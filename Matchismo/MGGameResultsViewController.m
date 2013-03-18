//
//  MGGameResultsViewController.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/24/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGGameResultsViewController.h"
#import "MGGameResult.h"

@interface MGGameResultsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)changeSorting:(UISegmentedControl *)sender;
- (IBAction)changeFiltering:(UISegmentedControl *)sender;

@property (nonatomic) NSUInteger sortMode;
@property (nonatomic) NSUInteger filterMode;
@property (strong,nonatomic) NSArray* sortedResults;
-(void)reloadData;

@end

@implementation MGGameResultsViewController

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	return self.sortedResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"scoreCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	MGGameResult* result = self.sortedResults[indexPath.row];
	cell.textLabel.text = result.gameType;
	NSDateFormatter* formatter = [NSDateFormatter new];
	formatter.dateStyle = NSDateFormatterShortStyle;
	formatter.timeStyle = NSDateFormatterShortStyle;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %.0fs, %d points",[formatter stringFromDate:result.startTime],result.duration,result.score];
	
	return cell;
}

-(void)viewWillAppear:(BOOL)animated {
	NSLog(@"%@",[MGGameResult allGameResults]);
	[self reloadData];
}

-(void)reloadData {
	SEL comparisonSelectors[] = {@selector(compareByDate:),@selector(compareByScore:),@selector(compareByDuration:)};
	NSArray* filterPredicates = @[[NSPredicate predicateWithValue:YES],
															 [NSPredicate predicateWithFormat:@"gameType LIKE %@",@"*Match*"],
															 [NSPredicate predicateWithFormat:@"gameType == %@",@"Set"]];
	self.sortedResults = [[[MGGameResult allGameResults]
												filteredArrayUsingPredicate:filterPredicates[self.filterMode]]
												sortedArrayUsingSelector:comparisonSelectors[self.sortMode]];
	[self.tableView reloadData];
}

- (IBAction)changeSorting:(UISegmentedControl *)sender {
	self.sortMode = sender.selectedSegmentIndex;
	[self reloadData];
}

- (IBAction)changeFiltering:(UISegmentedControl *)sender {
	self.filterMode = sender.selectedSegmentIndex;
	[self reloadData];
}

@end
