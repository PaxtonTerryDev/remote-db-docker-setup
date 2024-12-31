from parser import ConfigParser
from structures import Config


class Filebuilder:
    def __init__(self):
        self.parser = ConfigParser()
        
filebuilder = Filebuilder()
print(f"filebuilder config: ${filebuilder.parser.config}")