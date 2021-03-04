from Rhino import *
from Rhino.DocObjects import *
from Rhino.Input import *
from Rhino.Input.Custom import *
from Rhino.Commands import *

def RunCommand():
    rc, obj_refs = RhinoGet.GetMultipleObjects("Select mesh objects to contour", False, ObjectType.Mesh)
    if rc != Result.Success:
        return rc
    print(len(obj_refs))
    if len(obj_refs) < 2:
        print("not enough meshes")
    print(obj_refs)

if __name__ == "__main__":
    RunCommand()