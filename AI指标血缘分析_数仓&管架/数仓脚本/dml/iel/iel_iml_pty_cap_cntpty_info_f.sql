: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_cap_cntpty_info_f
CreateDate: 20230703
FileName:   ${iel_data_path}/pty_cap_cntpty_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t1.cntpty_abbr,chr(13),''),chr(10),'') as cntpty_abbr
,replace(replace(t1.cntpty_fname,chr(13),''),chr(10),'') as cntpty_fname
,replace(replace(t1.cntpty_en_abbr,chr(13),''),chr(10),'') as cntpty_en_abbr
,replace(replace(t1.cntpty_en_name,chr(13),''),chr(10),'') as cntpty_en_name
,replace(replace(t1.elec_cert_name,chr(13),''),chr(10),'') as elec_cert_name
,replace(replace(t1.elec_cert_id,chr(13),''),chr(10),'') as elec_cert_id
,replace(replace(t1.elec_cert_flg,chr(13),''),chr(10),'') as elec_cert_flg
,replace(replace(t1.intnal_rating_level_cd,chr(13),''),chr(10),'') as intnal_rating_level_cd
,replace(replace(t1.cotas_name,chr(13),''),chr(10),'') as cotas_name
,replace(replace(t1.tel_num,chr(13),''),chr(10),'') as tel_num
,replace(replace(t1.fax_num,chr(13),''),chr(10),'') as fax_num
,replace(replace(t1.issuer_flg,chr(13),''),chr(10),'') as issuer_flg
,replace(replace(t1.issuer_id,chr(13),''),chr(10),'') as issuer_id
,replace(replace(t1.guartor_flg,chr(13),''),chr(10),'') as guartor_flg
,replace(replace(t1.guartor_id,chr(13),''),chr(10),'') as guartor_id
,replace(replace(t1.fin_inst_flg,chr(13),''),chr(10),'') as fin_inst_flg
,replace(replace(t1.trust_org_flg,chr(13),''),chr(10),'') as trust_org_flg
,replace(replace(t1.indus_type_cd,chr(13),''),chr(10),'') as indus_type_cd
,replace(replace(t1.elec_ibank_no,chr(13),''),chr(10),'') as elec_ibank_no
,replace(replace(t1.pay_bk_bank_no,chr(13),''),chr(10),'') as pay_bk_bank_no
,replace(replace(t1.swift_id,chr(13),''),chr(10),'') as swift_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.pty_cap_cntpty_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_cap_cntpty_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
