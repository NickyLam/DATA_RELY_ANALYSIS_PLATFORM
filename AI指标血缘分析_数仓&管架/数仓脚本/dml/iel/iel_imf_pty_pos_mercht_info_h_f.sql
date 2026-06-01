: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_pty_pos_mercht_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_pos_mercht_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.mercht_seq_num,chr(13),''),chr(10),'') as mercht_seq_num
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.mercht_id,chr(13),''),chr(10),'') as mercht_id
    ,replace(replace(t.mercht_cn_abbr,chr(13),''),chr(10),'') as mercht_cn_abbr
    ,replace(replace(t.mercht_cn_name,chr(13),''),chr(10),'') as mercht_cn_name
    ,replace(replace(t.mercht_addr,chr(13),''),chr(10),'') as mercht_addr
    ,replace(replace(t.acquiri_bank_num,chr(13),''),chr(10),'') as acquiri_bank_num
    ,replace(replace(t.open_bank_name,chr(13),''),chr(10),'') as open_bank_name
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
    ,replace(replace(t.cotas_name,chr(13),''),chr(10),'') as cotas_name
    ,replace(replace(t.cotas_cert_no,chr(13),''),chr(10),'') as cotas_cert_no
    ,replace(replace(t.cotas_tel_num,chr(13),''),chr(10),'') as cotas_tel_num
    ,replace(replace(t.fax_num,chr(13),''),chr(10),'') as fax_num
    ,replace(replace(t.agency_name,chr(13),''),chr(10),'') as agency_name
    ,replace(replace(t.acct_name,chr(13),''),chr(10),'') as acct_name
    ,replace(replace(t.open_bank_no,chr(13),''),chr(10),'') as open_bank_no
    ,replace(replace(t.check_status_cd,chr(13),''),chr(10),'') as check_status_cd
    ,replace(replace(t.recv_org_id,chr(13),''),chr(10),'') as recv_org_id
    ,replace(replace(t.mcc_code,chr(13),''),chr(10),'') as mcc_code
    ,replace(replace(t.unify_soci_crdt_cd,chr(13),''),chr(10),'') as unify_soci_crdt_cd
    ,replace(replace(t.cust_mgr_name,chr(13),''),chr(10),'') as cust_mgr_name
    ,replace(replace(t.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
    ,replace(replace(t.acvmnt_assign_ratio,chr(13),''),chr(10),'') as acvmnt_assign_ratio
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.pty_pos_mercht_info_h t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_pos_mercht_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes