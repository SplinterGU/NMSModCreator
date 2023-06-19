#!/bin/bash
# NMSMODBuilder
# By SplinterGU (Juan Jose Ponteprino)

index=-1
lastIndex=-1

function trim() {
    echo "$1" | sed -e 's/^[[:space:]]*//g' -e 's/[[:space:]]*$//g'
}

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
        params="${extraFilesDOS[@]}"
        for i in ${!mbinNames[@]};
        do
            echo "${xml_data[$i]}" > "${exmlFile[$i]}"
            wine ${MBINCompiler} ${exmlFileDOS[$i]} -y -q
            if [ $? -ne 0 ]; then
                echo -e "\nError compiling ${mbinNames[$i]}\nAborting..."
                #rm -Rf ${tmpdir}
                exit 1
            fi
            params+="${exmlFileDOS[$i]} "
        done
        params=$(echo $params|sed -e 's/EXML/MBIN/g' -e 's,\\,\\\\,g')
        echo "${params}"|xargs wine ${PSARC} create -s${tmpdirDOS} -o ${outputPakFile} -y
    fi

    unset mbinNames
    unset exmlFile
    unset exmlFileDOS
    unset xml_data
    unset extraFiles
    unset extraFilesDOS

    index=-1
    lastIndex=-1
}

function getMbin() {
    # args: mbinFile

    for i in ${!mbinNames[@]};
    do
        if [ "${mbinNames[$i]}" = "$1" ]; then
            index=$i
            return 0
        fi
    done

    wine ${PSARC} extract ${inputPakFile} $1 --to=${tmpdirDOS} -y
    wine ${MBINCompiler} ${tmpdirDOS}/$1 -y --no-version -q
    if [ $? -ne 0 ]; then
        echo -e "\nError getting $1\nAborting..."
        #rm -Rf ${tmpdir}
        exit 1
    fi

    ((lastIndex=${lastIndex}+1))
    index=${lastIndex}

    mbinNames[${index}]=$1
    exmlFile[${index}]="$(echo ${tmpdir}/${mbinNames[${index}]}|sed 's/MBIN/EXML/g')"
    exmlFileDOS[${index}]=Z:$(echo ${exmlFile[${index}]}|sed 's,/,\\,g')
    xml_data[${index}]=$(cat "${exmlFile[${index}]}")
}

function process() {
    while IFS= read -r line
    do
        # delete comments
        line=$(echo $line|sed -e '/#/d')
        line="$(trim "$line")"

        if [ "$line" != "" ]; then
            case $line in
                !PSARC*)
                    IFS=' '
                    read dummy PSARC <<< $line
                    IFS=
                    ;;

                !MBINCompiler*)
                    IFS=' '
                    read dummy MBINCompiler <<< $line
                    IFS=
                    ;;

                !inputPakFile*)
                    IFS=' '
                    read dummy inputPakFile <<< $line
                    IFS=
                    ;;

                !outputPakFile*)
                    if [ "$outputPakFile" != "" ]; then
                        save_if_pending
                    fi

                    IFS=' '
                    read dummy outputPakFile <<< $line
                    IFS=
                    ;;

                !mbinFile*)
                    IFS=' '
                    read dummy mbinFile <<< $line
                    IFS=

                    if [ "$inputPakFile" = "" ]; then
                        error "you must define an inputPakFile!"
                    fi

                    getMbin ${mbinFile}
                    ;;

                !addFile*)
                    IFS=' '
                    read dummy addFile <<< $line
                    IFS=

                    cp -Rf --parents ${addFile} ${tmpdir}

                    extraFiles+=(${tmpdir}/${addFile})
                    extraFilesDOS+=(Z:$(echo ${tmpdir}/${addFile}|sed 's,/,\\,g'))

                    pending_to_save=1
                    ;;

                !include*)
                    IFS=' '
                    read dummy fileName <<< $line
                    IFS=

                    fileName="$(trim "$fileName")"

                    process ${fileName}
                    ;;

                cd*)
                    IFS=' '
                    read dummy tmpxpath <<< $line
                    IFS=

                    tmpxpath="$(trim "${tmpxpath}")"

                    if [ "$tmpxpath" = "/" ]; then
                        xpath="/Data"
                    else
                        if [ "${tmpxpath::1}" != "/" ]; then
                            tmpxpath="$(echo ${tmpxpath} | sed -e "s,^,/Property[@name='," -e "s,/,']/Property\[@name=',g3" -e "s,@name='=,@value=',g" -e "s,\[=\([^]]*\)\],' and @value='\1,g" -e "s,@name='' and ,,g" -e "s,Property\[@name='\.\.'\],..,g")']"
                            xpath="${xpath}${tmpxpath}"
                        else
                            xpath="${tmpxpath}"
                            xpath="$(echo ${xpath} | sed -e "s,^/,/Data/Property[@name='," -e "s,/,']/Property\[@name=',g3" -e "s,@name='=,@value=',g" -e "s,\[=\([^]]*\)\],' and @value='\1,g" -e "s,@name='' and ,,g" -e "s,Property\[@name='\.\.'\],..,g")']"
                        fi
                    fi
                    ;;

                *)
                    if [ ${index} = -1 ]; then
                        error "you must define a mbinFile!"
                    fi

                    IFS='='
                    read name value <<< $line
                    IFS=

                    name="$(trim "$name")"
                    value="$(trim "$value")"

                    if [[ ${line} = *=* ]]; then
                        if [[ "$name" != "" ]]; then
                            # var with name
                            varpath_check="$(echo "${xpath}/Property[@name='$name']"|sed "s/@name='\([\*0-9]*\)'/\1/g")"
                            varxpath="$(echo "${xpath}/Property[@name='$name']/@value"|sed "s/@name='\([\*0-9]*\)'/\1/g")"

                            if [ $(echo "${xml_data[${index}]}" | xmlstarlet sel -t -v "count(${varpath_check})") -gt 0 ]; then
                                # exists
                                xml_data[${index}]=$(echo "${xml_data[${index}]}" | xmlstarlet ed --update "${varxpath}" --value "${value}")
                            else
                                xml_data[${index}]=$(echo "${xml_data[${index}]}" | \
                                                     xmlstarlet ed -s "${xpath}" -t "elem" -n "Property" -i "${xpath}/Property[not(@name) and not(@value)]" -t attr -n name --value "${name}" \
                                                     -i "${xpath}/Property[@name='$name' and not(@value)]" -t attr -n value --value "${value}" \
                                                    )
                            fi
                        else
                            #create Property whith value only
                            varpath_check="$(echo "${xpath}/Property[@value='$value']"|sed "s/@value='\([\*0-9]*\)'/\1/g")"

                            if [ $(echo "${xml_data[${index}]}" | xmlstarlet sel -t -v "count(${varpath_check})") -eq 0 ]; then
                                xml_data[${index}]=$(echo "${xml_data[${index}]}" | \
                                                     xmlstarlet ed -s "${xpath}" -t "elem" -n "Property" -i "${xpath}/Property[not(@name) and not(@value)]" -t attr -n value --value "${value}" \
                                                    )
                            fi
                        fi
                    else
                        #create Property whith name only
                        varpath_check="$(echo "${xpath}/Property[@name='$name']"|sed "s/@name='\([\*0-9]*\)'/\1/g")"

                        if [ $(echo "${xml_data[${index}]}" | xmlstarlet sel -t -v "count(${varpath_check})") -eq 0 ]; then
                            xml_data[${index}]=$(echo "${xml_data[${index}]}" | \
                                                 xmlstarlet ed -s "${xpath}" -t "elem" -n "Property" -i "${xpath}/Property[not(@name) and not(@value)]" -t attr -n name --value "${name}" \
                                                )
                        fi
                    fi

                    pending_to_save=1
                    ;;


            esac

            IFS=
        fi

    done < "$1"
}

if ! [ -e "$1" ];
then
    error "Definition File is missing!"
fi

MBINCompiler=${PWD}/MBINCompiler/MBINCompiler.exe
PSARC=${PWD}/psarc.exe

tmpdir=$(mktemp -d)
tmpdirDOS=Z:$(echo $tmpdir|sed 's,/,\\,g')

defFile="$1"
inputPakFile=""
outputPakFile=""

xpath=""
xml_data=""

unset exmlFile
unset exmlFileDOS
unset extraFiles
unset extraFilesDOS

pending_to_save=0

process "${defFile}"

save_if_pending

#rm -Rf ${tmpdir}
