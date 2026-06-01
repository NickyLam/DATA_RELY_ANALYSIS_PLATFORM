: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_elec_bill_tran_flow_f
CreateDate: 20230602
FileName:   ${iel_data_path}/evt_elec_bill_tran_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.info_type_cd,chr(13),''),chr(10),'') as info_type_cd
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num
,replace(replace(t1.reqer_cate_cd,chr(13),''),chr(10),'') as reqer_cate_cd
,replace(replace(t1.reqer_name,chr(13),''),chr(10),'') as reqer_name
,replace(replace(t1.reqer_orgnz_cd,chr(13),''),chr(10),'') as reqer_orgnz_cd
,replace(replace(t1.reqer_acct_num,chr(13),''),chr(10),'') as reqer_acct_num
,replace(replace(t1.reqer_open_bank_no,chr(13),''),chr(10),'') as reqer_open_bank_no
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name
,replace(replace(t1.recver_orgnz_cd,chr(13),''),chr(10),'') as recver_orgnz_cd
,replace(replace(t1.recver_acct_num,chr(13),''),chr(10),'') as recver_acct_num
,replace(replace(t1.recver_open_bank_no,chr(13),''),chr(10),'') as recver_open_bank_no
,recv_dt
,replace(replace(t1.onl_clear_cd,chr(13),''),chr(10),'') as onl_clear_cd
,replace(replace(t1.not_ngbl_cd,chr(13),''),chr(10),'') as not_ngbl_cd
,int_rat
,redem_int_rat
,tran_amt
,redem_actl_amt
,replace(replace(t1.discnt_kind_cd,chr(13),''),chr(10),'') as discnt_kind_cd
,appl_dt
,sugst_pay_amt
,replace(replace(t1.refuse_pay_cd,chr(13),''),chr(10),'') as refuse_pay_cd
,replace(replace(t1.recs_type_cd,chr(13),''),chr(10),'') as recs_type_cd
,replace(replace(t1.lh_buy_tran_id,chr(13),''),chr(10),'') as lh_buy_tran_id
,replace(replace(t1.tran_status_descb,chr(13),''),chr(10),'') as tran_status_descb
,replace(replace(t1.bill_status_cd,chr(13),''),chr(10),'') as bill_status_cd
,payoff_dt
,replace(replace(t1.h_data_flg,chr(13),''),chr(10),'') as h_data_flg
,replace(replace(t1.tran_id,chr(13),''),chr(10),'') as tran_id

from ${iml_schema}.evt_elec_bill_tran_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_elec_bill_tran_flow.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
