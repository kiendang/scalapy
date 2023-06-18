#!/bin/bash

set -x
set -e

VENV_DIR=$(mktemp -d)
PYTHON_TEST_PACKAGE="typing-extensions"

function cleanup {
  if [ -x $(command -v deactivate) ]; then
    deactivate
  fi
  echo "DELETING VIRTUALENV ${VENV_DIR} ..."
  rm -rf "${VENV_DIR}"
}

trap cleanup EXIT

echo "CREATING VIRTUALENV AT ${VENV_DIR} ..."

python -m venv "${VENV_DIR}"

PYTHON_NIX="${VENV_DIR}/bin/python"
PYTHON_WIN="${VENV_DIR}/Scripts/python.exe"

if [ -f "$PYTHON_NIX" ]; then
  PYTHON="$PYTHON_NIX"
elif [ -f "$PYTHON_WIN" ]; then
  PYTHON="$PYTHON_WIN"
else
  echo "COULD NOT FIND VIRTUALENV PYTHON EXECUTABLE AT EITHER ${PYTHON_NIX} OR ${PYTHON_WIN}."
  exit 1
fi

echo "INSTALLING PACKAGE ${PYTHON_TEST_PACKAGE} INTO VIRTUALENV..."

"$PYTHON" -m pip install "$PYTHON_TEST_PACKAGE"

echo "ACTIVATING VIRTUALENV AT ${VENV_DIR} ..."

VENV_ACTIVATE_NIX="${VENV_DIR}/bin/activate"
VENV_ACTIVATE_WIN="${VENV_DIR}/Scripts/activate"

if [ -f "$VENV_ACTIVATE_NIX" ]; then
  VENV_ACTIVATE="$VENV_ACTIVATE_NIX"
elif [ -f "$VENV_ACTIVATE_WIN" ]; then
  VENV_ACTIVATE="$VENV_ACTIVATE_WIN"
else
  echo "COULD NOT FIND VIRTUALENV ACTIVATE SCRIPT AT EITHER ${VENV_ACTIVATE_NIX} OR ${VENV_ACTIVATE_WIN}."
  exit 1
fi

. "$VENV_ACTIVATE"

echo "$PATH"
echo "$PATHEXT"

if [ -d "${VENV_DIR}/Scripts" ]; then
  echo $(ls "${VENV_DIR}/Scripts")
fi

echo "VIRTUALENV python:              ${PYTHON}"
echo "CURRENT DEFAULT python ON PATH: $(command -v python)"

if ! [ $(command -v python) -ef "$PYTHON" ]; then
  echo "VIRTUALENV ACTIVATION FAILED. CURRENT DEFAULT python ON PATH DOES NOT POINT TO VIRTUALENV."
  exit 1
fi

echo "RUNNING TESTS ..."

sbt \
  -Dscalapy.ci.executable="${PYTHON}" \
  -Dscalapy.ci.pythontestpackage="$PYTHON_TEST_PACKAGE" \
  "$@"
