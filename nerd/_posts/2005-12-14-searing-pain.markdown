---
layout: post
title: The Searing Pain of Using Windows
date: 2005-12-14
author: Jeff Watkins
categories:
- Macintosh
- Windows
---

At long last, I've purchased a cell phone. I held out as long as I could. My claim was that there weren't any good cellphones that had all the features I wanted. My list included:

* Worked with Apple's iSync to synchronise contacts, schedule, and tasks
* Supported world-wide GSM
* Wasn't made by Motorola, because their phones suck

I kept checking the Cingular and T-Mobile Web sites to see when they would support phones on the [iSync compatible phone list](http://apple.com/isync/), but they never did. Well, none that weren't from Motorola. Finally, I thought to check Amazon, where I found a nice phone from Sony Ericsson: the z520a. It doesn't suck (because it wasn't made by Motorola) and it works perfectly with iSync.

## Synchronising on Macintosh ##

Here's the complete process of synchronising my phone with iCal and Tiger's Address Book:

<div class="figure">
<img class="photo" src="http://nerd.newburyportion.com/wp-content/uploads/2005/12/isync.gif" alt="">
</div>

1. Control-click on the iSync application icon in the Dock.
2. Pick **Sync Devices** from the context menu.
3. Wait for my phone to chime letting me know that the synchronisation has completed.

*Note:* I leave iSync hidden (Cmd-H) because I never interact with the UI.

## Synchronising with Outlook ##

Windows doesn't have a built-in synchronisation service like iSync. Perhaps Microsoft will address this in Windows Vista when it ships in a few years, but I doubt it. And even if Vista *does* include a synchronisation service, it probably *won't* co-operate with Microsoft Outlook.

Fortunately, Sony Ericsson distributes a free software package that lets me synchronise my phone with Outlook. But typical of everything on Windows, it is an absolute nightmare to use.

The following is the exact steps I must take to synchronise my phone with Outlook:

1. Click the Start button
2. Choose **All Programs**
3. Choose **Sony Ericsson** menu from the list of all programs
4. Choose **Sync Station** from the Sony Ericsson menu
5. Choose **Synchronize** from the Sync Station menu
    <div class="figure">
    <img src="http://nerd.newburyportion.com/wp-content/uploads/2005/12/sync.gif" alt="">
    </div>
6. Hit `Alt`-`Tab` several times to switch to Outlook
7. Check the box to allow Sync Station to have access to Outlook
    <div class="figure">
    <img src="http://nerd.newburyportion.com/wp-content/uploads/2005/12/outlook.gif" alt="">
    </div>
8. Switch back to Sync Station (`Alt`-`Tab`)
9. Click OK on the stupid dialog box from Sync Station
    <div class="figure">
    <img src="http://nerd.newburyportion.com/wp-content/uploads/2005/12/complete.gif" alt="">
    </div>
10. Right click on the icon for Sync Station in the system tray
11. Select **Exit** from the Sync Station system tray menu

I *absolutely* have to exit the Sync Station software because it insists on polling the phone every second or so via the Blue Tooth connection, which runs down the battery.

Yes, I could put an alias to the Sync Station synchronise command on the task bar's quick launch area, but I wanted to compare out of the box experience.

## No comparison ##

There really is no comparison between the Macintosh experience and the Windows experience. Synchronising with iSync is a pleasure, while synchronising on Windows is like scrubbing the backs of my eyeballs with sandpaper.

Of course, the iSync experience isn't perfect. The little menu bar widget doesn't seem to work correctly unless iSync is actually running. So if it's running, why not just use the context menu from the dock icon? And I'd really love it if iSync would notice that the phone had come into range (yes, this is polling via Blue Tooth again) and automatically synchronise. Finally, when adding or updating contacts or iCal entries, it would be *so* cool if iSync would push out the updates once a minute or so.

## Alternatives ##

There might be an alternative to the Sony Ericsson synchronisation software, but if there is, I hold out slim hope that it will be easier to use. And even when Microsoft wakes up and decides to support devices other than WinCE devices with their Active Sync technology, I expect support to be limited and cumbersome.

Fortunately, my cell phone is my *personal* device and I don't really care how closely it tracks my work appointments and task lists. In fact, I wish there was a way to have entries that originate from the phone marked as private. But that's like asking [my new-born daughter](http://newburyportion.com/2005/12/molly-elizabeth-watkins) to *tell* me why she's crying: too much to expect.
