#ifndef ALLOCATOR_HPP
#define ALLOCATOR_HPP

#include <iostream>

class my_allocator{
private:
    struct obj
    {
        struct obj *next;
    };

public:
    void *allocate(size_t size);
    void deallocate(void *ptr);

public:
    const int CHUNK = 5;
    obj* freeobj = nullptr;

};

#endif
