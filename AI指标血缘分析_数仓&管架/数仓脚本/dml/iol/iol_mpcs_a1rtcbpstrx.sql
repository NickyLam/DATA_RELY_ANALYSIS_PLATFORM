/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1rtcbpstrx
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
drop table ${iol_schema}.mpcs_a1rtcbpstrx_ex purge;
alter table ${iol_schema}.mpcs_a1rtcbpstrx add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

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
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''mpcs_a1rtcbpstrx'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    execute immediate v_sql into v_p_exists;
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iol.mpcs_a1rtcbpstrx truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --no exists partitions  
    else 
        v_sql := 'alter table iol.mpcs_a1rtcbpstrx add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    end if;
      end loop;
end;
/


-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a1rtcbpstrx_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1rtcbpstrx where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a1rtcbpstrx(
    syscd -- 系统码
    ,mainseq -- 中台流水
    ,transdt -- 中台日期
    ,transtm -- 中台时间
    ,pckno -- 报文类型
    ,sndbrn -- 发送行
    ,sndupbrn -- 发送清算行
    ,rcvbrn -- 接收行
    ,rcvupbrn -- 接收清算行
    ,consigndt -- 委托日期
    ,transseq -- 报文标识号
    ,opersq -- 明细标识号
    ,endtoendid -- 端到端标识号
    ,businesstrace -- 行内业务序号
    ,fronttrcd -- 中台交易码
    ,ccynbr -- 币种
    ,transamt -- 交易金额
    ,iotype -- 往来标识
    ,flag3 -- 收费标志
    ,flag4 -- 借贷标记
    ,feeflag -- 手续费标志
    ,feeamt -- 手续费用金额
    ,hosttrcd -- 金融交易码
    ,hostdate -- 金融交易日期
    ,hostnbr -- 金融交易流水
    ,accptncdttm -- 委托时间
    ,paycitycode -- 付款人开户行所属城市代码
    ,payupbrn -- 付款清算行行号
    ,paybrn -- 付款人开户行机构号
    ,payopenbrn -- 付款人开户行行号
    ,payopenbanknm -- 付款人开户行名称
    ,payaccttp -- 付款人账户类型
    ,payacct -- 付款人账号
    ,payname -- 付款人名称
    ,payaddr -- 付款人地址
    ,incocitycode -- 收款人开户行所属城市代码
    ,incoopenbank -- 收款人开户行行号
    ,incoupbrn -- 收款清算行行号
    ,incoopenbanknm -- 收款人开户行名称
    ,incoaccttp -- 收款人账户类型
    ,incoacct -- 收款人账号
    ,inconame -- 收款人名称
    ,incoaddr -- 收款人地址
    ,bustype -- 业务类型
    ,servtype -- 业务种类
    ,oraconsigndt -- 原委托日期
    ,oratransseq -- 原报文标识号
    ,orasndbrn -- 原发起行
    ,orapckno -- 原报文类型
    ,paymod -- 支付方式
    ,paypwd -- 支付密码
    ,idtype -- 证件种类
    ,idno -- 证件号码
    ,bookcode -- 凭证类型
    ,bookdate -- 凭证日期
    ,bookseqno -- 凭证号码
    ,feetype -- 计费种类
    ,realam1 -- 实收费额1
    ,smrycd1 -- 摘要码1
    ,busino1 -- 计费业务编码1
    ,fenm1 -- 计费业务编码名称1
    ,realam2 -- 实收费额2
    ,smrycd2 -- 摘要码2
    ,busino2 -- 计费业务编码2
    ,fenm2 -- 计费业务编码名称2
    ,realam3 -- 实收费额3
    ,smrycd3 -- 摘要码3
    ,busino3 -- 计费业务编码3
    ,fenm3 -- 计费业务编码名称3
    ,transfee -- 异地客户手续费
    ,levels -- 优先级别
    ,oprbrn -- 交易机构
    ,oprtlr -- 交易柜员
    ,info -- 附言
    ,note -- 备注
    ,orgnlreason -- 退汇原因
    ,opnwin -- 交易渠道
    ,appenddatatable -- 登记附加数据的表名
    ,maxtransamt -- 转账限额
    ,errcode -- 行里错误码
    ,errms -- 行里错误信息
    ,rcvdt -- 接收日期
    ,rcvtm -- 接收时间
    ,msgid -- 回执报文标识号
    ,processcode -- 城银清业务状态
    ,netgrnd -- 轧差场次
    ,netgdt -- 轧差日期
    ,rejectcode -- 城银清业务拒绝码
    ,rejectinfo -- 城银清业务拒绝原因
    ,proccd -- 城银清业务处理码
    ,rjbank -- 拒绝业务的参与机构行号
    ,transmitdt -- 转发时间
    ,cleardt -- 清算日期（处理日期、终态日期）
    ,chkprodstatus -- 业务对账状态
    ,chkhoststatus -- 金融对账状态
    ,status -- 交易状态
    ,fill -- 交易结果说明
    ,changtime -- 更新时间
    ,magebrn -- 管理机构
    ,prtcnt -- 打印次数
    ,hangupreason -- 挂账原因代码
    ,hangupmesg -- 挂账原因说明
    ,sacdt -- 挂账日期
    ,sactlr -- 挂账柜员
    ,sacbrn -- 挂账机构号
    ,sacacct -- 挂账账号
    ,sacname -- 挂账户名
    ,crdt -- 维护入账日期
    ,crtlr -- 维护入账柜员
    ,crbrn -- 维护入账机构号
    ,cracct -- 维护入账账号
    ,crname -- 维护入账户名
    ,endtlr -- 冲正柜员
    ,edhostnbr -- 冲正流水
    ,edhostdt -- 冲正日期
    ,isinout -- 账务标识
    ,inacct -- 实际扣帐账号
    ,inname -- 实际扣帐户名
    ,eaccflg -- 电子账户标识
    ,tacctp -- 账户种类
    ,accttp -- 账户类型
    ,acct_typ_id -- 账户类型ID
    ,globalseqno -- 全局流水号
    ,srcsysssn -- 统一支付渠道流水号
    ,od_flag -- 是否发生透支
    ,od_ovtranam -- 透支金额
    ,nextdayflag -- 次日达标识
    ,autoflag -- 自动退汇标志
    ,autocount -- 自动退汇次数
    ,automsg -- 自动退汇信息
    ,limitorderid -- 限额订单号
    ,returncode -- ESB接口返回码
    ,returnmsg -- ESB接口返回信息
    ,transseqno -- ESB接口交易流水号
    ,finaccountid -- 产品账户 （E账户时需要）
    ,memocntt -- 电子账户记账摘要
    ,finmainseq -- 金融表中台流水
    ,fintransdt -- 金融表中台日期
    ,recnt -- 记账/冲正处理次数
    ,msgno -- 通信级标识号
    ,refmsgno -- 通信级参考号
    ,trntype -- 交易种类
    ,exchgflg -- 个人汇兑标识
    ,orisrcsysssn -- 原交易流水
    ,orisyscd -- 原支付通道
    ,rcdstatus -- 往账删除标识
    ,redoflag -- 重发标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    syscd -- 系统码
    ,mainseq -- 中台流水
    ,transdt -- 中台日期
    ,transtm -- 中台时间
    ,pckno -- 报文类型
    ,sndbrn -- 发送行
    ,sndupbrn -- 发送清算行
    ,rcvbrn -- 接收行
    ,rcvupbrn -- 接收清算行
    ,consigndt -- 委托日期
    ,transseq -- 报文标识号
    ,opersq -- 明细标识号
    ,endtoendid -- 端到端标识号
    ,businesstrace -- 行内业务序号
    ,fronttrcd -- 中台交易码
    ,ccynbr -- 币种
    ,transamt -- 交易金额
    ,iotype -- 往来标识
    ,flag3 -- 收费标志
    ,flag4 -- 借贷标记
    ,feeflag -- 手续费标志
    ,feeamt -- 手续费用金额
    ,hosttrcd -- 金融交易码
    ,hostdate -- 金融交易日期
    ,hostnbr -- 金融交易流水
    ,accptncdttm -- 委托时间
    ,paycitycode -- 付款人开户行所属城市代码
    ,payupbrn -- 付款清算行行号
    ,paybrn -- 付款人开户行机构号
    ,payopenbrn -- 付款人开户行行号
    ,payopenbanknm -- 付款人开户行名称
    ,payaccttp -- 付款人账户类型
    ,payacct -- 付款人账号
    ,payname -- 付款人名称
    ,payaddr -- 付款人地址
    ,incocitycode -- 收款人开户行所属城市代码
    ,incoopenbank -- 收款人开户行行号
    ,incoupbrn -- 收款清算行行号
    ,incoopenbanknm -- 收款人开户行名称
    ,incoaccttp -- 收款人账户类型
    ,incoacct -- 收款人账号
    ,inconame -- 收款人名称
    ,incoaddr -- 收款人地址
    ,bustype -- 业务类型
    ,servtype -- 业务种类
    ,oraconsigndt -- 原委托日期
    ,oratransseq -- 原报文标识号
    ,orasndbrn -- 原发起行
    ,orapckno -- 原报文类型
    ,paymod -- 支付方式
    ,paypwd -- 支付密码
    ,idtype -- 证件种类
    ,idno -- 证件号码
    ,bookcode -- 凭证类型
    ,bookdate -- 凭证日期
    ,bookseqno -- 凭证号码
    ,feetype -- 计费种类
    ,realam1 -- 实收费额1
    ,smrycd1 -- 摘要码1
    ,busino1 -- 计费业务编码1
    ,fenm1 -- 计费业务编码名称1
    ,realam2 -- 实收费额2
    ,smrycd2 -- 摘要码2
    ,busino2 -- 计费业务编码2
    ,fenm2 -- 计费业务编码名称2
    ,realam3 -- 实收费额3
    ,smrycd3 -- 摘要码3
    ,busino3 -- 计费业务编码3
    ,fenm3 -- 计费业务编码名称3
    ,transfee -- 异地客户手续费
    ,levels -- 优先级别
    ,oprbrn -- 交易机构
    ,oprtlr -- 交易柜员
    ,info -- 附言
    ,note -- 备注
    ,orgnlreason -- 退汇原因
    ,opnwin -- 交易渠道
    ,appenddatatable -- 登记附加数据的表名
    ,maxtransamt -- 转账限额
    ,errcode -- 行里错误码
    ,errms -- 行里错误信息
    ,rcvdt -- 接收日期
    ,rcvtm -- 接收时间
    ,msgid -- 回执报文标识号
    ,processcode -- 城银清业务状态
    ,netgrnd -- 轧差场次
    ,netgdt -- 轧差日期
    ,rejectcode -- 城银清业务拒绝码
    ,rejectinfo -- 城银清业务拒绝原因
    ,proccd -- 城银清业务处理码
    ,rjbank -- 拒绝业务的参与机构行号
    ,transmitdt -- 转发时间
    ,cleardt -- 清算日期（处理日期、终态日期）
    ,chkprodstatus -- 业务对账状态
    ,chkhoststatus -- 金融对账状态
    ,status -- 交易状态
    ,fill -- 交易结果说明
    ,changtime -- 更新时间
    ,magebrn -- 管理机构
    ,prtcnt -- 打印次数
    ,hangupreason -- 挂账原因代码
    ,hangupmesg -- 挂账原因说明
    ,sacdt -- 挂账日期
    ,sactlr -- 挂账柜员
    ,sacbrn -- 挂账机构号
    ,sacacct -- 挂账账号
    ,sacname -- 挂账户名
    ,crdt -- 维护入账日期
    ,crtlr -- 维护入账柜员
    ,crbrn -- 维护入账机构号
    ,cracct -- 维护入账账号
    ,crname -- 维护入账户名
    ,endtlr -- 冲正柜员
    ,edhostnbr -- 冲正流水
    ,edhostdt -- 冲正日期
    ,isinout -- 账务标识
    ,inacct -- 实际扣帐账号
    ,inname -- 实际扣帐户名
    ,eaccflg -- 电子账户标识
    ,tacctp -- 账户种类
    ,accttp -- 账户类型
    ,acct_typ_id -- 账户类型ID
    ,globalseqno -- 全局流水号
    ,srcsysssn -- 统一支付渠道流水号
    ,od_flag -- 是否发生透支
    ,od_ovtranam -- 透支金额
    ,nextdayflag -- 次日达标识
    ,autoflag -- 自动退汇标志
    ,autocount -- 自动退汇次数
    ,automsg -- 自动退汇信息
    ,limitorderid -- 限额订单号
    ,returncode -- ESB接口返回码
    ,returnmsg -- ESB接口返回信息
    ,transseqno -- ESB接口交易流水号
    ,finaccountid -- 产品账户 （E账户时需要）
    ,memocntt -- 电子账户记账摘要
    ,finmainseq -- 金融表中台流水
    ,fintransdt -- 金融表中台日期
    ,recnt -- 记账/冲正处理次数
    ,msgno -- 通信级标识号
    ,refmsgno -- 通信级参考号
    ,trntype -- 交易种类
    ,exchgflg -- 个人汇兑标识
    ,orisrcsysssn -- 原交易流水
    ,orisyscd -- 原支付通道
    ,rcdstatus -- 往账删除标识
    ,redoflag -- 重发标志
    ,to_date(transdt,'yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a1rtcbpstrx
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table


-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1rtcbpstrx to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a1rtcbpstrx_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1rtcbpstrx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);