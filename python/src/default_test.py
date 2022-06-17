import random

#
def extend_representation(rep, n_bits):
    if len(rep) > n_bits:
        print("error in representation")
        return
    while len(rep) != n_bits:
        rep = "0"+rep
    print(rep)

# generating "amount" random pixel values
def random_pixel_values(id, amount, max_pixel_value):
    randomlist = ""
    randomlist_integer = []
    for i in range(0, amount):
        n = random.randint(0, max_pixel_value)
        randomlist += str(n) +"\n"
        randomlist_integer.append(n)

    with open("default_list"+str(id)+".txt", 'w') as f:
        f.write(randomlist)

    return randomlist_integer

def SAD(PAs, PBs):

    if len(PAs) != len(PBs):
        return -1

    SAD_str = ""
    sad = 0
    for i in range (0, len(PAs)):
        diff = abs(PAs[i] - PBs[i])
        SAD_str += str(diff) +"\n"
        sad += diff

    # write the resulting vector sad on file
    with open("default_list_sad.txt", 'w') as f:
        f.write(SAD_str)
    return sad

def main():
    # default: images of 16x16 pixels = 256 pixels
    # default: monochrome [0, 255] pixel
    amount = 256
    max_pixel_value = 255

    # generating PAs and PBs random values
    PAs = random_pixel_values(1, amount, max_pixel_value)
    PBs = random_pixel_values(2, amount, max_pixel_value)

    # calculating the result of SAD
    sad = SAD(PAs, PBs)

    if sad == -1:
        print("sad not generated correctly")
    else:
        print("sad generated correctly: "+str(sad))

    prova = bin(256).split('b')[1]
    print(prova)
    extend_representation(prova, 9)






if __name__ == "__main__":
    main()