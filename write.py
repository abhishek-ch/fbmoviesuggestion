#!/usr/bin/env python
#coding: utf8 
import os
import unicodedata 

def test_ascii(struni):
	strasc=unicodedata.normalize('NFD', struni).encode('ascii','replace')
	if len(struni)==len(strasc): 
		return True
	else:
		return False 

val = "Rë█_Rajkumar"
nor = val.decode('utf8')
print test_ascii(u"abcdÃª") 
print test_ascii(nor)
print test_ascii(u"Rajkumar")
