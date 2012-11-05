//
//  LightTableViewCell.m
//  LightControl
//
//  Created by Anthony Gillet on 8/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LightTableViewCell.h"

#import "Light.h"

@implementation LightTableViewCell

@synthesize light, lightLabel, lightSlider, lightSwitch, lightActivityIndicator, lightImage;

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (editing)
    {
        [lightActivityIndicator stopAnimating];
        [lightSlider setHidden:YES];
        [lightSwitch setHidden:YES];
        [lightImage setHidden:YES];
    }
    else
    {
        [self updateDisplay];
    }
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void) setValuesFromLight:(Light*)theLight
{
    light = theLight;
    lightLabel.text = light.deviceName;
    lightSlider.enabled = lightSwitch.enabled = light.enabled;

    [lightSlider setValue:light.level animated:NO];
    [lightSwitch setOn:(light.level > 0) animated:NO];
    
    [lightSwitch addTarget:theLight action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [lightSlider addTarget:theLight action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [self updateDisplay];
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void) updateDisplay
{
    loading = light.loading;
    if (loading)
    {
        [lightActivityIndicator startAnimating];
        [lightSlider setHidden:YES];
        [lightSwitch setHidden:YES];
        [lightImage setHidden:YES];
    }
    else
    {
        [lightActivityIndicator stopAnimating];
        [lightSlider setHidden:NO];
        [lightSwitch setHidden:NO];
        [lightImage setHidden:NO];
        [lightImage setImage:[UIImage imageNamed:(lightSwitch.on ? @"light_on.png" : @"light_off.png")]];
    }
}

@end
