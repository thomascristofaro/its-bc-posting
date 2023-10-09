page 50102 "Squash Player Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Squash Player";

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
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the name of the contact. If the contact is a person, you can click the field to see the Name Details window.';
                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies an additional part of the name.';
                    Visible = false;
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the salesperson who normally handles this contact.';
                }
                field(Member; Rec.Member)
                {
                    ApplicationArea = All;
                }
                field("Bill-To Customer No."; Rec."Bill-To Customer No.")
                {
                    ApplicationArea = All;
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                group(Control37)
                {
                    Caption = 'Address';
                    field(Address; Rec.Address)
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the contact''s address.';
                    }
                    field("Address 2"; Rec."Address 2")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field("Country/Region Code"; Rec."Country/Region Code")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the country/region of the address.';
                    }
                    field("Post Code"; Rec."Post Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Promoted;
                        ToolTip = 'Specifies the postal code.';
                    }
                    field(City; Rec.City)
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the city where the contact is located.';
                    }
                }
                group(ContactDetails)
                {
                    Caption = 'Contact';
                    field("Phone No."; Rec."Phone No.")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the contact''s phone number.';
                    }
                    field("E-Mail"; Rec."E-Mail")
                    {
                        ApplicationArea = Basic, Suite;
                        ExtendedDatatype = EMail;
                        Importance = Promoted;
                        ToolTip = 'Specifies the email address of the contact.';
                    }
                    field("Home Page"; Rec."Home Page")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the contact''s web site.';
                    }
                    field("Language Code"; Rec."Language Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Promoted;
                        ToolTip = 'Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.';
                    }
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the currency code for the contact.';
                }
                field("Territory Code"; Rec."Territory Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    Importance = Additional;
                    ToolTip = 'Specifies the territory code for the contact.';
                }
                field("Fiscal Code"; Rec."Fiscal Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the fiscal identification code that is assigned by the government to interact with state and public offices and tax authorities.';
                }
            }
        }
    }
}