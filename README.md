# Custom Build
## Install
```
npm i moment-locales-webpack-plugin
npm i @angular-builders/dev-server
```

## Custom webpack config

```
const MomentLocalesPlugin = require('moment-locales-webpack-plugin');

module.exports = {
  plugins: [
    new MomentLocalesPlugin({
      localesToKeep: ['fr']
    })
  ]
}
```

## Angular.json

```diff
diff --git a/angular.json b/angular.json
index ff49f7c..7cb80b1 100644
--- a/angular.json
+++ b/angular.json
@@ -38,8 +38,14 @@
       "prefix": "app",
       "architect": {
         "build": {
-          "builder": "@angular-devkit/build-angular:browser",
+          "builder": "@angular-builders/custom-webpack:browser",
           "options": {
+            "customWebpackConfig":{
+              "path": "./webpack.config.js",
+              "mergeStrategies": {
+                "externals": "replace"
+              }
+            },
             "outputPath": "dist/app",
             "index": "src/index.html",
             "main": "src/main.ts",
@@ -87,7 +93,7 @@
           }
         },
         "serve": {
-          "builder": "@angular-devkit/build-angular:dev-server",
+          "builder": "@angular-builders/custom-webpack:dev-server",
           "options": {
             "browserTarget": "app:build"
           },

```


# Building K8s APP

## Dockerfile
```
FROM node:12

WORKDIR /src

COPY package.json .
# COPY yarn.lock .
RUN yarn install --frozen-lockfile

ADD . /src

EXPOSE 4200

ENTRYPOINT yarn start
```


## YML for K8s
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend-angular
  # namespace: rat-or-cat
spec:
  selector:
    matchLabels:
      app: frontend-angular
  template:
    metadata:
      labels:
        app: frontend-angular
    spec:
      containers:
        - name: frontend-angular
          image: frontend-angular
          ports:
            - containerPort: 4200
```


## Tilt file
```

docker_build('frontend-angular', '.')
k8s_yaml('serve.yaml')
k8s_resource('frontend-angular', port_forwards=4200)

```