function Get-Harvest {
    [CmdletBinding()]
    param(
        [parameter(Mandatory=$true)]
        [ValidateSet("LinkedIn", "Hunter", "Twitter")]
        [String]$WhichSearch,

        [parameter(Mandatory=$true)]
        [Array]$Businesses,

        [parameter(Mandatory=$false)]
        [int]$SleepTime = 15,

        [parameter(Mandatory=$false)]
        [int]$StartFrom = 0,

        [parameter(Mandatory=$false)]
        [int]$End = $Businesses.Length,

        [switch]
        $AutoRepeat,

        # repeat a specific number of times on failure?
        [switch]
        $RepeatOnFailure,

        [switch]
        $UseBusinessName
        # use the business name and not

        # @TODO A switch to USE 

    )

      begin {
        <# ********** Variables *****************#>
        $i = 0;
        $stopAt = 0;
        [System.Collections.ArrayList]$expandedBusinesses = @();
        $theHarvesterScript = 'C:\Users\Luke\Desktop\theHarvester\theHarvester.py';
        $python = 'C:\Python37\python.exe';


        <# ********** Helper Functions **********#>
        # @TODO refactor so only one script block works for most functions twitter, linkedin, 
        # hunter etc.
      function Get-Input {

            $userInput = Read-Host "Enter to Harvest or continue,  
            V to switch VPN, R to repeat previous, S to Save/Export"
            # @TODO a way to retry the previous attempt
            if ($userInput -match "V") {
                Get-VPN;
            } elseif ($userInput -match "R") {
                $i = $i - 1;
            } 
            elseif ($userInput -match "S") {
                Write-Verbose "Saving `$expandedBusinesses"
                Write-Verbose "Both as CliXML and CSV."
                Export-CliXml -InputObject $expandedBusinesses -Path .\biz-with-harvest.xml 
                Export-Csv -InputObject $expandedBusinesses -Path .\biz-with-harvest.csv
                
            }
    }

    function Get-Duplicates {
        [CmdletBinding()]
        param()
        $numOfDuplicates = ($spa."Business Name" | Group-Object | Where-Object {$_.Count -gt 1}).count;
        Write-Host "$numOfDuplicates spas with the same name."

    }
    function Get-VPN {
        $NordVPN = "'C:\Program Files (x86)\NordVPN\NordVPN.exe'";
        $disconnect =  " -d";
        $connect = " -c -n `"United States`"";

        Write-Information "Switching IP address." -InformationAction Continue;
        & $NordVPN $disconnect;
        Start-Sleep -Seconds 10
        & $NordVPN $connect;
        Start-Sleep -Seconds 10
        # @TODO Should the $Measure-Command $twitterOutput be in a separate function?

    }

    <# Main Code Stuff 
                __                ___               ___
              ,' ,'              |   |              `. `.
            ,' ,'                |===|                `. `.
           / //                  |___|                  \\ \
          / //                   |___|                   \\ \
         ////                    |___|                    \\\\
        /  /                    ||   ||                    \  \
       /  /                     ||   ||                     \  \
      /| |                      ||   ||                      | |\
      || |                     | : o : |                     | ||
     |  \|                     | .===. |                     |/  |
     |  |\                    /| (___) |\                    /|  |
    |__||.\         .-.      // /,_._,\ \\      .-.         /.||__|
    |__||_.\        `-.\    //_ [:(|):] _\\    /.-'        /._||__|
 __/|  ||___`._____ ___\\__/___/_ ||| _\___\__//___ _____.'___||_ |\__
/___//__________/.-/_____________|.-.|_____________\-.\__________\\___\
\___\\__\\\_____\`-\__\\\\__\____|_-_|____/_//_____/-'/__//______//__//
   \|__||__..'         //  \ _ \__|||__/ _ /  \\         `..__||__|/
    |__||_./        .-'/    \\   |(|)|   //    \`-.        \..||__|
    |  || /         `-'      \\   \'/   //      `-'         \ ||  |
     |  |/                    \| :(-): |/                    \|  |
     |  /|                     | : o : |                     |\  |
      || |                     | |___| |                     | ||
      \| |                      ||   ||                      | |/
       \  \                     ||   ||                     /  /
        \  \                    ||___||                    /  /
         \\\\                    |___|                    ////
          \ \\                   |___|                   // /
           \ \\                  |   |                  // /
            `. `.                |===|                ,' ,'
              `._`.              |___|              ,'_,'

############### MAIN CODE STARTS HERE ##################################>

    Write-Verbose "You Passed A list of businesses that is $($Businesses.count)"

    $i = $StartFrom;

    while ($i++ -lt $End) {

    Write-Host "Up to $($Businesses[$i]."Business Name")"
    <# ##########  READ INPUT ########## #>
    # @TODO Remove these and just have the here string
    # Read which search engine to use

    Get-Input;
    Write-Verbose "About to $($Businesses[$i]."Business Name") using $WhichSearch";
    Write-Verbose "Using Business Name not domain name to search LinkedIn."
    if($UseBusinessName) {
        $dSwitch = "$($Businesses[$i].'Business Name')"
    } else {
        # @TODO ! Use Regex to extract ONLY the domain name
        
        $dSwitch = "$($Businesses[$i].'Website')"
    }

    $getHarvestScript = @"
$python $theHarvesterScript -d $dSwitch -l 200 -b $WhichSearch  
"@

    [string]$HarvestOutput = Invoke-Expression -Command $getHarvestScript;
    Write-Verbose $HarvestOutput;
    Write-Verbose "Running RegEx";
    $bizInfoToAdd = $HarvestOutput -match "^((\w+)\s(\w+)).*";
    Write-Verbose "Adding new $WhichSearch property to $($Businesses[$i].'Business Name')";

    $bizWithHarvestResult = $Businesses[$i];
    $bizWithHarvestResult = $bizWithHarvestResult | Add-Member -MemberType NoteProperty
         -Name "$WhichSearch Harvest" -Value $bizInfoToAdd;

    # Flatten the harvest result
    $bizWithHarvestResult | % { $_."$WhichSearch Harvest" = $_."$WhichSearch Harvest" -join ', '};
    Write-Verbose "Adding $bizWithHarvestResult to `$expandedBusinesses";
    $expandedBusinesses.add($bizWithHarvestResult);

    <# ##########  END BEGIN ########### #>
        }     
    }

    process {

    }
    end {
        Write-Host "Thank you, come again."
    }
}