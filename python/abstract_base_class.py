from abc import ABC, abstractmethod

# abc is a blueprint for other blueprints. Abstract classes cannot be instantiated

class Animal(ABC):

    @abstractmethod
    def make_sound(self):
        # No code because we only care about stating that any class than implements the abstract class Animal should have a make_sound method
        pass 

    # Abstract classes are allowed to have concrete methods, which are prewritten snippets we want classes, implementing Animal blueprint, have
    def sleep(self):
        return "Zzz..."


class Cat(Animal):
    def say_hi(self):
        print("Hi!")

    def make_sound(self):
        pass

cat = Cat()
cat.say_hi()
