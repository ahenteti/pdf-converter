#!/usr/bin/env bash

usage() {
  printf "Usage: %s [OPTION...]\n" "$0"
  cat >&2 << EOF

Convert pdf files to images/video

OPTIONs
 -h, --help                       show this help manuel
 -r, --recompile-dependencies     recompile dependencies
  
EOF
  exit 0
}

scriptRepo=$(dirname "$0")
currentDirectry=$PWD
recompileDependencies=false;

OPTS=$(getopt -o hr --long help,recompile-dependencies -n 'parse-options' -- "$@")
if [ $? != 0 ]; then
  echo "Failed parsing options." >&2; exit 1
fi
eval set -- "$OPTS"

while true; do
  case "$1" in
    -h | --help )
      usage; shift ;;
    -r | --recompile-dependencies )
      recompileDependencies=true; shift ;;
    -- )
      shift; break ;;
    * )
      break ;;
  esac
done

if [ "$recompileDependencies" = "true" ]; then
  echo "recomile dependencies..."
  cd $scriptRepo
  mvn clean install > /dev/null
  cd $currentDirectry
fi

echo "remove not pdf files present in the current foolder..."
find . -type f ! -name '*.pdf' -delete

for pdf in *.pdf; do
  echo "convert $pdf to images..."
  java -jar "$scriptRepo/pdf-to-images/dist/standalone.jar" "$pdf"
done
