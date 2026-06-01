: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_bln_branch_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_bln_branch_info_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 ID
 ,BRANCH_ID
 ,BRH_NO
 ,BRH_TYPE
 ,UBANK_NO
 ,BLN_DOWN_ID
 ,BLN_DOWN_NO
 ,BLN_UBANK_NO
 
from ${idl_schema}.odss_bln_branch_info
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_bln_branch_info_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes