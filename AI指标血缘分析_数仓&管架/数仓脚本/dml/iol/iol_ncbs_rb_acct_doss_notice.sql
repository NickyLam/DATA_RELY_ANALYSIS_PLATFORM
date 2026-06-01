/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_acct_doss_notice
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
create table ${iol_schema}.ncbs_rb_acct_doss_notice_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_acct_doss_notice
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_acct_doss_notice_op purge;
drop table ${iol_schema}.ncbs_rb_acct_doss_notice_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_doss_notice_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_acct_doss_notice where 0=1;

create table ${iol_schema}.ncbs_rb_acct_doss_notice_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_acct_doss_notice where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_acct_doss_notice_cl(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,address -- 地址
            ,base_acct_no -- 交易账号/卡号
            ,branch -- 机构编号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,remark -- 备注
            ,company -- 法人
            ,contact_tel -- 客户联系电话
            ,linkman -- 对账联系人
            ,notice_date -- 通知日期
            ,seq_no -- 序号
            ,dormant_date -- 转不动户日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,msg_notice_type -- 通知类型
            ,notice_status -- 通知状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_acct_doss_notice_op(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,address -- 地址
            ,base_acct_no -- 交易账号/卡号
            ,branch -- 机构编号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,remark -- 备注
            ,company -- 法人
            ,contact_tel -- 客户联系电话
            ,linkman -- 对账联系人
            ,notice_date -- 通知日期
            ,seq_no -- 序号
            ,dormant_date -- 转不动户日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,msg_notice_type -- 通知类型
            ,notice_status -- 通知状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.acct_status, o.acct_status) as acct_status -- 账户状态
    ,nvl(n.address, o.address) as address -- 地址
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.branch, o.branch) as branch -- 机构编号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.contact_tel, o.contact_tel) as contact_tel -- 客户联系电话
    ,nvl(n.linkman, o.linkman) as linkman -- 对账联系人
    ,nvl(n.notice_date, o.notice_date) as notice_date -- 通知日期
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.dormant_date, o.dormant_date) as dormant_date -- 转不动户日期
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.msg_notice_type, o.msg_notice_type) as msg_notice_type -- 通知类型
    ,nvl(n.notice_status, o.notice_status) as notice_status -- 通知状态
    ,case when
            n.seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_acct_doss_notice_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_acct_doss_notice where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq_no = n.seq_no
where (
        o.seq_no is null
    )
    or (
        n.seq_no is null
    )
    or (
        o.acct_name <> n.acct_name
        or o.acct_seq_no <> n.acct_seq_no
        or o.acct_status <> n.acct_status
        or o.address <> n.address
        or o.base_acct_no <> n.base_acct_no
        or o.branch <> n.branch
        or o.client_no <> n.client_no
        or o.internal_key <> n.internal_key
        or o.prod_type <> n.prod_type
        or o.remark <> n.remark
        or o.company <> n.company
        or o.contact_tel <> n.contact_tel
        or o.linkman <> n.linkman
        or o.notice_date <> n.notice_date
        or o.dormant_date <> n.dormant_date
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.acct_ccy <> n.acct_ccy
        or o.msg_notice_type <> n.msg_notice_type
        or o.notice_status <> n.notice_status
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_acct_doss_notice_cl(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,address -- 地址
            ,base_acct_no -- 交易账号/卡号
            ,branch -- 机构编号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,remark -- 备注
            ,company -- 法人
            ,contact_tel -- 客户联系电话
            ,linkman -- 对账联系人
            ,notice_date -- 通知日期
            ,seq_no -- 序号
            ,dormant_date -- 转不动户日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,msg_notice_type -- 通知类型
            ,notice_status -- 通知状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_acct_doss_notice_op(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,address -- 地址
            ,base_acct_no -- 交易账号/卡号
            ,branch -- 机构编号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,remark -- 备注
            ,company -- 法人
            ,contact_tel -- 客户联系电话
            ,linkman -- 对账联系人
            ,notice_date -- 通知日期
            ,seq_no -- 序号
            ,dormant_date -- 转不动户日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,msg_notice_type -- 通知类型
            ,notice_status -- 通知状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_name -- 账户名称
    ,o.acct_seq_no -- 账户子账号
    ,o.acct_status -- 账户状态
    ,o.address -- 地址
    ,o.base_acct_no -- 交易账号/卡号
    ,o.branch -- 机构编号
    ,o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.remark -- 备注
    ,o.company -- 法人
    ,o.contact_tel -- 客户联系电话
    ,o.linkman -- 对账联系人
    ,o.notice_date -- 通知日期
    ,o.seq_no -- 序号
    ,o.dormant_date -- 转不动户日期
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.acct_ccy -- 账户币种
    ,o.msg_notice_type -- 通知类型
    ,o.notice_status -- 通知状态
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
from ${iol_schema}.ncbs_rb_acct_doss_notice_bk o
    left join ${iol_schema}.ncbs_rb_acct_doss_notice_op n
        on
            o.seq_no = n.seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_acct_doss_notice_cl d
        on
            o.seq_no = d.seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_acct_doss_notice;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_acct_doss_notice') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_acct_doss_notice drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_acct_doss_notice add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_acct_doss_notice exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_acct_doss_notice_cl;
alter table ${iol_schema}.ncbs_rb_acct_doss_notice exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_acct_doss_notice_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_acct_doss_notice to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_acct_doss_notice_op purge;
drop table ${iol_schema}.ncbs_rb_acct_doss_notice_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_acct_doss_notice_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_acct_doss_notice',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
