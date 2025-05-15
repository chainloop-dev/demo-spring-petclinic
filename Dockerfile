FROM bellsoft/liberica-runtime-container:jdk-21-stream-musl as builder
WORKDIR /home/app
COPY target/*.jar .

FROM bellsoft/liberica-runtime-container:jdk-21-stream-musl as optimizer
WORKDIR /home/app
COPY --from=builder /home/app/*.jar petclinic.jar
RUN java -Djarmode=layertools -jar petclinic.jar extract

FROM bellsoft/liberica-runtime-container:jre-21-stream-musl
ENTRYPOINT ["java", "org.springframework.boot.loader.launch.JarLauncher"]
COPY --from=optimizer /home/app/dependencies/ ./
COPY --from=optimizer /home/app/spring-boot-loader/ ./
COPY --from=optimizer /home/app/snapshot-dependencies/ ./
COPY --from=optimizer /home/app/application/ ./
