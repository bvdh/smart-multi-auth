## User Brand Endpoint

Slicing on Endpoint.payloadType is missing. The current expression requires all codings to be http://terminology.hl7.org/CodeSystem/endpoint-payload-type#none. This makes it impossible to also add other codings, is this the intention? If so, why is the cardinality 1..*?

## User Brand Organization

The endpoints are restricted to UserBrandEndpoint making it impossible to add other options. I do not think this is the preferred solution.