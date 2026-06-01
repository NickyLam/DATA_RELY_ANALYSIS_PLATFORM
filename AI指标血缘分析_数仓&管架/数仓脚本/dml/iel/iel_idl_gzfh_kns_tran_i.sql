: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_gzfh_kns_tran_i
CreateDate: 20180529
FileName:   ${iel_data_path}/gzfh_kns_tran_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select TRANDT,TRANSQ,TRANTI,TRANTP,PRCSCD,SERVTP,TRANBR,PCKGSQ,CSBXNO,MENUID,TMNLID,TRANUS,CKBKUS,AUTHUS,CKTRTG,TRANST from  ${idl_schema}.gzfh_kns_tran where etl_dt=to_date('${batch_date}','yyyymmdd')" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/gzfh_kns_tran_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes