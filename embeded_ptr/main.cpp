#include<iostream>
#include "Foo.hpp"
using namespace std;
int Foo::c = 1;
int main(){
Foo e;
e.a = 32;
e.b = 48;
Foo *f = &e;
cout<<e.my_allo.CHUNK;
my_allocator *g = &e.my_allo;
}