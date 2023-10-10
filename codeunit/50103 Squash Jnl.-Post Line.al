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
        SquashLedgEntry: Record "Squash Ledger Entry";
        SquashCourt: Record "Squash Court";
        SquashPlayer: Record "Squash Player";
        SquashReg: Record "Squash Register";
        SquashJnlCheckLine: Codeunit "Squash Jnl.-Check Line";
        NextEntryNo: Integer;

    procedure RunWithCheck(var SquashJnlLine2: Record "Squash Journal Line")
    begin
        SquashJnlLine.Copy(SquashJnlLine2);
        Code();
        SquashJnlLine2 := SquashJnlLine;
    end;

    local procedure "Code"()
    begin
        if SquashJnlLine.EmptyLine() then
            exit;

        SquashJnlCheckLine.RunCheck(SquashJnlLine);

        if NextEntryNo = 0 then begin
            SquashLedgEntry.LockTable();
            NextEntryNo := SquashLedgEntry.GetLastEntryNo() + 1;
        end;

        if SquashJnlLine."Reservation Date" = 0D then
            SquashJnlLine."Reservation Date" := SquashJnlLine."Posting Date";

        if SquashReg."No." = 0 then begin
            SquashReg.LockTable();
            if (not SquashReg.FindLast()) or (SquashReg."To Entry No." <> 0) then begin
                SquashReg.Init();
                SquashReg."No." := SquashReg."No." + 1;
                SquashReg."From Entry No." := NextEntryNo;
                SquashReg."To Entry No." := NextEntryNo;
                SquashReg."Creation Date" := Today;
                SquashReg."Creation Time" := Time;
                SquashReg."Source Code" := SquashJnlLine."Source Code";
                SquashReg."Journal Batch Name" := SquashJnlLine."Journal Batch Name";
                SquashReg."User ID" := UserId;
                SquashReg.Insert();
            end;
        end;
        SquashReg."To Entry No." := NextEntryNo;
        SquashReg.Modify();

        SquashCourt.Get(SquashJnlLine."Squash Court No.");
        SquashPlayer.Get(SquashJnlLine."Squash Player No.");

        SquashLedgEntry.Init();
        SquashLedgEntry.CopyFromSquashJnlLine(SquashJnlLine);

        SquashLedgEntry."Total Cost" := Round(SquashLedgEntry."Total Cost");
        SquashLedgEntry."Total Price" := Round(SquashLedgEntry."Total Price");
        if SquashLedgEntry."Entry Type" = SquashLedgEntry."Entry Type"::Invoice then begin
            SquashLedgEntry.Quantity := -SquashLedgEntry.Quantity;
            SquashLedgEntry."Total Cost" := -SquashLedgEntry."Total Cost";
            SquashLedgEntry."Total Price" := -SquashLedgEntry."Total Price";
        end;
        SquashLedgEntry."User ID" := UserId;
        SquashLedgEntry."Entry No." := NextEntryNo;

        SquashLedgEntry.Insert(true);

        NextEntryNo := NextEntryNo + 1;
    end;
}