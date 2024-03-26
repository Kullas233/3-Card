# Program to print all combination
# of size r in an array of size n

# The main function that prints
# all combinations of size r in
# arr[] of size n. This function
# mainly uses combinationUtil()
global file
file = open("combs.txt","w") 

def printCombination(arr, n, r):
    data = [0]*r
    combinationUtil(arr, data, 0, n - 1, 0, r)

def combinationUtil(arr, data, start, end, index, r):
    if (index == r):
        file.write(str(data))
        file.write('\n')
        #print(data)
        #print()
        #for j in range(r):
        #    print(data[j], end = " ")
        return

    i = start
    while(i <= end and end - i + 1 >= r - index):
        data[index] = arr[i]
        combinationUtil(arr, data, i + 1, end, index + 1, r)
        i += 1

# Driver Code
#suits = ["S", "C", "D", "H"]
#values = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]

# cards = []
# for s in suits:
#     for v in values:  
#         card = str(v+s)
#         print(card)
#         cards += str(card)



arr = ["1S", "2S", "3S", "4S", "5S", "6S", "7S", "8S", "9S", "10S", "JS", "QS", "KS", "AS", "1C", "2C", "3C", "4C", "5C", "6C", "7C", "8C", "9C", "10C", "JC", "QC", "KC", "AC", "1D", "2D", "3D", "4D", "5D", "6D", "7D", "8D", "9D", "10D", "JD", "QD", "KD", "AD", "1H", "2H", "3H", "4H", "5H", "6H", "7H", "8H", "9H", "10H", "JH", "QH", "KH", "AH"]
r = 3
n = len(arr)
printCombination(arr, n, r)

# This code is contributed by mits