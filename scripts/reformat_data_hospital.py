#!/usr/bin/python

import pandas as pd
import numpy as np
import os

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

    # what?

def main():
    PLOT = 0
    WRITE = 1

    # Filenames
    DIR_DATA = '../data/'
    DIR_DATA_PROD = '../data_products/'
    FILENAME_DATA = DIR_DATA + 'Hospital_Readmissions_Reduction_Program.csv'
    FILENAME_REFORMATED = DIR_DATA + 'Reformatted_Hospital_Data.csv'

    # Hospital Name,
    # Provider Number,
    # State,
    # Measure Name,Number of
    # Discharges,Footnote,Excess Readmission Ratio,Predicted Readmission
    # Rate,Expected Readmission Rate,Number of Readmissions,Start Date,End Date

    DTYPES={'Hospital Name': str, #
            'Provider Number': int, #
            'State': str, #
            'Measure Name': str, #
            'Number of Discharges': int, #
            'Footnote': str, #
            'Excess Readmission Ratio': np.float64, #
            'Predicted Readmission Ratio': np.float64, #
            'Expected Readmission Rate': np.float64, #
            'Number of Readmissions': int, #
            'Start Date': str, #
            'End Date': str, #
            }

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

    # Reformat data times
    df["Start Date"] = pd.to_datetime(
                                      df["Start Date"],
                                      format='%m/%d/%Y',
                                      )
    df["End Date"] = pd.to_datetime(
                                    df["End Date"],
                                    format='%m/%d/%Y',
                                    )

    # remove 'not-availables'
    df = df.replace('Not Available', np.nan)

    # convert NaNs in int array to -1
    # http://pandas.pydata.org/pandas-docs/stable/gotchas.html#na-type-promotions
    columns = ['Number of Discharges',
               'Provider Number',
               'Number of Readmissions',
               ]
    for column in columns:
        indices = np.isnan(df[column].values)
        df[column][indices] = -1
        df[column] = df[column].astype(int)

    df.to_csv(FILENAME_REFORMATED,
              index=False,
              date_format='%Y-%m-%d',
              )

    print('copy ' + FILENAME_REFORMATED + ' to /usr/share/ with:')
    print("sudo cp " + FILENAME_REFORMATED + ' /usr/share/.')

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
