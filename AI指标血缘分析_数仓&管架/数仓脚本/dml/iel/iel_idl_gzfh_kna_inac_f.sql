: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_gzfh_kna_inac_f
CreateDate: 20180529
FileName:   ${iel_data_path}/gzfh_kna_inac_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select acctid
,crcycd
,acctna
,brchno
,dtitcd
,blncdn
,acctst
,lstrdt
,lstrsq
,opendt
,optrsq
,closdt
,cltrsq
,ioflag
,serial
,spectg from  ${idl_schema}.gzfh_kna_inac where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/gzfh_kna_inac_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes