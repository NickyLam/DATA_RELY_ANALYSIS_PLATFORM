/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a49tefpaytran
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
drop table ${iol_schema}.mpcs_a49tefpaytran_ex purge;
alter table ${iol_schema}.mpcs_a49tefpaytran add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a49tefpaytran truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a49tefpaytran_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a49tefpaytran where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a49tefpaytran_ex(
    trandt -- 交易日期
    ,transq -- 交易流水号
    ,trantm -- 交易时间
    ,txntype -- 交易类型细分
    ,iotype -- 渠道
    ,transt -- 交易状态
    ,magbrn -- 管理机构
    ,colldate -- 对账日期
    ,hostdt -- 主机日期
    ,hostsq -- 主机流水号
    ,colldt -- 冲正日期
    ,collsq -- 冲正流水
    ,msgcode -- 响应码
    ,msgtext -- 响应描述
    ,priority -- 优先级
    ,sysid -- 发起方系统号
    ,sndzone -- 发起地区代码
    ,rcvzone -- 接收地区代码
    ,msgno -- 报文编号
    ,msgid -- 信息序号
    ,origmsgid -- 原信息序号
    ,macflag -- 编核押标志
    ,entrustdate -- 委托日期
    ,vouchno -- 凭证提交号
    ,trantp -- 交易类型
    ,currencycd -- 交易货币
    ,amount -- 交易金额
    ,feeamt -- 手续费
    ,postam -- 邮电费
    ,handam -- 工本费
    ,sendbank -- 发起行行号/代理行
    ,payerbank -- 付款行行号
    ,payeraccbank -- 付款人开户行行号
    ,payeracc -- 付款人账号
    ,payername -- 付款人名称
    ,acctbr -- 付款账号开户行
    ,payeebank -- 收款行行号
    ,payeeaccbank -- 收款人开户行行号
    ,payeeacc -- 收款人账号
    ,payeename -- 收款人名称
    ,oprchl -- 业务渠道
    ,billid -- 缴费标识号
    ,oprtype -- 业务类型
    ,paytype -- 缴费类型
    ,payterm -- 查询缴费期
    ,userno -- 用户编号
    ,txnid -- 中心受理号
    ,txndate -- 清算日期
    ,txnround -- 清算场次
    ,retcd -- 返回码
    ,remark -- 附言
    ,prtmsg -- 打印信息
    ,brchno -- 营业点
    ,userid -- 柜员号
    ,ckbkus -- 授权柜员
    ,ckbkbr -- 授权网点
    ,linkid -- 链路ID
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    trandt -- 交易日期
    ,transq -- 交易流水号
    ,trantm -- 交易时间
    ,txntype -- 交易类型细分
    ,iotype -- 渠道
    ,transt -- 交易状态
    ,magbrn -- 管理机构
    ,colldate -- 对账日期
    ,hostdt -- 主机日期
    ,hostsq -- 主机流水号
    ,colldt -- 冲正日期
    ,collsq -- 冲正流水
    ,msgcode -- 响应码
    ,msgtext -- 响应描述
    ,priority -- 优先级
    ,sysid -- 发起方系统号
    ,sndzone -- 发起地区代码
    ,rcvzone -- 接收地区代码
    ,msgno -- 报文编号
    ,msgid -- 信息序号
    ,origmsgid -- 原信息序号
    ,macflag -- 编核押标志
    ,entrustdate -- 委托日期
    ,vouchno -- 凭证提交号
    ,trantp -- 交易类型
    ,currencycd -- 交易货币
    ,amount -- 交易金额
    ,feeamt -- 手续费
    ,postam -- 邮电费
    ,handam -- 工本费
    ,sendbank -- 发起行行号/代理行
    ,payerbank -- 付款行行号
    ,payeraccbank -- 付款人开户行行号
    ,payeracc -- 付款人账号
    ,payername -- 付款人名称
    ,acctbr -- 付款账号开户行
    ,payeebank -- 收款行行号
    ,payeeaccbank -- 收款人开户行行号
    ,payeeacc -- 收款人账号
    ,payeename -- 收款人名称
    ,oprchl -- 业务渠道
    ,billid -- 缴费标识号
    ,oprtype -- 业务类型
    ,paytype -- 缴费类型
    ,payterm -- 查询缴费期
    ,userno -- 用户编号
    ,txnid -- 中心受理号
    ,txndate -- 清算日期
    ,txnround -- 清算场次
    ,retcd -- 返回码
    ,remark -- 附言
    ,prtmsg -- 打印信息
    ,brchno -- 营业点
    ,userid -- 柜员号
    ,ckbkus -- 授权柜员
    ,ckbkbr -- 授权网点
    ,linkid -- 链路ID
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a49tefpaytran
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a49tefpaytran exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a49tefpaytran_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a49tefpaytran to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a49tefpaytran_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a49tefpaytran',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);