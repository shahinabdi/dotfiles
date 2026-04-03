#!/usr/bin/env bash

SESSION="$1"          # ex: dev
PROJECT_DIR="$2"      # ex: ~/projects/backend

ENV_TYPE="$3"         # "env" or "conda" or "none"
ENV_VALUE="$4"        # ".env" or "myenv" or ""

API_CMD="$5"          # ex: uvicorn app:app --reload
CELERY_CMD="$6"       # ex: celery -A app worker -l info

# Helper: apply environment setup
apply_env() {
    local TARGET="$1"

    tmux send-keys -t "$TARGET" "cd $PROJECT_DIR" Enter

    if [[ "$ENV_TYPE" == "env" ]]; then
        tmux send-keys -t "$TARGET" "source $ENV_VALUE 2>/dev/null || true" Enter<
    elif [[ "$ENV_TYPE" == "conda" ]]; then
        tmux send-keys -t "$TARGET" "conda activate $ENV_VALUE 2>/dev/null || true" Enter
    fi
}

# Create session
tmux new-session -d -s "$SESSION" -n api
apply_env "$SESSION:api"
tmux send-keys -t "$SESSION:api" "$API_CMD" Enter

# Celery window
tmux new-window -t "$SESSION" -n celery
apply_env "$SESSION:celery"
tmux send-keys -t "$SESSION:celery" "$CELERY_CMD" Enter

# Tests window (NO auto-run)
tmux new-window -t "$SESSION" -n tests
apply_env "$SESSION:tests"
tmux send-keys -t "$SESSION:tests" "# Ready for tests (pytest not auto-run)" Enter

tmux attach -t "$SESSION"
