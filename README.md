# cURL File Resource

Tracks the update of a single URL-addressable file.

This is a useful resource for pipeline development time, while a required artifact is available only from a URL-addressable location and until it is moved to a file management repository such as [git](https://github.com/concourse/git-resource) or [S3](https://github.com/concourse/s3-resource).  

## Source Configuration

* `url`: *Required.* The url location of the file.

* `filename`: *Optional.* The name of the file for the downloaded artifact to be save as. If not provided, the file will be saved using the full url string as its name.

* `config`: *Optional.* String to be used as a configuration file for `curl --config`.

### Example

Resource configuration:

``` yaml
resource_types:
- name: file-url
  type: registry-image
  source:
    repository: ghcr.io/3dhubs/concourse-curl-resource
    tag: master

resources:
- name: my-file
  type: file-url
  source:
    url: https://www.apache.org/dist/lucene/java/5.5.4/lucene-5.5.4-src.tgz
    filename: lucene-5.5.4-src.tgz

- name: file-requiring-auth
  type: file-url
  source:
    url: https://www.apache.org/dist/lucene/java/5.5.4/lucene-5.5.4-src.tgz
    filename: lucene-5.5.4-src.tgz
    config: |
      user username:password
```

## Behavior

### `check`: Check for the latest version of the file.

The resource uses `curl` under-the-covers to post a GET request and retrieve the HTTP header info for the file URL provided.  
If field `Last-Modified` is returned as part of the HTTP response header, then the resource will use that to build a version number timestamp with format "YYYYMMDDHHMMSS".

Otherwise, the timestamp string will be built using the request's current time, which will result in a new version being returned every time `check` is executed for that file.

To verify if a file URL returns the `Last-Modified` information in its HTTP response header, issue the `curl` command below and search for field "Last-Modified" in its output.

```curl -I <file-url>```


### `in`: Download the latest version of the file.

Downloads the latest version of the file issuing a `curl` command under-the-covers.


### `out`: Not supported.
