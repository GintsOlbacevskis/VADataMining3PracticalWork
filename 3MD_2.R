# Load necessary libraries
library(tidyverse)  # For data manipulation and visualization
library(FNN)        # For k-NN algorithm

# Step 1: Read the dataset
data <- read.csv("C:\\Users\\test\\Desktop\\3MD\\Firewall_Rule_Classification.csv")

# Step 2: Data Preprocessing (3.2.1.1)
# Check for missing values
if (sum(is.na(data)) > 0) {
  print("Data contains missing values. Please handle them before proceeding.")
} else {
  print("No missing values detected.")
}

# Convert 'Class' to factor if not already
data$Class <- as.factor(data$Class)

# Count unique class values
class_counts <- table(data$Class)
print(class_counts)

# Number of unique classes
num_classes <- length(unique(data$Class))
print(paste("Number of unique classes:", num_classes))

# Extract one example from each class
unique_samples <- data %>% group_by(Class) %>% slice(1)
print(unique_samples)

# Remove extracted rows from main dataset
data_filtered <- anti_join(data, unique_samples, by=colnames(data))

# Save the unique samples for later use
write.csv(unique_samples, "C:\\Users\\test\\Desktop\\3MD\\unique_class_records.csv", row.names = FALSE)
write.csv(data_filtered, "C:\\Users\\test\\Desktop\\3MD\\filtered_data.csv", row.names = FALSE)

print("Data pre-processing complete.")

# Step 3: Perform k-NN prediction (3.2.1.2)
# Normalize the data (Min-Max Scaling)
normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}

# Apply normalization to all predictor columns (first 12)
normalized_data <- data_filtered
normalized_data[, 1:12] <- as.data.frame(lapply(data_filtered[, 1:12], normalize))

# Split data into training and validation sets (60/40 split)
set.seed(42)
train_indices <- sample(1:nrow(normalized_data), size = 0.6 * nrow(normalized_data))
train_data <- normalized_data[train_indices, ]
valid_data <- normalized_data[-train_indices, ]

# Ensure factor levels are consistent across train and validation data
train_y <- factor(train_y, levels = levels(data$Class))
valid_y <- factor(valid_y, levels = levels(data$Class))

# Perform k-NN with k from 1 to 15
k_values <- 1:15
accuracy_results <- c()

for (k in k_values) {
  knn_model <- knn(train = train_X, test = valid_X, cl = train_y, k = k)
  
  # Ensure factor levels in predictions are consistent with validation labels
  knn_model <- factor(knn_model, levels = levels(valid_y))
  
  # Calculate accuracy
  accuracy <- mean(knn_model == valid_y)
  accuracy_results <- c(accuracy_results, accuracy)
  print(paste("Accuracy for k =", k, ":", accuracy))
}

# Find the best k
best_k <- k_values[which.max(accuracy_results)]
print(paste("Best k value:", best_k))

# Visualize k vs accuracy
plot(k_values, accuracy_results, type = "b", col = "blue",
     xlab = "Number of Neighbors (k)", ylab = "Accuracy",
     main = "k-NN Accuracy for Different k Values")

# Step 4: Predict Class for extracted records (3.2.1.3)
# Load previously saved unique records
unique_samples <- read.csv("C:\\Users\\test\\Desktop\\3MD\\unique_class_records.csv")

# Normalize the unique records data
unique_samples[, 1:12] <- as.data.frame(lapply(unique_samples[, 1:12], normalize))

# Perform k-NN prediction using the best k found
predictions <- knn(train = train_X, test = unique_samples[, 1:12], cl = train_y, k = best_k)

# Add predictions to unique samples
unique_samples$Predicted_Class <- predictions

# Save the predictions
write.csv(unique_samples, "C:\\Users\\test\\Desktop\\3MD\\unique_class_predictions.csv", row.names = FALSE)

print("Prediction for unique records completed.")
