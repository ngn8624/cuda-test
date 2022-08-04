CC=nvcc
TARGET=HighPassFilter
OBJS=$(TARGET).o

all:
	$(CC) -Xcompiler -fPIC -c $(TARGET).cu
	$(CC) -shared -o lib$(TARGET).so $(OBJS)
	rm *.o