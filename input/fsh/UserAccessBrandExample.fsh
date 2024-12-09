RuleSet: EndpointDefaults
* extension[fhir-version].valueCode = #4.0.1
* status = #active
* connectionType
  * system = "http://terminology.hl7.org/CodeSystem/endpoint-connection-type"
  * code   = #hl7-fhir-rest
* payloadType = http://terminology.hl7.org/CodeSystem/endpoint-payload-type#none

RuleSet: BrandEntry( resource )
* entry[UserAccessBrand][+]
  * fullUrl  = "urn:Organization/{resource}"
  * resource = {resource}

RuleSet: EndpointEntry( resource )
* entry[UserAccessEndpoint][+]
  * fullUrl  = "urn:Endpoint/{resource}"
  * resource = {resource}

/////////////////////////////////////////////////////////////////////////////////////////////////////

Instance: EpicSandboxOrganization
InstanceOf: http://hl7.org/fhir/smart-app-launch/StructureDefinition/user-access-brand
* name = "Epic Sandbox"
* telecom
  * system = #url
  * value = "https://fhir.epic.com/"
* type = http://terminology.hl7.org/CodeSystem/organization-type#prov
* endpoint[+] = Reference( EpicSandboxEndpoint )


Instance: EpicSandboxEndpoint
InstanceOf: http://hl7.org/fhir/smart-app-launch/StructureDefinition/user-access-endpoint
* insert EndpointDefaults
* contact[configuration-url]
  * system = #url
  * value  = "https://fhir.epic.com/"
* address = "https://fhir.epic.com/interconnect-fhir-oauth/api/FHIR/R4/"


Instance: ImagingSandboxOrganization
InstanceOf: http://hl7.org/fhir/smart-app-launch/StructureDefinition/user-access-brand
* name = "Imaging PACS"
* telecom
  * system = #url
  * value = "https://philips.com/"
* type = http://terminology.hl7.org/CodeSystem/organization-type#imaging
* endpoint[+] = Reference( ImagingSandboxEndpoint )

Instance: ImagingSandboxEndpoint
InstanceOf: http://hl7.org/fhir/smart-app-launch/StructureDefinition/user-access-endpoint
* insert EndpointDefaults
* name = "FHIR end point for imaging"
* contact[configuration-url]
  * system = #url
  * value  = "https://technical.philips.com/"
* address  = "http://92.108.246.183:9410/api/fhir"

Instance: UserBrandBundleExample
InstanceOf: http://hl7.org/fhir/smart-app-launch/StructureDefinition/user-access-brands-bundle
* meta.lastUpdated = 2024-06-06T13:28:17.269+02:00
* type = #collection
* insert BrandEntry( EpicSandboxOrganization )
* insert EndpointEntry( EpicSandboxEndpoint )
* insert BrandEntry( ImagingSandboxOrganization )
* insert EndpointEntry( ImagingSandboxEndpoint )
