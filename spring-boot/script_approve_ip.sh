## Show the Install Plan to edit:
ipname=$(oc get ip --no-headers | awk 'NR==1 {print $1}')
echo "edit the ip " $ipname

## Manually doing it:
#oc edit ip $ipname

## Automatically doing it - via patch
oc patch ip $ipname --type merge -p '{"spec":{"approved":true}}'