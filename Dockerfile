FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

COPY ["Example.csproj", "./"]
RUN dotnet restore "Example.csproj"

COPY . .
RUN dotnet publish "Example.csproj" -c Release -o out

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS migration-env
WORKDIR /app

RUN dotnet tool install --global dotnet-ef
ENV PATH="${PATH}:/root/.dotnet/tools"

COPY --from=build-env /app/out .
COPY --from=build-env /app/Example.csproj .

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build-env /app/out .


ENTRYPOINT [ "dotnet", "Example.dll" ]
