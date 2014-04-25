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

#import <FMDB/FMDatabase.h>

@implementation AMDSQLiteDatabase {
	NSString *_path;
	NSMutableDictionary *_tables;
	FMDatabase *_database;
}

@synthesize tables=_tables;

+ (void)installIntoContext:(L8Context *)context
{
	context[@"Database"] = [AMDSQLiteDatabase class];
	context[@"Database"][@"Table"] = [AMDSQLiteTable class];
}

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
		FMResultSet *rs;

		_path = path;
		_tables = [NSMutableDictionary dictionary];

		_database = [[FMDatabase alloc] initWithPath:path];
		if(![_database open]) {
			_database = nil;
			return nil;
		}

		rs = [_database executeQuery:@"SELECT tbl_name FROM sqlite_master WHERE type='table'"];
		while([rs next]) {
			NSString *name;

			name = [rs stringForColumn:@"tbl_name"];
			_tables[name] = [[AMDSQLiteTable alloc] initWithName:name database:self];
		}
	}
	return self;
}

- (void)dealloc
{
	[_database close];
}

- (NSObject *)queryWithSQL:(NSString *)sql
{
	FMResultSet *resultSet;
	NSArray *data;

	if(!sql) {
		L8Value *queryClass, *query;

		queryClass = [L8Context currentContext][@"Database"][@"Query"];
		query = [queryClass constructWithArguments:@[[L8Context currentThis]]];

		return query;
	}

	resultSet = [_database executeQuery:sql];
	data = [self arrayFromResultSet:resultSet];
	[resultSet close];

	return data;
}

- (AMDSQLiteTable *)createTableWithName:(NSString *)name layout:(NSDictionary *)layout
{
	// Transform layout into SQL query
	return nil;
}

- (NSArray *)_performQuery:(NSString *)query withArguments:(NSArray *)arguments
{
	// if starts with SELECT
	if([query hasPrefix:@"SELECT"]) {
		FMResultSet *resultSet;
		NSArray *data;

		resultSet = [_database executeQuery:query withArgumentsInArray:arguments];
		data = [self arrayFromResultSet:resultSet];
		[resultSet close];

		return data;
	}

	if(![_database executeUpdate:query withArgumentsInArray:arguments])
		return nil;

	// TODO some other kind of Success display
	return (NSArray *)[NSNull null];
}

- (NSNumber *)_insertId
{
	return @([_database lastInsertRowId]);
}

- (NSNumber *)_affectedRows
{
	return @([_database changes]);
}

- (NSString *)_getLastError
{
	if(![_database hadError])
		return (NSString *)[NSNull null];
	return [_database lastErrorMessage];
}

- (NSArray *)arrayFromResultSet:(FMResultSet *)resultSet
{
	NSMutableArray *rows;

	if(resultSet == nil)
		return nil;

	rows = [NSMutableArray array];

	while([resultSet next]) {
		NSMutableDictionary *row;

		row = [NSMutableDictionary dictionaryWithCapacity:[resultSet columnCount]];

		for(int i = 0; i < [resultSet columnCount]; ++i)
			row[[resultSet columnNameForIndex:i]] = resultSet[i];

		[rows addObject:row];
	}

	return rows;
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
	NSArray *rs;

	rs = [_database _performQuery:[NSString stringWithFormat:@"SELECT COUNT(*) AS count FROM %@",_name]
					withArguments:nil];

	return rs[0][@"count"];
}

- (bool)truncate
{
	id rs;

	rs = [_database _performQuery:[NSString stringWithFormat:@"DELETE FROM %@",_name]
					withArguments:nil];

	return (rs != nil);
}

- (bool)drop
{
	id rs;

	rs = [_database _performQuery:[NSString stringWithFormat:@"DROP TABLE %@",_name]
					withArguments:nil];

	if(rs == nil)
		return NO;

	[((NSMutableDictionary *)_database.tables) removeObjectForKey:_name];

	return YES;
}

@end
