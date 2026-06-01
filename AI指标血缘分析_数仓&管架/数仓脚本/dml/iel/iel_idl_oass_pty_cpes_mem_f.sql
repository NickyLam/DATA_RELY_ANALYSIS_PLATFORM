: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_pty_cpes_mem_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_pty_cpes_mem.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.mem_id as mem_id
,t1.mem_cd as mem_cd
,t1.mem_org_cd as mem_org_cd
,t1.mem_org_id as mem_org_id
,t1.org_cate_cd as org_cate_cd
,t1.org_lev_cd as org_lev_cd
,t1.org_cn_fname as org_cn_fname
,t1.org_en_fname as org_en_fname
,t1.org_cn_abbr as org_cn_abbr
,t1.org_en_abbr as org_en_abbr
,t1.unify_soci_crdt_cd as unify_soci_crdt_cd
,t1.dist_cd as dist_cd
,t1.lp_lev_cd as lp_lev_cd
,t1.org_hibchy_cd as org_hibchy_cd
,t1.prod_valid_dt as prod_valid_dt
,t1.prod_invalid_dt as prod_invalid_dt
,t1.org_status_cd as org_status_cd
,t1.org_intnal_acct_name as org_intnal_acct_name
,t1.org_intnal_acct_num as org_intnal_acct_num
,t1.tran_acct_num as tran_acct_num
,t1.tran_acct_status_cd as tran_acct_status_cd
,t1.trust_acct_num as trust_acct_num
,t1.trust_acct_status_cd as trust_acct_status_cd
,t1.cpes_cap_acct_num as cpes_cap_acct_num
,t1.cpes_cap_acct_status_cd as cpes_cap_acct_status_cd
,t1.legal_rep_or_princ as legal_rep_or_princ
,t1.wdraw_acct_lg_pay_sys_bank_no as wdraw_acct_lg_pay_sys_bank_no
,t1.wdraw_acct_name as wdraw_acct_name
,t1.wdraw_acct_num as wdraw_acct_num
,t1.rgst_cap as rgst_cap
,t1.addr as addr
,t1.cotas as cotas
,t1.phone as phone
,t1.fax as fax
,t1.zip_cd as zip_cd
,t1.sys_prtcptr_bigamt_bank_no as sys_prtcptr_bigamt_bank_no
,t1.sys_prtcptr_bigamt_bank_name as sys_prtcptr_bigamt_bank_name
,t1.ele_bill_agent_bigamt_bank_no as ele_bill_agent_bigamt_bank_no
,t1.ele_bill_agent_bigamt_acct_num as ele_bill_agent_bigamt_acct_num
,t1.udtake_org_cd as udtake_org_cd
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.party_id as party_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_pty_cpes_mem t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_pty_cpes_mem.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
