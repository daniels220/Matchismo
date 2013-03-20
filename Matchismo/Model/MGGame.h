//
//  MGGame.h
//  Matchismo
//
//  Created by Daniel Slomovits on 2/13/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGGameMove.h"
#import "MGGameResult.h"
#import "MGCard.h"
#import "MGDeck.h"

typedef enum {
	PLAYING_STATE,
	DONE_STATE,
	STUCK_STATE
} GameState;

@interface MGGame : NSObject

@property (nonatomic,readonly) NSInteger score;
@property (strong,nonatomic,readonly) MGGameResult* result;
@property (nonatomic,readonly) GameState gameState;

-(NSUInteger) numCards;
-(NSArray*) playableFaceUpCards;
-(void) flipCardAtIndex:(NSUInteger) index;
-(MGCard*) cardAtIndex:(NSUInteger) index;
-(void) removeCardAtIndex:(NSUInteger) index;
-(void) dealCard;

-(MGGameMove*) lastMove;
-(NSInteger) numMoves;
-(MGGameMove*) moveNumber:(NSInteger) moveNumber;

-(id) initWithCardCount:(NSUInteger)count usingDeck:(MGDeck*)deck;
-(NSString*) typeString;

_abstract @property (nonatomic,readonly) NSUInteger maxCardsUp;
_abstract @property (nonatomic,readonly) NSUInteger flipCost;
_abstract @property (nonatomic,readonly) NSUInteger matchBonus;
_abstract @property (nonatomic,readonly) NSUInteger mismatchPenalty;
_abstract @property (nonatomic,readonly) NSUInteger winBonus;

@end
