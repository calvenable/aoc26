param([string]$Day=(Get-Date -Format "dd"))
$dirName = "Day$Day"
$dayNumber = $Day.trimStart('0')
$year = (Get-Date -Format "yyyy")
echo $year

# Create a new directory and test input file for the day
New-Item -Path "." -Name "$dirName" -ItemType "directory"
New-Item -Path "./$dirName" -Name "test.txt" -ItemType "file"

# Create a new console application for the day, add a reference to my reusable helper library, and add it to the solution
Set-Location "$dirName"
dotnet new console --use-program-main
dotnet reference add "../HelperFunctions"

Set-Location ".."
dotnet sln add "$dirName"

# Copy the C# template file and replace the [DAY] marker with the number of the day
Copy-Item "./template.cs" -Destination "./$dirName/$dirName.cs"
(Get-Content "./$dirName/$dirName.cs").Replace('[DAY]', "$dirName") | Set-Content "./$dirName/$dirName.cs"

# Delete the default 'Program.cs' file
Remove-Item "./$dirName/Program.cs"

# Fetch the day's input from the right URL, using my session cookie/token
$Config = Get-Content -Path "./config.json" | ConvertFrom-Json
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.Cookies.Add((New-Object System.Net.Cookie("session", $Config.sessioncookie, "/", ".adventofcode.com")))

Invoke-WebRequest -UseBasicParsing -Uri "https://adventofcode.com/$year/day/$dayNumber/input" `
-WebSession $session `
-OutFile "./$dirName/input.txt";