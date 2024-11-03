import random

alpha=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']

def generate(alpha,digits):
    for i in range(0,digits):
        pw=''.join(random.choice(alpha))
        return pw
    
generate(alpha,8)