: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_pcrs_pty_indv_pty_lnkm_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_pcrs_pty_indv_pty_lnkm_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,t1.etl_dt as etl_dt
,replace(replace(t1.indv_pty_assoc_typ_cd,chr(13),''),chr(10),'') as indv_pty_assoc_typ_cd
,replace(replace(t1.lnkm_pty_id,chr(13),''),chr(10),'') as lnkm_pty_id
,replace(replace(t1.lnkm_name,chr(13),''),chr(10),'') as lnkm_name
,replace(replace(t1.lnkm_iden_typ_cd,chr(13),''),chr(10),'') as lnkm_iden_typ_cd
,replace(replace(t1.lnkm_iden_num,chr(13),''),chr(10),'') as lnkm_iden_num
,replace(replace(t1.lnkm_etpr_pty_id,chr(13),''),chr(10),'') as lnkm_etpr_pty_id
,replace(replace(t1.lnkm_etpr_fname,chr(13),''),chr(10),'') as lnkm_etpr_fname
,replace(replace(t1.lnkm_tel_intl_phone_cty_cd,chr(13),''),chr(10),'') as lnkm_tel_intl_phone_cty_cd
,replace(replace(t1.lnkm_dom_tel_area_cd,chr(13),''),chr(10),'') as lnkm_dom_tel_area_cd
,replace(replace(t1.lnkm_tel_num,chr(13),''),chr(10),'') as lnkm_tel_num
,replace(replace(t1.lnkm_tel_ext,chr(13),''),chr(10),'') as lnkm_tel_ext
,replace(replace(t1.lnkm_ceph_intl_phone_cty_cd,chr(13),''),chr(10),'') as lnkm_ceph_intl_phone_cty_cd
,replace(replace(t1.lnkm_ceph_num,chr(13),''),chr(10),'') as lnkm_ceph_num
,replace(replace(t1.lnkm_work_unt_loc,chr(13),''),chr(10),'') as lnkm_work_unt_loc
,replace(replace(t1.lnkm_work_corp_tel,chr(13),''),chr(10),'') as lnkm_work_corp_tel
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
from ${idl_schema}.hdws_dul_d_pcrs_pty_indv_pty_lnkm_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_pcrs_pty_indv_pty_lnkm_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes