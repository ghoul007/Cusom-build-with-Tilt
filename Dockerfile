FROM node:12

WORKDIR /src

COPY package.json .
# COPY yarn.lock .
RUN yarn install --frozen-lockfile

ADD . /src

EXPOSE 4200

ENTRYPOINT yarn start