Write-Host "Enter domain name";
$domain = Read-Host; 
Clear-DnsClientCache;
$output = Resolve-DnsName -Name $domain -Type MX 
Write-Host "Your TTL is/are:"
Write-Host ($output | select -Property TTL | Out-String);
Write-Host "Your SPF is:"
# Write an array you loop through that contains each property you want to print?
Write-Host "Your Name Server records are:"
Write-Host ($output | select -Property NS | Out-String);
