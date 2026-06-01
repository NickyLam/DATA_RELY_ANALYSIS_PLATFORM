: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_pams_khdx_jg_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_pams_khdx_jg.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,khdxdh
,jgdh
,jgmc
,jyjgbz
,pxbz
,zxzt
,zxrq
,fhdh
,fhbz
,jgdj
,jgqc
,start_dt
,end_dt
,id_mark
from idl.crms_pams_khdx_jg
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crms_pams_khdx_jg.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes