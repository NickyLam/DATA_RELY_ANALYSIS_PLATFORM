: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_careerdebtinfo2013_i
CreateDate: 20241216
FileName:   ${iel_data_path}/cqss_e_r_careerdebtinfo2013.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t1.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,replace(replace(t1.cr_supr_rcrd_id,chr(13),''),chr(10),'') as cr_supr_rcrd_id
,ccy_fnds
,shrttm_ivs
,fnc_shld_ret_lmt
,rcvb_bl
,rcvb
,prpy_accval
,othr_rv
,ivnt
,othr_lqud_ast
,lqud_ast_tot
,ltemivs
,fix_ast
,fix_ast_ori_prc
,acm_dprcn
,ucpt
,intgbl_ast
,intgbl_ast_ori_prc
,acm_amrz
,to_displ_ast
,non_lqud_ast_tot
,ast_tot
,shrttm_lnd
,pbl_taxfee
,pbl_trsr_amt
,pbl_fnc_spclacc_amt
,empe_wage_expn
,pbl_bl
,pbl_accval
,riav_accval
,othr_pl
,othr_lqud_lby
,lqud_lby_tot
,longtrm_lnd
,longtrm_pybl
,non_lqud_lby_tot
,lby_tot
,crer_fnd
,non_lqud_ast_fnd
,spclpps_fnd
,fnc_alwc_crrov
,fnc_alwc_srpls
,non_fnc_alwc_crrov
,non_fnc_alwc_srpls
,crer_srpls
,oprt_srpls
,netast_tot
,lby_and_netast_tot
,crt_dt_tm

from ${iol_schema}.cqss_e_r_careerdebtinfo2013 t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_careerdebtinfo2013.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
