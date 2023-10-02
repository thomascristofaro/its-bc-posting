codeunit 50101 SquashJnlManagement
{
    Permissions = TableData "Squash Journal Template" = imd,
                  TableData "Squash Journal Batch" = imd;

    var
        Text004: Label 'DEFAULT';
        Text005: Label 'Default Journal';

    procedure OpenJnl(var CurrentJnlBatchName: Code[10]; var SquashJnlLine: Record "Squash Journal Line")
    begin
        CheckTemplateName(SquashJnlLine.GetRangeMax("Journal Template Name"), CurrentJnlBatchName);
        SquashJnlLine.FilterGroup := 2;
        SquashJnlLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
        SquashJnlLine.FilterGroup := 0;
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