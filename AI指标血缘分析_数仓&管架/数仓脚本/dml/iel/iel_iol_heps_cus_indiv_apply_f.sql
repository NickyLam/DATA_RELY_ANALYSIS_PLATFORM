: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_heps_cus_indiv_apply_f
CreateDate: 20180529
FileName:   ${iel_data_path}/heps_cus_indiv_apply.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.flow_no,chr(13),''),chr(10),'') as flow_no
,replace(replace(t.cus_id,chr(13),''),chr(10),'') as cus_id
,replace(replace(t.cus_name,chr(13),''),chr(10),'') as cus_name
,replace(replace(t.indiv_sex,chr(13),''),chr(10),'') as indiv_sex
,replace(replace(t.cert_type,chr(13),''),chr(10),'') as cert_type
,replace(replace(t.cert_code,chr(13),''),chr(10),'') as cert_code
,replace(replace(t.indiv_brt_place,chr(13),''),chr(10),'') as indiv_brt_place
,replace(replace(t.indiv_heal_st,chr(13),''),chr(10),'') as indiv_heal_st
,replace(replace(t.indiv_mar_st,chr(13),''),chr(10),'') as indiv_mar_st
,replace(replace(t.indiv_rsd_addr,chr(13),''),chr(10),'') as indiv_rsd_addr
,replace(replace(t.indiv_rsd_st,chr(13),''),chr(10),'') as indiv_rsd_st
,replace(replace(t.indiv_rsd_year,chr(13),''),chr(10),'') as indiv_rsd_year
,replace(replace(t.phone,chr(13),''),chr(10),'') as phone
,replace(replace(t.indiv_com_name,chr(13),''),chr(10),'') as indiv_com_name
,replace(replace(t.indiv_com_addr,chr(13),''),chr(10),'') as indiv_com_addr
,replace(replace(t.main_brid,chr(13),''),chr(10),'') as main_brid
,replace(replace(t.cust_mgr,chr(13),''),chr(10),'') as cust_mgr
,replace(replace(t.indiv_sps_name,chr(13),''),chr(10),'') as indiv_sps_name
,replace(replace(t.indiv_sps_id_typ,chr(13),''),chr(10),'') as indiv_sps_id_typ
,replace(replace(t.indiv_sps_id_code,chr(13),''),chr(10),'') as indiv_sps_id_code
,t.loan_amount as loan_amount
,replace(replace(t.loan_term,chr(13),''),chr(10),'') as loan_term
,replace(replace(t.cert_st_time,chr(13),''),chr(10),'') as cert_st_time
,replace(replace(t.cert_ed_time,chr(13),''),chr(10),'') as cert_ed_time
,t.create_time as create_time
,t.update_time as update_time
from iol.heps_cus_indiv_apply t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/heps_cus_indiv_apply.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes