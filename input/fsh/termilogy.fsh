
CodeSystem: SmartAuthInformationCodeSystem
Id: smart-auth-information-CodeSystem
Title: "Codes for SMART authorization"
Description: "-"
* #endpoint-capabilities "Endpoint Capabilities" 
  * #smart-app-state "Endpoint storing smart app state resources" 
* #capability "Capabilities of the server"
  * #launch-ehr "support for SMART’s EHR Launch mode"
  * #launch-standalone "support for SMART’s Standalone Launch mode"
  * #authorize-post "support for POST-based authorization"
  * #client-public "support for SMART’s public client profile (no client authentication)"
  * #client-confidential-symmetric "support for SMART’s symmetric confidential client profile (“client secret” authentication). See Client Authentication Symmetric."
  * #client-confidential-asymmetric "support for SMART’s asymmetric confidential client profile (“JWT authentication”). See Client Authentication Asymmetric."
  * #sso-openid-connect "support for SMART’s OpenID Connect profile"
  * #context-banner "support for “need patient banner” launch context (conveyed via need_patient_banner token parameter)"
  * #context-style "support for “SMART style URL” launch context (conveyed via smart_style_url token parameter). This capability is deemed experimental. Launch Context for EHR Launch"
  * #context-ehr-patient "support for patient-level launch context (requested by launch/patient scope, conveyed via patient token parameter)"
  * #context-ehr-encounter "support for encounter-level launch context (requested by launch/encounter scope, conveyed via encounter token parameter) Launch Context for Standalone Launch"
  * #context-standalone-patient "support for patient-level launch context (requested by launch/patient scope, conveyed via patient token parameter)"
  * #context-standalone-encounter "support for encounter-level launch context (requested by launch/encounter scope, conveyed via encounter token parameter) Permissions"
  * #permission-offline "support for “offline” refresh tokens (requested by offline_access scope)"
  * #permission-online "support for “online” refresh tokens requested during EHR Launch (requested by online_access scope). This capability is deemed experimental, providing the input to a scope negotiation that could result in granting an online or offline refresh token (see Scopes and Launch Context)."
  * #permission-patient "support for patient-level scopes (e.g., patient/Observation.rs)"
  * #permission-user "support for user-level scopes (e.g., user/Appointment.rs)"
  * #permission-v1 "support for SMARTv1 scope syntax (e.g., patient/Observation.read)"
  * #permission-v2 "support for SMARTv2 granular scope syntax (e.g., patient/Observation.rs?category=http://terminology.hl7.org/CodeSystem/observation-category|vital-signs) App State (Experimental)"
  * #launch-token "support for issuing launch tokens."
  * #token-exchange-openid "support for token exchange using an open id token"
  * #token-exchange-accesstoken "support for token exchange using an access token"
  * #token-exchange-launchtoken "support for token exchange using a launch token"
* #grant-type "Lists the grant-types supported"
  * #authorization_code "when SMART App Launch is supported"
  * #client_credentials "Indicates upport for SMART Backend Services."
  * #urn:ietf:params:oauth:grant-type:token-exchange "Indicates support for token-exchange according to RFC8693"
* #token_endpoint_auth_methods "Supported token endpoints"
  * #client_secret_post ""
  * #client_secret_basic ""
  * #private_key_jwt  ""
* #smart_associated_endpoints "Smart associated_endpoints capabilities"
  * #token-reuse    "Authorization credentials can be retrieved by retrieving a access token for multiple audiences."
  * #token-exchange "Authorization credentials can be retrieved using token exchange."
  * #smart-open-id-connect "Authorization credentials can be retrieved using OpenID Connect with SMART on FHIR extensions."

ValueSet: SmartGrantTypes
Id: smart-grant-types
Title: "Grant types supported by SMART-on-FHIR"
* include codes from system SmartAuthInformationCodeSystem where concept is-a #grant-type
* exclude SmartAuthInformationCodeSystem#grant-type

ValueSet: SmartTokenEndpointAuthMethods
Id: smart-token-endpoint-auth-methods
Title: "Smart Token Endpoint Auth Methods supported by SMART-on-FHIR"
* include codes from system SmartAuthInformationCodeSystem where concept is-a #token_endpoint_auth_methods
* exclude SmartAuthInformationCodeSystem#token_endpoint_auth_methods

ValueSet: SmartCapabilities
Title: "Smart Capabilities"
* include codes from system SmartAuthInformationCodeSystem where concept is-a #capability
* exclude SmartAuthInformationCodeSystem#capability
* include SmartAuthInformationCodeSystem#smart-app-state

ValueSet: SmartEndpointCapabilities
Title: "Smart associated_endpoints capabilities"
* include codes from system SmartAuthInformationCodeSystem where concept is-a #smart_associated_endpoints
* exclude SmartAuthInformationCodeSystem#smart_associated_endpoints
