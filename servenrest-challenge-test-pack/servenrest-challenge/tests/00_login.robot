*** Settings ***
Resource      ../resources/api.resource
Suite Setup   Create API Session
Library       String

*** Test Cases ***
Login retorna token Bearer
    ${payload}=    Create Dictionary    email=${ADMIN_EMAIL}    password=${ADMIN_PASS}
    ${resp}=       POST On Session    ${ALIAS}    /login    json=${payload}
    Should Be Equal As Integers    ${resp.status_code}    200
    ${auth}=       Set Variable    ${resp.json()["authorization"]}
    Should Start With    ${auth}    Bearer
