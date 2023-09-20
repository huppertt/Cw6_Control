
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <float.h>
#include <assert.h>

double ieee2float(unsigned char *v, int natural_order)
{



const unsigned char *data = v;
int s, e;
unsigned long src;
long f;
double value;

if (natural_order) {
src = ((unsigned long)data[0] << 24) |
((unsigned long)data[1] << 16) |
((unsigned long)data[2] << 8) |
((unsigned long)data[3]);
}
else {
src = ((unsigned long)data[3] << 24) |
((unsigned long)data[2] << 16) |
((unsigned long)data[1] << 8) |
((unsigned long)data[0]);
}

s = (src & 0x80000000UL) >> 31;
e = (src & 0x7F800000UL) >> 23;
f = (src & 0x007FFFFFUL);

if (e == 255 && f != 0) {
/* NaN (Not a Number) */
value = DBL_MAX;
}
else if (e == 255 && f == 0 && s == 1) {
/* Negative infinity */
value = -DBL_MAX;
}
else if (e == 255 && f == 0 && s == 0) {
/* Positive infinity */
value = DBL_MAX;
}
else if (e > 0 && e < 255) {
/* Normal number */
f += 0x00800000UL;
if (s) f = -f;
value = ldexp(f, e - 150);
}
else if (e == 0 && f != 0) {
/* Denormal number */
if (s) f = -f;
value = ldexp(f, -149);
}
else if (e == 0 && f == 0 && s == 1) {
/* Negative zero */
value = 0;
}
else if (e == 0 && f == 0 && s == 0) {
/* Positive zero */
value = 0;
}
else {
/* Never happens */
printf("s = %d, e = %d, f = %lu\n", s, e, f);
assert(!"Woops, unhandled case in decode_ieee_single()");
}

return value;
}
