tableextension 50102 TE50102 extends Contact
{
    procedure CreateSquashPlayer(): Code[20];
    var
        SquashPlayer: Record "Squash Player";
        SquashPlayerNo: Code[20];
        ContBusRel: Record "Contact Business Relation";
    begin
        CheckContactType(Type::Person);
        CheckIfPrivacyBlockedGeneric();

        // Inserimento SquashPlayer
        SquashPlayer.Init();
        SquashPlayer.Insert(true);
        SquashPlayerNo := SquashPlayer."No.";

        // Creazione collegamento Contact - Squash Player
        ContBusRel.CreateRelation("No.", SquashPlayer."No.",
                ContBusRel."Link to Table"::"Squash Player");


    end;
}