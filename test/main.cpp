#include "HighPassFilter.h"
#include "Timer.h"
#include "stdio.h"
// #include <iostream>
#include <fstream>

using namespace std;

#define TEST_FILE_NAME_1 "data0000000049_144919_872_0.bin"
#define TEST_FILE_NAME_2 "data0000000049_144919_872_1.bin"
#define HEADER_SIZE 16
#define DATA_SIZE 25011200

int main(int argc, char* argv[])
{
    WGSTest::Timer timer;

    uint8_t* src = new uint8_t[DATA_SIZE * 2];
    uint8_t* dest_1 = new uint8_t[DATA_SIZE];
    uint8_t* dest_2 = new uint8_t[DATA_SIZE];
    uint8_t* filter_1 = new uint8_t[DATA_SIZE];
    uint8_t* filter_2 = new uint8_t[DATA_SIZE];
    float* max_1 = new float[200];
    float* max_2 = new float[200];

	ifstream in1, in2;
	in1.open(TEST_FILE_NAME_1, ios::binary);
    in2.open(TEST_FILE_NAME_2, ios::binary);
    for (size_t i = 0; i < DATA_SIZE + HEADER_SIZE; i++)
    {
        uint8_t tmp1, tmp2;
        in1 >> tmp1;
        in2 >> tmp2;

        if(i < HEADER_SIZE) continue;

        src[i - HEADER_SIZE] = tmp1;
        src[DATA_SIZE + i - HEADER_SIZE] = tmp2;
    }
    
    in1.close();
    in2.close();

    printf("[%d, %d], [%d, %d]\n", src[0], src[DATA_SIZE - 1], src[DATA_SIZE], src[DATA_SIZE * 2 - 1]);
    
    timer.Reset();
    timer.Start();
    int ret = cudaHighPassFilter(src, DATA_SIZE, dest_1, dest_2, filter_1, filter_2, max_1, max_2);
    timer.End();
    printf("%d\n", ret);
    timer.Print();

	// ofstream out("result_0.bin", ios::out);
	// out.write(reinterpret_cast<char *>(&dest[0]), DATA_SIZE);
	// out.close();

	delete[] src;
    delete[] dest_1;
    delete[] dest_2;
    delete[] filter_1;
    delete[] filter_2;
    delete[] max_1;
    delete[] max_2;

	return 0;
}