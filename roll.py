import random,time,keyboard

position=0
max=50
print('\033[1;33mWelcome to Dice.cli',end='\r''\nStarting...')
time.sleep(0.5)
print('\nlets get started')
print('\033[1;31mpress enter to roll')

def roll(position,max):
        while True:
                if keyboard.read_key('enter'):
                        roll_value=random.randint(1,6)
                        if position<max:
                                if roll_value==1:
                                        position+=1
                                        print(f'dice rolled to {roll_value}\nyou are at {position} now')
                                if roll_value==2:
                                        position+=2
                                        print(f'dice rolled to {roll_value}\nyou are at {position} now')
                                if roll_value==3:
                                        position+=3
                                        print(f'dice rolled to {roll_value}\nyou are at {position} now')
                                if roll_value==4:
                                        position+=4
                                        print(f'dice rolled to {roll_value}\nyou are at {position} now')
                                if roll_value==5:
                                        position+=5
                                        print(f'dice rolled to {roll_value}\nyou are at {position} now')
                                if roll_value==6:
                                        position+=6
                                        print(f'dice rolled to {roll_value}\nyou are at {position} now')
                                return roll(position,max)
                        if position==max:
                                        print(f'dice rolled to {roll_value}\nyou are at {position} now')
                                        print('\nYou won!!!')
                                        exit()
                        if position>max:
                                position-=roll_value
                                print(f'You are still at {position} now. kEEP ROLLING')
                        



roll(position,max)