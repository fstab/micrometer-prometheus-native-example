FROM openjdk:17

EXPOSE 8080

RUN microdnf install git findutils vim curl

WORKDIR /tmp

RUN git clone https://github.com/fstab/micrometer.git
WORKDIR /tmp/micrometer
RUN git checkout -t origin/prometheus-native
RUN ./gradlew publishToMavenLocal

WORKDIR /tmp

RUN git clone https://github.com/fstab/spring-boot.git
WORKDIR /tmp/spring-boot
RUN git checkout -t origin/micrometer-registry-prometheus_native
RUN ./gradlew publishToMavenLocal -x checkstyleMain -x test -x intTest -x documentationTest -x asciidoctor -x asciidoctorPdf -x asciidoctorMultipage -x :spring-boot-project:spring-boot-docs:zip -x :spring-boot-project:spring-boot-docs:publishMavenPublicationToMavenLocal

WORKDIR /tmp

RUN git clone https://github.com/fstab/micrometer-registry-prometheus_native-example.git
WORKDIR /tmp/micrometer-registry-prometheus_native-example
RUN ./gradlew build

WORKDIR /tmp

RUN curl -sOL https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v1.28.0/opentelemetry-javaagent.jar

ENV OTEL_TRACES_EXPORTER=none
ENV OTEL_METRICS_EXPORTER=none
ENV OTEL_LOGS_EXPORTER=none
CMD java -javaagent:/tmp/opentelemetry-javaagent.jar -jar /tmp/micrometer-registry-prometheus_native-example/build/libs/micrometer-registry-prometheus_native-example-0.0.1-SNAPSHOT.jar
