# lab-crossplane
Repository to test and experiment with Crossplane

 ## Local Testing
  In order to test locally we could use kind with docker emulating all necessary infrastructure to bring this lab up.

  To bring everything up just use Makefile:
  `make lab-start`

  To destroy everything:
  `make lab-stop` 

  To access ArgoCD you will need to grab the initial Secret for admin user during 'lab-start' process, it will appear after: 
  `ArgoCD Admin Secret: `

 ## Dependencies using Kind
   - docker
   - kubectl 
   - helm 
   - kind
   - ArgoCD CLI (https://argo-cd.readthedocs.io/en/stable/cli_installation/)
   - Github PAT

**Obs.:** For WSL Docker Desktop will respect the resource limit of wslconfig file, if none default is 50% host memory and all logical cpus.
