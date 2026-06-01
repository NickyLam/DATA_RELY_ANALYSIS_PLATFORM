/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbinsureracc
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
create table ${iol_schema}.ifms_tbinsureracc_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbinsureracc
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbinsureracc_op purge;
drop table ${iol_schema}.ifms_tbinsureracc_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbinsureracc_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbinsureracc where 0=1;

create table ${iol_schema}.ifms_tbinsureracc_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbinsureracc where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbinsureracc_cl(
            ta_code -- TA代码
            ,branch_no -- 机构编号
            ,curr_type -- 币种
            ,acc_type -- 账号类型0-内部户1-保险公司账户2-代收传账户
            ,account_no -- 账号
            ,account_name -- 账号名称
            ,account_openno -- 账号行号
            ,account_open -- 账号开户行名称
            ,reserve1 -- 备用字段1
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbinsureracc_op(
            ta_code -- TA代码
            ,branch_no -- 机构编号
            ,curr_type -- 币种
            ,acc_type -- 账号类型0-内部户1-保险公司账户2-代收传账户
            ,account_no -- 账号
            ,account_name -- 账号名称
            ,account_openno -- 账号行号
            ,account_open -- 账号开户行名称
            ,reserve1 -- 备用字段1
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ta_code, o.ta_code) as ta_code -- TA代码
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 机构编号
    ,nvl(n.curr_type, o.curr_type) as curr_type -- 币种
    ,nvl(n.acc_type, o.acc_type) as acc_type -- 账号类型0-内部户1-保险公司账户2-代收传账户
    ,nvl(n.account_no, o.account_no) as account_no -- 账号
    ,nvl(n.account_name, o.account_name) as account_name -- 账号名称
    ,nvl(n.account_openno, o.account_openno) as account_openno -- 账号行号
    ,nvl(n.account_open, o.account_open) as account_open -- 账号开户行名称
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备用字段1
    ,case when
            n.ta_code is null
            and n.branch_no is null
            and n.curr_type is null
            and n.acc_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ta_code is null
            and n.branch_no is null
            and n.curr_type is null
            and n.acc_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ta_code is null
            and n.branch_no is null
            and n.curr_type is null
            and n.acc_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbinsureracc_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbinsureracc where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ta_code = n.ta_code
            and o.branch_no = n.branch_no
            and o.curr_type = n.curr_type
            and o.acc_type = n.acc_type
where (
        o.ta_code is null
        and o.branch_no is null
        and o.curr_type is null
        and o.acc_type is null
    )
    or (
        n.ta_code is null
        and n.branch_no is null
        and n.curr_type is null
        and n.acc_type is null
    )
    or (
        o.account_no <> n.account_no
        or o.account_name <> n.account_name
        or o.account_openno <> n.account_openno
        or o.account_open <> n.account_open
        or o.reserve1 <> n.reserve1
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbinsureracc_cl(
            ta_code -- TA代码
            ,branch_no -- 机构编号
            ,curr_type -- 币种
            ,acc_type -- 账号类型0-内部户1-保险公司账户2-代收传账户
            ,account_no -- 账号
            ,account_name -- 账号名称
            ,account_openno -- 账号行号
            ,account_open -- 账号开户行名称
            ,reserve1 -- 备用字段1
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbinsureracc_op(
            ta_code -- TA代码
            ,branch_no -- 机构编号
            ,curr_type -- 币种
            ,acc_type -- 账号类型0-内部户1-保险公司账户2-代收传账户
            ,account_no -- 账号
            ,account_name -- 账号名称
            ,account_openno -- 账号行号
            ,account_open -- 账号开户行名称
            ,reserve1 -- 备用字段1
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ta_code -- TA代码
    ,o.branch_no -- 机构编号
    ,o.curr_type -- 币种
    ,o.acc_type -- 账号类型0-内部户1-保险公司账户2-代收传账户
    ,o.account_no -- 账号
    ,o.account_name -- 账号名称
    ,o.account_openno -- 账号行号
    ,o.account_open -- 账号开户行名称
    ,o.reserve1 -- 备用字段1
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
from ${iol_schema}.ifms_tbinsureracc_bk o
    left join ${iol_schema}.ifms_tbinsureracc_op n
        on
            o.ta_code = n.ta_code
            and o.branch_no = n.branch_no
            and o.curr_type = n.curr_type
            and o.acc_type = n.acc_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbinsureracc_cl d
        on
            o.ta_code = d.ta_code
            and o.branch_no = d.branch_no
            and o.curr_type = d.curr_type
            and o.acc_type = d.acc_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ifms_tbinsureracc;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ifms_tbinsureracc') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ifms_tbinsureracc drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ifms_tbinsureracc add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ifms_tbinsureracc exchange partition p_${batch_date} with table ${iol_schema}.ifms_tbinsureracc_cl;
alter table ${iol_schema}.ifms_tbinsureracc exchange partition p_20991231 with table ${iol_schema}.ifms_tbinsureracc_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbinsureracc to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbinsureracc_op purge;
drop table ${iol_schema}.ifms_tbinsureracc_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbinsureracc_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbinsureracc',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
