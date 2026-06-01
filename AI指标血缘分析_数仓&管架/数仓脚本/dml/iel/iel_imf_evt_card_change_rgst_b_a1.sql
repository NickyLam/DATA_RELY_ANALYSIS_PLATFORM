: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_card_change_rgst_b_a1
CreateDate: 20250513
FileName:   ${iel_data_path}/evt_card_change_rgst_b.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t1.etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,t1.appl_dt as appl_dt
,replace(replace(t1.init_card_no,chr(13),''),chr(10),'') as init_card_no
,t1.tran_dt as tran_dt
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.change_rs_cd,chr(13),''),chr(10),'') as change_rs_cd
,replace(replace(t1.modif_type_status_cd,chr(13),''),chr(10),'') as modif_type_status_cd
,t1.apot_draw_card_dt as apot_draw_card_dt
,replace(replace(t1.card_prod_id,chr(13),''),chr(10),'') as card_prod_id
,replace(replace(t1.new_card_num,chr(13),''),chr(10),'') as new_card_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.draw_way_cd,chr(13),''),chr(10),'') as draw_way_cd
,replace(replace(t1.save_num_change_card_flg,chr(13),''),chr(10),'') as save_num_change_card_flg
,replace(replace(t1.urgent_flg,chr(13),''),chr(10),'') as urgent_flg
,replace(replace(t1.loss_id,chr(13),''),chr(10),'') as loss_id
,replace(replace(t1.cust_addr,chr(13),''),chr(10),'') as cust_addr
,replace(replace(t1.zip_code,chr(13),''),chr(10),'') as zip_code
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.tel_num,chr(13),''),chr(10),'') as tel_num
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.appl_teller_id,chr(13),''),chr(10),'') as appl_teller_id
,t1.tran_tm as tran_tm
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
from ${iml_schema}.evt_card_change_rgst_b t1
where etl_dt between date'2024-01-01' and to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_card_change_rgst_b.a.${batch_date}.dat" \
        charset=utf8
        safe=yes