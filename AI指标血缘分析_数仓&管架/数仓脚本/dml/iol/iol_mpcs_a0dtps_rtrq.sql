/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a0dtps_rtrq
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
drop table ${iol_schema}.mpcs_a0dtps_rtrq_ex purge;
alter table ${iol_schema}.mpcs_a0dtps_rtrq add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.mpcs_a0dtps_rtrq;

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a0dtps_rtrq_ex nologging
compress
as
select * from ${iol_schema}.mpcs_a0dtps_rtrq where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a0dtps_rtrq_ex(
    sdtldt -- 登记日期
    ,sdtlsq -- 登记流水
    ,brchno -- 交易部门
    ,grupno -- 交易柜组
    ,txcode -- 征收机关代码
    ,tipsdt -- 委托日期
    ,tipssq -- 交易流水号
    ,hdtype -- 经收类别 1国库 2商业银行
    ,recvbk -- 收款行行号
    ,recvut -- 收款单位代码
    ,recvac -- 收款账号、入库账号
    ,recvna -- 收款单位名称
    ,pyerbk -- 付款行行号
    ,pyacbk -- 付款开户行行号
    ,pyerac -- 付款账号
    ,pyutna -- 缴款单位名称
    ,tranam -- 交易金额
    ,transt -- 处理状态 0收到请求 1成功 2失败 9冲正
    ,txvhno -- 税票号码
    ,txutna -- 纳税人名称
    ,contid -- 协议书号
    ,remark -- 备用
    ,remar1 -- 对账类型
    ,remar2 -- 备用
    ,listnm -- 税种条数
    ,tranus -- 录入用户
    ,taxdat -- 扣税日期
    ,retncd -- 处理结果 90000 成功
    ,rtinfo -- 回执附言
    ,dealtm -- 接收处理时间
    ,ckbkus -- 复核（回执）用户
    ,strksq -- 交易流水（对账不平时发往主机冲账后返回的主机流水）
    ,chckfg -- 对账标识 0未对帐1同为成功,金额一致2同为成功,金额不一致3人行成功,中台失败4人行成功,中台没记录5人行失败,中台成功7同为失败
    ,prtflg -- 打印标志 0未打印 1已打印
    ,packno -- 包流水号
    ,trantype -- 交易类型 1银行端缴款 2实时扣税 3批量扣税
    ,hostnbr -- 核心流水
    ,hostdate -- 核心日期
    ,dataid -- 主机记账ID
    ,colsts -- 主机对账状态 1-同为成功，金额一致 2-同为成功，金额不一致 3-主机成功，中台失败 4-主机成功，中台没记录 5-主机失败，中台成功 6-主机没记录，中台成功 7-同为失败
    ,chkflg -- 交易类型 Null未登记差错 1已登记差错 2登记差错失败
    ,queryno -- 银行端查询缴税序号
    ,paytype -- 缴款方式 1-现金 2-转账
    ,txutnaid -- 纳税人识别号
    ,bookseqno -- 凭证号码
    ,bookcode -- 凭证类型
    ,telphoneid -- 缴款人电话
    ,taxorgname -- 征收机关名称
    ,passwdid -- 密码
    ,chcktp -- 对账类型   0：日间对账 1：日切对账
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    sdtldt -- 登记日期
    ,sdtlsq -- 登记流水
    ,brchno -- 交易部门
    ,grupno -- 交易柜组
    ,txcode -- 征收机关代码
    ,tipsdt -- 委托日期
    ,tipssq -- 交易流水号
    ,hdtype -- 经收类别 1国库 2商业银行
    ,recvbk -- 收款行行号
    ,recvut -- 收款单位代码
    ,recvac -- 收款账号、入库账号
    ,recvna -- 收款单位名称
    ,pyerbk -- 付款行行号
    ,pyacbk -- 付款开户行行号
    ,pyerac -- 付款账号
    ,pyutna -- 缴款单位名称
    ,tranam -- 交易金额
    ,transt -- 处理状态 0收到请求 1成功 2失败 9冲正
    ,txvhno -- 税票号码
    ,txutna -- 纳税人名称
    ,contid -- 协议书号
    ,remark -- 备用
    ,remar1 -- 对账类型
    ,remar2 -- 备用
    ,listnm -- 税种条数
    ,tranus -- 录入用户
    ,taxdat -- 扣税日期
    ,retncd -- 处理结果 90000 成功
    ,rtinfo -- 回执附言
    ,dealtm -- 接收处理时间
    ,ckbkus -- 复核（回执）用户
    ,strksq -- 交易流水（对账不平时发往主机冲账后返回的主机流水）
    ,chckfg -- 对账标识 0未对帐1同为成功,金额一致2同为成功,金额不一致3人行成功,中台失败4人行成功,中台没记录5人行失败,中台成功7同为失败
    ,prtflg -- 打印标志 0未打印 1已打印
    ,packno -- 包流水号
    ,trantype -- 交易类型 1银行端缴款 2实时扣税 3批量扣税
    ,hostnbr -- 核心流水
    ,hostdate -- 核心日期
    ,dataid -- 主机记账ID
    ,colsts -- 主机对账状态 1-同为成功，金额一致 2-同为成功，金额不一致 3-主机成功，中台失败 4-主机成功，中台没记录 5-主机失败，中台成功 6-主机没记录，中台成功 7-同为失败
    ,chkflg -- 交易类型 Null未登记差错 1已登记差错 2登记差错失败
    ,queryno -- 银行端查询缴税序号
    ,paytype -- 缴款方式 1-现金 2-转账
    ,txutnaid -- 纳税人识别号
    ,bookseqno -- 凭证号码
    ,bookcode -- 凭证类型
    ,telphoneid -- 缴款人电话
    ,taxorgname -- 征收机关名称
    ,passwdid -- 密码
    ,chcktp -- 对账类型   0：日间对账 1：日切对账
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a0dtps_rtrq
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a0dtps_rtrq exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a0dtps_rtrq_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a0dtps_rtrq to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a0dtps_rtrq_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a0dtps_rtrq',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);