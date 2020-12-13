## Stamati Morellas
## COM S 474 - Homework 5 Written Solutions
## 11/11/20

<br>

### Question 1: 

<br>

The result of the Hadamard product $A \circ B$ is shown below:
$$
    A \circ B = \begin{pmatrix}
        1 & 2 & 3 \\
        3 & 2 & 1
    \end{pmatrix} \circ 
    \begin{pmatrix}
        0.5 & 0.1 & 0.3 \\
        -1 & -20 & 1.5
    \end{pmatrix} = 
    \begin{pmatrix}
        0.5 & 0.2 & 0.9 \\
        -3 & -40 & 1.5
    \end{pmatrix}
$$

<br>

### Question 2:

<br>

The result of $AB^T$:

$$
    AB^T = \begin{pmatrix}
        1 & 2 & 3 \\
        3 & 2 & 1
    \end{pmatrix}
    \begin{pmatrix}
        0.5 & -1 \\
        0.1 & -20 \\
        0.3 & 1.5
    \end{pmatrix} = 
    \begin{pmatrix}
        1.6 & -36.5 \\
        2 & -41.5
    \end{pmatrix}
$$

The result of $BA^T$:

$$
    BA^T = \begin{pmatrix}
        1 & 2 & 3 \\
        3 & 2 & 1
    \end{pmatrix}
    \begin{pmatrix}
        0.5 & -1 \\
        0.1 & -20 \\
        0.3 & 1.5
    \end{pmatrix} = 
    \begin{pmatrix}
        1.6 & 2 \\
        -36.5 & -41.5
    \end{pmatrix}
$$

<br>

### Question 3:

<br>

There is __not__ a product $AB$ because the dimensions of the two matrices are different. Matrix $A$ has dimensions (2 x 3) and matrix $B$ also has dimensions (2 x 3), so they __cannot__ be multiplied. To multiply matrices $A$ and $B$, they need to have dimensions such that $A$ has $m$ rows and $n$ columns, while matrix $B$ has $n$ rows and $l$ columns in order to produce a matrix with $m$ rows and $l$ columns.

<br>

### Question 4:

<br> 

Given $f(x) = x + 1$, the value of $f(AB^T) = \mathbf{AB^T + 1}$.

<br>

### Question 6

<br>

Given that $d = 3$, $\mathbf{x} = [x_0, x_1, x_2, x_3] = [1, 0, 1, 0]^T$, and $\mathbf{w} = [w_0, w_1, w_2, w_3] = [5, 4, 6, 1]$, and $\phi(x) = x^2$, we can find $\hat{y}$ by following the steps below.

First, we must find $w^Tx$:

$$
    w^Tx = \begin{pmatrix}
        5 & 4 & 6 & 1
    \end{pmatrix} * 
    \begin{pmatrix}
        1 \\ 0 \\ 1 \\ 0
    \end{pmatrix} = 11
$$

<br>

Then, we use $\phi(x) = x^2$ to find $\phi(w^Tx)$:

$$\phi(w^Tx) = \phi(11) = 11^2 = 121$$

<br>

So from this, we get:

$$\hat{y} = \phi(w^Tx) = (w^Tx)^2 = 121$$

<br>

### Question 7:

<br>

Given the value of the loss function $E = \hat{y} - y$, we can find the respective values of $\partial{E}/\partial{x_1}$ and $\partial{E}/\partial{w_1}$ by following the process below:

First, we will find the value of $\partial{E}/\partial{w_1}$:

$$
    \frac{\partial{E}}{\partial{w_1}} = 
        (\frac{\partial{E}}{\partial{\hat{y}}} * 
        \frac{\partial{\hat{y}}}{\partial{w_1}}) = 
            (\frac{\partial{E}}{\partial{\hat{y}}} * 
            \frac{\partial{\hat{y}}}{\partial{(w^Tx)}} * 
            \frac{\partial{(w^Tx)}}{\partial{w_1}}) = 
            1 * 22 * 0 = \mathbf{0}
$$

<br>

Next, we will find the value of $\partial{E}/\partial{x_1}$:

$$
    \frac{\partial{E}}{\partial{x_1}} = 
        (\frac{\partial{E}}{\partial{\hat{y}}} *
        \frac{\partial{\hat{y}}}{\partial{(w^Tx)}} *
        \frac{\partial{(w^Tx)}}{x_1}) =
        1 * 22 * 4 = \mathbf{88}
$$

<br>

### Question 8 (Bonus):

<br>

We saw from question 7 that $\frac{\partial{E}}{\partial{x_1}} = 1 * 22 * x_1 = \mathbf{22x_1}$ and $\frac{\partial{E}}{\partial{w_1}} = 1 * 22 * w_1 = \mathbf{22w_1}$.

Now, to find the values of $\frac{\partial{E}}{\partial{\mathbf{x}}}$ and $\frac{\partial{E}}{\partial{\mathbf{w}}}$, we will use the following equations to find the results:

<br>

For $\frac{\partial{E}}{\partial{\mathbf{x}}}$:

$$
    \frac{\partial{E}}{\partial{\mathbf{x}}} =
        22 *
        \begin{pmatrix}
            x_0 \\
            x_1 \\
            x_2 \\
            x_3
        \end{pmatrix} =
            \begin{pmatrix}
                1 \\
                0 \\
                1 \\
                0
            \end{pmatrix} =
            \mathbf{
                \begin{pmatrix}
                    22 \\
                    0 \\
                    22 \\
                    0
                \end{pmatrix}
            }
$$

<br>

For $\frac{\partial{E}}{\partial{\mathbf{w}}}$:

$$
    \frac{\partial{E}}{\partial{\mathbf{w}}} =
        22 * 
        \begin{pmatrix}
            w_0 \\
            w_1 \\
            w_2 \\
            w_3
        \end{pmatrix} =
            \begin{pmatrix}
                5 \\
                4 \\
                6 \\
                1
            \end{pmatrix} =
            \mathbf{
                \begin{pmatrix}
                    110 \\
                    88 \\
                    132 \\
                    22
                \end{pmatrix}
            }
$$




