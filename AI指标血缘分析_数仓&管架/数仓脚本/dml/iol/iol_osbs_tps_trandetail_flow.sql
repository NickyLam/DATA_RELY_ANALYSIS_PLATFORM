/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_tps_trandetail_flow
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
drop table ${iol_schema}.osbs_tps_trandetail_flow_ex purge;
alter table ${iol_schema}.osbs_tps_trandetail_flow add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.osbs_tps_trandetail_flow truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.osbs_tps_trandetail_flow_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_tps_trandetail_flow where 0=1;

insert /*+ append */ into ${iol_schema}.osbs_tps_trandetail_flow_ex(
    tdf_detail_flowno -- 明细流水号(23位全局流水号+9位序列号)
    ,tdf_ecifno -- 全行统一客户号
    ,tdf_userno -- 用户顺序号
    ,tdf_transtime -- 交易时间
    ,tdf_transcode -- 交易码
    ,tdf_optype -- 操作类型00计划新增 01跑批流水 02取消计划 03一站式转行 04定向转账 05亲密付计划新增 06亲密付跑批流水 07亲密付取消计划 08亲密付普通转账
    ,tdf_returncode -- 交易返回码
    ,tdf_returnmsg -- 失败原因
    ,tdf_amonut -- 交易金额
    ,tdf_currency -- 币种
    ,tdf_fee -- 手续费
    ,tdf_payaccno -- 付款账号
    ,tdf_payaccname -- 付款账户名称
    ,tdf_payacctype -- 付款账户类型
    ,tdf_rcvaccno -- 收款账号
    ,tdf_rcvaccname -- 收款账号名称
    ,tdf_rcvacctype -- 收款账户类型
    ,tdf_rcvbankid -- 收款人银行代码
    ,tdf_rcvbankname -- 收款人银行名称
    ,tdf_provincecode -- 收款人省份
    ,tdf_provincename -- 收款人省份名称
    ,tdf_citycode -- 收款人城市代码
    ,tdf_cityname -- 收款人城市名称
    ,tdf_submittime -- 计划制定时间
    ,tdf_type -- 计划类型
    ,tdf_tranfreq -- 交易频率
    ,tdf_nextexedate -- 下一次执行日期
    ,tdf_state -- 预约计划状态
    ,tdf_begindate -- 定时或定频起始日期
    ,tdf_enddate -- 截止日期
    ,tdf_limitname -- 限额属性
    ,tdf_securitytype -- 安全认证方式
    ,tdf_remark -- 附言
    ,tdf_use -- 用途
    ,tdf_trade_flowno -- 流水号(关联PUB_TRADE_FLOW.PTF_TRADE_FLOWNO)
    ,tdf_rcvaccnickname -- 收款人昵称
    ,tdf_deviceid -- ATM设备号
    ,tdf_rcvmobile -- 短信通知手机号码
    ,tdf_branchno -- 网点号
    ,tdf_branchname -- 网点名称
    ,tdf_deptid -- 
    ,tdf_pathid -- 转出路由
    ,tdf_routeid -- 汇路ID
    ,tdf_routename -- 汇路名称
    ,tdf_isnextday -- 是否次日转出
    ,tdf_mobileno -- 转账手机号码
    ,tdf_iscreditrepay -- 是否属信用卡还款  0-是，1-否，不传默认1
    ,tx_seq_num -- 交易订单号
    ,chain_way_track_no -- 链路跟踪号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tdf_detail_flowno -- 明细流水号(23位全局流水号+9位序列号)
    ,tdf_ecifno -- 全行统一客户号
    ,tdf_userno -- 用户顺序号
    ,tdf_transtime -- 交易时间
    ,tdf_transcode -- 交易码
    ,tdf_optype -- 操作类型00计划新增 01跑批流水 02取消计划 03一站式转行 04定向转账 05亲密付计划新增 06亲密付跑批流水 07亲密付取消计划 08亲密付普通转账
    ,tdf_returncode -- 交易返回码
    ,tdf_returnmsg -- 失败原因
    ,tdf_amonut -- 交易金额
    ,tdf_currency -- 币种
    ,tdf_fee -- 手续费
    ,tdf_payaccno -- 付款账号
    ,tdf_payaccname -- 付款账户名称
    ,tdf_payacctype -- 付款账户类型
    ,tdf_rcvaccno -- 收款账号
    ,tdf_rcvaccname -- 收款账号名称
    ,tdf_rcvacctype -- 收款账户类型
    ,tdf_rcvbankid -- 收款人银行代码
    ,tdf_rcvbankname -- 收款人银行名称
    ,tdf_provincecode -- 收款人省份
    ,tdf_provincename -- 收款人省份名称
    ,tdf_citycode -- 收款人城市代码
    ,tdf_cityname -- 收款人城市名称
    ,tdf_submittime -- 计划制定时间
    ,tdf_type -- 计划类型
    ,tdf_tranfreq -- 交易频率
    ,tdf_nextexedate -- 下一次执行日期
    ,tdf_state -- 预约计划状态
    ,tdf_begindate -- 定时或定频起始日期
    ,tdf_enddate -- 截止日期
    ,tdf_limitname -- 限额属性
    ,tdf_securitytype -- 安全认证方式
    ,tdf_remark -- 附言
    ,tdf_use -- 用途
    ,tdf_trade_flowno -- 流水号(关联PUB_TRADE_FLOW.PTF_TRADE_FLOWNO)
    ,tdf_rcvaccnickname -- 收款人昵称
    ,tdf_deviceid -- ATM设备号
    ,tdf_rcvmobile -- 短信通知手机号码
    ,tdf_branchno -- 网点号
    ,tdf_branchname -- 网点名称
    ,tdf_deptid -- 
    ,tdf_pathid -- 转出路由
    ,tdf_routeid -- 汇路ID
    ,tdf_routename -- 汇路名称
    ,tdf_isnextday -- 是否次日转出
    ,tdf_mobileno -- 转账手机号码
    ,tdf_iscreditrepay -- 是否属信用卡还款  0-是，1-否，不传默认1
    ,tx_seq_num -- 交易订单号
    ,chain_way_track_no -- 链路跟踪号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.osbs_tps_trandetail_flow
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.osbs_tps_trandetail_flow exchange partition p_${batch_date} with table ${iol_schema}.osbs_tps_trandetail_flow_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_tps_trandetail_flow to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.osbs_tps_trandetail_flow_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_tps_trandetail_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);