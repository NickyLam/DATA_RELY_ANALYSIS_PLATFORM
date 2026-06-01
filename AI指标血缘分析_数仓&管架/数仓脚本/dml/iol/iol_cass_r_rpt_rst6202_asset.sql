/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cass_r_rpt_rst6202_asset
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
drop table ${iol_schema}.cass_r_rpt_rst6202_asset_ex purge;
alter table ${iol_schema}.cass_r_rpt_rst6202_asset add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cass_r_rpt_rst6202_asset truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cass_r_rpt_rst6202_asset_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cass_r_rpt_rst6202_asset where 0=1;

insert /*+ append */ into ${iol_schema}.cass_r_rpt_rst6202_asset_ex(
    etl_dt_ora -- 数据日期
    ,bus_no -- 业务编号
    ,manager_org -- 考核机构
    ,bus_line -- 业务条线
    ,subj_no -- 本金科目
    ,std_prod_no -- 标准产品编号
    ,curr_cd -- 币种(折币后目标币种）
    ,cust_no -- 客户编号
    ,cust_mgr_no -- 客户经理编号
    ,accts_org_no -- 账务机构
    ,share_bal -- 余额
    ,share_bal_avg_y -- 余额年日均
    ,share_ftp_net_income -- FTP营业净收入
    ,share_ftp_profit -- FTP利润
    ,share_int_income_expns_af_m -- 外部利息收入_税后
    ,share_int_adj_bal_m -- 利息调整月累计
    ,share_final_ftp_accout_m -- FTP利息支出
    ,share_invest_prft -- 投资收益
    ,share_evha_val_chag -- 公允价值变动损益
    ,expense -- 营业费用
    ,surttax -- 税金及附加
    ,pre_pro_profit -- 拨备前经济利润
    ,asset_impair_loss -- 减值损失
    ,credit_impair_loss -- 信用减值损失
    ,other_asset_impair_loss -- 其他资产减值损失
    ,pre_tax_profit -- 税前利润
    ,income_tax_fee -- 所得税费用
    ,ftp_net_profit -- FTP净利润
    ,coc -- 资本成本
    ,share_eva -- EVA(经济利润)
    ,share_raroc -- RAROC（风险调整后的资本收益率）
    ,int_adj_subj_no -- 利息调整科目
    ,int_income_subj_no -- 利息科目
    ,invest_subj_no -- 投资收益科目
    ,evha_val_chag_pl_subj_no -- 公允价值科目
    ,val_subj_no -- 增值税科目
    ,level5_class_cd -- 五级分类
    ,org_term_dim -- 期限代码
    ,cust_level -- 客户等级
    ,cust_type -- 客户类型
    ,cust_indus_type_cd -- 行业代码
    ,class_credit_ind -- 类信贷标志
    ,portf_no -- 投组
    ,sm_mini_loan_ind -- 小微贷款标志
    ,asset_type_name -- 资产类型名称
    ,area -- 所属区域
    ,cae_health_loan_ind -- 文教健康贷款标志
    ,farming_ind -- 涉农标志
    ,green_loan_ind -- 绿色贷款标志
    ,spe_unq_new_med_side_enter_flg -- 专精特新中小企业标志
    ,spe_unq_new_lte_gnt_corp_flg -- 专精特新小巨人企业标志
    ,indust_park_corp_flg -- 产业园企业标志
    ,share_total_line_expense -- 总行条线费用
    ,share_total_non_line_expense -- 总行非条线费用
    ,share_brch_line_expense -- 分行条线费用
    ,share_brch_non_line_expense -- 分行非条线费用
    ,share_sub_expense -- 支行（团队）直接费用
    ,share_rwaamount_avg_m -- RWA（风险加权资产）月平均金额
    ,share_rwaamount -- RWA（风险加权资产）金额
    ,cdd_flg -- 超短贷标志
    ,adj_income_sum_m -- 调整收益月累计
    ,adj_income_sum_q -- 调整收益季累计
    ,adj_income_sum_y -- 调整收益年累计
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    etl_dt_ora -- 数据日期
    ,bus_no -- 业务编号
    ,manager_org -- 考核机构
    ,bus_line -- 业务条线
    ,subj_no -- 本金科目
    ,std_prod_no -- 标准产品编号
    ,curr_cd -- 币种(折币后目标币种）
    ,cust_no -- 客户编号
    ,cust_mgr_no -- 客户经理编号
    ,accts_org_no -- 账务机构
    ,share_bal -- 余额
    ,share_bal_avg_y -- 余额年日均
    ,share_ftp_net_income -- FTP营业净收入
    ,share_ftp_profit -- FTP利润
    ,share_int_income_expns_af_m -- 外部利息收入_税后
    ,share_int_adj_bal_m -- 利息调整月累计
    ,share_final_ftp_accout_m -- FTP利息支出
    ,share_invest_prft -- 投资收益
    ,share_evha_val_chag -- 公允价值变动损益
    ,expense -- 营业费用
    ,surttax -- 税金及附加
    ,pre_pro_profit -- 拨备前经济利润
    ,asset_impair_loss -- 减值损失
    ,credit_impair_loss -- 信用减值损失
    ,other_asset_impair_loss -- 其他资产减值损失
    ,pre_tax_profit -- 税前利润
    ,income_tax_fee -- 所得税费用
    ,ftp_net_profit -- FTP净利润
    ,coc -- 资本成本
    ,share_eva -- EVA(经济利润)
    ,share_raroc -- RAROC（风险调整后的资本收益率）
    ,int_adj_subj_no -- 利息调整科目
    ,int_income_subj_no -- 利息科目
    ,invest_subj_no -- 投资收益科目
    ,evha_val_chag_pl_subj_no -- 公允价值科目
    ,val_subj_no -- 增值税科目
    ,level5_class_cd -- 五级分类
    ,org_term_dim -- 期限代码
    ,cust_level -- 客户等级
    ,cust_type -- 客户类型
    ,cust_indus_type_cd -- 行业代码
    ,class_credit_ind -- 类信贷标志
    ,portf_no -- 投组
    ,sm_mini_loan_ind -- 小微贷款标志
    ,asset_type_name -- 资产类型名称
    ,area -- 所属区域
    ,cae_health_loan_ind -- 文教健康贷款标志
    ,farming_ind -- 涉农标志
    ,green_loan_ind -- 绿色贷款标志
    ,spe_unq_new_med_side_enter_flg -- 专精特新中小企业标志
    ,spe_unq_new_lte_gnt_corp_flg -- 专精特新小巨人企业标志
    ,indust_park_corp_flg -- 产业园企业标志
    ,share_total_line_expense -- 总行条线费用
    ,share_total_non_line_expense -- 总行非条线费用
    ,share_brch_line_expense -- 分行条线费用
    ,share_brch_non_line_expense -- 分行非条线费用
    ,share_sub_expense -- 支行（团队）直接费用
    ,share_rwaamount_avg_m -- RWA（风险加权资产）月平均金额
    ,share_rwaamount -- RWA（风险加权资产）金额
    ,cdd_flg -- 超短贷标志
    ,adj_income_sum_m -- 调整收益月累计
    ,adj_income_sum_q -- 调整收益季累计
    ,adj_income_sum_y -- 调整收益年累计
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cass_r_rpt_rst6202_asset
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cass_r_rpt_rst6202_asset exchange partition p_${batch_date} with table ${iol_schema}.cass_r_rpt_rst6202_asset_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cass_r_rpt_rst6202_asset to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cass_r_rpt_rst6202_asset_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cass_r_rpt_rst6202_asset',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);