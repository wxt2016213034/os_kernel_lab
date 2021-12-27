#ifndef FOO_HPP
#define FOO_HPP

#include "allocator.hpp"
class Foo{
public:
    int a;
    int b;
    static my_allocator my_allo;
    static int c;

public:
    void *operator new(size_t size);
    void operator delete(void *);
};


#endif