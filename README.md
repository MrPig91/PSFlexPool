# PSFlexPool
This a powershell module used for interacting with the FlexPool API.

# Install
The install should be really easy since this module is on the PowershellGallery. Just run the following command as admin.
```Powershell
Install-Module -Repository PSGallery -Name PSFlexPool
```
If you encouter any prompts about PSGallery not being a trusted Repository and needing to update Nuget, then enter Y and hit Enter.

To upgrade the module run the following command ad admin.
```Powershell
Update-Module -Name PSFlexPool
```

# Setup
You should be able to use all the commands in the module after installing it, however there is one command I highly recommend running after installing the module.
```Powershell
Set-fpMinerAddress -Address "Your ETH or XCH payout address here"
```
This command will set the default value for the "Address" parameter for all Miner related functions. This will will make running all these functions much eaiser and faster since you do not have enter your payout address every time you want to a run a command (see blow example). You can always override the default value even after it is set by specifying the parameter when running the command as well.
```Powershell
# This what you normally would have to run without setting a default
Get-fpMinerWorkers -Address "You payout address" -CoinTicker XCH

# And this is what you can run after setting the default address using Set-fpMinerAddress
Get-fpMinerWorkers
```

# Donate

If you found this module useful and want to donate you can use any of the below addresses.

XCH: xch1xlsrczvnfzjfeg7ejpaxy7evcn0nvsr73s4gcmzdqd7zkzlvy8ds49qvv2

ETH: 0xeeb3d0FEECaAfEd8BBC705370579689BFA024Be4

XMR: 4Adn4LNiaqjUfkAq1RNmLLcRd2oBDdGx8HWL4L76eZmMWQGbowrYhvuajRCdFYLq6pGAPgXYE9P3g2wvVp36FFRn3EAzRjW

BAN: ban_37o6aossupgce34dma9r6na4hi79j6mhqrtp1gkr8ygz6nxjz8t9q3emkp4h
