//
//  MainViewController.m
//  VRSlidingPicker
//
//  Created by Venu on 8/5/15.
//  Copyright (c) 2015 VRCo. All rights reserved.
//

#import "MainViewController.h"
#import "VRCollectionView.h"

@interface MainViewController ()<NSURLConnectionDataDelegate, VRCollectionViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    
}
@property (nonatomic, strong) NSMutableArray *collectionViewDataSource;
@property (nonatomic, strong) NSMutableArray *dayDetailsData;
@property (nonatomic, strong) NotesObject *tableViewDataSource;

@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet VRCollectionView *collectionView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setUpNavigationBar];
    
    self.dayDetailsData = [[NSMutableArray alloc] init];
    self.collectionViewDataSource = [[NSMutableArray alloc]init];
    [self getNotesOnline];
    
    //DataSource Init
    for (int i = NumberOfDays-DuplicateValues; i < NumberOfDays; i++) {
        [self.collectionViewDataSource addObject:[NSString stringWithFormat:@" "]];
    }
    for (int i = 1; i <= NumberOfDays; i++) {
        [self.collectionViewDataSource addObject:[NSString stringWithFormat:@"%d",i]];
    }
    for (int i = 1; i <= DuplicateValues; i++) {
        [self.collectionViewDataSource addObject:[NSString stringWithFormat:@" "]];
    }
    [self.collectionView loadWithDataSource:self.collectionViewDataSource];
    [self.collectionView setDelegate:self];
    
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NavigationBar setUp
-(void)setUpNavigationBar{
    
}

#pragma mark - Service calls
- (void) getNotesOnline{
    if (!self.activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.activityIndicator setFrame:CGRectMake(0.0f, 0.0f, 30, 30)];
        self.activityIndicator.center = self.tableView.center;
        [self.view addSubview:self.activityIndicator];
    }
    [self.view setUserInteractionEnabled:NO];
    [self.activityIndicator startAnimating];
    NSString *urlString = @"https://www.dropbox.com/s/g4ic9l6kq0kvyyp/screening.json?raw=1";
    NSMutableURLRequest *getNotesRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [getNotesRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [getNotesRequest setHTTPMethod:@"GET"];
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:getNotesRequest delegate:self];
    if (!theConnection) {
        [self.view setUserInteractionEnabled:YES];
        [self.activityIndicator stopAnimating];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Could not connect" message:@"There seems to be a problem connecting to the network. Please check your Internet Connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertView.tag = 100;
        [alertView show];
    }
}

- (void)parseJsonDataWithJson:(NSDictionary*)dict{
    NSArray *array = [dict valueForKey:@"dates"];
    for (id dict in array) {
        NotesObject *notesObj = [[NotesObject alloc] init];
        [notesObj createNotesObjectWithDictionary:dict];
        [self.dayDetailsData addObject:notesObj];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.view setUserInteractionEnabled:YES];
    [self.activityIndicator stopAnimating];
    if (data) {
        NSLog(@"Connection %@ did receive %lu bytes of data", connection, (unsigned long)[data length]);
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        [self parseJsonDataWithJson:json];
        return;
    }
    NSLog(@"Connection failed");
}

#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableViewDataSource.notesDescription.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.0f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 60.0f)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:headerView.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    [label setText:self.tableViewDataSource.title];
    
    [headerView addSubview:label];
    return headerView;
}

#pragma mark - TableView Delegate
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"AllowContactsCell";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)  {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
    cell.textLabel.text = self.tableViewDataSource.notesDescription[indexPath.row];
    return cell;
}

#pragma mark - VRCollectionView Delegate
- (void)didSelectTheDay:(NSInteger)integer{
    if (self.dayDetailsData.count > integer) {
        self.tableViewDataSource = [self.dayDetailsData objectAtIndex:integer];
    }else{
        self.tableViewDataSource = nil;
    }
    [self.tableView reloadData];
}

@end

@implementation NotesObject

- (void)createNotesObjectWithDictionary:(NSDictionary*)dict{
    //Date String
    NSString *dateString = [dict valueForKey:@"date"];
    NSArray* dateArray = [dateString componentsSeparatedByString: @"/"];
    self.day = [[dateArray objectAtIndex: 0] integerValue];
    self.month = [[dateArray objectAtIndex: 1] integerValue];
    self.year = [[dateArray objectAtIndex: 2] integerValue];
    
    //Title
    NSDictionary *detailsDict = [dict valueForKey:@"details"];
    self.title = [detailsDict valueForKey:@"title"];
    
    //Description
    self.notesDescription = [detailsDict valueForKey:@"description"];
}
@end
