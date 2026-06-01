: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amls_t2a_cust_i_f
CreateDate: 20180529
FileName:   ${iel_data_path}/amls_t2a_cust_i.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.org_id,chr(13),''),chr(10),'') as org_id
    ,t.create_dt as create_dt
    ,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
    ,replace(replace(t.cust_en_name,chr(13),''),chr(10),'') as cust_en_name
    ,replace(replace(t.cust_sts,chr(13),''),chr(10),'') as cust_sts
    ,replace(replace(t.cust_type,chr(13),''),chr(10),'') as cust_type
    ,replace(replace(t.aml_cust_type,chr(13),''),chr(10),'') as aml_cust_type
    ,replace(replace(t.pbc_cust_type,chr(13),''),chr(10),'') as pbc_cust_type
    ,replace(replace(t.pbc_ocp,chr(13),''),chr(10),'') as pbc_ocp
    ,replace(replace(t.s_ocp,chr(13),''),chr(10),'') as s_ocp
    ,replace(replace(t.cust_nat,chr(13),''),chr(10),'') as cust_nat
    ,replace(replace(t.cust_area,chr(13),''),chr(10),'') as cust_area
    ,replace(replace(t.cert_type,chr(13),''),chr(10),'') as cert_type
    ,replace(replace(t.s_cert_type,chr(13),''),chr(10),'') as s_cert_type
    ,replace(replace(t.cert_no,chr(13),''),chr(10),'') as cert_no
    ,t.cert_valid_dt as cert_valid_dt
    ,t.cert_invalid_dt as cert_invalid_dt
    ,replace(replace(t.cert_addr,chr(13),''),chr(10),'') as cert_addr
    ,replace(replace(t.home_addr,chr(13),''),chr(10),'') as home_addr
    ,replace(replace(t.office_addr,chr(13),''),chr(10),'') as office_addr
    ,replace(replace(t.office_tel,chr(13),''),chr(10),'') as office_tel
    ,replace(replace(t.home_tel,chr(13),''),chr(10),'') as home_tel
    ,replace(replace(t.mobile_phone,chr(13),''),chr(10),'') as mobile_phone
    ,replace(replace(t.website,chr(13),''),chr(10),'') as website
    ,replace(replace(t.email,chr(13),''),chr(10),'') as email
    ,t.birth_dt as birth_dt
    ,replace(replace(t.edu_lvl,chr(13),''),chr(10),'') as edu_lvl
    ,replace(replace(t.dgr_lvl,chr(13),''),chr(10),'') as dgr_lvl
    ,replace(replace(t.gender,chr(13),''),chr(10),'') as gender
    ,replace(replace(t.duty,chr(13),''),chr(10),'') as duty
    ,replace(replace(t.indus,chr(13),''),chr(10),'') as indus
    ,replace(replace(t.mgr_id,chr(13),''),chr(10),'') as mgr_id
    ,replace(replace(t.mgr_name,chr(13),''),chr(10),'') as mgr_name
    ,replace(replace(t.is_staff,chr(13),''),chr(10),'') as is_staff
    ,replace(replace(t.staff_id,chr(13),''),chr(10),'') as staff_id
    ,replace(replace(t.nation_cd,chr(13),''),chr(10),'') as nation_cd
    ,replace(replace(t.unit_name,chr(13),''),chr(10),'') as unit_name
    ,replace(replace(t.unit_addr,chr(13),''),chr(10),'') as unit_addr
    ,replace(replace(t.unit_prop,chr(13),''),chr(10),'') as unit_prop
    ,t.income_amt as income_amt
    ,replace(replace(t.income_curr_cd,chr(13),''),chr(10),'') as income_curr_cd
    ,replace(replace(t.rsrv_01,chr(13),''),chr(10),'') as rsrv_01
    ,replace(replace(t.rsrv_02,chr(13),''),chr(10),'') as rsrv_02
    ,replace(replace(t.rsrv_03,chr(13),''),chr(10),'') as rsrv_03
    ,replace(replace(t.rsrv_04,chr(13),''),chr(10),'') as rsrv_04
    ,replace(replace(t.is_ebank,chr(13),''),chr(10),'') as is_ebank
    ,replace(replace(t.is_loan,chr(13),''),chr(10),'') as is_loan
    ,replace(replace(t.create_channel,chr(13),''),chr(10),'') as create_channel
    ,replace(replace(t.is_free_trade,chr(13),''),chr(10),'') as is_free_trade
    ,replace(replace(t.remarks,chr(13),''),chr(10),'') as remarks
    ,replace(replace(t.close_dt,chr(13),''),chr(10),'') as close_dt
    ,replace(replace(t.is_pos,chr(13),''),chr(10),'') as is_pos
    ,replace(replace(t.position,chr(13),''),chr(10),'') as position
    ,replace(replace(t.oth_cert_type,chr(13),''),chr(10),'') as oth_cert_type
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.amls_t2a_cust_i t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_t2a_cust_i.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes