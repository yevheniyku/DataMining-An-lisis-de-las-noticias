import pandas as pd

with open('../data/articleFrequency90.txt', 'r') as f:
    with open('../data/1990.txt', 'w') as g:
        for line in f:
            if (len(line.split()) > 1):
                if(int(line.strip().split('\t')[1]) > 100):
                    g.write(line)

df = pd.read_csv('../data/1990.txt', sep='\t', header=None)
df.sort_values(by=[1], ascending=False, inplace=True)
df.to_csv('../data/1990.txt', sep='\t', header=None, index=False)
