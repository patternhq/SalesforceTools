# Salesforce Tools
_Open-source utilities for Salesforce.com developers_

## Background
We’re dedicated to providing tools for Salesforce developers in an ever-changing world of sales so we’ve committed to open-sourcing the majority of our Salesforce code.

Read more in our [blog post](https://medium.com/@PatternEng/open-sourcing-our-salesforce-4651d3fceba5).

## Use Cases

1. **Leads auto-assigning to existing Lead Owners.** Sally the salesperson owns Leads from `acme.com`. When another Lead with an email `*@acme.com` is created, it's auto assigned to Sally.
2. **Leads auto-converting to existing Accounts.** Roger the rep owns an Account with the custom field `Email Domain` set to `acme.com`. When a Lead with an email `*@acme.com` is created, the Lead is converted to the existing Account and assigned to the existing account Owner.
  * This supports multiple domains with a simple comma delimiter, e.g. `acme.com,acme.co,acme.io,`.
  * You'll notice the field is _always_ suffixed with a `,` character via a Workflow/Field Update to standardize the required queries.
3. In addition to Lead Utilities, we include a **basic Mock-like class** for easier testing (We know that's your favorite part of Force.com.)

## Installing
### via Unmanaged Package
For your convenience, we've created an unmanaged package with all the components. You can [install to Production](https://goo.gl/rizxb3) or [install to Sandbox](https://goo.gl/PUogR2).

### via IDE + Change Sets
1. Add this code to your sandbox environment using your favorite IDE or the web-based Developer Console. We like [MavensMate](http://mavensmate.com/).
2. Adjust as necessary based on your existing triggers (e.g. if you already have a Trigger for leads, reference the provided classes in your existing Trigger).
3. Deploy using [change sets](https://developer.salesforce.com/trailhead/en/app_deployment/app_deployment_changesets) best practices.

## Configuring
Once installed, automatic lead conversion will only occur for Accounts with the populated `Email Domain` field. (We've purposely left final task for you because we know each organization is unique.) As always, we suggest doing this in bulk.

![Email Domain in action](https://github.com/patternhq/SalesforceTools/blob/gh-pages/SFDCEmailDomain.png "Email Domain in action")

## Future Work
Please use [GitHub Issues](https://github.com/patternhq/SalesforceTools/issues) to explore planned features, recommend new components, or help contribute.

## Testing
98% Code Coverage.

## Contributing
See our [CONTRIBUTING](https://github.com/patternhq/SalesforceTools/blob/master/CONTIRBUTING.md) guidelines.

## About Us
We're former sales ops, sales leaders, and sales engineers. In addition to maintaining this repo, we're building a new workspace for salespeople. Learn more at [getpattern.com](https://www.getpattern.com?utm_source=github&utm_medium=repo&utm_campaign=salesforcetools).

## License
MIT
