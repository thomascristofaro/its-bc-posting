table 50100 "Squash Setup"
{
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Squash Player Nos."; Code[10])
        {
            Caption = 'Squash Player Nos.';
            TableRelation = "No. Series";
        }
        field(3; "Squash Court Nos."; Code[10])
        {
            Caption = 'Squash Court Nos.';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
}