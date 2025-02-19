#!/bin/bash

ok_marker=$(date +%s)
http_res_b64=$(echo -en "HTTP/1.1 200 OK\r\n\r\n$ok_marker" | base64)

cmd=''
cmd+='mkdir -p ~/public_html; '
cmd+='timeout 5 socat '
cmd+="UNIX-LISTEN:/home/$test_user/public_html/cgi-bin.sock,fork,perm-early=0666 "
cmd+="SYSTEM:'echo $http_res_b64 | base64 -d' &>/dev/null & "
cmd+="sleep 1; curl -m5 -s localhost/~$test_user/cgi-bin/test; wait"

assert $ok_marker \
    "$(test_cmd "$cmd")" \
    'user cgi should work'
