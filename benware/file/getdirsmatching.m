function data = getdirsmatching(searchstring)

data = getfilesmatching(searchstring, 'isdir==true');
