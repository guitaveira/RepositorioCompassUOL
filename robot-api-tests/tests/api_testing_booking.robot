*** Settings ***
Resource          ../resources/api_testing_booking_resources.robot
Suite Setup       Conectar na API e Gerar Token
Test Setup        Criar Nova Reserva Para Teste

*** Test Cases ***
# Testes GET
Cenario: GET - Consultar Reserva Existente
    ${response}=    GET On Session    Restful-booker    /booking/${BOOKING_ID}
    Status Should Be    200    ${response}
    Should Be Equal    ${response.json()}[firstname]    Gui
    Should Be Equal    ${response.json()}[lastname]     Black

Cenario: GET - Verificar se Reserva foi Deletada
    DELETE On Session    Restful-booker    /booking/${BOOKING_ID}    headers=${AUTH_HEADERS}
    ${response}=    GET On Session    Restful-booker    /booking/${BOOKING_ID}    expected_status=404
    Should Be Equal    ${response.status_code}    ${404}

# Testes POST  
Cenario: POST - Criar Nova Reserva
    ${booking_body}=    Create Dictionary    firstname=Mary    lastname=Silver    totalprice=200    depositpaid=${True}    additionalneeds=Dinner
    ${dates}=           Create Dictionary    checkin=2024-02-01    checkout=2024-02-05
    Set To Dictionary    ${booking_body}    bookingdates    ${dates}
    ${response}=    POST On Session    Restful-booker    /booking    json=${booking_body}
    Status Should Be    200    ${response}
    Should Contain    ${response.json()}    bookingid

# Testes PUT
Cenario: PUT - Atualizar Reserva com Sucesso
    ${dates}=    Create Dictionary    checkin=2025-01-01    checkout=2025-01-07
    &{payload}=     Create Dictionary    firstname=Thiago    lastname=Bond    totalprice=700    depositpaid=${False}    additionalneeds=Martini
    Set To Dictionary    ${payload}    bookingdates=${dates}
    ${response}=    PUT On Session    Restful-booker    /booking/${BOOKING_ID}    json=${payload}    headers=${AUTH_HEADERS}
    Status Should Be    200    ${response}

Cenario: PUT - Tentar Atualizar Reserva Sem Autenticacao
    ${dates}=    Create Dictionary    checkin=2025-01-01    checkout=2025-01-07
    &{payload}=     Create Dictionary    firstname=Thiago    lastname=Bond    totalprice=700    depositpaid=${False}    additionalneeds=Martini
    Set To Dictionary    ${payload}    bookingdates=${dates}
    ${response}=    PUT On Session    Restful-booker    /booking/${BOOKING_ID}    json=${payload}    headers=${NO_AUTH_HEADERS}    expected_status=403
    Should Be Equal    ${response.status_code}    ${403}

# Testes PATCH
Cenario: PATCH - Atualizar Parcialmente Reserva com Sucesso
    ${payload_parcial}=    Create Dictionary    firstname=John   lastname=Kenner
    ${response}=    PATCH On Session    Restful-booker    /booking/${BOOKING_ID}    json=${payload_parcial}    headers=${AUTH_HEADERS}
    Status Should Be    200    ${response}

Cenario: PATCH - Tentar Atualizar Parcialmente Sem Autenticacao
    ${payload_parcial}=    Create Dictionary    firstname=John
    ${response}=    PATCH On Session    Restful-booker    /booking/${BOOKING_ID}    json=${payload_parcial}    headers=${NO_AUTH_HEADERS}    expected_status=403
    Should Be Equal    ${response.status_code}    ${403}

# Testes DELETE
Cenario: DELETE - Deletar Reserva com Sucesso
    ${response}=    DELETE On Session    Restful-booker    /booking/${BOOKING_ID}    headers=${AUTH_HEADERS}    expected_status=201
    Should Be Equal    ${response.status_code}    ${201}

Cenario: DELETE - Tentar Deletar Reserva Sem Autenticacao
    ${response}=    DELETE On Session    Restful-booker    /booking/${BOOKING_ID}    headers=${NO_AUTH_HEADERS}    expected_status=403
    Should Be Equal    ${response.status_code}    ${403}

Cenario: DELETE - Tentar Deletar Reserva Inexistente
    ${id_invalido}=    Set Variable    99999999
    ${response}=    DELETE On Session    Restful-booker    /booking/${id_invalido}    headers=${AUTH_HEADERS}    expected_status=405
    Should Be Equal    ${response.status_code}    ${405}

# Testes adicionais de fluxo
Cenario: Fluxo Completo - Criar, Consultar, Atualizar e Deletar
    # Criar reserva
    ${booking_body}=    Create Dictionary    firstname=Ana    lastname=Costa    totalprice=300    depositpaid=${True}    additionalneeds=Breakfast
    ${dates}=           Create Dictionary    checkin=2024-03-01    checkout=2024-03-03
    Set To Dictionary    ${booking_body}    bookingdates    ${dates}
    ${response_post}=    POST On Session    Restful-booker    /booking    json=${booking_body}
    Status Should Be    200    ${response_post}
    ${booking_id}=    Set Variable    ${response_post.json()}[bookingid]
    
    # Consultar reserva
    ${response_get}=    GET On Session    Restful-booker    /booking/${booking_id}
    Status Should Be    200    ${response_get}
    Should Be Equal    ${response_get.json()}[firstname]    Ana
    
    # Atualizar reserva
    ${dates_update}=    Create Dictionary    checkin=2024-03-02    checkout=2024-03-04
    &{payload_update}=     Create Dictionary    firstname=Ana    lastname=Silva    totalprice=350    depositpaid=${True}    additionalneeds=Lunch
    Set To Dictionary    ${payload_update}    bookingdates=${dates_update}
    ${response_put}=    PUT On Session    Restful-booker    /booking/${booking_id}    json=${payload_update}    headers=${AUTH_HEADERS}
    Status Should Be    200    ${response_put}
    
    # Deletar reserva
    ${response_delete}=    DELETE On Session    Restful-booker    /booking/${booking_id}    headers=${AUTH_HEADERS}    expected_status=201

    Should Be Equal    ${response_delete.status_code}    ${201}

