: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_ifs_jud_remit_rgst_b_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_ifs_jud_remit_rgst_b.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,t1.unfrz_dt as unfrz_dt
,replace(replace(t1.unfrz_tm,chr(13),''),chr(10),'') as unfrz_tm
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.remit_way_cd,chr(13),''),chr(10),'') as remit_way_cd
,replace(replace(t1.remit_proof_cate_cd,chr(13),''),chr(10),'') as remit_proof_cate_cd
,replace(replace(t1.proof_num,chr(13),''),chr(10),'') as proof_num
,replace(replace(t1.exec_org,chr(13),''),chr(10),'') as exec_org
,replace(replace(t1.exec_ps_cert_type_cd_1,chr(13),''),chr(10),'') as exec_ps_cert_type_cd_1
,replace(replace(t1.exec_ps_cert_no_1,chr(13),''),chr(10),'') as exec_ps_cert_no_1
,replace(replace(t1.exec_ps_cert_type_cd_2,chr(13),''),chr(10),'') as exec_ps_cert_type_cd_2
,replace(replace(t1.exec_ps_cert_no_2,chr(13),''),chr(10),'') as exec_ps_cert_no_2
,replace(replace(t1.exec_ps_name,chr(13),''),chr(10),'') as exec_ps_name
,replace(replace(t1.remit_rs,chr(13),''),chr(10),'') as remit_rs
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,t1.init_froz_dt as init_froz_dt
,replace(replace(t1.init_froz_flow_num,chr(13),''),chr(10),'') as init_froz_flow_num
,t1.remit_amt as remit_amt
,replace(replace(t1.oper_teller_id_2,chr(13),''),chr(10),'') as oper_teller_id_2
,replace(replace(t1.jud_remit_chn_id,chr(13),''),chr(10),'') as jud_remit_chn_id
from ${iml_schema}.evt_ifs_jud_remit_rgst_b t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ifs_jud_remit_rgst_b.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes