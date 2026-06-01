: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_corp_cust_group_info_h_f
CreateDate: 20221021
FileName:   ${iel_data_path}/pty_corp_cust_group_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(party_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(belong_group_id,chr(13),''),chr(10),'')
,replace(replace(data_src_cd,chr(13),''),chr(10),'')
,replace(replace(belong_group_name,chr(13),''),chr(10),'')
,replace(replace(belong_group_orgnz_cd,chr(13),''),chr(10),'')
,replace(replace(belong_group_loan_card_no,chr(13),''),chr(10),'')
,replace(replace(belong_group_rgst_cty_rg_cd,chr(13),''),chr(10),'')
,replace(replace(belong_group_site_cd,chr(13),''),chr(10),'')
,replace(replace(belong_group_rgst_addr,chr(13),''),chr(10),'')
,replace(replace(group_core_mem_flg,chr(13),''),chr(10),'')
,replace(replace(belong_group_dom_work_addr,chr(13),''),chr(10),'')
,replace(replace(mem_type_cd,chr(13),''),chr(10),'')
,replace(replace(parent_corp_flg,chr(13),''),chr(10),'')
,replace(replace(mem_status_cd,chr(13),''),chr(10),'')
,start_dt
,end_dt
,replace(replace(id_mark,chr(13),''),chr(10),'')

from ${iml_schema}.pty_corp_cust_group_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_corp_cust_group_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
