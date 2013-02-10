//
//  MGPlayingCardDeck.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/9/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGPlayingCardDeck.h"
#import "MGPlayingCard.h"

@implementation MGPlayingCardDeck

-(id)init {
	if (self = [super init]) {
		for (NSString* suit in MGPlayingCard.validSuits)
			for (NSUInteger rank = 1; rank <= MGPlayingCard.maxRank; rank++)
				[self addCard:[[MGPlayingCard alloc] initWithSuit:suit rank:rank]];
	}
	return self;
}

@end
