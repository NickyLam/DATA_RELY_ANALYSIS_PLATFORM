: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_role_rela_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_role_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,t1.party_rela_type_cd as party_rela_type_cd
,t1.rela_party_id as rela_party_id
,replace(replace(t1.party_role_type_id,chr(13),''),chr(10),'') as party_role_type_id
,replace(replace(t1.rela_party_role_type_id,chr(13),''),chr(10),'') as rela_party_role_type_id
,replace(replace(t1.effect_tm,chr(13),''),chr(10),'') as effect_tm
,replace(replace(t1.invalid_tm,chr(13),''),chr(10),'') as invalid_tm
,replace(replace(t1.share_ratio,chr(13),''),chr(10),'') as share_ratio
,replace(replace(t1.shard_id,chr(13),''),chr(10),'') as shard_id
,replace(replace(t1.shard_type_cd,chr(13),''),chr(10),'') as shard_type_cd
,replace(replace(t1.contri_amt,chr(13),''),chr(10),'') as contri_amt
,replace(replace(t1.ctrler_idf_cd,chr(13),''),chr(10),'') as ctrler_idf_cd
,replace(replace(t1.ctrler_red_idti_type_cd,chr(13),''),chr(10),'') as ctrler_red_idti_type_cd
,replace(replace(t1.ctrler_birth_dt,chr(13),''),chr(10),'') as ctrler_birth_dt
,replace(replace(t1.ctrler_cn_birth_addr,chr(13),''),chr(10),'') as ctrler_cn_birth_addr
,replace(replace(t1.ctrler_cn_resd_addr,chr(13),''),chr(10),'') as ctrler_cn_resd_addr
,replace(replace(t1.ctrler_tax_red_cty,chr(13),''),chr(10),'') as ctrler_tax_red_cty
,replace(replace(t1.ctrler_tax_num,chr(13),''),chr(10),'') as ctrler_tax_num
,replace(replace(t1.ctrler_tax_null_rs_descb,chr(13),''),chr(10),'') as ctrler_tax_null_rs_descb
,replace(replace(t1.stament_flg,chr(13),''),chr(10),'') as stament_flg
,replace(replace(t1.ctrler_type_cd,chr(13),''),chr(10),'') as ctrler_type_cd
,replace(replace(t1.ctrler_name,chr(13),''),chr(10),'') as ctrler_name
,replace(replace(t1.ctrler_en_birth_addr,chr(13),''),chr(10),'') as ctrler_en_birth_addr
,replace(replace(t1.ctrler_en_resd_addr,chr(13),''),chr(10),'') as ctrler_en_resd_addr
,replace(replace(t1.start_dt,chr(13),''),chr(10),'') as start_dt
,replace(replace(t1.end_dt,chr(13),''),chr(10),'') as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.pty_role_rela_h t1
where t1.start_dt <=to_date('${batch_date}','yyyymmdd') and t1.end_dt >to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_role_rela_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes