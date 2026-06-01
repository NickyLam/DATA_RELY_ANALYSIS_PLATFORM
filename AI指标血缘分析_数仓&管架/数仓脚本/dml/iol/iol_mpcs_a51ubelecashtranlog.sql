/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a51ubelecashtranlog
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
drop table ${iol_schema}.mpcs_a51ubelecashtranlog_ex purge;
alter table ${iol_schema}.mpcs_a51ubelecashtranlog add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

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
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''mpcs_a51ubelecashtranlog'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    execute immediate v_sql into v_p_exists;
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iol.mpcs_a51ubelecashtranlog truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --no exists partitions  
    else 
        v_sql := 'alter table iol.mpcs_a51ubelecashtranlog add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    end if;
      end loop;
end;
/


-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a51ubelecashtranlog_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a51ubelecashtranlog where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a51ubelecashtranlog(
    filedate -- 文件日期
    ,gatetype -- 
    ,fwdinstid -- 发送机构号
    ,systrace -- 系统跟踪号
    ,acqinstid -- 受理机构号
    ,transtime -- 交易传输时间
    ,settlmtdate -- 清算日期
    ,trandate -- 交易日期
    ,priacct -- 卡号
    ,cardsq -- 卡序号
    ,trantp -- 
    ,crcycd -- 
    ,tranam -- 
    ,provstatus -- 
    ,merctp -- 
    ,termid -- 终端号
    ,mercid -- 商户号
    ,mercad -- 
    ,trcert -- 
    ,trauam -- 
    ,trotam -- 
    ,trcoun -- 
    ,trcrcy -- 
    ,trdate -- 
    ,trtype -- 
    ,trrand -- 
    ,trapip -- 
    ,traptc -- 
    ,trresp -- 
    ,idprest -- 
    ,isdata -- 
    ,oldtrantp -- 
    ,oldsystrace -- 
    ,oldsettlmtdate -- 
    ,oldtranstime -- 
    ,feeamt -- 手续费
    ,cardholdrate -- 
    ,cardholdamt -- 
    ,cardholdcy -- 
    ,settlmtamt -- 清算金额
    ,settlmtcy -- 
    ,ratefeeamt -- 
    ,openbrn -- 
    ,hostdate -- 主机交易日期
    ,hostnbr -- 主机交易流水
    ,dataid -- 
    ,errcode -- 错误代码
    ,errmsg -- 错误信息
    ,qsstatus -- 清算状态
    ,opstatus -- 
    ,retrflg -- 
    ,magacct -- 
    ,tranexamt -- 本方交换费
    ,covamt -- 转接清算费
    ,remark1 -- 保留
    ,remark2 -- 保留
    ,old_busi_seq -- 原交易流水号
    ,old_global_seq -- 原全局流水号
    ,old_trn_seq -- 原业务流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    filedate -- 文件日期
    ,gatetype -- 
    ,fwdinstid -- 发送机构号
    ,systrace -- 系统跟踪号
    ,acqinstid -- 受理机构号
    ,transtime -- 交易传输时间
    ,settlmtdate -- 清算日期
    ,trandate -- 交易日期
    ,priacct -- 卡号
    ,cardsq -- 卡序号
    ,trantp -- 
    ,crcycd -- 
    ,tranam -- 
    ,provstatus -- 
    ,merctp -- 
    ,termid -- 终端号
    ,mercid -- 商户号
    ,mercad -- 
    ,trcert -- 
    ,trauam -- 
    ,trotam -- 
    ,trcoun -- 
    ,trcrcy -- 
    ,trdate -- 
    ,trtype -- 
    ,trrand -- 
    ,trapip -- 
    ,traptc -- 
    ,trresp -- 
    ,idprest -- 
    ,isdata -- 
    ,oldtrantp -- 
    ,oldsystrace -- 
    ,oldsettlmtdate -- 
    ,oldtranstime -- 
    ,feeamt -- 手续费
    ,cardholdrate -- 
    ,cardholdamt -- 
    ,cardholdcy -- 
    ,settlmtamt -- 清算金额
    ,settlmtcy -- 
    ,ratefeeamt -- 
    ,openbrn -- 
    ,hostdate -- 主机交易日期
    ,hostnbr -- 主机交易流水
    ,dataid -- 
    ,errcode -- 错误代码
    ,errmsg -- 错误信息
    ,qsstatus -- 清算状态
    ,opstatus -- 
    ,retrflg -- 
    ,magacct -- 
    ,tranexamt -- 本方交换费
    ,covamt -- 转接清算费
    ,remark1 -- 保留
    ,remark2 -- 保留
    ,old_busi_seq -- 原交易流水号
    ,old_global_seq -- 原全局流水号
    ,old_trn_seq -- 原业务流水号
    ,to_date(trandate,'yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a51ubelecashtranlog
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table


-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a51ubelecashtranlog to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a51ubelecashtranlog_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a51ubelecashtranlog',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);