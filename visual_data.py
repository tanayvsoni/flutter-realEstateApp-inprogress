import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker
import numpy as np

def random_house_price(data):
    
    residential_data = data[data['Assessment Class 1'] == 'RESIDENTIAL']
    
    random_account = np.random.choice(residential_data['Account Number'].unique())
    lat, lon, house_number, street_name = data.loc[data['Account Number'] == random_account, ['Latitude', 'Longitude', 'House Number', 'Street Name']].values[0]
    
    # Find all other rows with the same latitude, longitude, house number, and street name
    if pd.isna(data.loc[data['Account Number'] == random_account, 'Suite'].values[0]):
        
        matching_rows = data.loc[
            (data['Latitude'] == lat) & 
            (data['Longitude'] == lon) &
            (data['House Number'] == house_number) &
            (data['Street Name'] == street_name)
            
        ]
    else: 
        matching_rows = data.loc[
            (data['Latitude'] == lat) & 
            (data['Longitude'] == lon) &
            (data['House Number'] == house_number) &
            (data['Street Name'] == street_name) & 
            (data['Suite'] == data.loc[data['Account Number'] == random_account, 'Suite'].values[0])
        ]
    
    matching_rows = matching_rows.sort_values('Assessment Year')
    
    print(f"{matching_rows['Latitude'].unique().tolist()[0]},{matching_rows['Longitude'].unique().tolist()[0]}")
    print(matching_rows['Suite'].unique())
    
    # Calculate the percentage change in 'Assessed Value' from the oldest to the most recent year
    oldest_value = matching_rows['Assessed Value'].iloc[0]
    most_recent_value = matching_rows['Assessed Value'].iloc[-1]
    percent_change = (most_recent_value - oldest_value) / abs(oldest_value) * 100
    
    
    plt.plot(matching_rows['Assessment Year'], matching_rows['Assessed Value'])
    plt.xlabel('Assessment Year')
    plt.ylabel('Assessed Value')
    plt.title(f'Assessed Value Over Time for Latitude: {lat}, Longitude: {lon}')
    plt.grid(True)
    
    plt.text(0.5, 0.9, f'Neighbourhood: {matching_rows["Neighbourhood"].iloc[0]}', transform=plt.gca().transAxes)
    plt.text(0.5, 0.85, f'Latitude: {matching_rows["Latitude"].iloc[0]}', transform=plt.gca().transAxes)
    plt.text(0.5, 0.8, f'Longitude: {matching_rows["Longitude"].iloc[0]}', transform=plt.gca().transAxes)
    plt.text(0.5, 0.75, f'Percentage Change: {percent_change:.2f}%', transform=plt.gca().transAxes)

    plt.gca().get_yaxis().set_major_formatter(mticker.FuncFormatter(lambda x, p: format(int(x), ',')))

    plt.show()
    
def temp(data):
    # Filter data to include only residential properties with a garage
    # residential_data_with_garage = data[(data['Assessment Class 1'] == 'RESIDENTIAL') & (data['Garage'] == 'Y')]
    residential_data_with_garage = data[(data['Assessment Class 1'] == 'RESIDENTIAL')]
    
    # Group data by 'Assessment Year' and calculate the average 'Assessed Value' for each year
    average_values_by_year = residential_data_with_garage.groupby('Assessment Year')['Assessed Value'].mean().reset_index()
    
    
    # Calculate the percentage change in 'Assessed Value' from the oldest to the most recent year
    oldest_value = average_values_by_year['Assessed Value'].iloc[0]
    most_recent_value = average_values_by_year['Assessed Value'].iloc[-1]
    percent_change = (most_recent_value - oldest_value) / abs(oldest_value) * 100
    
    # Plot the average assessed values over time as a line graph
    plt.plot(average_values_by_year['Assessment Year'], average_values_by_year['Assessed Value'])
    plt.xlabel('Assessment Year')
    plt.ylabel('Average Assessed Value')
    plt.title('Average Assessed Value Over Time for Residential Properties with a Garage')
    plt.text(0.5, 0.75, f'Percentage Change: {percent_change:.2f}%', transform=plt.gca().transAxes)
    plt.grid(True)

    # Disable scientific notation for large numbers
    plt.gca().get_yaxis().set_major_formatter(mticker.FuncFormatter(lambda x, p: format(int(x), ',')))
    
    plt.show()
    
def my_house(data):
    
    # matching_rows = data.loc[
        # (data['House Number'] == 3560) & 
        # (data['Street Name'] == '13 STREET NW')
    # ] 
    
    # Specify the legal description you want to match
    target_legal_description = "Plan: 0726190  Block: 9  Lot: 14"

    # Use str.contains() to filter rows with the target legal description
    matching_rows = data[data['Legal Description'].str.contains(target_legal_description, na=False)]
    
    matching_rows = matching_rows.sort_values('Assessment Year')
    
    print(matching_rows)

    
def main():
    data = pd.read_csv('./data/Property_Assessment_Data__Historical_.csv', low_memory=False)
    my_house(data)
    

if __name__ == '__main__':
    main()
    