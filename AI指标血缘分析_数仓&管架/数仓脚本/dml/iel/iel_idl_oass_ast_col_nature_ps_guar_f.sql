: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_col_nature_ps_guar_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_ast_col_nature_ps_guar.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.guartor_type_cd as guartor_type_cd
,t1.guartor_id as guartor_id
,t1.guartor_name as guartor_name
,t1.guartor_cert_no as guartor_cert_no
,t1.guartor_cert_type_cd as guartor_cert_type_cd
,t1.guartor_nat_std_indus_cls_cd as guartor_nat_std_indus_cls_cd
,t1.guartor_net_asset_amt as guartor_net_asset_amt
,t1.guartor_econ_compnt_cd as guartor_econ_compnt_cd
,t1.guartor_guar_indep_cd as guartor_guar_indep_cd
,t1.guartor_rgst_cd as guartor_rgst_cd
,t1.guartor_rgst_ext_rating_cd as guartor_rgst_ext_rating_cd
,t1.guartor_ext_rating_dt as guartor_ext_rating_dt
,t1.guartor_ext_rating_rest_cd as guartor_ext_rating_rest_cd
,t1.guartor_intnal_rating_dt as guartor_intnal_rating_dt
,t1.guartor_intnal_rating_rest_cd as guartor_intnal_rating_rest_cd
,t1.guar_aim_cd as guar_aim_cd
,t1.stage_guar_flg as stage_guar_flg
,t1.other_comnt as other_comnt
,t1.curr_cd as curr_cd
,t1.resdnt_flg as resdnt_flg
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.asset_id as asset_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_ast_col_nature_ps_guar t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_col_nature_ps_guar.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
