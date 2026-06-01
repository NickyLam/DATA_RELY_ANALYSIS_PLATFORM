: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_atms_dev_base_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/atms_dev_base_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.no,chr(13),''),chr(10),'') as no
,replace(replace(t1.ip,chr(13),''),chr(10),'') as ip
,replace(replace(t1.org_no,chr(13),''),chr(10),'') as org_no
,t1.away_flag as away_flag
,t1.dev_catalog as dev_catalog
,t1.dev_vendor as dev_vendor
,t1.dev_type as dev_type
,t1.work_type as work_type
,t1.status as status
,t1.dev_service as dev_service
,replace(replace(t1.terminal_no,chr(13),''),chr(10),'') as terminal_no
,replace(replace(t1.serial,chr(13),''),chr(10),'') as serial
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.buy_date,chr(13),''),chr(10),'') as buy_date
,replace(replace(t1.install_date,chr(13),''),chr(10),'') as install_date
,replace(replace(t1.start_date,chr(13),''),chr(10),'') as start_date
,replace(replace(t1.stop_date,chr(13),''),chr(10),'') as stop_date
,replace(replace(t1.open_time,chr(13),''),chr(10),'') as open_time
,replace(replace(t1.close_time,chr(13),''),chr(10),'') as close_time
,replace(replace(t1.expire_date,chr(13),''),chr(10),'') as expire_date
,t1.patrol_period as patrol_period
,replace(replace(t1.area_no,chr(13),''),chr(10),'') as area_no
,t1.x as x
,t1.y as y
,replace(replace(t1.cashbox_limit,chr(13),''),chr(10),'') as cashbox_limit
,replace(replace(t1.os,chr(13),''),chr(10),'') as os
,replace(replace(t1.atmc_soft,chr(13),''),chr(10),'') as atmc_soft
,replace(replace(t1.anti_virus_soft,chr(13),''),chr(10),'') as anti_virus_soft
,replace(replace(t1.sp,chr(13),''),chr(10),'') as sp
,replace(replace(t1.virtual_teller_no,chr(13),''),chr(10),'') as virtual_teller_no
,replace(replace(t1.care_level,chr(13),''),chr(10),'') as care_level
,replace(replace(t1.last_pm_date,chr(13),''),chr(10),'') as last_pm_date
,replace(replace(t1.expire_pm_date,chr(13),''),chr(10),'') as expire_pm_date
,replace(replace(t1.locate_no,chr(13),''),chr(10),'') as locate_no
,replace(replace(t1.note1,chr(13),''),chr(10),'') as note1
,replace(replace(t1.note2,chr(13),''),chr(10),'') as note2
,replace(replace(t1.note3,chr(13),''),chr(10),'') as note3
,replace(replace(t1.note4,chr(13),''),chr(10),'') as note4
,replace(replace(t1.note5,chr(13),''),chr(10),'') as note5
,replace(replace(t1.carrier,chr(13),''),chr(10),'') as carrier
,replace(replace(t1.money_org,chr(13),''),chr(10),'') as money_org
,t1.dev_status as dev_status
,replace(replace(t1.environment,chr(13),''),chr(10),'') as environment
,replace(replace(t1.address_code,chr(13),''),chr(10),'') as address_code
,t1.cash_type as cash_type
,t1.setup_type as setup_type
,replace(replace(t1.net_type,chr(13),''),chr(10),'') as net_type
,t1.operate_status as operate_status
,t1.registration_status as registration_status
,t1.comm_packet as comm_packet
,t1.zip_type as zip_type
,replace(replace(t1.dek_encoded,chr(13),''),chr(10),'') as dek_encoded
,replace(replace(t1.atmp_area,chr(13),''),chr(10),'') as atmp_area
,t1.selfbanktype as selfbanktype
,t1.arm_type as arm_type
,replace(replace(t1.pref_no,chr(13),''),chr(10),'') as pref_no
,replace(replace(t1.country_no,chr(13),''),chr(10),'') as country_no
,replace(replace(t1.postcode,chr(13),''),chr(10),'') as postcode
,replace(replace(t1.contact,chr(13),''),chr(10),'') as contact
,replace(replace(t1.acpt_ins_id_cd,chr(13),''),chr(10),'') as acpt_ins_id_cd
,replace(replace(t1.invstr_ins_id_cd,chr(13),''),chr(10),'') as invstr_ins_id_cd
,replace(replace(t1.maintn_ins_id_cd,chr(13),''),chr(10),'') as maintn_ins_id_cd
,replace(replace(t1.term_publicize_chnl,chr(13),''),chr(10),'') as term_publicize_chnl
,replace(replace(t1.socket,chr(13),''),chr(10),'') as socket
,replace(replace(t1.frn_acpt_tp,chr(13),''),chr(10),'') as frn_acpt_tp
,replace(replace(t1.scan_code,chr(13),''),chr(10),'') as scan_code
,replace(replace(t1.magn_read_in,chr(13),''),chr(10),'') as magn_read_in
,replace(replace(t1.no_card,chr(13),''),chr(10),'') as no_card
,replace(replace(t1.cont_ic_in,chr(13),''),chr(10),'') as cont_ic_in
,replace(replace(t1.contless_ic_in,chr(13),''),chr(10),'') as contless_ic_in
,replace(replace(t1.term_tran_fun,chr(13),''),chr(10),'') as term_tran_fun
,replace(replace(t1.last_statue,chr(13),''),chr(10),'') as last_statue
,t1.is_export as is_export
,replace(replace(t1.deploy_area_no,chr(13),''),chr(10),'') as deploy_area_no
,replace(replace(t1.deploy_area_name,chr(13),''),chr(10),'') as deploy_area_name
,replace(replace(t1.terminal_status,chr(13),''),chr(10),'') as terminal_status
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.atms_dev_base_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/atms_dev_base_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes