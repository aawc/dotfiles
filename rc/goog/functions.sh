#!/bin/bash

function cdcd
{
  local clientName="$(echo $PWD | sed -e 's/.*\/\(.*\)\/google3.*/\1/')";
  echo "Client name: ${clientName}"
  g4d "${clientName}"
}
