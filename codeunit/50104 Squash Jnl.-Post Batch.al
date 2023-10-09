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
        SquashJnlLine: Record "Squash Journal Line";

    local procedure "Code"()
    begin
    end;
}