//
//  ThermostatTableViewController.h
//  LightControl
//
//  Created by Anthony Gillet on 10/22/12.
//
//

#import <UIKit/UIKit.h>

#import "Thermostat.h"

@class ThermostatTableViewCell;
@class LightDatabase;

@interface ThermostatTableViewController : UITableViewController <ThermostatDelegate>
{
    ThermostatTableViewCell *thermostatCell;
    UIRefreshControl* refresher;
    BOOL loadedOnce;
}

@property (nonatomic, retain) IBOutlet UITableViewCell *thermostatCell;

@end
