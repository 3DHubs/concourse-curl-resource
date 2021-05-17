#!/usr/bin/env ash

set -o errexit

source $(dirname $0)/helpers.sh

it_can_get_file_with_last_modified_info() {
  jq -n "{
    source: {
      url: \"https://httpbin.org/response-headers?last-modified=2020-02-20\"
    }
  }" | $resource_dir/check | tee /dev/stderr
}

it_can_get_file_without_last_modified_info() {
  jq -n "{
    source: {
      url: \"https://httpbin.org/html\"
    }
  }" | $resource_dir/check | tee /dev/stderr
}

it_can_get_file_with_basic_auth() {
  jq -n "{
    source: {
      url: \"https://httpbin.org/basic-auth/aerobatic/aerobatic\",
      config: \"user aerobatic:aerobatic\",
    }
  }" | $resource_dir/check | tee /dev/stderr
}

run it_can_get_file_with_last_modified_info
run it_can_get_file_without_last_modified_info
run it_can_get_file_with_basic_auth
