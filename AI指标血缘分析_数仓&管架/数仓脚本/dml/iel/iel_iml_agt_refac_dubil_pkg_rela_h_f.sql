: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_refac_dubil_pkg_rela_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_refac_dubil_pkg_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.apv_flow_num,chr(13),''),chr(10),'') as apv_flow_num
,replace(replace(t1.batch_pkg_id,chr(13),''),chr(10),'') as batch_pkg_id
,replace(replace(t1.in_pool_idf_cd,chr(13),''),chr(10),'') as in_pool_idf_cd
,replace(replace(t1.in_pool_org_cd,chr(13),''),chr(10),'') as in_pool_org_cd
,actl_loan_distr_dt
,actl_loan_termnt_dt
,last_year_bus_inco
,corp_asset_tot
,replace(replace(t1.indus_type_cd,chr(13),''),chr(10),'') as indus_type_cd
,replace(replace(t1.loan_usage_descb,chr(13),''),chr(10),'') as loan_usage_descb
,replace(replace(t1.corp_size_cd,chr(13),''),chr(10),'') as corp_size_cd
,exec_int_rat
,corp_number
,replace(replace(t1.loan_kind_cd,chr(13),''),chr(10),'') as loan_kind_cd
,replace(replace(t1.mang_main_crdt_id,chr(13),''),chr(10),'') as mang_main_crdt_id
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.move_remark,chr(13),''),chr(10),'') as move_remark
,replace(replace(t1.rzxz_indus_type_cd,chr(13),''),chr(10),'') as rzxz_indus_type_cd

from ${iml_schema}.agt_refac_dubil_pkg_rela_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_refac_dubil_pkg_rela_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
