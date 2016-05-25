@isTest
public class Mock {

  static {
    System.assert(
      Test.isRunningTest(),
      'You must call these from test methods');
  }

  public static Date TEST_DATE = System.today();
  public static String TEST_STRING = generateRandomString(16);

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
        BillingState='IL',
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
        MailingState='IL');
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

  // Opportunity
  public static Opportunity createOpportunity(Id accountId) {
    Opportunity o = generateOpportunity(accountId);
    insert o;
    return o;
  }

  public static Opportunity generateOpportunity(Id accountId) {
    Contact conObj = generateContact(accountId);
    insert conObj;
    return new Opportunity(
        AccountId=accountId,
        CloseDate=TEST_DATE,
        Name=TEST_STRING,
        StageName=TEST_STRING);
  }

  // Tasks
  public static Task createTask() {
    Task t = generateTask();
    insert t;
    return t;
  }

  public static Task generateTask() {
    return new Task();
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

  public static Id SYSADMIN_PROFILE_ID {
    get {
      if (null == SYSADMIN_PROFILE_ID) {
        SYSADMIN_PROFILE_ID = [
            SELECT Id FROM Profile WHERE Name = 'System Administrator'][0].Id;
      }
      return SYSADMIN_PROFILE_ID;
    }
    private set;
  }

  // Opportunity Lose
  public static Opportunity closeLoseOpportunity(Opportunity opportunity) {
    opportunity.StageName = OPPTY_CLOSED_LOST_STAGE;
    return opportunity;
  }

  // Opportunity Win
  public static Opportunity closeWinOpportunity(Opportunity opportunity) {
    opportunity.StageName = OPPTY_CLOSED_WON_STAGE;
    return opportunity;
  }

  public static String OPPTY_CLOSED_LOST_STAGE {
    get {
      if (null == OPPTY_CLOSED_LOST_STAGE) {
        OpportunityStage opptyStage = [
            SELECT MasterLabel
            FROM OpportunityStage
            WHERE IsWon = FALSE
            AND IsClosed = TRUE
            LIMIT 1];
        OPPTY_CLOSED_LOST_STAGE = opptyStage.MasterLabel;
      }
      return OPPTY_CLOSED_LOST_STAGE;
    }
    private set;
  }

  public static String OPPTY_CLOSED_WON_STAGE
  {
    get {
      if (null == OPPTY_CLOSED_WON_STAGE) {
        OpportunityStage opptyStage = [
            SELECT MasterLabel
            FROM OpportunityStage
            WHERE IsWon = TRUE
            LIMIT 1];
        OPPTY_CLOSED_WON_STAGE = opptyStage.MasterLabel;
      }
      return OPPTY_CLOSED_WON_STAGE;
    }
    private set;
  }

  // TODO: OpportunityLineItem, OpportunityContactRole, Pricebook,
  //       PricebookEntry, Products

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
  private static void testCloseWinOpportunity() {
    Opportunity testOppty = createOpportunity(createAccount().Id);
    closeWinOpportunity(testOppty);
    update testOppty;
    testOppty = [SELECT IsWon FROM Opportunity WHERE Id = :testOppty.Id];
    System.assertEquals(TRUE, testOppty.IsWon);
  }

  @isTest
  private static void testCloseLoseOpportunity() {
    Opportunity testOppty = createOpportunity(createAccount().Id);
    closeLoseOpportunity(testOppty);
    update testOppty;
    testOppty = [SELECT IsClosed, IsWon
                 FROM Opportunity
                 WHERE Id = :testOppty.Id];
    system.assertEquals(TRUE, testOppty.IsClosed);
    system.assertEquals(FALSE, testOppty.IsWon);
  }

  @isTest
  private static void randomFunctionsTest() {
    system.assertNotEquals(null, generateRandomString());
    system.assertNotEquals(null, generateRandomEmail());
    system.assertNotEquals(null, generateRandomUrl());
  }
}
