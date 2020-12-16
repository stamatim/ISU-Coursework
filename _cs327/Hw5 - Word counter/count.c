#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <ctype.h>

// Define a struct for a linked list whose information includes a single string
// and an unsigned integer count.
struct node {
    char* word;
    unsigned count;
    struct node* next;
};

struct node* addToList(struct node* Listptr, char* word);

/* Main function
 *
 * 1. Reads from standard input
 * 2. Split the input stream into words
 * 3. Count the number of occurrences of each word
 */
int main(int argc, char** argv) {
    FILE* f;
    char* filename = "input.txt";
    f = fopen(filename, "r");
    struct node* head = NULL; // the head node
    head = (struct node*)malloc(sizeof(struct node*)); // allocate space

    // Check if file is empty
	if (f == NULL || !f) {
		fprintf(stderr, "Error: Could not open file %s. Please enter a valid file", filename);
		exit(1);
	}

    // While there are still more words
    while(!feof(f)) {
        int i = 0;
        char str[20]; // the word in the infile
        fscanf(f, "%s", str); // scan the word

        while(str[i]) { // make the word lowercase
            putchar(tolower(str[i]));
            i++;
        }

        char* word = str;
        struct node* current = addToList(head, word); // create node for the current word
        fprintf(stdout, "%d %s", current->count, current->word); // print the word to stdout
        fflush(stdout);
    }
    return 0;
}

/* Adds a word string to a list.
 *
 * On input, Listptr is a (possibly null) pointer to a linked list of words and their associated counts.
 *
 * If the word is already present in the list, then its count should be incremented; otherwise,
 * a new node should be added to the list for the new word and a count of 1.
 *
 * The function should return a pointer to the resulting list. You may order the list however
 * you like.
 */
struct node* addToList(struct node* Listptr, char* word) {
    struct node* new = malloc(sizeof(struct node) + strlen(word) + sizeof(char) + 1); // allocate space for the new node

    while (Listptr->next != NULL) { // while the next node is not null (last node)
        if (strcmp((Listptr->word), word) <= 0) { // if the word is present in the list
            Listptr->count++; // increment the count
            return Listptr;
        }
        Listptr = Listptr->next; // increment to the next node
    }
    strcpy(new->word, word); // copy the new word to the new node
    new->count = 1; // set the new count to 1
    new->next = NULL;

    return new;
}
