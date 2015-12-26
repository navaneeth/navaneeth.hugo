+++
categories = ["programming", "datastructures", "c"]
date = "2012-05-11T12:59:50+05:30"
description = ""
keywords = []
title = "Simple, generic and dynamically allocated array in C"
+++

C is a very good language. I have been using for quite some time for my opensource project. The flexibility C offers is really good. But sometimes, lack of simple datastructures like a dynamically growing array will slow down the programmer. There are tons of implementation available online, but most of them are overcomplicated, got lot of dependencies or tough to understand and incorporate with your application. In this post, I present a simple array which grows dynamically, reuses the memory, supports any pointer type and easy to copy to your code base.

Here is the code.

```c

typedef struct varray_t
{
   void **memory;
   size_t allocated;
   size_t used;
   int index;
} varray;

void
varray_init(varray **array)
{
   *array = (varray*) malloc (sizeof(varray));
   (*array)->memory = NULL;
   (*array)->allocated = 0;
   (*array)->used = 0;
   (*array)->index = -1;
}

void
varray_push(varray *array, void *data)
{
   size_t toallocate;
   size_t size = sizeof(void*);
   if ((array->allocated - array->used) < size) {
      toallocate = array->allocated == 0 ? size : (array->allocated * 2);
      array->memory = realloc(array->memory, toallocate);
      array->allocated = toallocate;
   }

   array->memory[++array->index] = data;
   array->used = array->used + size;
}

int
varray_length(varray *array)
{
   return array->index + 1;
}

void
varray_clear(varray *array)
{
   int i;
   for(i = 0; i < varray_length(array); i++)
   {
      array->memory[i] = NULL;
   }
   array->used = 0;
   array->index = -1;
}

void
varray_free(varray *array)
{
   free(array->memory);
   free(array);
}

void*
varray_get(varray *array, int index)
{
   if (index < 0 || index > array->index)
      return NULL;

   return array->memory[index];
}

void
varray_insert(varray *array, int index, void *data)
{
   if (index < 0 || index > array->index)
      return;

   array->memory[index] = data;
}
```

This array doesn’t take ownership of the data it contains. Ownership has to be managed separately. When adding a new item, array grows in constant propotion yielding inserts in amortized constant time. I have omitted error checking for malloc and realloc for simplicity.

Hope you enjoy the post.
