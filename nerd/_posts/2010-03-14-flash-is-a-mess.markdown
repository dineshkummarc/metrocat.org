---
layout: post
title: Flash Is A Mess
date: 2010-03-14
author: Jeff Watkins
categories:
- Macintosh
- Web
---

[Kevin Lynch of Adobe made some interesting claims recently](http://blogs.adobe.com/conversations/2010/02/open_access_to_content_and_app.html#comment-2137153) while trying to defend flash and explain why it should be included on the iPad and iPhone:

> Regarding crashing, I can tell you that we don't ship Flash with any known crash bugs, and if there was such a widespread problem historically Flash could not have achieved its wide use today. &hellip;
> Addressing crash issues is a top priority in the engineering team, and currently there are open reports we are researching in Flash Player 10.

I just tried to watch the most recent Colbert Report, Kevin, and I got the following:

    
    Process:         WebKitPluginHost [3005]
    Path:            /System/Library/Frameworks/WebKit.framework/WebKitPluginHost.app/Contents/MacOS/WebKitPluginHost
    Identifier:      com.apple.WebKit.PluginHost
    Version:         6531.22 (6531.22.2)
    Build Info:      WebKitPluginHost-65312202~2
    Code Type:       X86 (Native)
    Parent Process:  WebKitPluginAgent [273]
    
    PlugIn Path:       /Library/Internet Plug-Ins/Flash Player.plugin/Contents/MacOS/Flash Player
    PlugIn Identifier: com.macromedia.Flash Player.plugin
    PlugIn Version:    10.0.42 (1.0.4f348472)
    
    Date/Time:       2010-03-14 20:34:58.417 -0700
    OS Version:      Mac OS X 10.6.2 (10C540)
    Report Version:  6
    
    Interval Since Last Report:          44743 sec
    Crashes Since Last Report:           1
    Per-App Interval Since Last Report:  3565 sec
    Per-App Crashes Since Last Report:   1
    Anonymous UUID:                      853BF84A-2D72-40D3-AF9D-CF8CBABAF03B
    
    Exception Type:  EXC_BAD_ACCESS (SIGSEGV)
    Exception Codes: KERN_INVALID_ADDRESS at 0x0000000013fcf018
    Crashed Thread:  0  Dispatch queue: com.apple.main-thread
    
    Thread 0 Crashed:  Dispatch queue: com.apple.main-thread
    0   ...romedia.Flash Player.plugin    0x13a946ab FlashPlayer_10_0_42_34_FlashPlayer + 687051
    1   com.apple.CoreFoundation          0x96f4cedb __CFRunLoopRun + 8059
    2   com.apple.CoreFoundation          0x96f4a864 CFRunLoopRunSpecific + 452
    3   com.apple.CoreFoundation          0x96f4a691 CFRunLoopRunInMode + 97
    4   com.apple.HIToolbox               0x9597cf0c RunCurrentEventLoopInMode + 392
    5   com.apple.HIToolbox               0x9597ccc3 ReceiveNextEventCommon + 354
    6   com.apple.HIToolbox               0x9597cb48 BlockUntilNextEventMatchingListInMode + 81
    7   com.apple.AppKit                  0x91c3eac5 _DPSNextEvent + 847
    8   com.apple.AppKit                  0x91c3e306 -[NSApplication nextEventMatchingMask:untildate:inMode:dequeue:] + 156
    9   com.apple.AppKit                  0x91c0049f -[NSApplication run] + 821
    10  com.apple.WebKit.PluginHost       0x00006123 0x1000 + 20771
    11  com.apple.WebKit.PluginHost       0x00001ef9 0x1000 + 3833
    
    Thread 1:  Dispatch queue: com.apple.libdispatch-manager
    0   libSystem.B.dylib                 0x94f3d0ea kevent + 10
    1   libSystem.B.dylib                 0x94f3d804 _dispatch_mgr_invoke + 215
    2   libSystem.B.dylib                 0x94f3ccc3 _dispatch_queue_invoke + 163
    3   libSystem.B.dylib                 0x94f3ca68 _dispatch_worker_thread2 + 234
    4   libSystem.B.dylib                 0x94f3c4f1 _pthread_wqthread + 390
    5   libSystem.B.dylib                 0x94f3c336 start_wqthread + 30
    
    Thread 2:
    0   libSystem.B.dylib                 0x94f35856 select$DARWIN_EXTSN + 10
    1   com.apple.CoreFoundation          0x96f8addd __CFSocketManager + 1085
    2   libSystem.B.dylib                 0x94f43fbd _pthread_start + 345
    3   libSystem.B.dylib                 0x94f43e42 thread_start + 34
    
    Thread 3:
    0   libSystem.B.dylib                 0x94f3c182 __workq_kernreturn + 10
    1   libSystem.B.dylib                 0x94f3c718 _pthread_wqthread + 941
    2   libSystem.B.dylib                 0x94f3c336 start_wqthread + 30
    
    Thread 4:
    0   libSystem.B.dylib                 0x94f1693a semaphore_timedwait_signal_trap + 10
    1   libSystem.B.dylib                 0x94f44445 _pthread_cond_wait + 1066
    2   libSystem.B.dylib                 0x94f73028 pthread_cond_timedwait_relative_np + 47
    3   ...ple.CoreServices.CarbonCore    0x903b6235 TSWaitOnConditionTimedRelative + 242
    4   ...ple.CoreServices.CarbonCore    0x903b5f73 TSWaitOnSemaphoreCommon + 511
    5   ...ple.CoreServices.CarbonCore    0x903da16b TimerThread + 97
    6   libSystem.B.dylib                 0x94f43fbd _pthread_start + 345
    7   libSystem.B.dylib                 0x94f43e42 thread_start + 34
    
    Thread 5:
    0   libSystem.B.dylib                 0x94f3c182 __workq_kernreturn + 10
    1   libSystem.B.dylib                 0x94f3c718 _pthread_wqthread + 941
    2   libSystem.B.dylib                 0x94f3c336 start_wqthread + 30
    
    Thread 0 crashed with X86 Thread State (32-bit):
      eax: 0x0015c4d0  ebx: 0x96f4af71  ecx: 0x13a946a0  edx: 0x13fcf000
      edi: 0x13fcf000  esi: 0x0015c4d0  ebp: 0xbfffe818  esp: 0xbfffe7e0
       ss: 0x0000001f  efl: 0x00010282  eip: 0x13a946ab   cs: 0x00000017
       ds: 0x0000001f   es: 0x0000001f   fs: 0x00000000   gs: 0x00000037
      cr2: 0x13fcf018
    
    Binary Images:
        0x1000 -    0x18ff7  com.apple.WebKit.PluginHost 6531.22 (6531.22.2) <03CD53AA-AD4D-0DEA-A393-0718FD1959B1> /System/Library/Frameworks/WebKit.framework/WebKitPluginHost.app/Contents/MacOS/WebKitPluginHost
       0x20000 -    0x20ff7  WebKitPluginHostShim.dylib ??? (???) <EC7C3AD2-14ED-8AF5-14C0-FE756120F84A> /System/Library/Frameworks/WebKit.framework/WebKitPluginHost.app/Contents/MacOS/WebKitPluginHostShim.dylib
       0xc6000 -    0xd2ffb +com.fsb.SafariBlock ??? (2.2r1) <FE7DD96F-3E47-5128-F5B9-51956F41F1C9> /Library/InputManagers/SafariBlock/SafariBlock.bundle/Contents/MacOS/SafariBlock
      0x600000 -   0x6b5fe7  libcrypto.0.9.7.dylib ??? (???) <39CDB041-9DF5-01B1-4B33-03EC4CCA40B3> /usr/lib/libcrypto.0.9.7.dylib
      0x7bf000 -   0x7e8fef  com.apple.audio.CoreAudioKit 1.6.1 (1.6.1) <C5992CBA-0496-9681-A7CA-A932F2BC1CB9> /System/Library/Frameworks/CoreAudioKit.framework/Versions/A/CoreAudioKit
    0x13700000 - 0x13d3affb +com.macromedia.Flash Player.plugin 10.0.42 (1.0.4f348472) <266780DB-53C4-AAC8-30AF-F69306C5C030> /Library/Internet Plug-Ins/Flash Player.plugin/Contents/MacOS/Flash Player
    0x14fb6000 - 0x15023fff +com.DivXInc.DivXDecoder 6.6.0 (6.6.0) /Library/QuickTime/DivX Decoder.component/Contents/MacOS/DivX Decoder
    0x1a05c000 - 0x1a078ff7  GLRendererFloat ??? (???) <8FF7B576-512C-C2F8-4C0C-967FB3D9EEA2> /System/Library/Frameworks/OpenGL.framework/Resources/GLRendererFloat.bundle/GLRendererFloat
    0x1a108000 - 0x1a109ff7  ATSHI.dylib ??? (???) <B370C4CD-44F6-1241-EC63-F8F02A96275B> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ATS.framework/Versions/A/Resources/ATSHI.dylib
    0x1ea87000 - 0x1ea95fe7  libSimplifiedChineseConverter.dylib ??? (???) <4C9CC2D9-2F13-4465-5447-2516FCD9255B> /System/Library/CoreServices/Encodings/libSimplifiedChineseConverter.dylib
    0x1ea99000 - 0x1eaabff7  libTraditionalChineseConverter.dylib ??? (???) <C4E0D62B-4D1A-8DAD-D10B-2C055AA0479C> /System/Library/CoreServices/Encodings/libTraditionalChineseConverter.dylib
    0x1ef2d000 - 0x1ef31ff3  com.apple.audio.AudioIPCPlugIn 1.1.2 (1.1.2) <C36F9194-6DB6-0AA8-4839-71191EEBAC65> /System/Library/Extensions/AudioIPCDriver.kext/Contents/Resources/AudioIPCPlugIn.bundle/Contents/MacOS/AudioIPCPlugIn
    0x1f03e000 - 0x1f044ffb  com.apple.audio.AppleHDAHALPlugIn 1.7.9 (1.7.9a4) <A686EC36-C3D5-131F-46D2-F174F5477C77> /System/Library/Extensions/AppleHDA.kext/Contents/PlugIns/AppleHDAHALPlugIn.bundle/Contents/MacOS/AppleHDAHALPlugIn
    0x226a0000 - 0x22811ff7  GLEngine ??? (???) <D336658A-F6DB-6D61-9CA6-04299E7D5420> /System/Library/Frameworks/OpenGL.framework/Resources/GLEngine.bundle/GLEngine
    0x22842000 - 0x22c48fef  libclh.dylib ??? (???) <3ACD0D90-B1E9-59DA-729E-7E97092F9A24> /System/Library/Extensions/GeForce8xxxGLDriver.bundle/Contents/MacOS/libclh.dylib
    0x70000000 - 0x700cbffb  com.apple.audio.units.Components 1.6.1 (1.6.1) <4E1101F3-E8EF-4925-75FE-373BD7BC3BAB> /System/Library/Components/CoreAudio.component/Contents/MacOS/CoreAudio
    0x8f611000 - 0x8fa52fe7  com.apple.GeForce8xxxGLDriver 1.6.6 (6.0.6) <205911D0-3CE3-D53C-289B-319A4E4BA153> /System/Library/Extensions/GeForce8xxxGLDriver.bundle/Contents/MacOS/GeForce8xxxGLDriver
    0x8fe00000 - 0x8fe4162b  dyld 132.1 (???) <211AF0DD-42D9-79C8-BB6A-1F4BEEF4B4AB> /usr/lib/dyld
    0x901c5000 - 0x901e9ff7  libJPEG.dylib ??? (???) <649E1974-A527-AC0B-B3F4-B4DC30484070> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ImageIO.framework/Versions/A/Resources/libJPEG.dylib
    0x90206000 - 0x90206ff7  com.apple.CoreServices 44 (44) <AC35D112-5FB9-9C8C-6189-5F5945072375> /System/Library/Frameworks/CoreServices.framework/Versions/A/CoreServices
    0x90207000 - 0x90207ff7  com.apple.Accelerate.vecLib 3.5 (vecLib 3.5) <3E039E14-2A15-56CC-0074-EE59F9FBB913> /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/vecLib
    0x9036f000 - 0x9068efe7  com.apple.CoreServices.CarbonCore 861.2 (861.2) <A9077470-3786-09F2-E0C7-F082B7F97838> /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/CarbonCore.framework/Versions/A/CarbonCore
    0x9068f000 - 0x90696ff7  com.apple.agl 3.0.12 (AGL-3.0.12) <6BF89127-C18C-27A9-F94A-981836A822FE> /System/Library/Frameworks/AGL.framework/Versions/A/AGL
    0x9073a000 - 0x9075afe7  com.apple.opencl 12 (12) <2DB56F60-577B-6724-5708-7B082F62CC0F> /System/Library/Frameworks/OpenCL.framework/Versions/A/OpenCL
    0x90991000 - 0x90a2dfe7  com.apple.ApplicationServices.ATS 4.1 (???) <EA26375D-8276-9671-645D-D28CAEC95292> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ATS.framework/Versions/A/ATS
    0x90aa8000 - 0x90ad0ff7  libxslt.1.dylib ??? (???) <769EF4B2-C1AD-73D5-AAAD-1564DAEA77AF> /usr/lib/libxslt.1.dylib
    0x90ad1000 - 0x90b62fe7  com.apple.print.framework.PrintCore 6.1 (312.3) <6D4322AF-703C-CC19-77B4-53E6D3BB18D4> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/PrintCore.framework/Versions/A/PrintCore
    0x90bdd000 - 0x90beaff7  com.apple.opengl 1.6.5 (1.6.5) <0AE8B897-8A80-2C14-D6FC-DC21AC423234> /System/Library/Frameworks/OpenGL.framework/Versions/A/OpenGL
    0x90beb000 - 0x90bf5ff7  libGL.dylib ??? (???) <76A207FE-889A-CF1B-AF9A-795EEE5A463E> /System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGL.dylib
    0x90df7000 - 0x90ed4ff7  com.apple.vImage 4.0 (4.0) <64597E4B-F144-DBB3-F428-0EC3D9A1219E> /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vImage.framework/Versions/A/vImage
    0x90ed5000 - 0x90ed8ff7  libCoreVMClient.dylib ??? (???) <A89D7A78-8FB0-2BDF-30DB-A35E04A6186B> /System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libCoreVMClient.dylib
    0x90ed9000 - 0x916bc4b7  com.apple.CoreGraphics 1.536.12 (???) <263EB5FC-DEAD-7C5B-C486-EC86C173F952> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/CoreGraphics.framework/Versions/A/CoreGraphics
    0x916dd000 - 0x9172dff7  com.apple.framework.familycontrols 2.0 (2.0) <E6CAB425-3E40-65A3-0C23-150C26E9CBBF> /System/Library/PrivateFrameworks/FamilyControls.framework/Versions/A/FamilyControls
    0x9172e000 - 0x917e1fff  libFontParser.dylib ??? (???) <FAD5E96D-CF93-CC86-6B30-A6594B930772> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ATS.framework/Versions/A/Resources/libFontParser.dylib
    0x917e2000 - 0x9181cffb  libFontRegistry.dylib ??? (???) <72342297-E8D6-B071-A752-014134129282> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ATS.framework/Versions/A/Resources/libFontRegistry.dylib
    0x91a09000 - 0x91a0ffff  com.apple.CommonPanels 1.2.4 (91) <2438AF5D-067B-B9FD-1248-2C9987F360BA> /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/CommonPanels.framework/Versions/A/CommonPanels
    0x91a32000 - 0x91ab4ffb  SecurityFoundation ??? (???) <29C27E0E-B2B3-BF6B-B1F8-5783B8B01535> /System/Library/Frameworks/SecurityFoundation.framework/Versions/A/SecurityFoundation
    0x91ab5000 - 0x91b5cfe7  com.apple.CFNetwork 454.5 (454.5) <A7E78E62-0C59-CE57-73D2-C4E60527781C> /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/CFNetwork.framework/Versions/A/CFNetwork
    0x91b5d000 - 0x91ba0ff7  com.apple.NavigationServices 3.5.3 (181) <28CDD978-030E-7D4A-5334-874A8EBE6C29> /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/NavigationServices.framework/Versions/A/NavigationServices
    0x91ba1000 - 0x91be2ff7  libRIP.A.dylib ??? (???) <9F0ECE75-1F03-60E4-E29C-136A27C13F2E> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/CoreGraphics.framework/Versions/A/Resources/libRIP.A.dylib
    0x91bf6000 - 0x924d4ff7  com.apple.AppKit 6.6.3 (1038.25) <72A9AA47-8DCB-DB07-64F5-F837E98C62D8> /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
    0x924d5000 - 0x92737fe7  com.apple.security 6.1.1 (37594) <9AA7D9BF-852F-111F-68AD-65DD760D4DF3> /System/Library/Frameworks/Security.framework/Versions/A/Security
    0x92738000 - 0x9277afe7  libvDSP.dylib ??? (???) <8F8FFFB3-81E3-2969-5688-D5B0979182E6> /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libvDSP.dylib
    0x927c9000 - 0x928edff7  com.apple.CoreAUC 5.03.2 (5.03.2) <38C77DF1-6F98-4ABF-BE8F-ADA70E9C622D> /System/Library/PrivateFrameworks/CoreAUC.framework/Versions/A/CoreAUC
    0x928ee000 - 0x92923ff7  libGLImage.dylib ??? (???) <A6007BF7-BF3C-96DC-C435-849C6B88C58A> /System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGLImage.dylib
    0x92924000 - 0x92ae0fef  com.apple.ImageIO.framework 3.0.1 (3.0.1) <598CF4F9-7542-E1A7-26D2-584933497A2E> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ImageIO.framework/Versions/A/ImageIO
    0x92b2a000 - 0x92b5fff7  libcups.2.dylib ??? (???) <AFDC4D3C-0FF4-D459-B26C-4BA1093F9142> /usr/lib/libcups.2.dylib
    0x92b67000 - 0x92c95fe7  com.apple.CoreData 102.1 (250) <F33FF4A1-D7F9-4F6D-3153-E5F2588479EB> /System/Library/Frameworks/CoreData.framework/Versions/A/CoreData
    0x92d07000 - 0x92d76ff7  libvMisc.dylib ??? (???) <59243A8C-2B98-3E71-8032-884D4853E79F> /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libvMisc.dylib
    0x93044000 - 0x93044ff7  com.apple.ApplicationServices 38 (38) <8012B504-3D83-BFBB-DA65-065E061CFE03> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/ApplicationServices
    0x93045000 - 0x93096ff7  com.apple.HIServices 1.8.0 (???) <B8EC13DB-A81A-91BF-8C82-66E840C64C91> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/HIServices.framework/Versions/A/HIServices
    0x931a2000 - 0x931a9fff  com.apple.print.framework.Print 6.0 (237) <7A06B15C-B835-096E-7D96-C2FE8F0D21E1> /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/Print.framework/Versions/A/Print
    0x931aa000 - 0x931f0ff7  libauto.dylib ??? (???) <85670A64-3B67-8162-D441-D8E0BE15CA94> /usr/lib/libauto.dylib
    0x931f1000 - 0x93211fe7  libresolv.9.dylib ??? (???) <A48921CB-3FA7-3071-AF9C-2D86FB493A3A> /usr/lib/libresolv.9.dylib
    0x93212000 - 0x93224ff7  com.apple.MultitouchSupport.framework 204.9 (204.9) <B639F02B-33CC-150C-AE8C-1007EA7648F9> /System/Library/PrivateFrameworks/MultitouchSupport.framework/Versions/A/MultitouchSupport
    0x93373000 - 0x93377ff7  IOSurface ??? (???) <C11D3FF3-EB51-A07D-EF24-9C2004115724> /System/Library/Frameworks/IOSurface.framework/Versions/A/IOSurface
    0x93378000 - 0x9337aff7  libRadiance.dylib ??? (???) <462903E2-2E77-FAE5-4ED6-829AAB1980A4> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ImageIO.framework/Versions/A/Resources/libRadiance.dylib
    0x9337b000 - 0x9347cfe7  libxml2.2.dylib ??? (???) <B4C5CD68-405D-0F1B-59CA-5193D463D0EF> /usr/lib/libxml2.2.dylib
    0x9347d000 - 0x935fffe7  libicucore.A.dylib ??? (???) <2B0182F3-F459-B452-CC34-46FE73ADE348> /usr/lib/libicucore.A.dylib
    0x93641000 - 0x93651ff7  libsasl2.2.dylib ??? (???) <C8744EA3-0AB7-CD03-E639-C4F2B910BE5D> /usr/lib/libsasl2.2.dylib
    0x93685000 - 0x93abaff7  libLAPACK.dylib ??? (???) <5E2D2283-57DE-9A49-1DB0-CD027FEFA6C2> /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libLAPACK.dylib
    0x93abb000 - 0x93ae1fff  com.apple.DictionaryServices 1.1.1 (1.1.1) <02709230-9B37-C743-6E27-3FCFD18211F8> /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/DictionaryServices.framework/Versions/A/DictionaryServices
    0x93af1000 - 0x93b09ff7  com.apple.CFOpenDirectory 10.6 (10.6) <1537FB4F-C112-5D12-1E5D-3B1002A4038F> /System/Library/Frameworks/OpenDirectory.framework/Versions/A/Frameworks/CFOpenDirectory.framework/Versions/A/CFOpenDirectory
    0x93b52000 - 0x93c01ff3  com.apple.ColorSync 4.6.2 (4.6.2) <F3F097AC-FDB7-3357-C64F-E28BECF4C15F> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ColorSync.framework/Versions/A/ColorSync
    0x93c02000 - 0x93c05fe7  libmathCommon.A.dylib ??? (???) <1622A54F-1A98-2CBE-B6A4-2122981A500E> /usr/lib/system/libmathCommon.A.dylib
    0x93c10000 - 0x93ca8fe7  edu.mit.Kerberos 6.5.9 (6.5.9) <73EC847F-FF44-D542-2AD5-97F6C8D48F0B> /System/Library/Frameworks/Kerberos.framework/Versions/A/Kerberos
    0x93ca9000 - 0x93cc7ff7  com.apple.CoreVideo 1.6.0 (43.1) <1FB01BE0-B013-AE86-A063-481BB547D2F5> /System/Library/Frameworks/CoreVideo.framework/Versions/A/CoreVideo
    0x93f08000 - 0x93f0dff7  com.apple.OpenDirectory 10.6 (10.6) <92582807-E8F3-3DD9-EB42-4195CFB754A1> /System/Library/Frameworks/OpenDirectory.framework/Versions/A/OpenDirectory
    0x93f1c000 - 0x93f25ff7  com.apple.DiskArbitration 2.3 (2.3) <E9C40767-DA6A-6CCB-8B00-2D5706753000> /System/Library/Frameworks/DiskArbitration.framework/Versions/A/DiskArbitration
    0x93f26000 - 0x93f29ffb  com.apple.help 1.3.1 (41) <67F1F424-3983-7A2A-EC21-867BE838E90B> /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/Help.framework/Versions/A/Help
    0x94041000 - 0x9404ffe7  libz.1.dylib ??? (???) <7B7A02AB-DA99-6180-880E-D28E4F9AA8EB> /usr/lib/libz.1.dylib
    0x9412c000 - 0x9414efef  com.apple.DirectoryService.Framework 3.6 (621.1) <3ED4949F-9604-C109-6586-5CE5F421182B> /System/Library/Frameworks/DirectoryService.framework/Versions/A/DirectoryService
    0x9414f000 - 0x9416aff7  libPng.dylib ??? (???) <3F8682CD-C05B-607D-96E7-767646C77DB8> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ImageIO.framework/Versions/A/Resources/libPng.dylib
    0x941a0000 - 0x941a1ff7  com.apple.TrustEvaluationAgent 1.1 (1) <6C04C4C5-667E-2EBE-EB96-5B67BD4B2185> /System/Library/PrivateFrameworks/TrustEvaluationAgent.framework/Versions/A/TrustEvaluationAgent
    0x941cd000 - 0x94231ffb  com.apple.htmlrendering 72 (1.1.4) <4D451A35-FAB6-1288-71F6-F24A4B6E2371> /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/HTMLRendering.framework/Versions/A/HTMLRendering
    0x94232000 - 0x94328ff7  libGLProgrammability.dylib ??? (???) <82D03736-D30C-C013-BBB1-20ED9687D47F> /System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGLProgrammability.dylib
    0x9433a000 - 0x9433eff7  libGFXShared.dylib ??? (???) <79F4F60E-0A6D-CE9C-282E-FA85825449E3> /System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGFXShared.dylib
    0x943b4000 - 0x94434feb  com.apple.SearchKit 1.3.0 (1.3.0) <9E18AEA5-F4B4-8BE5-EEA9-818FC4F46FD9> /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/SearchKit.framework/Versions/A/SearchKit
    0x947fa000 - 0x948c4fef  com.apple.CoreServices.OSServices 352 (352) <D9F21CA4-EED0-705F-8F3C-F1322D114B52> /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/OSServices.framework/Versions/A/OSServices
    0x948c5000 - 0x948c9ff7  libGIF.dylib ??? (???) <83FB0DCC-355F-A930-E570-0BD95086CC59> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ImageIO.framework/Versions/A/Resources/libGIF.dylib
    0x94946000 - 0x94a4afe7  libcrypto.0.9.8.dylib ??? (???) <2E58547A-91CC-4C1A-9FCC-DA7515FDB68A> /usr/lib/libcrypto.0.9.8.dylib
    0x94aa7000 - 0x94ab8ff7  com.apple.LangAnalysis 1.6.6 (1.6.6) <7A3862F7-3730-8F6E-A5DE-8E2CCEA979EF> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/LangAnalysis.framework/Versions/A/LangAnalysis
    0x94ab9000 - 0x94b68fe3  com.apple.QuickTimeImporters.component 7.6.3 (1591.3) <2E2381EB-5E5E-B714-C65D-FCE349E77094> /System/Library/QuickTime/QuickTimeImporters.component/Contents/MacOS/QuickTimeImporters
    0x94b69000 - 0x94badfe7  com.apple.Metadata 10.6.2 (507.4) <DBCBAE7D-7B34-7806-C0B9-1E6E6D45562F> /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/Metadata.framework/Versions/A/Metadata
    0x94bae000 - 0x94f15ff7  com.apple.QuartzCore 1.6.1 (227.8) <8B90AB08-46A4-1C5C-4E71-C6AB652477B9> /System/Library/Frameworks/QuartzCore.framework/Versions/A/QuartzCore
    0x94f16000 - 0x950bafeb  libSystem.B.dylib ??? (???) <D45B91B2-2B4C-AAC0-8096-1FC48B7E9672> /usr/lib/libSystem.B.dylib
    0x950bb000 - 0x95168fe7  libobjc.A.dylib ??? (???) <DF8E4CFA-3719-3415-0BF1-E8C5E561C3B1> /usr/lib/libobjc.A.dylib
    0x95169000 - 0x951d3fe7  libstdc++.6.dylib ??? (???) <411D87F4-B7E1-44EB-F201-F8B4F9227213> /usr/lib/libstdc++.6.dylib
    0x9538b000 - 0x953ebfe7  com.apple.CoreText 3.1.0 (???) <79FD1B5C-2F93-4C5D-B07B-4DD9088E67DE> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/CoreText.framework/Versions/A/CoreText
    0x95443000 - 0x95443ff7  com.apple.Accelerate 1.5 (Accelerate 1.5) <F642E7A0-3720-FA19-0190-E6DBD9EF2D9B> /System/Library/Frameworks/Accelerate.framework/Versions/A/Accelerate
    0x9544f000 - 0x9544fff7  com.apple.Carbon 150 (152) <608A04AB-F35D-D2EB-6629-16B88FB32074> /System/Library/Frameworks/Carbon.framework/Versions/A/Carbon
    0x9550a000 - 0x955c3fe7  libsqlite3.dylib ??? (???) <16CEF8E8-8C9A-94CD-EF5D-05477844C005> /usr/lib/libsqlite3.dylib
    0x955c4000 - 0x956f0feb  com.apple.audio.toolbox.AudioToolbox 1.6.2 (1.6.2) <9AAFDCBE-C68C-3BB3-8089-83CD2C0B4ED7> /System/Library/Frameworks/AudioToolbox.framework/Versions/A/AudioToolbox
    0x956f1000 - 0x9573efeb  com.apple.DirectoryService.PasswordServerFramework 6.0 (6.0) <BF66BA5D-BBC8-78A5-DBE2-F9DE3DD1D775> /System/Library/PrivateFrameworks/PasswordServer.framework/Versions/A/PasswordServer
    0x9573f000 - 0x95741ff7  com.apple.securityhi 4.0 (36638) <962C66FB-5BE9-634E-0810-036CB340C059> /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/SecurityHI.framework/Versions/A/SecurityHI
    0x9577e000 - 0x9577fff7  com.apple.audio.units.AudioUnit 1.6.2 (1.6.2) <845D5E0D-870D-B7E8-AAC5-8364AC341AA1> /System/Library/Frameworks/AudioUnit.framework/Versions/A/AudioUnit
    0x95926000 - 0x95926ff7  com.apple.Cocoa 6.6 (???) <EA27B428-5904-B00B-397A-185588698BCC> /System/Library/Frameworks/Cocoa.framework/Versions/A/Cocoa
    0x9592e000 - 0x95942ffb  com.apple.speech.synthesis.framework 3.10.35 (3.10.35) <57DD5458-4F24-DA7D-0927-C3321A65D743> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/SpeechSynthesis.framework/Versions/A/SpeechSynthesis
    0x95948000 - 0x95c6bfef  com.apple.HIToolbox 1.6.2 (???) <E02640B9-7BC3-A4B4-6202-9E4127DDFDD6> /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/HIToolbox.framework/Versions/A/HIToolbox
    0x95c6c000 - 0x95c9dff3  libTrueTypeScaler.dylib ??? (???) <6C8916A2-8F85-98E0-AAD5-0020C39C0FC9> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ATS.framework/Versions/A/Resources/libTrueTypeScaler.dylib
    0x95d72000 - 0x95e20ff3  com.apple.ink.framework 1.3.1 (105) <CA3FBDC3-4BBA-7BD9-0777-A7B0751292CD> /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/Ink.framework/Versions/A/Ink
    0x95e2c000 - 0x96dbaff7  com.apple.QuickTimeComponents.component 7.6.3 (1591.3) /System/Library/QuickTime/QuickTimeComponents.component/Contents/MacOS/QuickTimeComponents
    0x96f0f000 - 0x97086fef  com.apple.CoreFoundation 6.6.1 (550.13) <AE9FC6F7-F0B2-DE58-759E-7DB89C021A46> /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation
    0x970ac000 - 0x970acff7  liblangid.dylib ??? (???) <B99607FC-5646-32C8-2C16-AFB5EA9097C2> /usr/lib/liblangid.dylib
    0x97139000 - 0x97139ff7  com.apple.vecLib 3.5 (vecLib 3.5) <17BEEF92-DF30-CD52-FD65-0B7B43B93617> /System/Library/Frameworks/vecLib.framework/Versions/A/vecLib
    0x9713a000 - 0x97183fe7  libTIFF.dylib ??? (???) <5864AE5B-EAEB-F8B6-18FB-3D27B7895A4C> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ImageIO.framework/Versions/A/Resources/libTIFF.dylib
    0x97184000 - 0x9718effb  com.apple.speech.recognition.framework 3.11.1 (3.11.1) <EC0E69C8-A121-70E8-43CF-E6FC4C7779EC> /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/SpeechRecognition.framework/Versions/A/SpeechRecognition
    0x9718f000 - 0x97269ff3  com.apple.DesktopServices 1.5.3 (1.5.3) <DA02AC94-7B0C-BD75-2305-C46A307A5FB0> /System/Library/PrivateFrameworks/DesktopServicesPriv.framework/Versions/A/DesktopServicesPriv
    0x9726a000 - 0x972a7ff7  com.apple.SystemConfiguration 1.10.1 (1.10.1) <BA676C76-6AAD-F630-626D-B9248535294D> /System/Library/Frameworks/SystemConfiguration.framework/Versions/A/SystemConfiguration
    0x972a8000 - 0x972dbff7  com.apple.AE 496.1 (496.1) <1AC75AE2-AF94-2458-0B94-C3BB0115BA4B> /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/AE.framework/Versions/A/AE
    0x972dc000 - 0x97356fef  com.apple.audio.CoreAudio 3.2.2 (3.2.2) <1F97B48A-327B-89CC-7C01-3865179716E0> /System/Library/Frameworks/CoreAudio.framework/Versions/A/CoreAudio
    0x97357000 - 0x9735aff7  libCGXType.A.dylib ??? (???) <483FCF1C-066B-D210-7355-ABC48CA9DB2F> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/CoreGraphics.framework/Versions/A/Resources/libCGXType.A.dylib
    0x9735b000 - 0x9739fff3  com.apple.coreui 2 (113) <D0FA9B36-3708-D5BF-0CC3-6CC1909BC8E6> /System/Library/PrivateFrameworks/CoreUI.framework/Versions/A/CoreUI
    0x973a7000 - 0x973f7fe7  libGLU.dylib ??? (???) <659ADCA2-10EC-59BD-1B0A-4928A965F1D1> /System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGLU.dylib
    0x97589000 - 0x975a5fe3  com.apple.openscripting 1.3.1 (???) <DA16DE48-59F4-C94B-EBE3-7FAF772211A2> /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/OpenScripting.framework/Versions/A/OpenScripting
    0x975a6000 - 0x975bbfff  com.apple.ImageCapture 6.0 (6.0) <3F31833A-38A9-444E-02B7-17619CA6F2A0> /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/ImageCapture.framework/Versions/A/ImageCapture
    0x975bc000 - 0x97664ffb  com.apple.QD 3.33 (???) <196CDBA6-5B87-2767-DD57-082D71B0A5C7> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/QD.framework/Versions/A/QD
    0x97b14000 - 0x97b6eff7  com.apple.framework.IOKit 2.0 (???) <1BE07087-27D5-0E62-F06B-007C2BED4073> /System/Library/Frameworks/IOKit.framework/Versions/A/IOKit
    0x97b6f000 - 0x97c0cfe3  com.apple.LaunchServices 362 (362) <8BE1C1A1-BF71-CE07-F3FB-6057D47AF461> /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/LaunchServices
    0x97c0d000 - 0x97f6bfff  com.apple.RawCamera.bundle 3.0.1 (523) <BB20C4C8-ACEE-7B40-C1A0-4BF4EC6B8796> /System/Library/CoreServices/RawCamera.bundle/Contents/MacOS/RawCamera
    0x97f74000 - 0x97f88fe7  libbsm.0.dylib ??? (???) <14CB053A-7C47-96DA-E415-0906BA1B78C9> /usr/lib/libbsm.0.dylib
    0x97f89000 - 0x97f93fe7  com.apple.audio.SoundManager 3.9.3 (3.9.3) <5F494955-7290-2D91-DA94-44B590191771> /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/CarbonSound.framework/Versions/A/CarbonSound
    0x9805c000 - 0x98067ff7  libCSync.A.dylib ??? (???) <9292E6E3-70C1-1DD7-4213-1044F0FA8381> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/CoreGraphics.framework/Versions/A/Resources/libCSync.A.dylib
    0x980a0000 - 0x98399fef  com.apple.QuickTime 7.6.3 (1591.3) <803CC5FD-2369-83B5-795D-A8963620EFAC> /System/Library/Frameworks/QuickTime.framework/Versions/A/QuickTime
    0x9839a000 - 0x983a7ff7  com.apple.NetFS 3.2.1 (3.2.1) <5E61A00B-FA16-9D99-A064-47BDC5BC9A2B> /System/Library/Frameworks/NetFS.framework/Versions/A/NetFS
    0x983b3000 - 0x98623ffb  com.apple.Foundation 6.6.1 (751.14) <CD815A50-BB33-5AA1-DD73-A5B07D394DDA> /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
    0x98624000 - 0x98a3aff7  libBLAS.dylib ??? (???) <C4FB303A-DB4D-F9E8-181C-129585E59603> /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libBLAS.dylib
    0x99452000 - 0x9962dff3  libType1Scaler.dylib ??? (???) <F9FEA41E-F079-87B8-04A9-7FF3B2931B79> /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ATS.framework/Versions/A/Resources/libType1Scaler.dylib
    0x9962e000 - 0x9963aff7  libkxld.dylib ??? (???) <3D2C5BA3-6A8D-C861-B346-0E19942D9AF1> /usr/lib/system/libkxld.dylib
    0xba900000 - 0xba916ff7  libJapaneseConverter.dylib ??? (???) <4FB5CEEB-8D3E-8C57-1718-81D7CAFBFE69> /System/Library/CoreServices/Encodings/libJapaneseConverter.dylib
    0xbab00000 - 0xbab21fe7  libKoreanConverter.dylib ??? (???) <A23F9980-5CC8-A44D-6FD6-DBFCBFF4FF28> /System/Library/CoreServices/Encodings/libKoreanConverter.dylib
    0xffff0000 - 0xffff1fff  libSystem.B.dylib ??? (???) <D45B91B2-2B4C-AAC0-8096-1FC48B7E9672> /usr/lib/libSystem.B.dylib
    
    Model: MacBookPro5,1, BootROM MBP51.007E.B05, 2 processors, Intel Core 2 Duo, 2.93 GHz, 4 GB, SMC 1.41f2
    Graphics: NVIDIA GeForce 9600M GT, NVIDIA GeForce 9600M GT, PCIe, 512 MB
    Graphics: NVIDIA GeForce 9400M, NVIDIA GeForce 9400M, PCI, 256 MB
    Memory Module: global_name
    AirPort: spairport_wireless_card_type_airport_extreme (0x14E4, 0x8D), Broadcom BCM43xx 1.0 (5.10.91.26)
    Bluetooth: Version 2.2.4f3, 2 service, 1 devices, 1 incoming serial ports
    Network Service: AirPort, AirPort, en1
    Serial ATA Device: Hitachi HTS543232L9SA02, 298.09 GB
    Serial ATA Device: MATSHITADVD-R   UJ-868
    USB Device: Built-in iSight, 0x05ac  (Apple Inc.), 0x8507, 0x24400000
    USB Device: BRCM2046 Hub, 0x0a5c  (Broadcom Corp.), 0x4500, 0x06100000
    USB Device: Bluetooth USB Host Controller, 0x05ac  (Apple Inc.), 0x8213, 0x06110000
    USB Device: Apple Internal Keyboard / Trackpad, 0x05ac  (Apple Inc.), 0x0236, 0x04600000
    USB Device: IR Receiver, 0x05ac  (Apple Inc.), 0x8242, 0x04500000

Now maybe Flash never crashes for Kevin. But I'm kind of accustomed to this. It's why I have [ClickToFlash](http://rentzsch.github.com/clicktoflash/) enabled, so I don't get Flash running and wasting my processor cycles unless I explicitly ask for it.

