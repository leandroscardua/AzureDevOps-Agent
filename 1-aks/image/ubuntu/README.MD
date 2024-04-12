Please, run the commands below to build the image

az acr login -n <acr_name>
docker build -t ado-agent:ubuntu22 .
docker tag ado-agent:ubuntu22 <acr_name>.azurecr.io/ado-agent:ubuntu22
docker push <acr_name>.azurecr.io/ado-agent:ubuntu22

or

az acr login -n <acr_name> --expose-token
# copy accessToken and use on the command below
nerdctl login <acr_name>.azurecr.io -u 00000000-0000-0000-0000-000000000000
# Prompt will ask to past the AccessToken
nerdctl build -t ado-agent:ubuntu22 .
nerdctl tag ado-agent:ubuntu22 <acr_name>.azurecr.io/ado-agent:ubuntu22
nerdctl push <acr_name>.azurecr.io/ado-agent:ubuntu22
