page 50112 "SquashPlayerAPI"
{
    PageType = API;
    Caption = 'squashPlayerAPI';
    APIPublisher = 'its';
    APIGroup = 'squash';
    APIVersion = 'v1.0';
    EntityName = 'squashplayer';
    EntitySetName = 'squashplayers';
    SourceTable = "Squash Player";
    DelayedInsert = true;
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(id; Rec.SystemId) { }
                field(no; Rec."No.") { }
                field(name; Rec.Name) { }
                field(member; Rec.Member) { }
            }
        }
    }
}