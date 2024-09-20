```yml
stages:
  - build
  - deploy
build:
  stage:build
  image: node:18.12.0
  script:
    - npm install
    - npm run build
  artifacts:
    paths:
      - dist/
  rules:
    - if: $CI_COMMIT_BRANCH == dev-xld
deploy:
  stage:deploy
  script:
    - move dist/  C:\data\app\apache-tomcat-8.5.91\webapps\GBAFloodControlDemoPlatform-test
  rules:
    - if: $CI_COMMIT_BRANCH == dev-xld

```
