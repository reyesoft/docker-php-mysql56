# docker reyesoft/php-mysql56

Supported versions of PHP:
- 7.1
- 7.2
- 7.3

## Build and test on local env

```bash
docker build -t hello .
docker run -it hello
```

## Test locally
docker run -it --volume=/Users/myUserName/code/localDebugRepo:/localDebugRepo --workdir="/localDebugRepo" --memory=4g --memory-swap=4g --memory-swappiness=0 --entrypoint=/bin/bash python:2.7
### https://confluence.atlassian.com/bitbucket/debug-your-pipelines-locally-with-docker-838273569.html
