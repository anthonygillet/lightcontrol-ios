//
//  Light.m
//  LightControl
//
//  Created by Anthony Gillet on 4/1/10.
//
//

#import "Light.h"

#import "LightRequest.h"

@implementation Light

@synthesize deviceId, deviceName, level, loading, enabled, delegate;

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (id) initWithDeviceName:(NSString*) newDeviceName
                 deviceId:(NSString*) newDeviceId
{
    self = [super init];
    if (self != nil)
    {
        deviceId = [newDeviceId copy];
        deviceName = [newDeviceName copy];
        level = 0;
        loading = NO;
        enabled = NO;
        delegate = nil;
    }
    return self;
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void) reload
{
    NSLog(@"Reloading device %@", deviceId);
    loading = YES;
    [delegate startedLoadingDevice:deviceId];
    [self sendStatusRequest];
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)switchAction:(id)sender
{
    UISwitch* switchCtl = sender;
    level = switchCtl.on ? 255 : 0;
    [self sendOnOffRequest];
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)sliderAction:(id)sender
{
    UISlider* sliderCtl = sender;
    level = (NSInteger) sliderCtl.value;
    [self sendOnOffRequest];
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)sendStatusRequest
{
    [LightRequest requestWithLightId:deviceId
                             command:@"status"
                          completion:^(NSString* result) {
                              NSLog(@"Success loading light '%@'! Result: %@", deviceName, result);
                              level = [result integerValue];
                              enabled = YES;
                              loading = NO;
                              [delegate finishedLoadingDevice:deviceId];
                          }
                             failure:^(NSString* reason) {
                                 NSLog(@"Failure loading light %@!  Reason: %@", deviceName, reason);
                                 enabled = NO;
                                 loading = NO;
                                 [delegate finishedLoadingDevice:deviceId];
                             }];
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)sendOnOffRequest
{
    [LightRequest requestWithLightId:deviceId
                             command:level > 0 ? @"on" : @"off"
                               level:level
                          completion:^(NSString* result) {
                              NSLog(@"Success sending light command!");
                              enabled = YES;
                              loading = NO;
                              [delegate finishedLoadingDevice:deviceId];
                          }
                             failure:^(NSString* reason) {
                                 NSLog(@"Failure sending command to light %@!  Reason: %@", deviceName, reason);
                                 enabled = NO;
                                 loading = NO;
                                 [delegate finishedLoadingDevice:deviceId];
                             }];
}

@end
