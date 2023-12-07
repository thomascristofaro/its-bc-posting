report 50100 "Squash Player"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = WordLayout;

    dataset
    {
        dataitem("Squash Player"; "Squash Player")
        {
            column(No_; "No.")
            {
                IncludeCaption = true;
            }
            column(Name; "Name")
            {
                IncludeCaption = true;
            }
            column(Fiscal_Code; "Fiscal Code")
            {
                IncludeCaption = true;
            }
            column(Member; Member)
            {
                IncludeCaption = true;
            }
            column(E_Mail; "E-Mail")
            {
                IncludeCaption = true;
            }

            trigger OnPreDataItem()
            begin
                if OnlyMembers then
                    "Squash Player".SetRange(Member, true);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(OnlyMembers; OnlyMembers)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    rendering
    {
        layout(WordLayout)
        {
            Type = Word;
            LayoutFile = 'report/50100 Squash Player.docx';
        }
    }

    labels
    {
        ReportTitle = 'Squash Player List';
        CompanyName = 'CRONUS Italia S.p.A.';
    }

    var
        OnlyMembers: Boolean;
}