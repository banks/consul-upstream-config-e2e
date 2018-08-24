#! /bin/bash

pushd api-payloads

for i in deprecated-managed-payload.json new-managed-payload.json new-proxy-payload.json deprecated-proxy-payload.json; do
  echo "Registering $i"
  if ! curl -fi -X PUT -d @$i 'http://localhost:8500/v1/agent/service/register' ; then
    echo ""
    echo "Failed to PUT $i"
    exit 1
  fi
done

popd

echo DONE