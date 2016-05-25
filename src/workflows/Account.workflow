<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Pattern_Add_Trailing_Comma_Email_Domain</fullName>
        <field>Email_Domain__c</field>
        <formula>Email_Domain__c + &apos;,&apos;</formula>
        <name>Pattern: Add Trailing Comma Email Domain</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Pattern%3A Add Trailing Comma Email Domain</fullName>
        <actions>
            <name>Pattern_Add_Trailing_Comma_Email_Domain</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(   NOT(ISBLANK(Email_Domain__c)),        RIGHT(Email_Domain__c, 1) &lt;&gt; &quot;,&quot; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
