codeunit 50103 "Squash Jnl.-Post Line"
{
    Permissions = TableData "Squash Ledger Entry" = imd,
                  TableData "Squash Register" = imd;
    TableNo = "Squash Journal Line";

    trigger OnRun()
    begin
        RunWithCheck(Rec);
    end;

    var
        SquashJnlLine: Record "Squash Journal Line";

    procedure RunWithCheck(var SquashJnlLine2: Record "Squash Journal Line")
    begin
        SquashJnlLine.Copy(SquashJnlLine2);
        Code();
        SquashJnlLine2 := SquashJnlLine;
    end;

    local procedure "Code"()
    begin
    end;
}