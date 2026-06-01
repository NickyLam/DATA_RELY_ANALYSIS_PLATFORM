: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_gzfh_ldb_yk_dsct_f
CreateDate: 20180529
FileName:   ${iel_data_path}/gzfh_ldb_yk_dsct_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select DATAID,NOTENO,ACCTNO,DSCTBR,DSCTTP,IOTYPE,BLTYPE,NOTETP,REBYTG,ONLNTG,CRCYCD,NOTEAM,MATUDT,INDYNM,DSCTIN,OPENDT,OPENSQ,CLOSDT,CLOSSQ,DSCTST,NOTEAC,INAJAC,INSTAC,IJSTDT,IJEDDT,INAJBL,AJACMD,PYINTG,PYINAC,PYTRAM from  ${idl_schema}.gzfh_ldb_yk_dsct where etl_dt=to_date('${batch_date}','yyyymmdd')" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/gzfh_ldb_yk_dsct_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes