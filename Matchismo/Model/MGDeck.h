//
//  MGDeck.h
//  Matchismo
//
//  Created by Daniel Slomovits on 2/9/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MGCard;

@interface MGDeck : NSObject

-(void) addCard:(MGCard*) card;

-(MGCard*) drawRandomCard;
-(NSUInteger) cardsRemaining;

@end
