: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_rela_party_basic_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_rela_party_basic_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.party_name,chr(13),''),chr(10),'') as party_name
,replace(replace(t1.party_type_cd,chr(13),''),chr(10),'') as party_type_cd
,replace(replace(t1.party_cert_type_cd_1,chr(13),''),chr(10),'') as party_cert_type_cd_1
,replace(replace(t1.party_cert_id_1,chr(13),''),chr(10),'') as party_cert_id_1
,replace(replace(t1.party_cert_type_cd_2,chr(13),''),chr(10),'') as party_cert_type_cd_2
,replace(replace(t1.party_cert_id_2,chr(13),''),chr(10),'') as party_cert_id_2
,replace(replace(t1.party_belong_org_id,chr(13),''),chr(10),'') as party_belong_org_id
,replace(replace(t1.party_belong_dept_id,chr(13),''),chr(10),'') as party_belong_dept_id
,replace(replace(t1.party_kins_rela_cd,chr(13),''),chr(10),'') as party_kins_rela_cd
,replace(replace(t1.party_org_cd,chr(13),''),chr(10),'') as party_org_cd
,replace(replace(t1.party_belong_corp_name,chr(13),''),chr(10),'') as party_belong_corp_name
,replace(replace(t1.party_post_name,chr(13),''),chr(10),'') as party_post_name
,replace(replace(t1.party_ghb_post_name,chr(13),''),chr(10),'') as party_ghb_post_name
,replace(replace(t1.party_share_ratio,chr(13),''),chr(10),'') as party_share_ratio
,replace(replace(t1.rela_type_cd,chr(13),''),chr(10),'') as rela_type_cd
,replace(replace(t1.rela_status_cd,chr(13),''),chr(10),'') as rela_status_cd
,replace(replace(t1.rela_party_id,chr(13),''),chr(10),'') as rela_party_id
,replace(replace(t1.rela_party_name,chr(13),''),chr(10),'') as rela_party_name
,replace(replace(t1.rela_party_cert_type_cd_1,chr(13),''),chr(10),'') as rela_party_cert_type_cd_1
,replace(replace(t1.rela_party_cert_id_1,chr(13),''),chr(10),'') as rela_party_cert_id_1
,replace(replace(t1.rela_party_cert_type_cd_2,chr(13),''),chr(10),'') as rela_party_cert_type_cd_2
,replace(replace(t1.rela_party_cert_id_2,chr(13),''),chr(10),'') as rela_party_cert_id_2
,replace(replace(t1.rela_party_belong_org_id,chr(13),''),chr(10),'') as rela_party_belong_org_id
,replace(replace(t1.rela_party_belong_dept_id,chr(13),''),chr(10),'') as rela_party_belong_dept_id
,replace(replace(t1.rela_party_kins_rela_cd,chr(13),''),chr(10),'') as rela_party_kins_rela_cd
,replace(replace(t1.rela_party_org_cd,chr(13),''),chr(10),'') as rela_party_org_cd
,replace(replace(t1.rela_party_belong_corp_name,chr(13),''),chr(10),'') as rela_party_belong_corp_name
,replace(replace(t1.rela_party_post_name,chr(13),''),chr(10),'') as rela_party_post_name
,replace(replace(t1.rela_party_ghb_post_name,chr(13),''),chr(10),'') as rela_party_ghb_post_name
,replace(replace(t1.rela_party_share_ratio,chr(13),''),chr(10),'') as rela_party_share_ratio
,replace(replace(t1.party_dom_overs_flg,chr(13),''),chr(10),'') as party_dom_overs_flg
,t1.rela_effect_dt as rela_effect_dt
,t1.rela_invalid_dt as rela_invalid_dt
,replace(replace(t1.rela_party_dom_overs_flg,chr(13),''),chr(10),'') as rela_party_dom_overs_flg
,replace(replace(t1.shard_or_rela_party_type_cd,chr(13),''),chr(10),'') as shard_or_rela_party_type_cd
,replace(replace(t1.shard_or_rela_party_bl_induty_cd,chr(13),''),chr(10),'') as shard_or_rela_party_bl_induty_cd
,replace(replace(t1.shard_or_rela_party_rgst_addr,chr(13),''),chr(10),'') as shard_or_rela_party_rgst_addr
,replace(replace(t1.shard_or_rela_party_rela_type_cd,chr(13),''),chr(10),'') as shard_or_rela_party_rela_type_cd
from ${icl_schema}.cmm_rela_party_basic_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_rela_party_basic_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes