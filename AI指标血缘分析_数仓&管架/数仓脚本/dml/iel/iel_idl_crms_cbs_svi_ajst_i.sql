: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_cbs_svi_ajst_i
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_cbs_svi_ajst_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
efctdt
,dataid
,inrttp
,termcd
,crcycd
,odinrt
,nwinrt
,inptdt
,userid
,status
from ${idl_schema}.crms_cbs_svi_ajst
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_cbs_svi_ajst_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes