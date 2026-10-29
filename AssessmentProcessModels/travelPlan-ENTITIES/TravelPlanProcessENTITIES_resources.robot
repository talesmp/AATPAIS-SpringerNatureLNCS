*** Settings ***
Library    FakerLibrary    #locale=pt_BR
Library    RPA.Browser.Selenium
Library    String
Library    RPA.Desktop

*** Variables ***
${url_home}    http://localhost:8080/
${url_my_tasks}    ${url_home}my-candidate-tasks
${locator-task-book-a-hotel-hotelBookingNumber}    task-book-a-hotel-hotelBookingNumber
${locator-task-book-a-hotel-hotelCompany.name}    task-book-a-hotel-hotelCompany
${locator-task-buy-flight-tickets-airlineCompany.name}    task-buy-flight-tickets-airlineCompany
${locator-task-buy-flight-tickets-airlineTicketNumber}    task-buy-flight-tickets-airlineTicketNumber
${locator-task-rent-a-car-carBookingNumber}    task-rent-a-car-carBookingNumber
${locator-task-rent-a-car-carRentalCompany.name}    task-rent-a-car-carRentalCompany
${locator-travel-plan-start-form-endDate}    travel-plan-start-form-endDate
${locator-travel-plan-start-form-name}    travel-plan-start-form-name
${locator-travel-plan-start-form-startDate}    travel-plan-start-form-startDate

*** Keywords ***
The user logs in
    [Documentation]  
    [Arguments]  
    Open Available Browser    maximized=true
    Go To    ${url_home}
    Click Element When Visible       account-menu__BV_toggle_
    Click Element When Visible       login
    Wait Until Element Is Visible    login-page___BV_modal_header_
    Input Text When Element Is Visible    username    admin
    Input Text When Element Is Visible    password    admin
    Click Element When Visible    //span[contains(.,'Remember me')]
    Click Button When Visible    //button[@data-cy='submit'][contains(.,'Sign in')]
    Sleep    500ms

The user is in MyTasks
    [Documentation]  
    [Arguments]  
    Sleep    500ms
    Go To    ${url_my_tasks}
    Wait Until Element Is Visible    task-instance-heading

The user is in StartEvent_1
    [Documentation]  
    [Arguments]  
    Sleep    500ms  
    Go To    http://localhost:8080/process-definition/TravelPlanProcessENTITIES/init 

The user fills StartEvent_1 
    [Documentation]  
    [Arguments]    ${argRes-name}=${argTest-name}    ${argRes-startDate}=${argTest-startDate}    ${argRes-endDate}=${argTest-endDate} 
    Wait Until Page Contains    Create or edit a 
    Input Text When Element Is Visible    ${locator-travel-plan-start-form-name}    ${argRes-name} 
    Input Text When Element Is Visible    ${locator-travel-plan-start-form-startDate}    ${argRes-startDate} 
    Input Text When Element Is Visible    ${locator-travel-plan-start-form-endDate}    ${argRes-endDate} 

The user submits StartEvent_1
    [Documentation]  
    [Arguments]  
    Sleep    500ms  
    Capture Page Screenshot  
    Click Button    save-entity 

The user is in TaskCar
    [Documentation]  
    [Arguments]  
    Sleep    500ms  
    Click Element If Visible    xpath:/html[1]/body[1]/div[1]/div[3]/div[1]/div[1]/div[1]/div[2]/table[1]/tbody[1]/tr[1]/td[12]/div[1]/button[1]  
    Wait Until Page Contains    TaskCar

The user fills TaskCar 
    [Documentation]  
    [Arguments]    ${argRes-carBookingNumber}=${argTest-carBookingNumber}    ${argRes-carRentalCompany.name}=${argTest-carRentalCompany.name} 
    Wait Until Page Contains    TaskCar 
    Input Text When Element Is Visible    ${locator-task-rent-a-car-carBookingNumber}    ${argRes-carBookingNumber} 
    Click Element When Visible    ${locator-task-rent-a-car-carRentalCompany.name} 
    IF    '${argRes-carRentalCompany.name}'=='blindExecutionSelection'
        ${list_options}=    Get WebElements    //select[@id='${locator-task-rent-a-car-carRentalCompany.name}']/option 
        ${options_length}=    Get Length    ${list_options} 
        ${random_index}=    Random Int    1    ${options_length - 1} 
        Select From List By Index    ${locator-task-rent-a-car-carRentalCompany.name}    ${random_index} 
    ELSE 
        Click Element When Visible     //option[@value='[object Object]'][contains(.,'${argRes-carRentalCompany.name}')]  
    END 

The user submits TaskCar
    [Documentation]  
    [Arguments]  
    Sleep    500ms  
    Capture Page Screenshot  
    Click Button    //button[@type='submit'][contains(.,'Complete')] 

The user is in TaskFlight
    [Documentation]  
    [Arguments]  
    Sleep    500ms  
    Click Element If Visible    xpath:/html[1]/body[1]/div[1]/div[3]/div[1]/div[1]/div[1]/div[2]/table[1]/tbody[1]/tr[1]/td[12]/div[1]/button[1]  
    Wait Until Page Contains    TaskFlight

The user fills TaskFlight 
    [Documentation]  
    [Arguments]    ${argRes-airlineTicketNumber}=${argTest-airlineTicketNumber}    ${argRes-airlineCompany.name}=${argTest-airlineCompany.name} 
    Wait Until Page Contains    TaskFlight 
    Input Text When Element Is Visible    ${locator-task-buy-flight-tickets-airlineTicketNumber}    ${argRes-airlineTicketNumber} 
    Click Element When Visible    ${locator-task-buy-flight-tickets-airlineCompany.name} 
    IF    '${argRes-airlineCompany.name}'=='blindExecutionSelection'
        ${list_options}=    Get WebElements    //select[@id='${locator-task-buy-flight-tickets-airlineCompany.name}']/option 
        ${options_length}=    Get Length    ${list_options} 
        ${random_index}=    Random Int    1    ${options_length - 1} 
        Select From List By Index    ${locator-task-buy-flight-tickets-airlineCompany.name}    ${random_index} 
    ELSE 
        Click Element When Visible     //option[@value='[object Object]'][contains(.,'${argRes-airlineCompany.name}')]  
    END 

The user submits TaskFlight
    [Documentation]  
    [Arguments]  
    Sleep    500ms  
    Capture Page Screenshot  
    Click Button    //button[@type='submit'][contains(.,'Complete')] 

The user is in TaskHotel
    [Documentation]  
    [Arguments]  
    Sleep    500ms  
    Click Element If Visible    xpath:/html[1]/body[1]/div[1]/div[3]/div[1]/div[1]/div[1]/div[2]/table[1]/tbody[1]/tr[1]/td[12]/div[1]/button[1]  
    Wait Until Page Contains    TaskHotel

The user fills TaskHotel 
    [Documentation]  
    [Arguments]    ${argRes-hotelBookingNumber}=${argTest-hotelBookingNumber}    ${argRes-hotelCompany.name}=${argTest-hotelCompany.name} 
    Wait Until Page Contains    TaskHotel 
    Input Text When Element Is Visible    ${locator-task-book-a-hotel-hotelBookingNumber}    ${argRes-hotelBookingNumber} 
    Click Element When Visible    ${locator-task-book-a-hotel-hotelCompany.name} 
    IF    '${argRes-hotelCompany.name}'=='blindExecutionSelection'
        ${list_options}=    Get WebElements    //select[@id='${locator-task-book-a-hotel-hotelCompany.name}']/option 
        ${options_length}=    Get Length    ${list_options} 
        ${random_index}=    Random Int    1    ${options_length - 1} 
        Select From List By Index    ${locator-task-book-a-hotel-hotelCompany.name}    ${random_index} 
    ELSE 
        Click Element When Visible     //option[@value='[object Object]'][contains(.,'${argRes-hotelCompany.name}')]  
    END 

The user submits TaskHotel
    [Documentation]  
    [Arguments]  
    Sleep    500ms  
    Capture Page Screenshot  
    Click Button    //button[@type='submit'][contains(.,'Complete')] 

