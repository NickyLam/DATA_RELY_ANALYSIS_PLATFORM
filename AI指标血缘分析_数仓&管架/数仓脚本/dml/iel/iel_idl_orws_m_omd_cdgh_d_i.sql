: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_orws_m_omd_cdgh_d_i
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_m_omd_cdgh_d_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
ods_src_dt
,trandt
,branch_name
,tranbr
,brchna
,acctno
,acctna
,accttp
,bus_type
,trantime
,transq
,tranus
,userna
,tranam
,processor
,authnam
,authus
,dcmttp
,menuid
,menunam
,acct_branchno
,acct_branchnam
,dcmtno
from ${idl_schema}.orws_m_omd_cdgh_d
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/orws_m_omd_cdgh_d_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes