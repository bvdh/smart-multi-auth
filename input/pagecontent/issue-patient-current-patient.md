### Issue: pass current patient

When using different independent authorization servers, in what way can I pass information on the launch context to the other server.

Launch context consists, among others, of: current patient. The current patient is needed in order to use patient specific scopes.

#### Option: ignore

Only allow multi-server access for user and system specific scopes will remove the requirement for passing patient context.

#### Option: Pass as part of the parameters

The patient could be passed as part of the parameters in the different authorization and authentication requests. This is not a required solution as the current patient is part of the security enforcement. This requires that the application should not be able to influence it.

#### Option: Pass access-token and introspect it

During the authorization/authentication of the other server, the access token for the initial server (EHR) is passed. This is not a preferred solution as the access token allows access to the data on the EHR server. The permissions to do so where issued to the App and not to the other authorization server which may not be allowed to access the data.

#### Option: Embed the current patient in the open-id token

This could work. It would change the scope of the openid token and change its role and purpose.

#### Option: Request launch token for other system from EHR

As part of the authorization/authentication process, the EHR issues a token that can be used in obtaining the current context when authorizing with the other system. This similar to the openid token but has a different purpose and scope. Making such launch token specific for the other AS also allows customization and specific agreements between those systems on the format and content of the token. The other system would inspect the token using introspection, similarly to introspection of a access or open id token.

If it is only used with introspection, it can be EHR-AS specific and can be specified -> open-id+scopes+patient+...

This token could be used as launch token in *multiple smart launch* and as token in *token-exchange*.

### Issue: matching patient can not be found

Not offer patient specific scopes. This may further restrict what an App can access.
