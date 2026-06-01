/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a10tibpsregeditlog
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
drop table ${iol_schema}.mpcs_a10tibpsregeditlog_ex purge;
alter table ${iol_schema}.mpcs_a10tibpsregeditlog add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a10tibpsregeditlog truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a10tibpsregeditlog_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a10tibpsregeditlog where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a10tibpsregeditlog_ex(
    function -- 函数名称
    ,pckno -- 报文类型
    ,transdt -- 交易日期--人行日期
    ,businesstrace -- 业务序号
    ,businessno -- 报文标识号
    ,transtime -- 交易时间--登表时间
    ,msgoutbank -- 发起行号
    ,msginbank -- 接收行号
    ,functype -- 业务类型：REGEDIT_注册，DELE_注销，ANMD_变更账号，DAMD_变更默认账户属性，SBUS_业务状态查询，VERIFY_验证，DOWNLOAD_下载
    ,idtype -- 证件类型
    ,idcode -- 证件号
    ,dftaccttp -- 默认账户属性：DFLT_默认账户，NDFT_非默认账户
    ,rejectbank -- 开户行所属网银系统行号
    ,acctno -- 账号
    ,acctname -- 户名
    ,mskacctname -- 掩码户名
    ,acctopenbrn -- 账户开户行
    ,sdficode -- 账户清算行
    ,tel -- 手机号
    ,otherid -- 其他ID
    ,remark -- 备注
    ,canclebanks -- 注销的行号列表
    ,newacctno -- 新账号
    ,newdftaccttp -- 新账户注册属性
    ,newacctbank -- 新账户注册属性行号
    ,iotype -- 往来标志：0_往，1_来
    ,processcode -- 业务状态
    ,rsrejectcode -- 业务拒绝码
    ,procdt -- 人行处理时间
    ,fill -- 错误信息
    ,status -- 交易状态：Z_初始状态，W_处理中（已发送），F_失败，S_成功，U_未知（超时）
    ,channlid -- 渠道号
    ,transseqno -- 渠道流水
    ,otpseqno -- 短信序列号
    ,orgnlmsgid -- 原报文标识号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    function -- 函数名称
    ,pckno -- 报文类型
    ,transdt -- 交易日期--人行日期
    ,businesstrace -- 业务序号
    ,businessno -- 报文标识号
    ,transtime -- 交易时间--登表时间
    ,msgoutbank -- 发起行号
    ,msginbank -- 接收行号
    ,functype -- 业务类型：REGEDIT_注册，DELE_注销，ANMD_变更账号，DAMD_变更默认账户属性，SBUS_业务状态查询，VERIFY_验证，DOWNLOAD_下载
    ,idtype -- 证件类型
    ,idcode -- 证件号
    ,dftaccttp -- 默认账户属性：DFLT_默认账户，NDFT_非默认账户
    ,rejectbank -- 开户行所属网银系统行号
    ,acctno -- 账号
    ,acctname -- 户名
    ,mskacctname -- 掩码户名
    ,acctopenbrn -- 账户开户行
    ,sdficode -- 账户清算行
    ,tel -- 手机号
    ,otherid -- 其他ID
    ,remark -- 备注
    ,canclebanks -- 注销的行号列表
    ,newacctno -- 新账号
    ,newdftaccttp -- 新账户注册属性
    ,newacctbank -- 新账户注册属性行号
    ,iotype -- 往来标志：0_往，1_来
    ,processcode -- 业务状态
    ,rsrejectcode -- 业务拒绝码
    ,procdt -- 人行处理时间
    ,fill -- 错误信息
    ,status -- 交易状态：Z_初始状态，W_处理中（已发送），F_失败，S_成功，U_未知（超时）
    ,channlid -- 渠道号
    ,transseqno -- 渠道流水
    ,otpseqno -- 短信序列号
    ,orgnlmsgid -- 原报文标识号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a10tibpsregeditlog
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a10tibpsregeditlog exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a10tibpsregeditlog_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a10tibpsregeditlog to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a10tibpsregeditlog_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a10tibpsregeditlog',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);