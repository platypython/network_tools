#!/bin/bash
# HTTP timeline breakdown. Speed is broken down into kilobytes per second.
# All times are in seconds.
CURL_FORMAT=$(cat <<EOF
{
"http_code":  %{http_code},
"num_redirects": %{num_redirects},
"time_namelookup":  %{time_namelookup},
"time_connect":  %{time_connect},
"time_appconnect":  %{time_appconnect},
"time_pretransfer":  %{time_pretransfer},
"time_redirect":  %{time_redirect},
"time_starttransfer":  %{time_starttransfer},
"time_total":  %{time_total},
"speed_download_kB/s": %{speed_download},
"speed_upload_kB/s": %{speed_upload},
"url_effective": "%{url_effective}"

}
EOF)


JSON=$(curl -w "$CURL_FORMAT" -o /dev/null -L -s $1)
echo $JSON | python -c 'import json,sys;obj=json.load(sys.stdin);obj["speed_download_kB/s"]=(obj["speed_download_kB/s"]/1024);obj["speed_upload_kB/s"]=(obj["speed_upload_kB/s"]/1024);print(json.dumps(obj,indent=2, sort_keys=True))'