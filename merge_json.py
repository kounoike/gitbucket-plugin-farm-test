#!/usr/bin/evn python
# coding: utf-8

import json
import glob

merged = []

for fn in glob.glob("json/*.json"):
    with open(fn) as f:
        merged.append(json.load(f))

with open("dist/plugins.json", "w", encoding="utf-8") as f:
    json.dump(f)