//
//  LightTableViewController.h
//  LightControl
//
//  Created by Anthony Gillet on 8/28/12.
//  
//

#import <UIKit/UIKit.h>

#import "Light.h"

@class LightTableViewCell;
@class LightDatabase;

@interface LightTableViewController : UITableViewController <LightDelegate>
{
    LightTableViewCell *lightCell;
    UIRefreshControl* refresher;
}

@property (nonatomic, retain) IBOutlet UITableViewCell *lightCell;

@end
