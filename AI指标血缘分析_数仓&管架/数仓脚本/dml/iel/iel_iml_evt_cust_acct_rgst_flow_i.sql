: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_cust_acct_rgst_flow_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_cust_acct_rgst_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.midgrod_tran_code,chr(13),''),chr(10),'') as midgrod_tran_code
,replace(replace(t1.msg_type,chr(13),''),chr(10),'') as msg_type
,t1.tran_dt as tran_dt
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.pbc_flow_num,chr(13),''),chr(10),'') as pbc_flow_num
,t1.tran_tm as tran_tm
,replace(replace(t1.origi_bank_no,chr(13),''),chr(10),'') as origi_bank_no
,replace(replace(t1.recv_bank_no,chr(13),''),chr(10),'') as recv_bank_no
,replace(replace(t1.acct_rgst_bus_type_cd,chr(13),''),chr(10),'') as acct_rgst_bus_type_cd
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.acct_attr_cd,chr(13),''),chr(10),'') as acct_attr_cd
,replace(replace(t1.onl_bank_sys_open_bank_no,chr(13),''),chr(10),'') as onl_bank_sys_open_bank_no
,replace(replace(t1.acct_num,chr(13),''),chr(10),'') as acct_num
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.mask_acct_name,chr(13),''),chr(10),'') as mask_acct_name
,replace(replace(t1.acct_open_bank_no,chr(13),''),chr(10),'') as acct_open_bank_no
,replace(replace(t1.acct_clear_bank_no,chr(13),''),chr(10),'') as acct_clear_bank_no
,replace(replace(t1.mobile_no,chr(13),''),chr(10),'') as mobile_no
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.wrtoff_bank_no,chr(13),''),chr(10),'') as wrtoff_bank_no
,replace(replace(t1.new_acct_num,chr(13),''),chr(10),'') as new_acct_num
,replace(replace(t1.new_acct_rgst_attr_cd,chr(13),''),chr(10),'') as new_acct_rgst_attr_cd
,replace(replace(t1.new_acct_rgst_bank_no,chr(13),''),chr(10),'') as new_acct_rgst_bank_no
,replace(replace(t1.cont_flg,chr(13),''),chr(10),'') as cont_flg
,replace(replace(t1.bus_status_cd,chr(13),''),chr(10),'') as bus_status_cd
,replace(replace(t1.bus_refuse_cd,chr(13),''),chr(10),'') as bus_refuse_cd
,t1.pbc_proc_dt as pbc_proc_dt
,replace(replace(t1.err_info,chr(13),''),chr(10),'') as err_info
,replace(replace(t1.rgst_status_cd,chr(13),''),chr(10),'') as rgst_status_cd
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.chn_flow_num,chr(13),''),chr(10),'') as chn_flow_num
,replace(replace(t1.st_msg_ser_num,chr(13),''),chr(10),'') as st_msg_ser_num
,replace(replace(t1.init_pbc_flow_num,chr(13),''),chr(10),'') as init_pbc_flow_num
from ${iml_schema}.evt_cust_acct_rgst_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_cust_acct_rgst_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes