#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SERVICE_NAME=$(basename $SCRIPT_DIR)

# set permissions for script files
chmod a+x $SCRIPT_DIR/restart.sh
chmod 744 $SCRIPT_DIR/restart.sh

chmod a+x $SCRIPT_DIR/uninstall.sh
chmod 744 $SCRIPT_DIR/uninstall.sh

chmod a+x $SCRIPT_DIR/service/run
chmod 755 $SCRIPT_DIR/service/run

wget -c -O pyserial-3.5-py2.py3-none-any.whl https://files.pythonhosted.org/packages/07/bc/587a445451b253b285629263eb51c2d8e9bcea4fc97826266d186f96f558/pyserial-3.5-py2.py3-none-any.whl
wget -c -O uModbus-1.0.4-py2.py3-none-any.whl https://files.pythonhosted.org/packages/d1/b9/664b226d34cc5154dfd0f92ccfaa6cb03dd3d2f77951c0d67eedb74ace5b/uModbus-1.0.4-py2.py3-none-any.whl
wget -c -O pysolarmanv5-3.0.0-py3-none-any.whl https://files.pythonhosted.org/packages/0a/79/2f3e44d7b82d07c9c72c3604aedd6a11493c3e9c79846411855fc5a26483/pysolarmanv5-3.0.0-py3-none-any.whl

# extract files if necessary, does not override files
unzip -n pyserial-3.5-py2.py3-none-any.whl
unzip -n uModbus-1.0.4-py2.py3-none-any.whl
unzip -n pysolarmanv5-3.0.0-py3-none-any.whl

# create sym-link to run script in deamon
ln -s $SCRIPT_DIR/service /service/$SERVICE_NAME

# add install-script to rc.local to be ready for firmware update
filename=/data/rc.local
if [ ! -f $filename ]
then
    touch $filename
    chmod 755 $filename
    echo "#!/bin/bash" >> $filename
    echo >> $filename
fi

grep -qxF "$SCRIPT_DIR/install.sh" $filename || echo "$SCRIPT_DIR/install.sh" >> $filename
