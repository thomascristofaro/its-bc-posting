table 50105 "Squash Journal Line"
{
    Caption = 'Squash Journal Line';

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Squash Journal Template";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        // field(3; "Entry Type"; Enum "Res. Journal Line Entry Type")
        // {
        //     Caption = 'Entry Type';
        // }
        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            begin
                TestField("Posting Date");
                Validate("Document Date", "Posting Date");
            end;
        }
        // 6 7 Squash Player/Court No
        field(8; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(11; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure".Code;// WHERE("Resource No." = FIELD("Resource No."));
        }
        field(12; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                Validate("Unit Cost");
                Validate("Unit Price");
            end;
        }
        field(13; "Direct Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
            MinValue = 0;
        }
        field(14; "Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            MinValue = 0;

            trigger OnValidate()
            begin
                "Total Cost" := Quantity * "Unit Cost";
            end;
        }
        field(15; "Total Cost"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Cost';

            trigger OnValidate()
            begin
                TestField(Quantity);
                "Unit Cost" := Round("Total Cost" / Quantity, 0.01);
            end;
        }
        field(16; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;

            trigger OnValidate()
            begin
                "Total Price" := Quantity * "Unit Price";
            end;
        }
        field(17; "Total Price"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Price';

            trigger OnValidate()
            begin
                TestField(Quantity);
                "Unit Price" := Round("Total Price" / Quantity, 0.01);
            end;
        }
        field(21; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            Editable = false;
            TableRelation = "Source Code";
        }
        field(23; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Res. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
        }
        field(24; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(25; "Recurring Method"; Option)
        {
            BlankZero = true;
            Caption = 'Recurring Method';
            OptionCaption = ',Fixed,Variable';
            OptionMembers = ,"Fixed",Variable;
        }
        field(26; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(27; "Recurring Frequency"; DateFormula)
        {
            Caption = 'Recurring Frequency';
        }
        field(28; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(29; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(30; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(31; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(32; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        // 34 customer
        field(35; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
        }
        field(959; "System-Created Entry"; Boolean)
        {
            Caption = 'System-Created Entry';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        LockTable();
        SquashJnlTemplate.Get("Journal Template Name");
        SquashJnlBatch.Get("Journal Template Name", "Journal Batch Name");
    end;

    var
        SquashJnlTemplate: Record "Squash Journal Template";
        SquashJnlBatch: Record "Squash Journal Batch";
        SquashJnlLine: Record "Squash Journal Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    procedure SetUpNewLine(LastSquashJnlLine: Record "Squash Journal Line")
    begin
        SquashJnlTemplate.Get("Journal Template Name");
        SquashJnlBatch.Get("Journal Template Name", "Journal Batch Name");
        SquashJnlLine.SetRange("Journal Template Name", "Journal Template Name");
        SquashJnlLine.SetRange("Journal Batch Name", "Journal Batch Name");
        if SquashJnlLine.FindFirst() then begin
            "Posting Date" := LastSquashJnlLine."Posting Date";
            "Document Date" := LastSquashJnlLine."Posting Date";
            "Document No." := LastSquashJnlLine."Document No.";
        end else begin
            "Posting Date" := WorkDate();
            "Document Date" := WorkDate();
            if SquashJnlBatch."No. Series" <> '' then begin
                Clear(NoSeriesMgt);
                "Document No." := NoSeriesMgt.TryGetNextNo(SquashJnlBatch."No. Series", "Posting Date");
            end;
        end;
        "Recurring Method" := LastSquashJnlLine."Recurring Method";
        "Source Code" := SquashJnlTemplate."Source Code";
        "Reason Code" := SquashJnlBatch."Reason Code";
        "Posting No. Series" := SquashJnlBatch."Posting No. Series";
    end;

}