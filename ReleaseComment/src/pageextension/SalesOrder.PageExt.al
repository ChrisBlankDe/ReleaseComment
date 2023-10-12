pageextension 50100 PTESalesOrder extends "Sales Order"
{
    layout
    {
        addbefore(Status)
        {
            field(PTEReleaseComment; Rec.PTEReleaseComment)
            {
                ToolTip = 'Comment to the release of the order';
                ApplicationArea = All;
            }
        }
    }
}
