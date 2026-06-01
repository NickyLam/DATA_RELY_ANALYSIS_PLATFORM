: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_gzfh_kna_acdc_f
CreateDate: 20180529
FileName:   ${iel_data_path}/gzfh_kna_acdc_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select DCMTTP,DCMTNO,DCTPID,STATUS,ACCTNO,SUBSAC,SEQNNO from  ${idl_schema}.gzfh_kna_acdc where etl_dt=to_date('${batch_date}','yyyymmdd')" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/gzfh_kna_acdc_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes