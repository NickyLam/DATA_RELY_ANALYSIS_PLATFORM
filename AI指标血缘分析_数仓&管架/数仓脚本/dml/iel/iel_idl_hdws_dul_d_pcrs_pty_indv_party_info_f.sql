: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_pcrs_pty_indv_party_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_pcrs_pty_indv_party_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,t1.etl_dt as etl_dt
,t1.open_dt as open_dt
,replace(replace(t1.open_org_id,chr(13),''),chr(10),'') as open_org_id
,replace(replace(t1.open_teller_id,chr(13),''),chr(10),'') as open_teller_id
,replace(replace(t1.setup_chn_typ_cd,chr(13),''),chr(10),'') as setup_chn_typ_cd
,replace(replace(t1.blng_org_id,chr(13),''),chr(10),'') as blng_org_id
,replace(replace(t1.blng_pty_mgr_id,chr(13),''),chr(10),'') as blng_pty_mgr_id
,t1.colse_dt as colse_dt
,replace(replace(t1.colse_org_id,chr(13),''),chr(10),'') as colse_org_id
,replace(replace(t1.colse_teller_id,chr(13),''),chr(10),'') as colse_teller_id
,replace(replace(t1.pty_typ_cd,chr(13),''),chr(10),'') as pty_typ_cd
,replace(replace(t1.pty_blng_indu_cd,chr(13),''),chr(10),'') as pty_blng_indu_cd
,replace(replace(t1.pty_loc_cd,chr(13),''),chr(10),'') as pty_loc_cd
,replace(replace(t1.non_resident_flg,chr(13),''),chr(10),'') as non_resident_flg
,replace(replace(t1.farmer_flg,chr(13),''),chr(10),'') as farmer_flg
,replace(replace(t1.indv_indu_com_acct_flg,chr(13),''),chr(10),'') as indv_indu_com_acct_flg
,replace(replace(t1.pty_status_cd,chr(13),''),chr(10),'') as pty_status_cd
,replace(replace(t1.legal_name,chr(13),''),chr(10),'') as legal_name
,replace(replace(t1.cn_fname,chr(13),''),chr(10),'') as cn_fname
,replace(replace(t1.cn_sname,chr(13),''),chr(10),'') as cn_sname
,replace(replace(t1.piny_name,chr(13),''),chr(10),'') as piny_name
,replace(replace(t1.en_fname,chr(13),''),chr(10),'') as en_fname
,replace(replace(t1.en_sname,chr(13),''),chr(10),'') as en_sname
,t1.birth_dt as birth_dt
,replace(replace(t1.gender_cd,chr(13),''),chr(10),'') as gender_cd
,replace(replace(t1.birth_pla_cd,chr(13),''),chr(10),'') as birth_pla_cd
,replace(replace(t1.native_place_cd,chr(13),''),chr(10),'') as native_place_cd
,replace(replace(t1.nation_cd,chr(13),''),chr(10),'') as nation_cd
,replace(replace(t1.ethnic_cd,chr(13),''),chr(10),'') as ethnic_cd
,replace(replace(t1.poli_face_cd,chr(13),''),chr(10),'') as poli_face_cd
,replace(replace(t1.reli_fai_cd,chr(13),''),chr(10),'') as reli_fai_cd
,replace(replace(t1.marriage_status_cd,chr(13),''),chr(10),'') as marriage_status_cd
,replace(replace(t1.highest_edu_degree_cd,chr(13),''),chr(10),'') as highest_edu_degree_cd
,replace(replace(t1.highest_degree_cd,chr(13),''),chr(10),'') as highest_degree_cd
,replace(replace(t1.grad_sch,chr(13),''),chr(10),'') as grad_sch
,replace(replace(t1.reside_status_cd,chr(13),''),chr(10),'') as reside_status_cd
,t1.join_work_tm as join_work_tm
,replace(replace(t1.work_corp_name,chr(13),''),chr(10),'') as work_corp_name
,t1.join_enterprise_dt as join_enterprise_dt
,replace(replace(t1.corp_blng_indu_cd,chr(13),''),chr(10),'') as corp_blng_indu_cd
,replace(replace(t1.corp_prop_cd,chr(13),''),chr(10),'') as corp_prop_cd
,replace(replace(t1.unit_addr,chr(13),''),chr(10),'') as unit_addr
,replace(replace(t1.corp_loc_zipcode,chr(13),''),chr(10),'') as corp_loc_zipcode
,replace(replace(t1.profsn_title_cd,chr(13),''),chr(10),'') as profsn_title_cd
,replace(replace(t1.duty_cd,chr(13),''),chr(10),'') as duty_cd
,replace(replace(t1.career_cd,chr(13),''),chr(10),'') as career_cd
,replace(replace(t1.sala_acct_num,chr(13),''),chr(10),'') as sala_acct_num
,replace(replace(t1.sala_acct_open_bank,chr(13),''),chr(10),'') as sala_acct_open_bank
,replace(replace(t1.ghb_emp_flg,chr(13),''),chr(10),'') as ghb_emp_flg
,replace(replace(t1.emp_id,chr(13),''),chr(10),'') as emp_id
,replace(replace(t1.ghb_shrholder_flg,chr(13),''),chr(10),'') as ghb_shrholder_flg
,replace(replace(t1.auth_mode_cd,chr(13),''),chr(10),'') as auth_mode_cd
,replace(replace(t1.safe_rank_cd,chr(13),''),chr(10),'') as safe_rank_cd
,replace(replace(t1.invt_risk_pref_cd,chr(13),''),chr(10),'') as invt_risk_pref_cd
,replace(replace(t1.risk_ablt_est_org,chr(13),''),chr(10),'') as risk_ablt_est_org
,t1.risk_ablt_est_dt as risk_ablt_est_dt
,t1.raise_cnt as raise_cnt
,t1.family_anl_inc as family_anl_inc
,t1.family_mon_income as family_mon_income
,t1.indv_mon_income as indv_mon_income
,t1.indv_year_income as indv_year_income
,replace(replace(t1.car_brand,chr(13),''),chr(10),'') as car_brand
,replace(replace(t1.blkl_pty_flg,chr(13),''),chr(10),'') as blkl_pty_flg
,t1.up_blkl_dt as up_blkl_dt
,replace(replace(t1.up_blkl_rsns,chr(13),''),chr(10),'') as up_blkl_rsns
,replace(replace(t1.blkl_src_cd,chr(13),''),chr(10),'') as blkl_src_cd
,replace(replace(t1.prefr_cont_mode_cd,chr(13),''),chr(10),'') as prefr_cont_mode_cd
,replace(replace(t1.bank_res_tel_num,chr(13),''),chr(10),'') as bank_res_tel_num
,replace(replace(t1.crdt_pty_flg,chr(13),''),chr(10),'') as crdt_pty_flg
,replace(replace(t1.small_eown_flg,chr(13),''),chr(10),'') as small_eown_flg
,replace(replace(t1.open_card_typ_cd,chr(13),''),chr(10),'') as open_card_typ_cd
,replace(replace(t1.pty_level_cd,chr(13),''),chr(10),'') as pty_level_cd
,replace(replace(t1.real_nm_flg,chr(13),''),chr(10),'') as real_nm_flg
,replace(replace(t1.co_brand_pty_flg,chr(13),''),chr(10),'') as co_brand_pty_flg
,replace(replace(t1.insd_and_otsd_flg,chr(13),''),chr(10),'') as insd_and_otsd_flg
,replace(replace(t1.assoc_txn_flg,chr(13),''),chr(10),'') as assoc_txn_flg
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
from ${idl_schema}.hdws_dul_d_pcrs_pty_indv_party_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_pcrs_pty_indv_party_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes