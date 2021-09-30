# A webserver implemented in AWK. 

## Why?
Why not?

## How?
The GNU implementation of awk (gawk) has builtin tcp and udp networking support. Opening a socket or listening on one is fairly trivial.
`HttpService |& getline line` creates a bidirectional pipe that can be read from or written to. The pipe is a tpc connection because of the way the path is constructed. Since the HTTP protocol is old it is easy to handroll.
Simply check if something is a GET request and serve the file that is asked for. `realpath` is used to prevent directory escaping.

networking in awk: https://www.gnu.org/software/gawk/manual/html_node/TCP_002fIP-Networking.html

## More?
* https://github.com/svenwiltink/awk-ircBot An IRC bot in awk that ran for a good while on our company's IRC server
* https://github.com/svenwiltink/AWKvent-of-code Advent of Code partially solved in awk and prolog
