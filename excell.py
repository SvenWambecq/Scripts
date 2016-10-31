from win32com.client import Dispatch
import os

class Excell(object):
    
    def __init__(self, comObject):
        self.com = comObject
        
    def __del__(self):
        self.close()
        
    def __getattr__(self, attr):
        return getattr(self.com, attr)
    
    def getSheet(self, name):
        return Sheet(self.com.Sheets(name))
    
    @classmethod
    def open(cls, filename):
        app = Dispatch("Excel.Application")
        return cls(app.Workbooks.Open(filename))
    
    def close(self):
        self.com.Close(SaveChanges=False)
        
class Sheet(object):
    
    def __init__(self, comObject, attribute='Value'):
        self.com = comObject
        self.attribute = attribute
        
    @property
    def formulas(self):
        return Sheet(self.com, attribute='Formula')
    
    @property
    def values(self):
        return Sheet(self.com, attribute='Value')
        
    def getRange(self, index):
        return self.com.Range(index)

    def getCell(self, column, row):
        return self.com.Cells(column, row)
        
    def __getitem__(self, index):
        return getattr(self.getRange(index), self.attribute)
    
    def __setitem__(self, index, value, formula=False):
        setattr(self.getRange(index), self.attribute, value)
        
