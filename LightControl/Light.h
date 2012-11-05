//
//  Light.h
//  LightControl
//
//  Created by Anthony Gillet on 4/1/10.
//
//

#import <Foundation/Foundation.h>

@protocol LightDelegate <NSObject>
- (void)startedLoadingDevice:(NSString*)deviceId;
- (void)finishedLoadingDevice:(NSString*)deviceId;
@end

@class LightTableViewCell;

@interface Light : NSObject
{
}

@property (nonatomic, readonly) NSString*   deviceId;
@property (nonatomic, readonly) NSString*   deviceName;
@property (nonatomic, assign)   NSUInteger  level;
@property (nonatomic, assign)   BOOL        loading;
@property (nonatomic, assign)   BOOL        enabled;
@property (nonatomic, assign)   id<LightDelegate> delegate;

- (id) initWithDeviceName:(NSString*) newDeviceName
                 deviceId:(NSString*) newDeviceId;

- (void) reload;

@end
