//
//  ThermostatTableViewController.m
//  LightControl
//
//  Created by Anthony Gillet on 10/22/12.
//
//

#import "ThermostatTableViewController.h"

#import "LightControlAppDelegate.h"
#import "ThermostatTableViewCell.h"
#import "LightDatabase.h"

@interface ThermostatTableViewController ()

@end

@implementation ThermostatTableViewController

@synthesize thermostatCell;

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Thermostats";
        self.tabBarItem.image = [UIImage imageNamed:@"temp_tab.png"];
        
        refresher = [[UIRefreshControl alloc] init];
        [refresher addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
        self.refreshControl = refresher;
    }
    return self;
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)viewDidLoad
{
    [LIGHT_DATABASE reloadThermostats];
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)refresh
{
    NSLog(@"Refresh thermostats");
    [LIGHT_DATABASE reloadThermostats];
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)addItem
{
    NSLog(@"Add thermostat");
}


#pragma mark - Table view data source

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [LIGHT_DATABASE numThermostats];
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [LIGHT_DATABASE thermostatTitleAtIndex:section];
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ThermostatTableViewCell";
    ThermostatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"ThermostatTableViewCell_iPhone" owner:self options:nil];
        cell = thermostatCell;
        self.thermostatCell = nil;
    }
    
    Thermostat* thermostat = [LIGHT_DATABASE thermostatAtIndex:indexPath.section];
    [cell setValuesFromThermostat:thermostat];
    thermostat.delegate = self;
    
    return (UITableViewCell*)cell;
}

#pragma mark - Table view delegate

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Thermostat* thermostat = [LIGHT_DATABASE thermostatAtIndex:indexPath.section];
    if (![thermostat loading])
    {
        thermostat.delegate = self;
        [thermostat reload];
    }
}

#pragma mark - Thermostat delegate

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void) startedLoadingDevice:(NSString *)deviceId
{
    [self.tableView reloadData];
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void) finishedLoadingDevice:(NSString *)deviceId
{
    [self.tableView reloadData];

    if (![LIGHT_DATABASE isAnyThermostatLoading])
    {
        [refresher endRefreshing];
    }
}



@end
