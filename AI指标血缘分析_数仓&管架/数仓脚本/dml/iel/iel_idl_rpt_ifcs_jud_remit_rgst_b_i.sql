: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_ifcs_jud_remit_rgst_b_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_ifcs_jud_remit_rgst_b.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.remit_dt,chr(13),''),chr(10),'') as remit_dt
,replace(replace(t1.remit_flow_num,chr(13),''),chr(10),'') as remit_flow_num
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.remit_way,chr(13),''),chr(10),'') as remit_way
,replace(replace(t1.remit_proof_type,chr(13),''),chr(10),'') as remit_proof_type
,replace(replace(t1.proof_num,chr(13),''),chr(10),'') as proof_num
,replace(replace(t1.exec_org_cd,chr(13),''),chr(10),'') as exec_org_cd
,replace(replace(t1.exec_cert_type_01,chr(13),''),chr(10),'') as exec_cert_type_01
,replace(replace(t1.exec_cert_no_01,chr(13),''),chr(10),'') as exec_cert_no_01
,replace(replace(t1.exec_cert_type_02,chr(13),''),chr(10),'') as exec_cert_type_02
,replace(replace(t1.exec_cert_no_02,chr(13),''),chr(10),'') as exec_cert_no_02
,replace(replace(t1.exec_ps_01,chr(13),''),chr(10),'') as exec_ps_01
,replace(replace(t1.remit_rs,chr(13),''),chr(10),'') as remit_rs
,replace(replace(t1.teller_no,chr(13),''),chr(10),'') as teller_no
,replace(replace(t1.org_no,chr(13),''),chr(10),'') as org_no
,replace(replace(t1.init_froz_dt,chr(13),''),chr(10),'') as init_froz_dt
,replace(replace(t1.init_froz_flow,chr(13),''),chr(10),'') as init_froz_flow
,t1.remit_amt as remit_amt
,replace(replace(t1.exec_ps_02,chr(13),''),chr(10),'') as exec_ps_02
,replace(replace(t1.remit_chn,chr(13),''),chr(10),'') as remit_chn
,replace(replace(t1.remit_tm,chr(13),''),chr(10),'') as remit_tm
 from iol.ifcs_jud_remit_rgst_b T1
where remit_dt= '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_ifcs_jud_remit_rgst_b.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes