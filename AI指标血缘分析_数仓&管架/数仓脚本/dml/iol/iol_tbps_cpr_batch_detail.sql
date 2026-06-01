/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbps_cpr_batch_detail
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
drop table ${iol_schema}.tbps_cpr_batch_detail_ex purge;
alter table ${iol_schema}.tbps_cpr_batch_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.tbps_cpr_batch_detail;

-- 2.3 insert data to ex table
create table ${iol_schema}.tbps_cpr_batch_detail_ex nologging
compress
as
select * from ${iol_schema}.tbps_cpr_batch_detail where 0=1;

insert /*+ append */ into ${iol_schema}.tbps_cpr_batch_detail_ex(
    cbd_batchno -- 批次号
    ,cbd_seqno -- 序号，从1-9999
    ,cbd_trade_flowno -- 流水号
    ,cbd_sendflowno -- 
    ,cbd_payacc -- 付款账号
    ,cbd_payname -- 付款账号户名
    ,cbd_payacctype -- 付款账户类型
    ,cbd_currency -- 付款账户币种
    ,cbd_paynode -- 付款方网点
    ,cbd_paybank -- 付款方开户行名称
    ,cbd_crflag -- 钞汇标志：C：钞；R：汇；X：不适用
    ,cbd_rcvacc -- 收款账号
    ,cbd_rcvname -- 收款账号户名
    ,cbd_rcvcry -- 收款账户币种
    ,cbd_rcvciftype -- 收款人类型：1；企业；2；个人
    ,cbd_rcvnode -- 收款行网点
    ,cbd_rcvbank -- 收款行开户行名称
    ,cbd_payeebankname -- 收款行名
    ,cbd_payeeprovincecode -- 收款行省号
    ,cbd_payeeprovincename -- 收款行省名
    ,cbd_payeecitycode -- 收款行城市号
    ,cbd_payeecityname -- 收款行城市名
    ,cbd_unionnode -- 收款行联行号
    ,cbd_payeeuniondeptname -- 收款行联行名
    ,cbd_rcvclearbankid -- 收款行清算行号
    ,cbd_rcvphone -- 收款人手机号码
    ,cbd_tranamt -- 金额
    ,cbd_fee -- 手续费
    ,cbd_tranchannel -- 转账路由
    ,cbd_purpose -- 转账用途
    ,cbd_remark -- 附言
    ,cbd_transcode -- 交易码
    ,cbd_transdate -- 交易日期
    ,cbd_transtime -- 交易时间
    ,cbd_saveflag -- 保存收款人
    ,cbd_noticercv -- 通知收款人
    ,cbd_stt -- 状态
    ,cbd_returncode -- 返回码
    ,cbd_returnmsg -- 返回信息
    ,cbd_starttime -- 处理开始时间
    ,cbd_endtime -- 处理结束时间
    ,cbd_hostflow -- 核心流水号
    ,cbd_validatemsg -- 验证信息
    ,cbd_errormsg -- 错误信息
    ,cbd_hostdate -- 核心日期
    ,cbd_other -- 其他
    ,cbd_biz_flow_no -- 业务流水号
    ,cbd_chain_track_no -- 链路跟踪号
    ,cbd_send_flow_no -- 上游交易流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    cbd_batchno -- 批次号
    ,cbd_seqno -- 序号，从1-9999
    ,cbd_trade_flowno -- 流水号
    ,cbd_sendflowno -- 
    ,cbd_payacc -- 付款账号
    ,cbd_payname -- 付款账号户名
    ,cbd_payacctype -- 付款账户类型
    ,cbd_currency -- 付款账户币种
    ,cbd_paynode -- 付款方网点
    ,cbd_paybank -- 付款方开户行名称
    ,cbd_crflag -- 钞汇标志：C：钞；R：汇；X：不适用
    ,cbd_rcvacc -- 收款账号
    ,cbd_rcvname -- 收款账号户名
    ,cbd_rcvcry -- 收款账户币种
    ,cbd_rcvciftype -- 收款人类型：1；企业；2；个人
    ,cbd_rcvnode -- 收款行网点
    ,cbd_rcvbank -- 收款行开户行名称
    ,cbd_payeebankname -- 收款行名
    ,cbd_payeeprovincecode -- 收款行省号
    ,cbd_payeeprovincename -- 收款行省名
    ,cbd_payeecitycode -- 收款行城市号
    ,cbd_payeecityname -- 收款行城市名
    ,cbd_unionnode -- 收款行联行号
    ,cbd_payeeuniondeptname -- 收款行联行名
    ,cbd_rcvclearbankid -- 收款行清算行号
    ,cbd_rcvphone -- 收款人手机号码
    ,cbd_tranamt -- 金额
    ,cbd_fee -- 手续费
    ,cbd_tranchannel -- 转账路由
    ,cbd_purpose -- 转账用途
    ,cbd_remark -- 附言
    ,cbd_transcode -- 交易码
    ,cbd_transdate -- 交易日期
    ,cbd_transtime -- 交易时间
    ,cbd_saveflag -- 保存收款人
    ,cbd_noticercv -- 通知收款人
    ,cbd_stt -- 状态
    ,cbd_returncode -- 返回码
    ,cbd_returnmsg -- 返回信息
    ,cbd_starttime -- 处理开始时间
    ,cbd_endtime -- 处理结束时间
    ,cbd_hostflow -- 核心流水号
    ,cbd_validatemsg -- 验证信息
    ,cbd_errormsg -- 错误信息
    ,cbd_hostdate -- 核心日期
    ,cbd_other -- 其他
    ,cbd_biz_flow_no -- 业务流水号
    ,cbd_chain_track_no -- 链路跟踪号
    ,cbd_send_flow_no -- 上游交易流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tbps_cpr_batch_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tbps_cpr_batch_detail exchange partition p_${batch_date} with table ${iol_schema}.tbps_cpr_batch_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbps_cpr_batch_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tbps_cpr_batch_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbps_cpr_batch_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);