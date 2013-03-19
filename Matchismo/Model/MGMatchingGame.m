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

-(UIView *)moveByFlippingSingleCard:(MGCard *)card {
	return [NSString stringWithFormat:@"Flipped up %@",card.contents];
}

-(UIView *)moveWithCards:(NSArray *)cards matchedForScore:(NSInteger)score {
	if (self.maxCardsUp == 2) {
		if (score)
			return [NSString stringWithFormat:@"%@ matched %@ for %d points",cards[0],cards[1],score*self.matchBonus];
		else
			return [NSString stringWithFormat:@"%@ did not match %@, %d point penalty",cards[0],cards[1],self.mismatchPenalty];
	}
	//maxCardsUp must be 3--or anyway it always will be in this app
	else {
		if (score)
			return [NSString stringWithFormat:@"%@, %@, %@ matched for %d points",cards[0],cards[1],cards[2],score*self.matchBonus];
		else
			return [NSString stringWithFormat:@"%@, %@, %@ do not match, %d point penalty",cards[0],cards[1],cards[2],self.mismatchPenalty];
	}
}

@end
