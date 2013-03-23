//
//  MGMatchCollectionViewCell.m
//  Matchismo
//
//  Created by Daniel Slomovits on 3/22/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGMatchCollectionViewCell.h"

@implementation MGMatchCollectionViewCell
-(NSArray *)cardViews {
	return [self.twoCardViews arrayByAddingObject:self.thirdCardView];
}
@end
