/**
 *  The MIT License (MIT)
 *
 *  Copyright (c) 2016 Pattern Technologies, Inc.
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to
 *  deal in the Software without restriction, including without limitation the
 *  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 *  sell copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 *  IN THE SOFTWARE.
 */
@isTest
public class Mock {

  static {
    System.assert(
      Test.isRunningTest(),
      'You must call these from test methods');
  }

  public static Decimal DEFAULT_PRICE = 1;
  public static Decimal DEFAULT_QUANTITY = 1;
  public static String DEFAULT_ROLE = 'Decision Maker';
  public static Blob TEST_BLOB = Blob.valueOf(generateRandomString(16));
  public static Date TEST_DATE = System.today();
  public static String TEST_STRING = generateRandomString(16);

  // Account Helpers
  public static Account createAccount() {
    Account a = generateAccount();
    insert a;
    return a;
  }

  public static Account createAccountWithOwner(Id ownerId) {
    Account a = generateAccountWithOwner(ownerId);
    insert a;
    return a;
  }

  public static Account generateAccount() {
    return new Account(
        Name = TEST_STRING,
        BillingStreet='Test Street',
        BillingCity='Test City',
        BillingState='IL',
        BillingPostalCode='60193',
        BillingCountry='United States');
  }
  public static Account generateAccountWithOwner(Id ownerId) {
    Account a = generateAccount();
    a.OwnerId = ownerId;
    return a;
  }

  public static Account createAccountWithParent(Id accountId) {
    Account a = generateAccountWithParent(accountId);
    insert a;
    return a;
  }

  public static Account generateAccountWithParent(Id parentId) {
    Account a = generateAccount();
    a.ParentId = parentId;
    return a;
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

  // Lead Convert
  public static Database.LeadConvert getLeadConvertObject(Id leadId) {
    Database.LeadConvert convertObject = new Database.Leadconvert();
    convertObject.setLeadId(leadId);
    convertObject.setConvertedStatus(CONVERTED_LEAD_STATUS);
    convertObject.setDoNotCreateOpportunity(false);
    return convertObject;
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

  // Products
  public static Product2 createProduct() {
    Product2 p = generateProduct();
    insert p;
    return p;
  }

  public static Product2 generateProduct() {
    return new Product2(
        Name = TEST_STRING,
        IsActive = true);
  }

  // Task
  public static Task createTask() {
    Task t = generateTask();
    insert t;
    return t;
  }

  public static Task generateTask() {
    return new Task();
  }

  // User
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

  public static String CONVERTED_LEAD_STATUS {
    get {
      if (null == CONVERTED_LEAD_STATUS) {
        CONVERTED_LEAD_STATUS = [
            SELECT MasterLabel
            FROM LeadStatus
            WHERE IsConverted = TRUE
            LIMIT 1][0].MasterLabel;
      }
      return CONVERTED_LEAD_STATUS;
    }
    private set;
  }

  // Note: This fails if @seeAllData=true is not included
  public static Pricebook2 STANDARD_PRICEBOOK {
    get {
      if (STANDARD_PRICEBOOK == null) {
        STANDARD_PRICEBOOK = [
            SELECT Name, IsActive
            FROM Pricebook2
            WHERE IsStandard = TRUE];
      }
      return STANDARD_PRICEBOOK;
    }
    private set;
  }

  // Opportunity Line Items
  public static OpportunityLineItem createOpportunityLineItem(Id opportunityId, Id pricebookEntryId) {
    OpportunityLineItem oli = generateOpportunityLineItem(opportunityId, pricebookEntryId);
    insert oli;
    return oli;
  }

  public static OpportunityLineItem generateOpportunityLineItem(Id opportunityId, Id pricebookEntryId) {
    return new OpportunityLineItem(
        OpportunityId=opportunityId,
        PricebookEntryId=pricebookEntryId,
        Quantity=DEFAULT_QUANTITY,
        TotalPrice=DEFAULT_PRICE,
        ServiceDate=System.today());
  }

  // Opportunity Contact Roles
  public static OpportunityContactRole createOpportunityContactRole(Id opportunityId, Id contactId) {
    OpportunityContactRole ocr = generateOpportunityContactRole(opportunityId, contactId);
    insert ocr;
    return ocr;
  }

  public static OpportunityContactRole generateOpportunityContactRole(Id opportunityId, Id contactId) {
    return new OpportunityContactRole(
        OpportunityId=opportunityId,
        ContactId=contactId,
        Role=DEFAULT_ROLE);
  }

  // Pricebook
  public static Pricebook2 createPricebook() {
    Pricebook2 pricebook = generatePricebook();
    insert pricebook;
    return pricebook;
  }

  public static Pricebook2 generatePricebook() {
    return new Pricebook2(
        Name=TEST_STRING,
        IsActive=TRUE);
  }

  // Pricebook Entries
  // Note: This fails if @seeAllData=true is not included
  public static PricebookEntry createPricebookEntry(Id productId, Id pricebookId) {
    return createPricebookEntries(new Id[] { productId }, pricebookId)[0];
  }

  public static List<PricebookEntry> createPricebookEntries(List<Id> productIds, Id pricebookId) {
    Set<Id> haveStandardPrice = new Set<Id>();
    for(PricebookEntry pbe : [
        SELECT Product2Id
        FROM PricebookEntry
        WHERE Pricebook2.IsStandard = TRUE AND Product2Id in :productIds]) {
      haveStandardPrice.add(pbe.Product2Id);
    }
    List<PricebookEntry> standardPBEs = new List<PricebookEntry>();
    List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
    for(Id productId : productIds) {
      if (!haveStandardPrice.contains(productId)) {
        standardPBEs.add(generatePricebookEntry(productId, STANDARD_PRICEBOOK.id));
      }
      pricebookEntries.add(generatePricebookEntry(productId, pricebookId));
    }
      if (!standardPBEs.isEmpty()) {
        insert standardPBEs;
        insert pricebookEntries;
        return pricebookEntries;
      }
  }

  private static PricebookEntry generatePricebookEntry(Id productId, Id pricebookId) {
    return new PricebookEntry(
        Product2Id=productId,
        Pricebook2Id=pricebookId,
        IsActive=TRUE,
        UnitPrice=DEFAULT_PRICE);
  }

  // Self-tests
  @isTest(seeAllData=true)
  private static void testProductCreators() {
    Pricebook2 pricebook = createPricebook();
    assertIdNotNull(pricebook);
    Product2 product = createProduct();
    assertIdNotNull(product);
    PricebookEntry pricebookEntry = createPricebookEntry(product.id, pricebook.id);
    assertIdNotNull(pricebookEntry);
    Account testAccount = createAccount();
    Opportunity testOppty = generateOpportunity(testAccount.id);
    testOppty.pricebook2Id = pricebook.id;
    insert testOppty;
    assertIdNotNull(createOpportunityLineItem(testOppty.id, pricebookEntry.id));
  }

  @isTest
  private static void testCloseWinOpportunity() {
    Opportunity testOppty = createOpportunity(createAccount().id);
    closeWinOpportunity(testOppty);
    update testOppty;
    testOppty = [SELECT IsWon FROM Opportunity WHERE Id = :testOppty.Id];
    System.assertEquals(TRUE, testOppty.IsWon);
  }

  private static void assertIdNotNull(SObject obj) {
    system.assertNotEquals(null, obj.id);
  }

  @isTest
  private static void testCloseLoseOpportunity() {
    Opportunity testOppty = createOpportunity(createAccount().id);
    closeLoseOpportunity(testOppty);
    update testOppty;
    testOppty = [SELECT IsClosed, IsWon
                 FROM Opportunity
                 WHERE Id = :testOppty.Id];
    system.assertEquals(TRUE, testOppty.IsClosed);
    system.assertEquals(FALSE, testOppty.IsWon);
  }

  @isTest
  private static void testLeadConversion() {
    Lead testLead = createLead();
    Database.convertLead(getLeadConvertObject(testLead.Id));
    testLead = [SELECT IsConverted, ConvertedOpportunityId
                FROM Lead
                WHERE Id = :testLead.Id];
    system.assertEquals(TRUE, testLead.isConverted);
    system.assert(testLead.ConvertedOpportunityId != null);
  }

  @isTest
  private static void randomFunctionsTest() {
    system.assertNotEquals(null, generateRandomString());
    system.assertNotEquals(null, generateRandomEmail());
    system.assertNotEquals(null, generateRandomUrl());
  }

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
}
