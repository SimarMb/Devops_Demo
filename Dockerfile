#getting base image from ubuntu
FROM ubuntu

MAINTAINER Anilkumar <anilkumar.mechanical3@gmail.com>

EXPOSE 8080
#ADD target/maven-0.0.1.jar maven-0.0.1.jar
#ENTRYPOINT ["java","-jar","/maven-0.0.1.jar"]
CMD ["echo", "Hello world...! from my first docker image"]
