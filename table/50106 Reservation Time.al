table 50106 "Reservation Time"
{
    LookupPageId = "Reservation Time";
    DrillDownPageId = "Reservation Time";

    fields
    {
        field(1; "Reservation Time"; Time)
        {
            Caption = 'Reservation Time';
        }
        field(2; Duration; Decimal)
        {
            Caption = 'Duration';
        }
        field(3; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
    }

    keys
    {
        key(Key1; "Reservation Time")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}