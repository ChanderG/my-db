#!/bin/bash

# Test performance of the database

function setupTest {
  DB="testdb"
  ./mydb init $DB
}

function destroyTest {
  # remove the test database
  rm $DB
}

function testWrites {
  NOS=$1 # number of unique keys to write

  T="$(date +%s)"
  for i in `seq 1 $NOS`; do
    DB=$DB ./mydb put $i 'Sample record.'
  done
  T="$(($(date +%s)-T))"

  echo "Write test: $(($NOS/$T)) Tx/sec"
}

function testReads {
  NOS=$1 # number of unique keys to read

  T="$(date +%s)"
  for i in `seq 1 $NOS`; do
    DB=$DB ./mydb get $i &> /dev/null
  done
  T="$(($(date +%s)-T))"

  echo "Read test: $(($NOS/$T)) Tx/sec"
}

setupTest
testWrites 1000
testReads 1000
destroyTest
