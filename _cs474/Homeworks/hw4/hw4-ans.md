## Stamati Morellas
## COM S 474 - Homework 4 Written Solutions
## 10/13/20

<br>

### **Question 1**: 

To estimate the value of $\mathbf{w}$, we will use the formula $\mathbf{w} = \sum_{x_k \in N_s} \lambda_k  \mathbf{x_k}  y_k$. 

$\mathbf{w} =  \lambda_1  \mathbf{x_1}  y_1 +  \lambda_3  \mathbf{x_3}  y_3$ since $\lambda_2 = \lambda_4 = 0$.

Plugging in the respective values for all the parameters, we get that the $\mathbf{w} = $\mathbf{w} = \begin{pmatrix} 1.8 \\ 0 \\ 0.075 \end{pmatrix}$.

To classify the point $\begin{pmatrix} 1 \\ 1 \\ 0 \end{pmatrix}$, we use the formula $y = \mathbf{w^T} * \begin{pmatrix} 1 \\ 1 \\ 0 \end{pmatrix} + w_b$ which is equal to $2.8 > 0$. Therefore, the point belongs to the $\mathbf{+1}$ class.

<br>

### **Question 2**: 

Given the following formula for the two gutters: $\mathbf{w^T}x + w_b = \pm1$.

Therefore, the equations are: $\begin{pmatrix} 1.8 & 0 & 0.075 \end{pmatrix} * \begin{pmatrix} x_a \\ x_b \\ x_c \end{pmatrix} + 1 = \pm1$

or

$1.8x_a + 0.075x_c + 1 = +1$ and $1.8x_a + 0.075x_c + 1 = -1$.

Finally, the equations for the gutters are:

$1.8x_a + 0.075x_c = 0$ and $1.8x_a + 0.075x_c + 2 = 0$

<br>

### **Question 3**:

We are going to check which of the given samples fall into the margin by using the following equation: 

$$-1 < \mathbf{w}^T \mathbf{x} + w_b < 1$$

For sample 1: $x_1 = \begin{pmatrix} 0.5 \\ 0.25 \\ 0.125 \end{pmatrix}$

We evaluate $\mathbf{w}^T \mathbf{x_1} + w_b$ which is equal to $\begin{pmatrix} 1.8 & 0 & 0.075 \end{pmatrix} * \begin{pmatrix} 0.5 \\ 0.25 \\ 0.125 \end{pmatrix} + 1 = \mathbf{1.909}$. Since $-1 < \mathbf{0.909} < 1$, this falls outside of the gutter area. 

For sample 2: $x_2 = \begin{pmatrix} 0.4 \\ 0.15 \\ 0.225 \end{pmatrix}$

We evaluate $\mathbf{w}^T \mathbf{x_2} + w_b$ which is equal to $\begin{pmatrix} 1.8 & 0 & 0.075 \end{pmatrix} * \begin{pmatrix} 0.4 \\ 0.15 \\ 0.225 \end{pmatrix} + 1 = \mathbf{1.736}$. Since $-1 < \mathbf{0.736} < 1$, this falls outside of the gutter area. 

For sample 3, $x_3 = \begin{pmatrix} 0.3 \\ 0.75 \\ 0.325 \end{pmatrix}$

We evaluate $\mathbf{w}^T \mathbf{x_3} + w_b$ which is equal to $\begin{pmatrix} 1.8 & 0 & 0.075 \end{pmatrix} * \begin{pmatrix} 0.3 \\ 0.75 \\ 0.325 \end{pmatrix} + 1 = \mathbf{1.564}$. Since $-1 < \mathbf{0.564} < 1$, this falls outside of the gutter area. 

For sample 3: $x_4 = \begin{pmatrix} 0.2 \\ 0.65 \\ 0.425 \end{pmatrix}$

We evaluate $\mathbf{w}^T \mathbf{x_4} + w_b$ which is equal to $\begin{pmatrix} 1.8 & 0 & 0.075 \end{pmatrix} * \begin{pmatrix} 0.2 \\ 0.65 \\ 0.425 \end{pmatrix} + 1 = \mathbf{1.391}$. Since $-1 < \mathbf{0.391} < 1$, this falls outside of the gutter area. 

*All of the provided samples fall outside of the gutter margin.*

<br>

### **Question 4**:

1. The condition $y_i ({\mathbf{w}^T\mathbf{x}+w_b}) \ge -1$ represents **misclassified** samples falling in the gutter area.<br>

2. The condition $y_i (\mathbf{w}^T\mathbf{x}+w_b) \le -1$ represents **misclassified** samples falling on the outer sides of the gutter.<br>

3. The condition $y_i (\mathbf{w}^T\mathbf{x}+w_b) \ge 1$ represents **correctly** classified samples.<br>

4. The condition $y_i (\mathbf{w}^T\mathbf{x}+w_b) \le 1$ represents **correctly** classified samples falling in the gutter area.<br>

5. The condition $y_i (\mathbf{w}^T\mathbf{x}+w_b) \ge 0$ represents **correctly** classified samples falling in the gutter area.<br>

6. The condition $y_i (\mathbf{w}^T\mathbf{x}+w_b) \le 0$ represents **misclassified** samples falling in the gutter area.<br>

