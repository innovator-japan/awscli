# awscli

Docker container for CircleCI2.0 -> codedeploy.

# Supported tags
Tag is correspond to awscli version.

- `latest`
- `1.14.69`

# How to use 

This container provides `aws-s3-deploy` command, which allows you to deploy your apps with Codedeploy via Amazon S3.

You can also use this container just for `awscli` command.

## Sample config.yml

```
version: 2
jobs:
  build:
    working_directory: ~/repo
    docker:
      - image: circleci/php:7.2-apache-node-browsers
    steps:
      - checkout
      - restore_cache:
          keys:
            - composer_cache
      - run: composer install --prefer-dist
      - save_cache:
          paths:
            - "~/.composer/cache"
          key: composer_cache
      - persist_to_workspace:
          root: .
          paths:
            - .
  deploy:
    working_directory: ~/repo
    environment:
      - AWS_DEFAULT_REGION: ap-northeast-1
      - CODE_DEPLOY_S3_BUCKET_NAME: xxxx-deploy
      - CODE_DEPLOY_APPLICATION_NAME: xxxxxxx
      - CODE_DEPLOY_GROUP_NAME: xxxxxx 
      - APP_DIR: .
    docker:
      - image: innovatorjapan/awscli:latest
    steps:
      - attach_workspace:
          at: .
      - run: sh /bin/aws-s3-deploy
workflows:
  version: 2
  build_and_deploy:
    jobs:
      - build
      - deploy:
          requires:
            - build
          filters:
            branches:
              only:
                - master
```

### Note
`deploy` job uses `attach_workspace` to restore built image files from `build` job.


## Environmental variables

You need to set following variables to use `asw-s3-deploy` command.

- `AWS_DEFAULT_REGION` *required*
Set region for your codedeploy application.
- `CODE_DEPLOY_S3_BUCKET_NAME` *required*
Set s3 bucket for codedeploy. 
- `CODE_DEPLOY_APPLICATION_NAME` *required*
Set codedeploy application name.
- `CODE_DEPLOY_GROUP_NAME` *optional*
Set codedeploy application group name. `CIRCLE_BRANCH` will be used if not specified.
- `APP_DIR` *required*
Set application dir to deploy.
