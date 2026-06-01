/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amls_t3b_msg
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
drop table ${iol_schema}.amls_t3b_msg_ex purge;
alter table ${iol_schema}.amls_t3b_msg add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.amls_t3b_msg;

-- 2.3 insert data to ex table
create table ${iol_schema}.amls_t3b_msg_ex nologging
compress
as
select * from ${iol_schema}.amls_t3b_msg where 0=1;

insert /*+ append */ into ${iol_schema}.amls_t3b_msg_ex(
    msg_id -- 报文代码
    ,stat_dt -- 数据日期
    ,rpt_id -- 报告代码
    ,msg_type -- 报文类型（参见[字典:aml0061]）
    ,packet_id -- 数据包代码
    ,rpt_type -- 报告类型（参见[字典:aml0062]）
    ,rpt_org_id -- 报告机构编码
    ,send_dt -- 报送日期
    ,send_char -- 报送日期（字符串）
    ,bat_seq -- 报送批次序号
    ,msg_seq -- 报文序号
    ,msg_file -- 报文文件名
    ,msg_file_path -- 报文路径 + 文件名
    ,orig_msg_file -- 原始报文文件名
    ,orig_msg_file_path -- 原始报文路径 + 文件名
    ,orig_msg_id -- 原始报文代码
    ,atht_file -- 附件文件名
    ,atht_file_path -- 附件文件名路径
    ,msg_sts -- 报文状态:aml0072
    ,create_tm -- 创建时间
    ,creator -- 创建人
    ,modify_tm -- 修改时间
    ,modifier -- 修改人
    ,msg_type_s -- 报文子类型（参见[字典:aml0162]）
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    msg_id -- 报文代码
    ,stat_dt -- 数据日期
    ,rpt_id -- 报告代码
    ,msg_type -- 报文类型（参见[字典:aml0061]）
    ,packet_id -- 数据包代码
    ,rpt_type -- 报告类型（参见[字典:aml0062]）
    ,rpt_org_id -- 报告机构编码
    ,send_dt -- 报送日期
    ,send_char -- 报送日期（字符串）
    ,bat_seq -- 报送批次序号
    ,msg_seq -- 报文序号
    ,msg_file -- 报文文件名
    ,msg_file_path -- 报文路径 + 文件名
    ,orig_msg_file -- 原始报文文件名
    ,orig_msg_file_path -- 原始报文路径 + 文件名
    ,orig_msg_id -- 原始报文代码
    ,atht_file -- 附件文件名
    ,atht_file_path -- 附件文件名路径
    ,msg_sts -- 报文状态:aml0072
    ,create_tm -- 创建时间
    ,creator -- 创建人
    ,modify_tm -- 修改时间
    ,modifier -- 修改人
    ,msg_type_s -- 报文子类型（参见[字典:aml0162]）
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.amls_t3b_msg
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.amls_t3b_msg exchange partition p_${batch_date} with table ${iol_schema}.amls_t3b_msg_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amls_t3b_msg to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.amls_t3b_msg_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amls_t3b_msg',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);