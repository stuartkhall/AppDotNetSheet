//
//  AppDotNetClient.h
//  iOS-Example
//
//  Created by Stuart Hall on 19/08/12.
//  Copyright (c) 2012 Stuart Hall. All rights reserved.
//

#import "AFHTTPClient.h"

typedef void(^AppDotNetClientFailure)(NSError* error, NSNumber* errorCode, NSString* message);


@interface AppDotNetClient : AFHTTPClient

// Initialisation, see https://github.com/appdotnet/api-spec/blob/master/auth.md
// for details
+ (void)initWithClientId:(NSString*)clientId
          andCallbackURL:(NSString*)callbackURL
               andScopes:(NSArray*)scopes;

// YES if we have a token stored
+ (BOOL)hasToken;

// Fully formatted authentication URL for the browser
+ (NSURL*)authenticationURL;

// Attempts to parse a URL for the token
+ (BOOL)parseURLForToken:(NSURL*)url;

// Forget token
+ (void)forgetToken;

// Post a status
+ (void)postUpdate:(NSString*)text
         replyToId:(NSString*)replyToId
       annotations:(NSString*)annotations
             links:(NSString*)links
           success:(void (^)(NSString* identifier))success
           failure:(AppDotNetClientFailure)failure;

@end
