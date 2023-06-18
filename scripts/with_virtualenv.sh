#!/bin/bash

set -e

VENV_DIR=$(mktemp -d)
PYTHON_TEST_PACKAGE="typing-extensions"

echo "Virtualenv created at ${VENV_DIR}"

python3 -m venv "${VENV_DIR}"
"${VENV_DIR}"/bin/python -m pip install "$PYTHON_TEST_PACKAGE"

source "${VENV_DIR}/bin/activate"

sbt \
  -Dscalapy.ci.executable="${VENV_DIR}/bin/python" \
  -Dscalapy.ci.pythontestpackage="$PYTHON_TEST_PACKAGE" \
  "$@"

deactivate
echo "Delete virtualenv ${VENV_DIR}"
rm -rf "${VENV_DIR}"
