: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nibs_ib_log_chlexch_log_i
CreateDate: 20240328
FileName:   ${iel_data_path}/nibs_ib_log_chlexch_log.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.sys_num,chr(13),''),chr(10),'') as sys_num
,replace(replace(t1.app_num,chr(13),''),chr(10),'') as app_num
,replace(replace(t1.chan_num,chr(13),''),chr(10),'') as chan_num
,replace(replace(t1.org_num,chr(13),''),chr(10),'') as org_num
,replace(replace(t1.teller_num,chr(13),''),chr(10),'') as teller_num
,replace(replace(t1.devicenum,chr(13),''),chr(10),'') as devicenum
,channeldate
,channeltime
,replace(replace(t1.chan_biz_seq_num,chr(13),''),chr(10),'') as chan_biz_seq_num
,replace(replace(t1.channelip,chr(13),''),chr(10),'') as channelip
,replace(replace(t1.channelmac,chr(13),''),chr(10),'') as channelmac
,replace(replace(t1.channeltrancode,chr(13),''),chr(10),'') as channeltrancode
,replace(replace(t1.req_code,chr(13),''),chr(10),'') as req_code
,replace(replace(t1.p_servicecode,chr(13),''),chr(10),'') as p_servicecode
,p_workdate
,replace(replace(t1.core_tran_flow_num,chr(13),''),chr(10),'') as core_tran_flow_num
,replace(replace(t1.p_biz_seq_num,chr(13),''),chr(10),'') as p_biz_seq_num
,replace(replace(t1.tx_seq_num,chr(13),''),chr(10),'') as tx_seq_num
,replace(replace(t1.p_ret_status,chr(13),''),chr(10),'') as p_ret_status
,replace(replace(t1.p_ret_code,chr(13),''),chr(10),'') as p_ret_code
,replace(replace(t1.p_ret_desc,chr(13),''),chr(10),'') as p_ret_desc
,reqdatetime
,rspdatetime
,replace(replace(t1.p_ip,chr(13),''),chr(10),'') as p_ip
,replace(replace(t1.logfilename,chr(13),''),chr(10),'') as logfilename
,replace(replace(t1.note1,chr(13),''),chr(10),'') as note1
,replace(replace(t1.note2,chr(13),''),chr(10),'') as note2
,replace(replace(t1.recinfo,chr(13),''),chr(10),'') as recinfo
,replace(replace(t1.handletime,chr(13),''),chr(10),'') as handletime

from ${iol_schema}.nibs_ib_log_chlexch_log t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nibs_ib_log_chlexch_log.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
