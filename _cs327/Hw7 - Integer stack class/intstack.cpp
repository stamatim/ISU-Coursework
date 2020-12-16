#include <iostream>
using namespace std;

// The intstack class
class Intstack {
    private:
        // Hidden inner class for the linked list nodes
        struct node {
            int data; // The data that each node holds
            node* next; // Pointer to the next node in the linked list
        };
        node *head; // Variables for adding to the linked list
        // int size; // The size of this intstack
    public:
        // Constructor/Deconstructer
        Intstack(); // A constructor with no parameters to initialize an empty stack
        ~Intstack(); // A destructor to remove and recycle any remaining items off the stack

        // Assignment methods
        void push(int); // push an item onto the stack
        int pop(); // pop (and recycle) items off the stack
        // bool operator(int); // A type conversion operator for bool, which returns true if and only if the stack is not empty

        // Helper methods
        void display() {
            node* tmp = new node;
            if (head == NULL) {
              cout<<"Error: Cannot display(); Stack is empty.\n\n";
            } else {
              tmp = head;
              cout<<"Elements: ";
              while (tmp != NULL) {
                cout<< tmp->data <<" ";
                tmp = tmp->next;
              }
            }
        }
};

Intstack::Intstack() {
    head = NULL;
}

// Push a new node onto the stack with value n
void Intstack::push(int n) {
    // tmp->data = n;
    // tmp->next = NULL;
    // if (head == NULL) {
    //     this->head->data = tmp->data;
    //     this->head->next = NULL;
    //     this->tail->data = tmp->data;
    //     this->tail->next = NULL;
    //     this->size = 1;
    //     delete tmp;
    // }
    // else {
    //     tail->next->data = tmp->data;
    //     tail->data = tmp->data;
    //     this->size = 1;
    //     delete tmp;
    // }
    struct node* tmp = new struct node;
    tmp->data = n;
    tmp->next = head;
    head = tmp;
}

int Intstack::pop() {
    if (head == NULL) {
        cout<<"Error: Cannot pop(); Stack is already empty.\n\n";
        return 1;
    }
    else {
        cout<<"Popped node with value "<<head->data<<" \n";
        head = head->next;
        return 0;
    }
}

Intstack::~Intstack() {
  delete head;
}


int main() {
    Intstack stack;
    stack.push(1);
    stack.push(2);
    stack.push(3);
    stack.push(4);
    stack.push(5);
    stack.display();
    stack.pop();
    stack.pop();
    stack.pop();
    stack.display();
    stack.pop();
    stack.pop();
    return 0;
}
