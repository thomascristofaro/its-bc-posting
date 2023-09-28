pageextension 50100 PE50100 extends "Marketing Setup"
{
    layout
    {
        addlast("Bus. Relation Code for")
        {
            field("Bus. Rel. Code for Squash Pl."; Rec."Bus. Rel. Code for Squash Pl.")
            {
                ApplicationArea = All;
            }
        }
    }
}