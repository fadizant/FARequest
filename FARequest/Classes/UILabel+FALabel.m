//
//  UILabel+FALabel.m
//  Gloocall
//
//  Created by Fadi on 17/11/15.
//  Copyright © 2015 Apprikot. All rights reserved.
//

#import "UILabel+FALabel.h"

@implementation UILabel (FALabel)

-(void) setText:(NSString *)text
{
    self.attributedText = [[NSAttributedString alloc]initWithString:([text isEqual:[NSNull null]] || !text ) ? @"" : text];
}

@end
