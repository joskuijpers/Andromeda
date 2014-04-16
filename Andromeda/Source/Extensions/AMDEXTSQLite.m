/*
 * Copyright (c) 2014 Jos Kuijpers. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "AMDEXTSQLite.h"

@implementation AMDEXTSQLite

- (id)init
{
	return [super initWithName:@"SQLite"
					   version:@(1)
				 versionString:@"0.0.1"
				   description:@{}];
}

@end

@implementation AMDSQLiteDatabase {
	NSString *_path;
	NSMutableDictionary *_tables;
}

@synthesize tables=_tables;

- (instancetype)init
{
	NSArray *arguments;

	arguments = [L8Context currentArguments];
	if(arguments.count < 1)
		return nil;

	return [self initWithPath:[arguments[0] toString]];
}

- (instancetype)initWithPath:(NSString *)path
{
	self = [super init];
	if(self) {
		_path = path;
		_tables = [NSMutableDictionary dictionary];
	}
	return self;
}

- (NSObject *)queryWithSQL:(NSString *)sql
{
	return nil;
}

- (AMDSQLiteTable *)createTableWithName:(NSString *)name layout:(NSDictionary *)layout
{
	return nil;
}

- (NSArray *)_performQuery:(NSString *)query
{
	return nil;
}

- (NSNumber *)_insertId
{
	return nil;
}

- (NSNumber *)_affectedRows
{
	return nil;
}

- (NSString *)_getError
{
	return nil;
}

@end

@implementation AMDSQLiteTable {
	NSString *_name;
	__weak AMDSQLiteDatabase *_database;
}

- (instancetype)initWithName:(NSString *)name database:(AMDSQLiteDatabase *)database
{
	self = [super init];
	if(self) {
		_name = name;
		_database = database;
	}
	return self;
}

- (NSNumber *)countAll
{
	return nil;
}

- (NSNumber *)truncate
{
	return nil;
}

- (BOOL)drop
{
	return NO;
}

@end
