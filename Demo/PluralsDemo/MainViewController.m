//
//  MainViewController.m
//  PluralsDemo
//
//  Created by Pavel Ivashkov on 2013-02-25.
//  Copyright (c) 2013 Smartling. All rights reserved.
//

#import "MainViewController.h"
#import "PluralsViewController.h"


@interface MainViewController ()

@property(strong, nonatomic) NSArray *model;
@property(strong, nonatomic) UILabel *statusLabel;

@end


@implementation MainViewController

- (id)init
{
	return [self initWithStyle:UITableViewStyleGrouped];
}
- (id)initWithStyle:(UITableViewStyle)style
{
	if (!(self = [super initWithStyle:style]))
		return nil;
	
	self.title = @"Smartling Demo";
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
	
	UILabel *statusLabel = [[UILabel alloc] init];
	statusLabel.opaque = NO;
	statusLabel.backgroundColor = [UIColor clearColor];
	statusLabel.textColor = [UIColor whiteColor];
	statusLabel.font = [UIFont boldSystemFontOfSize:14];
	statusLabel.shadowColor = [UIColor darkGrayColor];
	self.statusLabel = statusLabel;

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:statusLabel];
	
	self.model = @[
		@{@"title": @"Plurals", @"description": @"Localization of plural forms", @"controller": PluralsViewController.class},
	];
	
	return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
//	NSLocale *locale = [NSLocale currentLocale];
//	self.statusLabel.text = locale.localeIdentifier;
	self.statusLabel.text = [NSLocale preferredLanguages][0];
	[self.statusLabel sizeToFit];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.model.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellid = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
	}
	
	NSDictionary *m = self.model[indexPath.row];
	cell.textLabel.text = m[@"title"];
	cell.detailTextLabel.text = m[@"description"];
	
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *m = self.model[indexPath.row];
	Class cls = m[@"controller"];
	UIViewController *vc = [[cls alloc] init];
	vc.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
	[self.navigationController pushViewController:vc animated:YES];
}

@end
