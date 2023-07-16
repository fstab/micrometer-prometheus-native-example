#!/bin/bash

set -e

dir=$(mktemp -d -p ./test-runs/ run-XXX)

cp src/main/resources/application.properties $dir/

for mode in classic native ; do

	cp build-$mode.gradle build.gradle
	./gradlew build

	java -jar build/libs/micrometer-prometheus-native-example-0.0.1-SNAPSHOT.jar > $dir/$mode.log 2>&1 &
	pid=$!

	while ! grep 'Started MicrometerPrometheusExampleApp' $dir/$mode.log > /dev/null ; do
		sleep 1
		if grep 'APPLICATION FAILED TO START' $dir/$mode.log ; then
			cat $dir/$mode.log >&2
			kill $pid 2>&1
			exit 1
		fi
	done

	for i in {1..5}; do
		echo -n 'curl -s http://localhost:8080 -> '
		curl -s http://localhost:8080
	done

	curl -s http://localhost:8080/actuator/prometheus?debug=openmetrics > $dir/01-openmetrics-$mode.txt
	echo "Metrics written to $dir/01-openmetrics-$mode.txt"

	for i in {1..5}; do
		echo -n 'curl -s http://localhost:8080 -> '
		curl -s http://localhost:8080
	done

	curl -s http://localhost:8080/actuator/prometheus?debug=openmetrics > $dir/02-openmetrics-$mode.txt
	echo "Metrics written to $dir/02-openmetrics-$mode.txt"

	kill $pid

done
