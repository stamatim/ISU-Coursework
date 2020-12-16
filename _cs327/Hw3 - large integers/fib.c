// Name: Stamati Morellas
// Date Submitted: 9/19/19
// NetID: morellas@iastate.edu

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

/* PROTOTYPES */
void initialize(char digits[], unsigned numdigits, unsigned value);
int add(char result[], char num1[], char num2[], unsigned numdigits);
void print_int(char digits[], unsigned numdigits);

/* FUNCTIONS */
/*
* Initialize arbitrary-precision integer from unsigned integer
*/
void initialize(char digits[], unsigned numdigits, unsigned value) {
	// loop through and add each integer as a character to the array
	int i = numdigits - 1;
	while (i >= 0) { // while there are still digits to add
		if (value <= 0) {
			digits[i] = 0;
		}
		else {
			digits[i] = value % 10; // get the last integer
			value = value / 10; // move decimal left by one spot
		}
		i--; // decrement i
	}
}

/*
* Add 2 arbitrary-precision integers and store the sum into a third a-p integer
*/
int add(char result[], char num1[], char num2[], unsigned numdigits) {
	int i = numdigits - 1; // start at the last index
	while (i >= 0) {
		if (num1[i] + num2[i] >= 10) { // if the sum of the two numbers exceeds 10
			if (i - 1 < 0) { // handle overflow
				return 1;
			}
			else { // perform addition
				num1[i - 1] += 1;
				result[i] = num1[i] + num2[i] - 10;
			}
		}
		else { // add the two numbers and store them in the array
			result[i] = num1[i] + num2[i];
		}
		i--; // decrement i
	}
	return 0;
}

/*
* Write an arbitrary-precision integer to standard output, with commas as the thousands separator
*/
void print_int(char digits[], unsigned numdigits) {
	int i = 0;
	int c = 0; // comma separator
	while (digits[i] <= 0) { // ignore empty spaces
		i++;
		c++;
	}
	while (i < numdigits) { // print digits and commas
		printf("%d", digits[i]);
		if (i != 0 && (c % 3) == 0) {
			printf(",");
		}
		c++;
		i++; // increment i
	}
}

/* MAIN */

int main(int argc, char* argv[]) {

	unsigned numdigits; // The available size of the number arrays
	unsigned value1; // The numerical value of the first number
	unsigned value2; // The numerical value of the second number

	printf("Enter array size (numdigits): ");
	scanf("%d", &numdigits);

	printf("Enter first numerical value: ");
	scanf("%d", &value1);

	printf("Enter a second numerical value: ");
	scanf("%d", &value2);

	char num1[numdigits]; // The first number to add
	char num2[numdigits]; // The second number to add
	char sum[numdigits];  // The result of adding the 2 numbers

	// initialize the arrays
	initialize(num1, numdigits, value1);
	initialize(num2, numdigits, value2);
	initialize(sum, numdigits, 0);

	printf("Printing Fibonacci Sequence... \n\n");

	int i = 0; // for outer loop
	int j = 0; // for inner loop
	while (i < 500) {
		printf("F( %d): ", i);
		print_int(num1, numdigits); // print the first number
		printf("\n");
		if (add(sum, num1, num2, numdigits) == 1) { // handle error if applicable
			++i;
			printf("F( %d): ", i);
			print_int(sum, numdigits); // print the last number
			printf("\n\nDone: Overflow has occured.");
			return 0;
		}
		for (j = 0; j < numdigits; j++) {
			num1[j] = num2[j];
			num2[j] = sum[j];
		}
		i++;
	}
	return 1; // something else went wrong
}
