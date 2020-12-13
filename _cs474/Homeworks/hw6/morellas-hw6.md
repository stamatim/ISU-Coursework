## Stamati Morellas
## COM S 474 - Homework 6 Written Solutions
## 11/19/20

<br>

### Question 9: 

<br>

Given that $\mathbb{W}^{(l)}$ is the transfer matrix from layer $l$ to layer $l+1$, we must find the shapes in number of rows by columns for all $l\in[0..2]$. 

The shape of matrix $\mathbb{W}^{(0)}$ is $\mathbf{(3\times3)}$.

The shape of matrix $\mathbb{W}^{(1)}$ is $\mathbf{(4\times2)}$.

The shape of matrix $\mathbb{W}^{(2)}$ is $\mathbf{(3\times2)}$.

<br>

### Question 10: 

<br>

Given that all weights in $\mathbb{W}^{(0)} = 0.1$, all weights in $\mathbb{W}^{(1)} = 2$, and all weights in $\mathbb{W}^{(2)} = 1$, we must find the values of all activations $\mathbf{x}^{(l)}$ for all $l\in [1..3]$.

For $l = 0$:

$$
    \begin{pmatrix}
        \mathbb{W}^{(0)}
    \end{pmatrix}^T * \mathbf{x}^{(0)}  = 
        \frac{1}{10}
        \begin{pmatrix}
            1 & 1 & 1 \\
            1 & 1 & 1 \\
            1 & 1 & 1
        \end{pmatrix}
        \begin{pmatrix}
            1 \\
            1 \\
            1
        \end{pmatrix} =
            \frac{1}{10}
            \begin{pmatrix}
                3 \\
                3 \\
                3
            \end{pmatrix} =
                \frac{3}{10}
                \begin{pmatrix}
                    1 \\
                    1 \\
                    1
                \end{pmatrix}           
$$



$$
    \mathbf{x}^{(1)} = 
    \phi(
    \begin{pmatrix}
        \mathbb{W}^{(0)}
    \end{pmatrix}^T * \mathbf{x}^{(0)}) = 
    \sigma(\frac{3}{10}
    \begin{pmatrix}
        1 \\ 1 \\ 1
    \end{pmatrix}) =
        \begin{pmatrix}
            0.574 \\ 0.574 \\ 0.574
        \end{pmatrix} 
        \to
        \mathbf{x}^{(1)} = 
            \begin{pmatrix}
                1 \\ 0.574 \\ 0.574 \\ 0.574
            \end{pmatrix} 
$$

<br>

For $l = 1$:

$$
    \begin{pmatrix}
        \mathbb{W}^{(1)}
    \end{pmatrix} ^ T * \mathbf{x}^{(1)}  =
        2
        \begin{pmatrix}
            1 & 1 & 1 & 1 \\
            1 & 1 & 1 & 1
        \end{pmatrix}
        \begin{pmatrix}
                1 \\ 0.574 \\ 0.574 \\ 0.574
        \end{pmatrix}  = 
            \begin{pmatrix}
                5.44 \\ 
                5.44
            \end{pmatrix}
$$

$$
    \mathbf{x}^{(2)} = 
    \phi((\mathbb{W}^{(1)})^T * \mathbf{x}^{(1)}) = 
    \sigma
        \begin{pmatrix}
            5.44 \\ 5.44
        \end{pmatrix} =
        \begin{pmatrix}
            0.995 \\ 0.995
        \end{pmatrix}
        \to
        \mathbf{x}^{(2)} =
            \begin{pmatrix}
                1 \\ 0.995 \\ 0.995
            \end{pmatrix}
$$

<br>

### Question 11:

<br>

We want to find the values of $\delta^{(l)}$ for all $l\in{{2, 1}}$.

We start with $\delta^{(2)}$:

$$
    \delta^{(2)} = 
        \psi{(x^{(2)})} \circ {\mathbb{W}^{(2)} \delta^{(3)}} =
            x^{(2)} \circ (1 - x^{(2)}) \circ {\mathbb{W}^{(2)} \delta^{(3)}}
$$

We know that:

$$
    x^{(2)} = 
        \begin{pmatrix}
            1 \\ 0.995 \\ 0.995
        \end{pmatrix}
$$

$$
    1 - x^{(2)} = 
        \begin{pmatrix}
            0 \\ 0.005 \\ 0.005
        \end{pmatrix}
$$

$$
    \mathbb{W}^{(2)} \delta^{(3)} = 
        \begin{pmatrix}
            1 & 1 \\
            1 & 1 \\
            1 & 1
        \end{pmatrix}
        *
        \begin{pmatrix}
            1.99 \\ 2.99
        \end{pmatrix} = 
            \begin{pmatrix}
                4.98 \\ 4.98 \\ 4.98
            \end{pmatrix}
$$

Putting these all together, we get that:

$$
    \delta^{(2)} = 
        \begin{pmatrix}
            0 \\ 0.0247 \\ 0.0247
        \end{pmatrix}
$$

Next, we will find $\delta^{(1)}$:

$$
    \delta^{(1)} = 
        \psi{(x^{(1)})} \circ {\mathbb{W}^{(1)} \delta^{(2)}} =
            x^{(1)} \circ (1 - x^{(1)}) \circ {\mathbb{W}^{(1)} \delta^{(2)}}
$$

We know that:

$$
    x^{(1)} = 
        \begin{pmatrix}
            1 \\ 0.574 \\ 0.574 \\ 0.574
        \end{pmatrix}
$$

$$
    1 - x^{(1)} = 
        \begin{pmatrix}
            0 \\ 0.426 \\ 0.426 \\ 0.426
        \end{pmatrix}
$$

$$
    (\mathbb{W}^{(2)} \delta^{(3)}) = 
        \begin{pmatrix}
            1 & 1 \\
            1 & 1 \\
            1 & 1
        \end{pmatrix}
        *
        \begin{pmatrix}
            1.99 \\ 2.99
        \end{pmatrix} = 
            \begin{pmatrix}
                4.98 \\ 4.98 \\ 4.98
            \end{pmatrix}
$$

Putting these all together, we get that:

$$
    \delta^{(1)} = 
        \begin{pmatrix}
            0 \\ 0.0239 \\ 0.0239 \\ 0.0239
        \end{pmatrix}
$$

<br>

### Question 12:

<br>

In this problem, we must find $\nabla^{(l)}$.

Starting with $\nabla^{(2)}$:

$$
    \nabla^{(2)} = 
        \frac{\partial{E}}{\partial{\mathbb{W}^{(2)}}} = 
            x^{(2)}
            (\delta^{(3)})^T = 
            \begin{pmatrix}
                1 \\ 0.995 \\ 0.995
            \end{pmatrix}
            \begin{pmatrix}
                1.99 & 2.99
            \end{pmatrix} = 
                \begin{pmatrix}
                    1.99 & 2.99 \\
                    1.98 & 2.97 \\
                    1.98 & 2.97
                \end{pmatrix}
$$

Next, we will find $\nabla^{(1)}$:

$$
    \nabla^{(1)} = 
        \frac{\partial{E}}{\partial{\mathbb{W}^{(1)}}} = 
            x^{(1)}
            (\delta^{(2)})^T = 
            \begin{pmatrix}
                1 \\ 0.574 \\ 0.574 \\ 0.574
            \end{pmatrix}
            \begin{pmatrix}
                0.0247 & 0.0247
            \end{pmatrix} = 
                \begin{pmatrix}
                    0.0247 & 0.0247 \\
                    0.014 & 0.014 \\
                    0.014 & 0.014 \\
                    0.014 & 0.014
                \end{pmatrix}
$$

Finally, we will find $\nabla^{(0)}$:

$$
    \nabla^{(0)} = 
        \frac{\partial{E}}{\partial{\mathbb{W}^{(0)}}} = 
            x^{(0)}
            (\delta^{(1)})^T = 
            \begin{pmatrix}
                1 \\ 1 \\ 1
            \end{pmatrix}
            \begin{pmatrix}
                0.0239 & 0.0239 & 0.0239
            \end{pmatrix} = 
                \begin{pmatrix}
                    0.0239 & 0.0239 & 0.0239 \\
                    0.0239 & 0.0239 & 0.0239 \\
                    0.0239 & 0.0239 & 0.0239
                \end{pmatrix}
$$

<br>

### Question 13

<br>

Now, to update $\mathbb{W}^{(l)}$ based on $\nabla^{(l)}$ that we obtained previously, we perform the following adjustments:

$$
    \mathbb{W}^{(2)} \longleftarrow \mathbb{W}^{(2)} - p\nabla^{(2)} =
        \begin{pmatrix}
            1 & 1 \\
            1 & 1 \\
            1 & 1 
        \end{pmatrix} - 
        1 * 
        \begin{pmatrix} 
            1.99 & 2.99 \\
            1.98 & 2.97 \\
            1.98 & 2.97
        \end{pmatrix} = 
        \begin{pmatrix}
            -0.99 & -1.99 \\
            -0.98 & -1.97 \\
            -0.98 & -1.97
        \end{pmatrix}
$$ 

$$
    \mathbb{W}^{(1)} \longleftarrow \mathbb{W}^{(1)} - p\nabla^{(1)} =
        2 * 
        \begin{pmatrix}
            1 & 1 \\
            1 & 1 \\
            1 & 1 \\
            1 & 1
        \end{pmatrix} - 
        1 * 
        \begin{pmatrix} 
            0.0247 & 0.0247 \\
            0.014 & 0.014 \\
            0.014 & 0.014 \\
            0.014 & 0.014 
        \end{pmatrix} = 
        \begin{pmatrix}
            1.975 & 1.975 \\
            1.986 & 1.986 \\
            1.986 & 1.986 \\1
            1.986 & 1.986
        \end{pmatrix}
$$ 

$$
    \mathbb{W}^{(0)} \longleftarrow \mathbb{W}^{(0)} - p\nabla^{(0)} =
        2 * 
        \begin{pmatrix}
            0.1 & 0.1 & 0.1 \\
            0.1 & 0.1 & 0.1 \\
            0.1 & 0.1 & 0.1
        \end{pmatrix} - 
        1 * 
        \begin{pmatrix} 
            0.0239 & 0.0239 & 0.0239 \\
            0.0239 & 0.0239 & 0.0239 \\
            0.0239 & 0.0239 & 0.0239
        \end{pmatrix} = 
        \begin{pmatrix}
            0.0761 & 0.0761 & 0.0761 \\
            0.0761 & 0.0761 & 0.0761 \\
            0.0761 & 0.0761 & 0.0761
        \end{pmatrix}
$$ 

<br>

### Question 14

<br>

The output of neurons, after the activation function has been applied to the incoming signal, is indeed limited to values between [-1, 1]. The output layer in our case consists of a single neuron. This output neuron, receives a sum of the output of all neurons in the second to last layer weighted by the strength of their connection weights with the output neuron. This weighted sum is compared to the truth value during training. During back-propagation the values of all weights are calculated in order to correctly approximate the input/output function. The values of these weights may be any real number. As a result, the output of the single neuron in our case can take on values other than [-1, 1].