: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_corp_ctrler_tax_h_f
CreateDate: 20241230
FileName:   ${iel_data_path}/pty_corp_ctrler_tax_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.rela_party_id,chr(13),''),chr(10),'') as rela_party_id
,replace(replace(t1.ctrler_type_cd,chr(13),''),chr(10),'') as ctrler_type_cd
,replace(replace(t1.ctrler_cert_type_cd,chr(13),''),chr(10),'') as ctrler_cert_type_cd
,replace(replace(t1.ctrler_cert_no,chr(13),''),chr(10),'') as ctrler_cert_no
,replace(replace(t1.ctrler_name,chr(13),''),chr(10),'') as ctrler_name
,replace(replace(t1.ctrler_legal_en_last_name,chr(13),''),chr(10),'') as ctrler_legal_en_last_name
,replace(replace(t1.ctrler_en_mdl_name,chr(13),''),chr(10),'') as ctrler_en_mdl_name
,replace(replace(t1.ctrler_legal_en_first_name,chr(13),''),chr(10),'') as ctrler_legal_en_first_name
,replace(replace(t1.ctrler_tax_red_cty_cd_comb,chr(13),''),chr(10),'') as ctrler_tax_red_cty_cd_comb
,replace(replace(t1.get_stament_flg,chr(13),''),chr(10),'') as get_stament_flg
,replace(replace(t1.tax_num,chr(13),''),chr(10),'') as tax_num
,replace(replace(t1.distr_idtfy_num_cty_cd_comb,chr(13),''),chr(10),'') as distr_idtfy_num_cty_cd_comb
,replace(replace(t1.tax_num_null_rs_descb,chr(13),''),chr(10),'') as tax_num_null_rs_descb
,replace(replace(t1.ctrler_birth_city_name,chr(13),''),chr(10),'') as ctrler_birth_city_name
,replace(replace(t1.birth_cty_home_and_rg_cd,chr(13),''),chr(10),'') as birth_cty_home_and_rg_cd
,replace(replace(t1.ctrler_birth_cty_en_name,chr(13),''),chr(10),'') as ctrler_birth_cty_en_name
,replace(replace(t1.ctrler_cn_birth_addr,chr(13),''),chr(10),'') as ctrler_cn_birth_addr
,replace(replace(t1.ctrler_cn_resd_addr,chr(13),''),chr(10),'') as ctrler_cn_resd_addr
,replace(replace(t1.ctrler_en_resd_addr,chr(13),''),chr(10),'') as ctrler_en_resd_addr
,ctrler_birth_dt
,replace(replace(t1.tax_resdnt_idti_cd,chr(13),''),chr(10),'') as tax_resdnt_idti_cd
,cert_invalid_dt
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.pty_corp_ctrler_tax_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_corp_ctrler_tax_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
