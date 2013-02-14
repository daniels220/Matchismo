//
//  MGGame.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/13/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGGame_Protected.h"
#import "MGDeck.h"

@implementation MGGame

//INITIALIZERS

//Designated initializer
-(id)initWithCardCount:(NSUInteger)count usingDeck:(MGDeck *)deck {
	if (self = [super init]) {
		for (int i=0; i<count; i++)
			[self.cards addObject:[deck drawRandomCard]];
	}
	return self;
}

//GET/SET

-(NSMutableArray *)cards {
	if (!_cards) _cards = [NSMutableArray new];
	return _cards;
}

-(MGCard *)cardAtIndex:(NSUInteger)index {
	return self.cards[index];
}

@end
