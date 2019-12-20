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

        [switch]
        $RepeatOnFailure

        # @TODO repeat a specific number of times on failure?

    )

      begin {
        <# ********** Variables *****************#>
        $i = 0;
        $stopAt = 0;
        [System.Collections.ArrayList]$expandedBusinesses = @();
        $theHarvesterScript = 'C:\Users\Luke\Desktop\theHarvester\theHarvester.py';
        $python = 'C:\Python37\python.exe';


        <# ********** Helper Functions **********#>
      function Get-Linked {

          Write-Verbose "Called Get-Linked for $($Businesses[$i]."Business Name")";
          Write-Verbose "Using Business Name not domain name to search LinkedIn."
          $getHarvestScript = @"
          
        $python $theHarvesterScript -d $($Businesses[$i]."Business Name") -l 200 -b linkedin  
"@
        $script:LinkedOutput = Invoke-Expression -Command $getHarvestScript;
      }

      function Get-Hunter {
          Write-host "Called Get-Hunter $Businesses";
      }

      function Get-Twitter {
          Write-Host "Called Get-Twitter $Businesses";
      }

      function Get-Input {

        $userInput = Read-Host "Next business? Enter to add and continue,  
        V to switch VPN, R to repeat, 
        E to export"
        # @TODO a way to retry the previous attempt
        if ($userInput -match "V") {
            Get-VPN;
        } elseif ($userInput -match "R") {
            $i = $i - 1;
        } elseif ($userInput -match "A") {
            # REGEX to only match lines that start with a full name
            # ^((\w+)\s(\w+)).*

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
    Get-Input;
        if ($WhichSearch -match "LinkedIn") {
            Get-Linked; 
        } elseif ($WhichSearch -match "Hunter") {
            Get-Hunter;
        } elseif ($WhichSearch -match "Twitter") {
            Get-Twitter;
        }
    <# ##########  END BEGIN ########### #>
    }     
    process {

    }
    end {
        Write-Host "Thank you, come again."
    }
}