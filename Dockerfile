FROM quay.io/keycloak/keycloak:latest as builder

ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_FEATURES=token-exchange
ENV KC_DB=postgres
# Install custom providers
RUN curl -sL https://github.com/aerogear/keycloak-metrics-spi/releases/download/2.5.3/keycloak-metrics-spi-2.5.3.jar -o /opt/keycloak/providers/keycloak-metrics-spi-2.5.3.jar
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/
WORKDIR /opt/keycloak
# for demonstration purposes only, please make sure to use proper certificates in production instead
#RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore
# change these values to point to a running postgres instance
ENV KC_DB_URL=postgres://ldivyrmxdfzrhe:dc3db58aaa0234176913138143ac86114d42aebbd2dfd547561c53afeb5a8c58@ec2-63-32-248-14.eu-west-1.compute.amazonaws.com:5432/d8a83okpmod82a
ENV KC_DB_USERNAME=ldivyrmxdfzrhe
ENV KC_DB_PASSWORD=dc3db58aaa0234176913138143ac86114d42aebbd2dfd547561c53afeb5a8c58
ENV KC_HOSTNAME=ec2-63-32-248-14.eu-west-1.compute.amazonaws.com
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start"]