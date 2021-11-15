# SCCN Introduction to Modern Brain-Computer Interface Design

This respository shows the solutions for the exercises from the BCI course from SCCN. Please feel free to check out this very informative resource [here](https://sccn.ucsd.edu/wiki/Introduction_To_Modern_Brain-Computer_Interface_Design).

## Exercise 1

Implementation of an ERP-based BCI to detect error trials during a flanker task, where the subject is asked to press the left/right button based on the direction of the center arrow. The subject makes frequent errors (25%) becuase of the "flanker" arrows.

![flanker task](ex1/flanker.png)

A windowed approach is used to extract features as the weighted average across channels during the following time windows (seconds): [0.25 0.3; 0.3 0.35; 0.35 0.4; 0.4 0.45; 0.45 0.5; 0.5 0.6].

![ERP 1](ex1/ERP_1.png)
![ERP 2](ex1/ERP_2.png)

By applying a shrinkage LDA classifier with a lambda of 0.1, a mis-classification rate of 8.06% was achieved on the test set.


## Exercise 2

### Phase 1

BCILAB implementation of the shrinkage LDA based classifier for the flanker task in Exercise 1.

| Train Results | Test Results |
| ------------- | ------------ |
| ![train results](ex2/ex2_phase1_train_results.png) | ![test results](ex2/ex2_phase1_test_results.png) |


To understand the the model, the model weights can be visualized as spatial filters:

![model weights](ex2/ex2_phase1_model_weights.png)


While the previous analyses were performed offline, we can also adapt an online implementation to see how the model performs in real-time. The following plot shows the distribution of the probability for each class as the test data set is passed into the classifier in real-time. Class 1 corresponds to the non-error events, while class 2 corresponds to the error events. Here we can see that the classifier predicts a higher probability for the non-error events most of the time, and for the error events infrequently.

![online visualization](ex2_phase1_online.gif)


### Phase 2

Here, we create different variations of the basic BCI design by changing different parameters. Specifically, we tested different lambda values (0.1, 0.5, 1) for the shrinkage LDA classifier.

| Lambda Value | Train Results | Test Results |
| ------------ | ------------- | ------------ |
| 0.1          | ![slda01train](ex2/ex2_phase2_slda01_train_results.png) | ![slda01test](ex2/ex2_phase2_slda01_test_results.png) |
| 0.5          | ![slda05train](ex2/ex2_phase2_slda05_train_results.png) | ![slda05test](ex2/ex2_phase2_slda05_test_results.png) |
| 0.5          | ![slda1train](ex2/ex2_phase2_slda1_train_results.png)   | ![slda1test](ex2/ex2_phase2_slda1_test_results.png)   |


Based on the error rate of the testing set, we can see that a lambda value of 0.1 produced the best results among the different approaches.

