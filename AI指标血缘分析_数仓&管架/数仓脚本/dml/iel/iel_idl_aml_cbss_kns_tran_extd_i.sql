: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_cbss_kns_tran_extd_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_cbss_kns_tran_extd.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select trandt 
,transq 
,agcuna 
,agidtp 
,agidno 
,smrytx 
,pstspt 
,extdc1 
,extdc2 
,extdc3 
,extdc4 
,extdc5 
,extdc6 
,extdc7 
,extdc8 
,agendr 
,agidmt 
,agtele 
,agadrs 
,agdesc 
,agtype 
,opidtp 
,opidno 
,opcuna 
,ntlycd 
,etl_dt 
,etl_timestamp from idl.aml_cbss_kns_tran_extd where etl_dt= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_cbss_kns_tran_extd.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes