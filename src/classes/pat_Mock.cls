/**
 * Testing utilities to help create Mock data.
 * Note: these can only be called during tests.
 */
@isTest
public class pat_Mock {

  static {
    System.assert(Test.isRunningTest(), 'Mock class may only be used in tests');
  }

  // Default Values and Helpers
  public static String TEST_STRING = generateRandomString(16);
  // Based on org settings, you may need to change this to a state abbreviation
  public static String DEFAULT_STATE = 'Illinois';

  private static Id SYSADMIN_PROFILE_ID {
    get {
      if (null == SYSADMIN_PROFILE_ID) {
        SYSADMIN_PROFILE_ID = [
            SELECT Id FROM Profile WHERE Name = 'System Administrator'][0].Id;
      }
      return SYSADMIN_PROFILE_ID;
    }
    private set;
  }

  // Shorthand for most commonly used Objects
  // Accounts
  public static Account createAccount() {
    Account a = generateAccount();
    insert a;
    return a;
  }

  public static Account generateAccount() {
    return new Account(
        Name=TEST_STRING,
        BillingStreet='Test Street',
        BillingCity='Test City',
        BillingState=DEFAULT_STATE,
        BillingPostalCode='60193',
        BillingCountry='United States');
  }

  // Contacts
  public static Contact createContact(Id accountId) {
    Contact c = generateContact(accountId);
    insert c;
    return c;
  }

  public static Contact generateContact(Id accountId) {
    return new Contact(
        LastName=TEST_STRING,
        AccountId=accountId,
        MailingState=DEFAULT_STATE);
  }

  // Leads
  public static Lead createLead() {
    Lead l = generateLead();
    insert l;
    return l;
  }

  public static Lead generateLead() {
    return new Lead (
        FirstName=TEST_STRING,
        LastName=TEST_STRING,
        Company='Godot',
        LeadSource='Inbound',
        Email=generateRandomEmail());
  }

  // Users
  public static User createUser() {
    User u = generateUser();
    insert u;
    return u;
  }

  public static User generateUser() {
    String testString = generateRandomString(8);
    String testDomain = generateRandomString(8) + '.com';
    String testEmail = generateRandomEmail(testDomain);
    return new User(
        LastName=testString,
        Username=testEmail,
        ProfileId=SYSADMIN_PROFILE_ID,
        Alias=testString,
        Email=testEmail,
        EmailEncodingKey='ISO-8859-1',
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US',
        TimeZoneSidKey='America/Los_Angeles');
  }

  // TODO: Opportunity, OpportunityLineItem, OpportunityContactRole, Pricebook,
  //       PricebookEntry, Products, Task

  // Random Generator Helpers
  private static Set<String> priorRandoms;

  public static String generateRandomString() {
    return generateRandomString(null);
  }

  public static String generateRandomString(Integer length) {
    if (priorRandoms == null)
    priorRandoms = new Set<String>();

    if (length == null) length = 1+Math.round( Math.random() * 8 );
    String characters = 'abcdefghijklmnopqrstuvwxyz1234567890';
    String returnString = '';
    while(returnString.length() < length) {
      Integer charpos = Math.round( Math.random() * (characters.length()-1) );
      returnString += characters.substring( charpos , charpos+1 );
    }
    if (priorRandoms.contains(returnString)) {
      return generateRandomString(length);
    } else {
      priorRandoms.add(returnString);
      return returnString;
    }
  }

  public static String generateRandomEmail() {
    return generateRandomEmail(null);
  }

  public static String generateRandomEmail(String domain) {
    if (domain == null || domain == '')
    domain = generateRandomString() + '.com';
    return generateRandomString() + '@' + domain;
  }

  public static String generateRandomUrl() {
    return 'http://' + generateRandomString() + '.com';
  }

  @isTest
  private static void randomFunctionsTest() {
    System.assertNotEquals(null, generateRandomString());
    System.assertNotEquals(null, generateRandomEmail());
    System.assertNotEquals(null, generateRandomUrl());
  }
}
