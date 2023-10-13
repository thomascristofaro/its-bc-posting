codeunit 50100 "Squash Management"
{
    procedure UpdateSquashPlayer(Contact: Record Contact; ContBusRel: Record "Contact Business Relation")
    var
        SquashPlayer: Record "Squash Player";
        NoSeries: Code[20];
    begin
        SquashPlayer.Get(ContBusRel."No.");
        NoSeries := SquashPlayer."No. Series";
        SquashPlayer.TransferFields(Contact);
        SquashPlayer."No." := ContBusRel."No.";
        SquashPlayer."No. Series" := NoSeries;
        SquashPlayer.Modify();
    end;

    procedure CreateInvoice()
    var
        SquashLedEntry: Record "Squash Ledger Entry";
        SalesHeader: Record "Sales Header";
        prevCustomer: Code[20];
        LineNo: Integer;
    begin
        // Cercare le squash ledger entry da fatturare
        SquashLedEntry.SetCurrentKey(Open, "Entry Type", "Bill-to Customer No.", "Reservation Date");
        SquashLedEntry.SetRange("Entry Type", SquashLedEntry."Entry Type"::Reservation);
        SquashLedEntry.SetRange(Open, true);
        SquashLedEntry.SetRange(Chargeable, true);
        if SquashLedEntry.FindSet() then
            repeat
                if SquashLedEntry."Bill-to Customer No." <> prevCustomer then begin
                    // creare la sales header
                    CreateSalesHeader(SquashLedEntry."Bill-to Customer No.", SalesHeader);
                    prevCustomer := SquashLedEntry."Bill-to Customer No.";
                    LineNo := 10000;
                end;
                // creare la sales line
                CreateSalesLine(SalesHeader, SquashLedEntry, LineNo);
                LineNo += 10000;
            until SquashLedEntry.Next() = 0;
    end;

    local procedure CreateSalesHeader(Customer: Code[20];
                                var SalesHeader: Record "Sales Header")
    begin
        Clear(SalesHeader);
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader.Validate("Sell-to Customer No.", Customer);
        SalesHeader.Insert(true);
    end;

    local procedure CreateSalesLine(SalesHeader: Record "Sales Header";
                                SquashLedEntry: Record "Squash Ledger Entry";
                                LineNo: Integer)
    var
        SalesLine: Record "Sales Line";
        GenPstSetup: Record "General Posting Setup";
    begin
        GenPstSetup.Get(SquashLedEntry."Gen. Bus. Posting Group", SquashLedEntry."Gen. Prod. Posting Group");
        GenPstSetup.TestField("Sales Account");

        SalesLine.Init();
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := LineNo;

        SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
        SalesLine.Validate("No.", GenPstSetup."Sales Account");

        SalesLine.Description := SquashLedEntry.Description;
        SalesLine.Validate(Quantity, SquashLedEntry.Quantity);
        SalesLine.Validate("Unit Price", SquashLedEntry."Unit Price");
        SalesLine.Validate("Unit Cost", SquashLedEntry."Unit Cost");

        SalesLine."Applies-to Squash Entry No." := SquashLedEntry."Entry No.";
        SalesLine.Insert(true);
    end;
}