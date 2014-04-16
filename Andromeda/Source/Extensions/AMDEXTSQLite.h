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

#import "AMDJSClass.h"
#import "AMDSystemExtension.h"

@class AMDSQLiteTable;

/**
 * @brief SQLite database: JavaScript exports.
 */
@protocol AMDSQLiteDatabase <L8Export>

@property (readonly) NSDictionary *tables;

/**
 * Create or open a database
 *
 * @!param path Path to the database.
 * @return self.
 */
- (instancetype)init;

/**
 * Create a new query.
 *
 * @param sql Optional SQL query.
 * @return A Database.Query object if no SQL is supplied, a
 * result object otherwise.
 */
L8_EXPORT_AS(query,
- (NSObject *)queryWithSQL:(NSString *)sql
);

/**
 * Create a table.
 *
 * @param name Name of the table.
 * @param layout Layout of the table.
 * @return An instance of the table.
 */
L8_EXPORT_AS(createTable,
- (AMDSQLiteTable *)createTableWithName:(NSString *)name layout:(NSDictionary *)layout
);

/**
 * Perform an SQL query.
 *
 * @return Array of dictionaries as result, or null on failure.
 */
- (NSArray *)_performQuery:(NSString *)query;

/**
 * Get the insertion id of the last INSERT query.
 *
 * @return the id, or -1 if no insert query has been executed.
 */
- (NSNumber *)_insertId;

/**
 * Get the number of affected rows of the last UPDATE or DELETE query.
 *
 * @return the number, or -1 if no UPDATE or DELETE query has been executed.
 */
- (NSNumber *)_affectedRows;

/**
 * Get the last error.
 *
 * The error is cleared after this call. Call this method to 
 * see if any errors did occur (equal to null).
 *
 * @return The error string or null if no error.
 */
- (NSString *)_getError;

@end

/**
 * @brief SQLite table: JavaScript exports.
 */
@protocol AMDSQLiteTable <L8Export>

/**
 * Get the number of rows in the table.
 *
 * @return Number of rows or -1 on failure.
 */
- (NSNumber *)countAll;

/**
 * Truncates the table.
 *
 * @return Number of rows trashed or -1 on failure.
 */
- (NSNumber *)truncate;

/**
 * Drops the table.
 *
 * After this method, if the return value is YES,
 * this table object is invalid.
 *
 * @return YES on success, NO otherwise.
 */
- (BOOL)drop;

@end

/**
 * @brief SQLite database.
 */
@interface AMDSQLiteDatabase : NSObject <AMDSQLiteDatabase, AMDJSClass>

/**
 * Create or open a database
 *
 * @param path Path to the database.
 * @return self.
 */
- (instancetype)initWithPath:(NSString *)path;

@end

/**
 * @brief SQLite table.
 */
@interface AMDSQLiteTable : NSObject <AMDSQLiteTable, AMDJSClass>

- (instancetype)initWithName:(NSString *)name database:(AMDSQLiteDatabase *)database;

@end

/**
 * @brief SQLite extension info.
 */
@interface AMDEXTSQLite : AMDSystemExtension

@end
