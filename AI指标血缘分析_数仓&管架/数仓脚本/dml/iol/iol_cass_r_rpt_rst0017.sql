/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cass_r_rpt_rst0017
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
drop table ${iol_schema}.cass_r_rpt_rst0017_ex purge;
alter table ${iol_schema}.cass_r_rpt_rst0017 add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cass_r_rpt_rst0017 truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cass_r_rpt_rst0017_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cass_r_rpt_rst0017 where 0=1;

insert /*+ append */ into ${iol_schema}.cass_r_rpt_rst0017_ex(
    etl_dt_ora -- 数据日期
    ,acct_no -- 账号
    ,dubil_no -- 借据号
    ,cust_no -- 客户号
    ,accts_org_no -- 记账机构号
    ,manager_org -- 考核机构号
    ,cust_type -- 客户类型
    ,corp_size_cd -- 企业规模代码
    ,bus_type -- 业务类型
    ,std_prod_no -- 产品编号
    ,curr_cd -- 币种
    ,bal_avg_y -- 余额年日均
    ,int_income_y -- 利息收入年累计
    ,int_expns_y -- 利息支出年累计
    ,int_adj_bal_y -- 利息调整年累计
    ,invest_prft_y -- 投资收益年累计
    ,evha_val_chag_y -- 公允价值变动损益年累计
    ,fee_y -- 手续费收支年累计
    ,expense_y -- 营业费用年累计
    ,asset_impair_loss_y -- 减值损失年累计
    ,rwaamount_avg_y -- RWA（风险加权资产）金额年日均
    ,ca_risk_y -- 资本占用年累计
    ,coc_y -- 资本成本年累计
    ,surttax_y -- 税金及附加年累计
    ,ftp_net_profit_y -- FTP净利润年累计
    ,income_tax_fee_y -- 所得税费用年累计
    ,eva_y -- EVA(经济利润)年累计
    ,raroc -- RAROC（风险调整后的资本收益率）
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    etl_dt_ora -- 数据日期
    ,acct_no -- 账号
    ,dubil_no -- 借据号
    ,cust_no -- 客户号
    ,accts_org_no -- 记账机构号
    ,manager_org -- 考核机构号
    ,cust_type -- 客户类型
    ,corp_size_cd -- 企业规模代码
    ,bus_type -- 业务类型
    ,std_prod_no -- 产品编号
    ,curr_cd -- 币种
    ,bal_avg_y -- 余额年日均
    ,int_income_y -- 利息收入年累计
    ,int_expns_y -- 利息支出年累计
    ,int_adj_bal_y -- 利息调整年累计
    ,invest_prft_y -- 投资收益年累计
    ,evha_val_chag_y -- 公允价值变动损益年累计
    ,fee_y -- 手续费收支年累计
    ,expense_y -- 营业费用年累计
    ,asset_impair_loss_y -- 减值损失年累计
    ,rwaamount_avg_y -- RWA（风险加权资产）金额年日均
    ,ca_risk_y -- 资本占用年累计
    ,coc_y -- 资本成本年累计
    ,surttax_y -- 税金及附加年累计
    ,ftp_net_profit_y -- FTP净利润年累计
    ,income_tax_fee_y -- 所得税费用年累计
    ,eva_y -- EVA(经济利润)年累计
    ,raroc -- RAROC（风险调整后的资本收益率）
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cass_r_rpt_rst0017
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cass_r_rpt_rst0017 exchange partition p_${batch_date} with table ${iol_schema}.cass_r_rpt_rst0017_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cass_r_rpt_rst0017 to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cass_r_rpt_rst0017_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cass_r_rpt_rst0017',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);