#!/bin/bash

set -e

VENV_DIR=$(mktemp -d)
PYTHON_TEST_PACKAGE="typing-extensions"

echo "CREATING VIRTUALENV AT ${VENV_DIR} ..."

python3 -m venv "${VENV_DIR}"
"${VENV_DIR}"/bin/python -m pip install "$PYTHON_TEST_PACKAGE"

VENV_ACTIVATE_NIX="${VENV_DIR}/bin/activate"
VENV_ACTIVATE_WIN="${VENV_DIR}/Scripts/activate.bat"

if [ -f "$VENV_ACTIVATE_NIX" ]; then
  source "$VENV_ACTIVATE_NIX"
elif [ -f "$VENV_ACTIVATE_WIN" ]; then
  cmd "$VENV_ACTIVATE_WIN"
else
  echo "COULD NOT FIND VIRTUALENV ACTIVATE SCRIPT AT EITHER ${VENV_ACTIVATE_NIX} OR ${VENV_ACTIVATE_WIN}."
  exit 1
fi

echo "RUNNING TESTS ..."

sbt \
  -Dscalapy.ci.executable="${VENV_DIR}/bin/python" \
  -Dscalapy.ci.pythontestpackage="$PYTHON_TEST_PACKAGE" \
  "$@"

deactivate
echo "DELETING VIRTUALENV ${VENV_DIR} ..."
rm -rf "${VENV_DIR}"
