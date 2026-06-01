: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_rcrs_mybk_supv_cust_zt_f
CreateDate: 20220306
FileName:   ${iel_data_path}/rpt_rcrs_mybk_supv_cust_zt.f.${batch_date}.dat
IF_mark:    f
Logs:
   sundexin
' \
        query="select
     to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.inst_code,chr(13),''),chr(10),'') as inst_code
    ,replace(replace(t.cert_type,chr(13),''),chr(10),'') as cert_type
    ,replace(replace(t.name,chr(13),''),chr(10),'') as name
    ,replace(replace(t.cert_no,chr(13),''),chr(10),'') as cert_no
    ,replace(replace(t.target_jy_flag2,chr(13),''),chr(10),'') as target_jy_flag2
    ,replace(replace(t.target_jy_flag3,chr(13),''),chr(10),'') as target_jy_flag3
    ,replace(replace(t.farmer_flag,chr(13),''),chr(10),'') as farmer_flag
    ,replace(replace(t.bsn_type,chr(13),''),chr(10),'') as bsn_type
    ,replace(replace(t.act_cert_type,chr(13),''),chr(10),'') as act_cert_type
    ,replace(replace(t.act_cert_no,chr(13),''),chr(10),'') as act_cert_no
    ,replace(replace(t.act_cert_name,chr(13),''),chr(10),'') as act_cert_name
    ,replace(replace(t.staff_num,chr(13),''),chr(10),'') as staff_num
    ,replace(replace(t.income,chr(13),''),chr(10),'') as income
    ,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
    ,replace(replace(t.data_sync,chr(13),''),chr(10),'') as data_sync
    ,replace(replace(t.ip_id,chr(13),''),chr(10),'') as ip_id
    ,replace(replace(t.id_type,chr(13),''),chr(10),'') as id_type
    ,replace(replace(t.change_type,chr(13),''),chr(10),'') as change_type
    ,replace(replace(t.p_valid_date_start,chr(13),''),chr(10),'') as p_valid_date_start
    ,replace(replace(t.p_valid_date_end,chr(13),''),chr(10),'') as p_valid_date_end
    ,replace(replace(t.p_sex,chr(13),''),chr(10),'') as p_sex
    ,replace(replace(t.p_profession,chr(13),''),chr(10),'') as p_profession
    ,replace(replace(t.p_nationality,chr(13),''),chr(10),'') as p_nationality
    ,replace(replace(t.p_address,chr(13),''),chr(10),'') as p_address
    ,replace(replace(t.p_tele,chr(13),''),chr(10),'') as p_tele
    ,replace(replace(t.c_organiz_code,chr(13),''),chr(10),'') as c_organiz_code
    ,replace(replace(t.c_social_code,chr(13),''),chr(10),'') as c_social_code
    ,replace(replace(t.c_address_code,chr(13),''),chr(10),'') as c_address_code
    ,replace(replace(t.c_register_ads,chr(13),''),chr(10),'') as c_register_ads
    ,replace(replace(t.c_begin_dt,chr(13),''),chr(10),'') as c_begin_dt
    ,replace(replace(t.c_end_dt,chr(13),''),chr(10),'') as c_end_dt
    ,replace(replace(t.c_valid_date_start,chr(13),''),chr(10),'') as c_valid_date_start
    ,replace(replace(t.c_valid_date_end,chr(13),''),chr(10),'') as c_valid_date_end
    ,replace(replace(t.total_capital,chr(13),''),chr(10),'') as total_capital
    ,replace(replace(t.loan_biz_tag,chr(13),''),chr(10),'') as loan_biz_tag
    ,replace(replace(t.is_lmt_ind,chr(13),''),chr(10),'') as is_lmt_ind
    ,replace(replace(t.p_bank_card_number,chr(13),''),chr(10),'') as p_bank_card_number
    ,replace(replace(t.p_deposit_bank_name,chr(13),''),chr(10),'') as p_deposit_bank_name
    ,replace(replace(t.p_per_year_income,chr(13),''),chr(10),'') as p_per_year_income
    ,replace(replace(t.p_home_year_income,chr(13),''),chr(10),'') as p_home_year_income
    ,replace(replace(substrb(t.c_manage_range,1,1999),chr(13),''),chr(10),'') as c_manage_range
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
 from iol.rcrs_mybk_supv_cust_zt t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_rcrs_mybk_supv_cust_zt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes