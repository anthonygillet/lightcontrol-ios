//
//  ThermostatTableViewCell.m
//  LightControl
//
//  Created by Anthony Gillet on 10/22/12.
//
//

#import "ThermostatTableViewCell.h"
#import "ThermostatTableViewController.h"

@implementation ThermostatTableViewCell

@synthesize thermostat, controller, ambient, coolSetpoint, heatSetpoint, coolSetpointUpButton, coolSetpointDownButton,
            heatSetpointUpButton, heatSetpointDownButton, modeSelector, thermostatActivityIndicator;

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (editing)
    {
        [thermostatActivityIndicator stopAnimating];
        [ambient setHidden:YES];
        [coolSetpoint setHidden:YES];
        [heatSetpoint setHidden:YES];
        [coolSetpointUpButton setHidden:YES];
        [coolSetpointDownButton setHidden:YES];
        [heatSetpointUpButton setHidden:YES];
        [heatSetpointDownButton setHidden:YES];
        [modeSelector setHidden:YES];
    }
    else
    {
        [self updateDisplay];
    }
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void) setValuesFromThermostat:(Thermostat *)theThermostat
{
    thermostat = theThermostat;
    ambient.text = [NSString stringWithFormat:@"%d°", theThermostat.ambient];
    heatSetpoint.text = [NSString stringWithFormat:@"%d°", theThermostat.heatSetpoint];
    coolSetpoint.text = [NSString stringWithFormat:@"%d°", theThermostat.coolSetpoint];
    modeSelector.selectedSegmentIndex = theThermostat.mode;
    
    [coolSetpointUpButton addTarget:self action:@selector(setpointAction:) forControlEvents:UIControlEventTouchUpInside];
    [coolSetpointDownButton addTarget:self action:@selector(setpointAction:) forControlEvents:UIControlEventTouchUpInside];
    [heatSetpointUpButton addTarget:self action:@selector(setpointAction:) forControlEvents:UIControlEventTouchUpInside];
    [heatSetpointDownButton addTarget:self action:@selector(setpointAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [modeSelector addTarget:self action:@selector(modeAction:) forControlEvents:UIControlEventValueChanged];

    ambient.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadThermostat)];
    [ambient addGestureRecognizer:tapGesture];
    
    [self updateDisplay];
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)setpointAction:(id)sender
{
    if (sender == heatSetpointUpButton)
    {
        [thermostat setHeatSetpoint:thermostat.heatSetpoint+1];
        heatSetpoint.text = [NSString stringWithFormat:@"%d°", thermostat.heatSetpoint];
    }
    else if (sender == heatSetpointDownButton)
    {
        [thermostat setHeatSetpoint:thermostat.heatSetpoint-1];
        heatSetpoint.text = [NSString stringWithFormat:@"%d°", thermostat.heatSetpoint];
    }
    if (sender == coolSetpointUpButton)
    {
        [thermostat setCoolSetpoint:thermostat.coolSetpoint+1];
        coolSetpoint.text = [NSString stringWithFormat:@"%d°", thermostat.coolSetpoint];
    }
    else if (sender == coolSetpointDownButton)
    {
        [thermostat setCoolSetpoint:thermostat.coolSetpoint-1];
        coolSetpoint.text = [NSString stringWithFormat:@"%d°", thermostat.coolSetpoint];
    }
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)modeAction:(id)sender
{
    if (sender == modeSelector)
    {
        [thermostat setMode: modeSelector.selectedSegmentIndex];
        [thermostat reload];
    }
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void) updateDisplay
{
    switch (thermostat.mode)
    {
        case MODE_HEAT:
            [coolSetpoint setHidden:YES];
            [coolSetpointUpButton setEnabled:NO];
            [coolSetpointDownButton setEnabled:NO];
            [heatSetpoint setHidden:NO];
            [heatSetpointUpButton setEnabled:YES];
            [heatSetpointDownButton setEnabled:YES];
            break;
        case MODE_COOL:
            [coolSetpoint setHidden:NO];
            [coolSetpointUpButton setEnabled:YES];
            [coolSetpointDownButton setEnabled:YES];
            [heatSetpoint setHidden:YES];
            [heatSetpointUpButton setEnabled:NO];
            [heatSetpointDownButton setEnabled:NO];
            break;
        case MODE_AUTO:
            [coolSetpoint setHidden:NO];
            [coolSetpointUpButton setEnabled:YES];
            [coolSetpointDownButton setEnabled:YES];
            [heatSetpoint setHidden:NO];
            [heatSetpointUpButton setEnabled:YES];
            [heatSetpointDownButton setEnabled:YES];
            break;
        case MODE_OFF:
        default:
            [heatSetpoint setHidden:YES];
            [heatSetpointUpButton setEnabled:NO];
            [heatSetpointDownButton setEnabled:NO];
            [coolSetpoint setHidden:YES];
            [coolSetpointUpButton setEnabled:NO];
            [coolSetpointDownButton setEnabled:NO];
            break;
    }
    
    loading = thermostat.loading;
    
    if (loading)
    {
        [thermostatActivityIndicator startAnimating];
        [ambient setHidden:YES];
        [modeSelector setEnabled:NO];
        [coolSetpoint setHidden:YES];
        [heatSetpoint setHidden:YES];
        [coolSetpointUpButton setEnabled:NO];
        [coolSetpointDownButton setEnabled:NO];
        [heatSetpointUpButton setEnabled:NO];
        [heatSetpointDownButton setEnabled:NO];
    }
    else
    {
        [thermostatActivityIndicator stopAnimating];
        [ambient setHidden:NO];
        [modeSelector setEnabled:YES];
    }
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void) reloadThermostat
{
    if (![thermostat loading])
    {
        thermostat.delegate = self;
        [thermostat reload];
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
