#!/bin/bash

set -o history -o histexpand

# Test framework

FAILED=0
function fail {
  FAILED=$((FAILED + 1))
  echo
  echo "❌ " $*
}

PASSED=0
function ok {
  PASSED=$((PASSED + 1))
  echo -n '.'
}

function test_presence {
  if grep -q $1 <<< $2; then
    ok
  else
    fail "expected ${1}"
  fi
}

# Actual tests

CALL_CSS=$(sass test/_test-call.scss)
test_presence 'url(http://foo.com/quoted.jpg)' "$CALL_CSS"
test_presence 'url(http://foo.com/unquoted.jpg)'
test_presence 'url(quoted/transformed)' "$CALL_CSS"
test_presence 'url(unquoted/transformed)' "$CALL_CSS"

NOOP_CSS=$(sass test/_test-noop.scss)
test_presence 'url(quoted.jpg)' "$NOOP_CSS"
test_presence 'url(http://foo.com/quoted.jpg)' "$NOOP_CSS"
test_presence 'url(http://foo.com/unquoted.jpg)' "$NOOP_CSS"


# Display results

echo
if [ $FAILED -gt 0 ]; then
  echo "❌  ${FAILED} failed. ${PASSED} passed"
  exit 1
else
  echo "✔ ${PASSED} passed"
fi

