pageextension 50101 PE50101 extends "Contact Card"
{
    actions
    {
        addlast("Create as")
        {
            action(CreateSquashPlayer)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Squash Player';
                Image = Customer;
                ToolTip = 'Create the contact as a squash player.';

                trigger OnAction()
                begin
                    Rec.CreateSquashPlayer();
                end;
            }
        }
    }
}