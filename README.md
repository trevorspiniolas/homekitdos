# HomeKit Denial of Service (CVE-2022-22588)
Patched in iOS 15.2.1 - https://support.apple.com/en-us/HT213043

This application triggers a Denial of Service bug that can result in the loss of functionality of an iOS device, persistent through reboots and triggering again upon logging back into iCloud. [Read more here](https://trevorspiniolas.com/doorlock/doorlock.html)


# DISCLAIMER
**Do NOT run this application unless you know what you are doing. It is provided for security research purposes ONLY, and by running it you should assume that it will result in catastrophic loss of data and functionality on every iOS device logged into your iCloud. I am not responsible for any loss of data or device functionality. Do not run this application on any device you do not own, or on any device linked to an iCloud you do not own.**


## How it Works
When a HomeKit device with an exceptionally large string (ex: 500,000 characters) is loaded into control center, the device will freeze. Because this data is stored in iCloud, restoring a device the bug was triggered on and then signing back into the associated iCloud account will trigger the bug again.

This application will rename all HomeKit devices to the string contained in "ExploitString.swift," which by default is a string that **WILL trigger the bug** on iOS 15.0 (possibly 14.8.1) and lower. The bug can STILL be triggered on iOS 15.2, however, through methods such as Home invitations. More details on this are included in the above link.


## About
As I had no prior HomeKit experience, this application is just Apple's [Interacting with a Home Automation Network](https://developer.apple.com/documentation/homekit/interacting_with_a_home_automation_network) sample project with modifications made to rename all HomeKit devices to the same string in order to demonstrate the bug.

