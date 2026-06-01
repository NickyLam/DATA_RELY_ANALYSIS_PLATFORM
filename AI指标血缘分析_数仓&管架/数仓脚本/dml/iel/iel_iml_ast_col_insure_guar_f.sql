: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_col_insure_guar_f
CreateDate: 20221021
FileName:   ${iel_data_path}/ast_col_insure_guar.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(asset_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(guartor_type_cd,chr(13),''),chr(10),'')
,replace(replace(guartor_id,chr(13),''),chr(10),'')
,replace(replace(guartor_name,chr(13),''),chr(10),'')
,replace(replace(guartor_orgnz_cd,chr(13),''),chr(10),'')
,replace(replace(guartor_nat_std_indus_cls_cd,chr(13),''),chr(10),'')
,guartor_net_asset_amt
,replace(replace(guartor_econ_compnt_cd,chr(13),''),chr(10),'')
,replace(replace(guartor_guar_indep_cd,chr(13),''),chr(10),'')
,replace(replace(guartor_rgst_cd,chr(13),''),chr(10),'')
,replace(replace(guartor_rgst_ext_rating_cd,chr(13),''),chr(10),'')
,guartor_ext_rating_dt
,replace(replace(guartor_ext_rating_rest_cd,chr(13),''),chr(10),'')
,guartor_intnal_rating_dt
,replace(replace(guartor_intnal_rating_rest_cd,chr(13),''),chr(10),'')
,replace(replace(guar_aim_cd,chr(13),''),chr(10),'')
,replace(replace(guar_insure_policy_num,chr(13),''),chr(10),'')
,replace(replace(stage_guar_flg,chr(13),''),chr(10),'')
,replace(replace(other_comnt,chr(13),''),chr(10),'')
,replace(replace(curr_cd,chr(13),''),chr(10),'')
,replace(replace(resdnt_flg,chr(13),''),chr(10),'')
,create_dt
,update_dt
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.ast_col_insure_guar t1
where 1=1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_insure_guar.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
