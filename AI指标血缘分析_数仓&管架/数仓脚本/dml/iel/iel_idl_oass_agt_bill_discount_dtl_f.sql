: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_bill_discount_dtl_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_bill_discount_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.discount_dtl_id as discount_dtl_id
,t1.cont_id as cont_id
,t1.bill_id as bill_id
,t1.bill_amt as bill_amt
,t1.bill_exp_dt as bill_exp_dt
,t1.actl_exp_dt as actl_exp_dt
,t1.surp_tenor as surp_tenor
,t1.exp_surp_tenor as exp_surp_tenor
,t1.int_paybl as int_paybl
,t1.exp_int_paybl as exp_int_paybl
,t1.stl_amt as stl_amt
,t1.exp_stl_amt as exp_stl_amt
,t1.lmt_ocup_status_cd as lmt_ocup_status_cd
,t1.proc_status_cd as proc_status_cd
,t1.entry_status_cd as entry_status_cd
,t1.valid_flg as valid_flg
,t1.crdt_main_type_cd as crdt_main_type_cd
,t1.crdt_main_id as crdt_main_id
,t1.bill_intrv_std_amt as bill_intrv_std_amt
,t1.bf_split_intrv_id as bf_split_intrv_id
,t1.init_bill_amt as init_bill_amt
,t1.bill_num as bill_num
,t1.bill_sub_intrv_id as bill_sub_intrv_id
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_bill_discount_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_bill_discount_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
