#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Node Struct
typedef struct node {
    int val; // the node ID (value/variable)
    int visited; // if this node has been visited, set to 1
    struct node *linkNext; // link to next value
} node_t;

// Main Method
int main(int argc, char **argv) {
    printf("Made It To the Break");

    // Open input file
    FILE *inf = fopen(argv[1], "r"); // process cmd line args
    if (inf == NULL) {
        printf("Error opening file. Exiting...");
        exit(1);
    }

    int n; // first line of input file: the number of nodes N
    fscanf(inf, "%d", &n); // read
    if (n == NULL) {
        printf("Error, first line of input file must contain an int representing the number of nodes");
        exit(2);
    }

    // CONSTRUCT NODES
    int iVN; // index of VarNodes Array
    int iRN; // index of RegularNodes Array
    node_t arrVN[9]; // VarNodes Array; Program variables numbered 1 through 9
    node_t **arrRN = (node_t *)malloc(sizeof(node_t) * n); // RegularNodes Array; Nodes numbered 1 through N

    // Load VarNodes Array
    int vval = 1;
    for (iVN = 0; iVN < 9; iVN++){
        node_t vn;
        vn.val = vval;
        vn.visited = 0;
        vn.linkNext = NULL;
        arrVN[iVN] = vn; // Add the node to the array
        vval++;
    }

    // Load RegularNodes Array
    int rval = 1;
    for (iRN = 0; iRN < n; iRN++) {
        node_t *rn;
        rn->val = rval;
        rn->visited = 0;
        rn->linkNext = NULL;
        arrRN[iRN] = rn; //////////
        rval++;
    }

    // PROCESS THE REST OF THE FILE
    char *pl; // processed line variable
    char lvSwitch; // Switch for L and V; L->0, V->1
    int nodesrc; //////////
    int nodedest; //////////
    int varnum;
    while (!feof(inf)) { // process each of the lines
        // Scan for L or V
        fscanf(inf, "%c", pl);
        if (pl == 'L') {
            lvSwitch = 0;
        }
        else if (pl == 'V') {
            lvSwitch = 1;
        } else {
            printf("Error: Input formatting");
            exit(3);
        }

        // Scan for first number
        if (lvSwitch == 0) {
            fscanf(inf, "%d", &nodesrc); // L
        } else {
            fscanf(inf, "%d", &varnum); // V
        }

        // Scan for second number
        fscanf(inf, "%d", &nodedest);

        // Update the node values
        if (lvSwitch == 0) { // L
            arrRN[nodesrc - 1]->linkNext = arrRN[nodedest - 1];
        } else {
            arrVN[varnum - 1].linkNext = arrRN[nodedest - 1];
            arrVN[varnum - 1].visited = 1;
            arrRN[nodedest - 1]->visited = 1;
        }
    }

    // DETERMINE REACHABLITY
    int iaR = 0; // index for reachable array
    int iaU = 0; // index for unreachable array
    int *arrReachable = malloc(sizeof(int) * 2);
    int *arrUnreachable = malloc(sizeof(int) * 2);

    // Iterate over VarNodes Array
    for (int i = 0; i < 9; i++) {
        if (arrVN[i].linkNext != NULL && arrVN[i].visited == 1) { // if the node is reachable
            realloc(arrReachable, sizeof(int) + 1);
            arrReachable[iaR] = arrVN[i].val;
            iaR++;
        } else { // if the node is unreachable
            realloc(arrUnreachable, sizeof(int) + 1);
            arrUnreachable[iaU] = arrVN[i].val;
            iaU++;
        }
    }

    // Iterate over RegularNodes Array
    for (int i = 0; i < n; i++) {
        if (arrRN[i]->linkNext != NULL && arrRN[i]->visited == 1) { // if the node is reachable
            realloc(arrReachable, sizeof(int) + 1);
            arrReachable[iaR] = arrRN[i]->val;
            iaR++;
        } else { // if the node is unreachable
            realloc(arrUnreachable, sizeof(int) + 1);
            arrUnreachable[iaU] = arrRN[i]->val;
            iaU++;
        }
    }

    // PRINT INFO TO STDOUT
    printf("Reachable: ");
    for (int i = 0; i < iaR + 1; i++) { // Reachable Array
        printf(" %d ", arrReachable[i]);
    }
    printf("\n");
    printf("Unreachable: ");
    for (int i = 0; i < iaU + 1; i++) {
        printf(" %d ", arrUnreachable[i]);
    }

    // FREE MEMORY
    free(arrReachable);
    free(arrUnreachable);
    free(arrRN);
    fclose(inf);
    return 0;
}
