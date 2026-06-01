: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_src_dw_pty_indv_party_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_src_dw_pty_indv_party_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.pty_id,chr(13),''),chr(10),'') as pty_id
    ,t.etl_dt_ora as etl_dt_ora
    ,t.open_dt as open_dt
    ,replace(replace(t.open_org_id,chr(13),''),chr(10),'') as open_org_id
    ,replace(replace(t.open_teller_id,chr(13),''),chr(10),'') as open_teller_id
    ,replace(replace(t.setup_chn_typ_cd,chr(13),''),chr(10),'') as setup_chn_typ_cd
    ,replace(replace(t.pty_categ_cd,chr(13),''),chr(10),'') as pty_categ_cd
    ,replace(replace(t.blng_org_id,chr(13),''),chr(10),'') as blng_org_id
    ,replace(replace(t.blng_pty_mgr_id,chr(13),''),chr(10),'') as blng_pty_mgr_id
    ,t.colse_dt as colse_dt
    ,replace(replace(t.colse_org_id,chr(13),''),chr(10),'') as colse_org_id
    ,replace(replace(t.colse_teller_id,chr(13),''),chr(10),'') as colse_teller_id
    ,replace(replace(t.pty_typ_cd,chr(13),''),chr(10),'') as pty_typ_cd
    ,replace(replace(t.pty_blng_indu_cd,chr(13),''),chr(10),'') as pty_blng_indu_cd
    ,replace(replace(t.pty_loc_cd,chr(13),''),chr(10),'') as pty_loc_cd
    ,replace(replace(t.non_resident_flg,chr(13),''),chr(10),'') as non_resident_flg
    ,replace(replace(t.farmer_flg,chr(13),''),chr(10),'') as farmer_flg
    ,replace(replace(t.indv_indu_com_acct_flg,chr(13),''),chr(10),'') as indv_indu_com_acct_flg
    ,replace(replace(t.pty_status_cd,chr(13),''),chr(10),'') as pty_status_cd
    ,replace(replace(t.legal_name,chr(13),''),chr(10),'') as legal_name
    ,replace(replace(t.cn_fname,chr(13),''),chr(10),'') as cn_fname
    ,replace(replace(t.cn_sname,chr(13),''),chr(10),'') as cn_sname
    ,replace(replace(t.piny_name,chr(13),''),chr(10),'') as piny_name
    ,replace(replace(t.en_fname,chr(13),''),chr(10),'') as en_fname
    ,replace(replace(t.en_sname,chr(13),''),chr(10),'') as en_sname
    ,t.birth_dt as birth_dt
    ,replace(replace(t.gender_cd,chr(13),''),chr(10),'') as gender_cd
    ,replace(replace(t.birth_pla_cd,chr(13),''),chr(10),'') as birth_pla_cd
    ,replace(replace(t.native_place_cd,chr(13),''),chr(10),'') as native_place_cd
    ,replace(replace(t.nation_cd,chr(13),''),chr(10),'') as nation_cd
    ,replace(replace(t.ethnic_cd,chr(13),''),chr(10),'') as ethnic_cd
    ,replace(replace(t.poli_face_cd,chr(13),''),chr(10),'') as poli_face_cd
    ,replace(replace(t.reli_fai_cd,chr(13),''),chr(10),'') as reli_fai_cd
    ,replace(replace(t.marriage_status_cd,chr(13),''),chr(10),'') as marriage_status_cd
    ,replace(replace(t.highest_edu_degree_cd,chr(13),''),chr(10),'') as highest_edu_degree_cd
    ,replace(replace(t.highest_degree_cd,chr(13),''),chr(10),'') as highest_degree_cd
    ,replace(replace(t.grad_sch,chr(13),''),chr(10),'') as grad_sch
    ,replace(replace(t.reside_status_cd,chr(13),''),chr(10),'') as reside_status_cd
    ,t.join_work_tm as join_work_tm
    ,replace(replace(t.work_corp_name,chr(13),''),chr(10),'') as work_corp_name
    ,t.join_enterprise_dt as join_enterprise_dt
    ,replace(replace(t.corp_blng_indu_cd,chr(13),''),chr(10),'') as corp_blng_indu_cd
    ,replace(replace(t.corp_prop_cd,chr(13),''),chr(10),'') as corp_prop_cd
    ,replace(replace(t.unit_addr,chr(13),''),chr(10),'') as unit_addr
    ,replace(replace(t.corp_loc_zipcode,chr(13),''),chr(10),'') as corp_loc_zipcode
    ,replace(replace(t.profsn_title_cd,chr(13),''),chr(10),'') as profsn_title_cd
    ,replace(replace(t.duty_cd,chr(13),''),chr(10),'') as duty_cd
    ,replace(replace(t.career_cd,chr(13),''),chr(10),'') as career_cd
    ,replace(replace(t.sala_acct_num,chr(13),''),chr(10),'') as sala_acct_num
    ,replace(replace(t.sala_acct_open_bank,chr(13),''),chr(10),'') as sala_acct_open_bank
    ,replace(replace(t.ghb_emp_flg,chr(13),''),chr(10),'') as ghb_emp_flg
    ,replace(replace(t.emp_id,chr(13),''),chr(10),'') as emp_id
    ,replace(replace(t.ghb_shrholder_flg,chr(13),''),chr(10),'') as ghb_shrholder_flg
    ,replace(replace(t.auth_mode_cd,chr(13),''),chr(10),'') as auth_mode_cd
    ,replace(replace(t.safe_rank_cd,chr(13),''),chr(10),'') as safe_rank_cd
    ,replace(replace(t.invt_risk_pref_cd,chr(13),''),chr(10),'') as invt_risk_pref_cd
    ,replace(replace(t.risk_ablt_est_org,chr(13),''),chr(10),'') as risk_ablt_est_org
    ,t.risk_ablt_est_dt as risk_ablt_est_dt
    ,t.raise_cnt as raise_cnt
    ,t.family_anl_inc as family_anl_inc
    ,t.family_mon_income as family_mon_income
    ,t.indv_mon_income as indv_mon_income
    ,t.indv_year_income as indv_year_income
    ,replace(replace(t.car_brand,chr(13),''),chr(10),'') as car_brand
    ,replace(replace(t.blkl_pty_flg,chr(13),''),chr(10),'') as blkl_pty_flg
    ,t.up_blkl_dt as up_blkl_dt
    ,replace(replace(t.up_blkl_rsns,chr(13),''),chr(10),'') as up_blkl_rsns
    ,replace(replace(t.blkl_src_cd,chr(13),''),chr(10),'') as blkl_src_cd
    ,replace(replace(t.prefr_cont_mode_cd,chr(13),''),chr(10),'') as prefr_cont_mode_cd
    ,replace(replace(t.bank_res_tel_num,chr(13),''),chr(10),'') as bank_res_tel_num
    ,replace(replace(t.crdt_pty_flg,chr(13),''),chr(10),'') as crdt_pty_flg
    ,replace(replace(t.small_eown_flg,chr(13),''),chr(10),'') as small_eown_flg
    ,replace(replace(t.open_card_typ_cd,chr(13),''),chr(10),'') as open_card_typ_cd
    ,replace(replace(t.pty_level_cd,chr(13),''),chr(10),'') as pty_level_cd
    ,replace(replace(t.real_nm_flg,chr(13),''),chr(10),'') as real_nm_flg
    ,replace(replace(t.co_brand_pty_flg,chr(13),''),chr(10),'') as co_brand_pty_flg
    ,replace(replace(t.insd_and_otsd_flg,chr(13),''),chr(10),'') as insd_and_otsd_flg
    ,replace(replace(t.assoc_txn_flg,chr(13),''),chr(10),'') as assoc_txn_flg
    ,replace(replace(t.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
    ,replace(replace(t.del_flg,chr(13),''),chr(10),'') as del_flg
from iol.rcds_src_dw_pty_indv_party_info t    
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_src_dw_pty_indv_party_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes