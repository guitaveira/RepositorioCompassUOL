*** Settings ***
Library         RequestsLibrary
Library         Collections

*** Variables ***
${BASE_URL}     https://restful-booker.herokuapp.com

*** Keywords ***
Conectar na API e Gerar Token
    Create Session      alias=Restful-booker    url=${BASE_URL}
    
    ${credenciais}=     Create Dictionary    
    ...                 username=admin    
    ...                 password=password123
    
    ${auth_response}=   POST On Session    
    ...                 Restful-booker    
    ...                 /auth    
    ...                 json=${credenciais}
    
    Should Be Equal     ${auth_response.status_code}    ${200}
    
    ${token}=           Set Variable    ${auth_response.json()}[token]
    
    ${auth_headers}=    Create Dictionary    
    ...                 Content-Type=application/json    
    ...                 Accept=application/json    
    ...                 Cookie=token=${token}
    
    ${no_auth_headers}=    Create Dictionary    
    ...                    Content-Type=application/json    
    ...                    Accept=application/json
    
    Set Global Variable    ${AUTH_HEADERS}      ${auth_headers}
    Set Global Variable    ${NO_AUTH_HEADERS}   ${no_auth_headers}

Criar Nova Reserva Para Teste
    ${booking_dates}=   Create Dictionary    
    ...                 checkin=2024-01-01    
    ...                 checkout=2024-01-02
    
    ${booking_body}=    Create Dictionary    
    ...                 firstname=Jim    
    ...                 lastname=Brown    
    ...                 totalprice=111    
    ...                 depositpaid=${True}    
    ...                 additionalneeds=Breakfast    
    ...                 bookingdates=${booking_dates}
    
    ${response}=        POST On Session    
    ...                 Restful-booker    
    ...                 /booking    
    ...                 json=${booking_body}
    
    Should Be Equal     ${response.status_code}    ${200}
    
    ${booking_id}=      Set Variable    ${response.json()}[bookingid]
    Set Test Variable   ${BOOKING_ID}    ${booking_id}