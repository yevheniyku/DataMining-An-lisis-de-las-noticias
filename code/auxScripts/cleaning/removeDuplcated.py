wordList = []

def iterLoops(origin):
    global wordList

    for line in origin:
        words = line.split()
        for word in words:
            #removeDuplicated(word)
            if word not in wordList:
                wordList.append(word)

    with open('../data/clean1970.txt', 'a') as f:
        for word in wordList:
            f.write(word + '\n')


def main():
    fd = open('../data/cleanWords1970.txt', 'r')

    iterLoops(fd)

    fd.close()

if __name__ == '__main__':
    main()
