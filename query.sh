#!/bin/bash

query="$1"
psql -h localhost -U postgres -d postgres -t -c "$query;" -o output
