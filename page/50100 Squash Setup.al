page 50100 "Squash Setup"
{
    ApplicationArea = All;
    Caption = 'Squash Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Squash Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Squash Player Nos."; Rec."Squash Player Nos.")
                {
                    ApplicationArea = All;
                }
                field("Squash Court Nos."; Rec."Squash Court Nos.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}