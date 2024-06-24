ENVFILE="dev.env"

if [ ! -f $ENVFILE ]; then
  echo "${ENVIFILE} not found."
fi  

export $(xargs < "dev.env")

echo "Initiating containers in deatched mode..."
docker-compose up -d --build
