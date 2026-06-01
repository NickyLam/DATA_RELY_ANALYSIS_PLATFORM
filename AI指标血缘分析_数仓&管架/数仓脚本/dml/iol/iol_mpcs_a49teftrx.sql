/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a49teftrx
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
drop table ${iol_schema}.mpcs_a49teftrx_ex purge;
alter table ${iol_schema}.mpcs_a49teftrx add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
-- 2.2.1 get new data into table
set serveroutput on
declare bat_dt varchar2(10);
    v_p_exists varchar2(10);
    v_sql varchar2(200);
begin    
for i in 0 .. 14 loop
    bat_dt := to_char(to_date('${batch_date}','yyyymmdd') - i,'yyyymmdd');
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''mpcs_a49teftrx'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    execute immediate v_sql into v_p_exists;
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iol.mpcs_a49teftrx truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --no exists partitions  
    else 
        v_sql := 'alter table iol.mpcs_a49teftrx add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    end if;
      end loop;
end;
/


-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a49teftrx_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a49teftrx where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a49teftrx(
    unotnbr -- 前置流水号
    ,unotdate -- 前置日期
    ,unottime -- 前置时间机器时间
    ,hostnbr -- 主机流水号为主机记账流水号
    ,hostdate -- 主机日期
    ,magbrn -- 管理机构
    ,oprtlr -- 柜员号
    ,oprbrn -- 机构号
    ,auttlr -- 授权柜员
    ,autbrn -- 授权机构
    ,oprchl -- 通道号
    ,bthdate -- 批次日期
    ,bthseq -- 批次流水号
    ,msgid -- 支付报单号信息序号
    ,origmsgid -- 原交易支付单号
    ,txntype -- 交易类型细分
    ,trantype -- 业务种类
    ,entrustdate -- 委托日期
    ,vouchno -- 凭证提交号
    ,msgno -- 报文编号
    ,pkgno -- 包序号
    ,pkgdate -- 包日期
    ,moneyflag -- 钞汇标志
    ,currencycd -- 01或CNY--人民币,13港币,14美元
    ,amount -- 交易金额
    ,chargetype -- 手续费方式
    ,feeamt1 -- 手续费
    ,feeamt2 -- 邮电费
    ,feeamt3 -- 工本费
    ,bookcd -- 凭证类型
    ,booknbr -- 凭证号码
    ,sysid -- 发起方系统号
    ,sndzone -- 发起方地区码
    ,sendbank -- 发起行行号/代理行
    ,payerbank -- 付款行行号
    ,payeraccbank -- 付款人开户行行号
    ,payeracc -- 付款人账号
    ,payername -- 付款人名称
    ,payeraddr -- 付款人地址
    ,rcvzone -- 收收方地区码
    ,payeebank -- 收款行行号
    ,payeeaccbank -- 收款人开户行行号
    ,payeeacc -- 收款人账号
    ,payeename -- 收款人名称
    ,payeeaddr -- 收款人地址
    ,txnid -- 中心受理号
    ,txndate -- 清算日期
    ,txnround -- 清算场次
    ,origsendbank -- 原发起行行号
    ,origtxntype -- 原交易类型细分
    ,origentrustdt -- 原委托日期
    ,origvouchno -- 原凭证提交号
    ,orighostnbr -- 原主机流水号
    ,orighostdate -- 原主机日期
    ,secondtrack -- 第二磁道数据
    ,thirdtrack -- 第三磁道数据
    ,pin -- 个人识别号（PIN）
    ,entrymode -- 服务点输入方式码
    ,cashflag -- 现金/转账标识
    ,privateflag -- 对公/对私标识
    ,authzcd -- 授权码
    ,outmid -- 回应行业务处理号
    ,outtime -- 回应行交易受理时间
    ,cntrno -- 合同(协议)号
    ,linkid -- 连接号
    ,iotype -- 来往标识
    ,status -- 状态
    ,retcd -- 错误代码
    ,msgtext -- 错误信息
    ,remark -- 附言
    ,rcvbrnname -- 接收行行名
    ,media -- 卡/折标识
    ,payerbankname -- 付款行行名
    ,prtnum -- 打印次数
    ,colldate -- 对账日期
    ,identype -- 证件类型
    ,idennbr -- 证件号码
    ,isinout -- 客户帐内部帐标识
    ,inacct -- 实际账号
    ,inname -- 实际户名
    ,transdt -- 交易日期
    ,paymod -- 支付方式
    ,calfee -- 次总金额
    ,fronttrcd -- 中台交易码
    ,rcvbrn -- 接收行行号
    ,errcode -- 行内错误代码
    ,remark2 -- 来帐附言
    ,sendpathfilename -- 发送文件名
    ,eaccflg -- 电子账户标志
    ,od_flag -- 是否发生透支 0- 否 1- 是
    ,od_ovtranam -- 透支金额
    ,opnwin -- 渠道
    ,nextdayflag -- 次日达标识 ：0 次日达
    ,autoflag -- 自动退汇标志 1-自动退汇
    ,autocount -- 自动退汇次数
    ,automsg -- 自动退汇信息
    ,bindacct -- 虚拟账户绑定的账户
    ,bindacctnm -- 虚拟账户绑定的账户名
    ,accttype -- 账户类型 EDME-存管+账户 QSTP-广清所
    ,bindacctopnbrn -- 虚拟账户绑定的账户开户机构
    ,limitorderid -- 限额订单号 用于限额撤销使用
    ,globalseqno -- 全局流水号
    ,transseqno -- 业务流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    unotnbr -- 前置流水号
    ,unotdate -- 前置日期
    ,unottime -- 前置时间机器时间
    ,hostnbr -- 主机流水号为主机记账流水号
    ,hostdate -- 主机日期
    ,magbrn -- 管理机构
    ,oprtlr -- 柜员号
    ,oprbrn -- 机构号
    ,auttlr -- 授权柜员
    ,autbrn -- 授权机构
    ,oprchl -- 通道号
    ,bthdate -- 批次日期
    ,bthseq -- 批次流水号
    ,msgid -- 支付报单号信息序号
    ,origmsgid -- 原交易支付单号
    ,txntype -- 交易类型细分
    ,trantype -- 业务种类
    ,entrustdate -- 委托日期
    ,vouchno -- 凭证提交号
    ,msgno -- 报文编号
    ,pkgno -- 包序号
    ,pkgdate -- 包日期
    ,moneyflag -- 钞汇标志
    ,currencycd -- 01或CNY--人民币,13港币,14美元
    ,amount -- 交易金额
    ,chargetype -- 手续费方式
    ,feeamt1 -- 手续费
    ,feeamt2 -- 邮电费
    ,feeamt3 -- 工本费
    ,bookcd -- 凭证类型
    ,booknbr -- 凭证号码
    ,sysid -- 发起方系统号
    ,sndzone -- 发起方地区码
    ,sendbank -- 发起行行号/代理行
    ,payerbank -- 付款行行号
    ,payeraccbank -- 付款人开户行行号
    ,payeracc -- 付款人账号
    ,payername -- 付款人名称
    ,payeraddr -- 付款人地址
    ,rcvzone -- 收收方地区码
    ,payeebank -- 收款行行号
    ,payeeaccbank -- 收款人开户行行号
    ,payeeacc -- 收款人账号
    ,payeename -- 收款人名称
    ,payeeaddr -- 收款人地址
    ,txnid -- 中心受理号
    ,txndate -- 清算日期
    ,txnround -- 清算场次
    ,origsendbank -- 原发起行行号
    ,origtxntype -- 原交易类型细分
    ,origentrustdt -- 原委托日期
    ,origvouchno -- 原凭证提交号
    ,orighostnbr -- 原主机流水号
    ,orighostdate -- 原主机日期
    ,secondtrack -- 第二磁道数据
    ,thirdtrack -- 第三磁道数据
    ,pin -- 个人识别号（PIN）
    ,entrymode -- 服务点输入方式码
    ,cashflag -- 现金/转账标识
    ,privateflag -- 对公/对私标识
    ,authzcd -- 授权码
    ,outmid -- 回应行业务处理号
    ,outtime -- 回应行交易受理时间
    ,cntrno -- 合同(协议)号
    ,linkid -- 连接号
    ,iotype -- 来往标识
    ,status -- 状态
    ,retcd -- 错误代码
    ,msgtext -- 错误信息
    ,remark -- 附言
    ,rcvbrnname -- 接收行行名
    ,media -- 卡/折标识
    ,payerbankname -- 付款行行名
    ,prtnum -- 打印次数
    ,colldate -- 对账日期
    ,identype -- 证件类型
    ,idennbr -- 证件号码
    ,isinout -- 客户帐内部帐标识
    ,inacct -- 实际账号
    ,inname -- 实际户名
    ,transdt -- 交易日期
    ,paymod -- 支付方式
    ,calfee -- 次总金额
    ,fronttrcd -- 中台交易码
    ,rcvbrn -- 接收行行号
    ,errcode -- 行内错误代码
    ,remark2 -- 来帐附言
    ,sendpathfilename -- 发送文件名
    ,eaccflg -- 电子账户标志
    ,od_flag -- 是否发生透支 0- 否 1- 是
    ,od_ovtranam -- 透支金额
    ,opnwin -- 渠道
    ,nextdayflag -- 次日达标识 ：0 次日达
    ,autoflag -- 自动退汇标志 1-自动退汇
    ,autocount -- 自动退汇次数
    ,automsg -- 自动退汇信息
    ,bindacct -- 虚拟账户绑定的账户
    ,bindacctnm -- 虚拟账户绑定的账户名
    ,accttype -- 账户类型 EDME-存管+账户 QSTP-广清所
    ,bindacctopnbrn -- 虚拟账户绑定的账户开户机构
    ,limitorderid -- 限额订单号 用于限额撤销使用
    ,globalseqno -- 全局流水号
    ,transseqno -- 业务流水号
    ,to_date(unotdate,'yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a49teftrx
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table


-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a49teftrx to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a49teftrx_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a49teftrx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);