
tableextension 50101 PTESalesHeaderArchiveExt extends "Sales Header Archive"
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
