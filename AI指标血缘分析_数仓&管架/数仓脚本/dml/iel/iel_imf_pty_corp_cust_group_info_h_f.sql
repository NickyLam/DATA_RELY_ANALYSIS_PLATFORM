: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_pty_corp_cust_group_info_h_f
CreateDate: 20240802
FileName:   ${iel_data_path}/pty_corp_cust_group_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.belong_group_id,chr(13),''),chr(10),'') as belong_group_id
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.belong_group_name,chr(13),''),chr(10),'') as belong_group_name
,replace(replace(t1.belong_group_orgnz_cd,chr(13),''),chr(10),'') as belong_group_orgnz_cd
,replace(replace(t1.belong_group_loan_card_no,chr(13),''),chr(10),'') as belong_group_loan_card_no
,replace(replace(t1.belong_group_rgst_cty_rg_cd,chr(13),''),chr(10),'') as belong_group_rgst_cty_rg_cd
,replace(replace(t1.belong_group_site_cd,chr(13),''),chr(10),'') as belong_group_site_cd
,replace(replace(t1.belong_group_rgst_addr,chr(13),''),chr(10),'') as belong_group_rgst_addr
,replace(replace(t1.group_core_mem_flg,chr(13),''),chr(10),'') as group_core_mem_flg
,replace(replace(t1.belong_group_dom_work_addr,chr(13),''),chr(10),'') as belong_group_dom_work_addr
,replace(replace(t1.mem_type_cd,chr(13),''),chr(10),'') as mem_type_cd
,replace(replace(t1.parent_corp_flg,chr(13),''),chr(10),'') as parent_corp_flg
,replace(replace(t1.mem_status_cd,chr(13),''),chr(10),'') as mem_status_cd
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.use_family_edit_num,chr(13),''),chr(10),'') as use_family_edit_num
,replace(replace(t1.matn_family_edit_num,chr(13),''),chr(10),'') as matn_family_edit_num

from ${iml_schema}.pty_corp_cust_group_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_corp_cust_group_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
