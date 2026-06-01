: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_col_guartor_rating_info_f
CreateDate: 20231031
FileName:   ${iel_data_path}/cmm_col_guartor_rating_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.col_id,chr(13),''),chr(10),'') as col_id
,replace(replace(t1.guartor_id,chr(13),''),chr(10),'') as guartor_id
,replace(replace(t1.guartor_name,chr(13),''),chr(10),'') as guartor_name
,replace(replace(t1.guartor_type_cd,chr(13),''),chr(10),'') as guartor_type_cd
,guartor_intnal_rating_dt
,replace(replace(t1.guartor_intnal_rating_rest,chr(13),''),chr(10),'') as guartor_intnal_rating_rest
,guartor_ext_rating_dt
,replace(replace(t1.guartor_ext_rating_rest,chr(13),''),chr(10),'') as guartor_ext_rating_rest
,replace(replace(t1.guar_aim_cd,chr(13),''),chr(10),'') as guar_aim_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.guartor_econ_compnt_cd,chr(13),''),chr(10),'') as guartor_econ_compnt_cd
,replace(replace(t1.guartor_nat_std_indus_cls_cd,chr(13),''),chr(10),'') as guartor_nat_std_indus_cls_cd
,replace(replace(t1.stage_guar_flg,chr(13),''),chr(10),'') as stage_guar_flg
,guartor_net_asset_amt
,replace(replace(t1.guartor_guar_indep_cd,chr(13),''),chr(10),'') as guartor_guar_indep_cd

from ${icl_schema}.cmm_col_guartor_rating_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_col_guartor_rating_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
