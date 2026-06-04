# Building the Docker file locally:
```bash
docker build -t ruby-base .
docker run -it ruby-base /bin/bash

Specific versions
 docker build --build-arg RUBY_VERSION=3.4.9 --build-arg NODE_MAJOR=22 --build-arg YARN_VERSION=4.16.0 -t library/ruby-3.4.9-node-22-yarn-4.16.0 .
```

# Publishing a new image for other apps to use:
- Make the required changes (e.g. update Ruby or Yarn)
- Commit, push and let CI build and publish.

# Otherwise
If goal is to update packages and nothing else changes:
- Rerun the last CircleCI pipeline from the project UI to rebuild and publish the image.

