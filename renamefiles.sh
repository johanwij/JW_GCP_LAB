#!/bin/bash

# Check if task3.aaa exists
if [ -f "task3.aaa" ]; then
  # Copy task3.aaa to task3.tf
  cp "task3.aaa" "task3.tf"

  # Check if the copy was successful
  if [ $? -eq 0 ]; then
    echo "Successfully copied task3.aaa to task3.tf"
  else
    echo "Error: Failed to copy task3.aaa to task3.tf"
  fi
else
  echo "Error: task3.aaa does not exist."
fi

# Check if task4.aaa exists
if [ -f "task4.aaa" ]; then
  # Copy task4.aaa to task4.tf
  cp "task4.aaa" "task4.tf"

  # Check if the copy was successful
  if [ $? -eq 0 ]; then
    echo "Successfully copied task4.aaa to task4.tf"
  else
    echo "Error: Failed to copy task4.aaa to task4.tf"
  fi
else
  echo "Error: task4.aaa does not exist."
fi

# Check if task5.aaa exists
if [ -f "task5.aaa" ]; then
  # Copy task5.aaa to task5.tf
  cp "task5.aaa" "task5.tf"

  # Check if the copy was successful
  if [ $? -eq 0 ]; then
    echo "Successfully copied task5.aaa to task5.tf"
  else
    echo "Error: Failed to copy task5.aaa to task5.tf"
  fi
else
  echo "Error: task5.aaa does not exist."
fi
