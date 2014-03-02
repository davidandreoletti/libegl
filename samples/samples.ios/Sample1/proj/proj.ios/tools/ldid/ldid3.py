#!/usr/bin/env python
 
from sys import argv
from subprocess import check_call
from os.path import basename, dirname, splitext, join
from tempfile import NamedTemporaryFile
 
app = argv[-1]
ldid_path = join(dirname(__file__), 'ldid')
obj_path = join(app, splitext(basename(app))[0])
 
if '-gta' not in argv:
    check_call([ldid_path, '-S', obj_path])
else:
    with NamedTemporaryFile('w+b', 0) as f:
        f.write("""
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>get-task-allow</key>
    <true/>
  </dict>
</plist>
        """)
	f.flush()
        check_call([ldid_path, '-S' + f.name, obj_path])
