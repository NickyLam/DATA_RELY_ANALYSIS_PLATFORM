/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbps_cpr_ecomplex_batch_flow
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
create table ${iol_schema}.tbps_cpr_ecomplex_batch_flow_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tbps_cpr_ecomplex_batch_flow
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_ecomplex_batch_flow_op purge;
drop table ${iol_schema}.tbps_cpr_ecomplex_batch_flow_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_ecomplex_batch_flow_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_ecomplex_batch_flow where 0=1;

create table ${iol_schema}.tbps_cpr_ecomplex_batch_flow_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_ecomplex_batch_flow where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_ecomplex_batch_flow_cl(
            ebf_batchno -- 批次号
            ,ebf_batchdate -- 提交日期
            ,ebf_upload_flowno -- 文件上传流水号
            ,ebf_flowno -- 提交交易流水号
            ,ebf_ecifno -- 客户号
            ,ebf_userno -- 用户序号
            ,ebf_accno -- 账户序号
            ,ebf_showflag -- 显示明细标识
            ,ebf_totalcount -- 总笔数
            ,ebf_totalamount -- 总金额
            ,ebf_transdate -- 交易日期
            ,ebf_transtime -- 交易时间
            ,ebf_filename -- 文件名
            ,ebf_checkcount -- 检查条数
            ,ebf_checkerrorcount -- 错误条数
            ,ebf_checkstatus -- 校验状态（0-校验成功，1-校验失败，2-校验中）
            ,ebf_batchstate -- 批次状态
            ,ebf_operater -- 操作类型:1-退税
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_ecomplex_batch_flow_op(
            ebf_batchno -- 批次号
            ,ebf_batchdate -- 提交日期
            ,ebf_upload_flowno -- 文件上传流水号
            ,ebf_flowno -- 提交交易流水号
            ,ebf_ecifno -- 客户号
            ,ebf_userno -- 用户序号
            ,ebf_accno -- 账户序号
            ,ebf_showflag -- 显示明细标识
            ,ebf_totalcount -- 总笔数
            ,ebf_totalamount -- 总金额
            ,ebf_transdate -- 交易日期
            ,ebf_transtime -- 交易时间
            ,ebf_filename -- 文件名
            ,ebf_checkcount -- 检查条数
            ,ebf_checkerrorcount -- 错误条数
            ,ebf_checkstatus -- 校验状态（0-校验成功，1-校验失败，2-校验中）
            ,ebf_batchstate -- 批次状态
            ,ebf_operater -- 操作类型:1-退税
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ebf_batchno, o.ebf_batchno) as ebf_batchno -- 批次号
    ,nvl(n.ebf_batchdate, o.ebf_batchdate) as ebf_batchdate -- 提交日期
    ,nvl(n.ebf_upload_flowno, o.ebf_upload_flowno) as ebf_upload_flowno -- 文件上传流水号
    ,nvl(n.ebf_flowno, o.ebf_flowno) as ebf_flowno -- 提交交易流水号
    ,nvl(n.ebf_ecifno, o.ebf_ecifno) as ebf_ecifno -- 客户号
    ,nvl(n.ebf_userno, o.ebf_userno) as ebf_userno -- 用户序号
    ,nvl(n.ebf_accno, o.ebf_accno) as ebf_accno -- 账户序号
    ,nvl(n.ebf_showflag, o.ebf_showflag) as ebf_showflag -- 显示明细标识
    ,nvl(n.ebf_totalcount, o.ebf_totalcount) as ebf_totalcount -- 总笔数
    ,nvl(n.ebf_totalamount, o.ebf_totalamount) as ebf_totalamount -- 总金额
    ,nvl(n.ebf_transdate, o.ebf_transdate) as ebf_transdate -- 交易日期
    ,nvl(n.ebf_transtime, o.ebf_transtime) as ebf_transtime -- 交易时间
    ,nvl(n.ebf_filename, o.ebf_filename) as ebf_filename -- 文件名
    ,nvl(n.ebf_checkcount, o.ebf_checkcount) as ebf_checkcount -- 检查条数
    ,nvl(n.ebf_checkerrorcount, o.ebf_checkerrorcount) as ebf_checkerrorcount -- 错误条数
    ,nvl(n.ebf_checkstatus, o.ebf_checkstatus) as ebf_checkstatus -- 校验状态（0-校验成功，1-校验失败，2-校验中）
    ,nvl(n.ebf_batchstate, o.ebf_batchstate) as ebf_batchstate -- 批次状态
    ,nvl(n.ebf_operater, o.ebf_operater) as ebf_operater -- 操作类型:1-退税
    ,case when
            n.ebf_batchno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ebf_batchno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ebf_batchno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tbps_cpr_ecomplex_batch_flow_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tbps_cpr_ecomplex_batch_flow where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ebf_batchno = n.ebf_batchno
where (
        o.ebf_batchno is null
    )
    or (
        n.ebf_batchno is null
    )
    or (
        o.ebf_batchdate <> n.ebf_batchdate
        or o.ebf_upload_flowno <> n.ebf_upload_flowno
        or o.ebf_flowno <> n.ebf_flowno
        or o.ebf_ecifno <> n.ebf_ecifno
        or o.ebf_userno <> n.ebf_userno
        or o.ebf_accno <> n.ebf_accno
        or o.ebf_showflag <> n.ebf_showflag
        or o.ebf_totalcount <> n.ebf_totalcount
        or o.ebf_totalamount <> n.ebf_totalamount
        or o.ebf_transdate <> n.ebf_transdate
        or o.ebf_transtime <> n.ebf_transtime
        or o.ebf_filename <> n.ebf_filename
        or o.ebf_checkcount <> n.ebf_checkcount
        or o.ebf_checkerrorcount <> n.ebf_checkerrorcount
        or o.ebf_checkstatus <> n.ebf_checkstatus
        or o.ebf_batchstate <> n.ebf_batchstate
        or o.ebf_operater <> n.ebf_operater
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_ecomplex_batch_flow_cl(
            ebf_batchno -- 批次号
            ,ebf_batchdate -- 提交日期
            ,ebf_upload_flowno -- 文件上传流水号
            ,ebf_flowno -- 提交交易流水号
            ,ebf_ecifno -- 客户号
            ,ebf_userno -- 用户序号
            ,ebf_accno -- 账户序号
            ,ebf_showflag -- 显示明细标识
            ,ebf_totalcount -- 总笔数
            ,ebf_totalamount -- 总金额
            ,ebf_transdate -- 交易日期
            ,ebf_transtime -- 交易时间
            ,ebf_filename -- 文件名
            ,ebf_checkcount -- 检查条数
            ,ebf_checkerrorcount -- 错误条数
            ,ebf_checkstatus -- 校验状态（0-校验成功，1-校验失败，2-校验中）
            ,ebf_batchstate -- 批次状态
            ,ebf_operater -- 操作类型:1-退税
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_ecomplex_batch_flow_op(
            ebf_batchno -- 批次号
            ,ebf_batchdate -- 提交日期
            ,ebf_upload_flowno -- 文件上传流水号
            ,ebf_flowno -- 提交交易流水号
            ,ebf_ecifno -- 客户号
            ,ebf_userno -- 用户序号
            ,ebf_accno -- 账户序号
            ,ebf_showflag -- 显示明细标识
            ,ebf_totalcount -- 总笔数
            ,ebf_totalamount -- 总金额
            ,ebf_transdate -- 交易日期
            ,ebf_transtime -- 交易时间
            ,ebf_filename -- 文件名
            ,ebf_checkcount -- 检查条数
            ,ebf_checkerrorcount -- 错误条数
            ,ebf_checkstatus -- 校验状态（0-校验成功，1-校验失败，2-校验中）
            ,ebf_batchstate -- 批次状态
            ,ebf_operater -- 操作类型:1-退税
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ebf_batchno -- 批次号
    ,o.ebf_batchdate -- 提交日期
    ,o.ebf_upload_flowno -- 文件上传流水号
    ,o.ebf_flowno -- 提交交易流水号
    ,o.ebf_ecifno -- 客户号
    ,o.ebf_userno -- 用户序号
    ,o.ebf_accno -- 账户序号
    ,o.ebf_showflag -- 显示明细标识
    ,o.ebf_totalcount -- 总笔数
    ,o.ebf_totalamount -- 总金额
    ,o.ebf_transdate -- 交易日期
    ,o.ebf_transtime -- 交易时间
    ,o.ebf_filename -- 文件名
    ,o.ebf_checkcount -- 检查条数
    ,o.ebf_checkerrorcount -- 错误条数
    ,o.ebf_checkstatus -- 校验状态（0-校验成功，1-校验失败，2-校验中）
    ,o.ebf_batchstate -- 批次状态
    ,o.ebf_operater -- 操作类型:1-退税
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
from ${iol_schema}.tbps_cpr_ecomplex_batch_flow_bk o
    left join ${iol_schema}.tbps_cpr_ecomplex_batch_flow_op n
        on
            o.ebf_batchno = n.ebf_batchno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tbps_cpr_ecomplex_batch_flow_cl d
        on
            o.ebf_batchno = d.ebf_batchno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tbps_cpr_ecomplex_batch_flow;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tbps_cpr_ecomplex_batch_flow') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tbps_cpr_ecomplex_batch_flow drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tbps_cpr_ecomplex_batch_flow add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tbps_cpr_ecomplex_batch_flow exchange partition p_${batch_date} with table ${iol_schema}.tbps_cpr_ecomplex_batch_flow_cl;
alter table ${iol_schema}.tbps_cpr_ecomplex_batch_flow exchange partition p_20991231 with table ${iol_schema}.tbps_cpr_ecomplex_batch_flow_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbps_cpr_ecomplex_batch_flow to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_ecomplex_batch_flow_op purge;
drop table ${iol_schema}.tbps_cpr_ecomplex_batch_flow_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tbps_cpr_ecomplex_batch_flow_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbps_cpr_ecomplex_batch_flow',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
