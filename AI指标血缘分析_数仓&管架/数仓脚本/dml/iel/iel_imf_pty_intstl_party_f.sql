: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_pty_intstl_party_f
CreateDate: 20250211
FileName:   ${iel_data_path}/pty_intstl_party.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cn_name,chr(13),''),chr(10),'') as cn_name
,replace(replace(t1.intstl_cust_type_cd_comb,chr(13),''),chr(10),'') as intstl_cust_type_cd_comb
,replace(replace(t1.hq_party_id,chr(13),''),chr(10),'') as hq_party_id
,replace(replace(t1.nation_crdt_level_cd,chr(13),''),chr(10),'') as nation_crdt_level_cd
,replace(replace(t1.risk_level_cd,chr(13),''),chr(10),'') as risk_level_cd
,replace(replace(t1.risk_cty_cd,chr(13),''),chr(10),'') as risk_cty_cd
,replace(replace(t1.trans_lang_cd,chr(13),''),chr(10),'') as trans_lang_cd
,replace(replace(t1.edit_id,chr(13),''),chr(10),'') as edit_id
,replace(replace(t1.serv_level_cd,chr(13),''),chr(10),'') as serv_level_cd
,replace(replace(t1.enty_group_id,chr(13),''),chr(10),'') as enty_group_id
,replace(replace(t1.orgnz_cd,chr(13),''),chr(10),'') as orgnz_cd
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.resdnt_type_cd,chr(13),''),chr(10),'') as resdnt_type_cd
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.tran_main_cd,chr(13),''),chr(10),'') as tran_main_cd
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.src_party_id,chr(13),''),chr(10),'') as src_party_id
,replace(replace(t1.cbec_flg,chr(13),''),chr(10),'') as cbec_flg

from ${iml_schema}.pty_intstl_party t1
where create_dt <= to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_intstl_party.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
