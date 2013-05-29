@isTest
private class Tests
{
    private static testMethod void myUnitTest()
    {
        Test.startTest();

        System.runAs( testUser )
        {
            doTheTest();
        }

        Test.stopTest();

        System.assertEquals( true, false, 'The test is a test' );
    }
}
