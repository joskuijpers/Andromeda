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

#pragma mark Attribute definitions

#if __has_attribute(deprecated)
# define SPR_DEPRECATED(msg) __attribute__((deprecated((msg))))
#else
# define SPR_DEPRECATED(msg)
#endif

#if __has_attribute(unavailable)
# define SPR_UNAVAILABLE(msg) __attribute__((unavailable((msg))))
#else
# define SPR_UNAVAILABLE(msg)
#endif

#if __has_attribute(objc_designated_initializer)
# define SPR_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
#else
# define SPR_DESIGNATED_INITIALIZER
#endif

#if __has_attribute(objc_returns_inner_pointer)
# define SPR_RETURNS_INNER_POINTER __attribute__((objc_returns_inner_pointer))
#else
# define SPR_RETURNS_INNER_POINTER
#endif

#if __has_attribute(unused)
# define SPR_UNUSED __attribute__((unused))
#else
# define SPR_UNUSED
#endif

#if __has_attribute(warn_unused_result)
# define SPR_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SPR_WARN_UNUSED_RESULT
#endif

#if __has_attribute(objc_root_class)
# define SPR_ROOT_CLASS __attribute__((objc_root_class))
#else
# define SPR_ROOT_CLASS
#endif

#if __has_attribute(const)
# define SPR_CONST __attribute__((const))
#else
# define SPR_CONST
#endif

#if __has_builtin(__builtin_expect)
# define SPR_LIKELY(condition) (__builtin_expect(!!(condition), 1))
# define SPR_UNLIKELY(condition) (__builtin_expect(!!(condition), 0))
#else
# define SPR_LIKELY(condition)
# define SPR_UNLIKELY(condition)
#endif
