
# docker-altv-server

A Docker image providing the alt:V server.

## About

The Docker image for the alt:V server comes in three different versions:

- with no modules
- with the NodeJS module
- with the C# module

## Usage

Visit the image on [Docker Hub](https://hub.docker.com/r/eisengrind/altv-server).

### No modules

Starts the latest release of the server with no modules.

```sh
docker start -it eisengrind/altv-server:release
```

### NodeJS module

Starts the latest release of the server with the NodeJS module

```sh
docker start -it eisengrind/altv-server:release-nodejs
```

### C# module

Starts the latest release of the server with the C# module

```sh
docker start -it eisengrind/altv-server:release-dotnet
```

## Build

For the `$build` and `$branch` variables you have to enter the regarding alt:V versioning values.

**`$build`** represents the build number of the server source files. E.g. **`$build=1098`**

**`$branch`** represents the branch where the server build was released. E.g. **`$branch=release`**

### No modules

```sh
docker build . --build-arg BRANCH=$branch -t eisengrind/altv-server:$build
```

### NodeJS module

```sh
docker build . --build-arg BRANCH=$branch -t eisengrind/altv-server:$build
docker build . -f ./nodejs.Dockerfile --build-arg BUILD=$build --build-arg BRANCH=$branch -t eisengrind/altv-server:$build-nodejs
```

### C# module

```sh
docker build . --build-arg BRANCH=$branch -t eisengrind/altv-server:$build
docker build . -f ./dotnet.Dockerfile --build-arg BUILD=$build --build-arg BRANCH=$branch -t eisengrind/altv-server:$build-dotnet
```

## Usage with a custom Dockerfile

Most of the time if you are using containers, especially images, correctly, you will create a customized Docker image. For example by adding resources to a container which will represent a current version of your files.

You can use this images as a base for your future customizations:

```Dockerfile
FROM eisengrind/altv-server:release-nodejs

RUN mkdir -p /opt/altv/resources/test-resource
```

This example, however, just creates an empty folder within the alt:V resources folder.

## License

See the [LICENSE](https://github.com/eisengrind/docker-altv-server/blob/master/LICENSE)-file for more information.
