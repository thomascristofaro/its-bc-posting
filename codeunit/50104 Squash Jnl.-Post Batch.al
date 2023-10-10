codeunit 50104 "Squash Jnl.-Post Batch"
{
    Permissions = TableData "Squash Journal Batch" = imd;
    TableNo = "Squash Journal Line";

    trigger OnRun()
    begin
        SquashJnlLine.Copy(Rec);
        Code();
        Rec := SquashJnlLine;
    end;

    var
        AccountingPeriod: Record "Accounting Period";
        SquashJnlTemplate: Record "Squash Journal Template";
        SquashJnlBatch: Record "Squash Journal Batch";
        SquashJnlLine: Record "Squash Journal Line";
        SquashJnlLine2: Record "Squash Journal Line";
        SquashJnlLine3: Record "Squash Journal Line";
        SquashLedgEntry: Record "Squash Ledger Entry";
        SquashReg: Record "Squash Register";
        TempNoSeries: Record "No. Series" temporary;
        SquashJnlCheckLine: Codeunit "Squash Jnl.-Check Line";
        SquashJnlPostLine: Codeunit "Squash Jnl.-Post Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeriesMgt2: array[10] of Codeunit NoSeriesManagement;
        Window: Dialog;
        SquashRegNo: Integer;
        StartLineNo: Integer;
        LineCount: Integer;
        NoOfRecords: Integer;
        LastDocNo: Code[20];
        LastDocNo2: Code[20];
        LastPostedDocNo: Code[20];
        NoOfPostingNoSeries: Integer;
        PostingNoSeriesNo: Integer;

        Text001: Label 'Journal Batch Name    #1##########\\';
        Text002: Label 'Checking lines        #2######\';
        Text003: Label 'Posting lines         #3###### @4@@@@@@@@@@@@@\';
        Text004: Label 'Updating lines        #5###### @6@@@@@@@@@@@@@';
        Text005: Label 'Posting lines         #3###### @4@@@@@@@@@@@@@';
        Text006: Label 'A maximum of %1 posting number series can be used in each journal.';

    local procedure "Code"()
    var
        DummyDateFormula: DateFormula;
    begin
        SquashJnlLine.SetRange("Journal Template Name", SquashJnlLine."Journal Template Name");
        SquashJnlLine.SetRange("Journal Batch Name", SquashJnlLine."Journal Batch Name");
        SquashJnlLine.LockTable();

        SquashJnlTemplate.Get(SquashJnlLine."Journal Template Name");
        SquashJnlBatch.Get(SquashJnlLine."Journal Template Name", SquashJnlLine."Journal Batch Name");

        if SquashJnlTemplate.Recurring then begin
            SquashJnlLine.SetRange("Posting Date", 0D, WorkDate());
            SquashJnlLine.SetFilter("Expiration Date", '%1 | %2..', 0D, WorkDate());
        end;

        if not SquashJnlLine.Find('=><') then begin
            SquashJnlLine."Line No." := 0;
            Commit();
            exit;
        end;

        if SquashJnlTemplate.Recurring then
            Window.Open(
              Text001 +
              Text002 +
              Text003 +
              Text004)
        else
            Window.Open(
              Text001 +
              Text002 +
              Text005);
        Window.Update(1, SquashJnlLine."Journal Batch Name");

        // Check lines
        LineCount := 0;
        StartLineNo := SquashJnlLine."Line No.";
        repeat
            LineCount := LineCount + 1;
            Window.Update(2, LineCount);
            SquashJnlLine.TestField("Recurring Method", 0);
            SquashJnlLine.TestField("Recurring Frequency", DummyDateFormula);
            SquashJnlCheckLine.RunCheck(SquashJnlLine);
            if SquashJnlLine.Next() = 0 then
                SquashJnlLine.Find('-');
        until SquashJnlLine."Line No." = StartLineNo;
        NoOfRecords := LineCount;

        // Find next register no.
        SquashLedgEntry.LockTable();
        if SquashLedgEntry.FindLast() then;
        SquashReg.LockTable();
        if SquashReg.FindLast() and (SquashReg."To Entry No." = 0) then
            SquashRegNo := SquashReg."No."
        else
            SquashRegNo := SquashReg."No." + 1;

        // Post lines
        LineCount := 0;
        LastDocNo := '';
        LastDocNo2 := '';
        LastPostedDocNo := '';
        SquashJnlLine.Find('-');
        repeat
            LineCount := LineCount + 1;
            Window.Update(3, LineCount);
            Window.Update(4, Round(LineCount / NoOfRecords * 10000, 1));
            if not SquashJnlLine.EmptyLine() and
               (SquashJnlBatch."No. Series" <> '') and
               (SquashJnlLine."Document No." <> LastDocNo2)
            then
                SquashJnlLine.TestField("Document No.", NoSeriesMgt.GetNextNo(SquashJnlBatch."No. Series", SquashJnlLine."Posting Date", false));
            if not SquashJnlLine.EmptyLine() then
                LastDocNo2 := SquashJnlLine."Document No.";
            if SquashJnlLine."Posting No. Series" = '' then
                SquashJnlLine."Posting No. Series" := SquashJnlBatch."No. Series"
            else
                if not SquashJnlLine.EmptyLine() then
                    if SquashJnlLine."Document No." = LastDocNo then
                        SquashJnlLine."Document No." := LastPostedDocNo
                    else begin
                        if not TempNoSeries.Get(SquashJnlLine."Posting No. Series") then begin
                            NoOfPostingNoSeries := NoOfPostingNoSeries + 1;
                            if NoOfPostingNoSeries > ArrayLen(NoSeriesMgt2) then
                                Error(
                                  Text006,
                                  ArrayLen(NoSeriesMgt2));
                            TempNoSeries.Code := SquashJnlLine."Posting No. Series";
                            TempNoSeries.Description := Format(NoOfPostingNoSeries);
                            TempNoSeries.Insert();
                        end;
                        LastDocNo := SquashJnlLine."Document No.";
                        Evaluate(PostingNoSeriesNo, TempNoSeries.Description);
                        SquashJnlLine."Document No." := NoSeriesMgt2[PostingNoSeriesNo].GetNextNo(SquashJnlLine."Posting No. Series", SquashJnlLine."Posting Date", false);
                        LastPostedDocNo := SquashJnlLine."Document No.";
                    end;
            SquashJnlPostLine.RunWithCheck(SquashJnlLine);
        until SquashJnlLine.Next() = 0;

        // Copy register no. and current journal batch name to the Squash journal
        if not SquashReg.FindLast() or (SquashReg."No." <> SquashRegNo) then
            SquashRegNo := 0;

        SquashJnlLine.Init();
        SquashJnlLine."Line No." := SquashRegNo;

        // Update/delete lines
        if SquashRegNo <> 0 then begin
            // Not a recurring journal
            SquashJnlLine2.CopyFilters(SquashJnlLine);
            SquashJnlLine2.SetFilter("Squash Player No.", '<>%1', '');
            SquashJnlLine2.SetFilter("Squash Court No.", '<>%1', '');
            if SquashJnlLine2.Find('+') then; // Remember the last line
            SquashJnlLine3.Copy(SquashJnlLine);
            SquashJnlLine3.DeleteAll();
            SquashJnlLine3.Reset();
            SquashJnlLine3.SetRange("Journal Template Name", SquashJnlLine."Journal Template Name");
            SquashJnlLine3.SetRange("Journal Batch Name", SquashJnlLine."Journal Batch Name");
            if SquashJnlTemplate."Increment Batch Name" then
                if not SquashJnlLine3.FindLast() then
                    if IncStr(SquashJnlLine."Journal Batch Name") <> '' then begin
                        SquashJnlBatch.Delete();
                        SquashJnlBatch.Name := IncStr(SquashJnlLine."Journal Batch Name");
                        if SquashJnlBatch.Insert() then;
                        SquashJnlLine."Journal Batch Name" := SquashJnlBatch.Name;
                    end;

            SquashJnlLine3.SetRange("Journal Batch Name", SquashJnlLine."Journal Batch Name");
            if (SquashJnlBatch."No. Series" = '') and not SquashJnlLine3.FindLast() then begin
                SquashJnlLine3.Init();
                SquashJnlLine3."Journal Template Name" := SquashJnlLine."Journal Template Name";
                SquashJnlLine3."Journal Batch Name" := SquashJnlLine."Journal Batch Name";
                SquashJnlLine3."Line No." := 10000;
                SquashJnlLine3.Insert();
                SquashJnlLine3.SetUpNewLine(SquashJnlLine2);
                SquashJnlLine3.Modify();
            end;
        end;
        if SquashJnlBatch."No. Series" <> '' then
            NoSeriesMgt.SaveNoSeries();
        if TempNoSeries.Find('-') then
            repeat
                Evaluate(PostingNoSeriesNo, TempNoSeries.Description);
                NoSeriesMgt2[PostingNoSeriesNo].SaveNoSeries();
            until TempNoSeries.Next() = 0;

        Commit();
    end;
}