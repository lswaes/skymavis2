# curl the API
echo '"Vulnerabilities": ' > dns.json
echo '"Vulnerabilities": ' > hyper.json
curl -X GET  "https://quay.io/api/v1/repository/coreos/dnsmasq/manifest/sha256%3A910710beddb9cf3a01fe36450b4188b160a03608786c11e0c39b81f570f55377/security" | jq '[.data.Layer.Features[] | .Vulnerabilities[]]' >> dns.json
curl -X GET  "https://quay.io/api/v1/repository/coreos/hyperkube/manifest/sha256%3Aced8ba1345b8fef845ab256b7b4d0634423363721afe8f306c1a4bc4a75d9a0c/security" | jq  '[.data.Layer.Features[] | .Vulnerabilities[]]' >> hyper.json

# Divide 2 repo
file="./repo.json"
jq -cr 'keys[] as $k | "\($k)\t\(.[$k])"' "$file"  | awk -F\\t '{ file=$1".json" ; print $2 > file ; close(file); }'
mv 0.json a.json
mv 1.json b.json

# Add files together
jq -s 'add' a.json hyper.json '.' > hyperkube.json
jq -s 'add' b.json dns.json '.' > dnsmaq.json
jq -s 'add' hyperkube.json dnsmaq.json '.' > sum.json

rm hyperkube.json dnsmaq.json hyper.json dns.json b.json a.json