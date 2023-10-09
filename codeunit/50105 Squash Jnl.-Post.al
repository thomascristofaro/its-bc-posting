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
        SquashJnlLine: Record "Squash Journal Line";

    local procedure "Code"()
    begin
    end;
}