# Load necessary libraries
library(class)
library(caret)

# Load the dataset
boston_data <- read.csv("C:\\Users\\test\\Desktop\\3MD\\BostonHousing.csv")

# Remove the CAT.MEDV column
boston_data <- boston_data[, -14]

# Function to normalize the data
normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}

# Normalize the entire dataset
boston_data_norm <- as.data.frame(lapply(boston_data, normalize))

# Split data into training (60%) and validation (40%) sets
set.seed(42)
train_index <- createDataPartition(boston_data_norm$MEDV, p = 0.6, list = FALSE)
train_data <- boston_data_norm[train_index, ]
val_data <- boston_data_norm[-train_index, ]

# Extract predictors and target variables
train_x <- train_data[, -13]  # First 12 columns as predictors
train_y <- train_data$MEDV    # Target variable MEDV
val_x <- val_data[, -13]
val_y <- val_data$MEDV

# Perform k-NN with k from 1 to 5 and calculate validation error
error_rates <- c()
for (k in 1:5) {
  predictions <- class::knn(train = train_x, test = val_x, cl = train_y, k = k)
  error <- mean((as.numeric(predictions) - val_y)^2)
  error_rates <- c(error_rates, error)
}

# Find the best k
best_k <- which.min(error_rates)
print(paste("Best k:", best_k))

# Normalize the new tract using the same min/max values as training data
new_tract <- data.frame(CRIM=0.2, ZN=0, INDUS=7, CHAS=0, NOX=0.538, RM=6, 
                        AGE=62, DIS=4.7, RAD=4, TAX=307, PTRATIO=21, LSTAT=10)

# Apply the same normalization used for the dataset
new_tract_norm <- as.data.frame(lapply(seq_along(new_tract), function(i) {
  (new_tract[[i]] - min(boston_data[[i]])) / (max(boston_data[[i]]) - min(boston_data[[i]]))
}))

# Ensure new_tract_norm has correct column names
colnames(new_tract_norm) <- colnames(train_x)

# Predict using the best k
predicted_value <- class::knn(train_x, new_tract_norm, cl = train_y, k = best_k)
print(paste("Predicted MEDV:", predicted_value))


# Calculate training set error using the best k
train_predictions <- class::knn(train_x, train_x, cl = train_y, k = best_k)
train_error <- mean((as.numeric(train_predictions) - train_y)^2)
print(paste("Training error:", train_error))

# Explanation of why validation error is optimistic
cat("Validation error can be overly optimistic because:\n")
cat("- The validation data comes from the same distribution as training data.\n")
cat("- Model overfitting to the validation set.\n")
cat("- Scaling inconsistencies when applying the model to new data.\n")
cat("- Validation data may not capture real-world data diversity.\n")

# Disadvantages of k-NN for large datasets
cat("Disadvantages of using k-NN for large datasets:\n")
cat("- Computational complexity: O(n) for each prediction.\n")
cat("- Memory usage: Entire training data must be stored.\n")
cat("- Scalability issues for large datasets.\n")
cat("- Lack of interpretability compared to parametric models.\n")

# Steps performed by k-NN algorithm to make predictions
cat("Steps in k-NN prediction:\n")
cat("1. Compute distance to all training points.\n")
cat("2. Identify k nearest neighbors.\n")
cat("3. Calculate the mean of nearest values.\n")
cat("4. Return the predicted value.\n")