: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_crdt_risk_rating_info_f
CreateDate: 20221122
FileName:   ${iel_data_path}/cmm_crdt_risk_rating_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.rating_cate_cd,chr(13),''),chr(10),'') as rating_cate_cd
,replace(replace(t1.rating_rest_cd,chr(13),''),chr(10),'') as rating_rest_cd
,replace(replace(t1.auto_rating_flg,chr(13),''),chr(10),'') as auto_rating_flg
,rating_dt
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.mgmt_clerk_id,chr(13),''),chr(10),'') as mgmt_clerk_id
,replace(replace(t1.apv_clerk_id,chr(13),''),chr(10),'') as apv_clerk_id
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.manu_adj_rs_descb,chr(13),''),chr(10),'') as manu_adj_rs_descb

from ${icl_schema}.cmm_crdt_risk_rating_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_crdt_risk_rating_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
