"""Cuts the BanglaDigits fonts (assets/fonts) from Anek Bangla (SIL OFL).
Usage: python3 tool/build_bangla_digits.py AnekBangla[wdth,wght].ttf assets/fonts
Needs: pip install fonttools"""
import sys
from fontTools.ttLib import TTFont
from fontTools.varLib.instancer import instantiateVariableFont
from fontTools import subset
src=sys.argv[1]; out=sys.argv[2]
for w in (400,500,600,700):
    f=TTFont(src)
    f=instantiateVariableFont(f,{'wght':w,'wdth':100})
    s=subset.Subsetter(subset.Options())
    s.populate(unicodes=list(range(0x09E6,0x09F0))+[ord(':')])
    s.subset(f)
    for r in f['name'].names:
        if r.nameID in (1,16): r.string='BanglaDigits'
    f.save(f'{out}/BanglaDigits-{w}.ttf')
