import rhinoscriptsyntax as rs
import Rhino as R

#https://developer.rhino3d.com/api/RhinoScriptSyntax/#selection-ObjectsByType
CURVE_TYPE = 4;

#TODO
#Prompt for selection of two meshes
#Go through countour line process, assert that its on axis along foot length
#Delete extraneous open curves
def odds(xs):
    return [val for (idx, val) in enumerate(xs) if idx % 2 == 1]

def evens(xs):
    return [val for (idx, val) in enumerate(xs) if idx % 2 == 0]

def pairs(xs):
    return zip(odds(xs), evens(xs))

diffs = []
curves = [ o for o in rs.VisibleObjects() if rs.ObjectType(o) == CURVE_TYPE]

#TODO
#Its probably just easier to only pair things that are close on the axis and similar in size
#to get around the open curve issue

for (odd, even) in pairs(curves):
    odd_len = rs.CurveLength(odd)
    even_len = rs.CurveLength(even)
    diff = abs(odd_len - even_len)
    diffs.append(abs(rs.CurveLength(odd) - rs.CurveLength(even)))
    
    print("Abs Difference %f" % (diff))
    #print("Odd Curve: %f, Even Curve: %f, Abs Difference %f" % (odd_len, even_len, diff))
    #print("Diff percent of Odd Curve: %f, Diff percent of Even Curve:%f" % (100.0* (diff/odd_len), 100.0* (diff/even_len)))

diffs_mean = sum(diffs)/len(diffs)
print("\nAbs Difference Mean: %f" % diffs_mean)
print("Min %f, Max %f" % (min(diffs), max(diffs)))