from multiprocessing import Process


def countWords(word):
    count = 0
    # descriptor de fichero calcular numero de palabras
    check = open('./data/cleaning/cleanWords1970.txt', 'r')
    for line in check:
        if word in line:
            for w in line.strip().split():
                if(word == w):
                    count += 1
    check.close()

    return count


def iterLoops(fr, to):
    with open('./data/cleaning/clean1970.txt', 'r') as origin:
        for num, line in enumerate(origin, 0):
            if(num > fr and num >= to):
                break
            if(num < fr):
                continue
            if(num >= fr and num < to):
                word = line.strip()
                print(word)
                count = countWords(word)

                with open('./data/articleFrequency70.txt', 'a') as result:
                    result.write(word + '\t' + str(count) + '\n')


def main():
    # descriptor de fichero para obtener palabras
    with open('./data/clean1970.txt', 'r') as fd:
        numLines = len(fd.readlines())

    part = numLines/4
    procs = []

    proc1 = Process(target=iterLoops, args=(0, part))
    proc2 = Process(target=iterLoops, args=(part, part*2))
    proc3 = Process(target=iterLoops, args=(part*2, part*3))
    proc4 = Process(target=iterLoops, args=(part*3, numLines))
    procs.append(proc1)
    procs.append(proc2)
    procs.append(proc3)
    procs.append(proc4)
    proc1.start()
    proc2.start()
    proc3.start()
    proc4.start()

    for proc in procs:
        proc.join()


if __name__ == '__main__':
    main()
