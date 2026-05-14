import json
from collections import Counter

# Load dataset
def load_dataset(file_path):
    with open(file_path, 'r') as f:
        return json.load(f)

# Majority-class baseline
def majority_class_baseline(dataset):
    tactic_families = [entry['tactic_family'] for entry in dataset]
    most_common = Counter(tactic_families).most_common(1)[0][0]
    return most_common

# Keyword/heuristic baseline
def keyword_baseline(goal):
    keywords = {
        "contradiction": ["assume", "contradiction"],
        "arithmetic": ["sum", "product", "even", "odd"]
    }
    for tactic, words in keywords.items():
        if any(word in goal.lower() for word in words):
            return tactic
    return "unknown"

# Small text-based classifier (placeholder)
def text_classifier_baseline(goal):
    # Placeholder for a simple text-based classifier
    return "classifier_result"

if __name__ == "__main__":
    dataset = load_dataset("LeanResearch/dataset.json")

    # Majority-class baseline
    majority_class = majority_class_baseline(dataset)
    print(f"Majority-class baseline predicts: {majority_class}")

    # Keyword/heuristic baseline
    for entry in dataset:
        prediction = keyword_baseline(entry['goal'])
        print(f"Keyword baseline predicts for goal '{entry['goal']}': {prediction}")

    # Text-based classifier baseline
    for entry in dataset:
        prediction = text_classifier_baseline(entry['goal'])
        print(f"Text classifier baseline predicts for goal '{entry['goal']}': {prediction}")