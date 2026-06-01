/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_ft_product_history
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
drop table ${iol_schema}.nfss_ft_product_history_ex purge;
alter table ${iol_schema}.nfss_ft_product_history add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.nfss_ft_product_history;

-- 2.3 insert data to ex table
create table ${iol_schema}.nfss_ft_product_history_ex nologging
compress
as
select * from ${iol_schema}.nfss_ft_product_history where 0=1;

insert /*+ append */ into ${iol_schema}.nfss_ft_product_history_ex(
    id -- 主键序号
    ,product_id -- 主键序号
    ,product_name -- 产品名称
    ,product_code -- 产品代码
    ,risk_grade -- 风险等级 R1:R1低风险  R2:R2中低风险 R3:R3中风险 R4:R4中高风险 R5:R5高风险
    ,performance_status -- 业绩比较基准
    ,establishment_date -- 成立日
    ,termination_date -- 终止日
    ,product_status -- 产品状态 0募集，1成立，2终止
    ,purchase_amount -- 起购金额
    ,commencement_date -- 募集开始日
    ,closing_date -- 募集结束日
    ,init_amount -- 初始创立金额
    ,current_net_worth -- 当前净值
    ,current_market_value -- 当前市值
    ,trustcompany_code -- 信托公司代码
    ,trustcompany_name -- 信托公司名称
    ,product_sorted -- 排序字段
    ,product_comment -- 备注（修改原因）
    ,created_time -- 创建时间
    ,submit_time -- 提交认证时间
    ,audit_time -- 审核时间
    ,audit_status -- 审核状态
    ,remark -- 审核失败原因
    ,audit_by -- 审核人
    ,history_created_time -- 归档时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 主键序号
    ,product_id -- 主键序号
    ,product_name -- 产品名称
    ,product_code -- 产品代码
    ,risk_grade -- 风险等级 R1:R1低风险  R2:R2中低风险 R3:R3中风险 R4:R4中高风险 R5:R5高风险
    ,performance_status -- 业绩比较基准
    ,establishment_date -- 成立日
    ,termination_date -- 终止日
    ,product_status -- 产品状态 0募集，1成立，2终止
    ,purchase_amount -- 起购金额
    ,commencement_date -- 募集开始日
    ,closing_date -- 募集结束日
    ,init_amount -- 初始创立金额
    ,current_net_worth -- 当前净值
    ,current_market_value -- 当前市值
    ,trustcompany_code -- 信托公司代码
    ,trustcompany_name -- 信托公司名称
    ,product_sorted -- 排序字段
    ,product_comment -- 备注（修改原因）
    ,created_time -- 创建时间
    ,submit_time -- 提交认证时间
    ,audit_time -- 审核时间
    ,audit_status -- 审核状态
    ,remark -- 审核失败原因
    ,audit_by -- 审核人
    ,history_created_time -- 归档时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.nfss_ft_product_history
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.nfss_ft_product_history exchange partition p_${batch_date} with table ${iol_schema}.nfss_ft_product_history_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_ft_product_history to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.nfss_ft_product_history_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_ft_product_history',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);