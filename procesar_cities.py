import csv
  
# open input CSV file as source
# open output CSV file as result
with open("us_cities_full.csv",  "r") as source:
    reader = csv.reader(source, delimiter=";")
      
    with open("us_cities.csv", "w") as result:
        writer = csv.writer(result)
        for r in reader:
            
            # Use CSV Index to remove a column from CSV
            #r[3] = r['year']
            writer.writerow((r[0], r[1])) #r[6] es population