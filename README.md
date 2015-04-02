# elasticsearch-tools
Scripts for various Elasticsearch maintenance
## Elasticsearch Scroll Export to Bulk Format

Sometimes you just want to export all of the data for an Elasticsearch index or type and reload (e.g. after creating a new mapping). But the data as exported by the scan/scroll API in not in a useful format for the bulk load API. So this is a script to export and convert the files at the same time.

This script requires **jq**, a very nice utility for dealing with JSON files that you can find at [http://stedolan.github.io/jq/](http://stedolan.github.io/jq/)

Example:

`sh scroll-to-bulk.sh http://localhost:9200/myindex/mytype`

Files in the Elasticsearch bulk format will appear in a directory called data.

