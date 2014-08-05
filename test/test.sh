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

function assert_css_contains {
  if grep -q $1 <<< $CSS; then
    ok
  else
    fail "expected CSS compiled from ${SASS_PATH} to contain ${1}"
  fi
}

function with_sass {
  SASS_PATH=$1
  CSS=$(sass $SASS_PATH)
}
# Actual tests

# Test call conditions
with_sass test/_test-call.scss
assert_css_contains 'url(http://foo.com/quoted.jpg)'
assert_css_contains 'url(http://foo.com/unquoted.jpg)'
assert_css_contains 'url(quoted/transformed)'
assert_css_contains 'url(unquoted/transformed)'

# Test default no-op behaviour
with_sass test/_test-noop.scss
assert_css_contains 'url(quoted.jpg)'
assert_css_contains 'url(http://foo.com/quoted.jpg)'
assert_css_contains 'url(http://foo.com/unquoted.jpg)'

# Test Compass integration
with_sass test/_test-compass.scss
assert_css_contains 'url(/images/logo.png)'
assert_css_contains 'url(/fonts/font.woff)'

# Test Sprockets integration
with_sass test/_test-sprockets.scss
assert_css_contains 'url(/assets/logo.png)'
assert_css_contains 'url(/assets/font.woff)'

# Display results
echo
if [ $FAILED -gt 0 ]; then
  echo "❌  ${FAILED} failed. ${PASSED} passed."
  exit 1
else
  echo "✔ All ${PASSED} passed."
fi

