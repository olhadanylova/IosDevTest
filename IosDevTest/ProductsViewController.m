//
//  ProductsViewController.m
//  IosDevTest
//
//  Created by Olha Danylova on 26.01.17.
//  Copyright © 2017 Olha Danylova. All rights reserved.
//

#import "ProductsViewController.h"
#import "ProductDetailsViewController.h"
#import "Backendless.h"
#import "Product.h"

#define PAGESIZE 10

static long size;
static int offset;

@interface ProductsViewController () {
    BackendlessDataQuery *query;
    int numberOfRows;
}
@end

@implementation ProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailViewController = (ProductDetailsViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    [self retrieveProductsOnLoad];
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}


#pragma mark - Paging

// Retrieve first PAGESIZE products.
- (void)retrieveProductsOnLoad {
    offset = 0;
    query = [BackendlessDataQuery query];
    query.queryOptions.pageSize = @(PAGESIZE);
    
    [[backendless.persistenceService of:[Product class]] find:query
                                                     response:^(BackendlessCollection *products) { [self getPageAsync:products offset:offset]; }
                                                        error:^(Fault *fault) { NSLog(@"Server reported an error: %@", fault); }];
}


- (void)getPageAsync:(BackendlessCollection *)products offset:(int)offset {
    // Current products count.
    size = [[products getCurrentPage] count];
    if (!size) return;
    NSLog(@"Loaded %lu product in the current page", size);
    
    // Reload table view.
    numberOfRows += size;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    NSArray *prod = [[[backendless.persistenceService of:[Product class]] find:nil] data];
    if (numberOfRows == [prod count]) self.buttonLoadMore.enabled = NO;
}


#pragma mark - Buttons actions

- (IBAction)pressedLoadMore:(id)sender {
    // Increase the position of the object from which to retrieve next products.
    offset += size;
    [[[backendless.persistenceService of:[Product class]] find:query]   // = BackendlessCollection *products
     getPage:offset pageSize:PAGESIZE
     response:^(BackendlessCollection *products) { [self getPageAsync:products offset:offset]; }
     error:^(Fault *fault) { NSLog(@"Server reported an error: %@", fault); }];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //        NSDate *object = self.objects[indexPath.row];
        //        ProductDetailsViewController *controller = (ProductDetailsViewController *)[[segue destinationViewController] topViewController];
        //        [controller setDetailItem:object];
        //        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        //        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    //    NSDate *object = self.objects[indexPath.row];
    //    cell.textLabel.text = [object description];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
