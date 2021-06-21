#!/bin/bash

# general alt:V server options
ALTV_SERVER_NAME=${ALTV_SERVER_NAME:-"Alt:V Server on Docker!"}
ALTV_SERVER_HOST=${ALTV_SERVER_HOST:-"0.0.0.0"}
ALTV_SERVER_PORT=${ALTV_SERVER_PORT:-"7788"}
ALTV_SERVER_PLAYERS=${ALTV_SERVER_PLAYERS:-"10"}
ALTV_SERVER_PASSWORD=${ALTV_SERVER_PASSWORD:-""}
ALTV_SERVER_ANNOUNCE=${ALTV_SERVER_ANNOUNCE:-"false"}
ALTV_SERVER_TOKEN=${ALTV_SERVER_TOKEN:-""}
ALTV_SERVER_GAMEMODE=${ALTV_SERVER_GAMEMODE:-"none"}
ALTV_SERVER_WEBSITE=${ALTV_SERVER_WEBSITE:-""}
ALTV_SERVER_LANGUAGE=${ALTV_SERVER_LANGUAGE:-"en"}
ALTV_SERVER_DESCRIPTION=${ALTV_SERVER_DESCRIPTION:-"A Alt:V server running in a Docker container."}
ALTV_SERVER_MODULES=${ALTV_SERVER_MODULES:-"csharp-module,js-module"}
ALTV_SERVER_RESOURCES=${ALTV_SERVER_RESOURCES:-""}
ALTV_SERVER_LOG_PATH=${ALTV_SERVER_LOG_PATH:-""}
ALTV_SERVER_NO_LOGFILE=${ALTV_SERVER_NO_LOGFILE:-"true"}
ALTV_SERVER_JUSTPACK=${ALTV_SERVER_JUSTPACK:-""}
ALTV_SERVER_DEBUG=${ALTV_SERVER_DEBUG:-"false"}
ALTV_SERVER_EARLYAUTH_URL=${ALTV_SERVER_EARLYAUTH_URL:-""}

# alt:V server voice options
ALTV_SERVER_VOICE_BITRATE=${ALTV_SERVER_VOICE_BITRATE:-""}
ALTV_SERVER_VOICE_EXTERNAL_SECRET=${ALTV_SERVER_VOICE_EXTERNAL_SECRET:-""}
ALTV_SERVER_VOICE_EXTERNAL_HOST=${ALTV_SERVER_VOICE_EXTERNAL_HOST:-""}
ALTV_SERVER_VOICE_EXTERNAL_PORT=${ALTV_SERVER_VOICE_EXTERNAL_PORT:-""}
ALTV_SERVER_VOICE_EXTERNAL_PUBLIC_HOST=${ALTV_SERVER_VOICE_EXTERNAL_PUBLIC_HOST:-""}
ALTV_SERVER_VOICE_EXTERNAL_PUBLIC_PORT=${ALTV_SERVER_VOICE_EXTERNAL_PUBLIC_PORT:-""}

# alt:V server CDN options
ALTV_SERVER_CDN_URL=${ALTV_SERVER_CDN_URL:-""}

# alt:V .NET 3.1 / 5.0 options
ALTV_SERVER_DOTNET_VERSION=${ALTV_SERVER_DOTNET_VERSION:-"5"}

if [ ! -z "$ALTV_SERVER_PASSWORD" ]; then
    ALTV_SERVER_PASSWORD="password: $ALTV_SERVER_PASSWORD"
fi

if [ ! -z "$ALTV_SERVER_TOKEN" ]; then
    ALTV_SERVER_TOKEN="token: $ALTV_SERVER_TOKEN"
fi

if [ ! -z "$ALTV_SERVER_WEBSITE" ]; then
    ALTV_SERVER_WEBSITE="website: $ALTV_SERVER_WEBSITE"
fi

if [ ! -z "$ALTV_SERVER_LOG_PATH" ]; then
    ALTV_SERVER_LOG_PATH="--logfile $ALTV_SERVER_LOG_PATH"
fi

if [ "$ALTV_SERVER_NO_LOGFILE" = "true" ]; then
    ALTV_SERVER_NO_LOGFILE="--no-logfile"
else
    ALTV_SERVER_NO_LOGFILE=""
fi

if [ "$ALTV_SERVER_JUSTPACK" = "true" ]; then
    ALTV_SERVER_JUSTPACK="--justpack"
fi

if [ ! -z "$ALTV_SERVER_CDN_URL" ]; then
    ALTV_SERVER_CDN_URL="useCdn: true
cdnUrl: \"$ALTV_SERVER_CDN_URL\""
fi

voiceCfg=""

if [ ! -z "$ALTV_SERVER_VOICE_BITRATE" ] || \
   [ ! -z "$ALTV_SERVER_VOICE_EXTERNAL_SECRET" ] || \
   [ ! -z "$ALTV_SERVER_VOICE_EXTERNAL_HOST" ] || \
   [ ! -z "$ALTV_SERVER_VOICE_EXTERNAL_PORT" ] || \
   [ ! -z "$ALTV_SERVER_VOICE_EXTERNAL_PUBLIC_HOST" ] || \
   [ ! -z "$ALTV_SERVER_VOICE_EXTERNAL_PUBLIC_PORT" ]; then

   if [ ! -z "$ALTV_SERVER_VOICE_BITRATE" ]; then
    ALTV_SERVER_VOICE_BITRATE="bitrate: $ALTV_SERVER_VOICE_BITRATE"
   fi

   if [ ! -z "$ALTV_SERVER_VOICE_EXTERNAL_SECRET" ]; then
    ALTV_SERVER_VOICE_EXTERNAL_SECRET="externalSecret: $ALTV_SERVER_VOICE_EXTERNAL_SECRET"
   fi

   if [ ! -z "$ALTV_SERVER_VOICE_EXTERNAL_HOST" ]; then
    ALTV_SERVER_VOICE_EXTERNAL_HOST="externalHost: $ALTV_SERVER_VOICE_EXTERNAL_HOST"
   fi

   if [ ! -z "$ALTV_SERVER_VOICE_EXTERNAL_PORT" ]; then
    ALTV_SERVER_VOICE_EXTERNAL_PORT="externalPort: $ALTV_SERVER_VOICE_EXTERNAL_PORT"
   fi

   if [ ! -z "$ALTV_SERVER_VOICE_EXTERNAL_PUBLIC_HOST" ]; then
    ALTV_SERVER_VOICE_EXTERNAL_PUBLIC_HOST="externalPublicHost: $ALTV_SERVER_VOICE_EXTERNAL_PUBLIC_HOST"
   fi

   if [ ! -z "$ALTV_SERVER_VOICE_EXTERNAL_PUBLIC_PORT" ]; then
    ALTV_SERVER_VOICE_EXTERNAL_PUBLIC_PORT="externalPublicPort: $ALTV_SERVER_VOICE_EXTERNAL_PUBLIC_PORT"
   fi

   if [ ! -z "$ALTV_SERVER_EARLYAUTH_URL" ]; then
    ALTV_SERVER_EARLYAUTH_URL="useEarlyAuth: true
earlyAuthUrl: \"$ALTV_SERVER_EARLYAUTH_URL\""
   fi

   voiceCfg="voice: {
    $ALTV_SERVER_VOICE_BITRATE
    $ALTV_SERVER_VOICE_EXTERNAL_SECRET
    $ALTV_SERVER_VOICE_EXTERNAL_HOST
    $ALTV_SERVER_VOICE_EXTERNAL_PORT
    $ALTV_SERVER_VOICE_EXTERNAL_PUBLIC_HOST
    $ALTV_SERVER_VOICE_EXTERNAL_PUBLIC_PORT
}
"
fi

if [ "$ALTV_SERVER_DOTNET_VERSION" = "5" ]; then

cat <<EOF >/opt/altv/AltV.Net.Host.runtimeconfig.json
{
  "runtimeOptions": {
    "tfm": "net5.0",
    "framework": {
      "name": "Microsoft.NETCore.App",
      "version": "5.0.0"
    }
  }
}
EOF

else

# we assume dotnet version 3 to be the default
cat <<EOF >/opt/altv/AltV.Net.Host.runtimeconfig.json
{
  "runtimeOptions": {
    "tfm": "netcoreapp3.1",
    "framework": {
      "name": "Microsoft.NETCore.App",
      "version": "3.1.0"
    }
  }
}
EOF

fi

cat <<EOF >/opt/altv/server.cfg
name: "$ALTV_SERVER_NAME"
host: "$ALTV_SERVER_HOST"
port: $ALTV_SERVER_PORT
debug: $ALTV_SERVER_DEBUG
players: $ALTV_SERVER_PLAYERS
announce: $ALTV_SERVER_ANNOUNCE
gamemode: "$ALTV_SERVER_GAMEMODE"
language: "$ALTV_SERVER_LANGUAGE"
description: "$ALTV_SERVER_DESCRIPTION"
modules: [ $ALTV_SERVER_MODULES ]
resources: [ $ALTV_SERVER_RESOURCES ]

$ALTV_SERVER_EARLYAUTH_URL

$voiceCfg

$ALTV_SERVER_PASSWORD
$ALTV_SERVER_TOKEN
$ALTV_SERVER_WEBSITE
$ALTV_SERVER_CDN_URL
EOF

./altv-server --config=/opt/altv/server.cfg $ALTV_SERVER_LOG_PATH $ALTV_SERVER_NO_LOGFILE ${@:1}
