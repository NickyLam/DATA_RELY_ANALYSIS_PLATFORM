: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_cbss_kns_tran_fund_a
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_cbss_kns_tran_fund.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select trandt 
,transq 
,crcycd 
,tranam 
,acctno 
,subsac 
,acctna 
,acctbr 
,dcmttp 
,dcmtno 
,dctpid 
,cheqtp 
,cheqno 
,cqtpid 
,invodt 
,toacct 
,tosbac 
,toacna 
,toacbr 
,etl_dt 
,etl_timestamp from idl.aml_cbss_kns_tran_fund where etl_dt= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_cbss_kns_tran_fund.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes