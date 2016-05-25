@isTest
public class LeadUtil_TESTS{

    /* Tests for lead auto conversion */
    @isTest
    private static void leadAutoConvert_TEST() {
        String domain = 'schmoe.com';
        String email = 'test@' + domain;

        Account a = Mock.createAccount();
        a.Email_Domain__c = domain;
        update a;

        Lead shouldConvert = new Lead(
            FirstName='Joe',
            LastName='Schmoe',
            Company='Test',
            Email=email);
        insert shouldConvert;

        List<Contact> c = [SELECT Id, Email
                           FROM Contact
                           WHERE Email = :email
                           LIMIT 1];
        System.assertEquals(email, c[0].Email);
    }

    /* Tests for lead auto assignment */
    @isTest
    private static void leadAutoReassign_TEST() {
        String domain = 'schmoe.com';
        String email = 'test@' + domain;

        User existingOwner = Mock.createUser();
        User newLeadOwner = Mock.createUser();

        Lead firstLead = Mock.createLead();
        firstLead.Email = 'first@' + domain;
        firstLead.OwnerId = existingOwner.Id;
        update firstLead;

        Lead routedLead = new Lead(
            FirstName='Joe',
            LastName='Schmoe',
            Company='Test',
            OwnerId=newLeadOwner.Id,
            Email=email);
        insert routedLead;

        // OwnerId should be User 1 not User 2
        List<Lead> leads = [SELECT Id, OwnerId
                            FROM Lead
                            WHERE Email = :email
                            LIMIT 1];
        System.assertEquals(existingOwner.Id, leads[0].OwnerId);
    }
}
