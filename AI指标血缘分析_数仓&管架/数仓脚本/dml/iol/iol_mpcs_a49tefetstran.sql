/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a49tefetstran
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
drop table ${iol_schema}.mpcs_a49tefetstran_ex purge;
alter table ${iol_schema}.mpcs_a49tefetstran add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

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
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''mpcs_a49tefetstran'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    execute immediate v_sql into v_p_exists;
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iol.mpcs_a49tefetstran truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --no exists partitions  
    else 
        v_sql := 'alter table iol.mpcs_a49tefetstran add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    end if;
      end loop;
end;
/


-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a49tefetstran_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a49tefetstran where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a49tefetstran(
    trandt -- 交易日期
    ,transq -- 交易流水号
    ,trantm -- 交易时间
    ,txntype -- 交易类型细分
    ,iotype -- 往来标志
    ,transt -- 交易状态
    ,magbrn -- 管理机构
    ,colldate -- 对账日期
    ,hostdt -- 主机日期
    ,hostsq -- 主机流水号
    ,colldt -- 冲正日期
    ,collsq -- 冲正流水
    ,msgcode -- 响应码
    ,msgtext -- 响应描述
    ,sysid -- 发起方系统号
    ,sndzone -- 发起地区代码
    ,rcvzone -- 接收地区代码
    ,msgno -- 报文编号
    ,msgid -- 信息序号
    ,origmsgid -- 原信息序号
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
    ,acctbr -- 付款人账号开户机构
    ,payeebank -- 收款行行号
    ,payeeaccbank -- 收款人开户行行号
    ,payeeacc -- 收款人账号
    ,payeename -- 收款人名称
    ,oprchl -- 业务渠道
    ,mainbr -- 经收处银行号
    ,bankdt -- 银行提交日期
    ,tranid -- 交易识别号
    ,txbrch -- 机关类别
    ,origcd -- 征收机关代码
    ,origdt -- 征收机关提交日期
    ,origsq -- 征收机关流水号
    ,fisccd -- 收款国库代码
    ,oprtype -- 交易类型
    ,torigdt -- 征收机关提交日期
    ,torigsq -- 征收机关流水号
    ,txpycd -- 纳税人编码
    ,txpyna -- 纳税人名称
    ,declacd -- 申报方式代码
    ,declasq -- 申报流水号
    ,payecd -- 缴款方式代码
    ,logadt -- ETS资金对数日期
    ,logact -- ETS资金对数场次
    ,txnid -- 中心受理号
    ,txndate -- 清算日期
    ,txnround -- 清算场次
    ,outmid -- 回应方业务处理号
    ,outtime -- 回应行交易受理时间
    ,retcd -- 返回码
    ,remark -- 附言
    ,brchno -- 营业点
    ,userid -- 柜员号
    ,ckbkus -- 授权柜员
    ,ckbkbr -- 授权网点
    ,linkid -- 链路ID
    ,prtcnt -- 打印次数
    ,bustype -- 业务类型
    ,cpnytp -- 企业注册类型代码
    ,dtlrmk -- 明细备注
    ,dtllng -- 明细长度
    ,bugdltlr -- 异常处理柜员
    ,bugdlmk -- 异常处理附言
    ,bugdltp -- 异常处理方式
    ,bugdlsq -- 退款处理流水（记账流水）
    ,bugdldt -- 退款处理日期（记账日期）
    ,bugauth -- 异常处理授权柜员
    ,bugbrc -- 异常处理机构
    ,bugacctno -- 退款账号
    ,bugacctna -- 退款户名
    ,bugaccttms -- 退款异常记账次数
    ,payertel -- 缴款人电话
    ,idtftp -- 缴款人证件类型
    ,idtfno -- 缴款人证件号码
    ,bookcd -- 凭证类型
    ,bookno -- 凭证号码
    ,bookoutdt -- 出票日期
    ,trnchl -- 交易渠道
    ,srcsysid -- 源渠道码
    ,retmsg -- 中心返回信息
    ,chnlsq -- 渠道流水号
    ,transeqno -- 业务流水号
    ,globalseqno -- 全局流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    trandt -- 交易日期
    ,transq -- 交易流水号
    ,trantm -- 交易时间
    ,txntype -- 交易类型细分
    ,iotype -- 往来标志
    ,transt -- 交易状态
    ,magbrn -- 管理机构
    ,colldate -- 对账日期
    ,hostdt -- 主机日期
    ,hostsq -- 主机流水号
    ,colldt -- 冲正日期
    ,collsq -- 冲正流水
    ,msgcode -- 响应码
    ,msgtext -- 响应描述
    ,sysid -- 发起方系统号
    ,sndzone -- 发起地区代码
    ,rcvzone -- 接收地区代码
    ,msgno -- 报文编号
    ,msgid -- 信息序号
    ,origmsgid -- 原信息序号
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
    ,acctbr -- 付款人账号开户机构
    ,payeebank -- 收款行行号
    ,payeeaccbank -- 收款人开户行行号
    ,payeeacc -- 收款人账号
    ,payeename -- 收款人名称
    ,oprchl -- 业务渠道
    ,mainbr -- 经收处银行号
    ,bankdt -- 银行提交日期
    ,tranid -- 交易识别号
    ,txbrch -- 机关类别
    ,origcd -- 征收机关代码
    ,origdt -- 征收机关提交日期
    ,origsq -- 征收机关流水号
    ,fisccd -- 收款国库代码
    ,oprtype -- 交易类型
    ,torigdt -- 征收机关提交日期
    ,torigsq -- 征收机关流水号
    ,txpycd -- 纳税人编码
    ,txpyna -- 纳税人名称
    ,declacd -- 申报方式代码
    ,declasq -- 申报流水号
    ,payecd -- 缴款方式代码
    ,logadt -- ETS资金对数日期
    ,logact -- ETS资金对数场次
    ,txnid -- 中心受理号
    ,txndate -- 清算日期
    ,txnround -- 清算场次
    ,outmid -- 回应方业务处理号
    ,outtime -- 回应行交易受理时间
    ,retcd -- 返回码
    ,remark -- 附言
    ,brchno -- 营业点
    ,userid -- 柜员号
    ,ckbkus -- 授权柜员
    ,ckbkbr -- 授权网点
    ,linkid -- 链路ID
    ,prtcnt -- 打印次数
    ,bustype -- 业务类型
    ,cpnytp -- 企业注册类型代码
    ,dtlrmk -- 明细备注
    ,dtllng -- 明细长度
    ,bugdltlr -- 异常处理柜员
    ,bugdlmk -- 异常处理附言
    ,bugdltp -- 异常处理方式
    ,bugdlsq -- 退款处理流水（记账流水）
    ,bugdldt -- 退款处理日期（记账日期）
    ,bugauth -- 异常处理授权柜员
    ,bugbrc -- 异常处理机构
    ,bugacctno -- 退款账号
    ,bugacctna -- 退款户名
    ,bugaccttms -- 退款异常记账次数
    ,payertel -- 缴款人电话
    ,idtftp -- 缴款人证件类型
    ,idtfno -- 缴款人证件号码
    ,bookcd -- 凭证类型
    ,bookno -- 凭证号码
    ,bookoutdt -- 出票日期
    ,trnchl -- 交易渠道
    ,srcsysid -- 源渠道码
    ,retmsg -- 中心返回信息
    ,chnlsq -- 渠道流水号
    ,transeqno -- 业务流水号
    ,globalseqno -- 全局流水号
    ,to_date(trandt,'yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a49tefetstran
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table


-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a49tefetstran to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a49tefetstran_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a49tefetstran',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);