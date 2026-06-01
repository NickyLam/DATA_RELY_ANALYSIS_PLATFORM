/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_f_asyn_genealogy2_nodes
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
drop table ${iol_schema}.uxds_f_asyn_genealogy2_nodes_ex purge;
alter table ${iol_schema}.uxds_f_asyn_genealogy2_nodes add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.uxds_f_asyn_genealogy2_nodes truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_f_asyn_genealogy2_nodes_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uxds_f_asyn_genealogy2_nodes where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_f_asyn_genealogy2_nodes_ex(
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,properties_name -- 名称
    ,properties_entstatus -- 企业状态
    ,properties_regcapcur -- 注册币种code
    ,innode -- 是否是输入节点
    ,type -- 节点类型
    ,nodes -- 关联标签
    ,properties_regno -- 注册号
    ,properties_regcap -- 注册资本
    ,name -- 节点名称
    ,properties_esdate -- 成立日期
    ,id -- 节点id
    ,properties_creditcode -- 统一社会信用代码
    ,properties_islist -- 是否上市
    ,properties_nodeid -- 节点id
    ,properties_samevalue --疑似关系节点信息
    ,properties_regcapcur_desc --注册币种描述
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,properties_name -- 名称
    ,properties_entstatus -- 企业状态
    ,properties_regcapcur -- 注册币种code
    ,innode -- 是否是输入节点
    ,type -- 节点类型
    ,nodes -- 关联标签
    ,properties_regno -- 注册号
    ,properties_regcap -- 注册资本
    ,name -- 节点名称
    ,properties_esdate -- 成立日期
    ,id -- 节点id
    ,properties_creditcode -- 统一社会信用代码
    ,properties_islist -- 是否上市
    ,properties_nodeid -- 节点id
    ,properties_samevalue --疑似关系节点信息
    ,properties_regcapcur_desc --注册币种描述
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_f_asyn_genealogy2_nodes
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_f_asyn_genealogy2_nodes exchange partition p_${batch_date} with table ${iol_schema}.uxds_f_asyn_genealogy2_nodes_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_f_asyn_genealogy2_nodes to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_f_asyn_genealogy2_nodes_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_f_asyn_genealogy2_nodes',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);