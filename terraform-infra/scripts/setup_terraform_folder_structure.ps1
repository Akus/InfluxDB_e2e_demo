# Define the base directory
$baseDir = "terraform-infra"

# Define the folder structure
$folders = @(
    "$baseDir/modules/networking",
    "$baseDir/modules/compute",
    "$baseDir/modules/storage",
    "$baseDir/modules/monitoring",
    "$baseDir/envs/development",
    "$baseDir/envs/staging",
    "$baseDir/envs/production",
    "$baseDir/global"
)

# Define the empty files to create
$files = @(
    "$baseDir/modules/networking/main.tf",
    "$baseDir/modules/networking/variables.tf",
    "$baseDir/modules/networking/outputs.tf",
    "$baseDir/modules/compute/main.tf",
    "$baseDir/modules/storage/main.tf",
    "$baseDir/modules/monitoring/main.tf",
    "$baseDir/envs/development/main.tf",
    "$baseDir/envs/development/variables.tf",
    "$baseDir/envs/development/backend.tf",
    "$baseDir/envs/staging/main.tf",
    "$baseDir/envs/staging/variables.tf",
    "$baseDir/envs/staging/backend.tf",
    "$baseDir/envs/production/main.tf",
    "$baseDir/envs/production/variables.tf",
    "$baseDir/envs/production/backend.tf",
    "$baseDir/global/providers.tf",
    "$baseDir/global/versions.tf",
    "$baseDir/README.md"
)

# Create folders
foreach ($folder in $folders) {
    if (!(Test-Path $folder)) {
        New-Item -Path $folder -ItemType Directory -Force | Out-Null
    }
}

# Create empty files
foreach ($file in $files) {
    if (!(Test-Path $file)) {
        New-Item -Path $file -ItemType File -Force | Out-Null
    }
}

Write-Host "Terraform folder structure and empty files created successfully!" -ForegroundColor Green
