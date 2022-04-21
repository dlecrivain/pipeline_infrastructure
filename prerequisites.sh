#!/usr/bin/env bash

if [[ -f /etc/os-release ]]
then
  . /etc/os-release
else
  echo "Error1: /etc/os-release not found"
  exit 1
fi

if [[ "$ID" == "rhel" ]]
then
  echo "os family is rhel"
else
  echo "os family $ID is not yet supported"
  exit 1
fi
