*** Settings ***
Resource    resources/api_keywords.robot

*** Test Cases ***
Health Check
    [Tags]    health
    Check API Health

Get User List
    [Tags]    users
    Get Users And Validate Response
