/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a49tefcrdtbth
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
drop table ${iol_schema}.mpcs_a49tefcrdtbth_ex purge;
alter table ${iol_schema}.mpcs_a49tefcrdtbth add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a49tefcrdtbth truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a49tefcrdtbth_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a49tefcrdtbth where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a49tefcrdtbth_ex(
    bachdt -- 批次日期
    ,bachsq -- 批次流水
    ,entrustdate -- 委托日期
    ,msgid -- 信息序号(支付报单号)
    ,iotype -- 往来标识
    ,cntrno -- 合同(协议)号
    ,filena -- 批次文件名
    ,rspfile -- 响应文件名
    ,bachtp -- 交易类型
    ,totlan -- 总笔数
    ,totlam -- 总金额
    ,succnt -- 成功笔数
    ,sucamt -- 成功总金额
    ,failct -- 失败笔数
    ,failam -- 失败总金额
    ,acctno -- 账号
    ,acctna -- 账户名称
    ,colldate -- 对账日期
    ,hostdt -- 主机日期
    ,hostsq -- 主机流水号
    ,userid -- 录入柜员
    ,brchno -- 录入机构
    ,ckbrus -- 复核柜员
    ,ckbrno -- 复核机构
    ,txnid -- 中心受理号
    ,txndate -- 清算日期
    ,txnround -- 清算场次
    ,status -- 状态
    ,msgcode -- 错误代码
    ,msgtext -- 错误信息
    ,obthdt -- 原批次日期
    ,obthsq -- 原批次流水
    ,tolfile -- 应该发送文件总数
    ,sendct -- 上传文件数
    ,recvct -- 接收文件数
    ,hzflag -- 代收付，定期借记来账回执状态标记(0-未回执 1-已回执)
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    bachdt -- 批次日期
    ,bachsq -- 批次流水
    ,entrustdate -- 委托日期
    ,msgid -- 信息序号(支付报单号)
    ,iotype -- 往来标识
    ,cntrno -- 合同(协议)号
    ,filena -- 批次文件名
    ,rspfile -- 响应文件名
    ,bachtp -- 交易类型
    ,totlan -- 总笔数
    ,totlam -- 总金额
    ,succnt -- 成功笔数
    ,sucamt -- 成功总金额
    ,failct -- 失败笔数
    ,failam -- 失败总金额
    ,acctno -- 账号
    ,acctna -- 账户名称
    ,colldate -- 对账日期
    ,hostdt -- 主机日期
    ,hostsq -- 主机流水号
    ,userid -- 录入柜员
    ,brchno -- 录入机构
    ,ckbrus -- 复核柜员
    ,ckbrno -- 复核机构
    ,txnid -- 中心受理号
    ,txndate -- 清算日期
    ,txnround -- 清算场次
    ,status -- 状态
    ,msgcode -- 错误代码
    ,msgtext -- 错误信息
    ,obthdt -- 原批次日期
    ,obthsq -- 原批次流水
    ,tolfile -- 应该发送文件总数
    ,sendct -- 上传文件数
    ,recvct -- 接收文件数
    ,hzflag -- 代收付，定期借记来账回执状态标记(0-未回执 1-已回执)
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a49tefcrdtbth
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a49tefcrdtbth exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a49tefcrdtbth_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a49tefcrdtbth to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a49tefcrdtbth_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a49tefcrdtbth',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);