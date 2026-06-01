: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_gf_fpkjxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_gf_fpkjxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.xf_nsrsbh,chr(13),''),chr(10),'') as xf_nsrsbh
,replace(replace(t.gf_nsrsbh,chr(13),''),chr(10),'') as gf_nsrsbh
,replace(replace(t.kprq,chr(13),''),chr(10),'') as kprq
,t.je as je
,t.se as se
,replace(replace(t.xf_mc,chr(13),''),chr(10),'') as xf_mc
,replace(replace(t.gfmc,chr(13),''),chr(10),'') as gfmc
,replace(replace(t.fptype,chr(13),''),chr(10),'') as fptype
,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t.update_time,chr(13),''),chr(10),'') as update_time
,t.ydje as ydje
,replace(replace(t.auth_uuid,chr(13),''),chr(10),'') as auth_uuid
,t.data_syn_time as data_syn_time
from iol.ilss_ghb_gf_fpkjxx t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_gf_fpkjxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes