
This approach is targeted at deployments's where multiple servers are governed by the same organization.

A single Authorization server is used to authenticate users and authorize access.

The EHR authorizes access to other resource servers. From a security perspective this is only acceptable if those servers are governed by a same Authorization Server.

The approach taken in this flow is the same as a normal SMART launch. The application detects both servers and determines that access-token-reuse is possible and what scopes are supported by each server. It then sends out a request that contains the total list of scopes.

#### Discovery 

The first step in the flow is discovery.

<figure>
  {% include solution-reuse-access-token-discovery.svg %}
</figure>

The Application retrieves the conformance information from the EHR-FHIR server (`iss1`). Based on the user_brand_endpoint, it discovers the other server(s) it wants to access (`iss2`). Next, the application retrieves the conformance information of `iss2`.

Optionally this information could also be provided using the [Experimental: Authorization Details for Multiple Servers](https://www.hl7.org/fhir/smart-app-launch/app-launch.html#experimental-authorization-details-for-multiple-servers-exp) approach.

Both conformance endpoints indicate the same authorization and token endpoint. The capability `auth-multi-aud-token` signals the authorization server supports requesting access to multiple resource servers. This signals that a single access token can be requested that allows access to both servers.

The fact that the `auth-multi-aud-token` capability is also on the in the capability list of `iss2` indicates that `iss2` also supports being an audience for the authorization server of `iss1`.

#### Retrieve Authorization token

Next, the application retrieves an authorization token.

<figure>
  {% include solution-reuse-access-token-authorization.svg %}
</figure>

The application retrieves an authorization code as is specified by [SMART app launch](https://www.hl7.org/fhir/smart-app-launch/app-launch.html#obtain-authorization-code). Different in this approach is that the application includes multiple `resource` entries in the request and not `aud` field. This allows the authorization to differentiate this request from regular SMART launches without breaking the syntax of the request (taking `aud` from a entry to an array).

The scopes shown show the access that is provided on each server. Either as seperate lists or in one common list.

The rest of the process is standard SMART.

#### Retrieve Access Token

Based on the Authorization Token, an access token can be retrieved.

<figure>
  {% include solution-reuse-access-token-accesstoken.svg %}
</figure>

The access token is requested in the normal way.

In the case the launch requires passing information on the current context (e.g. patient), some additional specification is required. The SMART app launch specification specifies that the patient and encounter in context are passed as resource id's. In the case of multiple servers, it is not clear for what server the patient-id is the id of the patient.

This addressed in the following way:

* when `patient` is present, the `patient` field holds the `patient-id` for the current patient in all resource servers.
* when the patient is present in one or multiple servers with a different id, the patient will be included in the fhirContext. This requires a `role` field to be present with the value: `launch-full-url`. This also requires the server to indicate support for `context-style` in `conformance.capabilities`. The server the patient resource resides on can be detected by comparing the url with the url of the resource servers. Note that this also allows for scenario's in which the other servers refer to the patient on the EHR FHIR server using full url references.


An example is presented below:

```json

{
  "need_patient_banner": true,
  "smart_style_url": "https://smart.argo.run/smart-style.json",
  "token_type": "Bearer",
  "scope": "launch/patient patient/Observation.rs patient/Patient.rs",
  "expires_in": 3600,
  "fhirContext" : [
    {   "reference": "http://<ehr-url>/Patient/jdasjdaksjdlasj",
        "role": "launch-full-url"
    },
    {   "reference": "http://<other-url>/Patient/jdasjdaksjdlasj",
        "role": "launch-full-url"
    }
  ],
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuZWVkX3BhdGllbnRfYmFubmVyIjp0cnVlLCJzbWFydF9zdHlsZV91cmwiOiJodHRwczovL3NtYXJ0LmFyZ28ucnVuLy9zbWFydC1zdHlsZS5qc29uIiwicGF0aWVudCI6Ijg3YTMzOWQwLThjYWUtNDE4ZS04OWM3LTg2NTFlNmFhYjNjNiIsInRva2VuX3R5cGUiOiJiZWFyZXIiLCJzY29wZSI6ImxhdW5jaC9wYXRpZW50IHBhdGllbnQvT2JzZXJ2YXRpb24ucnMgcGF0aWVudC9QYXRpZW50LnJzIiwiY2xpZW50X2lkIjoiZGVtb19hcHBfd2hhdGV2ZXIiLCJleHBpcmVzX2luIjozNjAwLCJpYXQiOjE2MzM1MzIwMTQsImV4cCI6MTYzMzUzNTYxNH0.PzNw23IZGtBfgpBtbIczthV2hGwanG_eyvthVS8mrG4",
  
}

```
#### Access content

Using the access-token, the content on both servers can be accessed.

<figure>
  {% include solution-reuse-access-token-content.svg %}
</figure>

#### Required changes in SMART App Launch

Changes required in the SMART application launch specification.

**CHANGE:** Add the capability: `auth-multi-aud-token`

**CHANGE**: Allow multiple `resource`'s in the [Obtain authorization code](https://hl7.org/fhir/smart-app-launch/app-launch.html#obtain-authorization-code) call, make `aud` CONDITIONAL.

**CHANGE**: Define the role `launch-full-url` as a full url alternative of the launch patient and encounter, alternatively allow entries with launch for full urls in [fhirContext](https://hl7.org/fhir/smart-app-launch/scopes-and-launch-context.html#fhircontext-exp).
