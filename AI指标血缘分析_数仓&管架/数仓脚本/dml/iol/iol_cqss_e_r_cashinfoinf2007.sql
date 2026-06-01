/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_e_r_cashinfoinf2007
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
drop table ${iol_schema}.cqss_e_r_cashinfoinf2007_ex purge;
alter table ${iol_schema}.cqss_e_r_cashinfoinf2007 add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_e_r_cashinfoinf2007 truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_e_r_cashinfoinf2007_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_e_r_cashinfoinf2007 where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_e_r_cashinfoinf2007_ex(
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,cr_supr_rcrd_id -- 征信上级记录编号(上级序号)
    ,rtpd_and_prd_lbrsvc_cash -- 销售商品和提供劳务收到的现金:EG06BJ01
    ,rcvd_taxfee_ret -- 收到的税费返还:EG06BJ02
    ,rdothr_wth_optavy_cash -- 收到其他与经营活动有关的现金:EG06BJ03
    ,oprt_avy_flwcsh_sbtl -- 经营活动现金流入小计:EG06BJ04
    ,prch_cdty_acptsvc_pycsh -- 购买商品、接受劳务支付的现金:EG06BJ05
    ,pygv_wkrs_forwkrs_pycsh -- 支付给职工以及为职工支付的现金:EG06BJ06
    ,py_et_taxfee -- 支付的各项税费:EG06BJ07
    ,py_othr_oprt_avy_cash -- 支付其他与经营活动有关的现金:EG06BJ08
    ,oprt_avy_cf_out_sbtl -- 经营活动现金流出小计:EG06BJ09
    ,oprt_avy_gen_cf_netamt -- 经营活动产生的现金流量净额:EG06BJ10
    ,wtd_ivsplc_rcvsch -- 收回投资所收到的现金:EG06BJ11
    ,obis_icpl_rcvsch -- 取得投资收益所收到的现金:EG06BJ12
    ,dpl_ast_plc_cash -- 处置固定资产无形资产和其他长期资产所收回的现金净额:EG06BJ13
    ,dpl_subs_oprgcl_cshntat -- 处置子公司及其他营业单位收到的现金净额:EG06BJ14
    ,rd_othr_ivs_avy_relcsh -- 收到其他与投资活动有关的现金:EG06BJ15
    ,ivs_avy_flowcash_sbtl -- 投资活动现金流入小计:EG06BJ16
    ,acfxat_ast_plc_pycsh -- 购建固定资产无形资产和其他长期资产所支付的现金:EG06BJ17
    ,ivs_plc_pycsh -- 投资所支付的现金:EG06BJ18
    ,obtn_subs_oprg_pyt_cshntat -- 取得子公司及其他营业单位支付的现金净额:EG06BJ19
    ,py_othr_ivs_avy_cash -- 支付其他与投资活动有关的现金:EG06BJ20
    ,ivs_avy_cf_out_sbtl -- 投资活动现金流出小计:EG06BJ21
    ,ivs_avy_gen_cf_netamt -- 投资活动产生的现金流量净额:EG06BJ22
    ,absrb_ivs_plc_cash -- 吸收投资收到的现金:EG06BJ23
    ,obtn_lnd_rcvds_cash -- 取得借款收到的现金:EG06BJ24
    ,rcvd_othr_fnc_avy_cash -- 收到其他与筹资活动有关的现金:EG06BJ25
    ,fnc_avy_flowcash_sbtl -- 筹资活动现金流入小计:EG06BJ26
    ,repy_dbt_plc_pys_cash -- 偿还债务所支付的现金:EG06BJ27
    ,alct_dvdn_pft_cmpn_plc_pycsh -- 分配股利、利润或偿付利息所支付的现金:EG06BJ28
    ,py_othr_fnc_avy_cash -- 支付其他与筹资活动有关的现金:EG06BJ29
    ,fnc_avy_cf_out_sbtl -- 筹资活动现金流出小计:EG06BJ30
    ,set_avy_gen_cf_netamt -- 筹集活动产生的现金流量净额:EG06BJ31
    ,erch_csh_and_csheqv_aff -- 汇率变动对现金及现金等价物的影响:EG06BJ32
    ,casheqv_add_amt -- 现金及现金等价物净增加额:EG06BJ33
    ,bop_casheqv_bal -- 期初现金及现金等价物余额:EG06BJ34
    ,eop_casheqv_bal -- 期末现金及现金等价物余额:EG06BJ35
    ,net_pft -- 净利润:EG06BJ36
    ,ast_dprcnrsrv -- 资产减值准备:EG06BJ37
    ,ast_dprcn -- 固定资产折旧、油气资产折耗、生产性生物资产折旧:EG06BJ38
    ,intgbl_ast_amrz -- 无形资产摊销:EG06BJ39
    ,longtrm_ppdex_amrz -- 长期待摊费用摊销:EG06BJ40
    ,ppdex_rdc -- 待摊费用减少:EG06BJ41
    ,pnex_add -- 预提费用增加:EG06BJ42
    ,displ_ast_loss -- 处置固定资产无形资产和其他长期资产的损失:EG06BJ43
    ,fix_ast_scrp_loss -- 固定资产报废损失:EG06BJ44
    ,fairval_chg_loss -- 公允价值变动损失:EG06BJ45
    ,fncex -- 财务费用:EG06BJ46
    ,ivs_loss -- 投资损失:EG06BJ47
    ,dfr_incmtax_ast_rdc -- 递延所得税资产减少:EG06BJ48
    ,dfr_incmtax_lby_add -- 递延所得税负债增加:EG06BJ49
    ,ivnts_rdc -- 存货的减少:EG06BJ50
    ,oprg_rcvb_prjs_rdc -- 经营性应收项目的减少:EG06BJ51
    ,oprg_pbl_prjs_add -- 经营性应付项目的增加:EG06BJ52
    ,othr_oprt_avy_cash_flow -- （净利润调节为经营活动现金流量科目下）其他:EG06BJ53
    ,oprt_avy_cf_netamt -- 经营活动产生的现金流量净额:EG06BJ54
    ,dbt_tfr_for_cptl -- 债务转为资本:EG06BJ55
    ,in1yr_exps_cnvrt_cobd -- 一年内到期的可转换公司债券:EG06BJ56
    ,fnc_rnt_fix_ast -- 融资租入固定资产:EG06BJ57
    ,cash_endofprdbal -- 现金的期末余额:EG06BJ58
    ,cash_bgnprdbal -- 现金的期初余额:EG06BJ59
    ,cash_eqvs_endofprdbal -- 现金等价物的期末余额:EG06BJ60
    ,cash_eqvs_bgnprdbal -- 现金等价物的期初余额:EG06BJ61
    ,csheqv_ntic_add_amt -- 现金及现金等价物净增加额:EG06BJ62
    ,othr_not_cash_ivs -- （不涉及现金收支的投资和筹资活动科目下）其他:EG06BJ63
    ,crt_dt_tm -- 创建日期时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,cr_supr_rcrd_id -- 征信上级记录编号(上级序号)
    ,rtpd_and_prd_lbrsvc_cash -- 销售商品和提供劳务收到的现金:EG06BJ01
    ,rcvd_taxfee_ret -- 收到的税费返还:EG06BJ02
    ,rdothr_wth_optavy_cash -- 收到其他与经营活动有关的现金:EG06BJ03
    ,oprt_avy_flwcsh_sbtl -- 经营活动现金流入小计:EG06BJ04
    ,prch_cdty_acptsvc_pycsh -- 购买商品、接受劳务支付的现金:EG06BJ05
    ,pygv_wkrs_forwkrs_pycsh -- 支付给职工以及为职工支付的现金:EG06BJ06
    ,py_et_taxfee -- 支付的各项税费:EG06BJ07
    ,py_othr_oprt_avy_cash -- 支付其他与经营活动有关的现金:EG06BJ08
    ,oprt_avy_cf_out_sbtl -- 经营活动现金流出小计:EG06BJ09
    ,oprt_avy_gen_cf_netamt -- 经营活动产生的现金流量净额:EG06BJ10
    ,wtd_ivsplc_rcvsch -- 收回投资所收到的现金:EG06BJ11
    ,obis_icpl_rcvsch -- 取得投资收益所收到的现金:EG06BJ12
    ,dpl_ast_plc_cash -- 处置固定资产无形资产和其他长期资产所收回的现金净额:EG06BJ13
    ,dpl_subs_oprgcl_cshntat -- 处置子公司及其他营业单位收到的现金净额:EG06BJ14
    ,rd_othr_ivs_avy_relcsh -- 收到其他与投资活动有关的现金:EG06BJ15
    ,ivs_avy_flowcash_sbtl -- 投资活动现金流入小计:EG06BJ16
    ,acfxat_ast_plc_pycsh -- 购建固定资产无形资产和其他长期资产所支付的现金:EG06BJ17
    ,ivs_plc_pycsh -- 投资所支付的现金:EG06BJ18
    ,obtn_subs_oprg_pyt_cshntat -- 取得子公司及其他营业单位支付的现金净额:EG06BJ19
    ,py_othr_ivs_avy_cash -- 支付其他与投资活动有关的现金:EG06BJ20
    ,ivs_avy_cf_out_sbtl -- 投资活动现金流出小计:EG06BJ21
    ,ivs_avy_gen_cf_netamt -- 投资活动产生的现金流量净额:EG06BJ22
    ,absrb_ivs_plc_cash -- 吸收投资收到的现金:EG06BJ23
    ,obtn_lnd_rcvds_cash -- 取得借款收到的现金:EG06BJ24
    ,rcvd_othr_fnc_avy_cash -- 收到其他与筹资活动有关的现金:EG06BJ25
    ,fnc_avy_flowcash_sbtl -- 筹资活动现金流入小计:EG06BJ26
    ,repy_dbt_plc_pys_cash -- 偿还债务所支付的现金:EG06BJ27
    ,alct_dvdn_pft_cmpn_plc_pycsh -- 分配股利、利润或偿付利息所支付的现金:EG06BJ28
    ,py_othr_fnc_avy_cash -- 支付其他与筹资活动有关的现金:EG06BJ29
    ,fnc_avy_cf_out_sbtl -- 筹资活动现金流出小计:EG06BJ30
    ,set_avy_gen_cf_netamt -- 筹集活动产生的现金流量净额:EG06BJ31
    ,erch_csh_and_csheqv_aff -- 汇率变动对现金及现金等价物的影响:EG06BJ32
    ,casheqv_add_amt -- 现金及现金等价物净增加额:EG06BJ33
    ,bop_casheqv_bal -- 期初现金及现金等价物余额:EG06BJ34
    ,eop_casheqv_bal -- 期末现金及现金等价物余额:EG06BJ35
    ,net_pft -- 净利润:EG06BJ36
    ,ast_dprcnrsrv -- 资产减值准备:EG06BJ37
    ,ast_dprcn -- 固定资产折旧、油气资产折耗、生产性生物资产折旧:EG06BJ38
    ,intgbl_ast_amrz -- 无形资产摊销:EG06BJ39
    ,longtrm_ppdex_amrz -- 长期待摊费用摊销:EG06BJ40
    ,ppdex_rdc -- 待摊费用减少:EG06BJ41
    ,pnex_add -- 预提费用增加:EG06BJ42
    ,displ_ast_loss -- 处置固定资产无形资产和其他长期资产的损失:EG06BJ43
    ,fix_ast_scrp_loss -- 固定资产报废损失:EG06BJ44
    ,fairval_chg_loss -- 公允价值变动损失:EG06BJ45
    ,fncex -- 财务费用:EG06BJ46
    ,ivs_loss -- 投资损失:EG06BJ47
    ,dfr_incmtax_ast_rdc -- 递延所得税资产减少:EG06BJ48
    ,dfr_incmtax_lby_add -- 递延所得税负债增加:EG06BJ49
    ,ivnts_rdc -- 存货的减少:EG06BJ50
    ,oprg_rcvb_prjs_rdc -- 经营性应收项目的减少:EG06BJ51
    ,oprg_pbl_prjs_add -- 经营性应付项目的增加:EG06BJ52
    ,othr_oprt_avy_cash_flow -- （净利润调节为经营活动现金流量科目下）其他:EG06BJ53
    ,oprt_avy_cf_netamt -- 经营活动产生的现金流量净额:EG06BJ54
    ,dbt_tfr_for_cptl -- 债务转为资本:EG06BJ55
    ,in1yr_exps_cnvrt_cobd -- 一年内到期的可转换公司债券:EG06BJ56
    ,fnc_rnt_fix_ast -- 融资租入固定资产:EG06BJ57
    ,cash_endofprdbal -- 现金的期末余额:EG06BJ58
    ,cash_bgnprdbal -- 现金的期初余额:EG06BJ59
    ,cash_eqvs_endofprdbal -- 现金等价物的期末余额:EG06BJ60
    ,cash_eqvs_bgnprdbal -- 现金等价物的期初余额:EG06BJ61
    ,csheqv_ntic_add_amt -- 现金及现金等价物净增加额:EG06BJ62
    ,othr_not_cash_ivs -- （不涉及现金收支的投资和筹资活动科目下）其他:EG06BJ63
    ,crt_dt_tm -- 创建日期时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_e_r_cashinfoinf2007
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_e_r_cashinfoinf2007 exchange partition p_${batch_date} with table ${iol_schema}.cqss_e_r_cashinfoinf2007_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_e_r_cashinfoinf2007 to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_e_r_cashinfoinf2007_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_e_r_cashinfoinf2007',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);