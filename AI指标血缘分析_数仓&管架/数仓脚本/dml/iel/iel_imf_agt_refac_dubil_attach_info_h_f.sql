: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_refac_dubil_attach_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_refac_dubil_attach_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.batch_pkg_id,chr(13),''),chr(10),'') as batch_pkg_id
,replace(replace(t1.cert_name,chr(13),''),chr(10),'') as cert_name
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,t1.dubil_amt as dubil_amt
,t1.exec_int_rat as exec_int_rat
,t1.dubil_bal as dubil_bal
,t1.loan_distr_dt as loan_distr_dt
,t1.loan_exp_dt as loan_exp_dt
,replace(replace(t1.loan_level5_cls_cd,chr(13),''),chr(10),'') as loan_level5_cls_cd
,replace(replace(t1.loan_usage_cd,chr(13),''),chr(10),'') as loan_usage_cd
,replace(replace(t1.main_guar_way_cd,chr(13),''),chr(10),'') as main_guar_way_cd
,replace(replace(t1.indus_type_cd,chr(13),''),chr(10),'') as indus_type_cd
,replace(replace(t1.loan_type_cd,chr(13),''),chr(10),'') as loan_type_cd
,replace(replace(t1.loan_type_subdv_cd,chr(13),''),chr(10),'') as loan_type_subdv_cd
,replace(replace(t1.corp_size_cd,chr(13),''),chr(10),'') as corp_size_cd
,replace(replace(t1.corp_number,chr(13),''),chr(10),'') as corp_number
,replace(replace(t1.last_year_bus_inco,chr(13),''),chr(10),'') as last_year_bus_inco
,replace(replace(t1.in_pool_flg,chr(13),''),chr(10),'') as in_pool_flg
,replace(replace(t1.refac_status_cd,chr(13),''),chr(10),'') as refac_status_cd
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.org_name,chr(13),''),chr(10),'') as org_name
,replace(replace(t1.dubil_status_cd,chr(13),''),chr(10),'') as dubil_status_cd
,replace(replace(t1.batch_pkg_name,chr(13),''),chr(10),'') as batch_pkg_name
,t1.dubil_invalid_dt as dubil_invalid_dt
,t1.corp_asset_tot as corp_asset_tot
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.agt_refac_dubil_attach_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_refac_dubil_attach_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes