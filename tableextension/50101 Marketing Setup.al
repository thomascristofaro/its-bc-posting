tableextension 50101 TE5010 extends "Marketing Setup"
{
    fields
    {
        field(50100; "Bus. Rel. Code for Squash Pl."; Code[10])
        {
            Caption = 'Bus. Rel. Code for Squash Player';
            TableRelation = "Business Relation";
        }
    }
}