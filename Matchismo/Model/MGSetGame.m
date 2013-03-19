//
//  MGSetGame.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/13/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGSetGame.h"
#import "MGGame_Protected.h"
#import "MGSetCard.h"

@implementation MGSetGame

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

-(UIView *)moveByFlippingSingleCard:(MGCard *)card {
	NSMutableAttributedString* pastMove = [[NSMutableAttributedString alloc] initWithString:@"Chose "];
	[pastMove appendAttributedString:[(MGSetCard*) card attributedString]];
	[pastMove appendAttributedString:[[NSAttributedString alloc] initWithString:@"."]];
	
	CGRect frame;
	frame.origin = CGPointMake(0, 0);
	frame.size = pastMove.size;
	
	UILabel* label = [[UILabel alloc] initWithFrame:frame];
	label.attributedText = pastMove;
	return label;
}

-(UIView *)moveWithCards:(NSArray *)cards matchedForScore:(NSInteger)score {
	//Start constructing the past-move string
	NSMutableAttributedString* pastMove = [[NSMutableAttributedString alloc] init];
	[pastMove appendAttributedString:[cards[0] attributedString]];
	[pastMove appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
	[pastMove appendAttributedString:[cards[1] attributedString]];
	[pastMove appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
	[pastMove appendAttributedString:[cards[2] attributedString]];
	
	if (score) {
		[pastMove appendAttributedString:
		 [[NSAttributedString alloc] initWithString:
			[NSString stringWithFormat:@" is a Set! %d points.",score*self.matchBonus]]];
	}
	else {
		[pastMove appendAttributedString:
		 [[NSAttributedString alloc] initWithString:
			[NSString stringWithFormat:@" is not a Set! %d point penalty.",self.mismatchPenalty]]];
	}
	
	CGRect frame;
	frame.origin = CGPointMake(0, 0);
	frame.size = pastMove.size;
	
	UILabel* label = [[UILabel alloc] initWithFrame:frame];
	label.attributedText = pastMove;
	return label;
}

@end
