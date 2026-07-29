#使用一个已经准备好的基础环境，里面包含：
FROM maven:3.8.8-eclipse-temurin-8

#设置 Docker 容器中的工作目录为 /app
WORKDIR /app 

#把本地项目的总 pom.xml 复制到容器的 /app 目录。
#这里的 . 表示当前容器目录，也就是：
#/app
COPY pom.xml .

#把 sky-common 模块的 pom.xml 复制到容器中相同的位置。
COPY sky-common/pom.xml sky-common/pom.xml

#复制 sky-pojo 模块的 pom.xml
COPY sky-pojo/pom.xml sky-pojo/pom.xml

#复制 sky-server 模块的 pom.xml。
#前面只复制这些 pom.xml，是为了让 Docker 提前下载依赖。只要 pom.xml 没有变化，Docker 就可以复用之前的下载结果。
COPY sky-server/pom.xml sky-server/pom.xml

#让 Maven 根据 pom.xml 下载项目依赖。
#例如：Spring/BootMyBatis/Lombok/Druid/JWT/Knife4j/-DskipTests 表示暂时跳过测试。
RUN mvn dependency:go-offline -DskipTests

#把整个项目复制到容器的 /app 目录。/第一个 .：/本地项目目录/第二个 .：/容器中的 /app 目录
COPY . .
#声明这个项目使用 8080 端口。它相当于告诉 Docker：这个 Java 项目准备通过 8080 端口提供服务
EXPOSE 8080

#容器启动时执行 Maven 命令。含义是：使用 Maven启动 sky-server 模块同时启动它依赖的模块运行 Spring Boot 项目
#其中：-pl sky-server：启动 sky-server-am：同时构建它依赖的模块spring-boot:run：启动 Spring Boot 项目
CMD ["sh", "-c", "mvn -pl sky-server -am install -DskipTests && mvn -f sky-server/pom.xml spring-boot:run"]