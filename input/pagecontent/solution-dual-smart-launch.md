The OAuth2 flow requires a redirect for login. Multiple redirects in a row will cause issues for the application as it becomes difficult to maintain state. This is required though when notifying the user of the access it will provide (see [Considerations for Scope Consent](https://www.hl7.org/fhir/smart-app-launch/best-practices.html#considerations-for-scope-consent). This can not be avoided when the application is not controlled by the same organization.

In this section we explore the use case where it is required when the user has to provide permission to access the content in secure manner.

The approach taken in this flow is the same as a normal SMART launch, but couples several of these back-to-back. The advantage of the approach is that it does not compromise the SMART on FHIR approach and requires little to no additional specification. The disadvantage is that it requires multiple redirects with state maintained between them.

The patient context of the first launch is passed when performing the first SMART launch, triggered by the launch token. This information needs to be passed to the second launch. This requires alignment between the different authorization systems. In a way this is similar to the token exchange approach where a similar alignment is required. This is only required when patient specific scopes are used.

This is achieved by generating a `launch-token` in the EHR flow. This will be used as the `launchId` in the second flow.

#### Discovery 
 
The first step in the flow is discovery.

<figure>
  {% include solution-argo-ehr-token-discovery.svg %}
</figure>

The Application retrieves the conformance information from the EHR-FHIR server (`iss`). Based on the `associated_endpoints`, the imaging server url `iss-imaging` is located. Alternatively the user_brand_endpoint can be used to discover the other server(s) it wants to access (`iss-imaging`). 

The fact that `iss-imaging` support the launch-token approach is signalled by the `smart-imaging-access` capability.

{% include infonote.html text='Note we might want to change the name `smart-imaging-access` to something more neutral.
' %}

Next, the application retrieves the conformance information of `iss-imaging`. This conformance statement does not include a `associated_endpoint` field as there is no option to use this authorization server with the EHR.

{% include infonote.html text='Note we might want to change define a capability for indicating the endpoints whose authorization server can be used for smart-imaging-access.
' %}


#### Retrieve EHR Authorization token and Access token

Next, the application retrieves an authorization token and access-token from the EHR.

<figure>
  {% include solution-argo-ehr-token-ehr.svg %}
</figure>

The application retrieves an authorization code as is specified by [SMART app launch](https://www.hl7.org/fhir/smart-app-launch/app-launch.html#obtain-authorization-code).

The response includes an `open-id` token as requested.

#### Retrieve Imaging Authorization token and Access token

Next, the application retrieves an authorization token and access-token from the imaging server. 

First it has to ensure that the current state (application state, tokens) can be retrieved after the SMART launch against the second server.

The way to do this is outside the scope of this specifications, options include: storing it on a server, storing it encrypted in session-storage, ... . Optionally all, or part of the state can be passed as the `state` in the authorization step.

<figure>
  {% include solution-argo-ehr-token-imaging-1.svg %}
</figure>

Based on the open-id token, the iss of the authorization server is determined. The clients endpoint of the EHR AS is used to retrieve information the authorized clients and the client requesting access is verified.

The application retrieves an `ehr-access token` and `new-id-token` as is specified by [SMART app launch](https://www.hl7.org/fhir/smart-app-launch/app-launch.html#obtain-authorization-code). The `open-id` token retrieved in the previous step is used as `token-hint` and with a `prompt` set to `none` (see https://openid.net/specs/openid-connect-core-1_0.html).

<figure>
  {% include solution-argo-ehr-token-imaging-2.svg %}
</figure>

Using the `ehr-access-token`, the Imaging AS retrieves information on the current patient, user and the ImagingStudies this user is allowed to access from the EHR. This allows for the model where the EHR retains this information and the Imaging Server depends on it.

{% include infonote.html text='We may want to generalize this a bit further and define some sort of signalling that would allow the Imaging Server to detect what resources to check. ' %}

<figure>
  {% include solution-argo-ehr-token-imaging-3.svg %}
</figure>

Using the information retrieved from EHR, the Imaging AS presents a list of authorizations to the user and asks whether the application should be granted access to this information.

If the user agrees, an `imaging-auth-token` is generated.

The application restores the state and retrieves the ehr access token and context.

Using the `imaging-auth-token` the application can retrieve an `imaging-token-response` that contains an access token for the Imaging Server as well the patient and user id on the Imaging Server.

#### Access content

Using the access-tokens, the content on both servers can be accessed.

<figure>
  {% include solution-argo-ehr-token-content.svg %}
</figure>

When accessing the imaging information the Imaging FHIR server will determine what content can be accessed. The information to do is can be coded in the token are determined by accessing EHR.