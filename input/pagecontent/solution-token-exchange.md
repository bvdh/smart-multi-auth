Using token-exchange (see [RFC8693](https://www.rfc-editor.org/rfc/rfc8693.html) an access-token for the other server is retrieved. This will work for vendor apps with user scopes. Patient scopes require the patient to be passed. In the case this is required, either the `access-token` should be used as the basis for the request or the newly specified `launch-token` should be used.

{% include infonote.html text='Note that patient scopes rely on passing the current patient as the user is not necessary the same as the patient when the user is a patient.
' %}

{% include infonote.html text='Note that this approach will not allow the user to explicitly agree with providing access to the additional information that is stored in the other FHIR server (see [Considerations for Scope Consent](https://www.hl7.org/fhir/smart-app-launch/best-practices.html#considerations-for-scope-consent) making this solution best suited for applications that are not managed by the same organization (i.e. Patient facing apps).' %}

The approach taken in this flow is the same as a normal SMART launch. The application detects both servers and determines that access-token-reuse is possible and what scopes are supported by each server. It then sends out a request that contains the total list of scopes.

This approach does not include a new step in which the user is requested to approve the application having access to the data of the other server. This makes it a solution that might work for vendor apps but not for patient facing apps.


#### Discovery 

The first step in the flow is discovery.

<figure>
  {% include solution-token-exchange-discovery.svg %}
</figure>

The Application retrieves the conformance information from the EHR-FHIR server (`iss1`). Based on `associated_endpoints` it discovers the other server(s) it wants to access (`iss2`). Next, the application retrieves the conformance information of `iss2`.

Signalling a FHIR server supports token exchange with an open-id, launch-token or access-token is signalled in the following way:

1. `conformance.grant_types_supported` will hold `urn:ietf:params:oauth:grant-type:token-exchange` signalling support for token exchange.
2. For systems supporting open-id based token-exchange:
   1. `conformance.scopes_supported` will hold `open-id` signalling that `open-id` is supported.
   2. `conformance.capabilities` will hold `token-exchange-openid` 
3. For systems supporting access-token based token-exchange:
   1. `conformance.capabilities` will hold `token-exchange-accesstoken` 

#### Retrieve Authorization token

Next, the application retrieves an authorization token.

<figure>
  {% include solution-token-exchange-authorization.svg %}
</figure>

The application retrieves an authorization code as is specified by [SMART app launch](https://www.hl7.org/fhir/smart-app-launch/app-launch.html#obtain-authorization-code). Different in this approach is that the application requests the `launch-token` scope in order to get access access to a launch-token to be used in the token exchange. 

{% include infonote.html text='Note as vendor launch is assumed, there is not need to present a page with the authorizations that are granted.' %}

#### Retrieve Access Token

Based on the Authorization Token, an access token can be retrieved.

<figure>
  {% include solution-token-exchange-accesstoken-1.svg %}
</figure>

The access token is requested in the normal way.

<figure>
  {% include solution-token-exchange-accesstoken-2.svg %}
</figure>

The Application retrieves the access-token for the other server using token-exchange. The `grant-type` `urn:ietf:params:oauth:grant-type:token-exchange` indicates token-exchange is used. The `subject_token` field holds the `id-token` and the `subject_token_type` the value `urn:ietf:params:oauth:token-type:id_token`.

Using the claims `iss`, the source authorization server can be determined. Using a set of pre-aligned credentials and the SMART Backend protocol, an access-token is retrieved. This access-token is used to access the introspection endpoint to obtain information on the launch-token.

Based on that information and the requested scopes, a set of scopes is granted for this server. The fhirContext field provides information on the resources in context and is used to determine the corresponding resources. The id's for these resources are returned in the token-response.

As in this approach, the current patient is unknown, any patient specific scopes can not be granted.

#### Access content

Using the access-token, the content on both servers can be accessed.

<figure>
  {% include solution-token-exchange-content.svg %}
</figure>

#### Required changes

Changes requried in the SMART application launch specification.

**CHANGE**: Add the capabilities `token-exchange-openid` and `token-exchange-accesstoken`.

**CHANGE**: Add the `urn:ietf:params:oauth:grant-type:token-exchange` `grant_type`.

**CHANGE**: Add options `subject_token` and `subject_token_type` to the request access-token request.

**CHANGE**: Define the role `launch-full-url` as a full url alternative of the launch patient and encounter, alternatively allow entries with launch for full urls in [fhirContext](https://hl7.org/fhir/smart-app-launch/scopes-and-launch-context.html#fhircontext-exp).
