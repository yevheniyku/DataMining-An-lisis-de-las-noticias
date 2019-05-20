
class DuplicatesRemover:
    def __init__(self, decade):
        self.decade = decade

    def removeDuplicated():
        originFile      = '../../../data/cleaning/articleWordsList/{}.txt'.format(self.decade)
        destinationFile = '../../../data/cleaning/uniqueArticleWords/{}.txt'.format(self.decade)
        wordsList       = []

        with open(originFile, 'r') as origin:
            for line in origin:
                words = line.strip().split()
                for word in words:
                    if word not in wordList:
                        wordList.append(word)

        with open(destinyFile, 'a') as destination:
            for word in wordList:
                destination.write(word + '\n')
