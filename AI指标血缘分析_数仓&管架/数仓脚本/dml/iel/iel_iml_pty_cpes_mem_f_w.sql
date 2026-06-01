: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_cpes_mem_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_cpes_mem_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
        t1.etl_dt as etl_dt
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
,t1.prod_valid_dt as prod_valid_dt
,t1.prod_invalid_dt as prod_invalid_dt
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
,t1.rgst_cap as rgst_cap
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
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name
,replace(replace(t1.job_cd,chr(13),''),chr(10),'') as job_cd
from ${iml_schema}.pty_cpes_mem t1 
where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_cpes_mem_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes