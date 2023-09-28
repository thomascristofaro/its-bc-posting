page 50103 "Squash Court List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Squash Court";
    CardPageID = "Squash Court Card";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description of the contact. If the contact is a person, you can click the field to see the Description Details window.';
                }
                field("Search Description"; Rec."Search Description")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies an alternate Description that you can use to search for the record in question when you cannot remember the value in the Description field.';
                    Visible = false;
                }
            }
        }
    }
}