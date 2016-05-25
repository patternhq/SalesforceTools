trigger LeadTrigger on Lead (before insert, before update, after insert) {
    if (Trigger.isBefore){
        System.debug('*** Lead Before ***');

        if (Trigger.isInsert) {
            System.debug('*** Lead Before Insert ***');
            LeadUtil.maybeReassign(Trigger.new);
        }
    } else if (Trigger.isAfter) {
        System.debug('*** Lead After ***');

        if (Trigger.isInsert) {
            System.debug('*** Lead After Insert ***');
            LeadUtil.maybeConvert(Trigger.new);
        }
    }
}
