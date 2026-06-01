: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_pty_indv_pty_lnkm_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_pty_indv_pty_lnkm_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,etl_dt
      ,replace(replace(indv_pty_assoc_typ_cd,chr(10),''),chr(13),'') as indv_pty_assoc_typ_cd
      ,replace(replace(lnkm_pty_id,chr(10),''),chr(13),'') as lnkm_pty_id
      ,replace(replace(lnkm_name,chr(10),''),chr(13),'') as lnkm_name
      ,replace(replace(lnkm_iden_typ_cd,chr(10),''),chr(13),'') as lnkm_iden_typ_cd
      ,replace(replace(lnkm_iden_num,chr(10),''),chr(13),'') as lnkm_iden_num
      ,replace(replace(lnkm_etpr_pty_id,chr(10),''),chr(13),'') as lnkm_etpr_pty_id
      ,replace(replace(lnkm_etpr_fname,chr(10),''),chr(13),'') as lnkm_etpr_fname
      ,replace(replace(lnkm_tel_intl_phone_cty_cd,chr(10),''),chr(13),'') as lnkm_tel_intl_phone_cty_cd
      ,replace(replace(lnkm_dom_tel_area_cd,chr(10),''),chr(13),'') as lnkm_dom_tel_area_cd
      ,replace(replace(lnkm_tel_num,chr(10),''),chr(13),'') as lnkm_tel_num
      ,replace(replace(lnkm_tel_ext,chr(10),''),chr(13),'') as lnkm_tel_ext
      ,replace(replace(lnkm_ceph_intl_phone_cty_cd,chr(10),''),chr(13),'') as lnkm_ceph_intl_phone_cty_cd
      ,replace(replace(lnkm_ceph_num,chr(10),''),chr(13),'') as lnkm_ceph_num
      ,replace(replace(lnkm_work_unt_loc,chr(10),''),chr(13),'') as lnkm_work_unt_loc
      ,replace(replace(lnkm_work_corp_tel,chr(10),''),chr(13),'') as lnkm_work_corp_tel
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg 
from idl.hdws_dul_d_rpts_pty_indv_pty_lnkm_info 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_pty_indv_pty_lnkm_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes