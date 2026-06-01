/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cass_p_fsi_kpi
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
drop table ${iol_schema}.cass_p_fsi_kpi_ex purge;
alter table ${iol_schema}.cass_p_fsi_kpi add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cass_p_fsi_kpi truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cass_p_fsi_kpi_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cass_p_fsi_kpi where 0=1;

insert /*+ append */ into ${iol_schema}.cass_p_fsi_kpi_ex(
    etl_dt_ora -- 数据日期
    ,kpi_code -- 指标编号
    ,accts_org_no -- 账务机构
    ,manager_org -- 考核机构
    ,bus_line -- 业务条线
    ,com_line -- 常规条线
    ,subj_no -- 科目编号
    ,std_prod_no -- 标准产品编号
    ,org_term_dim -- 期限
    ,level5_class_cd -- 五级分类
    ,curr_cd -- 币种
    ,cust_level -- 客户等级
    ,adjust_type -- 调整类型
    ,kpi_value -- 指标值
    ,kpi_value_m -- 指标值(月)
    ,kpi_value_q -- 指标值(季)
    ,kpi_value_y -- 指标值(年)
    ,dir_indus_cd -- 投向行业代码
    ,cust_indus_type_cd -- 行业代码
    ,cost_type -- 成本类型
    ,cust_group -- 客群
    ,area -- 所属区域
    ,cust_mgr_no -- 客户经理编号
    ,ger_name -- 客户经理名称
    ,type_004 -- 分子/分母标识
    ,curr_cd_ori -- 源币种(折币前原始币种）
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    etl_dt_ora -- 数据日期
    ,kpi_code -- 指标编号
    ,accts_org_no -- 账务机构
    ,manager_org -- 考核机构
    ,bus_line -- 业务条线
    ,com_line -- 常规条线
    ,subj_no -- 科目编号
    ,std_prod_no -- 标准产品编号
    ,org_term_dim -- 期限
    ,level5_class_cd -- 五级分类
    ,curr_cd -- 币种
    ,cust_level -- 客户等级
    ,adjust_type -- 调整类型
    ,kpi_value -- 指标值
    ,kpi_value_m -- 指标值(月)
    ,kpi_value_q -- 指标值(季)
    ,kpi_value_y -- 指标值(年)
    ,dir_indus_cd -- 投向行业代码
    ,cust_indus_type_cd -- 行业代码
    ,cost_type -- 成本类型
    ,cust_group -- 客群
    ,area -- 所属区域
    ,cust_mgr_no -- 客户经理编号
    ,ger_name -- 客户经理名称
    ,type_004 -- 分子/分母标识
    ,curr_cd_ori -- 源币种(折币前原始币种）
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cass_p_fsi_kpi
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cass_p_fsi_kpi exchange partition p_${batch_date} with table ${iol_schema}.cass_p_fsi_kpi_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cass_p_fsi_kpi to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cass_p_fsi_kpi_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cass_p_fsi_kpi',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);