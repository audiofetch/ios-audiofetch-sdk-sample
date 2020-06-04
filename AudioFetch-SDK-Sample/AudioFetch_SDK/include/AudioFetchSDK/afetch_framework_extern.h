//
//  afetch_framework_extern.h
//  audiofetch
//
//  Copyright © 2017 AudioFetch, Inc. All rights reserved.
//

#ifndef afetch_framework_extern_h
#define afetch_framework_extern_h

#ifdef __cplusplus
#define AFETCH_FRAMEWORK_EXTERN      extern "C" __attribute__((visibility ("default")))
#else
#define AFETCH_FRAMEWORK_EXTERN      extern __attribute__((visibility ("default")))
#endif

#endif /* afetch_framework_extern_h */
