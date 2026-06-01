: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_ifm_tbbranch_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_ifm_tbbranch_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
internal_branch
,branch_no
,branch_name
,short_name
,up_branch
,branch_level
,branch_kind
,branch_trans
,reserve1
from ${idl_schema}.crms_ifm_tbbranch
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_ifm_tbbranch_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes