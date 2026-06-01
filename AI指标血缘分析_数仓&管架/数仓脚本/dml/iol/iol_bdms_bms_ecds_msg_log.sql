/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_ecds_msg_log
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
create table ${iol_schema}.bdms_bms_ecds_msg_log_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_bms_ecds_msg_log
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_ecds_msg_log_op purge;
drop table ${iol_schema}.bdms_bms_ecds_msg_log_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_ecds_msg_log_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_ecds_msg_log where 0=1;

create table ${iol_schema}.bdms_bms_ecds_msg_log_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_ecds_msg_log where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_ecds_msg_log_cl(
            id -- 主键ID
            ,cre_dt -- 报文日期
            ,cre_tm -- 报文时间
            ,idnb -- 电子票据号码
            ,deal_mk -- 是否处理成功： 0 报文处理失败 1 报文处理成功 2 报文处理中
            ,draft_content -- 报文内容
            ,sendorrecv_mk -- 是否发送/接收： 0 报文接收 1 报文发出
            ,orgnl_id -- 源报文id
            ,orgnl_draft_no -- 原报文号
            ,sender -- 报文发送方
            ,receiver -- 报文接受方
            ,msg_id -- 报文标识号
            ,draft_no -- 报文编号
            ,process_result -- 处理结果
            ,update_date -- 更新日期
            ,trans_id -- 交易id
            ,exec_status -- 业务处理状态： 0 待处理 1 处理中 2 已完成
            ,ip -- 处理机器ip
            ,his_orgnl_id -- 修正前orgnl_id
            ,txn_status -- 交易状态对于发送方
            ,buss_flag -- 业务标记
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_ecds_msg_log_op(
            id -- 主键ID
            ,cre_dt -- 报文日期
            ,cre_tm -- 报文时间
            ,idnb -- 电子票据号码
            ,deal_mk -- 是否处理成功： 0 报文处理失败 1 报文处理成功 2 报文处理中
            ,draft_content -- 报文内容
            ,sendorrecv_mk -- 是否发送/接收： 0 报文接收 1 报文发出
            ,orgnl_id -- 源报文id
            ,orgnl_draft_no -- 原报文号
            ,sender -- 报文发送方
            ,receiver -- 报文接受方
            ,msg_id -- 报文标识号
            ,draft_no -- 报文编号
            ,process_result -- 处理结果
            ,update_date -- 更新日期
            ,trans_id -- 交易id
            ,exec_status -- 业务处理状态： 0 待处理 1 处理中 2 已完成
            ,ip -- 处理机器ip
            ,his_orgnl_id -- 修正前orgnl_id
            ,txn_status -- 交易状态对于发送方
            ,buss_flag -- 业务标记
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键ID
    ,nvl(n.cre_dt, o.cre_dt) as cre_dt -- 报文日期
    ,nvl(n.cre_tm, o.cre_tm) as cre_tm -- 报文时间
    ,nvl(n.idnb, o.idnb) as idnb -- 电子票据号码
    ,nvl(n.deal_mk, o.deal_mk) as deal_mk -- 是否处理成功： 0 报文处理失败 1 报文处理成功 2 报文处理中
    ,nvl(n.draft_content, o.draft_content) as draft_content -- 报文内容
    ,nvl(n.sendorrecv_mk, o.sendorrecv_mk) as sendorrecv_mk -- 是否发送/接收： 0 报文接收 1 报文发出
    ,nvl(n.orgnl_id, o.orgnl_id) as orgnl_id -- 源报文id
    ,nvl(n.orgnl_draft_no, o.orgnl_draft_no) as orgnl_draft_no -- 原报文号
    ,nvl(n.sender, o.sender) as sender -- 报文发送方
    ,nvl(n.receiver, o.receiver) as receiver -- 报文接受方
    ,nvl(n.msg_id, o.msg_id) as msg_id -- 报文标识号
    ,nvl(n.draft_no, o.draft_no) as draft_no -- 报文编号
    ,nvl(n.process_result, o.process_result) as process_result -- 处理结果
    ,nvl(n.update_date, o.update_date) as update_date -- 更新日期
    ,nvl(n.trans_id, o.trans_id) as trans_id -- 交易id
    ,nvl(n.exec_status, o.exec_status) as exec_status -- 业务处理状态： 0 待处理 1 处理中 2 已完成
    ,nvl(n.ip, o.ip) as ip -- 处理机器ip
    ,nvl(n.his_orgnl_id, o.his_orgnl_id) as his_orgnl_id -- 修正前orgnl_id
    ,nvl(n.txn_status, o.txn_status) as txn_status -- 交易状态对于发送方
    ,nvl(n.buss_flag, o.buss_flag) as buss_flag -- 业务标记
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_bms_ecds_msg_log_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_bms_ecds_msg_log where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.cre_dt <> n.cre_dt
        or o.cre_tm <> n.cre_tm
        or o.idnb <> n.idnb
        or o.deal_mk <> n.deal_mk
        or o.draft_content <> n.draft_content
        or o.sendorrecv_mk <> n.sendorrecv_mk
        or o.orgnl_id <> n.orgnl_id
        or o.orgnl_draft_no <> n.orgnl_draft_no
        or o.sender <> n.sender
        or o.receiver <> n.receiver
        or o.msg_id <> n.msg_id
        or o.draft_no <> n.draft_no
        or o.process_result <> n.process_result
        or o.update_date <> n.update_date
        or o.trans_id <> n.trans_id
        or o.exec_status <> n.exec_status
        or o.ip <> n.ip
        or o.his_orgnl_id <> n.his_orgnl_id
        or o.txn_status <> n.txn_status
        or o.buss_flag <> n.buss_flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_ecds_msg_log_cl(
            id -- 主键ID
            ,cre_dt -- 报文日期
            ,cre_tm -- 报文时间
            ,idnb -- 电子票据号码
            ,deal_mk -- 是否处理成功： 0 报文处理失败 1 报文处理成功 2 报文处理中
            ,draft_content -- 报文内容
            ,sendorrecv_mk -- 是否发送/接收： 0 报文接收 1 报文发出
            ,orgnl_id -- 源报文id
            ,orgnl_draft_no -- 原报文号
            ,sender -- 报文发送方
            ,receiver -- 报文接受方
            ,msg_id -- 报文标识号
            ,draft_no -- 报文编号
            ,process_result -- 处理结果
            ,update_date -- 更新日期
            ,trans_id -- 交易id
            ,exec_status -- 业务处理状态： 0 待处理 1 处理中 2 已完成
            ,ip -- 处理机器ip
            ,his_orgnl_id -- 修正前orgnl_id
            ,txn_status -- 交易状态对于发送方
            ,buss_flag -- 业务标记
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_ecds_msg_log_op(
            id -- 主键ID
            ,cre_dt -- 报文日期
            ,cre_tm -- 报文时间
            ,idnb -- 电子票据号码
            ,deal_mk -- 是否处理成功： 0 报文处理失败 1 报文处理成功 2 报文处理中
            ,draft_content -- 报文内容
            ,sendorrecv_mk -- 是否发送/接收： 0 报文接收 1 报文发出
            ,orgnl_id -- 源报文id
            ,orgnl_draft_no -- 原报文号
            ,sender -- 报文发送方
            ,receiver -- 报文接受方
            ,msg_id -- 报文标识号
            ,draft_no -- 报文编号
            ,process_result -- 处理结果
            ,update_date -- 更新日期
            ,trans_id -- 交易id
            ,exec_status -- 业务处理状态： 0 待处理 1 处理中 2 已完成
            ,ip -- 处理机器ip
            ,his_orgnl_id -- 修正前orgnl_id
            ,txn_status -- 交易状态对于发送方
            ,buss_flag -- 业务标记
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键ID
    ,o.cre_dt -- 报文日期
    ,o.cre_tm -- 报文时间
    ,o.idnb -- 电子票据号码
    ,o.deal_mk -- 是否处理成功： 0 报文处理失败 1 报文处理成功 2 报文处理中
    ,o.draft_content -- 报文内容
    ,o.sendorrecv_mk -- 是否发送/接收： 0 报文接收 1 报文发出
    ,o.orgnl_id -- 源报文id
    ,o.orgnl_draft_no -- 原报文号
    ,o.sender -- 报文发送方
    ,o.receiver -- 报文接受方
    ,o.msg_id -- 报文标识号
    ,o.draft_no -- 报文编号
    ,o.process_result -- 处理结果
    ,o.update_date -- 更新日期
    ,o.trans_id -- 交易id
    ,o.exec_status -- 业务处理状态： 0 待处理 1 处理中 2 已完成
    ,o.ip -- 处理机器ip
    ,o.his_orgnl_id -- 修正前orgnl_id
    ,o.txn_status -- 交易状态对于发送方
    ,o.buss_flag -- 业务标记
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
from ${iol_schema}.bdms_bms_ecds_msg_log_bk o
    left join ${iol_schema}.bdms_bms_ecds_msg_log_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_bms_ecds_msg_log_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.bdms_bms_ecds_msg_log;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_bms_ecds_msg_log') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_bms_ecds_msg_log drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_bms_ecds_msg_log add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_bms_ecds_msg_log exchange partition p_${batch_date} with table ${iol_schema}.bdms_bms_ecds_msg_log_cl;
alter table ${iol_schema}.bdms_bms_ecds_msg_log exchange partition p_20991231 with table ${iol_schema}.bdms_bms_ecds_msg_log_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_ecds_msg_log to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_ecds_msg_log_op purge;
drop table ${iol_schema}.bdms_bms_ecds_msg_log_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_bms_ecds_msg_log_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_ecds_msg_log',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
