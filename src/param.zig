//! param.zig
//! some delclarations for handling parameters & changes

/// What a waste! Let's just use Zig's Mutex in the std for now

// if (std.Target.Os.Tag == .windows) {
//     const win = @cImport({@cInclude("windows.h");});
//     const HANDLE = win.Mutex;
//     fn MutexAcquire(mutex: anytype) void {
//         win.WaitForSingleObject(mutex, win.INFINITE);
//     }
//     #define MutexRelease(mutex) ReleaseMutex(mutex)
//     #define MutexInitialise(mutex) (mutex = CreateMutex(NULL, FALSE, NULL))
//     #define MutexDestroy(mutex) CloseHandle(mutex)
// }
// else
// #include <pthread.h>
// typedef pthread_mutex_t Mutex;
// #define MutexAcquire(mutex) pthread_mutex_lock(&(mutex))
// #define MutexRelease(mutex) pthread_mutex_unlock(&(mutex))
// #define MutexInitialise(mutex) pthread_mutex_init(&(mutex), NULL)
// #define MutexDestroy(mutex) pthread_mutex_destroy(&(mutex))
// #endif

pub fn FloatClamp01(x: f32) f32 {
    return if (x >= 1.0) 1.0 else if (x <= 0) 0 else x;
}

const P_VOLUME = 0;
const P_COUNT = 1;
