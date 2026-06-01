: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_comb_prod_info_h_f
CreateDate: 20230817
FileName:   ${iel_data_path}/prd_comb_prod_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.comb_prod_id,chr(13),''),chr(10),'') as comb_prod_id
,replace(replace(t1.comb_prod_name,chr(13),''),chr(10),'') as comb_prod_name
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t1.prod_risk_level_cd,chr(13),''),chr(10),'') as prod_risk_level_cd
,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,replace(replace(t1.tran_mode,chr(13),''),chr(10),'') as tran_mode
,replace(replace(t1.fin_mode_cd,chr(13),''),chr(10),'') as fin_mode_cd
,replace(replace(t1.open_tm,chr(13),''),chr(10),'') as open_tm
,replace(replace(t1.close_tm,chr(13),''),chr(10),'') as close_tm
,sevn_aual_yld
,ten_thous_prft
,indv_lowt_aip_amt
,amax_bamt
,acm_max_redem_amt
,supp_invest_amt
,create_tm
,final_modif_tm
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark

from ${iml_schema}.prd_comb_prod_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_comb_prod_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
