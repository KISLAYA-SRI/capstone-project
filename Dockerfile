FROM adoptopenjdk:11-jre-hotspot as builder
WORKDIR application
COPY Api1/target/simple-app.jar simple-app.jar
RUN java -Djarmode=layertools -jar simple-app.jar extract

FROM adoptopenjdk:11-jre-hotspot
WORKDIR application
COPY --from=builder application/dependencies/ ./
COPY --from=builder application/spring-boot-loader ./
COPY --from=builder application/snapshot-dependencies/ ./
COPY --from=builder application/application/ ./
ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]