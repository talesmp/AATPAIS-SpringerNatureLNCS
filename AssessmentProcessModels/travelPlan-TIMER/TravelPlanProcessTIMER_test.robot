# Prompt Command to Execute the BlindBatch Test Case : 
# robot -i TC_BlindBatch TravelPlanProcessTIMER_test.robot
# Prompt Command to Execute the Planned Test Cases with the tag "planned" : 
# robot -i planned TravelPlanProcessTIMER_test.robot
*** Settings ***
Library    FakerLibrary    #locale=pt_BR 
Library    OperatingSystem 
Library    Collections 
Library    DateTime 
Resource    TravelPlanProcessTIMER_resources.robot
Test Setup    kwFakerDataSetup

*** Variables ***
@{TaskNames}    TaskCar  TaskFlight  TaskHotel

*** Test Cases ***
TC_BlindBatch
    [Tags]  blind 
    ${kw_executed}=    Create List
    kwLogin
    ${start_time}=    Get Time    epoch
    FOR    ${i}    IN RANGE    30
        ${inner_list}=    Create List
        kwFakerDataSetup
        kwStartEvent_1
        Append To List    ${inner_list}    Start of Execution #${i}
        Append to List    ${inner_list}    StartEvent_1
        WHILE    $processRunning == True
            kwFindFirstAvailableTask
            IF    $found_task == "TaskCar"
                kwFakerDataSetup
                kwTaskCar
                Append To List    ${inner_list}    TaskCar
            ELSE IF    $found_task == "TaskFlight"
                kwFakerDataSetup
                kwTaskFlight
                Append To List    ${inner_list}    TaskFlight
            ELSE IF    $found_task == "TaskHotel"
                kwFakerDataSetup
                kwTaskHotel
                Append To List    ${inner_list}    TaskHotel
            ELSE IF    $found_task == "No task available."
                ${processRunning}=    Set Variable    ${False}
                Set Test Variable    ${processRunning}
                BREAK
            END
        END
        Append To List    ${inner_list}    End of Execution #${i} 
        Append To List    ${kw_executed}    ${inner_list} 
    END
    ${end_time}=    Get Time    epoch 
    ${time_spent}=    Subtract Time From Time    ${end_time}    ${start_time}    number 
    ${json_string}=    Evaluate    json.dumps(${kw_executed}, indent=4) 
    Create File    /Users/talesmp/Documents/Development/githubPersonal/AATPAIS-SpringerNatureLNCS/AssessmentProcessModels/travelPlan-TIMER/executedKeywords-travelPlan-TIMER.json    ${json_string} 
    ${data}=    Evaluate    json.loads(open("/Users/talesmp/Documents/Development/githubPersonal/AATPAIS-SpringerNatureLNCS/AssessmentProcessModels/travelPlan-TIMER/executedKeywords-travelPlan-TIMER.json").read()) 
    ${execution_paths}=    Evaluate    [' => '.join(execution[1:-1]) for execution in $data] 
    ${execution_counts}=    Evaluate    dict(collections.Counter($execution_paths))    modules=collections 
    ${output}=  Evaluate  "{} executions of TravelPlanProcessTIMER in {} seconds\\n".format(len($data), ${time_spent}) + '\\n'.join(["{} executions: {}".format(count, path) for path, count in $execution_counts.items()]) 
    Create File    /Users/talesmp/Documents/Development/githubPersonal/AATPAIS-SpringerNatureLNCS/AssessmentProcessModels/travelPlan-TIMER/executionsCounter-travelPlan-TIMER.txt    ${output} 

TC_Planned 
    # [Tags]  planned 
    [Documentation]  Arrange the following Keywords below according to the desired test path, always interpolating with the kwMyTasks keyword:
    kwLogin
    kwFakerDataSetup
    kwStartEvent_1
    # kwMyTasks 
    # kwTaskCar
    # kwMyTasks 
    # kwTaskFlight
    # kwMyTasks 
    # kwTaskHotel

*** Keywords ***
kwFindFirstAvailableTask
    kwMyTasks
    ${found_task}=    Set Variable    No task available.
    ${exist_available_task}=    Run Keyword And Return Status    Get Text  xpath=/html[1]/body[1]/div[1]/div[3]/div[1]/div[1]/div[1]/div[2]/table[1]/tbody[1]/tr[1]/td[8]
    IF    $exist_available_task == True
        FOR    ${taskName}    IN ZIP    ${TaskNames}
            ${task_definition_key_from_text}=    Get Text  xpath=/html[1]/body[1]/div[1]/div[3]/div[1]/div[1]/div[1]/div[2]/table[1]/tbody[1]/tr[1]/td[8]
            IF    $task_definition_key_from_text == $taskName
                ${found_task}=    Set Variable    ${taskName}
                BREAK
            END
        END
        IF    $found_task == "No task available."
            ${processRunning}=    Set Variable    ${False}
            Set Test Variable    ${processRunning}
            ${found_task}=    Set Variable    ${task_definition_key_from_text}
            Set Test Variable    ${found_task}
            Fatal Error    Unexpected task found! 
        END
    END
    Set Test Variable    ${found_task}

kwFakerDataSetup
    [Documentation]  FakerLibrary doc: https://marketsquare.github.io/robotframework-faker/ 
    ${faker-startDate}    FakerLibrary.Date
    Set Test Variable    ${faker-startDate}
    ${faker-endDate}    FakerLibrary.Date
    Set Test Variable    ${faker-endDate}
    ${faker-hotelBookingNumber}    FakerLibrary.Sentence  nb_words=8
    Set Test Variable    ${faker-hotelBookingNumber}
    ${faker-carCompanyName}    FakerLibrary.Sentence  nb_words=8
    Set Test Variable    ${faker-carCompanyName}
    ${faker-airlineTicketNumber}    FakerLibrary.Sentence  nb_words=8
    Set Test Variable    ${faker-airlineTicketNumber}
    ${faker-airlineCompanyName}    FakerLibrary.Sentence  nb_words=8
    Set Test Variable    ${faker-airlineCompanyName}
    ${faker-hotelName}    FakerLibrary.Sentence  nb_words=8
    Set Test Variable    ${faker-hotelName}
    ${faker-name}    FakerLibrary.Sentence  nb_words=8
    Set Test Variable    ${faker-name}
    ${faker-carBookingNumber}    FakerLibrary.Sentence  nb_words=8
    Set Test Variable    ${faker-carBookingNumber}
    ${processRunning}=    Set Variable    ${True}
    Set Test Variable    ${processRunning}

kwLogin
    [Documentation]  
    [Arguments]  
    The user logs in

kwMyTasks
    [Documentation]  
    [Arguments]  
    The user is in MyTasks

kwStartEvent_1
    [Documentation]  
    [Arguments]    ${argTest-name}=${faker-name}    ${argTest-startDate}=${faker-startDate}    ${argTest-endDate}=${faker-endDate} 
    The user is in StartEvent_1
    The user fills StartEvent_1    ${argTest-name}    ${argTest-startDate}    ${argTest-endDate} 
    The user submits StartEvent_1

kwTaskCar
    [Documentation]  
    [Arguments]    ${argTest-carCompanyName}=${faker-carCompanyName}    ${argTest-carBookingNumber}=${faker-carBookingNumber} 
    The user is in TaskCar
    The user fills TaskCar    ${argTest-carCompanyName}    ${argTest-carBookingNumber} 
    The user submits TaskCar

kwTaskFlight
    [Documentation]  
    [Arguments]    ${argTest-airlineCompanyName}=${faker-airlineCompanyName}    ${argTest-airlineTicketNumber}=${faker-airlineTicketNumber} 
    The user is in TaskFlight
    The user fills TaskFlight    ${argTest-airlineCompanyName}    ${argTest-airlineTicketNumber} 
    The user submits TaskFlight

kwTaskHotel
    [Documentation]  
    [Arguments]    ${argTest-hotelName}=${faker-hotelName}    ${argTest-hotelBookingNumber}=${faker-hotelBookingNumber} 
    The user is in TaskHotel
    The user fills TaskHotel    ${argTest-hotelName}    ${argTest-hotelBookingNumber} 
    The user submits TaskHotel

