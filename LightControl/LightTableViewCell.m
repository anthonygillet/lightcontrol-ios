//
//  LightTableViewCell.m
//  LightControl
//
//  Created by Anthony Gillet on 8/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LightTableViewCell.h"
#import "LightTableViewController.h"

@implementation LightTableViewCell

@synthesize light, controller, lightLabel, lightSlider, lightSwitch, lightActivityIndicator, lightImage;

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
    
    lightLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadLight)];
    [lightLabel addGestureRecognizer:tapGesture];

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

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void) reloadLight
{
    if (![light loading])
    {
        light.delegate = self;
        [light reload];
    }
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void) startedLoadingDevice:(NSString *)deviceId
{
    [controller.tableView reloadData];
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void) finishedLoadingDevice:(NSString *)deviceId
{
    [controller.tableView reloadData];
}

@end
