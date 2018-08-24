#! /bin/bash

EXPECT=$(cat expect/expect-upstreams.json)

for i in deprecated-managed deprecated-managed-json new-managed new-managed-json new-proxy new-proxy-json; do 
  echo "==> has correct upstreams: $i"
  OUT=$(curl -s http://localhost:8500/v1/catalog/service/$i)
  if [[ $i == *-proxy* ]] ; then
    UPS=$(echo $OUT | jq '.[0].ServiceProxy.Upstreams')
  else
    UPS=$(echo $OUT | jq '.[0].ServiceConnect.Proxy.Upstreams')
  fi
  if ! diff <(echo $EXPECT) <(echo $UPS) > /dev/null ; then
    echo "FAIL: < want, > got"
    diff <(echo $EXPECT) <(echo $UPS)
    exit 1
  fi
done

for i in deprecated-proxy deprecated-proxy-json new-proxy new-proxy-json; do 
  echo "==> has correct proxy destination: $i"
  OUT=$(curl -s http://localhost:8500/v1/catalog/service/$i)
  DEST=$(echo $OUT | jq -r '.[0].ServiceProxy.DestinationServiceName')
  if [[ "$DEST" != "web" ]] ; then
    echo "FAIL: want web, got $DEST"
    exit 1
  fi
done

# Create API services too
if ! source register-api.sh ; then
  echo "FAIL: couldn't register via API"
  exit 1
fi

# Same checks again but without the non-json versions
for i in deprecated-managed-json-api new-managed-json-api new-proxy-json-api; do 
  echo "==> has correct upstreams: $i"
  OUT=$(curl -s http://localhost:8500/v1/catalog/service/$i)
  if [[ $i == *-proxy* ]] ; then
    UPS=$(echo $OUT | jq '.[0].ServiceProxy.Upstreams')
  else
    UPS=$(echo $OUT | jq '.[0].ServiceConnect.Proxy.Upstreams')
  fi
  if ! diff <(echo $EXPECT) <(echo $UPS) > /dev/null ; then
    echo "FAIL: < want, > got"
    diff <(echo $EXPECT) <(echo $UPS)
    exit 1
  fi
done

for i in deprecated-proxy-json-api new-proxy-json-api; do 
  echo "==> has correct proxy destination: $i"
  OUT=$(curl -s http://localhost:8500/v1/catalog/service/$i)
  DEST=$(echo $OUT | jq -r '.[0].ServiceProxy.DestinationServiceName')
  if [[ "$DEST" != "web" ]] ; then
    echo "FAIL: want web, got $DEST"
    exit 1
  fi
done

echo PASS