/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a51ubforetraffic
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
drop table ${iol_schema}.mpcs_a51ubforetraffic_ex purge;
alter table ${iol_schema}.mpcs_a51ubforetraffic add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a51ubforetraffic truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a51ubforetraffic_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a51ubforetraffic where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a51ubforetraffic_ex(
    acqinstid -- 受理方标识码
    ,fwdinstid -- 发送方标识码
    ,systrace -- 系统跟踪号(银联流水号)
    ,transtime -- 交易时间(MMDDHHMMSS)
    ,transcode -- 交易码
    ,transdate -- 前置交易日期
    ,transnbr -- 交易流水号
    ,tlrnbr -- 柜员号
    ,brnnbr -- 网点号
    ,trantype -- 交易类型
    ,channels -- 渠道
    ,msgtype -- 消息类型
    ,priacct -- 主账户号
    ,cltname -- 客户姓名
    ,identype -- 证件类型
    ,idennbr -- 证件号码
    ,procecode -- 处理码
    ,transamt -- 交易金额
    ,localtime -- 受理方所在地时间
    ,localdate -- 受理方所在地日期
    ,exprdate -- 有效期
    ,settlmtdate -- 清算日期
    ,mchnttype -- 商户类型
    ,posentrymode -- 服务点输入方式码
    ,servicecode -- 服务点条件码
    ,trackdata2 -- 第二磁道数据
    ,trackdata3 -- 第三磁道数据
    ,retrivarefnum -- 检索参考号
    ,authridresp -- 授权标识应答码
    ,respcode -- 响应码
    ,acptermnlid -- 受理终端标识码
    ,accptrid -- 受理商户代码
    ,accttrnameloc -- 受理方名称/地址
    ,addtnlrespcd -- 附加响应数据
    ,privatedate -- 附加私有数据
    ,currcycode -- 交易货币代码
    ,pindata -- 个人标识码数据
    ,reserve -- 保留域
    ,oldacqinstid -- 原受理方标识码
    ,oldfwdinstid -- 原发送方标识码
    ,oldsystrace -- 原系统跟踪号
    ,oldtranstime -- 原交易时间(MMDDHHMMSS)
    ,factor -- 代理人
    ,fridentype -- 代理证件类型
    ,fridennbr -- 代理证件号码
    ,outacctnbr -- 支出帐号
    ,inacctnbr -- 存入账号
    ,hostnbr -- 核心流水
    ,hostdate -- 核心日期
    ,status -- 状态0 : 失效状态1 : 交易成功2 : 已冲正3 : 已挂账
    ,errcode -- 错误码
    ,errmsg -- 错误信息
    ,cardname -- 柜面通持卡人姓名
    ,recvname -- 柜面通收款人姓名
    ,linkid -- 链路ID
    ,cardseq -- 卡序列号
    ,inpbocelem -- 接入IC卡数据域
    ,outpbocelem -- 发出IC卡数据域
    ,busi_seq -- 业务流水号
    ,global_seq -- 原全局流水号
    ,old_busi_seq -- 原业务流水号
    ,old_global_seq -- 原全局流水号
    ,old_trn_seq -- 原交易流水号(原系统内流水号)
    ,trn_seq -- 交易流水号(系统内流水号)
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acqinstid -- 受理方标识码
    ,fwdinstid -- 发送方标识码
    ,systrace -- 系统跟踪号(银联流水号)
    ,transtime -- 交易时间(MMDDHHMMSS)
    ,transcode -- 交易码
    ,transdate -- 前置交易日期
    ,transnbr -- 交易流水号
    ,tlrnbr -- 柜员号
    ,brnnbr -- 网点号
    ,trantype -- 交易类型
    ,channels -- 渠道
    ,msgtype -- 消息类型
    ,priacct -- 主账户号
    ,cltname -- 客户姓名
    ,identype -- 证件类型
    ,idennbr -- 证件号码
    ,procecode -- 处理码
    ,transamt -- 交易金额
    ,localtime -- 受理方所在地时间
    ,localdate -- 受理方所在地日期
    ,exprdate -- 有效期
    ,settlmtdate -- 清算日期
    ,mchnttype -- 商户类型
    ,posentrymode -- 服务点输入方式码
    ,servicecode -- 服务点条件码
    ,trackdata2 -- 第二磁道数据
    ,trackdata3 -- 第三磁道数据
    ,retrivarefnum -- 检索参考号
    ,authridresp -- 授权标识应答码
    ,respcode -- 响应码
    ,acptermnlid -- 受理终端标识码
    ,accptrid -- 受理商户代码
    ,accttrnameloc -- 受理方名称/地址
    ,addtnlrespcd -- 附加响应数据
    ,privatedate -- 附加私有数据
    ,currcycode -- 交易货币代码
    ,pindata -- 个人标识码数据
    ,reserve -- 保留域
    ,oldacqinstid -- 原受理方标识码
    ,oldfwdinstid -- 原发送方标识码
    ,oldsystrace -- 原系统跟踪号
    ,oldtranstime -- 原交易时间(MMDDHHMMSS)
    ,factor -- 代理人
    ,fridentype -- 代理证件类型
    ,fridennbr -- 代理证件号码
    ,outacctnbr -- 支出帐号
    ,inacctnbr -- 存入账号
    ,hostnbr -- 核心流水
    ,hostdate -- 核心日期
    ,status -- 状态0 : 失效状态1 : 交易成功2 : 已冲正3 : 已挂账
    ,errcode -- 错误码
    ,errmsg -- 错误信息
    ,cardname -- 柜面通持卡人姓名
    ,recvname -- 柜面通收款人姓名
    ,linkid -- 链路ID
    ,cardseq -- 卡序列号
    ,inpbocelem -- 接入IC卡数据域
    ,outpbocelem -- 发出IC卡数据域
    ,busi_seq -- 业务流水号
    ,global_seq -- 原全局流水号
    ,old_busi_seq -- 原业务流水号
    ,old_global_seq -- 原全局流水号
    ,old_trn_seq -- 原交易流水号(原系统内流水号)
    ,trn_seq -- 交易流水号(系统内流水号)
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a51ubforetraffic
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a51ubforetraffic exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a51ubforetraffic_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a51ubforetraffic to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a51ubforetraffic_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a51ubforetraffic',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);