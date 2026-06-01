: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ifcs_jud_remit_rgst_b_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ifcs_jud_remit_rgst_b.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.remit_dt,chr(13),''),chr(10),'') as remit_dt
,replace(replace(t.remit_flow_num,chr(13),''),chr(10),'') as remit_flow_num
,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t.remit_way,chr(13),''),chr(10),'') as remit_way
,replace(replace(t.remit_proof_type,chr(13),''),chr(10),'') as remit_proof_type
,replace(replace(t.proof_num,chr(13),''),chr(10),'') as proof_num
,replace(replace(t.exec_org_cd,chr(13),''),chr(10),'') as exec_org_cd
,replace(replace(t.exec_cert_type_01,chr(13),''),chr(10),'') as exec_cert_type_01
,replace(replace(t.exec_cert_no_01,chr(13),''),chr(10),'') as exec_cert_no_01
,replace(replace(t.exec_cert_type_02,chr(13),''),chr(10),'') as exec_cert_type_02
,replace(replace(t.exec_cert_no_02,chr(13),''),chr(10),'') as exec_cert_no_02
,replace(replace(t.exec_ps_01,chr(13),''),chr(10),'') as exec_ps_01
,replace(replace(t.remit_rs,chr(13),''),chr(10),'') as remit_rs
,replace(replace(t.teller_no,chr(13),''),chr(10),'') as teller_no
,replace(replace(t.org_no,chr(13),''),chr(10),'') as org_no
,replace(replace(t.init_froz_dt,chr(13),''),chr(10),'') as init_froz_dt
,replace(replace(t.init_froz_flow,chr(13),''),chr(10),'') as init_froz_flow
,t.remit_amt as remit_amt
,replace(replace(t.exec_ps_02,chr(13),''),chr(10),'') as exec_ps_02
,replace(replace(t.remit_chn,chr(13),''),chr(10),'') as remit_chn
,replace(replace(t.remit_tm,chr(13),''),chr(10),'') as remit_tm
from ${iol_schema}.IFCS_JUD_REMIT_RGST_B t 
where REMIT_DT='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifcs_jud_remit_rgst_b.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes