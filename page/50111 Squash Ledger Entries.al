page 50111 "Squash Ledger Entries"
{
    ApplicationArea = All;
    Caption = 'Squash Ledger Entries';
    Editable = false;
    PageType = List;
    SourceTable = "Squash Ledger Entry";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the date when the entry was posted.';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the type of entry.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the document number on the Squash ledger entry.';
                }
                field("Squash Court No."; Rec."Squash Court No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the Squash.';
                }
                field("Squash Player No."; Rec."Squash Player No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the Squash group.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the description of the posted entry.';
                }
                field("From Time"; Rec."From Time")
                {
                    ApplicationArea = All;
                }
                field("To Time"; Rec."To Time")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of units of the item or Squash specified on the line.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies how each unit of the item or Squash is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or Squash card is inserted.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the cost of one unit of the item or Squash on the line.';
                    Visible = false;
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total cost of the posted entry.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the price of one unit of the item or Squash. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
                    Visible = false;
                }
                field("Total Price"; Rec."Total Price")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total price of the posted entry.';
                }
                field(Chargeable; Rec.Chargeable)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies if a Squash transaction is chargeable.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the ID of the user who posted the entry, to be used, for example, in the change log.';
                    Visible = false;

                    trigger OnDrillDown()
                    var
                        UserMgt: Codeunit "User Management";
                    begin
                        UserMgt.DisplayUserInformation(Rec."User ID");
                    end;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the source code that specifies where the entry was created.';
                    Visible = false;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';
                    Visible = false;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Applies-to Entry No."; Rec."Applies-to Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CreateInvoice)
            {
                Caption = 'Create Invoice';
                Image = Create;

                trigger OnAction()
                var
                    SquashMgmt: Codeunit "Squash Management";
                begin
                    SquashMgmt.CreateInvoice();
                end;
            }
        }
    }
}