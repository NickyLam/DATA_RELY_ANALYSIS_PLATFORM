/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_flow_catalog
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
drop table ${iol_schema}.icms_flow_catalog_ex purge;
alter table ${iol_schema}.icms_flow_catalog add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_flow_catalog;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_flow_catalog_ex nologging
compress
as
select * from ${iol_schema}.icms_flow_catalog where 0=1;

insert /*+ append */ into ${iol_schema}.icms_flow_catalog_ex(
    flowno -- 流程编号
    ,version -- 版本
    ,grouptitles -- 流程图分组标题
    ,viewfile -- 流程图文件
    ,inputorgid -- 登记机构
    ,isinuse -- 是否有效
    ,updateuserid -- 更新人
    ,viewfilelength -- 流程图描述长度
    ,flowtype -- 流程类型
    ,baseflowname -- 基础流程名称
    ,corporgid -- 法人机构编号
    ,flowname -- 流程名称
    ,flowdescribe -- 流程描述
    ,flowbuttonset -- 流程按钮组，若流程没有关联的申请或审批类型，则使用此按钮组编号
    ,inputuserid -- 登记人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,baseflowno -- 流程号
    ,aaenabled -- 是否启用授权系统
    ,metaflowno -- 元版本号
    ,inputdate -- 登记日期
    ,initphase -- 初始阶段
    ,aapolicy -- 授权方案
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    flowno -- 流程编号
    ,version -- 版本
    ,grouptitles -- 流程图分组标题
    ,viewfile -- 流程图文件
    ,inputorgid -- 登记机构
    ,isinuse -- 是否有效
    ,updateuserid -- 更新人
    ,viewfilelength -- 流程图描述长度
    ,flowtype -- 流程类型
    ,baseflowname -- 基础流程名称
    ,corporgid -- 法人机构编号
    ,flowname -- 流程名称
    ,flowdescribe -- 流程描述
    ,flowbuttonset -- 流程按钮组，若流程没有关联的申请或审批类型，则使用此按钮组编号
    ,inputuserid -- 登记人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,baseflowno -- 流程号
    ,aaenabled -- 是否启用授权系统
    ,metaflowno -- 元版本号
    ,inputdate -- 登记日期
    ,initphase -- 初始阶段
    ,aapolicy -- 授权方案
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_flow_catalog
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_flow_catalog exchange partition p_${batch_date} with table ${iol_schema}.icms_flow_catalog_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_flow_catalog to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_flow_catalog_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_flow_catalog',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);