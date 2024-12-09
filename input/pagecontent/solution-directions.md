Solution directions considered:

## Use same access token on all servers.

This approach can work for scenario's where multiple servers are governed by the same organization.

One approach requires the patient id to be aligned on all servers which provides a very strong coupling between servers. This should not be the preferred solution. Referring to single FHIR server for patients might work (other servers use full url references)\

For servers that are used by multiple EHR's this might even be impossible unless a specific proxy is provided.
The EHR authorizes access to other resource servers. From a security perspective this is seen as unacceptable if those servers are governed by a differnet Authorization Server.



## Use token exchange to obtain an access token for the other server

Using token-exchange an access-token for the other server is retrieved. This will work for vendor apps with user scopes. Patient scopes require the patient to be passed. A possible solution for this would be to include the patient-id and source in the open-id token.

This approach does not include a new step in which the user is requested to approve the application having access to the data of the other server. This makes it a solution that might work for vendor apps but not for patient facing apps.

## Login on multiple servers

The OAuth2 flow requires a redirect for login. Multiple redirects in a row will cause issues for the application as it becomes difficult to maintain state.

This is required though when notifying the user of the access it will provide. For vendor apps this is not always required and might be skipped.

It is a scenario that is required when the user has to provide permission to access the content in secure manner.

## Authorization proxy

Proxy server that takes the authentication request and authorizes with multiple Authorization Servers. This a new field for which there are no current specifications.

It also requires all parties to trust the proxy server. It would allow the authorization flow to follow the normal OAuth2 flow from the client perspective.