table 50102 "Squash Court"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            var
            begin
                if "No." <> xRec."No." then begin
                    SquashSetup.Get();
                    NoSeriesMgt.TestManual(SquashSetup."Squash Court Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Search Description"; Code[100])
        {
            Caption = 'Search Description';
        }
        field(107; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    var
        SquashSetup: Record "Squash Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SquashSetup.Get();
            SquashSetup.TestField("Squash Court Nos.");
            NoSeriesMgt.InitSeries(SquashSetup."Squash Court Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;
}