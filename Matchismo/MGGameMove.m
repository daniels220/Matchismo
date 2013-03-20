//
//  MGMatchingGameMove.m
//  Matchismo
//
//  Created by Daniel Slomovits on 3/19/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGGameMove.h"

@implementation MGGameMove

-(id)initWithCards:(NSArray *)cards score:(NSUInteger)score {
	if (self = [super init]) {
		_cards = cards;
		_score = score;
	}
	return self;
}

@end
