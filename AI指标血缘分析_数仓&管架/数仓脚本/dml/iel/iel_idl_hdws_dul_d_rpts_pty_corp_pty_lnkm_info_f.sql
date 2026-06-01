: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_pty_corp_pty_lnkm_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_pty_corp_pty_lnkm_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
pty_id
,etl_dt
,lnkm_typ_cd
,lnkm_pty_num
,lnkm_name
,lnkm_cty_cd
,lnkm_iden_typ_cd
,lnkm_other_iden_num
,lnkm_iden_eff_dt
,lnkm_iden_due_dt
,lnkm_highest_edu_degree_cd
,lnkm_work_resume
,dept_name
,duty_cd
,seni_flg
,ghb_shrholder_flg
,lp_rprs_flg
,lnkm_tel_intl_phone_cty_cd
,lnkm_dom_tel_area_cd
,lnkm_tel_num
,lnkm_tel_ext
,lnkm_ceph_intl_phone_cty_cd
,lnkm_ceph_num
,lnkm_work_unt_loc
,lnkm_work_corp_tel
,reg_dt
,upda_dt
,data_src_cd
from ${idl_schema}.hdws_dul_d_rpts_pty_corp_pty_lnkm_info 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_pty_corp_pty_lnkm_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes