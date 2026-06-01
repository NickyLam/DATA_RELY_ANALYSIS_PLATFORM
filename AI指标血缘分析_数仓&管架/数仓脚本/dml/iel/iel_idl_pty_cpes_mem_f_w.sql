: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pty_cpes_mem_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_cpes_mem_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt
,t.party_id
,t.lp_id
,t.mem_id
,t.mem_cd
,t.mem_org_cd
,t.mem_org_id
,t.org_cate_cd
,t.org_lev_cd
,t.org_cn_fname
,t.org_en_fname
,t.org_cn_abbr
,t.org_en_abbr
,t.unify_soci_crdt_cd
,t.dist_cd
,t.lp_lev_cd
,t.org_hibchy_cd
,t.prod_valid_dt
,t.prod_invalid_dt
,t.org_status_cd
,t.org_intnal_acct_name
,t.org_intnal_acct_num
,t.tran_acct_num
,t.tran_acct_status_cd
,t.trust_acct_num
,t.trust_acct_status_cd
,t.cpes_cap_acct_num
,t.cpes_cap_acct_status_cd
,t.legal_rep_or_princ
,t.wdraw_acct_lg_pay_sys_bank_no
,t.wdraw_acct_name
,t.wdraw_acct_num
,t.rgst_cap
,t.addr
,t.cotas
,t.phone
,t.fax
,t.zip_cd
,t.sys_prtcptr_bigamt_bank_no
,t.sys_prtcptr_bigamt_bank_name
,t.ele_bill_agent_bigamt_bank_no
,t.ele_bill_agent_bigamt_acct_num
,t.udtake_org_cd
,t.create_dt
,t.update_dt
,t.id_mark
,t.job_cd
from ${idl_schema}.pty_cpes_mem t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_cpes_mem_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes