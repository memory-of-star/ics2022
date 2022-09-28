long f1(long a, long b) {
    return (++a > --b) ? a : b;
}

long f2(long *a, long *b) {
    return (*a > *b) ? --(*a) : (*b)--;
}

long f3(long *a, long *b) {
    return a ? *a : (b ? *b : 0);
}

long f4(long a, long b) {
    return (a > b) ? a : ++b;
}