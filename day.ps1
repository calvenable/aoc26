param([string]$Day=(Get-Date -Format "dd"))
$dirName = "day$Day"
$dayNumber = $Day.trimStart('0')

# Create a new directory and test input file for the day
New-Item -Path "." -Name "$dirName" -ItemType "directory"
New-Item -Path "./$dirName" -Name "test.txt" -ItemType "file"

# Create a new console application for the day, add a reference to my reusable helper library, and add it to the solution
Set-Location "$dirName"
dotnet new console --use-program-main
dotnet reference add "../HelperFunctions/HelperFunctions.csproj"

Set-Location ".."
dotnet sln add "$dirName"
