#!/bin/bash

show_usage()
{
	echo "usage: scan_scroll URL" 
	exit 1
}

URL=$1
if [ x$1 == x"" ]; then
	show_usage
fi
BASE_URL=$(echo $URL | grep -o --color=never '[htps]*://[^/]*')

SCROLL_TIME=1m
OPTIONS="-k -v -g"

mkdir data
echo curl --noproxy ksekrfuat.tranzrail.co.nz ${OPTIONS} -XPOST "${URL}/_search?_search_type=scan&scroll=${SCROLL_TIME}" -d '{"query":{"match_all":{}},"size":100}'
curl --noproxy "*" ${OPTIONS} "${URL}/_search?_search_type=scan&scroll=${SCROLL_TIME}" -d '{"query":{"match_all":{}},"size":100}' > out.json

count=0
while $(true)
do
	scroll_id=$(jq < out.json '._scroll_id' | tr -d [\"])
	BULK=data/bulk-${count}.json
	count=$((count + 1))
	jq -r -c < out.json '.hits.hits[] | "{\"create\": {\"_index\":\"\(._index)\", \"_type\":\"\(._type)\", \"_id\":\"\(._id)\"}}\n\(._source)"' > ${BULK}
	if [ ! -s ${BULK} ]
	then
		rm ${BULK}
		break
	fi
	echo curl --noproxy ksekrfuat.tranzrail.co.nz ${OPTIONS} -XPOST "${BASE_URL}/_search/scroll?scroll=${SCROLL_TIME}" -d "$scroll_id"
	curl --noproxy "*" ${OPTIONS} "${BASE_URL}/_search/scroll?scroll=${SCROLL_TIME}" -d "$scroll_id" > out.json
done

