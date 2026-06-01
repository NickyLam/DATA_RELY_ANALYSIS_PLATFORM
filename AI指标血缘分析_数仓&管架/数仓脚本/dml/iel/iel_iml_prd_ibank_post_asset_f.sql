: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_ibank_post_asset_f
CreateDate: 20230104
FileName:   ${iel_data_path}/prd_ibank_post_asset.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd
,replace(replace(t1.prod_cd,chr(13),''),chr(10),'') as prod_cd
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name
,effect_dt
,ftp_int_rat
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,value_dt
,exp_dt
,replace(replace(t1.rgst_type_cd,chr(13),''),chr(10),'') as rgst_type_cd
,replace(replace(t1.proj,chr(13),''),chr(10),'') as proj
,replace(replace(t1.risk_wt,chr(13),''),chr(10),'') as risk_wt
,risk_asset_tot
,rgst_dt
,replace(replace(t1.market_inst,chr(13),''),chr(10),'') as market_inst
,replace(replace(t1.customer_manager,chr(13),''),chr(10),'') as customer_manager
,replace(replace(t1.asset_type_cd,chr(13),''),chr(10),'') as asset_type_cd
,replace(replace(t1.market_type_cd,chr(13),''),chr(10),'') as market_type_cd
,replace(replace(t1.vch_accti_obj_id,chr(13),''),chr(10),'') as vch_accti_obj_id
,amt
,replace(replace(t1.effect_flg,chr(13),''),chr(10),'') as effect_flg
,margin_amt
,dep_rcpt_amt
,cfb_amt
,tbond_amt
,pb_amt
,pub_dept_enty_amt
,other_amt
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.prd_ibank_post_asset t1
where etl_dt = to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_ibank_post_asset.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
