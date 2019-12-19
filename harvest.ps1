function Get-Harvest {
    [CmdletBinding()]
    param(
        [parameter(Mandatory=$true)]
        [ValidateSet("LinkedIn", "Hunter", "Twitter")]
        [String]$WhichSearch,

        [parameter(Mandatory=$true)]
        [Array]$businesses,

        [parameter(Mandatory=$false)]
        [switch]
        $AutoRepeat,

        [int]$StartFrom,
        [int]$End
        
    )
      begin {
        <# ********** Variables *****************#>
        $i = 0;
        [System.Collections.ArrayList]$expandedBusinesses = @();
        $theHarvesterScript = 'C:\Users\Luke\Desktop\theHarvester\theHarvester.py';
        $python = 'C:\Python37\python.exe';


        <# ********** Helper Functions **********#>
      function Get-Linked {
          Write-Host "Called Get-Linked $businesses";
      }

      function Get-Hunter {
          Write-host "Called Get-Hunter $businesses";
      }

      function Get-Twitter {
          Write-Host "Called Get-Twitter $businesses";
      }

      function Get-Input {

        $userInput = Read-Host "Next business? Enter to continue,  
        V to switch VPN, R to repeat, A to Add, S to Show new list. `
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

    Write-Host "You Passed A list of businesses that is $($businesses.count)"
    if ($WhichSearch -match "LinkedIn") {
        Get-Linked; 
    } elseif ($WhichSearch -match "Hunter") {
        Get-Hunter;
    } elseif ($WhichSearch -match "Twitter") {
        Get-Twitter;
    }
    <# ####  END BEGIN ########### #>
    }     
    process {

    }
    end {

    }
}