/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mrms_bth_jj_mcht_sum
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
drop table ${iol_schema}.mrms_bth_jj_mcht_sum_ex purge;
alter table ${iol_schema}.mrms_bth_jj_mcht_sum add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

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
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''mrms_bth_jj_mcht_sum'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    execute immediate v_sql into v_p_exists;
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iol.mrms_bth_jj_mcht_sum truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --no exists partitions  
    else 
        v_sql := 'alter table iol.mrms_bth_jj_mcht_sum add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    end if;
      end loop;
end;
/


-- 2.3 insert data to ex table
create table ${iol_schema}.mrms_bth_jj_mcht_sum_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_bth_jj_mcht_sum where 0=1;

insert /*+ append */ into ${iol_schema}.mrms_bth_jj_mcht_sum(
    inter_brh_code -- 内部分行代码
    ,trandt -- 交易日期
    ,acq_inst_id -- 收单机构代码
    ,seqno -- 序列号
    ,fund_id -- 基金编号
    ,sett_account -- 清算账号
    ,sett_na -- 结算模式
    ,totcnt -- 总笔数
    ,totamt -- 总笔数
    ,succcnt -- 成功笔数
    ,succamt -- 对账成功笔数
    ,failcnt -- 失败笔数
    ,failamt -- 失败笔数
    ,unkncnt -- 未明交易笔数
    ,unknamt -- 未明交易金额
    ,onlnbl -- 代付还款金额
    ,chckamt -- 业务确认金额
    ,chckuser -- 确认人编号
    ,chckstat -- 确认状态 y-已确认  n-未确认  z-无需确认
    ,cbsamt -- 实际划账金额
    ,inneracct -- 清算内部户
    ,inneracna -- 清算内部户户名
    ,acct_flag -- 是否已划账
    ,host_ssn -- 核心流水号
    ,res_desc -- 错误信息
    ,reserve -- 保留区域
    ,reserve1 -- 保留区域
    ,used_amt -- 基金公司已使用额度
    ,fee_amt -- 手续费金额
    ,yl_amt -- 银联成功金额
    ,settlmt_date -- 清算日期
    ,fund_amt -- 基金额度
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    inter_brh_code -- 内部分行代码
    ,trandt -- 交易日期
    ,acq_inst_id -- 收单机构代码
    ,seqno -- 序列号
    ,fund_id -- 基金编号
    ,sett_account -- 清算账号
    ,sett_na -- 结算模式
    ,totcnt -- 总笔数
    ,totamt -- 总笔数
    ,succcnt -- 成功笔数
    ,succamt -- 对账成功笔数
    ,failcnt -- 失败笔数
    ,failamt -- 失败笔数
    ,unkncnt -- 未明交易笔数
    ,unknamt -- 未明交易金额
    ,onlnbl -- 代付还款金额
    ,chckamt -- 业务确认金额
    ,chckuser -- 确认人编号
    ,chckstat -- 确认状态 y-已确认  n-未确认  z-无需确认
    ,cbsamt -- 实际划账金额
    ,inneracct -- 清算内部户
    ,inneracna -- 清算内部户户名
    ,acct_flag -- 是否已划账
    ,host_ssn -- 核心流水号
    ,res_desc -- 错误信息
    ,reserve -- 保留区域
    ,reserve1 -- 保留区域
    ,used_amt -- 基金公司已使用额度
    ,fee_amt -- 手续费金额
    ,yl_amt -- 银联成功金额
    ,settlmt_date -- 清算日期
    ,fund_amt -- 基金额度
    ,to_date(trandt,'yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mrms_bth_jj_mcht_sum
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table


-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mrms_bth_jj_mcht_sum to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mrms_bth_jj_mcht_sum_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mrms_bth_jj_mcht_sum',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);