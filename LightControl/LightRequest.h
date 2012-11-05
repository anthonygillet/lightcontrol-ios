//
//  LightStatus.h
//  LightControl
//
//  Created by Anthony Gillet on 8/5/12.
//  
//

#import <Foundation/Foundation.h>


@interface LightRequest : NSObject
{
    void (^completion)(NSString* result);
    void (^failure)(NSString* reason);
    NSMutableData*   responseData;
}

+ (void) requestWithLightId:(NSString*)lightId
                    command:(NSString*)command
                 completion:(void (^)(NSString* result))onCompletion
                    failure:(void(^)(NSString* reason))onFailure;

+ (void) requestWithLightId:(NSString*)lightId
                    command:(NSString*)command
                      level:(NSUInteger)level
                 completion:(void (^)(NSString* result))onCompletion
                    failure:(void(^)(NSString* reason))onFailure;

@end
