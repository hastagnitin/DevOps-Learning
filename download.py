import kagglehub

print("Download shuru ho raha hai, dil thaam ke baithiye...")
path = kagglehub.dataset_download("karakaggle/kaggle-cat-vs-dog-dataset")
print("\nKaam ho gaya! Dataset yahan mila:", path)