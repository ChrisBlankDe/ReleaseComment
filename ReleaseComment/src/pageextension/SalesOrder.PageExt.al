pageextension 50100 PTESalesOrder extends "Sales Order"
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
