//
//  MGSetDeck.m
//  Matchismo
//
//  Created by Daniel Slomovits on 2/13/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGSetDeck.h"
#import "MGSetCard.h"

@implementation MGSetDeck

-(id)init {
	if (self = [super init]) {
		for (NSString* symbol in MGSetCard.validSymbols)
			for (int number = SetMinNumber; number <= SetMaxNumber; number++)
				for (UIColor* color in MGSetCard.validColors) {
					[self addCard:
					 [[MGSetCard alloc] initWithSymbol:symbol number:number
																			 color:color shading:SetShadingEmpty]];
					[self addCard:
					 [[MGSetCard alloc] initWithSymbol:symbol number:number
																			 color:color shading:SetShadingShaded]];
					[self addCard:
					 [[MGSetCard alloc] initWithSymbol:symbol number:number
																			 color:color shading:SetShadingFilled]];
			}
				
	}
	return self;
}

@end
