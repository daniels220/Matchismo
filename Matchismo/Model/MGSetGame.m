//
//  MGSetGame.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/13/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGSetGame.h"
#import "MGGame_Protected.h"
#import "MGSetDeck.h"
#import "MGSetCard.h"

@implementation MGSetGame

-(MGDeck *)deck {
	if (!super.deck) super.deck = [MGSetDeck new];
	return super.deck;
}

-(NSUInteger)cardsToDeal {
	return 12;
}

-(NSString *)typeString {
	return @"Set";
}

-(NSUInteger)flipCost {
	return 0;
}

//The player can see all the cards, so they have no excuse for picking ones that don't match
-(NSUInteger)matchBonus {
	return 2;
}
-(NSUInteger)mismatchPenalty {
	return 4;
}
-(NSUInteger)winBonus {
	return 10;
}

-(NSUInteger)maxCardsUp {
	return 3;
}

@end
