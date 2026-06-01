: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_src_cbvlt_a
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_src_cbvlt.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select secid
,cdate
,encash_years
,mdprice
,mcprice
,m_mduration
,m_cnvxty
,mbasisvalue
,msprd_d
,msprd_cnvxty
,myield_d
,myield_cnvxty
,myield
,account
,etl_dt
,etl_timestamp from iol.fams_src_cbvlt where etl_dt < to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_src_cbvlt.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes