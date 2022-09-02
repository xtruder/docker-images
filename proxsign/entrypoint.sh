#!/bin/bash
trap 'pkill socat; pkill -SIGKILL proxsign' TERM INT
socat tcp-listen:14972,reuseaddr,fork tcp:localhost:41472 &
proxsign &
PID=$!
wait $PID