: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_lease_rent_asset_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/ast_lease_rent_asset_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lease_asset_ser_num,chr(13),''),chr(10),'') as lease_asset_ser_num
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.asset_ser_num,chr(13),''),chr(10),'') as asset_ser_num
,replace(replace(t1.lease_cont_ser_num,chr(13),''),chr(10),'') as lease_cont_ser_num
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.cont_name,chr(13),''),chr(10),'') as cont_name
,cont_effect_dt
,replace(replace(t1.rent_ps_name,chr(13),''),chr(10),'') as rent_ps_name
,replace(replace(t1.acct_b_id,chr(13),''),chr(10),'') as acct_b_id
,replace(replace(t1.asset_type_id,chr(13),''),chr(10),'') as asset_type_id
,replace(replace(t1.asset_name,chr(13),''),chr(10),'') as asset_name
,replace(replace(t1.asset_cate_ser_num,chr(13),''),chr(10),'') as asset_cate_ser_num
,replace(replace(t1.asset_qtty,chr(13),''),chr(10),'') as asset_qtty
,replace(replace(t1.asset_status_cd,chr(13),''),chr(10),'') as asset_status_cd
,replace(replace(t1.enter_acct_flg,chr(13),''),chr(10),'') as enter_acct_flg
,rent_start_dt
,rent_exp_dt
,replace(replace(t1.rent_tenor,chr(13),''),chr(10),'') as rent_tenor
,rent_tax_lmt
,plan_pay_pre_tax_tot
,plan_pay_at_tot
,year_disct_rat
,day_disct_rat
,effect_tm
,invalid_tm
,mtg_amt
,replace(replace(t1.pay_freq_cd,chr(13),''),chr(10),'') as pay_freq_cd
,replace(replace(t1.rent_cont_idtfy_ser_num,chr(13),''),chr(10),'') as rent_cont_idtfy_ser_num
,rent_area
,replace(replace(t1.inv_type_cd,chr(13),''),chr(10),'') as inv_type_cd
,replace(replace(t1.rent_usage_type_cd,chr(13),''),chr(10),'') as rent_usage_type_cd
,replace(replace(t1.mode_pay_cd,chr(13),''),chr(10),'') as mode_pay_cd
,replace(replace(t1.dedu_flg,chr(13),''),chr(10),'') as dedu_flg
,prepay_amorted_bal
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id

from ${iml_schema}.ast_lease_rent_asset_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_lease_rent_asset_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
