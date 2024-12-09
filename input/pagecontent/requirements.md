# Requirements

## Context

Application (Patient and Vendor) launches against EHR, discovers and connects to other FHIR servers in the network. These servers are protected by there own authentication server that have an understanding with the EHR Authorization Server.

### Generic

1. REQ: A seamless as possible authentication of an application to multiple servers (e.g. imaging server).
2. REQ: Resources and data offered may differ for each FHIR server
2. REQ: Application scopes may differ for each FHIR server
3. REQ: Authentication tokens can potentially be used to access non-FHIR servers
   1. REQ: Authentication tokens can potentially be used to access DICOM-web servers
   1. REQ: Authentication tokens can potentially be used to access PACS servers using DIMSE
4. REQ: The EHR Authorization Server is not responsible for authorizing access to access content to servers other than the EHR server.
5. REQ: Patient scopes are allowed when accessing other FHIR servers
6. REQ: EHR may place additional restrictions on data that can be accessed that has to be respected by the other servers
7. REQ: The authorised clients might be managed by the EHR.

### Patient App requirements

1. REQ: Patient App launches from EHR and discovers other FHIR servers
2. REQ: Patient App discovers authorization/authentication options for connecting to those servers
3. REQ: Patient Web app authorizes with EHR and connects to other FHIR server
4. REQ: Patient App shows, as part of launch process, the information the user authorizes the application to access. This has to be done securely.

### Vendor App requirements

1. REQ: Vendor App launches from EHR and discovers other FHIR servers
2. REQ: Vendor App discovers authorization/authentication options for connecting to those servers
3. REQ: Vendor Web app authorizes with EHR and connects to other FHIR server

