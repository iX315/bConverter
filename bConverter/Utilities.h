//
//  Utilities.h
//  bConverter
//
//  Created by Jury Giannelli on 22/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface Utilities
-(NSString*)getExecutableFileMD5Signature;
-(NSString*)cHash:(NSString*)algo data:(NSData*)data;
@end

@interface NSData (NSDataStrings)
-(NSString*)stringWithHexBytes;
@end 