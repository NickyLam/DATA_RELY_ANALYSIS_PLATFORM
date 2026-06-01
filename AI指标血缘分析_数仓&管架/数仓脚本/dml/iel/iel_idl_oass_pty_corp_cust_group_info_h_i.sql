: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_pty_corp_cust_group_info_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_pty_corp_cust_group_info_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.belong_group_id as belong_group_id
,t1.data_src_cd as data_src_cd
,t1.belong_group_name as belong_group_name
,t1.belong_group_orgnz_cd as belong_group_orgnz_cd
,t1.belong_group_loan_card_no as belong_group_loan_card_no
,t1.belong_group_rgst_cty_rg_cd as belong_group_rgst_cty_rg_cd
,t1.belong_group_site_cd as belong_group_site_cd
,t1.belong_group_rgst_addr as belong_group_rgst_addr
,t1.group_core_mem_flg as group_core_mem_flg
,t1.belong_group_dom_work_addr as belong_group_dom_work_addr
,t1.mem_type_cd as mem_type_cd
,t1.parent_corp_flg as parent_corp_flg
,t1.mem_status_cd as mem_status_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.party_id as party_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_pty_corp_cust_group_info_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_pty_corp_cust_group_info_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
