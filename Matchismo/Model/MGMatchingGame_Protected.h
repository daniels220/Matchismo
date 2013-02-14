//
//  MGMatchingGame_Protected.h
//  Matchismo
//
//  Created by Daniel Slomovits on 2/10/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGMatchingGame.h"
#import "MGGame_Protected.h"

@interface MGMatchingGame ()

@property (nonatomic,readwrite) NSUInteger numFlips;
@property (strong,nonatomic) NSMutableArray* pastMoves;

@end
