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

        // Create a Lead
        Lead l = Mock.createLead();
        l.Email = 'first@' + domain;
        l.OwnerId = existingOwner.Id;
        update l;

        List<Lead> lList = [SELECT Id, Email_Domain__c, OwnerId
                            FROM Lead
                            WHERE Id =: l.Id
                            LIMIT 1];
        System.assertEquals(domain, lList[0].Email_Domain__c);
        System.assertEquals(existingOwner.Id, lList[0].OwnerId);

        Lead l2 = new Lead(
            FirstName='Joe',
            LastName='Schmoe',
            Company='Test',
            OwnerId=newLeadOwner.Id,
            Email=email);
        insert l2;

        // OwnerId should be User 1 not User 2
        List<Lead> lList2 = [SELECT Id, OwnerId
                             FROM Lead
                             WHERE Email = :email
                             LIMIT 1];
        System.assertEquals(existingOwner.Id, lList2[0].OwnerId);
    }
}
