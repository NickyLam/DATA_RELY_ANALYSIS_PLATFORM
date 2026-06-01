: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_irrs_o_cbs_knp_inrt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/irrs_o_cbs_knp_inrt_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
inrttp
,termcd
,crcycd
,efctdt
,inefdt
,inrtst
,instrt
from idl.irrs_o_cbs_knp_inrt
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/irrs_o_cbs_knp_inrt_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes