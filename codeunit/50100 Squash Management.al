codeunit 50100 "Squash Management"
{
    // trigger che può essere schedulato
    // nel nostro caso vogliamo lanciare la 
    // registrazione per le squash journal line
    trigger OnRun()
    var
        SquashJnlLine: Record "Squash Journal Line";
    begin
        SquashJnlLine.SetRange("Journal Template Name", 'SQUASH');
        SquashJnlLine.SetRange("Journal Batch Name", 'DEFAULT');
        if SquashJnlLine.FindFirst() then
            CODEUNIT.Run(CODEUNIT::"Squash Jnl.-Post Batch", SquashJnlLine);
    end;

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
        SalesLine.Validate("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");

        SalesLine.Description := SquashLedEntry.Description;
        SalesLine.Validate(Quantity, SquashLedEntry.Quantity);
        SalesLine.Validate("Unit Price", SquashLedEntry."Unit Price");
        SalesLine.Validate("Unit Cost", SquashLedEntry."Unit Cost");

        SalesLine."Applies-to Squash Entry No." := SquashLedEntry."Entry No.";
        SalesLine.Insert(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostSalesLineOnBeforePostSalesLine', '', false, false)]
    local procedure OnPostSalesLineOnBeforePostSalesLine(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; GenJnlLineDocNo: Code[20]; GenJnlLineExtDocNo: Code[35]; GenJnlLineDocType: Enum "Gen. Journal Document Type"; SrcCode: Code[10]; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var IsHandled: Boolean)
    begin
        if SalesLine."Applies-to Squash Entry No." <> 0 then
            PostSquashJnlLn(SalesLine);
    end;

    procedure PostSquashJnlLn(SalesLine: Record "Sales Line")
    var
        OldSquashLedEntry: Record "Squash Ledger Entry";
        SquashJnlLine: Record "Squash Journal Line";
        SquashPostLine: Codeunit "Squash Jnl.-Post Line";
    begin
        OldSquashLedEntry.Get(SalesLine."Applies-to Squash Entry No.");
        OldSquashLedEntry.TestField(Open);
        OldSquashLedEntry.TestField("Bill-to Customer No.", SalesLine."Bill-to Customer No.");


        SquashJnlLine."Entry Type" := SquashJnlLine."Entry Type"::Invoice;
        SquashJnlLine."Document No." := SalesLine."Document No.";
        SquashJnlLine."Posting Date" := WorkDate();
        SquashJnlLine.Quantity := OldSquashLedEntry.Quantity;
        SquashJnlLine.Chargeable := false;
        SquashJnlLine."Applies-to Entry No." := OldSquashLedEntry."Entry No.";

        SquashJnlLine."External Document No." := OldSquashLedEntry."External Document No.";
        SquashJnlLine."Reservation Date" := OldSquashLedEntry."Reservation Date";
        SquashJnlLine."Squash Court No." := OldSquashLedEntry."Squash Court No.";
        SquashJnlLine."Squash Player No." := OldSquashLedEntry."Squash Player No.";
        SquashJnlLine.Description := OldSquashLedEntry.Description;
        SquashJnlLine."From Time" := OldSquashLedEntry."From Time";
        SquashJnlLine."To Time" := OldSquashLedEntry."To Time";
        SquashJnlLine."Unit of Measure Code" := OldSquashLedEntry."Unit of Measure Code";
        SquashJnlLine."Unit Cost" := OldSquashLedEntry."Unit Cost";
        SquashJnlLine."Total Cost" := OldSquashLedEntry."Total Cost";
        SquashJnlLine."Unit Price" := OldSquashLedEntry."Unit Price";
        SquashJnlLine."Total Price" := OldSquashLedEntry."Total Price";
        SquashJnlLine."Source Code" := OldSquashLedEntry."Source Code";
        SquashJnlLine."Journal Batch Name" := OldSquashLedEntry."Journal Batch Name";
        SquashJnlLine."Reason Code" := OldSquashLedEntry."Reason Code";
        SquashJnlLine."Bill-to Customer No." := OldSquashLedEntry."Bill-to Customer No.";
        SquashJnlLine."Gen. Bus. Posting Group" := OldSquashLedEntry."Gen. Bus. Posting Group";
        SquashJnlLine."Gen. Prod. Posting Group" := OldSquashLedEntry."Gen. Prod. Posting Group";
        SquashJnlLine."Posting No. Series" := OldSquashLedEntry."No. Series";
        SquashJnlLine."Qty. per Unit of Measure" := OldSquashLedEntry."Qty. per Unit of Measure";

        SquashPostLine.RunWithCheck(SquashJnlLine);

        OldSquashLedEntry.Open := false;
        OldSquashLedEntry.Modify();
    end;
}