PYTHON ?= python3
VENV   ?= .venv
PIP    := $(VENV)/bin/pip
PY     := $(VENV)/bin/python

EPOCHS     ?= 10
BATCH_SIZE ?= 64
LR         ?= 1e-3

.PHONY: help setup install cnn vit train-cnn train-vit clean

help:
	@echo "Targets:"
	@echo "  setup       Create virtualenv at $(VENV)"
	@echo "  install     Install runtime dependencies"
	@echo "  cnn         Train SimpleCNN (EPOCHS=$(EPOCHS))"
	@echo "  vit         Train ViT (EPOCHS=$(EPOCHS))"
	@echo "  clean       Remove caches, lightning logs, and wandb artifacts"
	@echo ""
	@echo "Overrides: EPOCHS=20 BATCH_SIZE=128 LR=5e-4 make cnn"

setup:
	$(PYTHON) -m venv $(VENV)
	$(PIP) install --upgrade pip

install: setup
	$(PIP) install -r requirements.txt

cnn:
	$(PY) train.py --model cnn --epochs $(EPOCHS) --batch_size $(BATCH_SIZE) --lr $(LR)

vit:
	$(PY) train.py --model vit --epochs $(EPOCHS) --batch_size $(BATCH_SIZE) --lr $(LR)

# Backwards-compatible aliases
train-cnn: cnn
train-vit: vit

clean:
	rm -rf __pycache__ */__pycache__ */*/__pycache__
	rm -rf .pytest_cache .ruff_cache .mypy_cache
	rm -rf lightning_logs wandb outputs/models outputs/logs outputs/checkpoints
