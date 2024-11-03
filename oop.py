class Dog:
    species='Canis Lupus Famileries'
    def __init__(self,name,age,color):
        self.name=name
        self.age=age
        self.color=color

    def bark(self):
        return f'{self.name} says woof'
    
dog1=Dog('B2',10,'black')
dog1.bark()
print(dog1.bark())