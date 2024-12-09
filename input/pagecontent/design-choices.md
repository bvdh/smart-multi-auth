### Issue: discovery of supported mechanisms

An App that wants to access multiple resource servers needs a way to detect what servers are available and in what way it can access those servers.

Discovery consists of multiple elements: discovery of available servers and discovery of what mechanism to use to access those servers. 

##### Discovery of available servers

Discovery of other servers could be provided as part of the app-configuration or discovered. 

The [Brand](https://www.hl7.org/fhir/smart-app-launch/brands.html) provides an overview of other Endpoints that are available to the App. This mechanism provides a convenient mechanism to discover these services and provide information related to to them. In this specification, we will use the brand approach.

SMART v2 also provides the option to provide information on available associated servers using the `associated_endpoints` field in the conformance statement (see https://www.hl7.org/fhir/smart-app-launch/conformance.html#metadata). This field is intended for this purpose

**CHOICE:** Endpoint discovery is based on 'associated_endpoints`.

##### Discovery of mechanism to access server

This information could be added as extensions to the resources provided in the Brand bundle. Alternatively, these can be included in the configuration information. The configuration information holds the security related information and should be used as source of truth. Optionally, extensions can be added to the Brand bundle to more easily filter the endpoints to use.

**CHOICE:** A set of capabilities need to be defined to provide information on the capabilities that can be listed as part of the capabilities list of the `associated-endpoints` response.

**CHOICE:** A CodeSystem and ValueSet is defined to hold these options.

### Reuse patient id

One approach requires the patient id to be aligned on all servers which provides a very strong coupling between servers. This should not be the preferred solution. Referring to single FHIR server for patients might work (other servers use full url references).

**CHOICE:** There should be no requirements for servers to align on the id's given to certain resources such as patients.