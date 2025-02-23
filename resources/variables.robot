*** Variables ***
${BASE_URL}    https://serverest.dev

*** Keywords ***
Get Default Headers
    ${headers}    Create Dictionary    Content-Type=application/json
    RETURN    ${headers}
