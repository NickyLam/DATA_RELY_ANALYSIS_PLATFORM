: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pty_tmss_group_cust_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_tmss_group_cust_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt 
,t1.cust_id as cust_id 
,t1.lp_id as lp_id 
,t1.party_id as party_id 
,t1.cust_name as cust_name 
,t1.cert_cate_cd as cert_cate_cd 
,t1.cert_type_cd as cert_type_cd 
,t1.cert_no as cert_no 
,t1.group_type_cd as group_type_cd 
,t1.multi_bank_serv_flg as multi_bank_serv_flg 
,t1.open_bank_no as open_bank_no 
,t1.belong_bank_no as belong_bank_no 
,t1.status_cd as status_cd 
,t1.operr_id as operr_id 
,t1.create_tm as create_tm 
,t1.checker_id as checker_id 
,t1.check_tm as check_tm 
,t1.group_id as group_id 
,t1.unify_soci_crdt_id as unify_soci_crdt_id 
,t1.adres_name as adres_name 
,t1.adres_addr as adres_addr 
,t1.adres_tel as adres_tel 
,t1.adres_remark as adres_remark 
,t1.dc_rgst_status_cd as dc_rgst_status_cd 
,t1.dc_valid_tm as dc_valid_tm 
,t1.ukey_uplmi_cnt as ukey_uplmi_cnt 
,t1.create_dt as create_dt 
,t1.update_dt as update_dt 
,t1.id_mark as id_mark 
,t1.job_cd
from ${idl_schema}.pty_tmss_group_cust t1 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_tmss_group_cust_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes