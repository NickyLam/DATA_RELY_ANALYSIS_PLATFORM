: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_o_frs_mosn_i
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_o_frs_mosn_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select * from dual where 1<>1;" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_o_frs_mosn_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes