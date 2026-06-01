: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_batch_netw_vrfction_flow_a
CreateDate: 20240130
FileName:   ${iel_data_path}/evt_batch_netw_vrfction_flow.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,batch_dt
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.batch_seq_num,chr(13),''),chr(10),'') as batch_seq_num
,replace(replace(t1.netw_vrfction_ser_num,chr(13),''),chr(10),'') as netw_vrfction_ser_num
,netw_vrfction_dt
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_num,chr(13),''),chr(10),'') as cert_num
,replace(replace(t1.cert_name,chr(13),''),chr(10),'') as cert_name
,replace(replace(t1.msg_id,chr(13),''),chr(10),'') as msg_id
,replace(replace(t1.sys_cd,chr(13),''),chr(10),'') as sys_cd
,replace(replace(t1.ibank_no,chr(13),''),chr(10),'') as ibank_no
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.vrfction_pass_cd,chr(13),''),chr(10),'') as vrfction_pass_cd
,replace(replace(t1.vrfction_dept_cd,chr(13),''),chr(10),'') as vrfction_dept_cd
,replace(replace(t1.vrfction_type_cd,chr(13),''),chr(10),'') as vrfction_type_cd
,replace(replace(t1.bus_kind_cd,chr(13),''),chr(10),'') as bus_kind_cd
,replace(replace(t1.midgrod_flow_num,chr(13),''),chr(10),'') as midgrod_flow_num
,replace(replace(t1.check_rest_cd,chr(13),''),chr(10),'') as check_rest_cd
,replace(replace(t1.check_status_cd,chr(13),''),chr(10),'') as check_status_cd
,replace(replace(t1.valid_rec_flg,chr(13),''),chr(10),'') as valid_rec_flg
,replace(replace(t1.export_status_cd,chr(13),''),chr(10),'') as export_status_cd
,replace(replace(t1.vrfction_status_cd,chr(13),''),chr(10),'') as vrfction_status_cd
,replace(replace(t1.aldy_stat_flg,chr(13),''),chr(10),'') as aldy_stat_flg

from ${iml_schema}.evt_batch_netw_vrfction_flow t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_batch_netw_vrfction_flow.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
