//
//  LightDatabase.h
//  LightControl
//
//  Created by Anthony Gillet on 8/28/12.
//  
//

#import <UIKit/UIKit.h>

@class Light;
@class Thermostat;

@interface LightDatabase : NSObject
{
    NSMutableArray* lightSections;
    NSMutableArray* thermostats;
}

-(NSInteger)numLightSections;
-(NSInteger)numLightsForSection:(NSInteger)sectionIndex;
-(NSString*)lightSectionTitleAtIndex:(NSInteger)sectionIndex;
-(NSMutableArray*)lightSectionAtIndex:(NSInteger)sectionIndex;
-(void)addLightSection:(NSString*)section;
-(Light*)lightForIndexPath:(NSIndexPath*)indexPath;
-(void)addLight:(Light*)light atIndexPath:(NSIndexPath*)indexPath;
-(void)deleteLightAtIndexPath:(NSIndexPath*)indexPath;
-(void)moveLightAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
-(void)reloadLights;
-(BOOL)isAnyLightLoading;

-(NSInteger)numThermostats;
-(NSString*)thermostatTitleAtIndex:(NSInteger)index;
-(Thermostat*)thermostatAtIndex:(NSInteger)index;
-(void)reloadThermostats;
-(BOOL)isAnyThermostatLoading;

@end
