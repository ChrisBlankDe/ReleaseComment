tableextension 50100 PTESalesHeaderExt extends "Sales Header"
{
    fields
    {
        field(50100; PTEReleaseComment; Text[50])
        {
            Caption = 'Release Comment';
            DataClassification = CustomerContent;
        }
    }
}