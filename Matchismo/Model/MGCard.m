//
//  MGCard.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/9/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGCard.h"

@implementation MGCard

-(NSUInteger)match:(NSArray *)otherCards {
	NSUInteger score = 0;
	
	for (MGCard* otherCard in otherCards) {
		if ([self.contents isEqualToString:otherCard.contents])
			score++;
	}
	
	return score;
}

-(NSString *)description {
	return self.contents;
}

@end
