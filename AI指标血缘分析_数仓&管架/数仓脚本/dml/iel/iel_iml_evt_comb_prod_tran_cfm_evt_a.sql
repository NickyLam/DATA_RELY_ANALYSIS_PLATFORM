: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_comb_prod_tran_cfm_evt_a
CreateDate: 20241227
FileName:   ${iel_data_path}/evt_comb_prod_tran_cfm_evt.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t1.ta_cfm_flow_num,chr(13),''),chr(10),'') as ta_cfm_flow_num
,cfm_dt
,replace(replace(t1.comb_prod_id,chr(13),''),chr(10),'') as comb_prod_id
,replace(replace(t1.comb_prod_name,chr(13),''),chr(10),'') as comb_prod_name
,replace(replace(t1.finc_prod_id,chr(13),''),chr(10),'') as finc_prod_id
,replace(replace(t1.bank_id,chr(13),''),chr(10),'') as bank_id
,replace(replace(t1.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id
,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd
,replace(replace(t1.ext_flow_num,chr(13),''),chr(10),'') as ext_flow_num
,replace(replace(t1.intnal_cust_id,chr(13),''),chr(10),'') as intnal_cust_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.vtual_bank_acct_id,chr(13),''),chr(10),'') as vtual_bank_acct_id
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,tran_amt
,tran_lot
,tran_tm
,cfm_amt
,cfm_lot
,cfm_comm_fee
,cfm_nv
,replace(replace(t1.bus_cd,chr(13),''),chr(10),'') as bus_cd
,replace(replace(t1.intior_cd,chr(13),''),chr(10),'') as intior_cd
,replace(replace(t1.deflt_divd_way_cd,chr(13),''),chr(10),'') as deflt_divd_way_cd
,divd_dt
,rgst_dt
,modif_tm
,return_amt
,replace(replace(t1.err_cd,chr(13),''),chr(10),'') as err_cd
,replace(replace(t1.err_info_desc,chr(13),''),chr(10),'') as err_info_desc

from ${iml_schema}.evt_comb_prod_tran_cfm_evt t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_comb_prod_tran_cfm_evt.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
