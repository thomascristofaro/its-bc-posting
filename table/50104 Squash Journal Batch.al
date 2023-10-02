table 50104 "Squash Journal Batch"
{
    Caption = 'Squash Journal Batch';
    DataCaptionFields = Name, Description;
    LookupPageID = "Squash Jnl. Batches";

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Squash Journal Template";
        }
        field(2; Name; Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(4; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";

            trigger OnValidate()
            begin
                if "Reason Code" <> xRec."Reason Code" then begin
                    SquashJnlLine.SetRange("Journal Template Name", "Journal Template Name");
                    SquashJnlLine.SetRange("Journal Batch Name", Name);
                    SquashJnlLine.ModifyAll("Reason Code", "Reason Code");
                    Modify();
                end;
            end;
        }
        field(5; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                if "No. Series" <> '' then begin
                    SquashJnlTemplate.Get("Journal Template Name");
                    if SquashJnlTemplate.Recurring then
                        Error(
                          Text000,
                          FieldCaption("Posting No. Series"));
                    if "No. Series" = "Posting No. Series" then
                        Validate("Posting No. Series", '');
                end;
            end;
        }
        field(6; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                if ("Posting No. Series" = "No. Series") and ("Posting No. Series" <> '') then
                    FieldError("Posting No. Series", StrSubstNo(Text001, "Posting No. Series"));
                SquashJnlLine.SetRange("Journal Template Name", "Journal Template Name");
                SquashJnlLine.SetRange("Journal Batch Name", Name);
                SquashJnlLine.ModifyAll("Posting No. Series", "Posting No. Series");
                Modify();
            end;
        }
        field(22; Recurring; Boolean)
        {
            CalcFormula = Lookup("Squash Journal Template".Recurring WHERE(Name = FIELD("Journal Template Name")));
            Caption = 'Recurring';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        SquashJnlLine.SetRange("Journal Template Name", "Journal Template Name");
        SquashJnlLine.SetRange("Journal Batch Name", Name);
        SquashJnlLine.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        LockTable();
        SquashJnlTemplate.Get("Journal Template Name");
    end;

    trigger OnRename()
    begin
        SquashJnlLine.SetRange("Journal Template Name", xRec."Journal Template Name");
        SquashJnlLine.SetRange("Journal Batch Name", xRec.Name);
        while SquashJnlLine.FindFirst() do
            SquashJnlLine.Rename("Journal Template Name", Name, SquashJnlLine."Line No.");
    end;

    var
        SquashJnlTemplate: Record "Squash Journal Template";
        SquashJnlLine: Record "Squash Journal Line";

        Text000: Label 'Only the %1 field can be filled in on recurring journals.';
        Text001: Label 'must not be %1';

    procedure SetupNewBatch()
    begin
        SquashJnlTemplate.Get("Journal Template Name");
        "No. Series" := SquashJnlTemplate."No. Series";
        "Posting No. Series" := SquashJnlTemplate."Posting No. Series";
        "Reason Code" := SquashJnlTemplate."Reason Code";
    end;
}
