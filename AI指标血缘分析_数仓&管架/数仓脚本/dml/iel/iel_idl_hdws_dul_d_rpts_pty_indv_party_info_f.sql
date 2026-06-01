: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_pty_indv_party_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_pty_indv_party_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,etl_dt
      ,open_dt
      ,replace(replace(open_org_id,chr(10),''),chr(13),'') as open_org_id
      ,replace(replace(open_teller_id,chr(10),''),chr(13),'') as open_teller_id
      ,replace(replace(setup_chn_typ_cd,chr(10),''),chr(13),'') as setup_chn_typ_cd
      ,replace(replace(blng_org_id,chr(10),''),chr(13),'') as blng_org_id
      ,replace(replace(blng_pty_mgr_id,chr(10),''),chr(13),'') as blng_pty_mgr_id
      ,colse_dt
      ,replace(replace(colse_org_id,chr(10),''),chr(13),'') as colse_org_id
      ,replace(replace(colse_teller_id,chr(10),''),chr(13),'') as colse_teller_id
      ,replace(replace(pty_typ_cd,chr(10),''),chr(13),'') as pty_typ_cd
      ,replace(replace(pty_blng_indu_cd,chr(10),''),chr(13),'') as pty_blng_indu_cd
      ,replace(replace(pty_loc_cd,chr(10),''),chr(13),'') as pty_loc_cd
      ,replace(replace(non_resident_flg,chr(10),''),chr(13),'') as non_resident_flg
      ,replace(replace(farmer_flg,chr(10),''),chr(13),'') as farmer_flg
      ,replace(replace(indv_indu_com_acct_flg,chr(10),''),chr(13),'') as indv_indu_com_acct_flg
      ,replace(replace(pty_status_cd,chr(10),''),chr(13),'') as pty_status_cd
      ,replace(replace(legal_name,chr(10),''),chr(13),'') as legal_name
      ,replace(replace(cn_fname,chr(10),''),chr(13),'') as cn_fname
      ,replace(replace(cn_sname,chr(10),''),chr(13),'') as cn_sname
      ,replace(replace(piny_name,chr(10),''),chr(13),'') as piny_name
      ,replace(replace(en_fname,chr(10),''),chr(13),'') as en_fname
      ,replace(replace(en_sname,chr(10),''),chr(13),'') as en_sname
      ,birth_dt
      ,replace(replace(gender_cd,chr(10),''),chr(13),'') as gender_cd
      ,replace(replace(birth_pla_cd,chr(10),''),chr(13),'') as birth_pla_cd
      ,replace(replace(native_place_cd,chr(10),''),chr(13),'') as native_place_cd
      ,replace(replace(nation_cd,chr(10),''),chr(13),'') as nation_cd
      ,replace(replace(ethnic_cd,chr(10),''),chr(13),'') as ethnic_cd
      ,replace(replace(poli_face_cd,chr(10),''),chr(13),'') as poli_face_cd
      ,replace(replace(reli_fai_cd,chr(10),''),chr(13),'') as reli_fai_cd
      ,replace(replace(marriage_status_cd,chr(10),''),chr(13),'') as marriage_status_cd
      ,replace(replace(highest_edu_degree_cd,chr(10),''),chr(13),'') as highest_edu_degree_cd
      ,replace(replace(highest_degree_cd,chr(10),''),chr(13),'') as highest_degree_cd
      ,replace(replace(grad_sch,chr(10),''),chr(13),'') as grad_sch
      ,replace(replace(reside_status_cd,chr(10),''),chr(13),'') as reside_status_cd
      ,join_work_tm
      ,replace(replace(work_corp_name,chr(10),''),chr(13),'') as work_corp_name
      ,join_enterprise_dt
      ,replace(replace(corp_blng_indu_cd,chr(10),''),chr(13),'') as corp_blng_indu_cd
      ,replace(replace(unit_addr,chr(10),''),chr(13),'') as unit_addr
      ,replace(replace(corp_loc_zipcode,chr(10),''),chr(13),'') as corp_loc_zipcode
      ,replace(replace(profsn_title_cd,chr(10),''),chr(13),'') as profsn_title_cd
      ,replace(replace(duty_cd,chr(10),''),chr(13),'') as duty_cd
      ,replace(replace(career_cd,chr(10),''),chr(13),'') as career_cd
      ,replace(replace(sala_acct_num,chr(10),''),chr(13),'') as sala_acct_num
      ,replace(replace(sala_acct_open_bank,chr(10),''),chr(13),'') as sala_acct_open_bank
      ,replace(replace(ghb_emp_flg,chr(10),''),chr(13),'') as ghb_emp_flg
      ,replace(replace(emp_id,chr(10),''),chr(13),'') as emp_id
      ,replace(replace(ghb_shrholder_flg,chr(10),''),chr(13),'') as ghb_shrholder_flg
      ,replace(replace(auth_mode_cd,chr(10),''),chr(13),'') as auth_mode_cd
      ,replace(replace(safe_rank_cd,chr(10),''),chr(13),'') as safe_rank_cd
      ,replace(replace(invt_risk_pref_cd,chr(10),''),chr(13),'') as invt_risk_pref_cd
      ,replace(replace(risk_ablt_est_org,chr(10),''),chr(13),'') as risk_ablt_est_org
      ,risk_ablt_est_dt
      ,raise_cnt
      ,family_anl_inc
      ,family_mon_income
      ,indv_mon_income
      ,indv_year_income
      ,replace(replace(car_brand,chr(10),''),chr(13),'') as car_brand
      ,replace(replace(blkl_pty_flg,chr(10),''),chr(13),'') as blkl_pty_flg
      ,up_blkl_dt
      ,replace(replace(up_blkl_rsns,chr(10),''),chr(13),'') as up_blkl_rsns
      ,replace(replace(blkl_src_cd,chr(10),''),chr(13),'') as blkl_src_cd
      ,replace(replace(prefr_cont_mode_cd,chr(10),''),chr(13),'') as prefr_cont_mode_cd
      ,replace(replace(bank_res_tel_num,chr(10),''),chr(13),'') as bank_res_tel_num
      ,replace(replace(crdt_pty_flg,chr(10),''),chr(13),'') as crdt_pty_flg
      ,replace(replace(small_eown_flg,chr(10),''),chr(13),'') as small_eown_flg
      ,replace(replace(open_card_typ_cd,chr(10),''),chr(13),'') as open_card_typ_cd
      ,replace(replace(pty_level_cd,chr(10),''),chr(13),'') as pty_level_cd
      ,replace(replace(real_nm_flg,chr(10),''),chr(13),'') as real_nm_flg
      ,replace(replace(co_brand_pty_flg,chr(10),''),chr(13),'') as co_brand_pty_flg
      ,replace(replace(insd_and_otsd_flg,chr(10),''),chr(13),'') as insd_and_otsd_flg
      ,replace(replace(assoc_txn_flg,chr(10),''),chr(13),'') as assoc_txn_flg
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg
      ,replace(replace(empl_typ_cd,chr(10),''),chr(13),'') as empl_typ_cd
      ,chdr_qtty
      ,replace(replace(own_local_e_state_flg,chr(10),''),chr(13),'') as own_local_e_state_flg
      ,replace(replace(own_car_flg,chr(10),''),chr(13),'') as own_car_flg
      ,replace(replace(sala_peop_flg,chr(10),''),chr(13),'') as sala_peop_flg
      ,replace(replace(civil_serv_flg,chr(10),''),chr(13),'') as civil_serv_flg 
from idl.hdws_dul_d_rpts_pty_indv_party_info 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_pty_indv_party_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes