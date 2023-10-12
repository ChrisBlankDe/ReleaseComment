codeunit 50100 PTEReleaseComment
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnBeforeManualReleaseSalesDoc, '', false, false)]
    local procedure CheckReleaseComment(var SalesHeader: Record "Sales Header")
    var
        ConfirmManagement: Codeunit "Confirm Management";
        DefaulValueConcatTxt: Label '%1 %2', Comment = '%1=UserId; %2=CurrentDateTime', Locked = true;
        UseDefaultValueQst: Label 'No %1 defined. Would you like to use a default value?', Comment = '%1=FieldCaption(PTEReleaseComment)';
    begin
        if SalesHeader.PTEReleaseComment = '' then
            if ConfirmManagement.GetResponse(StrSubstNo(UseDefaultValueQst, SalesHeader.FieldCaption(PTEReleaseComment)), false) then
                SalesHeader.Validate(PTEReleaseComment, StrSubstNo(DefaulValueConcatTxt, UserId, CurrentDateTime))
            else
                Error('');
    end;
}