#include <iostream>
using namespace std;

/* Abstract "expr" class */
class expr {
    public:
        expr(); // constructor
        ~expr(); // destructor
        virtual long compute() const = 0; // abstract method
};

/* Concrete class "literal", derived from "expr",
for storing an integer constant (as a long). */
class literal : public expr {
    private:
        long int_c; // integer constant
    public:
        literal(long c) : expr() {
            int_c = c;
        }
        ~literal() {
            cout << "Literal has been deleted." << endl;
        }
        /* Get the value of the integer constant stored */
        long compute() const {
            return int_c;
        }
};

/* Concrete class "variable", derived from "expr",
for storing a variable (as a reference to a long). */
class variable : public expr {
    private:
        long var; // variable
    public:
        variable() : expr() {
            var = 0;
        }
        ~variable() {
            cout << "Variable has been deleted." << endl;
        }
        void setVar(long newval) {
            var = newval;
        }
        /* Get the value of the variable stored */
        long compute() const {
            const long &r = var;
            return r;
        }
};

/* Implement a class binary_op, derived from expr,
for storing a binary operation of the form left op right,
where left and right are expressions (as pointers to an expr),
and op is one of +, -, *, /, %.
You may either make binary_op a concrete class,
or implement concrete classes plus_op, minus_op, etc. derived from binary_op.
*/
class binary_op : public expr {
    private:
        long left; long right; char op;
    public:
        binary_op(long l, long r, char o) : expr() {
            left = l;
            right = r;
            op = o;
        }
        ~binary_op() {
            cout << "Binary op has been deleted." << endl;
        }
        /* Get the result of the binary operation `left op right` */
        long compute() const {
            long value;
            if (op == '+') {
                value = left + right;
            } else if (op == '-') {
                value = left - right;
            } else if (op == '*') {
                value = left * right;
            } else if (op == '/') {
                value = left / right;
            } else if (op == '%') {
                value = left % right;
            } else {
                cout << "Error: the operator you entered is invalid" << endl;
            }
            return value;
        }
};

int main(int argc, char **argv) {
    cout << "\nRUNNING PROGRAM...\n";

    cout << "Creating a new object of type literal...";
    literal *lobj = new literal(1000000000000); // new literal object
    cout << "Success" << endl;

    cout << "Creating a new object of type variable...";
    variable *vobj = new variable(); // new variable object
    vobj->setVar(1000000000000);
    cout << "Success" << endl;

    expr *e1 = lobj;
    expr *e2 = vobj;
    e1->compute();
    e2->compute();
}