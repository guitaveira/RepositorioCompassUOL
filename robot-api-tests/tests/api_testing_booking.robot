*** Settings ***
Resource          ../resources/api_testing_booking_resources.robot
Suite Setup       Conectar na API e Gerar Token
Test Setup        Criar Nova Reserva Para Teste

*** Test Cases ***
Cenário: Atualizar reserva completa com autenticação
    ${dates}=          Create Dictionary    checkin=2025-01-01    checkout=2025-01-07
    &{payload}=        Create Dictionary    
    ...                firstname=James    
    ...                lastname=Bond    
    ...                totalprice=700    
    ...                depositpaid=${False}    
    ...                additionalneeds=Martini
    Set To Dictionary  ${payload}    bookingdates=${dates}
    
    ${response}=       PUT On Session    
    ...                Restful-booker    
    ...                /booking/${BOOKING_ID}    
    ...                json=${payload}    
    ...                headers=${AUTH_HEADERS}
    
    Status Should Be   200    ${response}
    Should Be Equal    ${response.json()}[firstname]    James
    Should Be Equal    ${response.json()}[lastname]     Bond

Cenário: Tentar atualizar reserva sem autenticação
    ${dates}=          Create Dictionary    checkin=2025-01-01    checkout=2025-01-07
    &{payload}=        Create Dictionary    
    ...                firstname=James    
    ...                lastname=Bond    
    ...                totalprice=700    
    ...                depositpaid=${False}    
    ...                additionalneeds=Martini
    Set To Dictionary  ${payload}    bookingdates=${dates}
    
    ${response}=       PUT On Session    
    ...                Restful-booker    
    ...                /booking/${BOOKING_ID}    
    ...                json=${payload}    
    ...                headers=${NO_AUTH_HEADERS}    
    ...                expected_status=403
    
    Should Be Equal    ${response.status_code}    ${403}

Cenário: Atualizar parcialmente reserva com autenticação
    ${payload_parcial}=    Create Dictionary    firstname=John    lastname=Wick
    
    ${response}=       PATCH On Session    
    ...                Restful-booker    
    ...                /booking/${BOOKING_ID}    
    ...                json=${payload_parcial}    
    ...                headers=${AUTH_HEADERS}
    
    Status Should Be   200    ${response}
    Should Be Equal    ${response.json()}[firstname]    John
    Should Be Equal    ${response.json()}[lastname]     Wick

Cenário: Tentar atualizar parcialmente sem autenticação
    ${payload_parcial}=    Create Dictionary    firstname=John
    
    ${response}=       PATCH On Session    
    ...                Restful-booker    
    ...                /booking/${BOOKING_ID}    
    ...                json=${payload_parcial}    
    ...                headers=${NO_AUTH_HEADERS}    
    ...                expected_status=403
    
    Should Be Equal    ${response.status_code}    ${403}

Cenário: Deletar reserva com autenticação
    ${response}=       DELETE On Session    
    ...                Restful-booker    
    ...                /booking/${BOOKING_ID}    
    ...                headers=${AUTH_HEADERS}    
    ...                expected_status=201
    
    Should Be Equal    ${response.status_code}    ${201}

Cenário: Verificar se reserva foi deletada
    # Primeiro deleta a reserva
    DELETE On Session    Restful-booker    /booking/${BOOKING_ID}    headers=${AUTH_HEADERS}
    
    # Depois verifica que não existe mais
    ${response}=       GET On Session    
    ...                Restful-booker    
    ...                /booking/${BOOKING_ID}    
    ...                expected_status=404
    
    Should Be Equal    ${response.status_code}    ${404}

Cenário: Tentar deletar reserva sem autenticação
    ${response}=       DELETE On Session    
    ...                Restful-booker    
    ...                /booking/${BOOKING_ID}    
    ...                headers=${NO_AUTH_HEADERS}    
    ...                expected_status=403
    
    Should Be Equal    ${response.status_code}    ${403}

Cenário: Tentar deletar reserva inexistente
    ${id_invalido}=    Set Variable    99999999
    
    ${response}=       DELETE On Session    
    ...                Restful-booker    
    ...                /booking/${id_invalido}    
    ...                headers=${AUTH_HEADERS}    
    ...                expected_status=405
    
    Should Be Equal    ${response.status_code}    ${405}