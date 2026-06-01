: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_clean_coll_bus_info_h_f
CreateDate: 20231110
FileName:   ${iel_data_path}/agt_clean_coll_bus_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.clean_coll_bus_id,chr(13),''),chr(10),'') as clean_coll_bus_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.tran_name,chr(13),''),chr(10),'') as tran_name
,draw_dt
,create_date
,effect_dt
,invalid_dt
,recvbl_dt
,replace(replace(t1.dsply_info_flg,chr(13),''),chr(10),'') as dsply_info_flg
,replace(replace(t1.clean_coll_form_cd,chr(13),''),chr(10),'') as clean_coll_form_cd
,replace(replace(t1.pay_way_cd,chr(13),''),chr(10),'') as pay_way_cd
,replace(replace(t1.stl_way_cd,chr(13),''),chr(10),'') as stl_way_cd
,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd
,replace(replace(t1.vrfction_slip_id,chr(13),''),chr(10),'') as vrfction_slip_id
,replace(replace(t1.decl_form_id,chr(13),''),chr(10),'') as decl_form_id
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.free_pay_flg,chr(13),''),chr(10),'') as free_pay_flg
,replace(replace(t1.nra_pay_flg,chr(13),''),chr(10),'') as nra_pay_flg
,replace(replace(t1.pkg_coll_bus_id,chr(13),''),chr(10),'') as pkg_coll_bus_id
,pkg_coll_recvbl_dt
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
,replace(replace(t1.bus_oper_org_id,chr(13),''),chr(10),'') as bus_oper_org_id
,replace(replace(t1.bus_belong_org_id,chr(13),''),chr(10),'') as bus_belong_org_id

from ${iml_schema}.agt_clean_coll_bus_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_clean_coll_bus_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
