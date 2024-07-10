[![Docker Build](https://github.com/ai-dock/fooocus/actions/workflows/docker-build.yml/badge.svg)](https://github.com/ai-dock/foocus/actions/workflows/docker-build.yml)

# Fooocus Docker Image

Run [Fooocus](https://github.com/lllyasviel/Fooocus) in a docker container locally or in the cloud.

>[!NOTE]  
>These images do not bundle models or third-party configurations. You should use a [provisioning script](https://github.com/ai-dock/base-image/wiki/4.0-Running-the-Image#provisioning-script) to automatically configure your container. You can find examples in `config/provisioning`.

## Documentation

All AI-Dock containers share a common base which is designed to make running on cloud services such as [vast.ai](https://link.ai-dock.org/vast.ai) as straightforward and user friendly as possible.

Common features and options are documented in the [base wiki](https://github.com/ai-dock/base-image/wiki) but any additional features unique to this image will be detailed below.


#### Version Tags

The `:latest` tag points to `:latest-cuda`

Tags follow these patterns:

##### _CUDA_
- `:v2-cuda-[x.x.x]-[base|runtime]-[ubuntu-version]`

- `:latest-cuda` &rarr; `:v2-cuda-12.1.1-base-22.04`

##### _ROCm_
- `:rocm-[x.x.x]-runtime-[ubuntu-version]`

- `:latest-rocm` &rarr; `:v2-rocm-6.0-core-22.04`

##### _CPU_
- `:cpu-ubuntu-[ubuntu-version]`

- `:latest-cpu` &rarr; `:v2-cpu-22.04` 

Browse [here](https://github.com/ai-dock/fooocus/pkgs/container/fooocus) for an image suitable for your target environment.

Supported Python versions: `3.10`

Supported Platforms: `NVIDIA CUDA`, `AMD ROCm`, `CPU`

## Additional Environment Variables

| Variable                   | Description |
| -------------------------- | ----------- |
| `AUTO_UPDATE`              | Update Fooocus on startup (default `false`) |
| `FOOOCUS_BRANCH`           | Fooocus branch/commit hash for auto update. (default `master`) |
| `FOOOCUS_FLAGS`            | Startup flags. eg. `--preset realistic` |
| `FOOOCUS_PORT_HOST`        | Web UI port (default `7865`) |
| `FOOOCUS_URL`              | Override `$DIRECT_ADDRESS:port` with URL for Web UI |

See the base environment variables [here](https://github.com/ai-dock/base-image/wiki/2.0-Environment-Variables) for more configuration options.

### Additional Python Environments

| Environment      | Packages |
| ---------------- | ----------------------------------------- |
| `fooocus`        | Fooocus and dependencies |

This environment will be activated on shell login.

~~See the base micromamba environments [here](https://github.com/ai-dock/base-image/wiki/1.0-Included-Software#installed-micromamba-environments).~~


## Additional Services

The following services will be launched alongside the [default services](https://github.com/ai-dock/base-image/wiki/1.0-Included-Software) provided by the base image.

### Fooocus

The service will launch on port `7865` unless you have specified an override with `FOOOCUS_PORT`.

If variable `AUTO_UPDATE=true`, Fooocus will be updated to the latest version on container start. You can pin the version to a branch or commit hash by setting the `FOOOCUS_BRANCH` variable.

You can set startup flags by using variable `FOOOCUS_FLAGS`.

To manage this service you can use `supervisorctl [start|stop|restart] fooocus`.

>[!NOTE]
>All services are password protected by default. See the [security](https://github.com/ai-dock/base-image/wiki#security) and [environment variables](https://github.com/ai-dock/base-image/wiki/2.0-Environment-Variables) documentation for more information.


## Pre-Configured Templates

**Vast.​ai**

- [A1111 WebUI:latest-cuda](https://link.ai-dock.org/template-vast-fooocus)

- [A1111 WebUI:latest-rocm](https://link.ai-dock.org/template-vast-fooocus-rocm)

---

_The author ([@robballantyne](https://github.com/robballantyne)) may be compensated if you sign up to services linked in this document. Testing multiple variants of GPU images in many different environments is both costly and time-consuming; This helps to offset costs_