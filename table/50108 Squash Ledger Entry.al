table 50108 "Squash Ledger Entry"
{
    Caption = 'Squash Ledger Entry';
    DrillDownPageID = "Squash Ledger Entries";
    LookupPageID = "Squash Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Entry Type"; Enum "Squash Journal Line Entry Type")
        {
            Caption = 'Entry Type';
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(5; "Squash Player No."; Code[20])
        {
            Caption = 'Squash No.';
            TableRelation = "Squash Player";
        }
        field(6; "Squash Court No."; Code[20])
        {
            Caption = 'Squash Court No.';
            TableRelation = "Squash Court";
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(8; "From Time"; Time)
        {
            Caption = 'From Time';
            TableRelation = "Reservation Time";
        }
        field(9; "To Time"; Time)
        {
            Caption = 'To Time';
            TableRelation = "Reservation Time";
        }
        field(10; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(11; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(12; "Direct Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
        }
        field(13; "Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
        }
        field(14; "Total Cost"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Cost';
        }
        field(15; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
        }
        field(16; "Total Price"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Price';
        }
        field(19; "Applies-to Entry No."; Integer)
        {
            Caption = 'Applies-to Entry No.';
        }
        field(20; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(21; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(22; Chargeable; Boolean)
        {
            Caption = 'Chargeable';
            InitValue = true;
        }
        field(23; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(24; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(25; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(26; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(27; "Reservation Date"; Date)
        {
            Caption = 'Reservation Date';
        }
        field(28; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(29; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(32; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
        }
        field(34; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Squash Court No.", "Posting Date")
        {
        }
        key(Key3; "Entry Type", Chargeable, "Unit of Measure Code", "Squash Court No.", "Posting Date")
        {
            SumIndexFields = Quantity, "Total Cost", "Total Price";
        }
        key(Key4; "Entry Type", Chargeable, "Unit of Measure Code", "Squash Player No.", "Posting Date")
        {
            SumIndexFields = Quantity, "Total Cost", "Total Price";
        }
        key(Key5; "Document No.", "Posting Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", Description, "Entry Type", "Document No.", "Posting Date")
        {
        }
    }

    var
        DimMgt: Codeunit DimensionManagement;

    procedure GetLastEntryNo(): Integer;
    var
        FindRecordManagement: Codeunit "Find Record Management";
    begin
        exit(FindRecordManagement.GetLastEntryIntFieldValue(Rec, FieldNo("Entry No.")))
    end;

    procedure CopyFromSquashJnlLine(SquashJnlLine: Record "Squash Journal Line")
    begin
        "Entry Type" := SquashJnlLine."Entry Type";
        "Document No." := SquashJnlLine."Document No.";
        "External Document No." := SquashJnlLine."External Document No.";
        "Posting Date" := SquashJnlLine."Posting Date";
        "Reservation Date" := SquashJnlLine."Reservation Date";
        "Squash Court No." := SquashJnlLine."Squash Court No.";
        "Squash Player No." := SquashJnlLine."Squash Player No.";
        Description := SquashJnlLine.Description;
        "From Time" := SquashJnlLine."From Time";
        "To Time" := SquashJnlLine."To Time";
        "Unit of Measure Code" := SquashJnlLine."Unit of Measure Code";
        Quantity := SquashJnlLine.Quantity;
        "Direct Unit Cost" := SquashJnlLine."Direct Unit Cost";
        "Unit Cost" := SquashJnlLine."Unit Cost";
        "Total Cost" := SquashJnlLine."Total Cost";
        "Unit Price" := SquashJnlLine."Unit Price";
        "Total Price" := SquashJnlLine."Total Price";
        "Source Code" := SquashJnlLine."Source Code";
        "Journal Batch Name" := SquashJnlLine."Journal Batch Name";
        "Reason Code" := SquashJnlLine."Reason Code";
        "Bill-to Customer No." := SquashJnlLine."Bill-to Customer No.";
        "Gen. Bus. Posting Group" := SquashJnlLine."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := SquashJnlLine."Gen. Prod. Posting Group";
        "No. Series" := SquashJnlLine."Posting No. Series";
        "Qty. per Unit of Measure" := SquashJnlLine."Qty. per Unit of Measure";
    end;
}

