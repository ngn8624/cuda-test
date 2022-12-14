#pragma once

#include <cstdio>
#include <cmath>
#include <stdint.h>

#if defined(_MSC_VER)
    //  Microsoft 
    #define EXPORT __declspec(dllexport)
    #define IMPORT __declspec(dllimport)
#elif defined(__GNUC__)
    //  GCC
    #define EXPORT __attribute__((visibility("default")))
    #define IMPORT
#else
    //  do nothing and hope for the best?
    #define EXPORT
    #define IMPORT
    #pragma warning Unknown dynamic link import/export semantics.
#endif

#define _USE_MATH_DEFINES

using namespace std;

typedef unsigned long ULONG;
typedef unsigned int UINT;

#define UNIT_COUNT 200

const double HF_ST1 = 0.125;
const double HF_CF1 = 10;
const double HF_ST2 = 0.125;
const double HF_CF2 = 10;
const double IDT = HF_ST1, OMEGA_C_1 = 2 * M_PI * HF_CF1, OMEGA_C_2 = 2 * M_PI * HF_CF2;
const double AMPLFAC_1 = 1 / ((IDT * OMEGA_C_1 / 2) + 1), AMPLFAC_2 = 1 / ((IDT * OMEGA_C_2 / 2) + 1);
const double Y1C_1 = (IDT * OMEGA_C_1 / 2) - 1, Y1C_2 = (IDT * OMEGA_C_2 / 2) - 1, DT = IDT;

// EXPORT int cudaHighPassFilter(const uint8_t* src, const int cnt, uint8_t* dest, uint8_t* max);
EXPORT int cudaHighPassFilter(const uint8_t* src, const int cnt, uint8_t* dest_1, uint8_t* dest_2, uint8_t* filter_1, uint8_t* filter_2, float* max_1, float* max_2);