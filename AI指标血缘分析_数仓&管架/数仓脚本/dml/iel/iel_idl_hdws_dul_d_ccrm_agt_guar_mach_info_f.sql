: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_agt_guar_mach_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_agt_guar_mach_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.coll_id,chr(13),''),chr(10),'') as coll_id
,t1.etl_dt as etl_dt
,replace(replace(t1.equip_brand,chr(13),''),chr(10),'') as equip_brand
,replace(replace(t1.model_spec,chr(13),''),chr(10),'') as model_spec
,replace(replace(t1.maker,chr(13),''),chr(10),'') as maker
,replace(replace(t1.wthr_spec_equip,chr(13),''),chr(10),'') as wthr_spec_equip
,t1.equip_qty as equip_qty
,t1.use_years as use_years
,replace(replace(t1.equip_situ,chr(13),''),chr(10),'') as equip_situ
,t1.purch_dt as purch_dt
,t1.make_dt as make_dt
,t1.purch_price as purch_price
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
from ${idl_schema}.hdws_dul_d_ccrm_agt_guar_mach_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_agt_guar_mach_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes