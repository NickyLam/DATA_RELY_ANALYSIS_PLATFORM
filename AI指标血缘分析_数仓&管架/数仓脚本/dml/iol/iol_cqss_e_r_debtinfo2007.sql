/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_e_r_debtinfo2007
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
drop table ${iol_schema}.cqss_e_r_debtinfo2007_ex purge;
alter table ${iol_schema}.cqss_e_r_debtinfo2007 add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_e_r_debtinfo2007 truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_e_r_debtinfo2007_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_e_r_debtinfo2007 where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_e_r_debtinfo2007_ex(
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,cr_supr_rcrd_id -- 征信上级记录编号(上级序号)
    ,ccy_fnds -- 货币资金:EG02BJ01
    ,tdfnast -- 交易性金融资产:EG02BJ02
    ,rcvb_bl -- 应收票据:EG02BJ03
    ,rcvb -- 应收账款:EG02BJ04
    ,prpy_accval -- 预付账款:EG02BJ05
    ,recint -- 应收利息:EG02BJ06
    ,rbdn -- 应收股利:EG02BJ07
    ,ohrv -- 其他应收款:EG02BJ08
    ,ivnt -- 存货:EG02BJ09
    ,in1yr_exps_non_lqud_ast -- 一年内到期的非流动资产:EG02BJ10
    ,othr_lqud_ast -- 其他流动资产:EG02BJ11
    ,lqud_ast_tot -- 流动资产合计:EG02BJ12
    ,csls_fast -- 可供出售的金融资产:EG02BJ13
    ,heldtmatinvm -- 持有至到期投资:EG02BJ14
    ,ltmeyis -- 长期股权投资:EG02BJ15
    ,longtrm_rcvb -- 长期应收款:EG02BJ16
    ,ivs_prp_rlest -- 投资性房地产:EG02BJ17
    ,fix_ast -- 固定资产:EG02BJ18
    ,ucpt -- 在建工程:EG02BJ19
    ,prj_dnc -- 工程物资:EG02BJ20
    ,fix_atcln -- 固定资产清理:EG02BJ21
    ,pd_prp_blgc_ast -- 生产性生物资产:EG02BJ22
    ,oil_ast -- 油气资产:EG02BJ23
    ,intgbl_ast -- 无形资产:EG02BJ24
    ,dvlp_expn -- 开发支出:EG02BJ25
    ,gdwl -- 商誉:EG02BJ26
    ,longtrm_ppdex -- 长期待摊费用:EG02BJ27
    ,dfr_incmtax_ast -- 递延所得税资产:EG02BJ28
    ,othr_non_lqud_ast -- 其他非流动资产:EG02BJ29
    ,non_lqud_ast_tot -- 非流动资产合计:EG02BJ30
    ,ast_tot -- 资产总计:EG02BJ31
    ,shrttm_lnd -- 短期借款:EG02BJ32
    ,fncastheldforlby -- 交易性金融负债:EG02BJ33
    ,pbl_bl -- 应付票据:EG02BJ34
    ,pbl_accval -- 应付账款:EG02BJ35
    ,riav_accval -- 预收账款:EG02BJ36
    ,plit -- 应付利息:EG02BJ37
    ,empewageexpn -- 应付职工薪酬:EG02BJ38
    ,ptxf -- 应交税费:EG02BJ39
    ,pbl_dvdn -- 应付股利:EG02BJ40
    ,othr_pl -- 其他应付款:EG02BJ41
    ,in1yr_exps_non_lqud_lby -- 一年内到期的非流动负债:EG02BJ42
    ,othr_lqud_lby -- 其他流动负债:EG02BJ43
    ,lqud_lby_tot -- 流动负债合计:EG02BJ44
    ,longtrm_lnd -- 长期借款:EG02BJ45
    ,pbl_bond -- 应付债券:EG02BJ46
    ,longtrm_pybl -- 长期应付款:EG02BJ47
    ,spcl_pybl -- 专项应付款:EG02BJ48
    ,frcst_lby -- 预计负债:EG02BJ49
    ,dfr_incmtax_lby -- 递延所得税负债:EG02BJ50
    ,othr_non_lqud_lby -- 其他非流动负债:EG02BJ51
    ,non_lqud_lby_tot -- 非流动负债合计:EG02BJ52
    ,lby_tot -- 负债合计:EG02BJ53
    ,arcptl -- 实收资本（或股本）:EG02BJ54
    ,cptrsv -- 资本公积:EG02BJ55
    ,sub_trrstk -- 减：库存股:EG02BJ56
    ,splrsv -- 盈余公积:EG02BJ57
    ,uspt -- 未分配利润:EG02BJ58
    ,owr_rght_tot -- 所有者权益合计:EG02BJ59
    ,lby_and_owr_rght_tot -- 负债和所有者权益合计:EG02BJ60
    ,crt_dt_tm -- 创建日期时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,cr_supr_rcrd_id -- 征信上级记录编号(上级序号)
    ,ccy_fnds -- 货币资金:EG02BJ01
    ,tdfnast -- 交易性金融资产:EG02BJ02
    ,rcvb_bl -- 应收票据:EG02BJ03
    ,rcvb -- 应收账款:EG02BJ04
    ,prpy_accval -- 预付账款:EG02BJ05
    ,recint -- 应收利息:EG02BJ06
    ,rbdn -- 应收股利:EG02BJ07
    ,ohrv -- 其他应收款:EG02BJ08
    ,ivnt -- 存货:EG02BJ09
    ,in1yr_exps_non_lqud_ast -- 一年内到期的非流动资产:EG02BJ10
    ,othr_lqud_ast -- 其他流动资产:EG02BJ11
    ,lqud_ast_tot -- 流动资产合计:EG02BJ12
    ,csls_fast -- 可供出售的金融资产:EG02BJ13
    ,heldtmatinvm -- 持有至到期投资:EG02BJ14
    ,ltmeyis -- 长期股权投资:EG02BJ15
    ,longtrm_rcvb -- 长期应收款:EG02BJ16
    ,ivs_prp_rlest -- 投资性房地产:EG02BJ17
    ,fix_ast -- 固定资产:EG02BJ18
    ,ucpt -- 在建工程:EG02BJ19
    ,prj_dnc -- 工程物资:EG02BJ20
    ,fix_atcln -- 固定资产清理:EG02BJ21
    ,pd_prp_blgc_ast -- 生产性生物资产:EG02BJ22
    ,oil_ast -- 油气资产:EG02BJ23
    ,intgbl_ast -- 无形资产:EG02BJ24
    ,dvlp_expn -- 开发支出:EG02BJ25
    ,gdwl -- 商誉:EG02BJ26
    ,longtrm_ppdex -- 长期待摊费用:EG02BJ27
    ,dfr_incmtax_ast -- 递延所得税资产:EG02BJ28
    ,othr_non_lqud_ast -- 其他非流动资产:EG02BJ29
    ,non_lqud_ast_tot -- 非流动资产合计:EG02BJ30
    ,ast_tot -- 资产总计:EG02BJ31
    ,shrttm_lnd -- 短期借款:EG02BJ32
    ,fncastheldforlby -- 交易性金融负债:EG02BJ33
    ,pbl_bl -- 应付票据:EG02BJ34
    ,pbl_accval -- 应付账款:EG02BJ35
    ,riav_accval -- 预收账款:EG02BJ36
    ,plit -- 应付利息:EG02BJ37
    ,empewageexpn -- 应付职工薪酬:EG02BJ38
    ,ptxf -- 应交税费:EG02BJ39
    ,pbl_dvdn -- 应付股利:EG02BJ40
    ,othr_pl -- 其他应付款:EG02BJ41
    ,in1yr_exps_non_lqud_lby -- 一年内到期的非流动负债:EG02BJ42
    ,othr_lqud_lby -- 其他流动负债:EG02BJ43
    ,lqud_lby_tot -- 流动负债合计:EG02BJ44
    ,longtrm_lnd -- 长期借款:EG02BJ45
    ,pbl_bond -- 应付债券:EG02BJ46
    ,longtrm_pybl -- 长期应付款:EG02BJ47
    ,spcl_pybl -- 专项应付款:EG02BJ48
    ,frcst_lby -- 预计负债:EG02BJ49
    ,dfr_incmtax_lby -- 递延所得税负债:EG02BJ50
    ,othr_non_lqud_lby -- 其他非流动负债:EG02BJ51
    ,non_lqud_lby_tot -- 非流动负债合计:EG02BJ52
    ,lby_tot -- 负债合计:EG02BJ53
    ,arcptl -- 实收资本（或股本）:EG02BJ54
    ,cptrsv -- 资本公积:EG02BJ55
    ,sub_trrstk -- 减：库存股:EG02BJ56
    ,splrsv -- 盈余公积:EG02BJ57
    ,uspt -- 未分配利润:EG02BJ58
    ,owr_rght_tot -- 所有者权益合计:EG02BJ59
    ,lby_and_owr_rght_tot -- 负债和所有者权益合计:EG02BJ60
    ,crt_dt_tm -- 创建日期时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_e_r_debtinfo2007
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_e_r_debtinfo2007 exchange partition p_${batch_date} with table ${iol_schema}.cqss_e_r_debtinfo2007_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_e_r_debtinfo2007 to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_e_r_debtinfo2007_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_e_r_debtinfo2007',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);