@isTest
public with sharing class GlobalUtilsTest {

    @TestSetup
    private static void makeData(){
        Profile standardProfile = [Select Id From Profile Where Name = 'Standard User'];

        User u = new User(FirstName = 'Anthony',
                        LastName = 'Stark',
                        ProfileId = standardProfile.Id,
                        Alias = 'astar',
                        Username = 'stark@industries.eu',
                        Email = 'stark@industries.eu',
                        TimeZoneSidKey = 'America/Los_Angeles',
                        languagelocalekey   = 'en_US',
                        localesidkey        = 'en_US',
                        emailencodingkey    = 'UTF-8'
                        );
        insert u;
    }

    @isTest
    private static void testGetGlobalDescribe() {
        Map<String, Schema.SObjectType> result;
        User u = [Select Id, ProfileId from User Where LastName='Stark'];
        System.runAs(u) {
            Test.startTest();
                result = GlobalUtils.getGlobalDescribe();
            Test.stopTest();
        }
        System.assertNotEquals(null, result, 'The Global Describe should not be null');
    }

    @isTest
    private static void testGetSObjectDescribe() {
        Schema.DescribeSObjectResult result;
        User u = [Select Id, ProfileId from User Where LastName='Stark'];
        System.runAs(u) {
            Test.startTest();
                result = GlobalUtils.getSObjectDescribe('Account');
            Test.stopTest();
        }
        System.assertNotEquals(null, result, 'The Account Describe should not be null');
        System.assertEquals(Schema.getGlobalDescribe().get('Account').getDescribe().getName(), result.getName(), 'The returned Account Describe is not valid');
    }

    @isTest
    private static void testGetFieldDescribe() {
        Schema.DescribeFieldResult result;
        User u = [Select Id, ProfileId from User Where LastName='Stark'];
        System.runAs(u) {
            Test.startTest();
                result = GlobalUtils.getFieldDescribe('Account', 'Name');
            Test.stopTest();
        }
        System.assertNotEquals(null, result, 'The Name Describe (in the Account SObject) should not be null');
        System.assertEquals(Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Name').getDescribe().getName(), result.getName(), 'The returned Name Describe (in the Account SObject) is not valid');
    }

    @isTest
    private static void testIsSObjectAccessible() {
        Boolean result;
        User u = [Select Id, ProfileId from User Where LastName='Stark'];
        System.runAs(u) {
            Test.startTest();
                result = GlobalUtils.isSObjectAccessible('Account');
            Test.stopTest();
        }
        System.assertEquals(true, result, 'The SObject should be accessible to the user');
    }

    @isTest
    private static void testIsFieldAccessible() {
        Boolean result;
        User u = [Select Id, ProfileId from User Where LastName='Stark'];
        System.runAs(u) {
            Test.startTest();
                result = GlobalUtils.isFieldAccessible('Account', 'Name');
            Test.stopTest();
        }
        System.assertEquals(true, result, 'The SObject should be accessible to the user');
    }

    @isTest
    private static void testGetSObjectPluralLabel() {
        String result;
        User u = [Select Id, ProfileId from User Where LastName='Stark'];
        System.runAs(u) {
            Test.startTest();
                result = GlobalUtils.getSObjectPluralLabel('Opportunity');
            Test.stopTest();
        }
        System.assertEquals('Opportunities', result, 'The SObject plural name should be "Opportunities"');
    }

    @isTest
    private static void testGetFieldLabel() {
        String result;
        User u = [Select Id, ProfileId from User Where LastName='Stark'];
        System.runAs(u) {
            Test.startTest();
                result = GlobalUtils.getFieldLabel('Opportunity', 'StageName');
            Test.stopTest();
        }
        System.assertEquals('Stage', result, 'The StageName field label should be "Stage"');
    }

    @isTest
    private static void testGetFieldType() {
        String resultText;
        String resultNumber;
        String resultUrl;
        String resultReference;
        User u = [Select Id, ProfileId from User Where LastName='Stark'];
        System.runAs(u) {
            Test.startTest();
                resultText = GlobalUtils.getFieldType('Account', 'AccountNumber');
                resultNumber = GlobalUtils.getFieldType('Account', 'NumberOfEmployees');
                resultUrl = GlobalUtils.getFieldType('Account', 'Website');
                resultReference = GlobalUtils.getFieldType('Opportunity', 'LastModifiedById');
            Test.stopTest();
        }
        System.assertEquals('text', resultText, 'The AccountNumber field type should be "text"');
        System.assertEquals('number', resultNumber, 'The NumberOfEmployees field type should be "number"');
        System.assertEquals('url', resultUrl, 'The Website field type should be "url"');
        System.assertEquals('reference', resultReference, 'The LastModifiedById field type should be "reference"');
    }

    @isTest
    private static void testGetFieldReferenceName() {
        String result;
        User u = [Select Id, ProfileId from User Where LastName='Stark'];
        System.runAs(u) {
            Test.startTest();
                result = GlobalUtils.getFieldReferenceName('Account', 'OwnerId');
            Test.stopTest();
        }
        System.assertEquals('Owner.Name', result, 'The field reference name should be "Owner.Name"');
    

    }
    @isTest
    private static void testGetFieldTypeAttributes() {
        Map<String, Object> resultReference;
        Map<String, Object> resultUrl;
        User u = [Select Id, ProfileId from User Where LastName='Stark'];
        System.runAs(u) {
            Test.startTest();
                resultReference = GlobalUtils.getFieldTypeAttributes('reference', 'Thanos');
                resultUrl = GlobalUtils.getFieldTypeAttributes('url', null);
            Test.stopTest();
        }
        System.assertEquals('Thanos', ((Map<String, String>) resultReference.get('label')).get('fieldName'), 'The reference field label should does not reference the correct value');
        System.assertEquals('Go to URL', (String) resultUrl.get('label'), 'The url field label should does not have the correct value');
    }
}