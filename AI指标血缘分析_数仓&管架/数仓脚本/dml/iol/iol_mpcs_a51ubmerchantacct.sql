/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a51ubmerchantacct
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
drop table ${iol_schema}.mpcs_a51ubmerchantacct_ex purge;
alter table ${iol_schema}.mpcs_a51ubmerchantacct add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a51ubmerchantacct truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a51ubmerchantacct_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a51ubmerchantacct where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a51ubmerchantacct_ex(
    transdate -- 交易日期
    ,transnbr -- 交易流水号
    ,hostnbr -- 主机流水
    ,hostdate -- 主机日期
    ,lnflag -- 交易地标志N : 异地L : 本地l : 本地
    ,bankname -- 行名
    ,merchantname -- 商户名称
    ,dateofstlm -- 清算日期
    ,bankcode -- 行号
    ,merchantcode -- 商行代码
    ,transamt -- 交易金额
    ,mchtsevifee -- 商行服务金额
    ,acctno -- 账号
    ,sumoffee -- 手续费
    ,pcaamt -- 消费金额
    ,pptamt -- 退货金额
    ,rvslpcaamt -- 消费沖正金额
    ,rvslpptamt -- 退货沖正金额
    ,dadjamt -- 借记调整金额
    ,cadjamt -- 贷记调整金额
    ,transt -- 交易状态 0：失败 1：成功 5：超时未知  9：预登记
    ,errcode -- 错误码
    ,errmsg -- 错误信息
    ,flag -- 标志
    ,status -- 状态 0：失败未处理 1：已入账 2：已挂账  9：无需处理
    ,brchno -- 行号
    ,accnbr -- 柜员号
    ,trandt -- 前置交易日期
    ,sdtlsq -- 登记流水
    ,transnum -- 交易总笔数
    ,brchbr -- 机构代码
    ,acctioflg -- 行内行外标记 1-行内 2-行外
    ,sysdt -- 系统日期
    ,batchno -- 批次号
    ,remark1 -- 实际入账账户
    ,remark2 -- 保留2
    ,remark3 -- 核心附言
    ,remark4 -- 保留4
    ,remark5 -- 保留5
    ,busi_seq -- 业务流水号
    ,global_seq -- 全局流水号
    ,trn_seq -- 交易流水号
    ,old_busi_seq -- 原交易流水号
    ,old_global_seq -- 原全局流水号
    ,old_trn_seq -- 原业务流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    transdate -- 交易日期
    ,transnbr -- 交易流水号
    ,hostnbr -- 主机流水
    ,hostdate -- 主机日期
    ,lnflag -- 交易地标志N : 异地L : 本地l : 本地
    ,bankname -- 行名
    ,merchantname -- 商户名称
    ,dateofstlm -- 清算日期
    ,bankcode -- 行号
    ,merchantcode -- 商行代码
    ,transamt -- 交易金额
    ,mchtsevifee -- 商行服务金额
    ,acctno -- 账号
    ,sumoffee -- 手续费
    ,pcaamt -- 消费金额
    ,pptamt -- 退货金额
    ,rvslpcaamt -- 消费沖正金额
    ,rvslpptamt -- 退货沖正金额
    ,dadjamt -- 借记调整金额
    ,cadjamt -- 贷记调整金额
    ,transt -- 交易状态 0：失败 1：成功 5：超时未知  9：预登记
    ,errcode -- 错误码
    ,errmsg -- 错误信息
    ,flag -- 标志
    ,status -- 状态 0：失败未处理 1：已入账 2：已挂账  9：无需处理
    ,brchno -- 行号
    ,accnbr -- 柜员号
    ,trandt -- 前置交易日期
    ,sdtlsq -- 登记流水
    ,transnum -- 交易总笔数
    ,brchbr -- 机构代码
    ,acctioflg -- 行内行外标记 1-行内 2-行外
    ,sysdt -- 系统日期
    ,batchno -- 批次号
    ,remark1 -- 实际入账账户
    ,remark2 -- 保留2
    ,remark3 -- 核心附言
    ,remark4 -- 保留4
    ,remark5 -- 保留5
    ,busi_seq -- 业务流水号
    ,global_seq -- 全局流水号
    ,trn_seq -- 交易流水号
    ,old_busi_seq -- 原交易流水号
    ,old_global_seq -- 原全局流水号
    ,old_trn_seq -- 原业务流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a51ubmerchantacct
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a51ubmerchantacct exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a51ubmerchantacct_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a51ubmerchantacct to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a51ubmerchantacct_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a51ubmerchantacct',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);