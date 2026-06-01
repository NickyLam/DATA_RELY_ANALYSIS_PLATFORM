: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_fft_bus_info_h_f
CreateDate: 20240507
FileName:   ${iel_data_path}/agt_fft_bus_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.intnal_id,chr(13),''),chr(10),'') as intnal_id
,replace(replace(t1.ref_no,chr(13),''),chr(10),'') as ref_no
,replace(replace(t1.lc_bus_id,chr(13),''),chr(10),'') as lc_bus_id
,replace(replace(t1.tran_sketch,chr(13),''),chr(10),'') as tran_sketch
,replace(replace(t1.pkg_buy_bk_comb,chr(13),''),chr(10),'') as pkg_buy_bk_comb
,replace(replace(t1.present_id,chr(13),''),chr(10),'') as present_id
,replace(replace(t1.present_ps_name,chr(13),''),chr(10),'') as present_ps_name
,rgst_dt
,open_dt
,open_exp_dt
,replace(replace(t1.close_flg,chr(13),''),chr(10),'') as close_flg
,close_dt
,value_dt
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.parent_intnal_id,chr(13),''),chr(10),'') as parent_intnal_id
,replace(replace(t1.parent_ref_no,chr(13),''),chr(10),'') as parent_ref_no
,replace(replace(t1.parent_tran_abbr,chr(13),''),chr(10),'') as parent_tran_abbr
,replace(replace(t1.parent_tran_name,chr(13),''),chr(10),'') as parent_tran_name
,replace(replace(t1.inv_role_name,chr(13),''),chr(10),'') as inv_role_name
,modif_dt
,modif_cnt
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
,replace(replace(t1.aldy_tran_sell_flg,chr(13),''),chr(10),'') as aldy_tran_sell_flg
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark

from ${iml_schema}.agt_fft_bus_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_fft_bus_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
