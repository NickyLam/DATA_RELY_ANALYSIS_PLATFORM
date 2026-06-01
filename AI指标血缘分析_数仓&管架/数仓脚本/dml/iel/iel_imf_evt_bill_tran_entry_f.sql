: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_bill_tran_entry_f
CreateDate: 20241101
FileName:   ${iel_data_path}/evt_bill_tran_entry.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.rgst_id,chr(13),''),chr(10),'') as rgst_id
,replace(replace(t1.indent_id,chr(13),''),chr(10),'') as indent_id
,replace(replace(t1.tran_req_id,chr(13),''),chr(10),'') as tran_req_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,tran_dt
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.tran_attr_string,chr(13),''),chr(10),'') as tran_attr_string
,replace(replace(t1.belong_hq_org_id,chr(13),''),chr(10),'') as belong_hq_org_id
,replace(replace(t1.entry_tran_id,chr(13),''),chr(10),'') as entry_tran_id
,entry_dt
,replace(replace(t1.core_entry_flow_num,chr(13),''),chr(10),'') as core_entry_flow_num
,replace(replace(t1.entry_flg,chr(13),''),chr(10),'') as entry_flg
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,replace(replace(t1.entry_ext_attr,chr(13),''),chr(10),'') as entry_ext_attr
,final_entry_dt
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.bus_agt_id,chr(13),''),chr(10),'') as bus_agt_id
,replace(replace(t1.bus_dtl_id,chr(13),''),chr(10),'') as bus_dtl_id
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num
,bill_amt
,replace(replace(t1.bill_src_cd,chr(13),''),chr(10),'') as bill_src_cd
,replace(replace(t1.sys_id,chr(13),''),chr(10),'') as sys_id
,replace(replace(t1.init_bill_id,chr(13),''),chr(10),'') as init_bill_id
,replace(replace(t1.bill_sub_intrv_id,chr(13),''),chr(10),'') as bill_sub_intrv_id
,replace(replace(t1.allow_pkg_ccution_flg,chr(13),''),chr(10),'') as allow_pkg_ccution_flg
,replace(replace(t1.old_init_bill_id,chr(13),''),chr(10),'') as old_init_bill_id
,replace(replace(t1.splt_bf_bill_id,chr(13),''),chr(10),'') as splt_bf_bill_id
,ext_amt_1
,ext_amt_2
,ext_amt_3
,replace(replace(t1.prtcptr_ext,chr(13),''),chr(10),'') as prtcptr_ext
,replace(replace(t1.intfc_return_code,chr(13),''),chr(10),'') as intfc_return_code
,replace(replace(t1.intfc_return_type_cd,chr(13),''),chr(10),'') as intfc_return_type_cd
,replace(replace(t1.intfc_return_descb,chr(13),''),chr(10),'') as intfc_return_descb
,replace(replace(t1.remark_1,chr(13),''),chr(10),'') as remark_1
,replace(replace(t1.remark_2,chr(13),''),chr(10),'') as remark_2
,replace(replace(t1.remark_3,chr(13),''),chr(10),'') as remark_3
,replace(replace(t1.remark_4,chr(13),''),chr(10),'') as remark_4
,replace(replace(t1.fin_org_id,chr(13),''),chr(10),'') as fin_org_id
,fir_create_dt
,final_update_tm
,replace(replace(t1.final_operr_id,chr(13),''),chr(10),'') as final_operr_id

from ${iml_schema}.evt_bill_tran_entry t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_bill_tran_entry.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
