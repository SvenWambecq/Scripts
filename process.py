#!/usr/bin/env python


import PIL
from PIL import Image 
from PIL import ImageFilter 
import os
import sys
import logging

logger = logging.getLogger('Image')
logger.addHandler(logging.StreamHandler())
logger.setLevel(logging.INFO)


def getJpgFiles() : 
    cwd = os.getcwd()
    files = os.listdir(cwd)    
    return [file for file in files if file.endswith('.jpg') or file.endswith('.JPG')]
    
def resize(image) : 
    
    if image.size[0] > 3000 or image.size[1] > 3000 : 
        if image.size[0] > image.size[1] :
            maxSize = float(image.size[0]) 
        else :
            maxSize = float(image.size[1])   
        logger.info('Maximal size = %i' % maxSize)     
        newSize0 = int(image.size[0] * (3000 / maxSize))
        newSize1 = int(image.size[1] * (3000 / maxSize))
        logger.info('Resizing image to (%i, %i)' % (newSize0, newSize1))
        return image.resize((newSize0, newSize1))
    else : 
        return image.copy()
    
def processFiles() : 
    
    for file in getJpgFiles() : 
        im = Image.open(file)    
        logger.info('Resizing %s' % file)
        im = resize(im) 
        im.save('resized_%s' % file)
        


if __name__ == '__main__' : 
    processFiles()        