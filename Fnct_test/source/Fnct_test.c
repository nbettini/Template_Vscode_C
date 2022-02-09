#include <stdio.h>

#include "Fnct_test.h"

void red()
{
  printf("\033[1;31m");
}

void green()
{
  printf("\033[0;32m");
}

void reset()
{
  printf("\033[0m");
}