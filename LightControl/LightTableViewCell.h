//
//  LightTableViewCell.h
//  LightControl
//
//  Created by Anthony Gillet on 8/28/12.
//  
//

#import <UIKit/UIKit.h>

@class Light;

@interface LightTableViewCell : UITableViewCell
{
    BOOL loading;
}

@property (nonatomic, assign) Light* light;
@property (nonatomic, assign) IBOutlet UILabel* lightLabel;
@property (nonatomic, assign) IBOutlet UISwitch* lightSwitch;
@property (nonatomic, assign) IBOutlet UISlider* lightSlider; 
@property (nonatomic, assign) IBOutlet UIActivityIndicatorView* lightActivityIndicator;
@property (nonatomic, assign) IBOutlet UIImageView* lightImage;

- (void) setValuesFromLight:(Light*)theLight;

@end
