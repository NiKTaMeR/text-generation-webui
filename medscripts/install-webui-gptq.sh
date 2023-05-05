#!/bin/bash
set -e

# Create a Conda environment for textgen
conda create -y -n textgen python=3.10.9

# Activate the textgen Conda environment
conda activate textgen

# Install required packages for textgen
pip3 install torch torchvision torchaudio

# Clone the text-generation-webui Git repository
git clone https://github.com/oobabooga/text-generation-webui

# Navigate to the cloned text-generation-webui repository
cd ~/text-generation-webui

# List available branches for text-generation-webui
textgen_branches=($(git branch -a --list))

# Prompt for branch selection for text-generation-webui
PS3="Enter the number of the branch you want to clone for text-generation-webui: "
select textgen_branch in "${textgen_branches[@]}"; do
    if [[ -n $textgen_branch ]]; then
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

# Remove the '*' character from the selected branch for text-generation-webui
textgen_branch=${textgen_branch#"* "}

# Checkout the selected branch for text-generation-webui
git checkout "$textgen_branch"

# Install dependencies for text-generation-webui
pip install -r requirements.txt

# Create the 'repositories' directory if it doesn't exist
mkdir -p repositories
cd repositories

# Create a Conda environment for GPTQ
conda create -y -n gptq python=3.9

# Activate the new gptq Conda environment
conda activate gptq

# Prompt for repository selection for GPTQ
PS3="Enter the number corresponding to the repository you want to clone for GPTQ: "
options=("https://github.com/oobabooga/GPTQ-for-LLaMa.git" "https://github.com/qwopqwop200/GPTQ-for-LLaMa.git")
select gptq_repository_url in "${options[@]}"; do
    if [[ -n $gptq_repository_url ]]; then
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

# Clone the selected repository for GPTQ
git clone "$gptq_repository_url"

# Navigate to the cloned repository for GPTQ
gptq_repository_name=$(basename "$gptq_repository_url" .git)
cd "$gptq_repository_name"

# List available branches for GPTQ
gptq_branches=($(git branch -a --list))

# Prompt for branch selection for GPTQ
PS3="Enter the number of the branch you want to checkout for GPTQ: "
select gptq_branch in "${gptq_branches[@]}"; do
    if [[ -n $gptq_branch ]]; then
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

# Remove the '*' character from the selected branch for GPTQ
gptq_branch=${gptq_branch#"* "}

# Checkout the selected branch for GPTQ
git checkout "$gptq_branch"

# Navigate to the GPTQ-for-LLaMa directory
cd GPTQ-for-LLaMa

# Install CUDA requirements (if error, install requirements.txt)
python setup_cuda.py install || pip install -r requirements.txt

# Activate the textgen Conda environment again
source "$(dirname $(which conda))/../etc/profile.d/conda.sh"
source conda activate textgen

# Navigate back to the cloned text-generation-webui repository
cd ~/text-generation-webui

# Remove the existing 'models' directory
rm -R models

# Create a symlink to the desired location for models
ln -s "/mnt/c/Users/mehdi/OneDrive/Desktop/ml_projects/models" "$HOME/text-generation-webui/models"

# Install additional dependencies for text-generation-webui
pip install -r requirements.txt
