codeunit 50100 "Squash Management"
{
    procedure UpdateSquashPlayer(Contact: Record Contact; ContBusRel: Record "Contact Business Relation")
    var
        SquashPlayer: Record "Squash Player";
        NoSeries: Code[20];
    begin
        SquashPlayer.Get(ContBusRel."No.");
        NoSeries := SquashPlayer."No. Series";
        SquashPlayer.TransferFields(Contact);
        SquashPlayer."No." := ContBusRel."No.";
        SquashPlayer."No. Series" := NoSeries;
        SquashPlayer.Modify();
    end;
}