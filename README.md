# AppDotNetSheet

This project is aimed to be an easy way for iOS developers to add APP.NET sharing to their own applications. It is designed to look and behave similar to the iOS5 TWTweetComposeViewController / Tweet Sheet. I built it as a way to add sharing to our [Discovr](http://discovr.info) apps and a new app we have on the way :)

![Step 1](http://f.cl.ly/items/0r1B2c1e1Z3V0S2o1p18/AppDotNetSheet1.png)
![Step 2](http://f.cl.ly/items/0f2m1q1N0G2z2s1c262T/AppDotNetSheet3.png)
![Step 3](http://f.cl.ly/items/2P291G1C3m1G0U333p47/AppDotNetSheet2.png)

## Disclaimer
Like the API this code is alpha and subject to a lot of changes. I wouldn't ship an app with this code until the API is out of alpha and we can be sure the endpoints won't change.

## Compiling the example project.

**Getting the code**

    git clone https://github.com/stuartkhall/AppDotNetSheet.git
    cd AppDotNetSheet
    git submodule update --init
    
**Adding your app credentials**

    touch iOS-Example/iOS-Example/Credentials.h

Now create a new app at the [APP.NET developer site](https://alpha.app.net/developer/apps/) and add your details to Credentials.h:

    #import <Foundation/Foundation.h>
    static NSString* const kAppDotNetClientId = @"your_client_id";
    static NSString* const kAppDotNetCallbackURL = @"http://yourcallback";
    static NSString* const kAppDotNetScopes = @"write_post stream";

**Open the project**

    open iOS-Example/iOS-Example.xcodeproj/

## Adding to your project

After you have created your project add this repository to it, e.g. as a submodule:

    git submodule add https://github.com/stuartkhall/AppDotNetSheet.git AppDotNetSheet

You'll also need AFNetworking:

    git submodule add https://github.com/AFNetworking/AFNetworking.git AFNetworking

Then drag the AppDotNetClient and AppDotNetSheet folders into your app.

Initialise the client with your details from the [APP.NET developer site](https://alpha.app.net/developer/apps/).

    #import "AppDotNetClient.h"
    ...
    [AppDotNetClient initWithClientId:kAppDotNetClientId
                       andCallbackURL:kAppDotNetCallbackURL
                            andScopes:[kAppDotNetScopes componentsSeparatedByString:@" "]];

And finally show the control:

    AppDotNetComposeViewController* controller = [[AppDotNetComposeViewController alloc] init];
    [self presentModalViewController:controller animated:NO];

## TODO:
If you are a designer or developer please jump in and help out.

* Test, test, test
* Internationalisation / Localisation
* Multiple users
* Update design to better match TWTweetComposeViewController.
* Better error handling.
* Validate tokens.
* Images. 

## Questions

Ask away on APP.NET of course I'm [@stuartkhall](https://alpha.app.net/stuartkhall), or I'm the same handle on Twitter [@stuartkhall](https://twitter.com/stuartkhall)
