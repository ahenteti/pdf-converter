#!/usr/bin/env bash

usage() {
  printf "Usage: %s [OPTION...]\n" "$0"
  cat >&2 << EOF

Convert pdf files to images/video

OPTIONs
 -h, --help                       show this help manuel
 -i, --install-dependencies       install dependencies
  
EOF
  exit 0
}

scriptRepo=$(dirname "$0")
currentDirectry=$PWD
installDependencies=false;

OPTS=$(getopt -o hi --long help,install-dependencies -n 'parse-options' -- "$@")
if [ $? != 0 ]; then
  echo "Failed parsing options." >&2; exit 1
fi
eval set -- "$OPTS"

while true; do
  case "$1" in
    -h | --help )
      usage; shift ;;
    -i | --install-dependencies )
      installDependencies=true; shift ;;
    -- )
      shift; break ;;
    * )
      break ;;
  esac
done

if [ "$installDependencies" = "true" ]; then
  echo "install dependencies..."
  cd $scriptRepo
  mvn clean install > /dev/null
  cd images-to-video
  npm install > /dev/null
  cd $currentDirectry
fi

echo "remove not pdf files present in the current foolder..."
find . -type f ! -name '*.pdf' -delete

for pdf in *.pdf; do
  echo "convert $pdf to images..."
  java -jar "$scriptRepo/pdf-to-images/dist/standalone.jar" "$pdf"
  echo "convert images to video..."
  node "$scriptRepo/images-to-video/index.js" "$currentDirectry"
done
