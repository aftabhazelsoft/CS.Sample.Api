FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY CS.Sample.Api.csproj .
RUN dotnet restore CS.Sample.Api.csproj --disable-parallel
COPY . .
RUN dotnet build . -c Release -o /build --disable-parallel

FROM build AS publish
WORKDIR /src
RUN dotnet publish . -c Release -o /publish --disable-parallel

FROM base AS final
WORKDIR /app
COPY --from=publish /publish .
ENTRYPOINT ["dotnet", "CS.Sample.Api.dll"]