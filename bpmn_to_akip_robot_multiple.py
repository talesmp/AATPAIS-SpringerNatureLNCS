import os
import time
import glob   # `find_files_with_extension` fuctinon
import bpmn_to_akip_robot_single as b2ar

# [General] Finding Files with Extension
def find_files_with_extension(directory, extension):
    return glob.glob(f"{directory}/*.{extension}")

current_directory = os.getcwd().replace('\\', '/')

assessment_process_models_path = current_directory+'/AssessmentProcessModels/'

times_spent = []

for apmf in os.listdir(assessment_process_models_path):
  if apmf not in ['uncovered-process-models', 'unused-backup-process-models']:
    start_time = time.time()
    process_folder_name = apmf
    # print('Processing: '+process_folder_name)
    process_folder_path = assessment_process_models_path+apmf+'/'
    bpmn_path = find_files_with_extension(process_folder_path, 'bpmn')[0].replace('\\', '/')
    executed_kw_json_path = process_folder_path+'executedKeywords-'+process_folder_name+'.json'
    b2ar.process_folder_function(apmf, current_directory)
    end_time = time.time()
    time_spent = end_time - start_time
    times_spent.append((process_folder_name, time_spent))

for name, time in times_spent:
    print(f'{name} : {time}')