: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_bill_redcst_dtl_f
CreateDate: 20221021
FileName:   ${iel_data_path}/agt_bill_redcst_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(agt_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(redcst_dtl_id,chr(13),''),chr(10),'')
,replace(replace(batch_id,chr(13),''),chr(10),'')
,replace(replace(bill_id,chr(13),''),chr(10),'')
,fac_val_amt
,bill_exp_dt
,actl_exp_dt
,surp_tenor
,int_paybl
,stl_amt
,exp_stl_amt
,replace(replace(lmt_ocup_status_cd,chr(13),''),chr(10),'')
,replace(replace(proc_status_cd,chr(13),''),chr(10),'')
,replace(replace(entry_status_cd,chr(13),''),chr(10),'')
,replace(replace(valid_flg,chr(13),''),chr(10),'')
,replace(replace(discount_bill_flg,chr(13),''),chr(10),'')
,replace(replace(remote_bill_flg,chr(13),''),chr(10),'')
,replace(replace(policy_std_flg,chr(13),''),chr(10),'')
,replace(replace(refuse_flg,chr(13),''),chr(10),'')
,replace(replace(bill_sub_intrv_id,chr(13),''),chr(10),'')
,bill_intrv_std_amt
,replace(replace(bf_split_intrv_id,chr(13),''),chr(10),'')
,replace(replace(bill_num,chr(13),''),chr(10),'')
,init_bill_amt
,create_dt
,update_dt
,replace(replace(id_mark,chr(13),''),chr(10),'')
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.agt_bill_redcst_dtl t1
where 1=1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_redcst_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
