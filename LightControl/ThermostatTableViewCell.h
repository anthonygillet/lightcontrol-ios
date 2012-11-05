//
//  ThermostatTableViewCell.h
//  LightControl
//
//  Created by Anthony Gillet on 10/22/12.
//
//

#import <UIKit/UIKit.h>

@class Thermostat;

@interface ThermostatTableViewCell : UITableViewCell
{
    BOOL loading;
}

@property (nonatomic, assign) Thermostat* thermostat;
@property (nonatomic, assign) IBOutlet UILabel* ambient;
@property (nonatomic, assign) IBOutlet UILabel* coolSetpoint;
@property (nonatomic, assign) IBOutlet UILabel* heatSetpoint;
@property (nonatomic, assign) IBOutlet UIButton* coolSetpointUpButton;
@property (nonatomic, assign) IBOutlet UIButton* coolSetpointDownButton;
@property (nonatomic, assign) IBOutlet UIButton* heatSetpointUpButton;
@property (nonatomic, assign) IBOutlet UIButton* heatSetpointDownButton;
@property (nonatomic, assign) IBOutlet UISegmentedControl* modeSelector;
@property (nonatomic, assign) IBOutlet UIActivityIndicatorView* thermostatActivityIndicator;

- (void) setValuesFromThermostat:(Thermostat*)theThermostat;

@end
