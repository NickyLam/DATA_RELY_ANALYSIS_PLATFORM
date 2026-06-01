/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_alss_am_acc_handle_tb
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
drop table ${iol_schema}.alss_am_acc_handle_tb_ex purge;
alter table ${iol_schema}.alss_am_acc_handle_tb add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.alss_am_acc_handle_tb;

-- 2.3 insert data to ex table
create table ${iol_schema}.alss_am_acc_handle_tb_ex nologging
compress
as
select * from ${iol_schema}.alss_am_acc_handle_tb where 0=1;

insert /*+ append */ into ${iol_schema}.alss_am_acc_handle_tb_ex(
    acctno -- 账号
    ,spectp -- 账号类型
    ,invost -- 原交易渠道状态
    ,channelstatus -- 现交易渠道状态
    ,operateremarks -- 处置原因
    ,statusupdateorg -- 渠道状态变更机构
    ,trandt -- 核心交易日期
    ,transq -- 核心交易流水
    ,frozdt -- 止付日期
    ,frozsq -- 止付流水
    ,unfrdt -- 解止日期
    ,unfrsq -- 解止流水
    ,frtransq -- 止付解止付主机流水号
    ,operatetype -- 处置操作类型
    ,freezetransno -- 冻结流水号
    ,freezeno -- 冻结编号
    ,freezedate -- 冻结日期
    ,freezestatus -- 账户冻结状态
    ,statusid -- 账户状态
    ,reason -- 账户处置原因
    ,isdealsource -- 处置来源
    ,warn_id -- 预警编号
    ,form_id -- 
    ,teller_id -- 
    ,client_no -- 
    ,trantime -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acctno -- 账号
    ,spectp -- 账号类型
    ,invost -- 原交易渠道状态
    ,channelstatus -- 现交易渠道状态
    ,operateremarks -- 处置原因
    ,statusupdateorg -- 渠道状态变更机构
    ,trandt -- 核心交易日期
    ,transq -- 核心交易流水
    ,frozdt -- 止付日期
    ,frozsq -- 止付流水
    ,unfrdt -- 解止日期
    ,unfrsq -- 解止流水
    ,frtransq -- 止付解止付主机流水号
    ,operatetype -- 处置操作类型
    ,freezetransno -- 冻结流水号
    ,freezeno -- 冻结编号
    ,freezedate -- 冻结日期
    ,freezestatus -- 账户冻结状态
    ,statusid -- 账户状态
    ,reason -- 账户处置原因
    ,isdealsource -- 处置来源
    ,warn_id -- 预警编号
    ,form_id -- 
    ,teller_id -- 
    ,client_no -- 
    ,trantime -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.alss_am_acc_handle_tb
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.alss_am_acc_handle_tb exchange partition p_${batch_date} with table ${iol_schema}.alss_am_acc_handle_tb_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.alss_am_acc_handle_tb to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.alss_am_acc_handle_tb_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'alss_am_acc_handle_tb',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);