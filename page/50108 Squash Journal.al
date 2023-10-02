page 50108 "Squash Journal"
{
    ApplicationArea = All;
    AutoSplitKey = true;
    Caption = 'Squash Journals';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Squash Journal Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                ApplicationArea = Jobs;
                Caption = 'Batch Name';
                Lookup = true;
                ToolTip = 'Specifies the name of the journal batch, a personalized journal layout, that the journal is based on.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord();
                    ResJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    SetControlAppearanceFromBatch();
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    ResJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali();
                end;
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the date when you want to assign.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the date when the related document was created.';
                    Visible = false;
                }
                // field("Entry Type"; Rec."Entry Type")
                // {
                //     ApplicationArea = Jobs;
                //     ToolTip = 'Specifies an entry type for each line.';
                // }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a document number for the journal line.';
                    ShowMandatory = true;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the description or name of the resource you chose in the Resource No. field.';
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.';
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of units of the item or resource specified on the line.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the cost of one unit of the selected item or resource.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the cost of one unit of the item or resource on the line.';
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total cost for this journal line.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
                }
                field("Total Price"; Rec."Total Price")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total price on the journal line.';
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';
                    Visible = false;
                }
            }
            group(FixedGroup)
            {
                ShowCaption = false;
                fixed(FixedControl)
                {
                    ShowCaption = false;
                    group("Player Name")
                    {
                        Caption = 'Player Name';
                        // field(ResName; ResName)
                        // {
                        //     ApplicationArea = Jobs;
                        //     Editable = false;
                        //     ShowCaption = false;
                        // }
                    }
                    group("Court Name")
                    {
                        Caption = 'Court Name';
                        // field(ResName; ResName)
                        // {
                        //     ApplicationArea = Jobs;
                        //     Editable = false;
                        //     ShowCaption = false;
                        // }
                    }
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Squash Player")
            {
                Caption = 'Squash Player';
                Image = Customer;
                action(Card)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Card';
                    Image = EditLines;
                    // RunObject = Page "Resource Card";
                    // RunPageLink = "No." = FIELD("Resource No.");
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Ledger E&ntries';
                    Image = Ledger;
                    // RunObject = Page "Resource Ledger Entries";
                    // RunPageLink = "Resource No." = FIELD("Resource No.");
                    // RunPageView = SORTING("Resource No.");
                }
            }
        }
        area(processing)
        {
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Post)
                {
                    ApplicationArea = Jobs;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction()
                    begin
                        // CODEUNIT.Run(CODEUNIT::"Squash Jnl.-Post", Rec);
                        CurrentJnlBatchName := Rec.GetRangeMax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
            // group("Page")
            // {
            //     Caption = 'Page';
            //     group(Errors)
            //     {
            //         Caption = 'Issues';
            //         Image = ErrorLog;
            //         Visible = BackgroundErrorCheck;
            //         action(ShowLinesWithErrors)
            //         {
            //             ApplicationArea = Basic, Suite;
            //             Caption = 'Show Lines with Issues';
            //             Image = Error;
            //             Visible = BackgroundErrorCheck;
            //             Enabled = not ShowAllLinesEnabled;
            //             ToolTip = 'View a list of journal lines that have issues before you post the journal.';

            //             trigger OnAction()
            //             begin
            //                 SwitchLinesWithErrorsFilter(ShowAllLinesEnabled);
            //             end;
            //         }
            //         action(ShowAllLines)
            //         {
            //             ApplicationArea = Basic, Suite;
            //             Caption = 'Show All Lines';
            //             Image = ExpandAll;
            //             Visible = BackgroundErrorCheck;
            //             Enabled = ShowAllLinesEnabled;
            //             ToolTip = 'View all journal lines, including lines with and without issues.';

            //             trigger OnAction()
            //             begin
            //                 SwitchLinesWithErrorsFilter(ShowAllLinesEnabled);
            //             end;
            //         }
            //     }
            // }
        }
    }

    var
        ResJnlManagement: Codeunit ResJnlManagement;
        CurrentJnlBatchName: Code[10];
}