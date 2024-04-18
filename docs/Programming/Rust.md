# Rust

<!-- toc -->

## Cargo plugins

### Explore further

#### cargo-diet

<https://crates.io/crates/cargo-diet>

Trims crate size before publishing.

#### cargo-get

<https://crates.io/crates/cargo-get>

Extract version information from Cargo.toml files for CI.

#### cargo-cache

<https://crates.io/crates/cargo-cache>

Install: `cargo install cargo-cache`
Run: `cargo cache`

Cleans up the local Cargo cache. Useful.

#### cargo-udeps

<https://crates.io/crates/cargo-udeps>

Install: `cargo install cargo-udeps --locked`
Run: `cargo +nightly udeps`

Finds unused dependencies.

* +remove cruft
* -might have false positives

#### cargo-deb

<https://crates.io/crates/cargo-deb>

Build Debian packages from Cargo projects. Looks super useful.

#### cargo-make

<https://crates.io/crates/cargo-make>

Looks interesting. It allows you to run scripts with cargo in a manner like Ant. Might be an antipattern though ...

### Maybe later

#### cargo-msrv

<https://crates.io/crates/cargo-msrv>

Install: `cargo install cargo-msrv`

Find the minimum supported rust version for a crate.

#### cargo-nextest

<https://crates.io/crates/cargo-nextest>

Install: `cargo install cargo-nextest --locked`

* +slightly faster
* +pretty output
* -one test succeeded in normal cargo test but had to be modified in cargo-nextest?

#### cargo-auditable

Meh ... embeds dependency manifest in binary. Allows you to check later with audit if an installed binary has know vulnerabilities.

#### cargo-deny

<https://crates.io/crates/cargo-deny>

* -overlaps with audit on advisories
* -alarmist

### Nah

#### cargo-audit (for fix)

Check for vulnerable dependencies. THe fix command is useless.

#### cargo-semver-checks

Great idea but seems pretty useless at the moment.

<https://crates.io/crates/cargo-semver-checks>

`cargo semver-checks check-release --baseline-rev main`

* +can check for breaking changes in CI
* -doesn't work from workspaces.

## Self signed CA problem

Sometimes you need to access a system with a self-signed root CA via SSL, and you might get errors like:

```
No response received: error trying to connect: error:1416F086:SSL
routines:tls_process_server_certificate:certificate verify failed:ssl/statem/statem_clnt.c:1919:: 
self signed certificate in certificate chain
```

If you don't own the system you are running on, but are seeing issues with self-signed certificates in the trust chain of a site you are connecting to, try this:

Copy a version of the system's CA setup to a local file, e.g.:

```shell
cp /etc/ssl/certs/ca-certificates.crt $HOME/ca-certificates.crt
```

Add the CA you want to trust to the end of the new file. The cert snippet should look something like:

```
-----BEGIN CERTIFICATE-----
MIIGTzCCBDegAwIBAgIQWAoyV+tzprJIl8dVQmA0CjANBgkqhkiG9w0BAQsFADBf
... base64 encoded nonsense ...
HSsB3yggN5bqCpTpSDGKsWU30sZ1152T/KaVwwCfzZ3e5jc=
-----END CERTIFICATE-----
```

Now export the new CA as an env var:

```
export SSL_CERT_FILE=$HOME/ca-certificates.crt
```

This should replace the system CA with your ammended CA.

## Lambda links

* Official [aws-lambda-rust-runtime](https://github.com/awslabs/aws-lambda-rust-runtime)
* [Using Rust Lambdas in Production](https://www.cvpartner.com/blog/using-rust-lambdas-in-production)
