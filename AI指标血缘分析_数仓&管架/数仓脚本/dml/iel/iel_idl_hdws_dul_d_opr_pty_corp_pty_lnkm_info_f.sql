: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_opr_pty_corp_pty_lnkm_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_opr_pty_corp_pty_lnkm_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,etl_dt
      ,replace(replace(lnkm_typ_cd,chr(10),''),chr(13),'') as lnkm_typ_cd
      ,replace(replace(lnkm_pty_num,chr(10),''),chr(13),'') as lnkm_pty_num
      ,replace(replace(lnkm_name,chr(10),''),chr(13),'') as lnkm_name
      ,replace(replace(lnkm_cty_cd,chr(10),''),chr(13),'') as lnkm_cty_cd
      ,replace(replace(lnkm_iden_typ_cd,chr(10),''),chr(13),'') as lnkm_iden_typ_cd
      ,replace(replace(lnkm_other_iden_num,chr(10),''),chr(13),'') as lnkm_other_iden_num
      ,lnkm_iden_eff_dt
      ,lnkm_iden_due_dt
      ,replace(replace(lnkm_highest_edu_degree_cd,chr(10),''),chr(13),'') as lnkm_highest_edu_degree_cd
      ,replace(replace(lnkm_work_resume,chr(10),''),chr(13),'') as lnkm_work_resume
      ,replace(replace(dept_name,chr(10),''),chr(13),'') as dept_name
      ,replace(replace(duty_cd,chr(10),''),chr(13),'') as duty_cd
      ,replace(replace(seni_flg,chr(10),''),chr(13),'') as seni_flg
      ,replace(replace(ghb_shrholder_flg,chr(10),''),chr(13),'') as ghb_shrholder_flg
      ,replace(replace(lp_rprs_flg,chr(10),''),chr(13),'') as lp_rprs_flg
      ,replace(replace(lnkm_tel_intl_phone_cty_cd,chr(10),''),chr(13),'') as lnkm_tel_intl_phone_cty_cd
      ,replace(replace(lnkm_dom_tel_area_cd,chr(10),''),chr(13),'') as lnkm_dom_tel_area_cd
      ,replace(replace(lnkm_tel_num,chr(10),''),chr(13),'') as lnkm_tel_num
      ,replace(replace(lnkm_tel_ext,chr(10),''),chr(13),'') as lnkm_tel_ext
      ,replace(replace(lnkm_ceph_intl_phone_cty_cd,chr(10),''),chr(13),'') as lnkm_ceph_intl_phone_cty_cd
      ,replace(replace(lnkm_ceph_num,chr(10),''),chr(13),'') as lnkm_ceph_num
      ,replace(replace(lnkm_work_unt_loc,chr(10),''),chr(13),'') as lnkm_work_unt_loc
      ,replace(replace(lnkm_work_corp_tel,chr(10),''),chr(13),'') as lnkm_work_corp_tel
      ,reg_dt
      ,upda_dt
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd 
from idl.hdws_dul_d_opr_pty_corp_pty_lnkm_info 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_opr_pty_corp_pty_lnkm_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes