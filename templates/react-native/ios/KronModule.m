// NativeModules.Kron in JavaScript, on iOS: each method calls the Kron
// framework (KronRN.framework, built from kron_rn.kr).
#import <React/RCTBridgeModule.h>
#include <stdint.h>

int32_t kron_add(int32_t a, int32_t b);
int64_t kron_fib(int32_t n);
int64_t kron_greet(const char *name, char *out, int64_t cap);

@interface KronModule : NSObject <RCTBridgeModule>
@end

@implementation KronModule

RCT_EXPORT_MODULE(Kron);

RCT_EXPORT_METHOD(add:(int)a b:(int)b
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    resolve(@(kron_add(a, b)));
}

RCT_EXPORT_METHOD(fib:(int)n
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    resolve(@((double)kron_fib(n)));
}

RCT_EXPORT_METHOD(greet:(NSString *)name
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    char out[256];
    kron_greet([name UTF8String], out, sizeof out);
    resolve([NSString stringWithUTF8String:out]);
}

@end
