# Building the Docker file locally:
```bash
docker build -t ruby-base .
```

# Publishing a new image for other apps to use:
- Make the required changes (e.g. update Ruby or Yarn)
- Commit, push and let CI build and publish.

# Otherwise
If goal is to update packages and nothing else changes:
- Rerun the last CircleCI pipeline from the project UI to rebuild and publish the image.

