tableextension 50100 TE50100 extends "Contact Business Relation"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF ("Link to Table" = CONST(Customer)) Customer
            ELSE
            IF ("Link to Table" = CONST(Vendor)) Vendor
            ELSE
            IF ("Link to Table" = CONST("Bank Account")) "Bank Account"
            else
            if ("Link to Table" = const(Employee)) Employee
            else
            if ("Link to Table" = const("Squash Player")) "Squash Player";
        }
    }
}