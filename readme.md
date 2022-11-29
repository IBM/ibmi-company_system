## Company System

Company System is a demo application that works with three build tools:

* GNU Make
* [ibmi-bob](https://ibm.github.io/ibmi-bob/#/)
* ARCAD Builder from IBM i Modernization Engine for Lifecycle Integration (Merlin)

### Setup

TODO.

### Build Commands

* GNU Make
* ibmi-bob
   * Project build `makei build`
   * Compile of files `makei compile -f {files}`
* ARCAD Builder
   * Project build `/QOpenSys/pkgs/bin/elias compile {branch}`
   * Compile of files `/QOpenSys/pkgs/bin/elias compile {branch} -f {files}`