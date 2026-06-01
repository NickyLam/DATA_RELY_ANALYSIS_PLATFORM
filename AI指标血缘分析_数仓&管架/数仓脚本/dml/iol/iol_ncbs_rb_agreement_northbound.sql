/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_agreement_northbound
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
create table ${iol_schema}.ncbs_rb_agreement_northbound_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_agreement_northbound
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_agreement_northbound_op purge;
drop table ${iol_schema}.ncbs_rb_agreement_northbound_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_northbound_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_agreement_northbound where 0=1;

create table ${iol_schema}.ncbs_rb_agreement_northbound_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_agreement_northbound where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_agreement_northbound_cl(
            unsignapplyrevertdate -- 解约申请撤销日期
            ,acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,prod_type -- 产品编号
            ,agreement_id -- 协议编号
            ,agreement_type -- 协议类型
            ,out_sign_date -- 解约日期
            ,sign_date -- 签约日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,out_sign_branch -- 解约机构
            ,out_sign_user_id -- 解约柜员
            ,sign_branch -- 签约机构
            ,sign_user_id -- 签约柜员
            ,northbound_status -- 北向通签约状态
            ,unsignapplaydate -- 解约申请日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_agreement_northbound_op(
            unsignapplyrevertdate -- 解约申请撤销日期
            ,acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,prod_type -- 产品编号
            ,agreement_id -- 协议编号
            ,agreement_type -- 协议类型
            ,out_sign_date -- 解约日期
            ,sign_date -- 签约日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,out_sign_branch -- 解约机构
            ,out_sign_user_id -- 解约柜员
            ,sign_branch -- 签约机构
            ,sign_user_id -- 签约柜员
            ,northbound_status -- 北向通签约状态
            ,unsignapplaydate -- 解约申请日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.unsignapplyrevertdate, o.unsignapplyrevertdate) as unsignapplyrevertdate -- 解约申请撤销日期
    ,nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.agreement_id, o.agreement_id) as agreement_id -- 协议编号
    ,nvl(n.agreement_type, o.agreement_type) as agreement_type -- 协议类型
    ,nvl(n.out_sign_date, o.out_sign_date) as out_sign_date -- 解约日期
    ,nvl(n.sign_date, o.sign_date) as sign_date -- 签约日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.out_sign_branch, o.out_sign_branch) as out_sign_branch -- 解约机构
    ,nvl(n.out_sign_user_id, o.out_sign_user_id) as out_sign_user_id -- 解约柜员
    ,nvl(n.sign_branch, o.sign_branch) as sign_branch -- 签约机构
    ,nvl(n.sign_user_id, o.sign_user_id) as sign_user_id -- 签约柜员
    ,nvl(n.northbound_status, o.northbound_status) as northbound_status -- 北向通签约状态
    ,nvl(n.unsignapplaydate, o.unsignapplaydate) as unsignapplaydate -- 解约申请日期
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
from (select * from ${iol_schema}.ncbs_rb_agreement_northbound_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_agreement_northbound where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.agreement_id = n.agreement_id
where (
        o.agreement_id is null
    )
    or (
        n.agreement_id is null
    )
    or (
        o.unsignapplyrevertdate <> n.unsignapplyrevertdate
        or o.acct_seq_no <> n.acct_seq_no
        or o.base_acct_no <> n.base_acct_no
        or o.client_no <> n.client_no
        or o.prod_type <> n.prod_type
        or o.agreement_type <> n.agreement_type
        or o.out_sign_date <> n.out_sign_date
        or o.sign_date <> n.sign_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.acct_ccy <> n.acct_ccy
        or o.out_sign_branch <> n.out_sign_branch
        or o.out_sign_user_id <> n.out_sign_user_id
        or o.sign_branch <> n.sign_branch
        or o.sign_user_id <> n.sign_user_id
        or o.northbound_status <> n.northbound_status
        or o.unsignapplaydate <> n.unsignapplaydate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_agreement_northbound_cl(
            unsignapplyrevertdate -- 解约申请撤销日期
            ,acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,prod_type -- 产品编号
            ,agreement_id -- 协议编号
            ,agreement_type -- 协议类型
            ,out_sign_date -- 解约日期
            ,sign_date -- 签约日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,out_sign_branch -- 解约机构
            ,out_sign_user_id -- 解约柜员
            ,sign_branch -- 签约机构
            ,sign_user_id -- 签约柜员
            ,northbound_status -- 北向通签约状态
            ,unsignapplaydate -- 解约申请日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_agreement_northbound_op(
            unsignapplyrevertdate -- 解约申请撤销日期
            ,acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,prod_type -- 产品编号
            ,agreement_id -- 协议编号
            ,agreement_type -- 协议类型
            ,out_sign_date -- 解约日期
            ,sign_date -- 签约日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,out_sign_branch -- 解约机构
            ,out_sign_user_id -- 解约柜员
            ,sign_branch -- 签约机构
            ,sign_user_id -- 签约柜员
            ,northbound_status -- 北向通签约状态
            ,unsignapplaydate -- 解约申请日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.unsignapplyrevertdate -- 解约申请撤销日期
    ,o.acct_seq_no -- 账户子账号
    ,o.base_acct_no -- 交易账号/卡号
    ,o.client_no -- 客户编号
    ,o.prod_type -- 产品编号
    ,o.agreement_id -- 协议编号
    ,o.agreement_type -- 协议类型
    ,o.out_sign_date -- 解约日期
    ,o.sign_date -- 签约日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.acct_ccy -- 账户币种
    ,o.out_sign_branch -- 解约机构
    ,o.out_sign_user_id -- 解约柜员
    ,o.sign_branch -- 签约机构
    ,o.sign_user_id -- 签约柜员
    ,o.northbound_status -- 北向通签约状态
    ,o.unsignapplaydate -- 解约申请日期
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
from ${iol_schema}.ncbs_rb_agreement_northbound_bk o
    left join ${iol_schema}.ncbs_rb_agreement_northbound_op n
        on
            o.agreement_id = n.agreement_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_agreement_northbound_cl d
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
--truncate table ${iol_schema}.ncbs_rb_agreement_northbound;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_agreement_northbound') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_agreement_northbound drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_agreement_northbound add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_agreement_northbound exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_agreement_northbound_cl;
alter table ${iol_schema}.ncbs_rb_agreement_northbound exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_agreement_northbound_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_agreement_northbound to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_agreement_northbound_op purge;
drop table ${iol_schema}.ncbs_rb_agreement_northbound_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_agreement_northbound_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_agreement_northbound',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
