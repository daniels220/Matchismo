//
//  MGPlayingCardView.m
//  Matchismo
//
//  Created by Daniel Slomovits on 3/17/13.
//  Copyright (c) 2013 Daniel Slomovits. All rights reserved.
//

#import "MGPlayingCardView.h"

@interface MGPlayingCardView ()

-(NSString*)rankAsString;

@end

@implementation MGPlayingCardView

#define FACE_CARD_MARGIN_FRACTION 0.1
- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	if (self.faceUp) {
	UIImage* faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.jpg",self.rankAsString,self.suit]];
	if (faceImage) {
		CGRect imageRect = CGRectInset(self.bounds, self.bounds.size.width*FACE_CARD_MARGIN_FRACTION, self.bounds.size.width*FACE_CARD_MARGIN_FRACTION);
		[faceImage drawInRect:imageRect];
	}  
	else
		[self drawPips];
	[self drawCorners];
	}
	else {
		[[UIImage imageNamed:@"cardback.png"] drawInRect:self.bounds];
	}
}

#define PIP_HOFFSET 0.165
#define PIP_VOFFSET1 0.090
#define PIP_VOFFSET2 0.175
#define PIP_VOFFSET3 0.270
#define PIP_FONT_FRACTION 0.15

-(void)drawPips {
	if ([@[@1,@3,@5,@7,@9] containsObject:@(self.rank)])
		[self drawPipsWithHorizontalOffset:0
												verticalOffset:0
										mirroredVertically:NO];
	if ([@[@6,@7,@8] containsObject:@(self.rank)])
		[self drawPipsWithHorizontalOffset:PIP_HOFFSET
												verticalOffset:0
										mirroredVertically:NO];
	if ([@[@2,@3,@7,@8,@10] containsObject:@(self.rank)])
		[self drawPipsWithHorizontalOffset:0
												verticalOffset:PIP_VOFFSET2
										mirroredVertically:self.rank != 7];
	if (self.rank >= 4 && self.rank <= 10)
		[self drawPipsWithHorizontalOffset:PIP_HOFFSET
												verticalOffset:PIP_VOFFSET3
										mirroredVertically:YES];
	if ([@[@9,@10] containsObject:@(self.rank)])
		[self drawPipsWithHorizontalOffset:PIP_HOFFSET
												verticalOffset:PIP_VOFFSET1
										mirroredVertically:YES];
}

-(void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
										 verticalOffset:(CGFloat)voffset
												 upsideDown:(BOOL)upsideDown {
	[self pushContext];
	if (upsideDown)
		[self rotateUpsideDown];
	
	CGPoint middle = CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2);
	UIFont* pipFont = [UIFont systemFontOfSize:self.bounds.size.width*PIP_FONT_FRACTION];
	NSAttributedString* suitString = [[NSAttributedString alloc] initWithString:self.suit attributes:@{NSFontAttributeName: pipFont}];
	CGSize pipSize = suitString.size;
	CGPoint pipOrigin = CGPointMake(
																	middle.x-pipSize.width/2.0-hoffset*self.bounds.size.width,
																	middle.y-pipSize.height/2.0-voffset*self.bounds.size.height
																	);
	[suitString drawAtPoint:pipOrigin];
	if (hoffset) {
		pipOrigin.x += hoffset*2*self.bounds.size.width;
		[suitString drawAtPoint:pipOrigin];
	}
	[self popContext];
}

-(void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
							 verticalOffset:(CGFloat)voffset
					 mirroredVertically:(BOOL)mirrored {
	[self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:NO];
	if (mirrored)
		[self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:YES];
}

#define CORNER_TEXT_FRACTION 0.1
#define CORNER_TEXT_INSET_FRACTION 0.05
-(void)drawCorners {
	NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
	style.alignment = NSTextAlignmentCenter;
	
	UIFont* font = [UIFont systemFontOfSize:self.bounds.size.width*CORNER_TEXT_FRACTION];
	
	NSAttributedString* cornerText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",self.rankAsString, self.suit] attributes:@{ NSParagraphStyleAttributeName: style, NSFontAttributeName: font}];
	
	CGRect cornerBounds;
	cornerBounds.size = cornerText.size;
	cornerBounds.origin = CGPointMake(self.bounds.size.width*CORNER_TEXT_INSET_FRACTION, self.bounds.size.height*CORNER_TEXT_INSET_FRACTION);
	[cornerText drawInRect:cornerBounds];
	
	//Save the context
	[self pushContext];
	//Move the context to the bottom-right corner and rotate upside down
	[self rotateUpsideDown];
	//Draw our text again
	[cornerText drawInRect:cornerBounds];
	//Restore the context
	[self popContext];
	
}

-(void)pushContext {
	CGContextSaveGState(UIGraphicsGetCurrentContext());
}

-(void)rotateUpsideDown {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
	CGContextRotateCTM(context, M_PI);
}

-(void)popContext {
	CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

-(NSString *)rankAsString {
	return @[@"",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"][self.rank];
}

-(void)setSuit:(NSString *)suit {
	_suit = suit;
	[self setNeedsDisplay];
}

-(void)setRank:(NSUInteger)rank {
	_rank = rank;
	[self setNeedsDisplay];
}

@end
