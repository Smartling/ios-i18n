// Copyright 2013 Smartling, Inc.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this work except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//
//  PluralsViewController.m
//  PluralsDemo
//
//  Created by Pavel Ivashkov on 2013-02-25.
//

#import "PluralsView.h"
#import "PluralsViewController.h"
#import <Smartling.i18n/SLLocalization.h>


@interface PluralsViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property(strong, nonatomic) NSArray *model;
@property(strong, nonatomic) NSArray *pickerModel;
@property(nonatomic, readonly) PluralsView *pluralsView;

- (NSArray *)modelWithNumber:(float)primitive;
- (void)updateModelFromPickerView:(UIPickerView *)pickerView;

@end


@implementation PluralsViewController


- (NSArray *)modelWithNumber:(float)primitive
{
	NSString *s0 = [NSString stringWithFormat:NSLocalizedString(@"%.1f apples",nil), primitive];

	NSString *s1 = [NSString stringWithFormat:SLPluralizedString(@"%.1f apples", primitive, nil), primitive];
	
	NSNumber *number = [NSNumber numberWithFloat:primitive];
	NSString *s2 = [NSString stringWithFormat:SLPluralizedString(@"%@ apples", number, nil), number];

	NSString *string = [NSString stringWithFormat:@"\uF8FF%@", number];
	NSString *s3 = [NSString stringWithFormat:SLPluralizedString(@"%@ apples", number, nil), string];

	NSString *s4 = [NSString stringWithFormat:SLPluralizedStringFromTable(@"%@ demo strings", @"Demo", number, nil), number];

	NSArray *list = @[
		@{ @"text":s0, @"detail":@"NSLocalizedString and stringWithFormat" },
		@{ @"text":s1, @"detail":@"SLPluralizedString with primitive type" },
		@{ @"text":s2, @"detail":@"SLPluralizedString with number object type" },
		@{ @"text":s3, @"detail":@"SLPluralizedString with custom formatted string" },
		@{ @"text":s4, @"detail":@"SLPluralizedStringFromTable \"Demo\"" },
	];
	return list;
}


- (id)init
{
	if (!(self = [super init]))
		return nil;
	
	self.title = @"Plurals";
	
	self.pickerModel = @[
		@[@(0), @(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8), @(9)],
		@[@(0), @(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8), @(9)],
		@[@(0), @(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8), @(9)],
		@[@(0), @(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8), @(9)],
	];
	
	return self;
}

- (PluralsView *)pluralsView
{
	return (PluralsView *)self.view;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self updateModelFromPickerView:self.pluralsView.pickerView];
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.pluralsView.tableView flashScrollIndicators];
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
	cell.textLabel.text = m[@"text"];
	cell.detailTextLabel.text = m[@"detail"];
	
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return self.pickerModel.count;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	NSArray *items = self.pickerModel[component];
	return items.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSArray *items = self.pickerModel[component];
	NSNumber *x = items[row];
	return [x stringValue];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	[self updateModelFromPickerView:pickerView];
}

#pragma mark - data model

- (void)updateModelFromPickerView:(UIPickerView *)pickerView
{
	int x = 0;
	for (int i = 0; i < pickerView.numberOfComponents; i++) {
		x *= 10;
		x += [pickerView selectedRowInComponent:i];
	}
	float num = x / 10.0;
	self.model = [self modelWithNumber:num];
	[self.pluralsView.tableView reloadData];
}

@end
