/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_agreement_rec
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
create table ${iol_schema}.ncbs_rb_agreement_rec_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_agreement_rec
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_agreement_rec_op purge;
drop table ${iol_schema}.ncbs_rb_agreement_rec_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_rec_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_agreement_rec where 0=1;

create table ${iol_schema}.ncbs_rb_agreement_rec_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_agreement_rec where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_agreement_rec_cl(
            client_no -- 客户编号
            ,document_id -- 证件号码
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,password -- 密码
            ,phone_no -- 固定电话
            ,source_type -- 渠道编号
            ,sign_date -- 签约日期
            ,tran_timestamp -- 交易时间戳
            ,phone_name -- 经办人名称
            ,sign_branch -- 签约机构
            ,sign_user_id -- 签约柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_agreement_rec_op(
            client_no -- 客户编号
            ,document_id -- 证件号码
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,password -- 密码
            ,phone_no -- 固定电话
            ,source_type -- 渠道编号
            ,sign_date -- 签约日期
            ,tran_timestamp -- 交易时间戳
            ,phone_name -- 经办人名称
            ,sign_branch -- 签约机构
            ,sign_user_id -- 签约柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.document_id, o.document_id) as document_id -- 证件号码
    ,nvl(n.agreement_id, o.agreement_id) as agreement_id -- 协议编号
    ,nvl(n.agreement_status, o.agreement_status) as agreement_status -- 协议状态
    ,nvl(n.channel_seq_no, o.channel_seq_no) as channel_seq_no -- 全局流水号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.password, o.password) as password -- 密码
    ,nvl(n.phone_no, o.phone_no) as phone_no -- 固定电话
    ,nvl(n.source_type, o.source_type) as source_type -- 渠道编号
    ,nvl(n.sign_date, o.sign_date) as sign_date -- 签约日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.phone_name, o.phone_name) as phone_name -- 经办人名称
    ,nvl(n.sign_branch, o.sign_branch) as sign_branch -- 签约机构
    ,nvl(n.sign_user_id, o.sign_user_id) as sign_user_id -- 签约柜员
    ,case when
            n.agreement_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agreement_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agreement_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_agreement_rec_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_agreement_rec where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.agreement_id = n.agreement_id
where (
        o.agreement_id is null
    )
    or (
        n.agreement_id is null
    )
    or (
        o.client_no <> n.client_no
        or o.document_id <> n.document_id
        or o.agreement_status <> n.agreement_status
        or o.channel_seq_no <> n.channel_seq_no
        or o.company <> n.company
        or o.password <> n.password
        or o.phone_no <> n.phone_no
        or o.source_type <> n.source_type
        or o.sign_date <> n.sign_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.phone_name <> n.phone_name
        or o.sign_branch <> n.sign_branch
        or o.sign_user_id <> n.sign_user_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_agreement_rec_cl(
            client_no -- 客户编号
            ,document_id -- 证件号码
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,password -- 密码
            ,phone_no -- 固定电话
            ,source_type -- 渠道编号
            ,sign_date -- 签约日期
            ,tran_timestamp -- 交易时间戳
            ,phone_name -- 经办人名称
            ,sign_branch -- 签约机构
            ,sign_user_id -- 签约柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_agreement_rec_op(
            client_no -- 客户编号
            ,document_id -- 证件号码
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,password -- 密码
            ,phone_no -- 固定电话
            ,source_type -- 渠道编号
            ,sign_date -- 签约日期
            ,tran_timestamp -- 交易时间戳
            ,phone_name -- 经办人名称
            ,sign_branch -- 签约机构
            ,sign_user_id -- 签约柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.document_id -- 证件号码
    ,o.agreement_id -- 协议编号
    ,o.agreement_status -- 协议状态
    ,o.channel_seq_no -- 全局流水号
    ,o.company -- 法人
    ,o.password -- 密码
    ,o.phone_no -- 固定电话
    ,o.source_type -- 渠道编号
    ,o.sign_date -- 签约日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.phone_name -- 经办人名称
    ,o.sign_branch -- 签约机构
    ,o.sign_user_id -- 签约柜员
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
from ${iol_schema}.ncbs_rb_agreement_rec_bk o
    left join ${iol_schema}.ncbs_rb_agreement_rec_op n
        on
            o.agreement_id = n.agreement_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_agreement_rec_cl d
        on
            o.agreement_id = d.agreement_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_agreement_rec;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_agreement_rec') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_agreement_rec drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_agreement_rec add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_agreement_rec exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_agreement_rec_cl;
alter table ${iol_schema}.ncbs_rb_agreement_rec exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_agreement_rec_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_agreement_rec to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_agreement_rec_op purge;
drop table ${iol_schema}.ncbs_rb_agreement_rec_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_agreement_rec_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_agreement_rec',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
