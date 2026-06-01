/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_lhd_trans_flow_info
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
drop table ${iol_schema}.icms_lhd_trans_flow_info_ex purge;
alter table ${iol_schema}.icms_lhd_trans_flow_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_lhd_trans_flow_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_lhd_trans_flow_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lhd_trans_flow_info where 0=1;

insert /*+ append */ into ${iol_schema}.icms_lhd_trans_flow_info_ex(
    serialno -- 流水号
    ,duebillno -- 信贷借据号
    ,accountdate -- 账务日期
    ,transno -- 交易流水号
    ,transtype -- 交易类型
    ,transamt -- 交易金额
    ,noaccstatus -- 非应计状态
    ,prioccamt -- 本金发生额
    ,intoccamt -- 利息发生额
    ,defintoccamt -- 罚息发生额
    ,czflag -- 冲正标识
    ,channel -- 渠道
    ,transdate -- 交易时间戳
    ,transorgid -- 交易机构
    ,migttype -- 交易标志
    ,inputuserid -- 登记人
    ,inputorgid -- 登记机构
    ,inputdate -- 登记日期
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,compintoccamt -- 复利发生额
    ,hxduebillno -- 核心借据号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    serialno -- 流水号
    ,duebillno -- 信贷借据号
    ,accountdate -- 账务日期
    ,transno -- 交易流水号
    ,transtype -- 交易类型
    ,transamt -- 交易金额
    ,noaccstatus -- 非应计状态
    ,prioccamt -- 本金发生额
    ,intoccamt -- 利息发生额
    ,defintoccamt -- 罚息发生额
    ,czflag -- 冲正标识
    ,channel -- 渠道
    ,transdate -- 交易时间戳
    ,transorgid -- 交易机构
    ,migttype -- 交易标志
    ,inputuserid -- 登记人
    ,inputorgid -- 登记机构
    ,inputdate -- 登记日期
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,compintoccamt -- 复利发生额
    ,hxduebillno -- 核心借据号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_lhd_trans_flow_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_lhd_trans_flow_info exchange partition p_${batch_date} with table ${iol_schema}.icms_lhd_trans_flow_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_lhd_trans_flow_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_lhd_trans_flow_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_lhd_trans_flow_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);