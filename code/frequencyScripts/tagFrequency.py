from multiprocessing import Process

def countTags(tag):
    count = 0
    # descriptor de fichero calcular numero de palabras
    check = open('./data/cleaning/tagsList00.txt', 'r', encoding='utf8')
    for line in check:
        t = line.strip()
        if(t == tag):
            count += 1
    check.close()

    return count


def iterLoops(fr, to):
    with open('./data/uniqTags00.txt', 'r', encoding='utf8') as origin:
        for num, line in enumerate(origin, 0):
            if(num > fr and num >= to):
                break
            if(num < fr):
                continue
            if(num >= fr and num < to):
                tag = line.strip()
                count = countTags(tag)

                with open('./data/tagsFrequency00.txt', 'a', encoding='utf8') as result:
                    result.write(tag + ';' + str(count) + '\n')


def main():
    # descriptor de fichero para obtener palabras
    with open('./data/cleaning/tagsList00.txt', 'r', encoding='utf8') as fd:
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
