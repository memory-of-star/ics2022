#include <stdio.h>

#define print_bits(x)                                            \
  do {                                                           \
    unsigned long long a__ = (x);                                \
    size_t bits__ = sizeof(x) * 8;                               \
    while (bits__--) putchar(a__ &(1ULL << bits__) ? '1' : '0'); \
    putchar('\n');                                               \
  } while (0)

int main(){
    printf("%d %d\n", sizeof(0.1f), sizeof(0.1));
    float fa = 0.1f, fb = 0.2f, fc = 0.3f, fs;
    double da = 0.1, db = 0.2, dc = 0.3, ds;
    int *pfa = &fa, *pfb = &fb, *pfc = &fc, *pfs = &fs;
    long *pda = &da, *pdb = &db, *pdc = &dc, *pds = &ds;
    printf("%d %d %d %d\n", sizeof(*pfa), sizeof(*pda), sizeof(fa), sizeof(da));
    
    print_bits(*pfa);
    print_bits(*pfb);
    print_bits(*pfc);
    fs = fa + fb;
    print_bits(*pfs);

    print_bits(*pda);
    print_bits(*pdb);
    print_bits(*pdc);
    ds = da + db;
    print_bits(*pds);

    return 0;
}