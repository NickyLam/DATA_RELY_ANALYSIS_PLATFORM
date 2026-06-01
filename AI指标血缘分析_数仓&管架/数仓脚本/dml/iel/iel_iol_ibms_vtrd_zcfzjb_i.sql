: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_vtrd_zcfzjb_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_vtrd_zcfzjb.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.beg_date,chr(13),''),chr(10),'') as beg_date
,t1.ordid as ordid
,replace(replace(t1.title,chr(13),''),chr(10),'') as title
,t1.all_real_cp as all_real_cp
,t1.all_minus_cp as all_minus_cp
,t1.zb_real_cp as zb_real_cp
,t1.zb_minus_cp as zb_minus_cp
,t1.gz_real_cp as gz_real_cp
,t1.gz_minus_cp as gz_minus_cp
,t1.sz_real_cp as sz_real_cp
,t1.sz_minus_cp as sz_minus_cp
,t1.szsfq_real_cp as szsfq_real_cp
,t1.szsfq_minus_cp as szsfq_minus_cp
,t1.fs_real_cp as fs_real_cp
,t1.fs_minus_cp as fs_minus_cp
,t1.dg_real_cp as dg_real_cp
,t1.dg_minus_cp as dg_minus_cp
,t1.st_real_cp as st_real_cp
,t1.st_minus_cp as st_minus_cp
,t1.jm_real_cp as jm_real_cp
,t1.jm_minus_cp as jm_minus_cp
,t1.zh_real_cp as zh_real_cp
,t1.zh_minus_cp as zh_minus_cp
,t1.hz_real_cp as hz_real_cp
,t1.hz_minus_cp as hz_minus_cp
,t1.zs_real_cp as zs_real_cp
,t1.zs_minus_cp as zs_minus_cp
,t1.zq_real_cp as zq_real_cp
,t1.zq_minus_cp as zq_minus_cp
from ${iol_schema}.ibms_vtrd_zcfzjb t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_vtrd_zcfzjb.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes