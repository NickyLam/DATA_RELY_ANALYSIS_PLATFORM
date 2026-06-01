: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_eifs_t01_corp_group_info_f
CreateDate: 20240805
FileName:   ${iel_data_path}/eifs_t01_corp_group_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.group_id,chr(13),''),chr(10),'') as group_id
,replace(replace(t1.group_num,chr(13),''),chr(10),'') as group_num
,replace(replace(t1.group_name,chr(13),''),chr(10),'') as group_name
,replace(replace(t1.group_short_name,chr(13),''),chr(10),'') as group_short_name
,replace(replace(t1.group_en_name,chr(13),''),chr(10),'') as group_en_name
,replace(replace(t1.phys_addr_cty_zone_cd,chr(13),''),chr(10),'') as phys_addr_cty_zone_cd
,replace(replace(t1.group_work_addr_dist_cd,chr(13),''),chr(10),'') as group_work_addr_dist_cd
,replace(replace(t1.group_dom_work_addr,chr(13),''),chr(10),'') as group_dom_work_addr
,replace(replace(t1.trade_group_ind,chr(13),''),chr(10),'') as trade_group_ind
,group_mem_cnt
,replace(replace(t1.group_risk_warn_info_cd,chr(13),''),chr(10),'') as group_risk_warn_info_cd
,replace(replace(t1.group_status,chr(13),''),chr(10),'') as group_status
,replace(replace(t1.tax_pay_ctzn_idnt,chr(13),''),chr(10),'') as tax_pay_ctzn_idnt
,replace(replace(t1.prnt_cust_no,chr(13),''),chr(10),'') as prnt_cust_no
,replace(replace(t1.tax_org_type,chr(13),''),chr(10),'') as tax_org_type
,replace(replace(t1.cust_mgr_name,chr(13),''),chr(10),'') as cust_mgr_name
,replace(replace(t1.cust_mgr_num,chr(13),''),chr(10),'') as cust_mgr_num
,replace(replace(t1.create_te,chr(13),''),chr(10),'') as create_te
,replace(replace(t1.create_org,chr(13),''),chr(10),'') as create_org
,replace(replace(t1.init_system_id,chr(13),''),chr(10),'') as init_system_id
,init_created_ts
,created_ts
,updated_ts
,replace(replace(t1.last_updated_te,chr(13),''),chr(10),'') as last_updated_te
,replace(replace(t1.last_updated_org,chr(13),''),chr(10),'') as last_updated_org
,replace(replace(t1.last_system_id,chr(13),''),chr(10),'') as last_system_id
,last_updated_ts
,replace(replace(t1.grp_typ,chr(13),''),chr(10),'') as grp_typ
,replace(replace(t1.wthr_ghb_assoc_txn,chr(13),''),chr(10),'') as wthr_ghb_assoc_txn
,replace(replace(t1.fst_busi,chr(13),''),chr(10),'') as fst_busi
,replace(replace(t1.pri_major_main_biz_bus_pct,chr(13),''),chr(10),'') as pri_major_main_biz_bus_pct
,replace(replace(t1.scd_busi,chr(13),''),chr(10),'') as scd_busi
,replace(replace(t1.scd_major_main_biz_bus_pct,chr(13),''),chr(10),'') as scd_major_main_biz_bus_pct
,replace(replace(t1.third_busi,chr(13),''),chr(10),'') as third_busi
,replace(replace(t1.third_major_main_biz_bus_pct,chr(13),''),chr(10),'') as third_major_main_biz_bus_pct
,replace(replace(t1.actl_ctrl_cnt,chr(13),''),chr(10),'') as actl_ctrl_cnt
,replace(replace(t1.main_cntri_cnt,chr(13),''),chr(10),'') as main_cntri_cnt
,upd_offic_loc_date
,replace(replace(t1.src_sys_num,chr(13),''),chr(10),'') as src_sys_num
,replace(replace(t1.last_updated_src_sys_num,chr(13),''),chr(10),'') as last_updated_src_sys_num
,replace(replace(t1.actl_ctrl_cert_num,chr(13),''),chr(10),'') as actl_ctrl_cert_num
,replace(replace(t1.actl_ctrl_iden_typ,chr(13),''),chr(10),'') as actl_ctrl_iden_typ
,replace(replace(t1.actl_ctrl_name,chr(13),''),chr(10),'') as actl_ctrl_name
,replace(replace(t1.actl_ctrl_nation_cd,chr(13),''),chr(10),'') as actl_ctrl_nation_cd
,replace(replace(t1.base_group_cust_no,chr(13),''),chr(10),'') as base_group_cust_no

from ${iol_schema}.eifs_t01_corp_group_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/eifs_t01_corp_group_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
