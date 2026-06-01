: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_agt_guar_mova_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_agt_guar_mova_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.coll_id,chr(13),''),chr(10),'') as coll_id
,t1.etl_dt as etl_dt
,replace(replace(t1.mova_name,chr(13),''),chr(10),'') as mova_name
,replace(replace(t1.model,chr(13),''),chr(10),'') as model
,t1.qty as qty
,t1.ori_val as ori_val
,t1.prod_dt as prod_dt
,t1.ardy_prvs_depr_amt as ardy_prvs_depr_amt
,t1.used_years as used_years
,replace(replace(t1.store_site,chr(13),''),chr(10),'') as store_site
,t1.keep_stdt as keep_stdt
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
from ${idl_schema}.hdws_dul_d_ccrm_agt_guar_mova_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_agt_guar_mova_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes