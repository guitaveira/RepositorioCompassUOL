*** Settings ***
Library           RequestsLibrary
Variables         ../variables/env.py

*** Variables ***
${ALIAS}          servrest
${TOKEN}          None

*** Keywords ***
Create API Session
    Create Session    ${ALIAS}    ${BASE_URL}    headers={"Content-Type":"application/json"}

Login As Admin
    [Documentation]   Faz login e guarda o token em variável de suíte
    ${payload}=       Create Dictionary    email=${ADMIN_EMAIL}    password=${ADMIN_PASS}
    ${resp}=          POST On Session    ${ALIAS}    /login    json=${payload}
    Should Be Equal As Integers    ${resp.status_code}    200
    ${token}=         Set Variable    ${resp.json()["authorization"]}
    Set Suite Variable    ${TOKEN}    ${token}

Auth Header
    [Return]    {"Authorization": "${TOKEN}", "Content-Type": "application/json"}
