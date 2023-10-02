codeunit 50101 SquashJnlManagement
{
    Permissions = TableData "Squash Journal Template" = imd,
                  TableData "Squash Journal Batch" = imd;

    var
        Text000: Label 'SQUASH';
        Text001: Label 'Squash Journals';
        Text002: Label 'RECURRING';
        Text003: Label 'Recurring Squash Journal';
        Text004: Label 'DEFAULT';
        Text005: Label 'Default Journal';
        OpenFromBatch: Boolean;
        SquashJnlBatchEmptyErr: Label 'The Squash Journal batch job is empty.';

    procedure TemplateSelection(PageID: Integer; RecurringJnl: Boolean;
                                var SquashJnlLine: Record "Squash Journal Line";
                                var JnlSelected: Boolean)
    var
        SquashJnlTemplate: Record "Squash Journal Template";
    begin
        JnlSelected := true;

        SquashJnlTemplate.Reset();
        SquashJnlTemplate.SetRange("Page ID", PageID);
        SquashJnlTemplate.SetRange(Recurring, RecurringJnl);

        case SquashJnlTemplate.Count of
            0:
                begin
                    SquashJnlTemplate.Init();
                    SquashJnlTemplate.Recurring := RecurringJnl;
                    if not RecurringJnl then begin
                        SquashJnlTemplate.Name := Text000;
                        SquashJnlTemplate.Description := Text001;
                    end else begin
                        SquashJnlTemplate.Name := Text002;
                        SquashJnlTemplate.Description := Text003;
                    end;
                    SquashJnlTemplate.Validate("Page ID");
                    SquashJnlTemplate.Insert();
                    Commit();
                end;
            1:
                SquashJnlTemplate.FindFirst();
            else
                JnlSelected := PAGE.RunModal(0, SquashJnlTemplate) = ACTION::LookupOK;
        end;
        if JnlSelected then begin
            SquashJnlLine.FilterGroup := 2;
            SquashJnlLine.SetRange("Journal Template Name", SquashJnlTemplate.Name);
            SquashJnlLine.FilterGroup := 0;
            if OpenFromBatch then begin
                SquashJnlLine."Journal Template Name" := '';
                PAGE.Run(SquashJnlTemplate."Page ID", SquashJnlLine);
            end;
        end;
    end;

    procedure TemplateSelectionFromBatch(var SquashJnlBatch: Record "Squash Journal Batch")
    var
        SquashJnlLine: Record "Squash Journal Line";
        SquashJnlTemplate: Record "Squash Journal Template";
    begin
        OpenFromBatch := true;
        SquashJnlTemplate.Get(SquashJnlBatch."Journal Template Name");
        SquashJnlTemplate.TestField("Page ID");
        SquashJnlBatch.TestField(Name);

        SquashJnlLine.FilterGroup := 2;
        SquashJnlLine.SetRange("Journal Template Name", SquashJnlTemplate.Name);
        SquashJnlLine.FilterGroup := 0;

        SquashJnlLine."Journal Template Name" := '';
        SquashJnlLine."Journal Batch Name" := SquashJnlBatch.Name;
        PAGE.Run(SquashJnlTemplate."Page ID", SquashJnlLine);
    end;

    procedure OpenJnl(var CurrentJnlBatchName: Code[10]; var SquashJnlLine: Record "Squash Journal Line")
    begin
        CheckTemplateName(SquashJnlLine.GetRangeMax("Journal Template Name"), CurrentJnlBatchName);
        SquashJnlLine.FilterGroup := 2;
        SquashJnlLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
        SquashJnlLine.FilterGroup := 0;
    end;

    procedure OpenJnlBatch(var SquashJnlBatch: Record "Squash Journal Batch")
    var
        SquashJnlTemplate: Record "Squash Journal Template";
        SquashJnlLine: Record "Squash Journal Line";
        JnlSelected: Boolean;
    begin
        if SquashJnlBatch.GetFilter("Journal Template Name") <> '' then
            exit;
        SquashJnlBatch.FilterGroup(2);
        if SquashJnlBatch.GetFilter("Journal Template Name") <> '' then begin
            SquashJnlBatch.FilterGroup(0);
            exit;
        end;
        SquashJnlBatch.FilterGroup(0);

        if not SquashJnlBatch.Find('-') then begin
            if not SquashJnlTemplate.FindFirst() then
                TemplateSelection(0, false, SquashJnlLine, JnlSelected);
            if SquashJnlTemplate.FindFirst() then
                CheckTemplateName(SquashJnlTemplate.Name, SquashJnlBatch.Name);
            SquashJnlTemplate.SetRange(Recurring, true);
            if not SquashJnlTemplate.FindFirst() then
                TemplateSelection(0, true, SquashJnlLine, JnlSelected);
            if SquashJnlTemplate.FindFirst() then
                CheckTemplateName(SquashJnlTemplate.Name, SquashJnlBatch.Name);
            SquashJnlTemplate.SetRange(Recurring);
        end;
        if not SquashJnlBatch.Find('-') then
            Error(SquashJnlBatchEmptyErr);

        JnlSelected := true;
        SquashJnlBatch.CalcFields(Recurring);
        SquashJnlTemplate.SetRange(Recurring, SquashJnlBatch.Recurring);
        if SquashJnlBatch.GetFilter("Journal Template Name") <> '' then
            SquashJnlTemplate.SetRange(Name, SquashJnlBatch.GetFilter("Journal Template Name"));
        case SquashJnlTemplate.Count of
            1:
                SquashJnlTemplate.FindFirst();
            else
                JnlSelected := PAGE.RunModal(0, SquashJnlTemplate) = ACTION::LookupOK;
        end;
        if not JnlSelected then
            Error('');

        SquashJnlBatch.FilterGroup(0);
        SquashJnlBatch.SetRange("Journal Template Name", SquashJnlTemplate.Name);
        SquashJnlBatch.FilterGroup(2);
    end;

    local procedure CheckTemplateName(CurrentJnlTemplateName: Code[10]; var CurrentJnlBatchName: Code[10])
    var
        SquashJnlBatch: Record "Squash Journal Batch";
    begin
        SquashJnlBatch.SetRange("Journal Template Name", CurrentJnlTemplateName);
        if not SquashJnlBatch.Get(CurrentJnlTemplateName, CurrentJnlBatchName) then begin
            if not SquashJnlBatch.FindFirst() then begin
                SquashJnlBatch.Init();
                SquashJnlBatch."Journal Template Name" := CurrentJnlTemplateName;
                SquashJnlBatch.SetupNewBatch();
                SquashJnlBatch.Name := Text004;
                SquashJnlBatch.Description := Text005;
                SquashJnlBatch.Insert(true);
                Commit();
            end;
            CurrentJnlBatchName := SquashJnlBatch.Name;
        end;
    end;

    procedure CheckName(CurrentJnlBatchName: Code[10]; var SquashJnlLine: Record "Squash Journal Line")
    var
        SquashJnlBatch: Record "Squash Journal Batch";
    begin
        SquashJnlBatch.Get(SquashJnlLine.GetRangeMax("Journal Template Name"), CurrentJnlBatchName);
    end;

    procedure SetName(CurrentJnlBatchName: Code[10]; var SquashJnlLine: Record "Squash Journal Line")
    begin
        SquashJnlLine.FilterGroup := 2;
        SquashJnlLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
        SquashJnlLine.FilterGroup := 0;
        if SquashJnlLine.Find('-') then;
    end;

    procedure LookupName(var CurrentJnlBatchName: Code[10]; var SquashJnlLine: Record "Squash Journal Line")
    var
        SquashJnlBatch: Record "Squash Journal Batch";
    begin
        Commit();
        SquashJnlBatch."Journal Template Name" := SquashJnlLine.GetRangeMax("Journal Template Name");
        SquashJnlBatch.Name := SquashJnlLine.GetRangeMax("Journal Batch Name");
        SquashJnlBatch.FilterGroup(2);
        SquashJnlBatch.SetRange("Journal Template Name", SquashJnlBatch."Journal Template Name");
        SquashJnlBatch.FilterGroup(0);
        if PAGE.RunModal(0, SquashJnlBatch) = ACTION::LookupOK then begin
            CurrentJnlBatchName := SquashJnlBatch.Name;
            SetName(CurrentJnlBatchName, SquashJnlLine);
        end;
    end;
}