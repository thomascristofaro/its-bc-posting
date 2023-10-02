tableextension 50103 TE50103 extends "Source Code Setup"
{
    fields
    {
        field(50100; "Squash Journal"; Code[10])
        {
            Caption = 'Squash Journal';
            TableRelation = "Source Code";
        }
    }
}