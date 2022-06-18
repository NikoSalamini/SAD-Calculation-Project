
# load the simulated sad and extract data
def load_simulated_sad():
    with open("./../../SAD_Project_Files/tb/test/list.txt", 'r') as f:
        sim_sad = f.readlines()

    #reading only the odd lines
    sim_sad = [v for i, v in enumerate(sim_sad) if i % 2 != 0]

    #dropping element 0, 1 and last
    sim_sad = sim_sad[2:]
    sim_sad = sim_sad[:-1]

    #extract the value from each line and convert it to an integer
    for i in range(0, len(sim_sad)):
        sim_sad[i] = sim_sad[i].split(" ")[1].replace("\n", "")
        sim_sad[i] = int(sim_sad[i], 2)

    #extract the value of sad from the line and then convert it to an integer
    return sim_sad

# load real sad
def load_real_sad():
    with open("./../../SAD_Project_Files/tb/test/default_list_sad.txt", 'r') as f:
        real_sad = f.readlines()
    for i in range(0, len(real_sad)):
        real_sad[i] = int(real_sad[i])
    return real_sad

# calculate the error on the 2 list, return 0 if not ok, 1 if ok
def check_error(i1, i2):
    if len(i1) != len(i2):
        print("error")
        return False

    for i in range(0, len(i1)):
        if (i1[i] - i2[i]) != 0:
            return False

    return True

def main():
    sim_sad = load_simulated_sad()
    real_sad = load_real_sad()

    print(real_sad)
    print(sim_sad)

    if  check_error(sim_sad, real_sad):
        print("no errors, simulation success")
    else:
        print("errors, simulation failure")

if __name__ == "__main__":
    main()