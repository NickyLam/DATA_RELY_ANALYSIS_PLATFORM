: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_atms_dev_base_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_atms_dev_base_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.no
,t1.ip
,t1.org_no
,t1.away_flag
,t1.dev_catalog
,t1.dev_vendor
,t1.dev_type
,t1.work_type
,t1.status
,t1.dev_service
,t1.terminal_no
,t1.serial
,t1.address
,t1.buy_date
,t1.install_date
,t1.start_date
,t1.stop_date
,t1.open_time
,t1.close_time
,t1.expire_date
,t1.patrol_period
,t1.area_no
,t1.x
,t1.y
,t1.cashbox_limit
,t1.os
,t1.atmc_soft
,t1.anti_virus_soft
,t1.sp
,t1.virtual_teller_no
,t1.care_level
,t1.last_pm_date
,t1.expire_pm_date
,t1.locate_no
,t1.note1
,t1.note2
,t1.note3
,t1.note4
,t1.note5
,t1.carrier
,t1.money_org
,t1.dev_status
,t1.environment
,t1.address_code
,t1.cash_type
,t1.setup_type
,t1.net_type
,t1.operate_status
,t1.registration_status
,t1.comm_packet
,t1.zip_type
,t1.dek_encoded
,t1.atmp_area
,t1.selfbanktype
,t1.arm_type
,t1.pref_no
,t1.country_no
,t1.postcode
,t1.contact
,t1.acpt_ins_id_cd
,t1.invstr_ins_id_cd
,t1.maintn_ins_id_cd
,t1.term_publicize_chnl
,t1.socket
,t1.frn_acpt_tp
,t1.scan_code
,t1.magn_read_in
,t1.no_card
,t1.cont_ic_in
,t1.contless_ic_in
,t1.term_tran_fun
,t1.last_statue
,t1.is_export
,t1.deploy_area_no
,t1.deploy_area_name
,t1.terminal_status
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_atms_dev_base_info t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_atms_dev_base_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes