/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_ul_acct_int_detail
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
drop table ${iol_schema}.ncbs_ul_acct_int_detail_ex purge;
alter table ${iol_schema}.ncbs_ul_acct_int_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_ul_acct_int_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_ul_acct_int_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_ul_acct_int_detail where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_ul_acct_int_detail_ex(
    cmisloan_no -- 客户借据编号|客户借据编号
    ,int_class -- 利息分类|利息分类|int-正常利息,odi-复利,odp-罚息,ododi-复利的复利,ododp-罚息的复利,pdue-超期利息,godp-宽限期利息,wyint-违约利息
    ,batch_no -- 批次号|批次号
    ,client_no -- 客户编号|客户编号
    ,int_basis -- 基准利率类型|基准利率类型
    ,int_basis_rate -- 基准利率|基准利率
    ,spread_rate -- 浮动点数|浮动点数
    ,next_cycle_date -- 下一结息日|下一结息日
    ,cycle_freq -- 结息频率|结息频率
    ,int_day -- 存贷结息日期|存贷结息日期
    ,last_cycle_date -- 上一结息日|上一结息日
    ,int_type -- 利率类型|利率类型
    ,real_rate -- 执行利率|执行利率
    ,int_accrued_ctd -- 计提日计提利息|计提日计提利息
    ,int_accrued -- 累计计提|累计计提
    ,int_posted_ctd -- 结息日利息金额|结息日利息金额
    ,int_posted -- 结息金额|结息金额
    ,last_accrual_date -- 上一利息计提日|上一利息计提日
    ,int_appl_type -- 利率启用方式|利率启用方式|a-随基准利率变更,n-不变更,r-按周期变更,s-按计息变更,f-浮动不随基准利率变更
    ,rate_effect_type -- 利率生效方式|利率生效方式|a-按产品,n-按分户,h-就高（贷款使用时）,l-就低（贷款使用时）,n-不比较（贷款使用时）
    ,calc_begin_date -- 利息计算起始日|利息计算起始日
    ,calc_end_date -- 利息计算截止日|利息计算截止日
    ,last_change_date -- 最后修改日期|最后修改日期
    ,year_basis -- 年基准天数|年基准天数|360-按360天计算日利率,365-按365天计算日利率,366-按366天计算日利率
    ,month_basis -- 月基准|月基准|act-按实际天数,d30-按30天
    ,int_ind_flag -- 计息标识|是否计息|y-是、正利率计息,n-否,f-是、负利率计息
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    cmisloan_no -- 客户借据编号|客户借据编号
    ,int_class -- 利息分类|利息分类|int-正常利息,odi-复利,odp-罚息,ododi-复利的复利,ododp-罚息的复利,pdue-超期利息,godp-宽限期利息,wyint-违约利息
    ,batch_no -- 批次号|批次号
    ,client_no -- 客户编号|客户编号
    ,int_basis -- 基准利率类型|基准利率类型
    ,int_basis_rate -- 基准利率|基准利率
    ,spread_rate -- 浮动点数|浮动点数
    ,next_cycle_date -- 下一结息日|下一结息日
    ,cycle_freq -- 结息频率|结息频率
    ,int_day -- 存贷结息日期|存贷结息日期
    ,last_cycle_date -- 上一结息日|上一结息日
    ,int_type -- 利率类型|利率类型
    ,real_rate -- 执行利率|执行利率
    ,int_accrued_ctd -- 计提日计提利息|计提日计提利息
    ,int_accrued -- 累计计提|累计计提
    ,int_posted_ctd -- 结息日利息金额|结息日利息金额
    ,int_posted -- 结息金额|结息金额
    ,last_accrual_date -- 上一利息计提日|上一利息计提日
    ,int_appl_type -- 利率启用方式|利率启用方式|a-随基准利率变更,n-不变更,r-按周期变更,s-按计息变更,f-浮动不随基准利率变更
    ,rate_effect_type -- 利率生效方式|利率生效方式|a-按产品,n-按分户,h-就高（贷款使用时）,l-就低（贷款使用时）,n-不比较（贷款使用时）
    ,calc_begin_date -- 利息计算起始日|利息计算起始日
    ,calc_end_date -- 利息计算截止日|利息计算截止日
    ,last_change_date -- 最后修改日期|最后修改日期
    ,year_basis -- 年基准天数|年基准天数|360-按360天计算日利率,365-按365天计算日利率,366-按366天计算日利率
    ,month_basis -- 月基准|月基准|act-按实际天数,d30-按30天
    ,int_ind_flag -- 计息标识|是否计息|y-是、正利率计息,n-否,f-是、负利率计息
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_ul_acct_int_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_ul_acct_int_detail exchange partition p_${batch_date} with table ${iol_schema}.ncbs_ul_acct_int_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_ul_acct_int_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_ul_acct_int_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_ul_acct_int_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);