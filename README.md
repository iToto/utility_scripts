utility_scripts
===============

Scripts for all kinds of things useful and useless things.

## Benchmark Tools

### multithreadHTTPRequest.rb

Synopsis:

    Spawns a variable number of threads that send a request to the url passed.
    Keeps making call until a HTTP status code other then 200 is returned.

Usage:

`>ruby {:URL} {:NUM_OF_THREADS}`

