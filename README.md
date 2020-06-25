
# CDK NodeJS

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/udondan/cdk-nodejs)][releases]
[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/udondan/cdk-nodejs)][hub]
[![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/udondan/cdk-nodejs)][hub-builds]
[![Docker Pulls](https://img.shields.io/docker/pulls/udondan/cdk-nodejs)][hub]
[![GitHub](https://img.shields.io/github/license/udondan/cdk-nodejs)][MITlicense]

Run CDK application. Diff, deploy, synth, destroy, ...

## Examples

### GitHub workflow

```yml
---
name: Deploy

on:
  push:
    branches:
      - master
  pull_request:
    branches:
      - master

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v2
        with:
          fetch-depth: 1

      - name: Deploy
        uses: udondan/cdk-nodejs@v0.3.1
        with:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

This will execute on the root directory of the repository:

- `npm i`
- `npm run build`
- `cdk deploy --require-approval never`

If you want to run the action against a subdirectory of the repo, you can specify the directory:

```yml
      - name: Deploy
        uses: udondan/cdk-nodejs@v0.3.1
        with:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          SUBDIR: some/sub/directory
```

By default the action will run a `deploy`. In case you want to run any other process, you can specific the command via `args`:

```yml
      - name: Destroy
        uses: udondan/cdk-nodejs@v0.3.1
        with:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          args: cdk destroy --force
```

### Running the Docker image locally

```bash
# DEPLOY
docker run -it \
    -v $(PWD):/workdir \
    --workdir /workdir \
    -e AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY \
    udondan/cdk-nodejs:0.3.1

# DESTROY
docker run -it \
    -v $(PWD):/workdir \
    --workdir /workdir \
    -e AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY \
    udondan/cdk-nodejs:0.3.1 \
    cdk destroy
```

The package code can be mounted to any location in the container. Just make sure you set the workdir to the same value. In the example above I use `/workdir`.

Parameters passed per env:

- **AWS_ACCESS_KEY_ID**: AWS access key associated with an IAM user
- **AWS_SECRET_ACCESS_KEY**: Secret key associated with the access key
- **AWS_DEFAULT_REGION**: AWS Region to send the request to. Default: `us-east-1`
- **SUBDIR**: Subdirectory of the repository to change to, before running the action
- **DEBUG**: If `true`, debug mode is enabled. **Might leak secrets in output**.

# Required permissions

CDK needs to be able to interact with the cloudformation service and upload contents to a staging S3 bucket. Additionally you need to allow all actions you expect CloudFormation to do for you. Here is an example policy:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "cloudformation:*"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Condition": {
                "ForAnyValue:StringEquals": {
                    "aws:CalledVia": [
                        "cloudformation.amazonaws.com"
                    ]
                }
            },
            "Action": "*",
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::cdktoolkit-stagingbucket-*",
            "Effect": "Allow"
        }
    ]
}
```

## License

The project is licensed under [MIT][MITlicense].

   [hub]: https://hub.docker.com/r/udondan/cdk-nodejs
   [hub-builds]: https://hub.docker.com/r/udondan/cdk-nodejs/builds
   [releases]: https://github.com/udondan/cdk-nodejs/releases
   [MITlicense]: https://github.com/udondan/cdk-nodejs/blob/master/LICENSE
