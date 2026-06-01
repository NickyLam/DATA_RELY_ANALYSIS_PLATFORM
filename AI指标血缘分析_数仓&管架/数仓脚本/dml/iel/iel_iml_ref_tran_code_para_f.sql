: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_tran_code_para_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_tran_code_para.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.bus_cls_cd,chr(13),''),chr(10),'') as bus_cls_cd
,replace(replace(t1.a_calc_bal_stop_pay_flg,chr(13),''),chr(10),'') as a_calc_bal_stop_pay_flg
,replace(replace(t1.revs_tran_code,chr(13),''),chr(10),'') as revs_tran_code
,replace(replace(t1.tran_code_descb,chr(13),''),chr(10),'') as tran_code_descb
,replace(replace(t1.cntpty_tran_code,chr(13),''),chr(10),'') as cntpty_tran_code
,replace(replace(t1.a_calc_lmt_amt_flg,chr(13),''),chr(10),'') as a_calc_lmt_amt_flg
,replace(replace(t1.revs_flg,chr(13),''),chr(10),'') as revs_flg
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.aval_bal_calc_type_cd,chr(13),''),chr(10),'') as aval_bal_calc_type_cd
,replace(replace(t1.multi_revs_way_flg,chr(13),''),chr(10),'') as multi_revs_way_flg
,replace(replace(t1.cash_tran_flg,chr(13),''),chr(10),'') as cash_tran_flg
,replace(replace(t1.cor_tran_flg,chr(13),''),chr(10),'') as cor_tran_flg
,replace(replace(t1.tran_cls_cd,chr(13),''),chr(10),'') as tran_cls_cd
,replace(replace(t1.debit_crdt_flg,chr(13),''),chr(10),'') as debit_crdt_flg
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.ref_tran_code_para t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_tran_code_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes