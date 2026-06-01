/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a51ubsrvfee
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
drop table ${iol_schema}.mpcs_a51ubsrvfee_ex purge;
alter table ${iol_schema}.mpcs_a51ubsrvfee add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

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
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''mpcs_a51ubsrvfee'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    execute immediate v_sql into v_p_exists;
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iol.mpcs_a51ubsrvfee truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --no exists partitions  
    else 
        v_sql := 'alter table iol.mpcs_a51ubsrvfee add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    end if;
      end loop;
end;
/


-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a51ubsrvfee_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a51ubsrvfee where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a51ubsrvfee(
    trantype -- 文件类型
    ,transdate -- 前置交易日期
    ,acqinstid -- 受理方标识码
    ,fwdinstid -- 发送方标识码
    ,systrace -- 系统跟踪号
    ,transtime -- 交易时间
    ,acptermnlid -- 受理终端标识码
    ,poscode -- POS终端号
    ,procecode -- 处理码
    ,transamt -- 交易金额
    ,hostnbr -- 主机流水
    ,hostdate -- 主机日期
    ,status -- 状态：0 : 失效状态 1 : 交易成功 2 : 已冲正
    ,brnnbr -- 机构号
    ,errcode -- 错误码
    ,errmsg -- 错误信息
    ,merchantcode -- 商户代码
    ,brchbr -- 
    ,busi_seq -- 业务流水号
    ,global_seq -- 全局流水号
    ,old_busi_seq -- 原交易流水号
    ,old_global_seq -- 原全局流水号
    ,old_trn_seq -- 原业务流水号
    ,trn_seq -- 交易流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    trantype -- 文件类型
    ,transdate -- 前置交易日期
    ,acqinstid -- 受理方标识码
    ,fwdinstid -- 发送方标识码
    ,systrace -- 系统跟踪号
    ,transtime -- 交易时间
    ,acptermnlid -- 受理终端标识码
    ,poscode -- POS终端号
    ,procecode -- 处理码
    ,transamt -- 交易金额
    ,hostnbr -- 主机流水
    ,hostdate -- 主机日期
    ,status -- 状态：0 : 失效状态 1 : 交易成功 2 : 已冲正
    ,brnnbr -- 机构号
    ,errcode -- 错误码
    ,errmsg -- 错误信息
    ,merchantcode -- 商户代码
    ,brchbr -- 
    ,busi_seq -- 业务流水号
    ,global_seq -- 全局流水号
    ,old_busi_seq -- 原交易流水号
    ,old_global_seq -- 原全局流水号
    ,old_trn_seq -- 原业务流水号
    ,trn_seq -- 交易流水号
    ,to_date(transdate,'yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a51ubsrvfee
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table


-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a51ubsrvfee to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a51ubsrvfee_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a51ubsrvfee',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);