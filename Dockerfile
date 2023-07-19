FROM openjdk:17

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
