: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_pty_cpes_mem_f
CreateDate: 20230829
FileName:   ${iel_data_path}/pty_cpes_mem.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.mem_id,chr(13),''),chr(10),'') as mem_id
,replace(replace(t1.mem_cd,chr(13),''),chr(10),'') as mem_cd
,replace(replace(t1.mem_org_cd,chr(13),''),chr(10),'') as mem_org_cd
,replace(replace(t1.mem_org_id,chr(13),''),chr(10),'') as mem_org_id
,replace(replace(t1.org_cate_cd,chr(13),''),chr(10),'') as org_cate_cd
,replace(replace(t1.org_lev_cd,chr(13),''),chr(10),'') as org_lev_cd
,replace(replace(t1.org_cn_fname,chr(13),''),chr(10),'') as org_cn_fname
,replace(replace(t1.org_en_fname,chr(13),''),chr(10),'') as org_en_fname
,replace(replace(t1.org_cn_abbr,chr(13),''),chr(10),'') as org_cn_abbr
,replace(replace(t1.org_en_abbr,chr(13),''),chr(10),'') as org_en_abbr
,replace(replace(t1.unify_soci_crdt_cd,chr(13),''),chr(10),'') as unify_soci_crdt_cd
,replace(replace(t1.dist_cd,chr(13),''),chr(10),'') as dist_cd
,replace(replace(t1.lp_lev_cd,chr(13),''),chr(10),'') as lp_lev_cd
,replace(replace(t1.org_hibchy_cd,chr(13),''),chr(10),'') as org_hibchy_cd
,prod_valid_dt
,prod_invalid_dt
,replace(replace(t1.org_status_cd,chr(13),''),chr(10),'') as org_status_cd
,replace(replace(t1.org_intnal_acct_name,chr(13),''),chr(10),'') as org_intnal_acct_name
,replace(replace(t1.org_intnal_acct_num,chr(13),''),chr(10),'') as org_intnal_acct_num
,replace(replace(t1.tran_acct_num,chr(13),''),chr(10),'') as tran_acct_num
,replace(replace(t1.tran_acct_status_cd,chr(13),''),chr(10),'') as tran_acct_status_cd
,replace(replace(t1.trust_acct_num,chr(13),''),chr(10),'') as trust_acct_num
,replace(replace(t1.trust_acct_status_cd,chr(13),''),chr(10),'') as trust_acct_status_cd
,replace(replace(t1.cpes_cap_acct_num,chr(13),''),chr(10),'') as cpes_cap_acct_num
,replace(replace(t1.cpes_cap_acct_status_cd,chr(13),''),chr(10),'') as cpes_cap_acct_status_cd
,replace(replace(t1.legal_rep_or_princ,chr(13),''),chr(10),'') as legal_rep_or_princ
,replace(replace(t1.wdraw_acct_lg_pay_sys_bank_no,chr(13),''),chr(10),'') as wdraw_acct_lg_pay_sys_bank_no
,replace(replace(t1.wdraw_acct_name,chr(13),''),chr(10),'') as wdraw_acct_name
,replace(replace(t1.wdraw_acct_num,chr(13),''),chr(10),'') as wdraw_acct_num
,rgst_cap
,replace(replace(t1.addr,chr(13),''),chr(10),'') as addr
,replace(replace(t1.cotas,chr(13),''),chr(10),'') as cotas
,replace(replace(t1.phone,chr(13),''),chr(10),'') as phone
,replace(replace(t1.fax,chr(13),''),chr(10),'') as fax
,replace(replace(t1.zip_cd,chr(13),''),chr(10),'') as zip_cd
,replace(replace(t1.sys_prtcptr_bigamt_bank_no,chr(13),''),chr(10),'') as sys_prtcptr_bigamt_bank_no
,replace(replace(t1.sys_prtcptr_bigamt_bank_name,chr(13),''),chr(10),'') as sys_prtcptr_bigamt_bank_name
,replace(replace(t1.ele_bill_agent_bigamt_bank_no,chr(13),''),chr(10),'') as ele_bill_agent_bigamt_bank_no
,replace(replace(t1.ele_bill_agent_bigamt_acct_num,chr(13),''),chr(10),'') as ele_bill_agent_bigamt_acct_num
,replace(replace(t1.udtake_org_cd,chr(13),''),chr(10),'') as udtake_org_cd
,create_dt
,update_dt

from ${iml_schema}.pty_cpes_mem t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_cpes_mem.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
