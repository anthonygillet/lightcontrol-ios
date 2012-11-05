//
//  Thermostat.m
//  LightControl
//
//  Created by Anthony Gillet on 10/22/12.
//
//

#import "Thermostat.h"
#import "LightRequest.h"

@implementation Thermostat

@synthesize deviceId, deviceName, ambient, coolSetpoint, heatSetpoint, mode, loading, enabled, delegate;

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
        ambient = 0;
        coolSetpoint = 0;
        heatSetpoint = 0;
        mode = MODE_OFF;
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
    [self sendStatusRequestStep1];
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)sendStatusRequestStep1
{
    [LightRequest requestWithLightId:deviceId
                             command:@"temp_get_ambient"
                          completion:^(NSString* result) {
                              NSLog(@"Success loading ambient temp for '%@'! Result: %@", deviceName, result);
                              ambient = [result integerValue];
                              [self sendStatusRequestStep2];
                          }
                             failure:^(NSString* reason) {
                                 NSLog(@"Failure loading ambient temp for %@!  Reason: %@", deviceName, reason);
                                 ambient = 0;
                                 heatSetpoint = 0;
                                 coolSetpoint = 0;
                                 mode = MODE_OFF;
                                 enabled = NO;
                                 loading = NO;
                                 [delegate finishedLoadingDevice:deviceId];
                             }];
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)sendStatusRequestStep2
{
    [LightRequest requestWithLightId:deviceId
                             command:@"temp_get_mode"
                          completion:^(NSString* result) {
                              NSLog(@"Success loading temp mode for '%@'! Result: %@", deviceName, result);
                              mode = [result integerValue];
                              if (mode == MODE_OFF)
                              {
                                  heatSetpoint = 0;
                                  coolSetpoint = 0;
                                  enabled = YES;
                                  loading = NO;
                                  [delegate finishedLoadingDevice:deviceId];
                              }
                              else
                              {
                                  [self sendStatusRequestStep3];
                              }
                          }
                             failure:^(NSString* reason) {
                                 NSLog(@"Failure loading temp mode for %@!  Reason: %@", deviceName, reason);
                                 heatSetpoint = 0;
                                 coolSetpoint = 0;
                                 mode = MODE_OFF;
                                 enabled = NO;
                                 loading = NO;
                                 [delegate finishedLoadingDevice:deviceId];
                             }];
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)sendStatusRequestStep3
{
    [LightRequest requestWithLightId:deviceId
                             command:@"temp_get_setpoint"
                               level:mode
                          completion:^(NSString* result) {
                              NSArray* setPoints = [result componentsSeparatedByString:@"\n"];
                              if (mode == MODE_HEAT)
                              {
                                  NSLog(@"Success loading heat set point for '%@'! Result: %@", deviceName, result);
                                  heatSetpoint = [[setPoints objectAtIndex:0] integerValue];
                                  coolSetpoint = 0;
                                  enabled = YES;
                                  loading = NO;
                                  [delegate finishedLoadingDevice:deviceId];
                              }
                              else if (mode == MODE_COOL)
                              {
                                  NSLog(@"Success loading cool set point for '%@'! Result: %@", deviceName, result);
                                  heatSetpoint = 0;
                                  coolSetpoint = [[setPoints objectAtIndex:0] integerValue];
                                  enabled = YES;
                                  loading = NO;
                                  [delegate finishedLoadingDevice:deviceId];
                              }
                              else if (mode == MODE_AUTO && [setPoints count] == 2)
                              {
                                  NSLog(@"Success loading heat & cool set point for '%@'! Result: %@", deviceName, result);
                                  heatSetpoint = [[setPoints objectAtIndex:0] integerValue];
                                  coolSetpoint = [[setPoints objectAtIndex:1] integerValue];
                                  enabled = YES;
                                  loading = NO;
                                  [delegate finishedLoadingDevice:deviceId];
                              }
                              else
                              {
                                  NSLog(@"Failure loading set point for %@!  Reason: Malformed result!", deviceName);
                                  enabled = NO;
                                  loading = NO;
                                  heatSetpoint = 0;
                                  coolSetpoint = 0;
                                  [delegate finishedLoadingDevice:deviceId];
                              }
                          }
                             failure:^(NSString* reason) {
                                 NSLog(@"Failure loading set point for %@!  Reason: %@", deviceName, reason);
                                 enabled = NO;
                                 loading = NO;
                                 heatSetpoint = 0;
                                 coolSetpoint = 0;
                                 [delegate finishedLoadingDevice:deviceId];
                             }];
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)setMode:(ThermostatMode)theMode
{
    mode = theMode;

    [LightRequest requestWithLightId:deviceId
                             command:@"temp_set_mode"
                               level:mode
                          completion:^(NSString* result) {
                              NSLog(@"Success setting mode for '%@'! Result: %@", deviceName, result);
                              enabled = YES;
                              loading = NO;
                              //[delegate finishedLoadingDevice:deviceId];
                          }
                             failure:^(NSString* reason) {
                                 NSLog(@"Failure setting mode for %@!  Reason: %@", deviceName, reason);
                                 enabled = NO;
                                 loading = NO;
                                 //[delegate finishedLoadingDevice:deviceId];
                             }];
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)setCoolSetpoint:(NSUInteger)theCoolSetpoint
{
    coolSetpoint = theCoolSetpoint;

    [LightRequest requestWithLightId:deviceId
                             command:@"temp_set_cool_setpoint"
                               level:coolSetpoint
                          completion:^(NSString* result) {
                              NSLog(@"Success setting cool setpoint for '%@'! Result: %@", deviceName, result);
                              enabled = YES;
                              loading = NO;
                              [delegate finishedLoadingDevice:deviceId];
                          }
                             failure:^(NSString* reason) {
                                 NSLog(@"Failure setting cool setpoint for %@!  Reason: %@", deviceName, reason);
                                 enabled = NO;
                                 loading = NO;
                                 [delegate finishedLoadingDevice:deviceId];
                             }];
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)setHeatSetpoint:(NSUInteger)theHeatSetpoint
{
    heatSetpoint = theHeatSetpoint;

    [LightRequest requestWithLightId:deviceId
                             command:@"temp_set_heat_setpoint"
                               level:heatSetpoint
                          completion:^(NSString* result) {
                              NSLog(@"Success setting heat setpoint for '%@'! Result: %@", deviceName, result);
                              enabled = YES;
                              loading = NO;
                              [delegate finishedLoadingDevice:deviceId];
                          }
                             failure:^(NSString* reason) {
                                 NSLog(@"Failure setting heat setpoint for %@!  Reason: %@", deviceName, reason);
                                 enabled = NO;
                                 loading = NO;
                                 [delegate finishedLoadingDevice:deviceId];
                             }];
}


@end
