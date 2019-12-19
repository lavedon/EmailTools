# @TODO top priority make LinkedIn search
$spas = Import-CSV .\spas.csv;
[System.Collections.ArrayList]$ExpandedSpas = @();
$theHarvesterScript = 'C:\Users\Luke\Desktop\theHarvester\theHarvester.py';
$NordVPN = "'C:\Program Files (x86)\NordVPN\NordVPN.exe'";
$python = 'C:\Python37\python.exe';
$disconnect =  " -d";
$connect = " -c -n `"United States`"";

# This is probably bad style - to use a global iterator.
$i = 0;

# @TODO Use a workflow?
# @TODO re-write the connect -discconect command so it works like so
# PS C:\Program Files (x86)\NordVPN> .\nordvpn -d
function Get-Twitter {
    [CmdletBinding()]
    param()

    for($i = i; $i -lt $spas.count; $i++) {
        Write-Host "Looped $i times."
        Write-Host $item."Business Name";
        $twitterScript = @"
        python $theHarvesterScript -d $($spas[$i].Website) -l 200 -b twitter
"@
        Measure-Command {
            $twitterOutput = Invoke-Expression -Command $twitterScript;
        } | Write-Host;
        $twitterOutput | Write-Host;
        
        # @TODO if text file includes no users found change the VPN settings
        # Use the select-string cmdlet and the -quiet parameter
        # Select-String -AllMatches to grab all twitter users
        if ($twitterOutput | select-string -Pattern "No users found." -quiet) {
           # @TODO do an auto action like switch VPN?  Get-VPN;
           Write-Information "No USERS found.  IP block?" -InformationAction Continue;
        }
        $userInput = Read-Host "Next business? Enter to continue, V to switch VPN, R to repeat.  A to Add."
        # @TODO a way to retry the previous attempt
        if ($userInput -match "V") {
            Get-VPN;
        } elseif ($userInput -match "R") {
            $i = $i - 1;
        } elseif ($userInput -match "A") {
            # $twitterAccounts = $twitterOutput | Select-String -Pattern "@" -AllMatches # Fix this 
            $twitterAccounts = "@MuffinCat, @MommyCat"
            $tempSpa = $spas[$i];
            $tempSpa | Add-Member -MemberType NoteProperty -Name "Twitter Accounts" -Value $twitterAccounts;
            $ExpandedSpas.Add($tempSpa);

            $tempSpa = $null;
            $twitterAccounts = $null;

        }
    }
}

function Get-Input {
<#
    
.DESCRIPTION 

Reads the user input.  Call from any of the Harvester functions, such as finding
LinkedIn Users, Hunter.io emails, etc.  

.INPUTS 

Currently uses global variables.  Takes an input for what property you want
To add the collected information to.  Also, specify what number spas to look up?
Or should that be with the other functions?

#>
    param(
        [parameter(Mandatory)]
        [ValidateSet('Twitter','LinkedIn','Hunter')]
        [string]$whichSearch
        # @TODO A switch statement if you want to 
    )
        $userInput = Read-Host "Next business? Enter to continue, V to switch VPN, R to repeat.  A to Add."
        # @TODO a way to retry the previous attempt
        if ($userInput -match "V") {
            Get-VPN;
            return;
        } elseif ($userInput -match "R") {
            $i = $i - 1;
            return;
        } elseif ($userInput -match "A") {
            # $twitterAccounts = $twitterOutput | Select-String -Pattern "@" -AllMatches # Fix this 
            $twitterAccounts = "@MuffinCat, @MommyCat"
            $tempSpa = $spas[$i];
            $tempSpa | Add-Member -MemberType NoteProperty -Name "Twitter Accounts" -Value $twitterAccounts;
            $ExpandedSpas.Add($tempSpa);

            $tempSpa = $null;
            $twitterAccounts = $null;
            #put the above in the calling function
            return;

        }

}
function Get-VPN {
    Write-Information "Switching IP address." -InformationAction Continue;
    & $NordVPN $disconnect;
    Start-Sleep -Seconds 10
    & $NordVPN $connect;
    Start-Sleep -Seconds 10
    # @TODO Should the $Measure-Command $twitterOutput be in a separate function?

}
function Get-Duplicates {
    [CmdletBinding()]
    param()
    $numOfDuplicates = ($spa."Business Name" | Group-Object | Where-Object {$_.Count -gt 1}).count;
    Write-Host "$numOfDuplicates spas with the same name."

}

function Get-LinkedIn {
    [CmdletBinding()]
    param()
    for($i = $i; $i -lt $spas.count; $i++) {
        Write-Host "Looped $i times."
        Write-Host $item."Business Name";
        $linkedInScript = @"
        python $theHarvesterScript -d '$($spas[$i]."Business Name")' -l 200 -b linkedin
"@
        Measure-Command {
            $linkedInOutput = Invoke-Expression -Command $linkedInScript;
        } | Write-Host;
        $linkedInOutput | Write-Host;
        
        # @TODO if text file includes no users found change the VPN settings
        # Use the select-string cmdlet and the -quiet parameter
        # Select-String -AllMatches to grab all twitter users
        if ($linkedInOutput | select-string -Pattern "No users found." -quiet) {
           # @TODO do an auto action like switch VPN?  Get-VPN;
           Write-Information "No USERS found.  IP block?" -InformationAction Continue;
        }
        $userInput = Read-Host "Next business? Enter to continue, V to switch VPN, R to repeat, A to Add, S to Show new list. 
        E to export"
        # @TODO a way to retry the previous attempt
        if ($userInput -match "V") {
            Get-VPN;
        } elseif ($userInput -match "R") {
            $StartFrom = $StartFrom - 1;
        } elseif ($userInput -match "A") {
            # REGEX to only match lines that start with a full name
            # ^((\w+)\s(\w+)).*
            $linkedInUsers = $linkedInOutput | Select-String -Pattern '^((\w+)\s(\w+)).*' -AllMatches 

            $tempSpa = $spas[$i];
            
            $tempSpa | Add-Member -MemberType NoteProperty -Name "LinkedIn Users" -Value $linkedInUsers;
            $ExpandedSpas.Add($tempSpa);

            Write-Information "Spas with new information added: $($ExpandedSpas.Count)"

            $tempSpa = $null;
            $linkedInUsers = $null;

        } elseif ($userInput -match "E") {
            $ExpandedSpas | ForEach-Object { $_."LinkedIn Users" = $_."LinkedIn Users" -join ', '};
            $ExpandedSpas | Export-Csv -Path .\export.csv 
        } elseif ($userInput -match "S") {
            $ExpandedSpas | Write-Host; 
        }
    }
}
# @TODO function that gets straight from the Hunter.io API and skips theharvester
# https://hunter.io/api_keys
