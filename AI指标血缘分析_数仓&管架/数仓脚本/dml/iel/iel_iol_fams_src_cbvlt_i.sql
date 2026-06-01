: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_src_cbvlt_i
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_src_cbvlt.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.secid,chr(13),''),chr(10),'') as secid
,replace(replace(t1.cdate,chr(13),''),chr(10),'') as cdate
,t1.encash_years as encash_years
,t1.mdprice as mdprice
,t1.mcprice as mcprice
,t1.m_mduration as m_mduration
,t1.m_cnvxty as m_cnvxty
,t1.mbasisvalue as mbasisvalue
,t1.msprd_d as msprd_d
,t1.msprd_cnvxty as msprd_cnvxty
,t1.myield_d as myield_d
,t1.myield_cnvxty as myield_cnvxty
,t1.myield as myield
,replace(replace(t1.account,chr(13),''),chr(10),'') as account
,to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.etl_timestamp as etl_timestamp
from iol.fams_src_cbvlt t1
where replace(trim(t1.cdate),'-') = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_src_cbvlt.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes