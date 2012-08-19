//
//  AppDotNetClient.m
//  iOS-Example
//
//  Created by Stuart Hall on 19/08/12.
//  Copyright (c) 2012 Stuart Hall. All rights reserved.
//

#import "AppDotNetClient.h"

#import "AFJSONRequestOperation.h"

@interface AppDotNetClient()
@property (nonatomic, copy) NSString* token;

@property (nonatomic, copy) NSString* clientId;
@property (nonatomic, copy) NSString* callbackURL;
@property (nonatomic, strong) NSArray* scopes;
@end

@implementation AppDotNetClient

static NSString* const kBaseURLString = @"https://alpha-api.app.net";
static NSString* const kTokenKey = @"kAppDotNetTokenKey";

@synthesize token=_token;

@synthesize clientId;
@synthesize callbackURL;
@synthesize scopes;

+ (AppDotNetClient *)sharedClient
{
    static AppDotNetClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AppDotNetClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setParameterEncoding:AFFormURLParameterEncoding];
    
    // Load the token
    self.token = [[NSUserDefaults standardUserDefaults] objectForKey:kTokenKey];
    
    return self;
}

+ (void)initWithClientId:(NSString*)clientId
          andCallbackURL:(NSString*)callbackURL
               andScopes:(NSArray*)scopes
{
    // All values are required
    assert(clientId);
    assert(callbackURL);
    assert(scopes);
    
    // Store the params, calling sharedClient will
    // ensure we are initialised
    self.sharedClient.clientId = clientId;
    self.sharedClient.callbackURL = callbackURL;
    self.sharedClient.scopes = scopes;
}

+ (BOOL)hasToken
{
    return self.sharedClient.token.length > 0;
}

- (void)setToken:(NSString *)token
{
    // Store the token and persist for next time
    _token = token;
    [[NSUserDefaults standardUserDefaults] setValue:token
                                             forKey:kTokenKey];
    
    // Use a header for auth
    if (token) {
        [self setDefaultHeader:@"Authorization"
                         value:[@"Bearer " stringByAppendingString:token]];
    }
}

+ (NSURL*)authenticationURL
{
    // Initialisation must of occured
    assert(self.sharedClient.clientId);
    assert(self.sharedClient.callbackURL);
    assert(self.sharedClient.scopes);
    
    // Format the oauth URL
    NSString* url = [NSString stringWithFormat:@"https://alpha.app.net/oauth/authenticate"
                     "?client_id=%@"
                     "&response_type=token"
                     "&scope=%@"
                     "&redirect_uri=%@",
                     self.sharedClient.clientId,
                     [self.sharedClient.scopes componentsJoinedByString:@"%20"],
                     self.sharedClient.callbackURL];
    return [NSURL URLWithString:url];
}

+ (BOOL)parseURLForToken:(NSURL*)url
{
    // Check if it's our required URL
    NSString* cleanUrl = [[url absoluteString] lowercaseString];
    NSString* expectedUrl = [[self.sharedClient.callbackURL lowercaseString] stringByAppendingString:@"#access_token="];
    
    if ([cleanUrl hasPrefix:expectedUrl]) {
        NSString* token = [[url absoluteString] substringFromIndex:expectedUrl.length];
        if (token.length > 0) {
            self.sharedClient.token = token;
            return YES;
        }
    }
    
    return NO;
}

+ (void)forgetToken
{
    self.sharedClient.token = nil;
}

#pragma mark - Error Handling

+ (void)handleError:(NSError*)error
     responseObject:(id)responseObject
            failure:(AppDotNetClientFailure)failure
{
    NSNumber* errorCode = nil;
    NSString* message = nil;
    if (responseObject) {
        NSError *jsonError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if (json && [json isKindOfClass:[NSDictionary class]]) {
            errorCode = [json valueForKeyPath:@"error.code"];
            message = [json valueForKeyPath:@"error.message"];
        }
    }
    failure(error, errorCode, message);
}

#pragma mark - Endpoint

+ (void)postUpdate:(NSString*)text
         replyToId:(NSString*)replyToId
       annotations:(NSString*)annotations
             links:(NSString*)links
           success:(void (^)(NSString* identifier))success
           failure:(AppDotNetClientFailure)failure
{
    // Text is required
    assert(text);
    assert(self.sharedClient.token);
    
    // Assemble the parameters
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:text, @"text", nil];
    if (replyToId) [params setObject:replyToId forKey:@"reply_to"];
    if (annotations) [params setObject:replyToId forKey:@"annotations"];
    if (links) [params setObject:replyToId forKey:@"links"];
    
    // Post away
    [self.sharedClient postPath:@"stream/0/posts"
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            success([responseObject objectForKey:@"id"]);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self handleError:failure
                               responseObject:operation.responseData
                                      failure:failure];
                        }];
}

@end
