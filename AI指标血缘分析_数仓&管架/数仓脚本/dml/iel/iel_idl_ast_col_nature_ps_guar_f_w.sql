: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ast_col_nature_ps_guar_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_col_nature_ps_guar_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.asset_id as asset_id
,t.lp_id as lp_id
,t.guartor_type_cd as guartor_type_cd
,t.guartor_id as guartor_id
,t.guartor_name as guartor_name
,t.guartor_cert_no as guartor_cert_no
,t.guartor_cert_type_cd as guartor_cert_type_cd
,t.guartor_nat_std_indus_cls_cd as guartor_nat_std_indus_cls_cd
,t.guartor_net_asset_amt as guartor_net_asset_amt
,t.guartor_econ_compnt_cd as guartor_econ_compnt_cd
,t.guartor_guar_indep_cd as guartor_guar_indep_cd
,t.guartor_rgst_cd as guartor_rgst_cd
,t.guartor_rgst_ext_rating_cd as guartor_rgst_ext_rating_cd
,t.guartor_ext_rating_dt as guartor_ext_rating_dt
,t.guartor_ext_rating_rest_cd as guartor_ext_rating_rest_cd
,t.guartor_intnal_rating_dt as guartor_intnal_rating_dt
,t.guartor_intnal_rating_rest_cd as guartor_intnal_rating_rest_cd
,t.guar_aim_cd as guar_aim_cd
,t.stage_guar_flg as stage_guar_flg
,t.other_comnt as other_comnt
,t.curr_cd as curr_cd
,t.resdnt_flg as resdnt_flg
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.ast_col_nature_ps_guar t 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_nature_ps_guar_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes