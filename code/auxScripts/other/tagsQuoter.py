with open('../data/tagsFrequency70.txt', 'r', encoding='utf8') as f:
    with open('../data/tagsQuoted70.txt', 'w', encoding='utf8') as g:
        for line in f:
            parts = line.strip().split(';')
            formatString = ('"' + parts[0] + '";{}\n').format(parts[1])
            g.write(formatString)
