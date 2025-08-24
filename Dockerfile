FROM mcr.microsoft.com/dotnet/sdk:9.0 as BUILD

COPY MareAPI /server/MareAPI
COPY MareSynchronosServer/MareSynchronosShared /server/MareSynchronosServer/MareSynchronosShared
COPY MareSynchronosServer/MareSynchronosServer /server/MareSynchronosServer/MareSynchronosServer

WORKDIR /server/MareSynchronosServer/MareSynchronosServer/

RUN dotnet publish \
        --configuration=Release \
        --os=linux \
        --output=/build \
        MareSynchronosServer.csproj

FROM mcr.microsoft.com/dotnet/aspnet:9.0

RUN adduser \
        --disabled-password \
        --group \
        --no-create-home \
        --quiet \
        --system \
        mare

COPY --from=BUILD /build /opt/MareSynchronosServer
RUN chown -R mare:mare /opt/MareSynchronosServer
RUN apt-get update; apt-get install curl -y

USER mare:mare
WORKDIR /opt/MareSynchronosServer

CMD ["./MareSynchronosServer"]
