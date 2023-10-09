page 50109 "Reservation Time"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Reservation Time";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Reservation Time"; Rec."Reservation Time")
                {
                    ApplicationArea = All;
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}