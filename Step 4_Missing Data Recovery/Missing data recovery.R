
#-----------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                   Random selection of missing cells & Imputation                           #
#-----------------------------------------------------------------------------------------------------------------------------------------------------------#

# Load necessary libraries
library(FHDI)

#----------------------
# Load the data (No Headers)
#----------------------
full_data <- read.csv("C:\Users\abuoliem\Desktop\Spring26\2. Research\2. Satellite_Imagery_paper\F.FHDI\10%\merged_x_prime_y_prime_with_features.csv", 
                      header=FALSE)

# Assign column names
colnames(full_data) <- c("x_prime", "y_prime", "y1", "y2", "y3", "y4", "y5", "y6", "y7")

# Define missing rate
missing_rate <- 0.1  # Define the missing rate (e.g., 10%, 20%, 30%, 40%)

# Run the experiment 5 times
for (trial in 1:5) {
  
  # Set a different seed for each trial
  set.seed(123 + trial) #Different missing values for each trial.Each trial has a unique seed (124, 125, 126, 127, 128).#
  
  # Copy dataset for modification
  daty_user <- full_data  
  total_rows <- nrow(daty_user)
  num_missing <- round(missing_rate * total_rows)  # Calculate the number of missing entries in y1
  
  # Randomly select rows to introduce missingness in y1
  missing_rows <- sample(1:total_rows, num_missing, replace = FALSE)
  
  # Create a missingness indicator matrix (All 1s initially, meaning all values are observed)
  datr_user <- data.frame(matrix(1, nrow = total_rows, ncol = ncol(daty_user)))  
  colnames(datr_user) <- colnames(daty_user)
  
  # Apply missingness in y1 (3rd column)
  datr_user[missing_rows, 3] <- 0  # Mark as missing in indicator matrix
  daty_user[missing_rows, 3] <- NA  # Set actual missing values
  
  # Identify missing indices in y1
  missing_indices <- which(is.na(daty_user$y1))

  #----------------------
  # Check Missingness Before Imputation
  #----------------------
  print(paste("Trial:", trial))
  print(paste("Total missing values in y1:", sum(is.na(daty_user$y1))))
  print(paste("Missing indicator for y1:", sum(datr_user$y1 == 0)))
  print(summary(daty_user$y1))
  
  # Function to Compute AME
  compute_AME <- function(imputed_y1, true_y1, missing_indices) {
    errors <- abs(imputed_y1[missing_indices] - true_y1[missing_indices])  # Calculate absolute error
    return(mean(errors, na.rm=TRUE))  # Compute mean absolute error
  }
  
  # Function to Compute Standard Error (SE)
  compute_SE <- function(imputed_y1, true_y1, missing_indices) {
    errors <- abs(imputed_y1[missing_indices] - true_y1[missing_indices])  # Compute absolute errors
    sd_errors <- sd(errors, na.rm=TRUE)  # Standard deviation of absolute errors
    n_missing <- length(missing_indices)  # Number of missing values
    return(sd_errors / sqrt(n_missing))  # Compute SE
  }
  
  #----------------------------------------------------------------------------------------------------------------------#
  #                           Impute Missing Data using FHDI & Compute AME                                              #
  #----------------------------------------------------------------------------------------------------------------------#
  start_time <- Sys.time()
  result_FHDI <- FHDI_Driver(daty=daty_user, datr=datr_user, s_op_imputation="FHDI", M=3, i_op_variance=1, k=3)
  end_time <- Sys.time()
  
  imputed_y1_FHDI <- as.vector(result_FHDI$simp.data[, 3])
  AME_FHDI <- compute_AME(imputed_y1_FHDI, full_data$y1, missing_indices)
  SE_FHDI <- compute_SE(imputed_y1_FHDI, full_data$y1, missing_indices)
  
  imputed_data_FHDI <- daty_user
  imputed_data_FHDI$y1[missing_indices] <- imputed_y1_FHDI[missing_indices]
  imputed_data_FHDI$AME <- NA  # Initialize with NA for all rows
  imputed_data_FHDI$AME[missing_indices] <- abs(imputed_y1_FHDI[missing_indices] - full_data$y1[missing_indices])
  
  # Compute mean, standard deviation, and standard error of the estimator (μ̂_FHDI)
  mu_hat_FHDI <- result_FHDI$imp.mean[1, 3]  # Correct mean
  se_hat_FHDI <- result_FHDI$imp.mean[2, 3]
  sd_hat_FHDI <- sd(imputed_data_FHDI$y1, na.rm=TRUE)
  
  print(paste("FHDI Imputation Time:", end_time - start_time))
  print(paste("Average AME for FHDI:", round(AME_FHDI, 4)))
  print(paste("Estimated Mean (μ̂_FHDI):", round(mu_hat_FHDI, 4)))
  print(paste("Standard Deviation of Imputed y1:", round(sd_hat_FHDI, 4)))
  print(paste("Standard Error of Mean (SE μ̂_FHDI):", format(se_hat_FHDI, scientific = TRUE, digits = 4)))
  
  #write.csv(imputed_data_FHDI, paste0("C:/Users/abuoliem/Box/2.Second year2024/2.Spring2025/1.Research/2.satellite image analysis of pre- and post-disaster images/F.FHDI/50%/FHDI_curing_50%_", trial, ".csv"), row.names=FALSE)
  
  #----------------------------------------------------------------------------------------------------------------------#
  #                           Impute Missing Data using FEFI & Compute AME                                              #
  #----------------------------------------------------------------------------------------------------------------------#
  start_time <- Sys.time()
  result_FEFI <- FHDI_Driver(daty=daty_user, datr=datr_user, s_op_imputation="FEFI", i_op_variance=1, k=3)
  end_time <- Sys.time()
  
  imputed_y1_FEFI <- as.vector(result_FEFI$simp.data[, 3])
  AME_FEFI <- compute_AME(imputed_y1_FEFI, full_data$y1, missing_indices)
  SE_FEFI <- compute_SE(imputed_y1_FEFI, full_data$y1, missing_indices)
  
  imputed_data_FEFI <- daty_user
  imputed_data_FEFI$y1[missing_indices] <- imputed_y1_FEFI[missing_indices]
  imputed_data_FEFI$AME <- NA  
  imputed_data_FEFI$AME[missing_indices] <- abs(imputed_y1_FEFI[missing_indices] - full_data$y1[missing_indices])
  
  mu_hat_FEFI <- result_FEFI$imp.mean[1, 3]  # Correct mean
  se_hat_FEFI <- result_FEFI$imp.mean[2, 3]
  sd_hat_FEFI <- sd(imputed_data_FEFI$y1, na.rm=TRUE)
  
  print(paste("FEFI Imputation Time:", end_time - start_time))
  print(paste("Average AME for FEFI:", round(AME_FEFI, 4)))
  print(paste("Estimated Mean (μ̂_FEFI):", round(mu_hat_FEFI, 4)))
  print(paste("Standard Deviation of Imputed y1 (FEFI):", round(sd_hat_FEFI, 4)))
  print(paste("Standard Error of Mean (SE μ̂_FEFI):", format(se_hat_FEFI, scientific = TRUE, digits = 4)))
  
  #write.csv(imputed_data_FEFI, paste0("C:/Users/abuoliem/Box/2.Second year2024/2.Spring2025/1.Research/2.satellite image analysis of pre- and post-disaster images/F.FHDI/50%/FEFI_curing_50%_", trial, ".csv"), row.names=FALSE)
  
  #----------------------------------------------------------------------------------------------------------------------#
  #                           Impute Missing Data using Average Naïve Method & Compute AME                              #
  #----------------------------------------------------------------------------------------------------------------------#
  start_time <- Sys.time()
  mean_y1 <- mean(daty_user$y1, na.rm=TRUE)
  imputed_y1_naive <- daty_user$y1
  imputed_y1_naive[missing_indices] <- mean_y1
  end_time <- Sys.time()
  
  AME_Naive <- compute_AME(imputed_y1_naive, full_data$y1, missing_indices)
  SE_Naive <- compute_SE(imputed_y1_naive, full_data$y1, missing_indices)
  
  imputed_data_Naive <- daty_user
  imputed_data_Naive$y1[missing_indices] <- imputed_y1_naive[missing_indices]
  imputed_data_Naive$AME <- NA  
  imputed_data_Naive$AME[missing_indices] <- abs(imputed_y1_naive[missing_indices] - full_data$y1[missing_indices])
  
  mu_hat_Naive <- mean(imputed_data_Naive$y1, na.rm=TRUE)
  sd_hat_Naive <- sd(imputed_data_Naive$y1, na.rm=TRUE)
  se_hat_Naive <- sd_hat_Naive / sqrt(nrow(imputed_data_Naive))
  
  print(paste("Imputation Time for Naïve Method:", end_time - start_time))
  print(paste("Average AME for Average Naïve Method:", round(AME_Naive, 4)))
  print(paste("Estimated Mean (μ̂_Naive):", round(mu_hat_Naive, 4)))
  print(paste("Standard Deviation of Imputed y1 (Naïve):", round(sd_hat_Naive, 4)))
  print(paste("Standard Error of Mean (SE μ̂_Naive):", round(se_hat_Naive, 4)))
  
  #write.csv(imputed_data_Naive, paste0("C:/Users/abuoliem/Box/2.Second year2024/2.Spring2025/1.Research/2.satellite image analysis of pre- and post-disaster images/F.FHDI/50%/Average_Naive_Imputation_50%_", trial, ".csv"), row.names=FALSE)
}
