echo "$(podman images | grep registry.suse.com)" | while read image; do
  IMG_SRC=$(echo "$image" | awk '{print $1}')
  IMG_TAG=$(echo "$image" | awk '{print $2}')
  IMG_NAME=$(echo "${IMG_SRC}" | awk -F"/" '{ print $NF }')
  IMG_ID=$(echo "${image}" | awk '{ print $3 }')
  podman tag ${IMG_ID} regminint.suse.site:80/caasp4/${IMG_NAME}:${IMG_TAG}
  podman push regminint.suse.site:80/caasp4/${IMG_NAME}:${IMG_TAG}
done

