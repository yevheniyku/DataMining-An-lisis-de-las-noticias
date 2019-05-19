import pandas as pd
import csv

df = pd.read_csv('../data/tagsQuoted70.txt', sep=';', header=None, quoting=csv.QUOTE_NONE)
df.sort_values(by=[1], ascending=False, inplace=True)
df.to_csv('../data/tags70.txt', sep=';', header=None, index=False, quoting=csv.QUOTE_NONE)
