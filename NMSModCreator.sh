#!/bin/bash
# NMSMODBuilder
# By SplinterGU (Juan Jose Ponteprino)

function error() {
    echo "NMSModBuilder v1.0 - by SplinterGU (2023)"
    echo ""
    echo "Error: $1"
    echo ""
    echo "usage: $0 <definition_file>"
    exit 1    
}

function save_if_pending() {
    if [ ${pending_to_save} = 1 ]; then
        if [ "$outputPakFile" = "" ]; then
            error "you must define an outputPakFile!"
        fi

        pending_to_save=0

        printf "${xml_data}" > "${exmlFile}"

        wine ${MBINCompiler} ${exmlFileDOS} -y
        wine ${PSARC} create -S ${tmpdirDOS}\\${mbinFile} -o ${outputPakFile} -y

    fi
}


if ! [ -e "$1" ];
then
    error "Definition File is missing!"
fi

MBINCompiler=MBINCompiler/MBINCompiler.exe
PSARC=psarc.exe

originaldir=${PWD}
tmpdir=$(mktemp -d)
tmpdirDOS=Z:$(echo $tmpdir|sed 's,/,\\,g')

defFile="$1"
inputPakFile=""
outputPakFile=""
mbinFile=""

xpath=""
xml_data=""

exmlFile=""
exmlFileDOS=""

pending_to_save=0

while IFS= read -r line
do
    # delete comments
    line=$(echo $line|sed -e '/#/d')

    if [ "$line" != "" ]; then
        case $line in
            !inputPakFile*)
                save_if_pending

                IFS=' '
                read dummy inputPakFile <<< $line
                IFS=
                xml_data=""
                ;;

            !outputPakFile*)
                IFS=' '
                read dummy outputPakFile <<< $line
                IFS=
                ;;

            !mbinFile*)
                save_if_pending

                IFS=' '
                read dummy mbinFile <<< $line
                IFS=

                if [ "$inputPakFile" = "" ]; then
                    error "you must define an inputPakFile!"
                fi

                wine ${PSARC} extract ${inputPakFile} ${mbinFile} --to=${tmpdirDOS} -y
                wine ${MBINCompiler} ${tmpdirDOS}/${mbinFile} -y

                exmlFile="${tmpdir}/$(basename ${tmpdir}/${mbinFile} .MBIN).EXML"
                exmlFileDOS=Z:$(echo ${exmlFile}|sed 's,/,\\,g')

                xml_data=$(cat "$exmlFile")                
                ;;

            cd*)
                IFS=' '
                read dummy xpath <<< $line
                IFS=

                if [ "$xpath" = "/" ]; then
                    xpath="/Data"
                else
                    xpath="$(echo ${xpath} | sed "s,^/,/Data/Property[@name=\'," | sed "s,/,\']/Property\[@name=\',g3")']"
                fi
                ;;

            *)
                IFS='='
                read name value <<< $line
                IFS=

                varxpath="$(echo "${xpath}/Property[@name='$name']/@value"|sed "s/@name='\([\*0-9]*\)'/\1/g")"

                xml_data=$(printf "${xml_data}" | xmlstarlet ed --update "${varxpath}" --value ${value})

                pending_to_save=1
                ;;


        esac

        IFS=
    fi

done < "${defFile}"

save_if_pending

rm -Rf ${tmpdir}
