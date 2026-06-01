: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_beps_stop_pay_appl_a
CreateDate: 20230512
FileName:   ${iel_data_path}/evt_beps_stop_pay_appl.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.appl_seq_num,chr(13),''),chr(10),'') as appl_seq_num
,midgrod_dt
,replace(replace(t1.midgrod_flow_num,chr(13),''),chr(10),'') as midgrod_flow_num
,replace(replace(t1.obank_init_stop_pay_flg,chr(13),''),chr(10),'') as obank_init_stop_pay_flg
,appl_dt
,replace(replace(t1.appl_clear_bk_no,chr(13),''),chr(10),'') as appl_clear_bk_no
,replace(replace(t1.appl_bk_no,chr(13),''),chr(10),'') as appl_bk_no
,replace(replace(t1.reply_clear_bk_no,chr(13),''),chr(10),'') as reply_clear_bk_no
,replace(replace(t1.reply_bk_no,chr(13),''),chr(10),'') as reply_bk_no
,replace(replace(t1.appl_type_cd,chr(13),''),chr(10),'') as appl_type_cd
,replace(replace(t1.appl_stop_pay_cnt,chr(13),''),chr(10),'') as appl_stop_pay_cnt
,replace(replace(t1.agree_stop_pay_cnt,chr(13),''),chr(10),'') as agree_stop_pay_cnt
,replace(replace(t1.init_init_org_id,chr(13),''),chr(10),'') as init_init_org_id
,replace(replace(t1.init_recv_bank_no,chr(13),''),chr(10),'') as init_recv_bank_no
,replace(replace(t1.init_pay_bank_no,chr(13),''),chr(10),'') as init_pay_bank_no
,init_entr_dt
,replace(replace(t1.init_dtl_ind_no,chr(13),''),chr(10),'') as init_dtl_ind_no
,replace(replace(t1.init_bus_type_id,chr(13),''),chr(10),'') as init_bus_type_id
,appl_stop_pay_amt
,replace(replace(t1.appl_remark,chr(13),''),chr(10),'') as appl_remark
,replace(replace(t1.reply_remark,chr(13),''),chr(10),'') as reply_remark
,replace(replace(t1.stop_pay_reply_status_cd,chr(13),''),chr(10),'') as stop_pay_reply_status_cd
,replace(replace(t1.appl_teller_id,chr(13),''),chr(10),'') as appl_teller_id
,replace(replace(t1.proc_status_cd,chr(13),''),chr(10),'') as proc_status_cd
,reply_dt

from ${iml_schema}.evt_beps_stop_pay_appl t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_beps_stop_pay_appl.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
