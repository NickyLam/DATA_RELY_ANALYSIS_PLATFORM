: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_o_frs_ubcardtrscode_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_o_frs_ubcardtrscode_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select msgtype
,trscode
,trsname
,trstype
,procecode
,bitmap from idl.pirs_o_frs_ubcardtrscode where 1=1;" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_o_frs_ubcardtrscode_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes