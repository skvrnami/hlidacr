## Test environments
* local macOS, R 4.0.4
* ubuntu 20.04 (on Github Actions & r-hub), R 4.0.4
* Fedora Linux, R-devel (on r-hub)
* windows (R 4.0.4 on Github Actions, 4.0.2 and 4.1.0 on win-builder)
* macOS (on Github Actions)

## R CMD check results
There were no ERRORs or WARNINGs. 

Checks on r-hub produces 1 NOTE:

Possibly mis-spelled words in DESCRIPTION:
  Hlídač (3:29, 11:55)
  Státu (3:36)
  státu (11:62)

These are not mis-spelled words, they are just words in Czech.

## Downstream dependencies
There are no downstream dependencies.
