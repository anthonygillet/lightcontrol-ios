//
//  LightTableViewController.m
//  LightControl
//
//  Created by Anthony Gillet on 8/28/12.
//  
//

#import "LightTableViewController.h"

#import "LightControlAppDelegate.h"
#import "LightTableViewCell.h"
#import "LightDatabase.h"

@interface LightTableViewController ()

@end

@implementation LightTableViewController

@synthesize lightCell;

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Lights";
        self.tabBarItem.image = [UIImage imageNamed:@"light_tab.png"];
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem;

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
    [LIGHT_DATABASE reloadLights];
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
    NSLog(@"Refresh lights");
    [LIGHT_DATABASE reloadLights];
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)addItem
{
    NSLog(@"Add light");
}

#pragma mark - Table view data source

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [LIGHT_DATABASE numLightSections];
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [LIGHT_DATABASE numLightsForSection:section];
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [LIGHT_DATABASE lightSectionTitleAtIndex:section];
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSBundle mainBundle] loadNibNamed:@"LightTableViewCell_iPhone" owner:self options:nil];
    LightTableViewCell* cell = lightCell;
    self.lightCell = nil;
    
    Light* light = [LIGHT_DATABASE lightForIndexPath:indexPath];
    [cell setValuesFromLight:light];
    light.delegate = self;
    
    return (UITableViewCell*)cell;
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
    
    if (editing)
    {
        UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
        self.navigationItem.rightBarButtonItem = addButton;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing)
    {
        // Only allow delete in edit mode
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [LIGHT_DATABASE deleteLightAtIndexPath:indexPath];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [LIGHT_DATABASE moveLightAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - Table view delegate

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Light* light = [LIGHT_DATABASE lightForIndexPath:indexPath];
    if (![light loading])
    {
        light.delegate = self;
        [light reload];
    }
}

#pragma mark - Light delegate

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
    
    if (![LIGHT_DATABASE isAnyLightLoading])
    {
        [refresher endRefreshing];
    }
}


@end
