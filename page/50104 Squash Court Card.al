page 50104 "Squash Court Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Squash Court";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Importance = Standard;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the Description of the contact. If the contact is a person, you can click the field to see the Description Details window.';
                }
                field("Search Description"; Rec."Search Description")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies an alternate Description that you can use to search for the record in question when you cannot remember the value in the Description field.';
                }

            }
        }
    }
}