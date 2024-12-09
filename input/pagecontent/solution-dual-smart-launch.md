The section enables applications to obtain authorization from multiple systems while maintaining appropriate user consent and security controls. It builds on existing SMART App Launch flows, executing them sequentially with contextual information passed between authorization requests.

### Key Characteristics

- Preserves the security properties of SMART App Launch
- Maintains distinct authorization grants for each system
- Enables automated authentication when supported
- Preserves patient context across authorization requests
- Requires no protocol extensions beyond standard SMART, OAuth 2.0, and OpenID Connect parameters

### Core Components

1. **Initial Authorization**: Application obtains authorization from the EHR system using standard SMART App Launch
2. **Context Preservation**: EHR-supplied context (patient ID, user identity) is preserved for subsequent authorization
3. **Secondary Authorization**: Application initiates authorization with imaging system using preserved context
4. **Token Issuance**: Each system issues distinct access tokens for their respective resources

### Application Discovers Imaging Endpoints from EHR

The Application retrieves the EHR's SMART configuration from `[ehrFhirBaseUrl]/.well-known/smart-configuration`. The imaging server URL `[imagingServerFhirBaseUrl]` is discovered through the `associated_endpoints` array.

Servers that want to advertise associated endpoints supporting Dual SMART Launch will include the "smart-imaging-access-dual-launch" capability in the associated endpoint's capabilities array:

```json
{
  "capabilities": [...],
  "associated_endpoints": [{
    "url": "[imagingServerFhirBaseUrl]",
    "capabilities": ["smart-imaging-access-dual-launch"]
  }]
}
```

Next, the application retrieves the SMART configuration from `[imagingServerFhirBaseUrl]/.well-known/smart-configuration`. This configuration generally would not include `associated_endpoints`. The configuration's capabilities array MUST include "smart-imaging-access-dual-launch" to indicate support for receiving an OpenID Connect `id_token` as a `login_hint`.

### Application Obtains Authorization from EHR 

The application initiates a SMART App Launch flow with the EHR, requesting authorization including the `openid` and `fhirUser` scopes to ensure receipt of an OpenID Connect `id_token`. This follows the standard SMART App Launch specification process for obtaining an authorization code.

### Application Exchanges Authorization Code for Access Token from EHR

The application exchanges its authorization code for an Access Token Response that includes:
- An access token for accessing EHR resources
- An OpenID Connect `id_token` as requested via the scopes

### Application Preserves Authorization State

Before initiating authorization with the imaging server, the application must preserve its current authorization state. This includes:

- The EHR's access token
- The EHR's OpenID Connect `id_token` 
- Current application state and context

The application may store this state either client-side (e.g., browser `sessionStorage`) or server-side. The specific storage mechanism is implementation-dependent but must ensure appropriate security controls.

### Imaging Server Verifies Client Registration with EHR

The imaging server MUST verify the requesting client's credentials by retrieving the client's registration details from the EHR's client discovery endpoint. The EHR MUST make its client discovery endpoint location available out of band to the imaging server.

The imaging server:
1. Retrieves client metadata from `[ehrClientDiscoveryEndpoint]/clients/[clientId]`
2. Validates the client type and authentication method:
   * For public clients: validates only the `redirect_uri`
   * For confidential clients using asymmetric authentication: retrieves the JWKS or JWKS URI for validating signatures during the token exchange
   * All other client types MUST be rejected

NOTES:
* Only public clients and asymmetric-authenticated confidential clients are eligible for dual SMART launch
* Client credentials and other symmetric authentication methods are not supported

### Application Obtains Authorization from Imaging Server

The application initiates a SMART on FHIR standalone launch request to the imaging server's authorize endpoint. This request includes:
- The OpenID Connect `id_token` (from the EHR) in the `login_hint` parameter
- Required scopes for imaging access

### Imaging Server Authenticates User and Obtains Authorization from EHR (Embedded Workflow, No User-visible Steps)

The imaging server initiates an authorization request to the EHR's authorization endpoint with:
- The EHR's OpenID Connect `id_token` passed in the `id_token_hint` parameter
- `prompt=none` to request automated authentication
- Scopes requesting access to relevant patient and imaging study data

The EHR processes this request and, if valid:
1. Validates the `id_token_hint`
2. Automatically issues a new Access Token Response containing:
   - An access token for the imaging server to access relevant FHIR resources
   - A new OpenID Connect `id_token`
   - The current patient context

### Imaging Server Obtains User Authorization

The imaging server MUST present an authorization screen to the user asking if they want to authorize the supplied client to access imaging data. This divides authorization decision-making between:
* The EHR (for clinical access authorization)
* The imaging server (for imaging access authorization)

### Imaging Server Enforces Authorization Policy

The imaging server has multiple options for implementing its authorization policy:

1. **Independent Policy**: The imaging server can implement its own access policy based on the patient and user context received from the EHR

2. **EHR-Integrated Policy**: If the EHR hosts ImagingStudy FHIR resources, the imaging server can gate access based on which studies are visible using the EHR-provided access token. This allows for shared enforcement of access rules between the systems.

### Application Exchanges Authorization Code for Access Token from Imaging Server

After user approval, the application exchanges its authorization code for an Access Token Response from the imaging server. This token grants access specifically to the approved imaging resources.

### Application Accesses Resources from Both Systems

The client application can now access:
1. EHR resources using the EHR-issued access token
2. Imaging resources using the imaging server-issued access token

Each system maintains independent access control and token validation.
