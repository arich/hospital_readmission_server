#!/usr/bin/python

import pandas as pd
import numpy as np

def plot_data(df):

    pass

def read_data(filename, filetype='csv'):

    if filetype == 'csv':
        df = pd.read_csv(filename,
                         sep=',',
                         header=0,
                         )
    else:
        df = pd.read_pickle(filename,
                            )

    return df

def write_data(filename, df):

    df.to_pickle(filename)

def crop_df(df):

    ''' Crop data to following columns:

    State name
    State abbrev
    Population

    '''

    df_crop = df[['NAME','POPESTIMATE2015']]

    # first five rows are regions, not states, remove them
    rows_to_remove = [0,1,2,3,4]
    df_crop = df_crop.drop(df_crop.index[rows_to_remove])

    return df_crop

def add_state_abbrev(df):

    ''' Adds state abbreviation column from full names

    '''

    import us
    import numpy as np

    # create an empty column with the same number of rows
    abbrevs = np.chararray(len(df['NAME']), itemsize=2)
    for i in xrange(len(abbrevs)):
        # get state name based on row number, convert to unicode
        name = df['NAME'].iloc[i].decode('utf-8')

        # add name abbreviation to array
        abbrevs[i] = us.states.lookup(name).abbr

    # assign the new column to the dataframe
    df['ABBREV'] = abbrevs

    return df

def main():
    PLOT = 0
    WRITE = 1

    # Filenames
    DIR_DATA = '../data/'
    DIR_DATA_PROD = '../data_products/'
    FILENAME_DATA = DIR_DATA + 'NST-EST2015-alldata.csv'
    FILENAME_REFORMATED = DIR_DATA + 'Reformatted_Census_Data.csv'

    df = pd.read_csv(FILENAME_DATA,
                  sep=',',
                  header=0,
                  #dtype=DTYPES,
                  #na_values={'Excess Readmission Ratio': 'Not Available',
                  #          },
                  #engine='c',
                    )

    # Attempt to coerce to numbers (including strings), with unconvertible
    # values becoming NaN.
    df = df.convert_objects(convert_numeric=True)

    # crop to just a few columns
    df_crop = crop_df(df)

    # rename POPESTIMATE2015
    df_crop = df_crop.rename(columns={'POPESTIMATE2015': 'POPULATION'})

    # add state abbreviations
    df_crop = add_state_abbrev(df_crop)

    # remove 'not-availables'
    #df = df.replace('Not Available', np.nan)

    df_crop.to_csv(FILENAME_REFORMATED, index=False)

    if PLOT:
        import matplotlib.pyplot as plt

        # Plot
        fig, ax = plt.subplots()

        df.boxplot(column='Excess Readmission Ratio', by='State', ax=ax)

        ax.margins(0.05) # Optional, just adds 5% padding to the autoscaling
        ax.legend()

        plt.show()


if __name__ == '__main__':
    main()
