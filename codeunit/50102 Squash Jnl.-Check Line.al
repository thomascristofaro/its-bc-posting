codeunit 50102 "Squash Jnl.-Check Line"
{
    TableNo = "Squash Journal Line";

    trigger OnRun()
    begin
        RunCheck(Rec);
    end;

    var
        Text000: Label 'cannot be a closing date';

    procedure RunCheck(var SquashJnlLine: Record "Squash Journal Line")
    begin
        if SquashJnlLine.EmptyLine() then
            exit;

        SquashJnlLine.TestField("Squash Player No.", ErrorInfo.Create());
        SquashJnlLine.TestField("Squash Court No.", ErrorInfo.Create());
        SquashJnlLine.TestField("Posting Date", ErrorInfo.Create());
        SquashJnlLine.TestField("Gen. Prod. Posting Group", ErrorInfo.Create());
        SquashJnlLine.TestField("Reservation Date", ErrorInfo.Create());
        SquashJnlLine.TestField("From Time", ErrorInfo.Create());
        SquashJnlLine.TestField("To Time", ErrorInfo.Create());
        SquashJnlLine.TestField("Bill-to Customer No.", ErrorInfo.Create());

        if SquashJnlLine."Entry Type" = SquashJnlLine."Entry Type"::Invoice then
            SquashJnlLine.TestField("Applies-to Entry No.", ErrorInfo.Create());
        if SquashJnlLine."Applies-to Entry No." <> 0 then
            SquashJnlLine.TestField("Entry Type", SquashJnlLine."Entry Type"::Invoice, ErrorInfo.Create());

        if SquashJnlLine."Posting Date" <> NormalDate(SquashJnlLine."Posting Date") then
            SquashJnlLine.FieldError("Posting Date", ErrorInfo.Create(Text000, true));

        if SquashJnlLine."Reservation Date" <> 0D then
            if SquashJnlLine."Reservation Date" <> NormalDate(SquashJnlLine."Reservation Date") then
                SquashJnlLine.FieldError("Reservation Date", ErrorInfo.Create(Text000, true));
    end;

}