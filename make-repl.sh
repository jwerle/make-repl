#!/bin/bash

TAB="`printf '\t'`"
TMP="${TMPDIR:-/tmp}"
PROMPT="${PROMPT:-make>}"
MAKE="${MAKE:-make}"

mread () {
  local buf
  {
    trap "exit 1" SIGTERM
    trap "exit 0" SIGINT
    printf "%s " "${PROMPT}"
    read -er buf
    #read -n 1 buf
    #read -n 1 -t 1 b1
    #read -n 1 -t 1 b2
    #read -n 1 -t 1 b3
    #buf+=${k1}${k2}${b3}
    meval "${buf}"
  }

  return $?
}

meval () {
  local buf="${1}"
  local ctx="${TMP}/make-repl-${RANDOM}"
  if [ -z "${buf}" ]; then
    echo "nil"
    mread
  else
    ## remove existing context if exists
    rm -f "${ctx}"
    ## create new context
    touch "${ctx}"
    cat >> "${ctx}" <<MAKE
value = \$(${buf})

e:
${TAB}@echo \$(value)
MAKE
  ${MAKE} e -f "${ctx}" | {
    while read -r line; do
      if ! [ -z "${line}" ]; then
        echo $line
      fi
    done
  }
  ## cleanup
  rm -f "${ctx}"
  mread
  fi
  return 0
}

repl () {
  mread
  return 0
}

repl "${@}"
exit $?
