/**
 * param.h
 * includes and utilities for parameters
*/

#ifdef _WIN32
#include <windows.h>
typedef HANDLE Mutex;
#define MutexAcquire(mutex) WaitForSingleObject(mutex, INFINITE)
#define MutexRelease(mutex) ReleaseMutex(mutex)
#define MutexInitialise(mutex) (mutex = CreateMutex(NULL, FALSE, NULL))
#define MutexDestroy(mutex) CloseHandle(mutex)
#else
#include <pthread.h>
typedef pthread_mutex_t Mutex;
#define MutexAcquire(mutex) pthread_mutex_lock(&(mutex))
#define MutexRelease(mutex) pthread_mutex_unlock(&(mutex))
#define MutexInitialise(mutex) pthread_mutex_init(&(mutex), NULL)
#define MutexDestroy(mutex) pthread_mutex_destroy(&(mutex))
#endif

static float FloatClamp01(float x)
{
    return x >= 1.0f ? 1.0f : x <= 0.f ? 0.f : x;
}

#define P_VOLUME (0)
#define P_COUNT (1)
