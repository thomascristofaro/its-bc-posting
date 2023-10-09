codeunit 50102 "Squash Jnl.-Check Line"
{
    TableNo = "Squash Journal Line";

    trigger OnRun()
    begin
        RunCheck(Rec);
    end;

    procedure RunCheck(var SquashJnlLine: Record "Squash Journal Line")
    begin
    end;
}