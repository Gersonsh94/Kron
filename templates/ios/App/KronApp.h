// What a Kron app built with std_app.kr gives its host (kronc app.kr
// --target=ios --lib): the program's main runs in a thread of its own and
// draws its pictures; the host shows them and hands it the touches and keys.
#include <stdint.h>

// the screen's size in pixels; starts the program's main, once
int32_t kron_app_start(int32_t width, int32_t height);
// the last picture, copied to dst if it holds bytes: its width | height << 32,
// 0 when there is none; 32 bits a pixel, blue first in memory (BGRX)
int64_t kron_app_frame(void *dst, int64_t bytes);
// 1 down, 2 move, 3 up; x and y in the picture's pixels
void kron_app_touch(int32_t phase, double x, double y);
// a key (8 backspace, 13 enter, 27 escape, the arrows 37-40) and/or the
// character typed; 0 for none
void kron_app_key(int32_t key, int32_t ch);
// 1 while a box to type in has the focus
int32_t kron_app_wants_keyboard(void);
// 0 once the program's main returned
int32_t kron_app_running(void);
// the system is ending the app
void kron_app_stop(void);
