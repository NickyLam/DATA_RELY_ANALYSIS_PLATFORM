: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_fcurr_bond_party_f
CreateDate: 20241022
FileName:   ${iel_data_path}/pty_fcurr_bond_party.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t1.super_party_id,chr(13),''),chr(10),'') as super_party_id
,replace(replace(t1.dc_elec_cert_id,chr(13),''),chr(10),'') as dc_elec_cert_id
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t1.lp_name,chr(13),''),chr(10),'') as lp_name
,replace(replace(t1.tel_num,chr(13),''),chr(10),'') as tel_num
,replace(replace(t1.fax_num,chr(13),''),chr(10),'') as fax_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.intnal_crdt_rating_id,chr(13),''),chr(10),'') as intnal_crdt_rating_id
,replace(replace(t1.intnal_crdt_rating_name,chr(13),''),chr(10),'') as intnal_crdt_rating_name
,replace(replace(t1.ibank_no,chr(13),''),chr(10),'') as ibank_no
,replace(replace(t1.lg_pay_sys_bank_no,chr(13),''),chr(10),'') as lg_pay_sys_bank_no
,replace(replace(t1.issuer_id,chr(13),''),chr(10),'') as issuer_id
,replace(replace(t1.issuer_flg,chr(13),''),chr(10),'') as issuer_flg
,replace(replace(t1.fin_inst_flg,chr(13),''),chr(10),'') as fin_inst_flg
,replace(replace(t1.guartor_flg,chr(13),''),chr(10),'') as guartor_flg
,replace(replace(t1.trust_org_flg,chr(13),''),chr(10),'') as trust_org_flg
,replace(replace(t1.dc_mem_cd,chr(13),''),chr(10),'') as dc_mem_cd
,replace(replace(t1.mem_src_cd,chr(13),''),chr(10),'') as mem_src_cd
,replace(replace(t1.parent_corp_flg,chr(13),''),chr(10),'') as parent_corp_flg
,replace(replace(t1.parent_corp_group_id,chr(13),''),chr(10),'') as parent_corp_group_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,create_dt
,update_dt

from ${iml_schema}.pty_fcurr_bond_party t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_fcurr_bond_party.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
