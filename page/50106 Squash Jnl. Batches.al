page 50106 "Squash Jnl. Batches"
{
    Caption = 'Squash Jnl. Batches';
    DataCaptionExpression = DataCaption();
    PageType = List;
    SourceTable = "Squash Journal Batch";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of this squash journal.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of this batch.';
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series from which entry or record numbers are assigned to new entries or records.';
                }
                field("Posting No. Series"; Rec."Posting No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series code used to assign document numbers to ledger entries that are posted from this journal batch.';
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';
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
        area(processing)
        {
            action("Edit Journal")
            {
                ApplicationArea = All;
                Caption = 'Edit Journal';
                Image = OpenJournal;
                ShortCutKey = 'Return';
                ToolTip = 'Open a journal based on the journal batch.';

                trigger OnAction()
                begin
                    SquashJnlMgt.TemplateSelectionFromBatch(Rec);
                end;
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action("P&ost")
                {
                    ApplicationArea = All;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    // RunObject = Codeunit "Squash Jnl.-B.Post";
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref("Edit Journal_Promoted"; "Edit Journal")
                {
                }
                actionref("P&ost_Promoted"; "P&ost")
                {
                }
            }
        }
    }

    trigger OnInit()
    begin
        Rec.SetRange("Journal Template Name");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetupNewBatch();
    end;

    trigger OnOpenPage()
    begin
        SquashJnlMgt.OpenJnlBatch(Rec);
    end;

    var
        SquashJnlMgt: Codeunit SquashJnlManagement;

    local procedure DataCaption(): Text[250]
    var
        SquashJnlTemplate: Record "Squash Journal Template";
    begin
        if not CurrPage.LookupMode then
            if Rec.GetFilter("Journal Template Name") <> '' then
                if Rec.GetRangeMin("Journal Template Name") = Rec.GetRangeMax("Journal Template Name") then
                    if SquashJnlTemplate.Get(Rec.GetRangeMin("Journal Template Name")) then
                        exit(SquashJnlTemplate.Name + ' ' + SquashJnlTemplate.Description);
    end;
}

