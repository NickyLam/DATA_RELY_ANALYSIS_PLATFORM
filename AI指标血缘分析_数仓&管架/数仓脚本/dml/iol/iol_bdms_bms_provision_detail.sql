/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_provision_detail
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
drop table ${iol_schema}.bdms_bms_provision_detail_ex purge;
alter table ${iol_schema}.bdms_bms_provision_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.bdms_bms_provision_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.bdms_bms_provision_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_provision_detail where 0=1;

insert /*+ append */ into ${iol_schema}.bdms_bms_provision_detail_ex(
    prov_de_id -- 计提明细表ID
    ,prov_id -- 计提主表ID
    ,prov_acct_id -- 计提记账表ID
    ,draft_id -- 票据ID
    ,draft_number -- 票据号
    ,draft_type -- 票据种类
    ,tprov_interest -- 当日计提利息
    ,is_success -- 是否记账成功： 0 否 1 是
    ,acct_dt -- 记账日
    ,back_flow_no -- 核心流水号
    ,fore_flow_no -- 前台流水号
    ,brch_no -- 交易机构编号
    ,product_no -- 业务产品号
    ,it_in_subject_no -- 利息收入科目
    ,it_back_subject_no -- 计提后科目
    ,it_sale_subject_no -- 卖断后科目
    ,create_time -- 创建时间
    ,reserve1 -- 保留字段1
    ,reserve2 -- 保留字段2
    ,reserve3 -- 保留字段3
    ,jiti_type -- 计提配置类型： 1 贴现 2 转贴现 3 买入质押式回购 4 买入买断式回购 5 卖出质押式回购 6 卖出买断式回购 7 再贴现回购
    ,cd_range -- 子票区间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    prov_de_id -- 计提明细表ID
    ,prov_id -- 计提主表ID
    ,prov_acct_id -- 计提记账表ID
    ,draft_id -- 票据ID
    ,draft_number -- 票据号
    ,draft_type -- 票据种类
    ,tprov_interest -- 当日计提利息
    ,is_success -- 是否记账成功： 0 否 1 是
    ,acct_dt -- 记账日
    ,back_flow_no -- 核心流水号
    ,fore_flow_no -- 前台流水号
    ,brch_no -- 交易机构编号
    ,product_no -- 业务产品号
    ,it_in_subject_no -- 利息收入科目
    ,it_back_subject_no -- 计提后科目
    ,it_sale_subject_no -- 卖断后科目
    ,create_time -- 创建时间
    ,reserve1 -- 保留字段1
    ,reserve2 -- 保留字段2
    ,reserve3 -- 保留字段3
    ,jiti_type -- 计提配置类型： 1 贴现 2 转贴现 3 买入质押式回购 4 买入买断式回购 5 卖出质押式回购 6 卖出买断式回购 7 再贴现回购
    ,cd_range -- 子票区间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.bdms_bms_provision_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.bdms_bms_provision_detail exchange partition p_${batch_date} with table ${iol_schema}.bdms_bms_provision_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_provision_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.bdms_bms_provision_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_provision_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);