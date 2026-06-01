: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_mercht_tran_dtl_f
CreateDate: 20230804
FileName:   ${iel_data_path}/evt_mercht_tran_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,tran_tm
,tran_dt
,replace(replace(t1.tran_type_descb,chr(13),''),chr(10),'') as tran_type_descb
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,tran_amt
,replace(replace(t1.mercht_no,chr(13),''),chr(10),'') as mercht_no
,replace(replace(t1.mercht_name,chr(13),''),chr(10),'') as mercht_name
,replace(replace(t1.unionpay_mercht_cate_cd,chr(13),''),chr(10),'') as unionpay_mercht_cate_cd
,mercht_comm_fee
,int_paybl_amt
,recvbl_amt
,replace(replace(t1.debit_crdt_flg,chr(13),''),chr(10),'') as debit_crdt_flg
,replace(replace(t1.retriv_ref_id,chr(13),''),chr(10),'') as retriv_ref_id

from ${iml_schema}.evt_mercht_tran_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_mercht_tran_dtl.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
