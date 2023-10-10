codeunit 50105 "Squash Jnl.-Post"
{
    TableNo = "Squash Journal Line";

    trigger OnRun()
    begin
        SquashJnlLine.Copy(Rec);
        Code();
        Rec.Copy(SquashJnlLine);
    end;

    var
        SquashJnlTemplate: Record "Squash Journal Template";
        SquashJnlLine: Record "Squash Journal Line";
        JournalErrorsMgt: Codeunit "Journal Errors Mgt.";
        TempJnlBatchName: Code[10];

        Text000: Label 'cannot be filtered when posting recurring journals';
        Text001: Label 'Do you want to post the journal lines?';
        Text003: Label 'The journal lines were successfully posted.';
        Text004: Label 'The journal lines were successfully posted. ';
        Text005: Label 'You are now in the %1 journal.';

    local procedure "Code"()
    begin
        SquashJnlTemplate.Get(SquashJnlLine."Journal Template Name");
        SquashJnlTemplate.TestField("Force Posting Report", false);
        if SquashJnlTemplate.Recurring and (SquashJnlLine.GetFilter("Posting Date") <> '') then
            SquashJnlLine.FieldError("Posting Date", Text000);

        if not Confirm(Text001) then
            exit;

        TempJnlBatchName := SquashJnlLine."Journal Batch Name";

        CODEUNIT.Run(CODEUNIT::"Squash Jnl.-Post Batch", SquashJnlLine);

        if SquashJnlLine."Line No." = 0 then
            Message(JournalErrorsMgt.GetNothingToPostErrorMsg())
        else
            if TempJnlBatchName = SquashJnlLine."Journal Batch Name" then
                Message(Text003)
            else
                Message(
                  Text004 +
                  Text005,
                  SquashJnlLine."Journal Batch Name");

        if not SquashJnlLine.Find('=><') or (TempJnlBatchName <> SquashJnlLine."Journal Batch Name") then begin
            SquashJnlLine.Reset();
            SquashJnlLine.FilterGroup(2);
            SquashJnlLine.SetRange("Journal Template Name", SquashJnlLine."Journal Template Name");
            SquashJnlLine.SetRange("Journal Batch Name", SquashJnlLine."Journal Batch Name");
            SquashJnlLine.FilterGroup(0);
            SquashJnlLine."Line No." := 1;
        end;
    end;
}