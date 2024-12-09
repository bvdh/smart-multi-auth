Logical: ExtendedSmartLaunchConformance
Id: extended-smart-launch-conformance
Title: "New SMART launch conformance definition"
Description: "The formal definition of the SMART launch conformance as a FHIR logical model."
* issuer                                0..1 string "CONDITIONAL, String conveying this system’s OpenID Connect Issuer URL. Required if the server’s capabilities include sso-openid-connect; otherwise, omitted."
* jwks_uri                              0..1 string "CONDITIONAL, String conveying this system’s JSON Web Key Set URL. Required if the server’s capabilities include sso-openid-connect; otherwise, optional."
* authorization_endpoint                0..1 string "REQUIRED, URL to the OAuth2 authorization endpoint. Required if server supports the `launch-ehr` or launch-standalone capability; otherwise, optional."
* grant_types_supported                 1..* code   "OPTIONAL, Array of grant types supported at the token endpoint. The options are “authorization_code” (when SMART App Launch is supported) and “client_credentials” (when SMART Backend Services is supported)."
* grant_types_supported from SmartGrantTypes (required)
* token_endpoint                        1..1 string "OPTIONAL, URL to the OAuth2 token endpoint."
* token_endpoint_auth_methods_supported 0..1 code   "array of client authentication methods supported by the token endpoint. The options are “client_secret_post”, “client_secret_basic”, and “private_key_jwt”."
* token_endpoint_auth_methods_supported from SmartTokenEndpointAuthMethods (required)
* registration_endpoint                 0..1 string "OPTIONAL, If available, URL to the OAuth2 dynamic registration endpoint for this FHIR server."
* smart_app_state_endpoint              0..1 string "OPTIONAL, DEPRECATED, URL to the EHR’s app state endpoint. Deprecated; use associated_endpoints with the smart-app-state capability instead."
* user_access_brand_bundle              0..1 string "RECOMMENDED, URL for a Brand Bundle. See User Access Brands."
* user_access_brand_identifier          0..1 string "RECOMMENDED, Identifier for the primary entry in a Brand Bundle. See User Access Brands."
* scopes_supported                      0..1 string "RECOMMENDED, Array of scopes a client may request. See scopes and launch context. The server SHALL support all scopes listed here; additional scopes MAY be supported (so clients should not consider this an exhaustive list)."
* response_types_supported              0..1 string "RECOMMENDED, Array of OAuth2 response_type values that are supported. Implementers can refer to response_types defined in OAuth 2.0 (RFC 6749) and in OIDC Core."
* management_endpoint                   0..1 string "RECOMMENDED, URL where an end-user can view which applications currently have access to data and can make adjustments to these access rights."
* introspection_endpoint                0..1 string "RECOMMENDED, URL to a server’s introspection endpoint that can be used to validate a token."
* revocation_endpoint                   0..1 string "RECOMMENDED, URL to a server’s revoke endpoint that can be used to revoke a token."
* capabilities                          1..* code   "REQUIRED, Array of strings representing SMART capabilities (e.g., sso-openid-connect or launch-standalone) that the server supports."
* capabilities from SmartCapabilities (required)
* code_challenge_methods_supported      1..* string "REQUIRED, Array of PKCE code challenge methods supported. The S256 method SHALL be included in this list, and the plain method SHALL NOT be included in this list."
* associated_endpoints                  0..1 Base  "OPTIONAL, Array of objects for endpoints that share the same authorization mechanism as this FHIR endpoint, each with a “url” and “capabilities” array. This property is deemed experimental."
  * url           1..1 string "url of the endpoint"
  * capabilities  1..* code "List of capabilities of the endpoint."
  * capabilities from SmartEndpointCapabilities (required)