import math
x = float('nan')
math.isnan(x)
True
f = open("lista.txt", "r")
l = []

for x in f:
    s = x.split(" ")
    if(len(s)>1):
        a =''
        for k in s:
            a+= k.strip() + " "
        l.append(a+"\n")
""" for x in f:
    s = x.split(" ")
    #print(s)
    if(len(s)>1):
        for el in range(len(s)):
            if(el ==)
            l.append(el.strip())
    for el in s:
        el = float(str(el))
        if(math.isnan(el)):
            print(el)
        if(el[0] =='('):
            l.append(el[1:len(el) -3])"""
print(l) 
f = open("lis.txt", "a")
for h in l:

    f.write(h)
f.close()