import random

alpha=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']

pos_x=0
pos_y=0

def generate(alpha,digits):
     for i in range(digits):
        password=''.join(random.choice(alpha))
        with open('passwords.txt','a') as f:
            for i in range(10):
                f.write(f'\n{password}')
            return password

lebel='THIS TEXT FILE IS AUTOMATICALLY GENERATED BY A PYTHON SCRIPT'

print(f'\033[3mGenerating passwords...')
open('passwords.txt','a').write('')
f=open('passwords.txt','r')
f.seek(0)
if lebel not in f.read():
    print('\033[3mlebel is being regenerated')
    open('passwords.txt','a').write(f'{lebel}\n')
else:
    print('\033[3mlebel is found')
generate(alpha,8)

print('\033[1;33msuccessfully generated!!!')
print('\033[3mA text file has been generated containing all the passwords\n')
exit()

'''
print(random.sample(file,8))
print(random.choices(file, k=8))
'''