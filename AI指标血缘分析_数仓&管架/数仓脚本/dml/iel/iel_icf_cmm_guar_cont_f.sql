: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_guar_cont_f
CreateDate: 20240425
FileName:   ${iel_data_path}/cmm_guar_cont.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.guar_cont_id,chr(13),''),chr(10),'') as guar_cont_id
,replace(replace(t1.guar_cont_type_cd,chr(13),''),chr(10),'') as guar_cont_type_cd
,replace(replace(t1.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd
,replace(replace(t1.guar_kind_cd,chr(13),''),chr(10),'') as guar_kind_cd
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,sign_dt
,effect_dt
,exp_dt
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.guartor_id,chr(13),''),chr(10),'') as guartor_id
,replace(replace(t1.guartor_name,chr(13),''),chr(10),'') as guartor_name
,replace(replace(t1.guartor_cert_type_cd,chr(13),''),chr(10),'') as guartor_cert_type_cd
,replace(replace(t1.guartor_cert_no,chr(13),''),chr(10),'') as guartor_cert_no
,replace(replace(t1.brwer_rela_cd,chr(13),''),chr(10),'') as brwer_rela_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,guar_amt
,ocup_amt
,guar_start_dt
,guar_exp_dt
,guar_tenor
,replace(replace(t1.pri_contr_id,chr(13),''),chr(10),'') as pri_contr_id
,replace(replace(t1.pri_contr_type_cd,chr(13),''),chr(10),'') as pri_contr_type_cd
,replace(replace(t1.ocup_guar_lmt_flg,chr(13),''),chr(10),'') as ocup_guar_lmt_flg
,replace(replace(t1.guar_range_cd,chr(13),''),chr(10),'') as guar_range_cd
,replace(replace(t1.gcust_flg,chr(13),''),chr(10),'') as gcust_flg
,replace(replace(t1.obg_id,chr(13),''),chr(10),'') as obg_id
,replace(replace(t1.obg_name,chr(13),''),chr(10),'') as obg_name
,replace(replace(t1.dir_guar_flg,chr(13),''),chr(10),'') as dir_guar_flg
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.director_org_id,chr(13),''),chr(10),'') as director_org_id
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,replace(replace(t1.rgstrat_id,chr(13),''),chr(10),'') as rgstrat_id
,rgst_dt
,replace(replace(t1.update_person_id,chr(13),''),chr(10),'') as update_person_id
,update_dt
,replace(replace(t1.guar_type_cls_cd,chr(13),''),chr(10),'') as guar_type_cls_cd
,replace(replace(t1.guartor_natnal_econ_dept_type_cd,chr(13),''),chr(10),'') as guartor_natnal_econ_dept_type_cd
,replace(replace(t1.guartor_indus_type_cd,chr(13),''),chr(10),'') as guartor_indus_type_cd
,replace(replace(t1.guartor_dist_cd,chr(13),''),chr(10),'') as guartor_dist_cd
,replace(replace(t1.guartor_corp_size_cd,chr(13),''),chr(10),'') as guartor_corp_size_cd
,replace(replace(t1.rev_guar_measure_flg,chr(13),''),chr(10),'') as rev_guar_measure_flg
,replace(replace(t1.guar_cont_name,chr(13),''),chr(10),'') as guar_cont_name
,guartor_net_asset
,replace(replace(t1.guartor_cate_cd,chr(13),''),chr(10),'') as guartor_cate_cd
,replace(replace(t1.guartor_cty_rg_cd,chr(13),''),chr(10),'') as guartor_cty_rg_cd
,replace(replace(t1.rev_guar_flg,chr(13),''),chr(10),'') as rev_guar_flg
,replace(replace(t1.gover_fin_guar_corp_guar_flg,chr(13),''),chr(10),'') as gover_fin_guar_corp_guar_flg

from ${icl_schema}.cmm_guar_cont t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_guar_cont.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
