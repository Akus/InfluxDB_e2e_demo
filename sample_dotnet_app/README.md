docker build -t csharp-microservice:latest .
docker tag csharp-microservice:latest akosbodor/csharp-microservice:latest
docker login
docker push akosbodor/csharp-microservice:latest


dotnet restore "./MyMicroservice.csproj"
dotnet publish "./MyMicroservice.csproj" -c Release -o /app/publish
dotnet /app/publish/MyMicroservice.dll