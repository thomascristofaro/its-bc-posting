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
                    SquashJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    SquashJnlManagement.CheckName(CurrentJnlBatchName, Rec);
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
                field("Reservation Date"; Rec."Reservation Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the date when the related document was created.';
                    Visible = false;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies an entry type for each line.';
                }
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
                field("Squash Player No."; Rec."Squash Player No.")
                {
                    ApplicationArea = All;
                }
                field("Squash Court No."; Rec."Squash Court No.")
                {
                    ApplicationArea = All;
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
                    ToolTip = 'Specifies the number of units of the item or resource specified on the line.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
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
                field(Chargeable; Rec.Chargeable)
                {
                    ApplicationArea = All;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
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
                        CODEUNIT.Run(CODEUNIT::"Squash Jnl.-Post", Rec);
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

    // trigger OnAfterGetCurrRecord()
    // begin
    //     ResJnlManagement.GetRes("Resource No.", ResName);
    // end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetUpNewLine(xRec);
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        if IsOpenedFromBatch() then begin
            CurrentJnlBatchName := Rec."Journal Batch Name";
            SquashJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
            exit;
        end;
        SquashJnlManagement.TemplateSelection(PAGE::"Squash Journal", false, Rec, JnlSelected);
        if not JnlSelected then
            Error('');
        SquashJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
    end;

    var
        SquashJnlManagement: Codeunit SquashJnlManagement;
        CurrentJnlBatchName: Code[10];

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord();
        SquashJnlManagement.SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;

    procedure IsOpenedFromBatch(): Boolean
    var
        SquashJournalBatch: Record "Squash Journal Batch";
        TemplateFilter: Text;
        BatchFilter: Text;
    begin
        BatchFilter := Rec.GetFilter("Journal Batch Name");
        if BatchFilter <> '' then begin
            TemplateFilter := Rec.GetFilter("Journal Template Name");
            if TemplateFilter <> '' then
                SquashJournalBatch.SetFilter("Journal Template Name", TemplateFilter);
            SquashJournalBatch.SetFilter(Name, BatchFilter);
            SquashJournalBatch.FindFirst();
        end;

        exit(((Rec."Journal Batch Name" <> '') and (Rec."Journal Template Name" = '')) or (BatchFilter <> ''));
    end;
}