: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_mims_coll_pty_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_mims_coll_pty_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,replace(replace(t1.legal_name,chr(13),''),chr(10),'') as legal_name
,replace(replace(t1.pty_typ_cd,chr(13),''),chr(10),'') as pty_typ_cd
,replace(replace(t1.crdt_rat_resu_cd,chr(13),''),chr(10),'') as crdt_rat_resu_cd
,replace(replace(t1.blng_pty_mgr_id,chr(13),''),chr(10),'') as blng_pty_mgr_id
,replace(replace(t1.blng_org_id,chr(13),''),chr(10),'') as blng_org_id
,replace(replace(t1.pty_loc_cd,chr(13),''),chr(10),'') as pty_loc_cd
,replace(replace(t1.corp_size_gb_cd,chr(13),''),chr(10),'') as corp_size_gb_cd
,replace(replace(t1.corp_size_hb_cd,chr(13),''),chr(10),'') as corp_size_hb_cd
,replace(replace(t1.indu_typ_cd_gb,chr(13),''),chr(10),'') as indu_typ_cd_gb
,replace(replace(t1.org_cn_full_name,chr(13),''),chr(10),'') as org_cn_full_name
,replace(replace(t1.iden_typ_cd,chr(13),''),chr(10),'') as iden_typ_cd
,replace(replace(t1.iden_num,chr(13),''),chr(10),'') as iden_num
,replace(replace(t1.cbss_pty_id,chr(13),''),chr(10),'') as cbss_pty_id
,t1.estab_dt as estab_dt
,replace(replace(t1.ecif_pty_id,chr(13),''),chr(10),'') as ecif_pty_id
,replace(replace(t1.reg_cty_cd,chr(13),''),chr(10),'') as reg_cty_cd
,replace(replace(t1.line_cd,chr(13),''),chr(10),'') as line_cd
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
from ${idl_schema}.hdws_dul_d_mims_coll_pty_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_mims_coll_pty_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes