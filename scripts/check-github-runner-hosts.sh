#!/bin/bash

echo "================================================================="
echo "  Checking ping on github.com"
echo "================================================================="
ping -c 4 "github.com"
if [ $? -ne 0 ]; then
  echo "Ping failed"
  exit 1
fi

echo "================================================================="
echo "  Checking ping on api.github.com"
echo "================================================================="
ping -c 4 "api.github.com"
if [ $? -ne 0 ]; then
  echo "Ping failed"
  exit 1
fi

# echo "================================================================="
# echo "  Checking ping on *.actions.githubusercontent.com"
# echo "================================================================="
# ping -c 4 "*.actions.githubusercontent.com"
# if [ $? -ne 0 ]; then
#   echo "Ping failed"
#   exit 1
# fi


echo "================================================================="
echo "  Checking ping on codeload.github.com"
echo "================================================================="
ping -c 4 "codeload.github.com"
if [ $? -ne 0 ]; then
  echo "Ping failed"
  exit 1
fi

echo "================================================================="
echo "  Checking ping on pkg.actions.githubusercontent.com"
echo "================================================================="
ping -c 4 "pkg.actions.githubusercontent.com"
if [ $? -ne 0 ]; then
  echo "Ping failed"
  exit 1
fi


echo "================================================================="
echo "  Checking ping on ghcr.io"
echo "================================================================="
ping -c 4 "ghcr.io"
if [ $? -ne 0 ]; then
  echo "Ping failed"
  exit 1
fi


echo "================================================================="
echo "  Checking ping on results-receiver.actions.githubusercontent.com"
echo "================================================================="
ping -c 4 "results-receiver.actions.githubusercontent.com"
if [ $? -ne 0 ]; then
  echo "Ping failed"
  exit 1
fi

# echo "================================================================="
# echo "  Checking ping on *.blob.core.windows.net"
# echo "================================================================="
# ping -c 4 "*.blob.core.windows.net"
# if [ $? -ne 0 ]; then
#   echo "Ping failed"
#   exit 1
# fi


echo "================================================================="
echo "  Checking ping on objects.githubusercontent.com"
echo "================================================================="
ping -c 4 "objects.githubusercontent.com"
if [ $? -ne 0 ]; then
  echo "Ping failed"
  exit 1
fi

echo "================================================================="
echo "  Checking ping on objects-origin.githubusercontent.com"
echo "================================================================="
ping -c 4 "objects-origin.githubusercontent.com"
if [ $? -ne 0 ]; then
  echo "Ping failed"
  exit 1
fi

echo "================================================================="
echo "  Checking ping on github-releases.githubusercontent.com"
echo "================================================================="
ping -c 4 "github-releases.githubusercontent.com"
if [ $? -ne 0 ]; then
  echo "Ping failed"
  exit 1
fi

echo "================================================================="
echo "  Checking ping on github-registry-files.githubusercontent.com"
echo "================================================================="
ping -c 4 "github-registry-files.githubusercontent.com"
if [ $? -ne 0 ]; then
  echo "Ping failed"
  exit 1
fi


# echo "================================================================="
# echo "  Checking ping on *.actions.githubusercontent.com"
# echo "================================================================="
# ping -c 4 "*.actions.githubusercontent.com"
# if [ $? -ne 0 ]; then
#   echo "Ping failed"
#   exit 1
# fi


# echo "================================================================="
# echo "  Checking ping on *.pkg.github.com"
# echo "================================================================="
# ping -c 4 "*.pkg.github.com"
# if [ $? -ne 0 ]; then
#   echo "Ping failed"
#   exit 1
# fi

echo "================================================================="
echo "  Checking ping on pkg-containers.githubusercontent.com"
echo "================================================================="
ping -c 4 "pkg-containers.githubusercontent.com"
if [ $? -ne 0 ]; then
  echo "Ping failed"
  exit 1
fi

echo "================================================================="
echo "  Checking ping on ghcr.io"
echo "================================================================="
ping -c 4 "ghcr.io"
if [ $? -ne 0 ]; then
  echo "Ping failed"
  exit 1
fi


echo "================================================================="
echo "  Checking ping on github-cloud.githubusercontent.com"
echo "================================================================="
ping -c 4 "github-cloud.githubusercontent.com"
if [ $? -ne 0 ]; then
  echo "Ping failed"
  exit 1
fi

echo "================================================================="
echo "  Checking ping on github-cloud.s3.amazonaws.com"
echo "================================================================="
ping -c 4 "github-cloud.s3.amazonaws.com"
if [ $? -ne 0 ]; then
  echo "Ping failed"
  exit 1
fi


echo "================================================================="
echo "  Checking ping on dependabot-actions.githubapp.com"
echo "================================================================="
ping -c 4 "dependabot-actions.githubapp.com"
if [ $? -ne 0 ]; then
  echo "Ping failed"
  exit 1
fi


