#!/bin/bash
# ===========================================================================
#   KRON - macOS TESTS, part 2 of 2: run them (on the Mac)
#
#   MACTESTS.bat built the tests on Windows into tests/mac. Copy the folder
#   of the compiler to a Mac with Apple silicon and, in it:
#
#       bash MACTESTS.sh            every test in tests/mac/LIST.txt
#       bash MACTESTS.sh test_map   only the ones named
#
#   Each runs from this folder, as on the other systems, and its output is
#   compared with tests/expected/NAME.txt.
#
#   The programs are signed ad hoc, as a linker signs what it builds. A file
#   that arrived through a browser or AirDrop carries the quarantine mark,
#   and macOS asks before running it; the mark is removed here first.
# ===========================================================================

cd "$(dirname "$0")" || exit 1
OUT=tests/mac
EXP=tests/expected

if [ "$(uname -s)" != "Darwin" ] || [ "$(uname -m)" != "arm64" ]; then
    echo "[ERROR] this is for macOS on Apple silicon (arm64)"
    exit 1
fi
if [ ! -f "$OUT/LIST.txt" ] && [ $# -eq 0 ]; then
    echo "[ERROR] $OUT/LIST.txt is missing: build the tests with MACTESTS.bat on Windows first"
    exit 1
fi

if [ $# -gt 0 ]; then
    LIST="$*"
else
    LIST=$(tr -d '\r' < "$OUT/LIST.txt")
fi

PASS=0
FAIL=0
SKIP=0
FAILED=""

echo "============================================================"
echo "  KRON - macOS TESTS (Apple silicon)"
echo "============================================================"
echo

for N in $LIST; do
    if [ ! -f "$OUT/$N" ]; then
        echo "  OMIT  $N  (not built)"
        SKIP=$((SKIP + 1))
        continue
    fi
    if [ ! -f "$EXP/$N.txt" ]; then
        echo "  OMIT  $N  (no reference)"
        SKIP=$((SKIP + 1))
        continue
    fi
    chmod +x "$OUT/$N"
    xattr -d com.apple.quarantine "$OUT/$N" 2>/dev/null
    "./$OUT/$N" > "$OUT/$N.out" 2>&1
    if diff <(tr -d '\r' < "$EXP/$N.txt") <(tr -d '\r' < "$OUT/$N.out") > /dev/null; then
        echo "  PASS  $N  (macOS)"
        PASS=$((PASS + 1))
    else
        echo "  FAIL  $N"
        echo "        --- expected vs got ---"
        diff <(tr -d '\r' < "$EXP/$N.txt") <(tr -d '\r' < "$OUT/$N.out") | head -20
        FAIL=$((FAIL + 1))
        FAILED="$FAILED $N"
    fi
done

echo
echo "============================================================"
echo "  PASS: $PASS    FAIL: $FAIL    SKIPPED: $SKIP"
if [ $FAIL -gt 0 ]; then
    echo
    echo "  There are differences:$FAILED"
else
    echo
    echo "  All good."
fi
echo "============================================================"
