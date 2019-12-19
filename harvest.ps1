function Get-Harvest {
    [CmdletBinding()]
    param(
        [parameter(Mandatory=$true)]
        [ValidateSet("LinkedIn", "Hunter", "Twitter")]
        [String]$WhichSearch,

        [parameter(Mandatory=$true)]
        [PSCustomObject]$businesses,

        [parameter(Mandatory=$false)]
        [switch]
        $AutoRepeat,

        [int]$StartFrom,
        [int]$EndFrom
        
    )
      begin {

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
    function Get-Duplicates {
        [CmdletBinding()]
        param()
        $numOfDuplicates = ($spa."Business Name" | Group-Object | Where-Object {$_.Count -gt 1}).count;
        Write-Host "$numOfDuplicates spas with the same name."

    }

    if ($WhichSearch -match "LinkedIn") {
        Get-Linked; 
    } elseif ($WhichSearch -match "Hunter") {
        Get-Hunter;
    } elseif ($WhichSearch -match "Twitter") {
        Get-Twitter;
    }
    } 
    process {

    }
    end {

    }
}