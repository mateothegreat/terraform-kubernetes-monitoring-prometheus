#!/bin/sh

jq -n --arg hash "$(htpasswd -bn $1 $2)" '{"hash":$hash}'
