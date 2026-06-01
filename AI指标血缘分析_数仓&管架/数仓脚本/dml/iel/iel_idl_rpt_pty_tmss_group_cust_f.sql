: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_pty_tmss_group_cust_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_pty_tmss_group_cust.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,cust_id
,lp_id
,party_id
,cust_name
,cert_cate_cd
,cert_type_cd
,cert_no
,group_type_cd
,multi_bank_serv_flg
,open_bank_no
,belong_bank_no
,status_cd
,operr_id
,create_tm
,checker_id
,check_tm
,group_id
,unify_soci_crdt_id
,adres_name
,adres_addr
,adres_tel
,adres_remark
,dc_rgst_status_cd
,dc_valid_tm
,ukey_uplmi_cnt from idl.rpt_pty_tmss_group_cust where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_pty_tmss_group_cust.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes