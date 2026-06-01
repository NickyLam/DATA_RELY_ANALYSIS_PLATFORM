: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_orws_m_omd_yhhpyc_i
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_m_omd_yhhpyc_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 date_id
,gs_no
,cshpbillnb
,cshpbilltype
,hpstatus
,billst
,cshpbillamt
,paybrnno
,cshpbilldate
,payacct
,payname
,tranus
,ckbkus
from ${idl_schema}.orws_m_omd_yhhpyc
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/orws_m_omd_yhhpyc_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes