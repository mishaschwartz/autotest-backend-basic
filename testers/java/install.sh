#!/usr/bin/env bash

if [ $# -ne 2 ]; then
	echo usage: $0 java_dir uam_dir
	exit 1
fi

JDIR=$1
UAMDIR=$2
SOLUTIONDIR=${JDIR}/solution
TESTSDIR=${SOLUTIONDIR}/tests
SPECS=${JDIR}/specs.json
JAMDIR=${UAMDIR}/jam

echo "[JAVA] Installing system packages"
sudo apt-get install python3 openjdk-8-jre
echo "[JAVA] Downloading latest version of UAM"
if cd ${UAMDIR}; then
	git pull
else
	git clone https://github.com/ProjectAT/uam.git ${UAMDIR}
fi
echo "[JAVA] Compiling JAM and solution"
pushd ${JAMDIR}
./compile_jam.sh
./compile_tests.sh ${TESTSDIR} ${SOLUTIONDIR}
popd
echo '[JAVA] Updating json specs file'
sed -i -e "s#/path/to/uam#${UAMDIR}#g;s#/path/to/tests#${TESTSDIR}#g" ${SPECS}