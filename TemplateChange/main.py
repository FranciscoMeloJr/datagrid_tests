import csv

#Function to read values
def read_values(d_print=False):
  with open('variable_template.csv') as csv_file:
      dict_replace_values = []
      csv_reader = csv.reader(csv_file, delimiter=',')
      line_count = 0
      for row in csv_reader:
          if line_count == 0:
              line_count += 1
          else:
              dict_replace_values.append([row[0], row[1]])
              line_count += 1
      
  if d_print:
    print(f'Processed {line_count} lines.')
  return dict_replace_values

def replace_values(dict_replace_values):
  FileName = "../hotrodspringboot/src/main/resources/"
  for i in range(len(dict_replace_values)):
    a= dict_replace_values[i][0]
    b= dict_replace_values[i][1]
    with open(FileName) as f:
      newText=f.read().replace(a, b)
    with open(FileName, "w") as f:
      f.write(newText)
  
dict_replace_values = read_values()
replace_values(dict_replace_values)