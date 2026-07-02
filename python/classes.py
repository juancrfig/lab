# A class is a blueprint
class Dog:
    # The __init__ function is a constructor. It runs when the class is instantiated
    # 'self' is a reserved word used to refer to the very same instance that is being created
    def __init__(self, name: str, age: int)
        self.name = name
        self.age = age

    # Method
    def bark(self):
        return f"{self.name} says Woof!"


dog_one = Dog("Gamora", 5)
dog_two = Dog("Bellota", 10)
