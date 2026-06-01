: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_pams_khdx_hy_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_pams_khdx_hy.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,khdxdh
,hydh
,hymc
,xl
,lxdh
,sfz
,yxrybz
,xnhybz
,dlmc
,dlmm
,aqjb
,zxzt
,scdl
,zpxx
,czybh
,zxrq
,csrq
,gzrq
,rhrq
,fgbz
,pxbz
,xgmmrq
,start_dt
,end_dt
,id_mark
from idl.crms_pams_khdx_hy
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crms_pams_khdx_hy.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes