#!/bin/bash

get_name (){

echo $(python -c 'import json; print json.load(open("'$1'package.json"))["name"]')
}

setup_submodule (){
    for dep in $(cat test/dep_modules.txt); do
        mname=$(basename $dep | sed 's/.git//g')
        echo "Cloning $dep into $mname .."
        git clone $dep ~/$mname
        rmname=$(get_name ~/$mname/)
        cp -r  ~/$mname/module ~/shinken/modules/$rmname
        [ -f ~/$mname/requirements.txt ] && pip install -r ~/$mname/requirements.txt
    done
    # we need the livestatus test files to be in shinken test dir:
    cp -r ~/mod-livestatus/test/* ~/shinken/test/
}

name=$(get_name)

pip install pycurl
pip install coveralls
pip install importlib # this is a requirement of shinken itself
git clone https://github.com/naparuba/shinken.git ~/shinken
[ -f test/dep_modules.txt ] && setup_submodule
[ -f requirements.txt ] && pip install -r requirements.txt
[ -f test/requirements.txt ] && pip install -r test/requirements.txt
rm ~/shinken/test/test_*.py
cp test/test_*.py ~/shinken/test/
[ -d test/etc ] && cp -r test/etc ~/shinken/test/
cp -r module ~/shinken/modules/$name
ln -sf ~/shinken/modules ~/shinken/test/modules
#cd ~/shinken


