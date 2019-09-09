 ## The idea
This minimalistic NodeJS app creates a signed JWT token which can work as Bearer Authentication in Qlik Sense Enterprise on Kubernetes. It allows you to **impersonate as the user you want** and to automate API calls that otherwise are not possible. Handle with caution.
You can do this directly using https://jwt.io if you provide the relevant JWT header-keys and JWT payload entries. In this case, you don't have to use my NodeJS app. Create the key pair (next section) and then continue to read at "Using JWT.IO" then.

This tool runs in two different modes
 - locally (you will need nodejs and npm installed)
 - as Kubernetes Pod (you need to have kubectl access to your Kubernetes cluster)
To get started download this entire folder (get the whole git and use folder “jwtcreate”)

## Create public and private SSH key pair
If you want to skip this step for a quick test, you may use the attached priv.key and pub.key although this compromises your security!
Any SSH key pair would work. To create a new one (under Linux) execute these commands
```
openssl genrsa -out priv.key 4096
openssl rsa -in priv.key -pubout -out pub.key
```
## Configure QSEoK Identity provider
Edit the .yaml file which you last used to install or upgrade your Qlik Sense Enterprise on Kubernetes with helm. If you are not certain what the last helm configuration was, use this command to create a current qliksense.yaml file: (qlik in below example is the name of the deployment, yours could be different such as qliksense or qseok)
```
helm get values qlik >qliksense.yaml
``` 
Edit the .yaml and find the section for "identity-providers". You should find a section "identity-providers" already, otherwise your QSEoK installation is not ready to be used yet. There is already a "hostname" configured within that section. Remember that one and use the same hostname, when you insert the text below. There are 4 very important settings:
 * hostname -> this defines which tenant the user is assigned to. Use the same hostname as the one you already had 
 * realm -> this defines the "part before the \" of the userid. Use the same as you already had
 * kid -> choose one and use it later in the webservice or on jwt.io
 * pem -> The content of your pub.key file has to go in here

The yaml file should look like this (adjust hostname, realm, kid, and pem accordingly)
```
identity-providers:
  secrets:
    idpConfigs:
      - hostname: "51.141.29.221"
        realm: "Auth0" #
        primary: false
        issuerConfig:
          issuer: "https://qlik.api.internal"
        staticKeys:
        - kid: "my-key-identifier"
          pem: |-
            -----BEGIN PUBLIC KEY-----
            MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEApcxutPf8kK6TK4cX4abY
            EArPDVngZBqww7H9tOWhU+micMkRMQhyMnxYFhPIF/BHrdDQ5ph8W6zzggVyk8k+
            WiY/BHec3nGIgoXbe/5K45ChJhhrMj9CCJqHd1Q3stxfEMkwWupiJ8DDsUgqMfVz
            t8ufBiKtnLw5v51T6+8Or9TgZ5L+vnAc+uW5RbDT5iAPT2Zqapk4aYU4B9bVY0t0
            D5T2s56HmdzTYG8OvUsjdkMRUGvZmD358upX0jG0sRdQZC68Ej92yMZNJFZh+w+E
            9Q525ZNah4piioP/4714FAfjh8rU0T1ndrXbhgyWHbTXRlLJ8B4oyFgi+XyjFZLP
            hwOp25QMV08t2Lwn4g8aMW7lz0jYSTSETJF6rWIspwc7iSQ6KNtogJyyphxIRi2E
            XXgPJScSf8YeGDqFYXaGd4ysoRWgOKnEY69dYRT805YzGpr6NLcXZJ3SMYoJS6NI
            1OAlOSUdRCLWs67WtlHb3g1zCD20/0AV8TAo7Yvah2WKzBtKnDzQNKa/RK5ahQ+a
            +O692il39bR/3E+EEvBseCLwqhJpyJ5IgXjFiIAj56mdbSMj8xRof/mrYN2ofr2A
            4zl7HanxuF79w+G70RE9Y7my4zA9jlAFyVABD8Iuee+sSh8OQXMqLCa+8wmgrejC
            SJxIUvPgQpuWgVRrDQMHobMCAwEAAQ==
            -----END PUBLIC KEY-----
```
Then apply the new setting with this command. Note "qlik" and "qlik-stable" may be called differently, to learn the name of you picked for the deployment execute "helm list", to learn the name of your repository execute "helm repo list".
```
helm upgrade --install qlik qlik-stable/qliksense -f qliksense.yaml
```
Next you can choose to either use
 - jwt.io to <a href="https://github.com/ChristofSchwarz/qs_on_Kubernetes/blob/master/jwtcreate/jwt_io.md">create the tokens</a> (no further config needed but lots of copy/paste before you get the key)
 - run this NodeJS app locally (outside the Cluster)
 - run in Kubernetes cluster 
 
Choose your way. 
