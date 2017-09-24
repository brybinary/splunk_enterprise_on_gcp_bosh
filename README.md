### splunk: basic splunk enterprise server 6.5.1 install (full)

* BOSH deployed splunk enterprise node in GCP (via bastion)

### pre-req's & assumptions (mac)
• assumes gcp account and bosh bastion/nats env available
• bosh/cf cli tools
• mac dev tools
* xcode-select --install
install bosh cli (v2), cf-cli, bosh-init

## install bosh-cli
* brew tap cloudfoundry/tap
* brew install <cf-cli | bosh-init | bosh-cli | credhub-cli | bbl> 

### files for GCP use:
* /scripts/GCP_build-release.sh
* /packages/common/spec
* /properties.yml
* /GCP_cf-splunk-full.yml

### commands used to run this in GCP:
* ssh into the instance (on bosh)
bosh -d cf-splunk-full ssh <INSTANCE ID>
* get logs from instance(s)
bosh -d cf-splunk-full logs
* deploy 
bosh -d cf-splunk-full deploy GCP_cf-splunk-full.yml
* create release (bosh)
bosh create-release --name cf-splunk --tarball="./release.tgz" --force

## GCP BOSH process.

### assumes you already have the GCP env setup correctly

* stemcell will already exist on your director, in this case `ubuntu-trusty`

* Pull latest submodules, namely `src/splunk-firehose-nozzle`
```
git submodule update --init --recursive
```

* use deployment manifest: GCP_cf-splunk-forwarder.yml

* Create a release

    This will download [Splunk](https://www.splunk.com/download.html) and [Golang](https://golang.org/dl/) binaries (if not available already), add necessary blobs, and create the release:
```
./scripts/build-release.sh
```

* Upload & deploy release

* Iterating

    If `splunk-firehose-nozzle` submodule changed upstream, pull latest before creating the release with `./scripts/build-release.sh`:
```
git submodule update src/splunk-firehose-nozzle
(cd src/splunk-firehose-nozzle; git pull origin HEAD)
```

## Jobs

* `splunk-forwarder`: bosh managed Splunk heavy forwarder with HTTP event collector enabled
* `spunk-nozzle`: Nozzle that drains firehose logs & forwards to HEC. Should be co-located with `splunk-forwarder` 
* `splunk-full`: bosh managed Splunk search head and indexer. Intended for internal testing only (not 
HA, doesn't persist past rebuilds, etc)
