/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_e_r_cashinfoinf2002
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.cqss_e_r_cashinfoinf2002_ex purge;
alter table ${iol_schema}.cqss_e_r_cashinfoinf2002 add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_e_r_cashinfoinf2002 truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_e_r_cashinfoinf2002_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_e_r_cashinfoinf2002 where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_e_r_cashinfoinf2002_ex(
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,cr_supr_rcrd_id -- 征信上级记录编号(上级序号)
    ,rtpd_and_prd_lbrsvc_cash -- 销售商品和提供劳务收到的现金:EG05BJ01
    ,rcvd_taxfee_ret -- 收到的税费返还:EG05BJ02
    ,rdothr_wth_optavy_cash -- 收到的其他与经营活动有关的现金:EG05BJ03
    ,oprt_avy_flwcsh_sbtl -- 经营活动现金流入小计:EG05BJ04
    ,prch_cdty_acptsvc_pycsh -- 购买商品、接受劳务支付的现金:EG05BJ05
    ,pygv_wkrs_forwkrs_pycsh -- 支付给职工以及为职工支付的现金:EG05BJ06
    ,py_et_taxfee -- 支付的各项税费:EG05BJ07
    ,py_othr_oprt_avy_cash -- 支付的其他与经营活动有关的现金:EG05BJ08
    ,oprt_avy_cf_out_sbtl -- 经营活动现金流出小计:EG05BJ09
    ,oprt_avy_gen_cf_netamt -- 经营活动产生的现金流量净额:EG05BJ10
    ,wtd_ivsplc_rcvsch -- 收回投资所收到的现金:EG05BJ11
    ,obis_icpl_rcvsch -- 取得投资收益所收到的现金:EG05BJ12
    ,dpl_ast_plc_cash -- 处置固定资产无形资产和其他长期资产所收回的现金净额:EG05BJ13
    ,rd_othr_ivs_avy_relcsh -- 收到的其他与投资活动有关的现金:EG05BJ14
    ,ivs_avy_flowcash_sbtl -- 投资活动现金流入小计:EG05BJ15
    ,acfxat_ast_plc_pycsh -- 购建固定资产无形资产和其他长期资产所支付的现金:EG05BJ16
    ,ivs_plc_pycsh -- 投资所支付的现金:EG05BJ17
    ,py_othr_ivs_avy_cash -- 支付的其他与投资活动有关的现金:EG05BJ18
    ,ivs_avy_cf_out_sbtl -- 投资活动现金流出小计:EG05BJ19
    ,ivs_avy_gen_cf_netamt -- 投资活动产生的现金流量净额:EG05BJ20
    ,absrb_ivs_plc_cash -- 吸收投资所收到的现金:EG05BJ21
    ,lnd_plc_rcvd_cash -- 借款所收到的现金:EG05BJ22
    ,rcvd_othr_fnc_avy_cash -- 收到的其他与筹资活动有关的现金:EG05BJ23
    ,fnc_avy_flowcash_sbtl -- 筹资活动现金流入小计:EG05BJ24
    ,repy_dbt_plc_pys_cash -- 偿还债务所支付的现金:EG05BJ25
    ,alct_dvdn_pft_cmpn_plc_pycsh -- 分配股利、利润或偿付利息所支付的现金:EG05BJ26
    ,py_othr_fnc_avy_rel_cash -- 支付的其他与筹资活动有关的现金:EG05BJ27
    ,fnc_avy_cf_out_sbtl -- 筹资活动现金流出小计:EG05BJ28
    ,set_avy_gen_cf_num_netamt -- 筹集活动产生的现金流量净额:EG05BJ29
    ,erch_to_cash_aff -- 汇率变动对现金的影响:EG05BJ30
    ,cash_eqv_ntic_add_amt -- 现金及现金等价物净增加额:EG05BJ31
    ,net_pft -- 净利润:EG05BJ32
    ,acr_ast_dprcnrsrv -- 计提的资产减值准备:EG05BJ33
    ,fix_ast_old -- 固定资产拆旧:EG05BJ34
    ,intgbl_ast_amrz -- 无形资产摊销:EG05BJ35
    ,longtrm_ppdex_amrz -- 长期待摊费用摊销:EG05BJ36
    ,ppdex_rdc -- 待摊费用减少:EG05BJ37
    ,pnex_add -- 预提费用增加:EG05BJ38
    ,displ_ast_loss -- 处置固定资产无形资产和其他长期资产的损失:EG05BJ39
    ,fix_ast_scrp_loss -- 固定资产报废损失:EG05BJ40
    ,fncex -- 财务费用:EG05BJ41
    ,ivs_loss -- 投资损失:EG05BJ42
    ,dfr_taxpymt_crnt -- 递延税款贷项:EG05BJ43
    ,ivnt_s_rdc -- 存货的减少:EG05BJ44
    ,oprg_rcvb_prj_rdc -- 经营性应收项目的减少:EG05BJ45
    ,oprg_pbl_prj_add -- 经营性应付项目的增加:EG05BJ46
    ,othr_oprt_avy_cash_flow -- （净利润调节为经营活动现金流量科目下）其他:EG05BJ47
    ,oprt_avy_cf_netamt -- 经营活动产生的现金流量净额:EG05BJ48
    ,dbt_tfr_for_cptl -- 债务转为资本:EG05BJ49
    ,in1yr_exp_cnvrt_cobd -- 一年内到期的可转换公司债券:EG05BJ50
    ,fnc_rnt_fix_ast -- 融资租入固定资产:EG05BJ51
    ,othr_not_cash_ivs -- （不涉及现金收支的投资和筹资活动科目下）其他:EG05BJ52
    ,cash_endofprdbal -- 现金的期末余额:EG05BJ53
    ,cash_bgnprdbal -- 现金的期初余额:EG05BJ54
    ,cash_eqv_endofprdbal -- 现金等价物的期末余额:EG05BJ55
    ,cash_eqv_bgnprdbal -- 现金等价物的期初余额:EG05BJ56
    ,csheqv_ntic_add_amt -- 现金及现金等价物净增加额:EG05BJ57
    ,crt_dt_tm -- 创建日期时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,cr_supr_rcrd_id -- 征信上级记录编号(上级序号)
    ,rtpd_and_prd_lbrsvc_cash -- 销售商品和提供劳务收到的现金:EG05BJ01
    ,rcvd_taxfee_ret -- 收到的税费返还:EG05BJ02
    ,rdothr_wth_optavy_cash -- 收到的其他与经营活动有关的现金:EG05BJ03
    ,oprt_avy_flwcsh_sbtl -- 经营活动现金流入小计:EG05BJ04
    ,prch_cdty_acptsvc_pycsh -- 购买商品、接受劳务支付的现金:EG05BJ05
    ,pygv_wkrs_forwkrs_pycsh -- 支付给职工以及为职工支付的现金:EG05BJ06
    ,py_et_taxfee -- 支付的各项税费:EG05BJ07
    ,py_othr_oprt_avy_cash -- 支付的其他与经营活动有关的现金:EG05BJ08
    ,oprt_avy_cf_out_sbtl -- 经营活动现金流出小计:EG05BJ09
    ,oprt_avy_gen_cf_netamt -- 经营活动产生的现金流量净额:EG05BJ10
    ,wtd_ivsplc_rcvsch -- 收回投资所收到的现金:EG05BJ11
    ,obis_icpl_rcvsch -- 取得投资收益所收到的现金:EG05BJ12
    ,dpl_ast_plc_cash -- 处置固定资产无形资产和其他长期资产所收回的现金净额:EG05BJ13
    ,rd_othr_ivs_avy_relcsh -- 收到的其他与投资活动有关的现金:EG05BJ14
    ,ivs_avy_flowcash_sbtl -- 投资活动现金流入小计:EG05BJ15
    ,acfxat_ast_plc_pycsh -- 购建固定资产无形资产和其他长期资产所支付的现金:EG05BJ16
    ,ivs_plc_pycsh -- 投资所支付的现金:EG05BJ17
    ,py_othr_ivs_avy_cash -- 支付的其他与投资活动有关的现金:EG05BJ18
    ,ivs_avy_cf_out_sbtl -- 投资活动现金流出小计:EG05BJ19
    ,ivs_avy_gen_cf_netamt -- 投资活动产生的现金流量净额:EG05BJ20
    ,absrb_ivs_plc_cash -- 吸收投资所收到的现金:EG05BJ21
    ,lnd_plc_rcvd_cash -- 借款所收到的现金:EG05BJ22
    ,rcvd_othr_fnc_avy_cash -- 收到的其他与筹资活动有关的现金:EG05BJ23
    ,fnc_avy_flowcash_sbtl -- 筹资活动现金流入小计:EG05BJ24
    ,repy_dbt_plc_pys_cash -- 偿还债务所支付的现金:EG05BJ25
    ,alct_dvdn_pft_cmpn_plc_pycsh -- 分配股利、利润或偿付利息所支付的现金:EG05BJ26
    ,py_othr_fnc_avy_rel_cash -- 支付的其他与筹资活动有关的现金:EG05BJ27
    ,fnc_avy_cf_out_sbtl -- 筹资活动现金流出小计:EG05BJ28
    ,set_avy_gen_cf_num_netamt -- 筹集活动产生的现金流量净额:EG05BJ29
    ,erch_to_cash_aff -- 汇率变动对现金的影响:EG05BJ30
    ,cash_eqv_ntic_add_amt -- 现金及现金等价物净增加额:EG05BJ31
    ,net_pft -- 净利润:EG05BJ32
    ,acr_ast_dprcnrsrv -- 计提的资产减值准备:EG05BJ33
    ,fix_ast_old -- 固定资产拆旧:EG05BJ34
    ,intgbl_ast_amrz -- 无形资产摊销:EG05BJ35
    ,longtrm_ppdex_amrz -- 长期待摊费用摊销:EG05BJ36
    ,ppdex_rdc -- 待摊费用减少:EG05BJ37
    ,pnex_add -- 预提费用增加:EG05BJ38
    ,displ_ast_loss -- 处置固定资产无形资产和其他长期资产的损失:EG05BJ39
    ,fix_ast_scrp_loss -- 固定资产报废损失:EG05BJ40
    ,fncex -- 财务费用:EG05BJ41
    ,ivs_loss -- 投资损失:EG05BJ42
    ,dfr_taxpymt_crnt -- 递延税款贷项:EG05BJ43
    ,ivnt_s_rdc -- 存货的减少:EG05BJ44
    ,oprg_rcvb_prj_rdc -- 经营性应收项目的减少:EG05BJ45
    ,oprg_pbl_prj_add -- 经营性应付项目的增加:EG05BJ46
    ,othr_oprt_avy_cash_flow -- （净利润调节为经营活动现金流量科目下）其他:EG05BJ47
    ,oprt_avy_cf_netamt -- 经营活动产生的现金流量净额:EG05BJ48
    ,dbt_tfr_for_cptl -- 债务转为资本:EG05BJ49
    ,in1yr_exp_cnvrt_cobd -- 一年内到期的可转换公司债券:EG05BJ50
    ,fnc_rnt_fix_ast -- 融资租入固定资产:EG05BJ51
    ,othr_not_cash_ivs -- （不涉及现金收支的投资和筹资活动科目下）其他:EG05BJ52
    ,cash_endofprdbal -- 现金的期末余额:EG05BJ53
    ,cash_bgnprdbal -- 现金的期初余额:EG05BJ54
    ,cash_eqv_endofprdbal -- 现金等价物的期末余额:EG05BJ55
    ,cash_eqv_bgnprdbal -- 现金等价物的期初余额:EG05BJ56
    ,csheqv_ntic_add_amt -- 现金及现金等价物净增加额:EG05BJ57
    ,crt_dt_tm -- 创建日期时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_e_r_cashinfoinf2002
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_e_r_cashinfoinf2002 exchange partition p_${batch_date} with table ${iol_schema}.cqss_e_r_cashinfoinf2002_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_e_r_cashinfoinf2002 to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_e_r_cashinfoinf2002_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_e_r_cashinfoinf2002',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);