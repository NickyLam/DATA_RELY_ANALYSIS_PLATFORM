: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_pty_corp_pty_lnkm_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_pty_corp_pty_lnkm_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,replace(replace(t1.lnkm_typ_cd,chr(13),''),chr(10),'') as lnkm_typ_cd
,replace(replace(t1.lnkm_pty_num,chr(13),''),chr(10),'') as lnkm_pty_num
,replace(replace(t1.lnkm_name,chr(13),''),chr(10),'') as lnkm_name
,replace(replace(t1.lnkm_cty_cd,chr(13),''),chr(10),'') as lnkm_cty_cd
,replace(replace(t1.lnkm_iden_typ_cd,chr(13),''),chr(10),'') as lnkm_iden_typ_cd
,replace(replace(t1.lnkm_other_iden_num,chr(13),''),chr(10),'') as lnkm_other_iden_num
,t1.lnkm_iden_eff_dt as lnkm_iden_eff_dt
,t1.lnkm_iden_due_dt as lnkm_iden_due_dt
,replace(replace(t1.lnkm_highest_edu_degree_cd,chr(13),''),chr(10),'') as lnkm_highest_edu_degree_cd
,replace(replace(t1.lnkm_work_resume,chr(13),''),chr(10),'') as lnkm_work_resume
,replace(replace(t1.dept_name,chr(13),''),chr(10),'') as dept_name
,replace(replace(t1.duty_cd,chr(13),''),chr(10),'') as duty_cd
,replace(replace(t1.seni_flg,chr(13),''),chr(10),'') as seni_flg
,replace(replace(t1.ghb_shrholder_flg,chr(13),''),chr(10),'') as ghb_shrholder_flg
,replace(replace(t1.lp_rprs_flg,chr(13),''),chr(10),'') as lp_rprs_flg
,replace(replace(t1.lnkm_tel_intl_phone_cty_cd,chr(13),''),chr(10),'') as lnkm_tel_intl_phone_cty_cd
,replace(replace(t1.lnkm_dom_tel_area_cd,chr(13),''),chr(10),'') as lnkm_dom_tel_area_cd
,replace(replace(t1.lnkm_tel_num,chr(13),''),chr(10),'') as lnkm_tel_num
,replace(replace(t1.lnkm_tel_ext,chr(13),''),chr(10),'') as lnkm_tel_ext
,replace(replace(t1.lnkm_ceph_intl_phone_cty_cd,chr(13),''),chr(10),'') as lnkm_ceph_intl_phone_cty_cd
,replace(replace(t1.lnkm_ceph_num,chr(13),''),chr(10),'') as lnkm_ceph_num
,replace(replace(t1.lnkm_work_unt_loc,chr(13),''),chr(10),'') as lnkm_work_unt_loc
,replace(replace(t1.lnkm_work_corp_tel,chr(13),''),chr(10),'') as lnkm_work_corp_tel
,t1.reg_dt as reg_dt
,t1.upda_dt as upda_dt
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'PTY_CORP_PTY_LNKM_INFO_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'PTY_CORP_PTY_LNKM_INFO_H') as etl_task_name 
,replace(replace(t1.lnkm_en_name,chr(13),''),chr(10),'') as lnkm_en_name
,replace(replace(t1.lnkm_self_cert_decl_flg,chr(13),''),chr(10),'') as lnkm_self_cert_decl_flg
,replace(replace(t1.lnkm_rvn_resd_iden_cd,chr(13),''),chr(10),'') as lnkm_rvn_resd_iden_cd
,t1.lnkm_birth_dt as lnkm_birth_dt
,replace(replace(t1.lnkm_cn_birth_loc,chr(13),''),chr(10),'') as lnkm_cn_birth_loc
,replace(replace(t1.lnkm_en_birth_loc,chr(13),''),chr(10),'') as lnkm_en_birth_loc
,replace(replace(t1.lnkm_cn_resi_loc,chr(13),''),chr(10),'') as lnkm_cn_resi_loc
,replace(replace(t1.lnkm_en_resi_loc,chr(13),''),chr(10),'') as lnkm_en_resi_loc
,replace(replace(t1.ctrler_typ_cd,chr(13),''),chr(10),'') as ctrler_typ_cd
,replace(replace(t1.lnkm_en_sur,chr(13),''),chr(10),'') as lnkm_en_sur
,replace(replace(t1.lnkm_duty_name,chr(13),''),chr(10),'') as lnkm_duty_name
from ${idl_schema}.hdws_iml_pty_corp_pty_lnkm_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_pty_corp_pty_lnkm_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes