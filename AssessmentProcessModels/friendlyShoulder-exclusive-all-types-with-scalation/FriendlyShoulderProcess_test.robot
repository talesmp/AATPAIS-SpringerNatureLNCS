# Prompt Command to Execute the BlindBatch : 
# robot -i TC_BlindBatch FriendlyShoulderProcess_test.robot
*** Settings ***
Library    FakerLibrary    #locale=pt_BR 
Library    OperatingSystem 
Library    Collections 
Library    DateTime 
Resource    FriendlyShoulderProcess_resources.robot
Test Setup    kwFakerDataSetup

*** Variables ***
@{TaskNames}    TaskAnalyseComplaint  TaskReviewEscalation  TaskAcknowledge

*** Test Cases ***
TC_BlindBatch
    ${kw_executed}=    Create List
    kwFakerDataSetup
    kwLogin
    ${start_time}=    Get Time    epoch
    FOR    ${i}    IN RANGE    30
        ${inner_list}=    Create List
        kwFakerDataSetup
        kwRequestForm
        Append To List    ${inner_list}    Start of Execution #${i}
        Append to List    ${inner_list}    RequestForm
        WHILE    $processRunning == True
            kwFindFirstAvailableTask
            IF    $found_task == "TaskAnalyseComplaint"
                kwFakerDataSetup
                kwTaskAnalyseComplaint
                Append To List    ${inner_list}    TaskAnalyseComplaint
            ELSE IF    $found_task == "TaskReviewEscalation"
                kwFakerDataSetup
                kwTaskReviewEscalation
                Append To List    ${inner_list}    TaskReviewEscalation
            ELSE IF    $found_task == "TaskAcknowledge"
                kwFakerDataSetup
                kwTaskAcknowledge
                Append To List    ${inner_list}    TaskAcknowledge
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
    Create File    C:/Users/tales/LocalDocuments/Development/aat4pais/AssessmentProcessModels/friendlyShoulder-exclusive-all-types-with-scalation/executedKeywords-friendlyShoulder-exclusive-all-types-with-scalation.json    ${json_string} 
    ${data}=    Evaluate    json.loads(open("C:/Users/tales/LocalDocuments/Development/aat4pais/AssessmentProcessModels/friendlyShoulder-exclusive-all-types-with-scalation/executedKeywords-friendlyShoulder-exclusive-all-types-with-scalation.json").read()) 
    ${execution_paths}=    Evaluate    [' => '.join(execution[1:-1]) for execution in $data] 
    ${execution_counts}=    Evaluate    dict(collections.Counter($execution_paths))    modules=collections 
    ${output}=  Evaluate  "{} executions of FriendlyShoulderProcess in {} seconds\\n".format(len($data), ${time_spent}) + '\\n'.join(["{} executions: {}".format(count, path) for path, count in $execution_counts.items()]) 
    Create File    C:/Users/tales/LocalDocuments/Development/aat4pais/AssessmentProcessModels/friendlyShoulder-exclusive-all-types-with-scalation/executionsCounter-friendlyShoulder-exclusive-all-types-with-scalation.txt    ${output} 

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
    ${faker-log}    FakerLibrary.Boolean
    Set Test Variable    ${faker-log}
    ${faker-gravity}    FakerLibrary.Random Int  min=1  max=10
    Set Test Variable    ${faker-gravity}
    ${faker-date}    FakerLibrary.Date
    Set Test Variable    ${faker-date}
    ${faker-description}    FakerLibrary.Sentence  nb_words=8
    Set Test Variable    ${faker-description}
    ${faker-response}    FakerLibrary.Sentence  nb_words=8
    Set Test Variable    ${faker-response}
    ${processRunning}=    Set Variable    ${True}
    Set Test Variable    ${processRunning}

kwLogin
    [Arguments]  
    [Documentation]  
    The user logs in

kwMyTasks
    [Arguments]  
    [Documentation]  
    The user is in MyTasks

kwRequestForm
    [Arguments]  
    [Documentation]  
    The user is in RequestForm
    The user fills RequestForm
    The user submits RequestForm

kwTaskAnalyseComplaint
    [Arguments]  
    [Documentation]  
    The user is in TaskAnalyseComplaint
    The user fills TaskAnalyseComplaint
    The user submits TaskAnalyseComplaint

kwTaskReviewEscalation
    [Arguments]  
    [Documentation]  
    The user is in TaskReviewEscalation
    The user fills TaskReviewEscalation
    The user submits TaskReviewEscalation

kwTaskAcknowledge
    [Arguments]  
    [Documentation]  
    The user is in TaskAcknowledge
    The user fills TaskAcknowledge
    The user submits TaskAcknowledge

