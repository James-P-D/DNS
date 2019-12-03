# DNS
A simple command-line [Domain Name System (DNS)](https://en.wikipedia.org/wiki/Domain_Name_System) tool in Ruby using raw UDP packets

![Screenshot](https://github.com/James-P-D/DNS/blob/master/screenshot.gif)

## Usage

```
C:\Users\jdorr\Desktop\Dev\DNS\src>ruby -v
ruby 2.6.5p114 (2019-10-01 revision 67812) [x64-mingw32]

C:\Users\jdorr\Desktop\Dev\DNS\src>ruby DNS.rb
ruby DNS.rb domain-host lookup-host1..lookup-hostN
e.g. ruby DNS.rb 192.168.0.1 news.bbc.co.uk
e.g. ruby DNS.rb 192.168.0.1 www.facebook.com www.twitter.com www.instagram.com

C:\Users\jdorr\Desktop\Dev\DNS\src>ruby DNS.rb 192.168.0.1 www.facebook.com news.bbc.co.uk
Query www.facebook.com sent to 192.168.0.1
Response:
        Type:   5       (CNAME (Canonical NAME for an alias))
        TTL:    44
        Name:   star-mini.c10r.facebook.com
Response:
        Type:   1       (A (Host Address))
        TTL:    44
        Name:   157.240.1.35

Query news.bbc.co.uk sent to 192.168.0.1
Response:
        Type:   5       (CNAME (Canonical NAME for an alias))
        TTL:    43
        Name:   newswww.bbc.net.uk
Response:
        Type:   1       (A (Host Address))
        TTL:    43
        Name:   212.58.244.56
Response:
        Type:   1       (A (Host Address))
        TTL:    43
        Name:   212.58.249.144

Complete.
```