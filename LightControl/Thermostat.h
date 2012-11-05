//
//  Thermostat.h
//  LightControl
//
//  Created by Anthony Gillet on 10/22/12.
//
//

typedef enum {
    MODE_OFF=0,
    MODE_HEAT=1,
    MODE_COOL=2,
    MODE_AUTO=3
} ThermostatMode;

@protocol ThermostatDelegate <NSObject>
- (void)startedLoadingDevice:(NSString*)deviceId;
- (void)finishedLoadingDevice:(NSString*)deviceId;
@end

#import <Foundation/Foundation.h>

@interface Thermostat : NSObject
{
}

@property (nonatomic, readonly) NSString*   deviceId;
@property (nonatomic, readonly) NSString*   deviceName;
@property (nonatomic, assign)   NSUInteger  ambient;
@property (nonatomic, assign)   NSUInteger  coolSetpoint;
@property (nonatomic, assign)   NSUInteger  heatSetpoint;
@property (nonatomic, assign)   ThermostatMode mode;
@property (nonatomic, assign)   BOOL        loading;
@property (nonatomic, assign)   BOOL        enabled;
@property (nonatomic, assign)   id<ThermostatDelegate> delegate;

- (id) initWithDeviceName:(NSString*) newDeviceName
                 deviceId:(NSString*) newDeviceId;

- (void) reload;

- (void)setCoolSetpoint:(NSUInteger)theCoolSetpoint;

- (void)setHeatSetpoint:(NSUInteger)theHeatSetpoint;

- (void)setMode:(ThermostatMode)theMode;

@end
