codeunit 50111 PTEReleaseCommentTest
{
    Description = 'Description';
    Subtype = Test;



    trigger OnRun();
    begin
        IsInitialized := false;
    end;

    local procedure Initialize();
    begin
        LibraryTestInitialize.OnTestInitialize(Codeunit::PTEReleaseCommentTest);
        ClearLastError();
        LibraryVariableStorage.Clear();
        LibrarySetupStorage.Restore();
        if IsInitialized then
            exit;

        LibraryTestInitialize.OnBeforeTestSuiteInitialize(Codeunit::PTEReleaseCommentTest);

        LibraryRandom.Init();

        // CUSTOMIZATION: Prepare setup tables etc. that are used for all test functions


        IsInitialized := true;
        Commit();

        // CUSTOMIZATION: Add all setup tables that are changed by tests to the SetupStorage, so they can be restored for each test function that calls Initialize.
        // This is done InMemory, so it could be run after the COMMIT above
        //   LibrarySetupStorage.Save(DATABASE::"[SETUP TABLE ID]");

        LibraryTestInitialize.OnAfterTestSuiteInitialize(Codeunit::PTEReleaseCommentTest);
    end;

    [Test]
    procedure ReleaseWithComment()
    // [FEATURE] Feature Id / Description
    // [SCENARIO] Scenario Description
    var
        LibrarySales: Codeunit "Library - Sales";
        SalesHeader: Record "Sales Header";
    begin
        Initialize();
        // [GIVEN] Given
        LibrarySales.CreateSalesOrder(SalesHeader);
        SalesHeader.Validate(PTEReleaseComment, 'Any Comment');
        SalesHeader.Modify(true);
        // [WHEN] When
        LibrarySales.ReleaseSalesDocument(SalesHeader);
        // [THEN] Then
    end;

    [Test]
    [HandlerFunctions('ExpectedConfirmHandler')]
    procedure ReleaseWithoutCommentAndConfirm()
    // [FEATURE] Feature Id / Description
    // [SCENARIO] Scenario Description
    var
        LibrarySales: Codeunit "Library - Sales";
        SalesHeader: Record "Sales Header";
    begin
        Initialize();
        // [GIVEN] Given
        LibrarySales.CreateSalesOrder(SalesHeader);
        // SalesHeader.Validate(PTEReleaseComment, ''); // Do not set an comment
        SalesHeader.Modify(true);
        LibraryVariableStorage.Enqueue('Would you like to use a default value');
        LibraryVariableStorage.Enqueue(true); // or false, depending of the reply you want if below question is asked. Any other question will throw an error

        // [WHEN] When
        LibrarySales.ReleaseSalesDocument(SalesHeader);
        // [THEN] Then
        assert.AreNotEqual('', SalesHeader.PTEReleaseComment, '');
    end;

    [Test]
    [HandlerFunctions('ExpectedConfirmHandler')]
    procedure ReleaseWithoutCommentAndNotConfirm()
    // [FEATURE] Feature Id / Description
    // [SCENARIO] Scenario Description
    var
        LibrarySales: Codeunit "Library - Sales";
        SalesHeader: Record "Sales Header";
    begin
        Initialize();
        // [GIVEN] Given
        LibrarySales.CreateSalesOrder(SalesHeader);
        // SalesHeader.Validate(PTEReleaseComment, ''); // Do not set an comment
        SalesHeader.Modify(true);
        LibraryVariableStorage.Enqueue('Would you like to use a default value');
        LibraryVariableStorage.Enqueue(false); // or false, depending of the reply you want if below question is asked. Any other question will throw an error

        // [WHEN] When
        asserterror LibrarySales.ReleaseSalesDocument(SalesHeader);
        // [THEN] Then
        Assert.ExpectedErrorCode('Dialog');
        Assert.ExpectedError('');
    end;

    [Test]
    procedure ArchiveWithCommentTest()
    // [FEATURE] Feature Id / Description
    // [SCENARIO] Scenario Description
    var
        LibrarySales: Codeunit "Library - Sales";
        SalesHeader: Record "Sales Header";
        ArchiveManagement: Codeunit ArchiveManagement;
        SalesHeaderArchive: Record "Sales Header Archive";
    begin
        Initialize();
        // [GIVEN] Given
        LibrarySales.CreateSalesOrder(SalesHeader);
        SalesHeader.Validate(PTEReleaseComment, 'TEST COMMENT');                                                                  // [WHEN] When
        ArchiveManagement.ArchSalesDocumentNoConfirm(SalesHeader);

        // [THEN] Then
        SalesHeaderArchive.SetRange("Document Type", SalesHeader."Document Type");
        SalesHeaderArchive.SetRange("No.", SalesHeader."No.");
        SalesHeaderArchive.FindLast();
        Assert.AreEqual('TEST COMMENT', SalesHeaderArchive.PTEReleaseComment, '');

    end;


    [ConfirmHandler]
    procedure ExpectedConfirmHandler(Question: Text[1024]; var Reply: Boolean)
    // Call the following in the Test function
    //   LibraryVariableStorage.Enqueue('ExpectedConfirmText');
    //   LibraryVariableStorage.Enqueue(true); // or false, depending of the reply you want if below question is asked. Any other question will throw an error
    begin
        Assert.ExpectedMessage(LibraryVariableStorage.DequeueText(), Question);
        Reply := LibraryVariableStorage.DequeueBoolean();
    end;

    var
        Assert: Codeunit Assert;
        LibraryRandom: Codeunit "Library - Random";
        LibrarySetupStorage: Codeunit "Library - Setup Storage";
        LibraryTestInitialize: Codeunit "Library - Test Initialize";
        LibraryVariableStorage: Codeunit "Library - Variable Storage";
        IsInitialized: Boolean;
}