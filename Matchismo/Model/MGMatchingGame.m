//
//  MGMatchingGame.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/9/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGMatchingGame.h"
#import "MGGame_Protected.h"
#import "MGCard.h"
#import "MGDeck.h"

@implementation MGMatchingGame

-(NSString *)typeString {
	return [NSString stringWithFormat:@"%d-Card Match",self.maxCardsUp];
}

-(NSUInteger)flipCost {
	return 1;
}

-(NSUInteger)matchBonus {
	return 4;
}
-(NSUInteger)mismatchPenalty {
	return 2;
}
-(NSUInteger)winBonus {
	return 10;
}
@synthesize maxCardsUp = _maxCardsUp;
-(NSUInteger)maxCardsUp {
	if (!_maxCardsUp) _maxCardsUp = 2;
	return _maxCardsUp;
}

@end
