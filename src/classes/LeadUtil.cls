/**
 *  Utilities for assigning, converting and routing Leads.
 *  Example usage:
 *
 *      // from within Trigger.isInsert
 *      LeadUtil.maybeConvert(Trigger.new);
 *
 */
public class LeadUtil{

    /** Whether to create opportunities when converting leads. */
    private static Boolean createOpportunities = false;

    /** Whether to send notification emails when converting leads. */
    private static Boolean sendNotificationEmails = false;

    /**
     * Converts leads to existing accounts based on account email domains.
     * @param List<Lead> leadList
     */
    public static void maybeConvert(List<Lead> leadList) {
        System.debug('LeadUtil.maybeConvert starting');

        /** <Lead.Email, Lead> */
        Map<String, Lead> emailsToLeads = new Map<String, Lead>();

        /** <Email Domains> */
        Set<String> emailDomains = new Set<String>();

        /** <EmailDomain, Account> */
        Map<String, Account> domainToAccount = new Map<String, Account>();

        // Unconverted leads with non-null Emails
        for(Lead lead : leadList) {
            if (!lead.IsConverted && lead.Email != null) {
                System.debug(
                    'Lead: ' + lead.Id + ' domain: ' + lead.Email_Domain__c);
                emailsToLeads.put(lead.Email, lead);
                emailDomains.add(lead.Email_Domain__c);
            }
        }

        // We have leads with emails.
        if (!emailsToLeads.isEmpty()) {
            for (Account a : [SELECT ID, OwnerId, Email_Domain__c
                              FROM Account
                              WHERE Email_Domain__c IN :emailDomains]) {
                System.debug('Match: ' + a.Id + '/' + a.Email_Domain__c);
                domainToAccount.put(a.Email_Domain__c, a);
            }

            // We have account matches
            if (!domainToAccount.isEmpty()) {
                System.debug('We have account matches!');
                // Create a list of leadconverts
                List<Database.LeadConvert> lcList =
                    new List<Database.LeadConvert>();

                // TODO: Move this to a shared class
                LeadStatus convertStatus = [SELECT Id, MasterLabel
                                            FROM LeadStatus
                                            WHERE IsConverted=TRUE LIMIT 1];

                // Convert leads with matching accounts
                for (Lead l : emailsToLeads.values()) {
                    if (domainToAccount.keySet().contains(l.Email_Domain__c)) {
                        System.debug('Converting lead: ' + l.Id);

                        Database.LeadConvert lc = new Database.LeadConvert();
                        lc.setLeadId(l.Id);
                        lc.setAccountId(
                            domainToAccount.get(l.Email_Domain__c).Id);
                        lc.setOwnerId(
                            domainToAccount.get(l.Email_Domain__c).OwnerId);
                        lc.setDoNotCreateOpportunity(createOpportunities);
                        lc.setConvertedStatus(convertStatus.MasterLabel);
                        lc.setSendNotificationEmail(sendNotificationEmails);
                        lcList.add(lc);
                    }
                }

                // Try to convert them
                try {
                    if (!lcList.isEmpty()) {
                        System.debug('Converting leads!');
                        Database.LeadConvertResult[] lcrList =
                            Database.convertLead(lcList);
                    }
                } catch (System.dmlexception e) {
                    System.debug('Leads not converted due to error: ' + e);
                }
            }
        }
    }

    /**
     * Reassigns leads to existing lead owners based on email domains.
     * This method assumes implementation during a `before` trigger.
     * @param List<Lead> leadList
     */
    public static void maybeReassign(List<Lead> leadList) {
        System.debug('AutoConversion.maybeReassign starting');

        /** <Lead.Email, Lead> */
        Map<String, Lead> emailsToLeads = new Map<String, Lead>();

        /** <EmailDomain> */
        Set<String> emailDomains = new Set<String>();

        /** <EmailDomain, Lead.OwnerId> */
        Map<String, Id> domainToOwner = new Map<String, Id>();

        // Do we have 'legit' leads? Unconverted leads with Emails
        for(Lead l : leadList) {
            if (!l.IsConverted && l.Email != null) {
                System.debug(
                    'Legit lead: ' + l.Id + ' domain: ' + l.Email_Domain__c);
                emailsToLeads.put(l.Email, l);
                emailDomains.add(l.Email_Domain__c);
            }
        }

        // Do we have lead matches that haven't already been converted?
        // We also need to ignore the ones we just converted.
        for (Lead l : [SELECT Id, OwnerId, Email_Domain__c
                       FROM Lead
                       WHERE IsConverted = FALSE
                       AND Email NOT IN :emailsToLeads.keySet()
                       AND Email_Domain__c IN :emailDomains]) {
            System.debug('Lead/Domain match: ' + l.Email_Domain__c);
            domainToOwner.put(l.Email_Domain__c, l.OwnerId);
        }

        if (!domainToOwner.isEmpty()) {
            // Prepare a list of these leads for updating
            for (Lead l : emailsToLeads.values()) {
                if (domainToOwner.keySet().contains(l.Email_Domain__c)) {
                    System.debug('Lead assignment match: ' + l.Id);
                    l.OwnerId = domainToOwner.get(l.Email_Domain__c);
                    System.debug(
                        'New owner: ' + domainToOwner.get(l.Email_Domain__c));
                }
            }
        }
    }
}
