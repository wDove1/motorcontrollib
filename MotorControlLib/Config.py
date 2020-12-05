import json
class Config:
    



    def getMeasuredData(self,path):
        return json.loads(open(path))


