check_version() {
  # args
  local tmpd="$1"
  local url="$2"
  local args="$3"
  shift 3

  # retrieves HTTP header of file URL response
  curl -fsSL -o "$tmpd/result" -R -I --url "$url" $args
  local lastModifiedHeader=$(grep -i 'last-modified:' < "$tmpd/result")

  # Checks if field "Last-Modified" exists in HTTP header and transform it into timestamp string
  # if that field is not present, return current timestamp
  local dateVersionFormat="%Y%m%d%H%S"
  local dateString=$(date +"$dateVersionFormat")

  if test -n "$lastModifiedHeader"; then
    local lastModifiedDate="$(echo "$lastModifiedHeader" | sed 's/Last-Modified: //I' | cut -d',' -f 2)"
    local dateString="$(date +"$dateVersionFormat" -d "$lastModifiedDate")"
  fi

  echo "{\"version\":\"$dateString\"}" | jq --slurp .
}
