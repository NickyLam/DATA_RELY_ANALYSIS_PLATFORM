: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_cust_risk_warn_rgst_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/pty_cust_risk_warn_rgst_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,rgst_dt
,replace(replace(t1.warn_proc_status_cd,chr(13),''),chr(10),'') as warn_proc_status_cd
,replace(replace(t1.effect_flg,chr(13),''),chr(10),'') as effect_flg
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.rela_flow_num,chr(13),''),chr(10),'') as rela_flow_num
,replace(replace(t1.warn_init_way_cd,chr(13),''),chr(10),'') as warn_init_way_cd
,replace(replace(t1.warn_type_cd,chr(13),''),chr(10),'') as warn_type_cd

from ${iml_schema}.pty_cust_risk_warn_rgst_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_cust_risk_warn_rgst_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
