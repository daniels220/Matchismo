//
//  MGGame_Protected.h
//  Matchismo
//
//  Created by Daniel Slomovits on 2/13/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGGame.h"

@interface MGGame ()

@property (strong,nonatomic) NSMutableArray* cards;
-(NSArray*)faceDownCards;
-(NSArray*)playableFaceUpCards;
@property (nonatomic,readwrite) NSInteger score;
@property (nonatomic,readwrite) NSUInteger numFlips;
@property (strong,nonatomic,readwrite) MGGameResult* result;
@property (nonatomic,readwrite) GameState gameState;

@property (strong,nonatomic) NSMutableArray* pastMoves;

_abstract @property (nonatomic,readonly) NSUInteger flipCost;
_abstract @property (nonatomic,readonly) NSUInteger matchBonus;
_abstract @property (nonatomic,readonly) NSUInteger mismatchPenalty;
_abstract @property (nonatomic,readonly) NSUInteger winBonus;
_abstract @property (nonatomic,readonly) NSUInteger maxCardsUp;
_abstract -(UIView*) moveByFlippingSingleCard:(MGCard*)card;
_abstract -(UIView*) moveWithCards:(NSArray*)cards matchedForScore:(NSInteger)score;


@end
