*** Settings ***
Library    RequestsLibrary
Library    String
Resource    ../resources/variables.robot

*** Test Cases ***
Criar e Consultar Usuário
    [Documentation]    Teste para criar um usuário e consultá-lo depois
    Create Session    api    ${BASE_URL}

    # 🔹 Gerar parte aleatória do e-mail (10 caracteres)
    ${random_string}    Generate Random String    6    [LETTERS]
    ${email}    Set Variable    ${random_string}@qa.com.br

    Log To Console    \n📧 E-mail gerado: ${email}

    ${body}    Create Dictionary    
    ...    nome=Fulano da Silva    
    ...    email=${email}    
    ...    password=teste    
    ...    administrador=true    

    ${headers}    Create Dictionary    Content-Type=application/json

    ${response}    POST On Session    api    /usuarios    
    ...    json=${body}    
    ...    headers=${headers}    

    Log    ${response.json()}
    Should Be Equal As Numbers    ${response.status_code}    201

    # 🔹 Captura o _id do usuário criado
    ${user_id}    Set Variable    ${response.json()}[_id]

    Log To Console    \n✅ Usuário criado com sucesso! ID: ${user_id}

    # 🔹 Consulta o usuário criado
    ${get_response}    GET On Session    api    /usuarios/${user_id}    
    Log    ${get_response.json()}
    Should Be Equal As Numbers    ${get_response.status_code}    200
    Should Be Equal As Strings    ${get_response.json()}[_id]    ${user_id}

    Log To Console    \n✅ Consulta realizada com sucesso!\n${get_response.json()}

    # 🔹 Editar o usuário criado
    ${random_string}    Generate Random String    6    [LETTERS]
    ${email}    Set Variable    ${random_string}@qa.com.br

    Log To Console    \n📧 E-mail gerado: ${email}

    ${body}    Create Dictionary    
    ...    nome=Usuario Editado    
    ...    email=${email}    
    ...    password=teste    
    ...    administrador=true    

    ${headers}    Create Dictionary    Content-Type=application/json

    ${response}    PUT On Session    api    /usuarios/${user_id}    
    ...    json=${body}    
    ...    headers=${headers}    

    Log    ${response.json()}
    Should Be Equal As Numbers    ${response.status_code}    200

    Log To Console    \n✅ Usuario editado com sucesso!\n${get_response.json()}

    # 🔹 Excluir o usuário criado
    ${get_response}    DELETE On Session    api    /usuarios/${user_id}    
    Log    ${get_response.json()}
    Should Be Equal As Numbers    ${get_response.status_code}    200    

    Log To Console    \n✅ Usuario excluido com sucesso!\n${get_response.json()}
    
