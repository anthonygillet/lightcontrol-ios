//
//  LightStatus.m
//  LightControl
//
//  Created by Anthony Gillet on 8/5/12.
//  
//

#import "LightRequest.h"
#import "LightServer.h"

@implementation LightRequest

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
+ (void) requestWithLightId:(NSString*)lightId
                    command:(NSString*)command
                 completion:(void (^)(NSString* result))onCompletion
                    failure:(void(^)(NSString* reason))onFailure
{
    (void) [[LightRequest alloc] initRequestWithLightId:lightId 
                                                command:command
                                                  level:-1
                                             completion:onCompletion 
                                                failure:onFailure];
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
+ (void) requestWithLightId:(NSString*)lightId
                    command:(NSString*)command
                      level:(NSUInteger)level
                 completion:(void (^)(NSString* result))onCompletion
                    failure:(void(^)(NSString* reason))onFailure
{
    (void) [[LightRequest alloc] initRequestWithLightId:lightId 
                                                command:command 
                                                  level:level
                                             completion:onCompletion 
                                                failure:onFailure];
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (id) initRequestWithLightId:(NSString*)lightId
                      command:(NSString*)command
                        level:(NSUInteger)level
                   completion:(void (^)(NSString* result))onCompletion
                      failure:(void(^)(NSString* reason))onFailure
{
    self = [super init];
    
    if (self != nil)
    {
        completion = onCompletion;
        failure = onFailure;
        
        NSMutableString* url = [[NSMutableString alloc] initWithFormat:
                                [SERVER_ADDR stringByAppendingString:@"/?device=%@&cmd=%@"],
                                lightId,
                                command];
        if (level > 0)
        {
            [url appendFormat:@"&level=%d", level];
        }
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString: url] 
                                                      cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
                                                  timeoutInterval:60.0];
        NSLog(@"Sending request: %@", [[request URL] absoluteString]);

        NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (theConnection)
        {
            responseData = [[NSMutableData alloc] initWithCapacity:2048];
        }
        else
        {
            NSLog(@"Oops?!?");
        }
        
    }
    return self;
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"connection didFailWithError, error = %@", [error localizedDescription]);
    [responseData setLength:0];
    failure([error localizedDescription]);
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"connection didReceiveResponse");
    [responseData setLength:0];
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"connection didReceiveData");
    [responseData appendData:data];
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
    NSString* rawResponse = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    NSString* response = [rawResponse stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"responseData: '%@'", responseData);
    NSLog(@"response: '%@'", response);
    
    if ([response length] >= 7 && [[response substringToIndex:7] isEqualToString:@"error: "])
    {
        failure([response substringFromIndex:7]);
    }
    else
    {
        completion(response);
    }
    
    [responseData setLength:0];
}

@end
