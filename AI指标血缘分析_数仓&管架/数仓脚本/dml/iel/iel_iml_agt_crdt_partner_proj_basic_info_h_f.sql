: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_crdt_partner_proj_basic_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_crdt_partner_proj_basic_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.co_proj_id,chr(13),''),chr(10),'') as co_proj_id
,replace(replace(t1.co_proj_name,chr(13),''),chr(10),'') as co_proj_name
,replace(replace(t1.co_proj_type_cd,chr(13),''),chr(10),'') as co_proj_type_cd
,replace(replace(t1.partner_id,chr(13),''),chr(10),'') as partner_id
,replace(replace(t1.partner_type_cd,chr(13),''),chr(10),'') as partner_type_cd
,replace(replace(t1.coprator_type_cd,chr(13),''),chr(10),'') as coprator_type_cd
,partner_capital_ratio
,replace(replace(t1.co_agt_id,chr(13),''),chr(10),'') as co_agt_id
,replace(replace(t1.have_proj_lmt_flg,chr(13),''),chr(10),'') as have_proj_lmt_flg
,proj_begin_dt
,proj_exp_dt
,co_tenor
,fee_rat
,comm_ratio
,replace(replace(t1.proj_status_cd,chr(13),''),chr(10),'') as proj_status_cd
,replace(replace(t1.proj_descb,chr(13),''),chr(10),'') as proj_descb
,replace(replace(t1.cont_circl_flg,chr(13),''),chr(10),'') as cont_circl_flg
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.cap_supv_acct_id,chr(13),''),chr(10),'') as cap_supv_acct_id
,replace(replace(t1.cap_supv_acct_name,chr(13),''),chr(10),'') as cap_supv_acct_name
,replace(replace(t1.proj_stl_acct_id,chr(13),''),chr(10),'') as proj_stl_acct_id
,replace(replace(t1.proj_stl_acct_name,chr(13),''),chr(10),'') as proj_stl_acct_name
,replace(replace(t1.proj_stl_open_acct_bank_org_id,chr(13),''),chr(10),'') as proj_stl_open_acct_bank_org_id
,replace(replace(t1.proj_stl_open_acct_org_id,chr(13),''),chr(10),'') as proj_stl_open_acct_org_id
,replace(replace(t1.appl_type_cd,chr(13),''),chr(10),'') as appl_type_cd
,replace(replace(t1.hxb_rela_ps_flg,chr(13),''),chr(10),'') as hxb_rela_ps_flg
,replace(replace(t1.move_remark,chr(13),''),chr(10),'') as move_remark
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,rgst_dt
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id

from ${iml_schema}.agt_crdt_partner_proj_basic_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_crdt_partner_proj_basic_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
