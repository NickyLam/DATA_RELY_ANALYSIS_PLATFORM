: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_bill_discnt_dtl_f
CreateDate: 20221021
FileName:   ${iel_data_path}/agt_bill_discnt_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(agt_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(buy_dtl_id,chr(13),''),chr(10),'')
,replace(replace(buy_way_cd,chr(13),''),chr(10),'')
,replace(replace(batch_id,chr(13),''),chr(10),'')
,replace(replace(discnt_type_cd,chr(13),''),chr(10),'')
,replace(replace(bill_id,chr(13),''),chr(10),'')
,replace(replace(city_wide_flg,chr(13),''),chr(10),'')
,replace(replace(rher_name,chr(13),''),chr(10),'')
,int_accr_exp_dt
,defer_days
,int_accr_days
,replace(replace(not_ngbl_flg,chr(13),''),chr(10),'')
,int_amt
,replace(replace(onl_clear_flg,chr(13),''),chr(10),'')
,buyer_pay_int
,actl_amt
,replace(replace(discnt_appl_enter_acct_num,chr(13),''),chr(10),'')
,replace(replace(discnt_appl_enter_acct_bk_no,chr(13),''),chr(10),'')
,replace(replace(dscnt_props_cate_cd,chr(13),''),chr(10),'')
,replace(replace(dscnt_props_name,chr(13),''),chr(10),'')
,replace(replace(dscnt_props_orgnz_cd,chr(13),''),chr(10),'')
,replace(replace(dscnt_props_acct_num,chr(13),''),chr(10),'')
,replace(replace(dscnt_props_udtake_bk_no,chr(13),''),chr(10),'')
,replace(replace(tran_cont_id,chr(13),''),chr(10),'')
,entry_dt
,replace(replace(entry_status_cd,chr(13),''),chr(10),'')
,recv_dt
,replace(replace(buy_dtl_status_cd,chr(13),''),chr(10),'')
,final_modif_tm
,replace(replace(modif_teller_id,chr(13),''),chr(10),'')
,replace(replace(bill_sub_intrv_id,chr(13),''),chr(10),'')
,replace(replace(quick_discnt_status_cd,chr(13),''),chr(10),'')
,replace(replace(quick_discnt_flg,chr(13),''),chr(10),'')
,replace(replace(bill_src_cd,chr(13),''),chr(10),'')
,replace(replace(h_data_flg,chr(13),''),chr(10),'')
,replace(replace(crdt_out_acct_flow_num,chr(13),''),chr(10),'')
,create_dt
,update_dt
,replace(replace(id_mark,chr(13),''),chr(10),'')
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.agt_bill_discnt_dtl t1
where 1=1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_discnt_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
