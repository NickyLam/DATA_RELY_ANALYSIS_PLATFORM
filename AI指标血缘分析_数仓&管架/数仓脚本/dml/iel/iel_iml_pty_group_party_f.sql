: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_group_party_f
CreateDate: 20230525
FileName:   ${iel_data_path}/pty_group_party.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.group_name,chr(13),''),chr(10),'') as group_name
,replace(replace(t1.group_abbr,chr(13),''),chr(10),'') as group_abbr
,replace(replace(t1.group_en_name,chr(13),''),chr(10),'') as group_en_name
,replace(replace(t1.cty_rg_cd,chr(13),''),chr(10),'') as cty_rg_cd
,replace(replace(t1.work_land_dist_cd,chr(13),''),chr(10),'') as work_land_dist_cd
,replace(replace(t1.dom_work_addr,chr(13),''),chr(10),'') as dom_work_addr
,replace(replace(t1.ibank_group_flg,chr(13),''),chr(10),'') as ibank_group_flg
,mem_cnt
,replace(replace(t1.group_risk_warn_sgn_cd,chr(13),''),chr(10),'') as group_risk_warn_sgn_cd
,replace(replace(t1.group_status_cd,chr(13),''),chr(10),'') as group_status_cd
,replace(replace(t1.parent_corp_cust_id,chr(13),''),chr(10),'') as parent_corp_cust_id
,replace(replace(t1.cust_mgr_name,chr(13),''),chr(10),'') as cust_mgr_name
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.tax_resdnt_idti_cd,chr(13),''),chr(10),'') as tax_resdnt_idti_cd
,replace(replace(t1.tax_org_cate_cd,chr(13),''),chr(10),'') as tax_org_cate_cd
,create_dt
,update_dt
,replace(replace(t1.group_cust_type_cd,chr(13),''),chr(10),'') as group_cust_type_cd

from ${iml_schema}.pty_group_party t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_group_party.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
