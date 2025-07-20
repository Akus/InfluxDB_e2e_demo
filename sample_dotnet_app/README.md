docker build -t csharp-microservice:latest .
docker tag csharp-microservice:latest akosbodor/csharp-microservice:latest
docker login
docker push akosbodor/csharp-microservice:latest

docker run -p 8080:8080 akosbodor/csharp-microservice akos-dotnet-3

dotnet restore "./MyMicroservice.csproj"
dotnet publish "./MyMicroservice.csproj" -c Release -o /app/publish
dotnet /app/publish/MyMicroservice.dll