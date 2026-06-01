/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nibs_ib_log_comm_log
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
drop table ${iol_schema}.nibs_ib_log_comm_log_ex purge;
alter table ${iol_schema}.nibs_ib_log_comm_log add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.nibs_ib_log_comm_log truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.nibs_ib_log_comm_log_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_ib_log_comm_log where 0=1;

insert /*+ append */ into ${iol_schema}.nibs_ib_log_comm_log_ex(
    p_workdate -- 协同平台工作日期
    ,note2 -- 备用2
    ,core_tran_flow_num -- 全局流水号
    ,p_biz_seq_num -- 协同平台流水号
    ,sys_num -- 系统编号
    ,app_num -- 应用编号
    ,chan_num -- 渠道编号
    ,channeldate -- 渠道日期
    ,chan_biz_seq_num -- 渠道方系统流水号
    ,backsysnum -- 后台服务系统
    ,backintercode -- 后台服务系统接口码
    ,backintercodenm -- 后台服务系统接口名称
    ,backrspdate -- 后台响应日期
    ,backserialnum -- 后台流水号
    ,back_ret_status -- 后台处理状态
    ,back_ret_code -- 后台处理码
    ,back_ret_desc -- 后台返回信息
    ,reqdatetime -- 请求时间戳
    ,rspdatetime -- 响应时间戳
    ,channeltrancode -- 渠道交易码
    ,channeltranname -- 渠道交易名称
    ,biztype -- 业务类型
    ,nodecode -- 节点编码
    ,nodename -- 节点名称
    ,ismaincomm -- 主通讯标志
    ,cust_type_cd -- 客户类型
    ,cust_num -- 客户编号
    ,cn_name -- 客户名称
    ,cert_type_cd -- 证件类型
    ,cert_num -- 证件号码
    ,acct_num -- 账户编号
    ,acct_name -- 账号名称
    ,tx_amt -- 交易金额
    ,tx_cntpty_acct_num -- 交易对手账号
    ,tx_cntpty_name -- 交易对手名称
    ,note1 -- 备用1
    ,tx_seq_num -- 业务流水号(交易订单号)
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    p_workdate -- 协同平台工作日期
    ,note2 -- 备用2
    ,core_tran_flow_num -- 全局流水号
    ,p_biz_seq_num -- 协同平台流水号
    ,sys_num -- 系统编号
    ,app_num -- 应用编号
    ,chan_num -- 渠道编号
    ,channeldate -- 渠道日期
    ,chan_biz_seq_num -- 渠道方系统流水号
    ,backsysnum -- 后台服务系统
    ,backintercode -- 后台服务系统接口码
    ,backintercodenm -- 后台服务系统接口名称
    ,backrspdate -- 后台响应日期
    ,backserialnum -- 后台流水号
    ,back_ret_status -- 后台处理状态
    ,back_ret_code -- 后台处理码
    ,back_ret_desc -- 后台返回信息
    ,reqdatetime -- 请求时间戳
    ,rspdatetime -- 响应时间戳
    ,channeltrancode -- 渠道交易码
    ,channeltranname -- 渠道交易名称
    ,biztype -- 业务类型
    ,nodecode -- 节点编码
    ,nodename -- 节点名称
    ,ismaincomm -- 主通讯标志
    ,cust_type_cd -- 客户类型
    ,cust_num -- 客户编号
    ,cn_name -- 客户名称
    ,cert_type_cd -- 证件类型
    ,cert_num -- 证件号码
    ,acct_num -- 账户编号
    ,acct_name -- 账号名称
    ,tx_amt -- 交易金额
    ,tx_cntpty_acct_num -- 交易对手账号
    ,tx_cntpty_name -- 交易对手名称
    ,note1 -- 备用1
    ,tx_seq_num -- 业务流水号(交易订单号)
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.nibs_ib_log_comm_log
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.nibs_ib_log_comm_log exchange partition p_${batch_date} with table ${iol_schema}.nibs_ib_log_comm_log_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nibs_ib_log_comm_log to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.nibs_ib_log_comm_log_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nibs_ib_log_comm_log',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);