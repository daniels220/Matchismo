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
@property (strong,nonatomic) MGDeck* deck;
-(NSArray*)faceDownCards;
-(NSArray*)playableFaceUpCards;
@property (nonatomic,readwrite) NSInteger score;
@property (nonatomic,readwrite) NSUInteger numFlips;
@property (strong,nonatomic,readwrite) MGGameResult* result;
@property (nonatomic,readwrite) GameState gameState;

@property (strong,nonatomic) NSMutableArray* pastMoves;

@end
