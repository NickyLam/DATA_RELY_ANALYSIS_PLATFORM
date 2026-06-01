/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_e_r_debtinfo2002
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
drop table ${iol_schema}.cqss_e_r_debtinfo2002_ex purge;
alter table ${iol_schema}.cqss_e_r_debtinfo2002 add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_e_r_debtinfo2002 truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_e_r_debtinfo2002_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_e_r_debtinfo2002 where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_e_r_debtinfo2002_ex(
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,ccy_fnds -- 货币资金:EG01BJ01
    ,shrttm_ivs -- 短期投资:EG01BJ02
    ,rcvb_bl -- 应收票据:EG01BJ03
    ,rbdn -- 应收股利:EG01BJ04
    ,recint -- 应收利息:EG01BJ05
    ,rcvb -- 应收账款:EG01BJ06
    ,ohrv -- 其他应收款:EG01BJ07
    ,prpy_accval -- 预付账款:EG01BJ08
    ,ftrs_mrgn -- 期货保证金:EG01BJ09
    ,rcvb_alwc_amt -- 应收补贴款:EG01BJ10
    ,rcvb_eptrb -- 应收出口退税:EG01BJ11
    ,ivnt -- 存货:EG01BJ12
    ,ivnt_ori_mtrl -- 存货原材料:EG01BJ13
    ,ivnt_mdupartcl -- 存货产成品:EG01BJ14
    ,ppdex -- 待摊费用:EG01BJ15
    ,pndg_lqud_ast_net_loss -- 待处理流动资产净损失:EG01BJ16
    ,in1yr_exps_longtrm_clm_ivs -- 一年内到期的长期债权投资:EG01BJ17
    ,othr_lqud_ast -- 其他流动资产:EG01BJ18
    ,lqud_ast_tot -- 流动资产合计:EG01BJ19
    ,ltemivs -- 长期投资:EG01BJ20
    ,ltmeyis -- 长期股权投资:EG01BJ21
    ,longtrm_clm_ivs -- 长期债权投资:EG01BJ22
    ,mrg_prmg -- 合并价差:EG01BJ23
    ,ltemivs_tot -- 长期投资合计:EG01BJ24
    ,fix_ast_ori_prc -- 固定资产原价:EG01BJ25
    ,acm_dprcn -- 累计折旧:EG01BJ26
    ,fix_ast_netval -- 固定资产净值:EG01BJ27
    ,fix_ast_val_dprcnrsrv -- 固定资产值减值准备:EG01BJ28
    ,fix_ast_netamt -- 固定资产净额:EG01BJ29
    ,fix_atcln -- 固定资产清理:EG01BJ30
    ,prj_dnc -- 工程物资:EG01BJ31
    ,ucpt -- 在建工程:EG01BJ32
    ,pndg_fix_ast_net_loss -- 待处理固定资产净损失:EG01BJ33
    ,fix_ast_tot -- 固定资产合计:EG01BJ34
    ,intgbl_ast -- 无形资产:EG01BJ35
    ,land_use_wght -- （无形资产科目下）土地使用权:EG01BJ36
    ,dfr_ast -- 递延资产:EG01BJ37
    ,fix_ast_fix -- （递延资产科目下）固定资产修理:EG01BJ38
    ,fix_ast_chg_expn -- （递延资产科目下）固定资产改良支出:EG01BJ39
    ,othr_longtrm_ast -- 其他长期资产:EG01BJ40
    ,spcl_qsi_rsrv_dnc -- （其他长期资产科目下）特准储备物资:EG01BJ41
    ,intgbl_and_othrast_tot -- 无形及其他资产合计:EG01BJ42
    ,dfr_taxpymt_brw_itm -- 递延税款借项:EG01BJ43
    ,ast_tot -- 资产总计:EG01BJ44
    ,shrttm_lnd -- 短期借款:EG01BJ45
    ,pbl_bl -- 应付票据:EG01BJ46
    ,pbl_accval -- 应付账款:EG01BJ47
    ,riav_accval -- 预收账款:EG01BJ48
    ,pbl_wage -- 应付工资:EG01BJ49
    ,pbl_wlfr_fee -- 应付福利费:EG01BJ50
    ,pblpft -- 应付利润:EG01BJ51
    ,acrtax -- 应交税金:EG01BJ52
    ,othr_pymt_amt -- 其他应交款:EG01BJ53
    ,otpl -- 其他应付款:EG01BJ54
    ,pnex -- 预提费用:EG01BJ55
    ,frcst_lby -- 预计负债:EG01BJ56
    ,in1yr_exps_longtrm_lby -- 一年内到期的长期负债:EG01BJ57
    ,othr_lqud_lby -- 其他流动负债:EG01BJ58
    ,lqud_lby_tot -- 流动负债合计:EG01BJ59
    ,longtrm_lnd -- 长期借款:EG01BJ60
    ,pbl_bond -- 应付债券:EG01BJ61
    ,longtrm_pybl -- 长期应付款:EG01BJ62
    ,spcl_pybl -- 专项应付款:EG01BJ63
    ,othr_longtrm_lby -- 其他长期负债:EG01BJ64
    ,spcl_qsi_rsrv_fnd -- （其他长期负债科目下）特准储备基金:EG01BJ65
    ,longtrm_lby_tot -- 长期负债合计:EG01BJ66
    ,dfr_taxpymt_crnt -- 递延税款贷项:EG01BJ67
    ,lby_tot -- 负债合计:EG01BJ68
    ,less_num_shrh_rght -- 少数股东权益:EG01BJ69
    ,arcptl -- 实收资本:EG01BJ70
    ,cty_cptl -- 国家资本:EG01BJ71
    ,colltvt_cptl -- 集体资本:EG01BJ72
    ,lglpsn_cptl -- 法人资本:EG01BJ73
    ,nal_lglpsn_cptl -- （法人资本科目下）国有法人资本:EG01BJ74
    ,colltvt_lglpsn_cptl -- （法人资本科目下）集体法人资本:EG01BJ75
    ,idv_cptl -- 个人资本:EG01BJ76
    ,frgnmrch_cptl -- 外商资本:EG01BJ77
    ,cptrsv -- 资本公积:EG01BJ78
    ,splrsv -- 盈余公积:EG01BJ79
    ,lgl_pblc -- （盈余公积科目下）法定盈余公积:EG01BJ80
    ,pbwlf_gld -- （盈余公积科目下）公益金:EG01BJ81
    ,splmt_lqud_cptl -- （盈余公积科目下）补充流动资本:EG01BJ82
    ,not_cfms_ivs_loss -- 未确认的投资损失:EG01BJ83
    ,uspt -- 未分配利润:EG01BJ84
    ,frncy_rpt_cnvr_difamt -- 外币报表折算差额:EG01BJ85
    ,owr_rght_tot -- 所有者权益合计:EG01BJ86
    ,lby_and_owr_rght_tot -- 负债和所有者权益总计:EG01BJ87
    ,crt_dt_tm -- 创建日期时间
    ,cr_supr_rcrd_id -- 征信上级记录编号(上级序号)
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,ccy_fnds -- 货币资金:EG01BJ01
    ,shrttm_ivs -- 短期投资:EG01BJ02
    ,rcvb_bl -- 应收票据:EG01BJ03
    ,rbdn -- 应收股利:EG01BJ04
    ,recint -- 应收利息:EG01BJ05
    ,rcvb -- 应收账款:EG01BJ06
    ,ohrv -- 其他应收款:EG01BJ07
    ,prpy_accval -- 预付账款:EG01BJ08
    ,ftrs_mrgn -- 期货保证金:EG01BJ09
    ,rcvb_alwc_amt -- 应收补贴款:EG01BJ10
    ,rcvb_eptrb -- 应收出口退税:EG01BJ11
    ,ivnt -- 存货:EG01BJ12
    ,ivnt_ori_mtrl -- 存货原材料:EG01BJ13
    ,ivnt_mdupartcl -- 存货产成品:EG01BJ14
    ,ppdex -- 待摊费用:EG01BJ15
    ,pndg_lqud_ast_net_loss -- 待处理流动资产净损失:EG01BJ16
    ,in1yr_exps_longtrm_clm_ivs -- 一年内到期的长期债权投资:EG01BJ17
    ,othr_lqud_ast -- 其他流动资产:EG01BJ18
    ,lqud_ast_tot -- 流动资产合计:EG01BJ19
    ,ltemivs -- 长期投资:EG01BJ20
    ,ltmeyis -- 长期股权投资:EG01BJ21
    ,longtrm_clm_ivs -- 长期债权投资:EG01BJ22
    ,mrg_prmg -- 合并价差:EG01BJ23
    ,ltemivs_tot -- 长期投资合计:EG01BJ24
    ,fix_ast_ori_prc -- 固定资产原价:EG01BJ25
    ,acm_dprcn -- 累计折旧:EG01BJ26
    ,fix_ast_netval -- 固定资产净值:EG01BJ27
    ,fix_ast_val_dprcnrsrv -- 固定资产值减值准备:EG01BJ28
    ,fix_ast_netamt -- 固定资产净额:EG01BJ29
    ,fix_atcln -- 固定资产清理:EG01BJ30
    ,prj_dnc -- 工程物资:EG01BJ31
    ,ucpt -- 在建工程:EG01BJ32
    ,pndg_fix_ast_net_loss -- 待处理固定资产净损失:EG01BJ33
    ,fix_ast_tot -- 固定资产合计:EG01BJ34
    ,intgbl_ast -- 无形资产:EG01BJ35
    ,land_use_wght -- （无形资产科目下）土地使用权:EG01BJ36
    ,dfr_ast -- 递延资产:EG01BJ37
    ,fix_ast_fix -- （递延资产科目下）固定资产修理:EG01BJ38
    ,fix_ast_chg_expn -- （递延资产科目下）固定资产改良支出:EG01BJ39
    ,othr_longtrm_ast -- 其他长期资产:EG01BJ40
    ,spcl_qsi_rsrv_dnc -- （其他长期资产科目下）特准储备物资:EG01BJ41
    ,intgbl_and_othrast_tot -- 无形及其他资产合计:EG01BJ42
    ,dfr_taxpymt_brw_itm -- 递延税款借项:EG01BJ43
    ,ast_tot -- 资产总计:EG01BJ44
    ,shrttm_lnd -- 短期借款:EG01BJ45
    ,pbl_bl -- 应付票据:EG01BJ46
    ,pbl_accval -- 应付账款:EG01BJ47
    ,riav_accval -- 预收账款:EG01BJ48
    ,pbl_wage -- 应付工资:EG01BJ49
    ,pbl_wlfr_fee -- 应付福利费:EG01BJ50
    ,pblpft -- 应付利润:EG01BJ51
    ,acrtax -- 应交税金:EG01BJ52
    ,othr_pymt_amt -- 其他应交款:EG01BJ53
    ,otpl -- 其他应付款:EG01BJ54
    ,pnex -- 预提费用:EG01BJ55
    ,frcst_lby -- 预计负债:EG01BJ56
    ,in1yr_exps_longtrm_lby -- 一年内到期的长期负债:EG01BJ57
    ,othr_lqud_lby -- 其他流动负债:EG01BJ58
    ,lqud_lby_tot -- 流动负债合计:EG01BJ59
    ,longtrm_lnd -- 长期借款:EG01BJ60
    ,pbl_bond -- 应付债券:EG01BJ61
    ,longtrm_pybl -- 长期应付款:EG01BJ62
    ,spcl_pybl -- 专项应付款:EG01BJ63
    ,othr_longtrm_lby -- 其他长期负债:EG01BJ64
    ,spcl_qsi_rsrv_fnd -- （其他长期负债科目下）特准储备基金:EG01BJ65
    ,longtrm_lby_tot -- 长期负债合计:EG01BJ66
    ,dfr_taxpymt_crnt -- 递延税款贷项:EG01BJ67
    ,lby_tot -- 负债合计:EG01BJ68
    ,less_num_shrh_rght -- 少数股东权益:EG01BJ69
    ,arcptl -- 实收资本:EG01BJ70
    ,cty_cptl -- 国家资本:EG01BJ71
    ,colltvt_cptl -- 集体资本:EG01BJ72
    ,lglpsn_cptl -- 法人资本:EG01BJ73
    ,nal_lglpsn_cptl -- （法人资本科目下）国有法人资本:EG01BJ74
    ,colltvt_lglpsn_cptl -- （法人资本科目下）集体法人资本:EG01BJ75
    ,idv_cptl -- 个人资本:EG01BJ76
    ,frgnmrch_cptl -- 外商资本:EG01BJ77
    ,cptrsv -- 资本公积:EG01BJ78
    ,splrsv -- 盈余公积:EG01BJ79
    ,lgl_pblc -- （盈余公积科目下）法定盈余公积:EG01BJ80
    ,pbwlf_gld -- （盈余公积科目下）公益金:EG01BJ81
    ,splmt_lqud_cptl -- （盈余公积科目下）补充流动资本:EG01BJ82
    ,not_cfms_ivs_loss -- 未确认的投资损失:EG01BJ83
    ,uspt -- 未分配利润:EG01BJ84
    ,frncy_rpt_cnvr_difamt -- 外币报表折算差额:EG01BJ85
    ,owr_rght_tot -- 所有者权益合计:EG01BJ86
    ,lby_and_owr_rght_tot -- 负债和所有者权益总计:EG01BJ87
    ,crt_dt_tm -- 创建日期时间
    ,cr_supr_rcrd_id -- 征信上级记录编号(上级序号)
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_e_r_debtinfo2002
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_e_r_debtinfo2002 exchange partition p_${batch_date} with table ${iol_schema}.cqss_e_r_debtinfo2002_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_e_r_debtinfo2002 to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_e_r_debtinfo2002_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_e_r_debtinfo2002',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);