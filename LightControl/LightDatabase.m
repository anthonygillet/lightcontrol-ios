//
//  LightDatabase.m
//  LightControl
//
//  Created by Anthony Gillet on 8/28/12.
//  
//

#import "LightDatabase.h"

#import "Light.h"
#import "Thermostat.h"

@implementation LightDatabase

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (id) init
{
    self = [super init];
    if (self != nil)
    {
        NSMutableArray* firstLights = 
        [[NSMutableArray alloc] initWithObjects:
         [[Light alloc] initWithDeviceName:@"Media Room Front" deviceId:@"131B62"],
         [[Light alloc] initWithDeviceName:@"Media Room Back" deviceId:@"133B4D"], nil];
        NSMutableDictionary* firstSection = 
        [[NSMutableDictionary alloc] initWithObjectsAndKeys:firstLights, @"lights", @"Basement", @"title", nil];

        NSMutableArray* secondLights = 
        [[NSMutableArray alloc] initWithObjects:
         [[Light alloc] initWithDeviceName:@"Breakfast Area" deviceId:@"1391E9"],
         [[Light alloc] initWithDeviceName:@"Recessed Lights" deviceId:@"12BD52"],
         [[Light alloc] initWithDeviceName:@"Pendant Lights" deviceId:@"1339A2"],
         [[Light alloc] initWithDeviceName:@"Kitchen Sink" deviceId:@"14AC5E"], nil];
        NSMutableDictionary* secondSection = 
        [[NSMutableDictionary alloc] initWithObjectsAndKeys:secondLights, @"lights", @"Kitchen", @"title", nil];

        lightSections = [[NSMutableArray alloc] initWithObjects:firstSection, secondSection, nil];
        
        thermostats =
        [[NSMutableArray alloc] initWithObjects:
         [[Thermostat alloc] initWithDeviceName:@"Upstairs Thermostat" deviceId:@"11BE1E"],
         [[Thermostat alloc] initWithDeviceName:@"Downstairs Thermostat" deviceId:@"11B4E2"], nil];
    }
    return self;
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
-(NSInteger)numLightSections
{
    return [lightSections count];
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
-(NSInteger)numLightsForSection:(NSInteger)sectionIndex
{
    return [[self lightSectionAtIndex:sectionIndex] count];
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
-(NSString*)lightSectionTitleAtIndex:(NSInteger)sectionIndex
{
    NSMutableDictionary* section = [lightSections objectAtIndex:sectionIndex];
    return (NSString*) [section objectForKey:@"title"];
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
-(NSMutableArray*)lightSectionAtIndex:(NSInteger)sectionIndex
{
    NSMutableDictionary* section = [lightSections objectAtIndex:sectionIndex];
    return (NSMutableArray*) [section objectForKey:@"lights"];
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
-(void)addLightSection:(NSString*)section
{
    [lightSections addObject:section];
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
-(Light*)lightForIndexPath:(NSIndexPath*)indexPath
{
    return (Light*)[[self lightSectionAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
-(void)addLight:(Light*)light atIndexPath:(NSIndexPath*)indexPath
{
    [[self lightSectionAtIndex:indexPath.section] insertObject:light atIndex:indexPath.row];
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
-(void)deleteLightAtIndexPath:(NSIndexPath*)indexPath
{
    [[self lightSectionAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
-(void)moveLightAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    Light* lightToMove = (Light*)[[self lightSectionAtIndex:fromIndexPath.section] objectAtIndex:fromIndexPath.row];
    [[self lightSectionAtIndex:fromIndexPath.section] removeObjectAtIndex:fromIndexPath.row];
    
    [[self lightSectionAtIndex:toIndexPath.section] insertObject:lightToMove atIndex:toIndexPath.row];
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
-(void)reloadLights
{
    for (int i = 0; i < [lightSections count]; i++)
    {
        NSMutableArray* lightsInSection = [self lightSectionAtIndex:i];
        for (Light* light in lightsInSection)
        {
            [light reload];
        }
    }
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
-(BOOL)isAnyLightLoading;
{
    for (int i = 0; i < [lightSections count]; i++)
    {
        NSMutableArray* lightsInSection = [self lightSectionAtIndex:i];
        for (Light* light in lightsInSection)
        {
            if (light.loading)
            {
                return YES;
            }
        }
    }
    
    return NO;
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
-(NSInteger)numThermostats
{
    return [thermostats count];
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
-(NSString*)thermostatTitleAtIndex:(NSInteger)index
{
    return [((Thermostat*)[thermostats objectAtIndex:index]) deviceName];
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
-(Thermostat*)thermostatAtIndex:(NSInteger)index
{
    return (Thermostat*)[thermostats objectAtIndex:index];
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
-(void)reloadThermostats
{
    for (Thermostat* thermostat in thermostats)
    {
        [thermostat reload];
    }
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
-(BOOL)isAnyThermostatLoading
{
    for (Thermostat* thermostat in thermostats)
    {
        if (thermostat.loading)
        {
            return YES;
        }
    }
    
    return NO;
}

@end
