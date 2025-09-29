*** Settings ***
Resource      ../resources/api.resource
Suite Setup   Setup Suite
Library       String

*** Keywords ***
Setup Suite
    Create API Session
    Login As Admin

*** Test Cases ***
Criar Produto (admin) OK
    ${headers}=     Auth Header
    ${rand}=        Generate Random String    6    [LETTERS]
    ${prod}=        Create Dictionary    nome=Teclado ${rand}    preco=120    descricao=Mecanico    quantidade=5
    ${resp}=        POST On Session    ${ALIAS}    /produtos    headers=${headers}    json=${prod}
    Should Be Equal As Integers    ${resp.status_code}    201
    Dictionary Should Contain Key    ${resp.json()}    message
    Dictionary Should Contain Key    ${resp.json()}    _id

Nao Permite Criar Produto sem ser admin (403)
    ${rand}=        Generate Random String    6    [LETTERS]
    ${prod}=        Create Dictionary    nome=Mouse ${rand}    preco=80    descricao=Optico    quantidade=3
    ${resp}=        POST On Session    ${ALIAS}    /produtos    json=${prod}
    Should Be Equal As Integers    ${resp.status_code}    403
