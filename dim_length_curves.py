import rhinoscriptsyntax as rs
import Rhino as R

def odds(xs):
    return [val for (idx, val) in enumerate(xs) if idx % 2 == 1]

def evens(xs):
    return [val for (idx, val) in enumerate(xs) if idx % 2 == 0]

def pairs(xs):
    return zip(odds(xs), evens(xs))

diffs = []
curves = rs.ObjectsByType(4)

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