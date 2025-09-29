*** Settings ***
Resource      ../resources/api.resource
Suite Setup   Create API Session
Library       String

*** Test Cases ***
CRUD Usuarios - cadastrar, buscar por id e excluir
    ${rand}=         Generate Random String    6    [LETTERS]
    ${email}=        Set Variable    qa_${rand}@test.com
    ${payload}=      Create Dictionary    nome=QA ${rand}    email=${email}    password=1234    administrador=true
    ${resp}=         POST On Session    ${ALIAS}    /usuarios    json=${payload}
    Should Be Equal As Integers    ${resp.status_code}    201
    ${id}=           Set Variable    ${resp.json()['_id']}

    ${get}=          GET On Session    ${ALIAS}    /usuarios/${id}
    Should Be Equal As Integers    ${get.status_code}    200
    Should Be Equal    ${get.json()['_id']}    ${id}

    ${del}=          DELETE On Session    ${ALIAS}    /usuarios/${id}
    Should Be Equal As Integers    ${del.status_code}    200
