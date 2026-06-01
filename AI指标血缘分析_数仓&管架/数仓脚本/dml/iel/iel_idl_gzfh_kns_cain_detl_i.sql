: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_gzfh_kns_cain_detl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/gzfh_kns_cain_detl_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select CAINDT,ACCTID,BRCHNO,CRCYCD,DTITCD,DEBTTP,CAINBL,LASTBL,CURTAM,INSTRT from  ${idl_schema}.gzfh_kns_cain_detl where etl_dt=to_date('${batch_date}','yyyymmdd')" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/gzfh_kns_cain_detl_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes