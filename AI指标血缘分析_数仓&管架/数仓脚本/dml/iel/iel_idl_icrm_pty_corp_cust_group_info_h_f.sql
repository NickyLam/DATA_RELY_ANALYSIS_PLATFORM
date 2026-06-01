: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_pty_corp_cust_group_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_pty_corp_cust_group_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select party_id
,lp_id
,belong_group_id
,data_src_cd
,belong_group_name
,belong_group_orgnz_cd
,belong_group_loan_card_no
,belong_group_rgst_cty_rg_cd
,belong_group_site_cd
,belong_group_rgst_addr
,group_core_mem_flg
,belong_group_dom_work_addr
,mem_type_cd
,job_cd
,etl_dt from idl.icrm_pty_corp_cust_group_info_h where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_pty_corp_cust_group_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes