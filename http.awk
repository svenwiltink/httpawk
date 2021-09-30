BEGIN {
	FILE_DIRECTORY = "/home/swiltink/httpawk/public/";
	RS = ORS = "\r\n";
	HttpService = "/inet/tcp/80/0/0";
	while (1) {
		print "handling request";
		while ((HttpService |& getline line) > 0 ) {
			print "parsing line";
			split(line, parts, " ");
			if (parts[1] == "GET") {
				print "parsing GET line";
				path = parts[2];
				path = urlDecode(path);
				path = substr(path, 2);
				fullpath = FILE_DIRECTORY path;

				fullpath = trim(fullpath);

				"realpath " fullpath | getline realpath;

				realpath = trim(realpath);

				if (realpah != fullpaht) {
					print "not a real path: " fullpath;
					print "HTTP/1.0 5404 FILENOTFOUND" |& HttpService;
					break;	
				}

				if (system("test -f " fullpath) != 0) {
					print "file not found: " fullpath;
					print "HTTP/1.0 404 FILENOTFOUND" |& HttpService;
					break;	
				}

				totalfile = "";
				while ((getline fileline < fullpath) > 0) {
					totalfile = totalfile fileline;	
				}

				close(fullpath);

				Len = length(totalfile) + length(ORS);
				print "HTTP/1.0 200 OK "		|& HttpService;
				print "Content-Length: " Len ORS 	|& HttpService;
				print totalfile ORS 			|& HttpService;
			}	
		}

		close(HttpService);
	}
}

function urlDecode(url) {
	for (i = 0x20; i <  0x40; ++i) {
		repl = sprintf("%c", i);
		if ((repl == "&") || (repl == "\\")) {
			repl = "\\" repl;	
		}
		url = gensub(sprintf("%%%02X", i), repl, "g", url);
		url = gensub(sprintf("%%%02X", i), repl, "g", url);
	}	
	return url;
}

function ltrim(s) {sub(/^[ \t\r\n]+/, "", s); return s;}
function rtrim(s) {sub(/[ \t\r\n]+$/, "", s); return s;}
function trim(s) {return rtrim(ltrim(s));}
