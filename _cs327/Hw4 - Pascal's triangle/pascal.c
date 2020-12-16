/*
 * Author: Stamatios Morellas
 *  Date Submitted: 10/4/19
 */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

/* PROTOTYPES */
unsigned long** build_Pascal(unsigned N);
void show_Pascal(unsigned long** P, unsigned N);
void destroy_Pascal(unsigned long** P, unsigned N);

/* FUNCTIONS */
/*
 * Build the first N rows of Pascal's triangle, where N is given as a parameter
 * 
 * This should allocate memory for an array of N pointers, and initialize pointer i to point to an array of i+1 unsigned longs 
 * (because row i of Pascal's triangle will contain exactly i+1 non-zero entries). 
 * 
 * Return a null pointer (and release any memory allocated) if any memory allocation request fails.
 */
unsigned long** build_Pascal(unsigned N) {
    printf("Error: line 30");
    unsigned num_columns = 1;
    unsigned A[N][num_columns]; // Declare a 2D array written assignment two until re-submission allows to submit? And if we submit assignments until it is not closed, we will not be penalized right?
    // printf("Error Here");
    unsigned long **P = (unsigned long **) malloc(N * N * sizeof(unsigned long*)); // Assign pointer to an array of length N of unsigned long POINTERS
                                                                                   // Access elements by using P[a][b]
    if (P == NULL) { // if memory allocation fails
        printf("Error: Memory allocation failed");
        unsigned long **np = P; // null pointer to be returned
        free(P); // free space allocated
        return np;
    }
    for (int i = 0; i < N; i++) { // Step through rows
        int j = 0;
        while (j < num_columns) { // Step through columns
            if (j == 0 || j == i) {
                P[i][j] = A[i][j] = 1;
            } else {
                P[i][j] = A[i][j] = A[i - 1][j - 1] + A[i - 1][j];
            }
            j++;
        }
        num_columns++;
        P = (unsigned long **) realloc(P, (N + num_columns) * sizeof(unsigned long));
    }
    return P;
    // Note: Could not figure out how to malloc :(
}

/*
 * Display the first N rows of Pascal's triangle, where N and the triangle are given as parameters
 * 
 * The output should be organized into columns, so that the width of each column is just wide enough 
 * to display the largest integer in that column. 
 */ 
void show_Pascal(unsigned long **P, unsigned N) {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < i + 1; j++) {
            printf("%ln", &P[i][j]);
        }
    }
}

/*
 * Destroy (free the allocated memory for) the first N rows of Pascal's triangle. 
 */ 
void destroy_Pascal(unsigned long **P, unsigned N) {
    free(P);
    P = NULL;
}

/* MAIN */
/*
 * 1. Prompt the user for N
 * 2. Build Pascal's Triangle
 * 3. Display Pascal's Triangle
 * 4. Destroy Pascal's Triangle
 */ 
int main(int argc, char* argv[]) {
    // 1
    unsigned n;
    unsigned long **p;
    printf("Please enter the number of layers for Pascal's Triangle (pick an integer): ");
    scanf("%u", &n);
    printf("Value Entered: %u\n\n", n);
    if(n < 0) {
        printf("Error: Please enter a valid integer");
        exit(-1);
    } else {
        // 2
        p = (unsigned long **) malloc(n * n * sizeof(unsigned long *));
        
        if (p == 0) { // check memory allocation
            fprintf(stderr, "Malloc fail\n");
            exit(1);
        }

        p = build_Pascal(n); // build the pascal triangle
        // 3
        printf("Pascal's triangle: \n\n");
        show_Pascal(p, n); // display the pascal triangle to standard output
        // 4
        destroy_Pascal(p, n); // destroy the pascal triangle
    }
    return 0;
}
