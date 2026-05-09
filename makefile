install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt

train:
	python train.py

eval:
	echo "## Model Metrics" > report.md
	cat ./Results/metrics.txt >> report.md
	echo "" >> report.md
	echo "## Confusion Matrix" >> report.md
	echo "![Confusion Matrix](./Results/model_results.png)" >> report.md
	cml comment create report.md

update-branch:
	git config --global user.name $(USER_NAME)
	git config --global user.email $(USER_EMAIL)
	git add Results/ farmer_optimized_xgb.json feature_names.pkl model.pkl
	git commit -m "Update model and results [skip ci]"
	git push --force origin HEAD:update

hf-login:
	git fetch origin update
	git checkout update
	pip install -U "huggingface_hub[cli]"
	huggingface-cli login --token $(HF) --add-to-git-credential

push-hub:
	huggingface-cli upload Ultra123-hub/farmer-credit-worthiness . \
		--repo-type=space \
		--commit-message="Sync latest model and app"

deploy: hf-login push-hub
