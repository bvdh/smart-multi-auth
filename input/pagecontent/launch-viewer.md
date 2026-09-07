# Launch viewer

This approach allows an application launched from an EHR to hand off an
ImagingStudy to an IID (image-identification) viewer. The viewer is launched
as a separate SMART on FHIR application. It uses the EHR access token to
retrieve the current user and patient context, maps that context to its
internal DICOM identities, and decides whether the user may view the study.

The viewer does not assume that the EHR patient identifier is the identifier
used by the DICOM system. The mapping and authorization decision remain the
responsibility of the IID viewer.

## Initial SMART launch

The user starts the originating application using the [SMART App Launch
framework](https://hl7.org/fhir/smart-app-launch/app-launch.html). The
application performs normal discovery against the EHR FHIR server, obtains an
authorization code, and exchanges it for an access token.

The originating application uses that token to retrieve the resources it
needs, including the `ImagingStudy` selected by the user. The usual SMART
launch context rules apply; the application must not treat an identifier
without its FHIR server context as globally unique.

## Select an ImagingStudy

The application presents the available studies to the user. A selected study
is represented by its FHIR reference, for example:

```text
https://ehr.example/fhir/ImagingStudy/123
```

The application reads the study and determines the configured IID viewer
endpoint. The endpoint may be supplied by the EHR deployment configuration or
by an extension/profile agreed by the participating systems. This page does
not prescribe a new FHIR element for that configuration.

## Discover the IID viewer endpoint

The application discovers an `iid-viewer` endpoint associated with the
selected study and verifies that it is suitable for a SMART launch. The
endpoint is the launch URL of the viewer, not the DICOMweb URL used later to
retrieve images.

An illustrative configuration value is:

```json
{
  "iid-viewer": "https://viewer.example/smart/launch"
}
```

The exact representation of this value is deployment-specific. The
application should validate the endpoint and use an allow-list or equivalent
trust configuration rather than accepting an arbitrary URL from untrusted
content.

## Launch the IID viewer

The originating application launches the IID viewer as a new SMART
application. It passes the selected study and the relevant launch context
through the viewer's configured launch mechanism. For example, a deployment
could use a launch URL containing an opaque state reference:

```text
https://viewer.example/smart/launch
  ?iss=https%3A%2F%2Fehr.example%2Ffhir
  &launch=opaque-launch-context
  &client_id=iid-viewer
```

Line breaks and whitespace are shown only for readability. The viewer must
follow the normal SMART launch discovery, state, redirect, and CSRF
protections. The `launch` value should identify server-side state containing
the selected study; sensitive clinical data should not be placed directly in
the URL.

The viewer may instead receive a study reference through a deployment-defined
launch context mechanism. That mechanism must preserve the association between
the study and the EHR FHIR server.

## Authenticate and retrieve an access token

The IID viewer starts its normal SMART authorization flow. The authorization
server authenticates the user when necessary and returns an authorization
code to the viewer's registered redirect URI. The viewer exchanges the code
for an access token:

```http
POST https://ehr.example/oauth/token
Content-Type: application/x-www-form-urlencoded

grant_type=authorization_code&
code=authorization-code&
redirect_uri=https%3A%2F%2Fviewer.example%2Fsmart%2Fcallback&
client_id=iid-viewer
```

The actual authorization and token endpoints come from SMART discovery. The
viewer requests only the scopes it needs, including access to the current
patient and user context as supported by the EHR. The viewer validates the
token response and protects the token as required by OAuth 2.0.

## Retrieve user and patient context

Using the EHR access token, the viewer retrieves the current patient and user
information. The exact resources and scopes depend on the EHR's SMART
configuration. For example, the viewer might retrieve the patient in launch
context and a user resource identified by the token's SMART user context:

```http
GET https://ehr.example/fhir/Patient/456
Authorization: ******
Accept: application/fhir+json
```

The viewer must use the FHIR server identified by `iss` and must not infer
that a patient or user identifier has the same meaning in another system.
Missing, inconsistent, or insufficient context causes the viewer to stop
rather than guessing an identity.

## Map EHR identities to DICOM identities

The IID viewer uses the EHR user and patient information, together with the
selected study reference, to query its internal identity and study indexes.
The mapping can use deployment-defined identifiers or other trusted
correlations. It must produce the DICOM-side patient, user, and study
identities without exposing internal identifiers unnecessarily.

The viewer then checks that:

* the authenticated user maps to an allowed DICOM user;
* the EHR patient maps to the patient associated with the selected study; and
* the user is authorized to access that study under the viewer's local policy.

The viewer does not display or download the study until all required checks
have succeeded. A failed or ambiguous mapping is an authorization failure,
not a request to try another patient.

## Retrieve and display the study

After authorization, the viewer resolves the study to its DICOM study
identifier and retrieves the image data using
[DICOMweb WADO-RS](https://www.dicomstandard.org/using/dicomweb/retrieve-wado-rs).
The DICOMweb endpoint and authentication details are deployment-specific.
The viewer should request only the authorized study and should preserve the
response media type and transfer syntax required by its image renderer.

An illustrative retrieval request is:

```http
GET https://dicom.example/dicomweb/studies/1.2.840.113619.2.55.3.604688
Accept: multipart/related; type="application/dicom"
Authorization: ******
```

The viewer renders the returned instances for the user. The access token used
for DICOMweb access is not assumed to be the EHR token; the viewer uses the
credential and authorization model defined by its DICOM deployment.

## Download the study

When the user selects **Download**, the viewer retrieves the authorized
instances using WADO-RS and streams them to the client device. The viewer
must apply the same authorization check to a download as it does to display,
avoid making the DICOM endpoint directly available to an unauthorized client,
and handle the response as potentially sensitive health information.

The download should use an appropriate filename and media type without
claiming that a study is complete unless the viewer has verified the
retrieved instance set.

## Required considerations

This approach requires participating systems to agree on:

* how an `iid-viewer` launch endpoint is associated with an `ImagingStudy`;
* how the selected study and EHR server context are carried into the viewer
  launch;
* which SMART scopes and launch-context values provide the current patient
  and user;
* how EHR identities are mapped to DICOM identities;
* which policy authorizes access to a study and how denials are reported; and
* how the viewer authenticates to DICOMweb and limits WADO-RS retrievals.

The flow uses standard SMART App Launch for application authentication and
FHIR `ImagingStudy` for study context, while the viewer-specific endpoint,
identity mapping, authorization policy, and DICOMweb credentials require
deployment agreements. No change to SMART App Launch is implied by this
approach.
