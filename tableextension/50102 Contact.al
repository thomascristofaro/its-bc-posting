tableextension 50102 TE50102 extends Contact
{
    procedure CreateSquashPlayer(): Code[20];
    var
        SquashPlayer: Record "Squash Player";
        SquashPlayerNo: Code[20];
        ContBusRel: Record "Contact Business Relation";
        SquashMgmt: Codeunit "Squash Management";
        RelatedRecordIsCreatedMsg: Label 'The %1 record has been created.';
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

        // Aggiorna lo squash player tramite un transferfield da contact
        SquashMgmt.UpdateSquashPlayer(Rec, ContBusRel);
        Commit();

        if not HideValidationDialog then
            Message(RelatedRecordIsCreatedMsg, SquashPlayer.TableCaption());
    end;
}