: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_sys_lsvl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_sys_lsvl_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select LISTCD
,LISTVL
,VALUNA
,DESCTX
,ENNAME
,VERMOD
,MODULE
,PROJCD from IDL.ODSS_SYS_LSVL where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_sys_lsvl_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes