echo "Script to connect to OCP cluster and run the templates"
echo $0
echo "Using user: "$1
echo "Using password: "$2
echo "Using url: https://api."%$3%":6443"
oc login -u $1 -p $2 https://api.$3:6443