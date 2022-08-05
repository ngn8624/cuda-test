CC=g++
TARGET=main
LIB=HighPassFilter
OBJS=$(TARGET).o

all:
	$(CC) $(TARGET).cpp -o $(TARGET) -I. -L. -l$(LIB)

debug:
	$(CC) $(TARGET).cpp -g -O0 -DDEBUG -o $(TARGET) -I. -L. -l$(LIB)

release:
	$(CC) $(TARGET).cpp -O3 -DNDEBUG -o $(TARGET) -I. -L. -l$(LIB)