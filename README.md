# DEV SAAS
Bundled containers which provide SaaS tools for safe containerized development. Mainly Visual Studio Code Server and Obsidian server.

---

## Pre-requirements
To be able to build and run easily the images and the full project, the following tools must be installed:
    - Podman
    - Podman Compose
    - Crun
    - Make

## Building
Building the project and launching the containers is as simple as going to the root directory and typing: `make` Make will call the all method on the main makefile which initializes the git submodules and start the services

## Accessing the applications
After successfull build, you can use the applications locally on the following urls:  
    - [code-container](https://code-container.localhost:4430)  
    - [obsdiain](https://obsidian.localhost:4430)  
    - [caddy](https://caddy.localhost:4430)  


### Additional information:
this is a podman first project, so it adheres strictly to:
[compose-spec](https://github.com/compose-spec/compose-spec/blob/main/spec.md)
