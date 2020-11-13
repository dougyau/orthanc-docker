import json
import os
from ast import literal_eval

CONFIG_FOLDER = 'orthanc'
config = {}


def set_value(data, key, value):
    c = key.pop(0)
    if c in data:
        if len(key) == 0:
            data[c] = value
        else:
            data[c] = set_value(data[c], key, value)
    return data


with os.scandir(CONFIG_FOLDER) as entries:
    for entry in entries:
        if entry.name.endswith('.json'):
            with open('{}/{}'.format(CONFIG_FOLDER, entry.name)) as file:
                data = json.load(file)
                if entry.name == 'orthanc.json':
                    config = { **config, **data }
                else:
                    config[list(data.keys())[0]] = list(data.values())[0]

for c_key in os.environ.keys():
    if c_key.startswith('config.'):
        config = set_value(config, c_key[7:].split('.'), literal_eval(os.environ.get(c_key).strip()))

print(json.dumps(config, sort_keys=True, indent=2))
