*** Settings ***
Library    RequestsLibrary
Library    String
Resource    ../resources/variables.robot

*** Test Cases ***
Api Produto
    [Documentation]    Teste para API Produtos
    Create Session    api    ${BASE_URL}

     # 🔹 Gerar letra aleatória (6 caracteres)
    ${random_string}    Generate Random String    6    [LETTERS]

    # 🔹 Realizar autenticação e capturar Token
    ${body}    Create Dictionary
    ...    email=robsonqa@qa.com.br
    ...    password=teste        

    ${headers}    Create Dictionary    Content-Type=application/json

    ${response}    POST On Session    api    /login
    ...    json=${body}    
    ...    headers=${headers}   

    Log    ${response.json()}
    Should Be Equal As Numbers    ${response.status_code}    200   

    ${user_authorization}    Set Variable    ${response.json()}[authorization] 

    Log To Console    \n✅ Login realizado com sucesso! Token: ${user_authorization}

    # 🔹 Criar Produto autenticado
    ${product_body}    Create Dictionary    
    ...    nome=${random_string}     
    ...    preco=470    
    ...    descricao=Mouse    
    ...    quantidade=381    

    ${auth_headers}    Create Dictionary    
    ...    Content-Type=application/json    
    ...    Authorization=${user_authorization}

    ${product_response}    POST On Session    api    /produtos    
    ...    json=${product_body}    
    ...    headers=${auth_headers}    

    Log    ${product_response.json()}
    Should Be Equal As Numbers    ${product_response.status_code}    201   

 # 🔹 Captura o _id do usuário criado
    ${produto_id}    Set Variable    ${product_response.json()}[_id]

    Log To Console    \n✅ Produto criado com sucesso! ID: ${produto_id}

     # 🔹 Consultar Produto pelo _id na Query String
    ${query_params}    Create Dictionary    _id=${produto_id}

    ${get_product_response}    GET On Session    api    /produtos    
    ...    params=${query_params}    
    ...    headers=${auth_headers}

    Should Be Equal As Numbers    ${get_product_response.status_code}    200   
    Should Be Equal As Strings    ${get_product_response.json()}[produtos][0][_id]    ${produto_id}

    Log To Console    \n✅ Produto consultado com sucesso!\n${get_product_response.json()}

    # 🔹 Editar o produto criado  
    ${body}    Create Dictionary    
    ...    nome=Produto ${random_string}   
    ...    preco=470    
    ...    descricao=Mouse    
    ...    quantidade=381     

    ${headers}    Create Dictionary    Content-Type=application/json

    ${response}    PUT On Session    api    /produtos/${produto_id}    
    ...    json=${body} 
    ...    headers=${auth_headers}      

    Log    ${response.json()}
    Should Be Equal As Numbers    ${response.status_code}    200

    Log To Console    \n✅ Produto editado com sucesso!\n${response.json()}

      # 🔹 Excluir o produto criado
    ${get_response}    DELETE On Session    api    /produtos/${produto_id} 
    ...    headers=${auth_headers}
       
    Log    ${response.json()}
    Should Be Equal As Numbers    ${get_response.status_code}    200      

    Log To Console    \n✅ Produto excluido com sucesso!\n${response.json()}
