# =========================
# Etapa 1 - Build
# =========================
FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /app

# Copia arquivos do Maven
COPY pom.xml .

# Baixa dependências
RUN mvn dependency:go-offline

# Copia projeto
COPY src ./src

# Gera JAR
RUN mvn clean package -DskipTests

# =========================
# Etapa 2 - Runtime
# =========================
FROM amazoncorretto:17-alpine

WORKDIR /app

# Copia JAR gerado
COPY --from=build /app/target/*.jar app.jar

# Porta da aplicação
EXPOSE 8080

# Executa aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]