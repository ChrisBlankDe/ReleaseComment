pageextension 50101 PTESalesOrderArchive extends "Sales Order Archive"
{
    layout
    {
        addbefore(Status)
        {
            field(PTEReleaseComment; Rec.PTEReleaseComment)
            {
                ApplicationArea = All;
            }

        }
    }
}