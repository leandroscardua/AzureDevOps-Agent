Please, run the commands below to build the image

az acr login -n <acr_name>
docker build -t ado-agent:alpine .
docker tag ado-agent:alpine <acr_name>.azurecr.io/ado-agent:alpine
docker push <acr_name>.azurecr.io/ado-agent:alpine

or

az acr login -n <acr_name> --expose-token
# copy accessToken and use on the command below
nerdctl login <acr_name>.azurecr.io -u 00000000-0000-0000-0000-000000000000
# Prompt will ask to past the AccessToken
nerdctl build -t ado-agent:alpine .
nerdctl tag ado-agent:alpine <acr_name>.azurecr.io/ado-agent:alpine
nerdctl push <acr_name>.azurecr.io/ado-agent:alpine
