/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_xft_clear_batch
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.amss_xft_clear_batch_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_xft_clear_batch
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_xft_clear_batch_op purge;
drop table ${iol_schema}.amss_xft_clear_batch_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_xft_clear_batch_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_xft_clear_batch where 0=1;

create table ${iol_schema}.amss_xft_clear_batch_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_xft_clear_batch where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_xft_clear_batch_cl(
            xft_batch_no -- 批次流水号（主键）
            ,file_name -- 文件名称
            ,clear_time -- 清分时间
            ,merch_num -- 商户编号
            ,merch_name -- 商户名称
            ,total_cnt -- 总笔数
            ,txn_total_amt -- 交易总金额
            ,succ_cnt -- 成功笔数
            ,succ_amt -- 成功金额
            ,fail_cnt -- 失败笔数
            ,fail_amt -- 失败金额
            ,bth_status -- 批次状态
            ,bth_status_msg -- 批次状态信息
            ,chn_bat_seq_num -- 清分请求批次流水号
            ,return_query_serial_no -- 回盘查询流水号
            ,ledger_file_name -- 
            ,valid_flag -- 有效标识（0-作废，1-正常）
            ,create_emp -- 创建者
            ,create_time -- 创建时间（YYYY-MM-DD HH24:MI:SS.FF6）
            ,update_emp -- 更新者
            ,update_time -- 更新时间（YYYY-MM-DD HH24:MI:SS.FF6）
            ,clear_type -- 1-自动清分 2-补清分 3-文件清分
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_xft_clear_batch_op(
            xft_batch_no -- 批次流水号（主键）
            ,file_name -- 文件名称
            ,clear_time -- 清分时间
            ,merch_num -- 商户编号
            ,merch_name -- 商户名称
            ,total_cnt -- 总笔数
            ,txn_total_amt -- 交易总金额
            ,succ_cnt -- 成功笔数
            ,succ_amt -- 成功金额
            ,fail_cnt -- 失败笔数
            ,fail_amt -- 失败金额
            ,bth_status -- 批次状态
            ,bth_status_msg -- 批次状态信息
            ,chn_bat_seq_num -- 清分请求批次流水号
            ,return_query_serial_no -- 回盘查询流水号
            ,ledger_file_name -- 
            ,valid_flag -- 有效标识（0-作废，1-正常）
            ,create_emp -- 创建者
            ,create_time -- 创建时间（YYYY-MM-DD HH24:MI:SS.FF6）
            ,update_emp -- 更新者
            ,update_time -- 更新时间（YYYY-MM-DD HH24:MI:SS.FF6）
            ,clear_type -- 1-自动清分 2-补清分 3-文件清分
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.xft_batch_no, o.xft_batch_no) as xft_batch_no -- 批次流水号（主键）
    ,nvl(n.file_name, o.file_name) as file_name -- 文件名称
    ,nvl(n.clear_time, o.clear_time) as clear_time -- 清分时间
    ,nvl(n.merch_num, o.merch_num) as merch_num -- 商户编号
    ,nvl(n.merch_name, o.merch_name) as merch_name -- 商户名称
    ,nvl(n.total_cnt, o.total_cnt) as total_cnt -- 总笔数
    ,nvl(n.txn_total_amt, o.txn_total_amt) as txn_total_amt -- 交易总金额
    ,nvl(n.succ_cnt, o.succ_cnt) as succ_cnt -- 成功笔数
    ,nvl(n.succ_amt, o.succ_amt) as succ_amt -- 成功金额
    ,nvl(n.fail_cnt, o.fail_cnt) as fail_cnt -- 失败笔数
    ,nvl(n.fail_amt, o.fail_amt) as fail_amt -- 失败金额
    ,nvl(n.bth_status, o.bth_status) as bth_status -- 批次状态
    ,nvl(n.bth_status_msg, o.bth_status_msg) as bth_status_msg -- 批次状态信息
    ,nvl(n.chn_bat_seq_num, o.chn_bat_seq_num) as chn_bat_seq_num -- 清分请求批次流水号
    ,nvl(n.return_query_serial_no, o.return_query_serial_no) as return_query_serial_no -- 回盘查询流水号
    ,nvl(n.ledger_file_name, o.ledger_file_name) as ledger_file_name -- 
    ,nvl(n.valid_flag, o.valid_flag) as valid_flag -- 有效标识（0-作废，1-正常）
    ,nvl(n.create_emp, o.create_emp) as create_emp -- 创建者
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间（YYYY-MM-DD HH24:MI:SS.FF6）
    ,nvl(n.update_emp, o.update_emp) as update_emp -- 更新者
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间（YYYY-MM-DD HH24:MI:SS.FF6）
    ,nvl(n.clear_type, o.clear_type) as clear_type -- 1-自动清分 2-补清分 3-文件清分
    ,case when
            n.xft_batch_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.xft_batch_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.xft_batch_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amss_xft_clear_batch_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_xft_clear_batch where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.xft_batch_no = n.xft_batch_no
where (
        o.xft_batch_no is null
    )
    or (
        n.xft_batch_no is null
    )
    or (
        o.file_name <> n.file_name
        or o.clear_time <> n.clear_time
        or o.merch_num <> n.merch_num
        or o.merch_name <> n.merch_name
        or o.total_cnt <> n.total_cnt
        or o.txn_total_amt <> n.txn_total_amt
        or o.succ_cnt <> n.succ_cnt
        or o.succ_amt <> n.succ_amt
        or o.fail_cnt <> n.fail_cnt
        or o.fail_amt <> n.fail_amt
        or o.bth_status <> n.bth_status
        or o.bth_status_msg <> n.bth_status_msg
        or o.chn_bat_seq_num <> n.chn_bat_seq_num
        or o.return_query_serial_no <> n.return_query_serial_no
        or o.ledger_file_name <> n.ledger_file_name
        or o.valid_flag <> n.valid_flag
        or o.create_emp <> n.create_emp
        or o.create_time <> n.create_time
        or o.update_emp <> n.update_emp
        or o.update_time <> n.update_time
        or o.clear_type <> n.clear_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_xft_clear_batch_cl(
            xft_batch_no -- 批次流水号（主键）
            ,file_name -- 文件名称
            ,clear_time -- 清分时间
            ,merch_num -- 商户编号
            ,merch_name -- 商户名称
            ,total_cnt -- 总笔数
            ,txn_total_amt -- 交易总金额
            ,succ_cnt -- 成功笔数
            ,succ_amt -- 成功金额
            ,fail_cnt -- 失败笔数
            ,fail_amt -- 失败金额
            ,bth_status -- 批次状态
            ,bth_status_msg -- 批次状态信息
            ,chn_bat_seq_num -- 清分请求批次流水号
            ,return_query_serial_no -- 回盘查询流水号
            ,ledger_file_name -- 
            ,valid_flag -- 有效标识（0-作废，1-正常）
            ,create_emp -- 创建者
            ,create_time -- 创建时间（YYYY-MM-DD HH24:MI:SS.FF6）
            ,update_emp -- 更新者
            ,update_time -- 更新时间（YYYY-MM-DD HH24:MI:SS.FF6）
            ,clear_type -- 1-自动清分 2-补清分 3-文件清分
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_xft_clear_batch_op(
            xft_batch_no -- 批次流水号（主键）
            ,file_name -- 文件名称
            ,clear_time -- 清分时间
            ,merch_num -- 商户编号
            ,merch_name -- 商户名称
            ,total_cnt -- 总笔数
            ,txn_total_amt -- 交易总金额
            ,succ_cnt -- 成功笔数
            ,succ_amt -- 成功金额
            ,fail_cnt -- 失败笔数
            ,fail_amt -- 失败金额
            ,bth_status -- 批次状态
            ,bth_status_msg -- 批次状态信息
            ,chn_bat_seq_num -- 清分请求批次流水号
            ,return_query_serial_no -- 回盘查询流水号
            ,ledger_file_name -- 
            ,valid_flag -- 有效标识（0-作废，1-正常）
            ,create_emp -- 创建者
            ,create_time -- 创建时间（YYYY-MM-DD HH24:MI:SS.FF6）
            ,update_emp -- 更新者
            ,update_time -- 更新时间（YYYY-MM-DD HH24:MI:SS.FF6）
            ,clear_type -- 1-自动清分 2-补清分 3-文件清分
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.xft_batch_no -- 批次流水号（主键）
    ,o.file_name -- 文件名称
    ,o.clear_time -- 清分时间
    ,o.merch_num -- 商户编号
    ,o.merch_name -- 商户名称
    ,o.total_cnt -- 总笔数
    ,o.txn_total_amt -- 交易总金额
    ,o.succ_cnt -- 成功笔数
    ,o.succ_amt -- 成功金额
    ,o.fail_cnt -- 失败笔数
    ,o.fail_amt -- 失败金额
    ,o.bth_status -- 批次状态
    ,o.bth_status_msg -- 批次状态信息
    ,o.chn_bat_seq_num -- 清分请求批次流水号
    ,o.return_query_serial_no -- 回盘查询流水号
    ,o.ledger_file_name -- 
    ,o.valid_flag -- 有效标识（0-作废，1-正常）
    ,o.create_emp -- 创建者
    ,o.create_time -- 创建时间（YYYY-MM-DD HH24:MI:SS.FF6）
    ,o.update_emp -- 更新者
    ,o.update_time -- 更新时间（YYYY-MM-DD HH24:MI:SS.FF6）
    ,o.clear_type -- 1-自动清分 2-补清分 3-文件清分
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.amss_xft_clear_batch_bk o
    left join ${iol_schema}.amss_xft_clear_batch_op n
        on
            o.xft_batch_no = n.xft_batch_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_xft_clear_batch_cl d
        on
            o.xft_batch_no = d.xft_batch_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amss_xft_clear_batch;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_xft_clear_batch') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_xft_clear_batch drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_xft_clear_batch add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_xft_clear_batch exchange partition p_${batch_date} with table ${iol_schema}.amss_xft_clear_batch_cl;
alter table ${iol_schema}.amss_xft_clear_batch exchange partition p_20991231 with table ${iol_schema}.amss_xft_clear_batch_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_xft_clear_batch to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_xft_clear_batch_op purge;
drop table ${iol_schema}.amss_xft_clear_batch_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_xft_clear_batch_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_xft_clear_batch',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
