: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_vouch_loss_dtl_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_vouch_loss_dtl_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.loss_idf,chr(13),''),chr(10),'') as loss_idf
,replace(replace(t1.loss_id,chr(13),''),chr(10),'') as loss_id
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,t1.loss_begin_dt as loss_begin_dt
,t1.reissue_begin_dt as reissue_begin_dt
,replace(replace(t1.dep_vouch_cate_cd,chr(13),''),chr(10),'') as dep_vouch_cate_cd
,replace(replace(t1.vouch_begin_num,chr(13),''),chr(10),'') as vouch_begin_num
,replace(replace(t1.vouch_termnt_num,chr(13),''),chr(10),'') as vouch_termnt_num
,replace(replace(t1.new_vouch_type_cd,chr(13),''),chr(10),'') as new_vouch_type_cd
,replace(replace(t1.new_vouch_no,chr(13),''),chr(10),'') as new_vouch_no
,replace(replace(t1.vouch_loss_status_cd,chr(13),''),chr(10),'') as vouch_loss_status_cd
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,t1.tran_tm as tran_tm
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.public_agent_name,chr(13),''),chr(10),'') as public_agent_name
,replace(replace(t1.public_agent_nation,chr(13),''),chr(10),'') as public_agent_nation
,replace(replace(t1.public_agent_cert_type_cd,chr(13),''),chr(10),'') as public_agent_cert_type_cd
,replace(replace(t1.public_agent_cert_no,chr(13),''),chr(10),'') as public_agent_cert_no
,replace(replace(t1.public_agent_tel_num,chr(13),''),chr(10),'') as public_agent_tel_num
,replace(replace(t1.unloss_public_agent_name,chr(13),''),chr(10),'') as unloss_public_agent_name
,replace(replace(t1.unloss_public_agent_nation,chr(13),''),chr(10),'') as unloss_public_agent_nation
,replace(replace(t1.unloss_public_agent_cert_type_cd,chr(13),''),chr(10),'') as unloss_public_agent_cert_type_cd
,replace(replace(t1.unloss_public_agent_cert_no,chr(13),''),chr(10),'') as unloss_public_agent_cert_no
,replace(replace(t1.unloss_public_agent_phone,chr(13),''),chr(10),'') as unloss_public_agent_phone
from ${iml_schema}.agt_vouch_loss_dtl_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_vouch_loss_dtl_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes