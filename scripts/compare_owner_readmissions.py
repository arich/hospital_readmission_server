#!/usr/bin/python

import pandas as pd
import numpy as np
import os

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

def load_hosp_data(filename):

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

    df = pd.read_csv(filename,
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
    df["Start Date"] = pd.to_datetime(
        df["Start Date"]
        )
    df["End Date"] = pd.to_datetime(
        df["End Date"]
        )

    # remove 'not-availables'
    df = df.replace('Not Available', np.nan)

    return df

def load_pop_data(filename):

    df = pd.read_csv(filename,
                  sep=',',
                  header=0,
                  #dtype=DTYPES,
                  #na_values={'Excess Readmission Ratio': 'Not Available',
                  #          },
                  #engine='c',
                    )

    # Attempt to coerce to numbers (including strings), with unconvertible
    # values becoming NaN.
    #df = df.convert_objects(convert_numeric=True)

    # remove 'not-availables'
    #df = df.replace('Not Available', np.nan)

    return df

def write_data(filename, df):

    df.to_pickle(filename)

    # what?


def plot_readmission_vs_population(df_hosp, df_gen, filename, show=False):

    import matplotlib.pyplot as plt
    import us
    import scipy.stats

    # Plot
    fig, ax = plt.subplots()

    # get the readmission ratio

    # convert state abbreviations to names
    states = df_hosp['State'].unique()
    y = np.empty(len(states), dtype=float)
    x = np.empty(len(states), dtype=float)
    for i in xrange(len(y)):
        state_name = us.states.lookup(states[i]).name
        index = df_gen[df_gen['NAME'] == state_name].index.tolist()
        x[i] = df_gen['POPESTIMATE2015'][index].values[0]

        index = df_hosp[df_hosp['State'] == states[i]].index.tolist()
        median = scipy.stats.nanmedian(df_hosp['Excess Readmission Ratio'][index].values)
        y[i] = median

        ax.annotate(states[i],xy=(x[i]/1e6,y[i],), xycoords='data',)

    x = x / 1e6
    #ax.scatter(x,y,)
    #ax.margins(0.05) # Optional, just adds 5% padding to the autoscaling
    ax.set_xlabel('Population [1,000,000]')
    ax.set_ylabel('Excess Readmission Ratio')
    x_scalar = np.max(x) * 0.1
    ax.set_xlim([np.min(x)-x_scalar, np.max(x)+x_scalar])
    y_scalar = np.max(y) * 0.1
    ax.set_ylim([np.min(y)-y_scalar, np.max(y)+y_scalar])
    ax.legend()

    plt.savefig(filename, dpi=100)
    if show:
        plt.show()

def merge_owner_to_hosp(df_hosp, df_gen):

    df = pd.merge(df_gen, df_hosp, how='right', on=['Provider Number',])

    return df

def main():

    PLOT = 1
    WRITE = 1

    # Filenames
    DIR_DATA = '../data/'
    DIR_DATA_PROD = '../data_products/'
    DIR_PLOTS = '../plots/'
    FILENAME_DATA_HOSP = DIR_DATA + 'Reformatted_Hospital_Data.csv'
    FILENAME_DATA_OWNER = DIR_DATA + 'Reformatted_Provider_Data.csv'
    FILENAME_PLOT_READ_VS_OWNER = DIR_PLOTS + 'readmission_vs_owner'

    # Hospital Name,
    # Provider Number,
    # State,
    # Measure Name,Number of
    # Discharges,Footnote,Excess Readmission Ratio,Predicted Readmission
    # Rate,Expected Readmission Rate,Number of Readmissions,Start Date,End Date

    df_hosp = load_hosp_data(FILENAME_DATA_HOSP)
    df_gen = load_pop_data(FILENAME_DATA_OWNER)

    # merge tables on Provider Number
    df = merge_owner_to_hosp(df_hosp, df_gen)

    print('Number of unique hospitals in readmissions table:')
    print(np.size(np.unique(df_hosp['Provider Number'].values)))
    print('')
    print('Number of readmissions rows not in contact table:')
    print(len(df_hosp) - len(df))

    if PLOT:
        show = True
        import matplotlib.pyplot as plt

        if 0:
            plot_readmission_vs_population(df_hosp,
                                           df_gen,
                                           FILENAME_PLOT_READ_VS_OWNER,
                                           show=show)

        # Plot Readmission ratio box plot with state
        fig, ax = plt.subplots(figsize=(15,4))
        df.boxplot(column='Excess Readmission Ratio',
                        by='Hospital Ownership', ax=ax)
        ax.margins(0.05) # Optional, just adds 5% padding to the autoscaling
        plt.savefig(FILENAME_PLOT_READ_VS_OWNER, dpi=100)
        if show:
            plt.show()


if __name__ == '__main__':
    main()

