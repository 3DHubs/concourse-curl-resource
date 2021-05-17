#!/usr/bin/env ash

set -o errexit

source $(dirname $0)/helpers.sh
export tmpd="$(mktemp -d /tmp/test-in.XXXXXX)"

it_can_get_file_with_date_info() {
  jq -n "{
    source: {
      url: \"https://httpbin.org/json\"
    }
  }" | $resource_dir/in "$tmpd" | tee /dev/stderr

  test "$(jq -r '.slideshow.title' < "$tmpd/file")" = "Sample Slide Show"
}

it_can_get_file_with_basic_auth() {
  jq -n "{
    source: {
      url: \"https://httpbin.org/basic-auth/aerobatic/aerobatic\",
      config: \"user aerobatic:aerobatic\",
    }
  }" | $resource_dir/in "$tmpd" | tee /dev/stderr

  test "$(jq -r '.user' < "$tmpd/file")" = aerobatic
}


run it_can_get_file_with_date_info
run it_can_get_file_with_basic_auth
