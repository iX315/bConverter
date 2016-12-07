//
//  Utilities.m
//  bConverter
//
//  Created by Jury Giannelli on 22/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"
#include <CommonCrypto/CommonDigest.h>

@implementation Utilities

-(NSString*)getExecutableFileMD5Signature{
	NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
	NSString *execName = [info objectForKey:@"CFBundleExecutable"];
	
	NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.app/%@", NSHomeDirectory(), execName, execName]];
	
	return [self cHash:@"md5" data:data];
}

-(NSString*)cHash:(NSString*)algo data:(NSData*)data{
	NSData *rdata;
	if ([algo isEqualToString:@"sha1"]) {
		unsigned char hashBytes[CC_SHA1_DIGEST_LENGTH];
		CC_SHA1([data bytes], [data length], hashBytes);
		rdata = [NSData dataWithBytes:hashBytes length:CC_SHA1_DIGEST_LENGTH];
	}else if ([algo isEqualToString:@"md5" ]) {
		unsigned char hashBytes[CC_MD5_DIGEST_LENGTH];
		CC_MD5([data bytes], [data length], hashBytes);
		rdata = [NSData dataWithBytes:hashBytes length:CC_MD5_DIGEST_LENGTH];
	} else {
		return @"NULL";
	}
    
	return [rdata stringWithHexBytes];
}

@end


//add new method to NSData Class
//convert NSData to HEX NSString
@implementation NSData (NSDataStrings)

- (NSString*)stringWithHexBytes {
	static const char hexdigits[] = "0123456789abcdef";
	const size_t numBytes = [self length];	
	const unsigned char* bytes = [self bytes];
	char *strbuf = (char *)malloc(numBytes * 2 + 1);
	char *hex = strbuf;
	NSString *hexBytes = nil;
	
	for (int i = 0; i<numBytes; ++i){
		const unsigned char c = *bytes++;
		*hex++ = hexdigits[(c >> 4) & 0xF];
		*hex++ = hexdigits[(c ) & 0xF];
	}
	*hex = 0;
	hexBytes = [NSString stringWithUTF8String:strbuf];
	free(strbuf);
    
	return hexBytes;
}


@end