/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_overdue_handle
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
create table ${iol_schema}.ibms_ttrd_overdue_handle_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_overdue_handle
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_overdue_handle_op purge;
drop table ${iol_schema}.ibms_ttrd_overdue_handle_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_overdue_handle_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_overdue_handle where 0=1;

create table ${iol_schema}.ibms_ttrd_overdue_handle_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_overdue_handle where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_overdue_handle_cl(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,i_name -- 金融工具名称
            ,is_ai_overdue -- 利息是否逾期：1是0否
            ,amount_ai_overdue -- 利息逾期金额
            ,beg_date_ai_overdue -- 利息逾期开始日
            ,is_cp_overdue -- 本金是否逾期：1是0否
            ,amount_cp_overdue -- 本金逾期金额
            ,beg_date_cp_overdue -- 本金逾期开始日
            ,transfer_table_type -- 1:转表内,2:转表外,0:默认值,未进行过转表操作
            ,statu -- 状态 1:待复核,2:已生效
            ,check_name -- 提交人/修改人
            ,check_time -- 提交时间/修改时间
            ,review_user -- 复核人
            ,review_time -- 复核时间
            ,change_date -- 变更日期
            ,is_si -- 是次级标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_overdue_handle_op(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,i_name -- 金融工具名称
            ,is_ai_overdue -- 利息是否逾期：1是0否
            ,amount_ai_overdue -- 利息逾期金额
            ,beg_date_ai_overdue -- 利息逾期开始日
            ,is_cp_overdue -- 本金是否逾期：1是0否
            ,amount_cp_overdue -- 本金逾期金额
            ,beg_date_cp_overdue -- 本金逾期开始日
            ,transfer_table_type -- 1:转表内,2:转表外,0:默认值,未进行过转表操作
            ,statu -- 状态 1:待复核,2:已生效
            ,check_name -- 提交人/修改人
            ,check_time -- 提交时间/修改时间
            ,review_user -- 复核人
            ,review_time -- 复核时间
            ,change_date -- 变更日期
            ,is_si -- 是次级标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.i_code, o.i_code) as i_code -- 金融工具代码
    ,nvl(n.a_type, o.a_type) as a_type -- 资产类型
    ,nvl(n.m_type, o.m_type) as m_type -- 市场类型
    ,nvl(n.i_name, o.i_name) as i_name -- 金融工具名称
    ,nvl(n.is_ai_overdue, o.is_ai_overdue) as is_ai_overdue -- 利息是否逾期：1是0否
    ,nvl(n.amount_ai_overdue, o.amount_ai_overdue) as amount_ai_overdue -- 利息逾期金额
    ,nvl(n.beg_date_ai_overdue, o.beg_date_ai_overdue) as beg_date_ai_overdue -- 利息逾期开始日
    ,nvl(n.is_cp_overdue, o.is_cp_overdue) as is_cp_overdue -- 本金是否逾期：1是0否
    ,nvl(n.amount_cp_overdue, o.amount_cp_overdue) as amount_cp_overdue -- 本金逾期金额
    ,nvl(n.beg_date_cp_overdue, o.beg_date_cp_overdue) as beg_date_cp_overdue -- 本金逾期开始日
    ,nvl(n.transfer_table_type, o.transfer_table_type) as transfer_table_type -- 1:转表内,2:转表外,0:默认值,未进行过转表操作
    ,nvl(n.statu, o.statu) as statu -- 状态 1:待复核,2:已生效
    ,nvl(n.check_name, o.check_name) as check_name -- 提交人/修改人
    ,nvl(n.check_time, o.check_time) as check_time -- 提交时间/修改时间
    ,nvl(n.review_user, o.review_user) as review_user -- 复核人
    ,nvl(n.review_time, o.review_time) as review_time -- 复核时间
    ,nvl(n.change_date, o.change_date) as change_date -- 变更日期
    ,nvl(n.is_si, o.is_si) as is_si -- 是次级标识
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_overdue_handle_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_overdue_handle where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
where (
        o.i_code is null
        and o.a_type is null
        and o.m_type is null
    )
    or (
        n.i_code is null
        and n.a_type is null
        and n.m_type is null
    )
    or (
        o.i_name <> n.i_name
        or o.is_ai_overdue <> n.is_ai_overdue
        or o.amount_ai_overdue <> n.amount_ai_overdue
        or o.beg_date_ai_overdue <> n.beg_date_ai_overdue
        or o.is_cp_overdue <> n.is_cp_overdue
        or o.amount_cp_overdue <> n.amount_cp_overdue
        or o.beg_date_cp_overdue <> n.beg_date_cp_overdue
        or o.transfer_table_type <> n.transfer_table_type
        or o.statu <> n.statu
        or o.check_name <> n.check_name
        or o.check_time <> n.check_time
        or o.review_user <> n.review_user
        or o.review_time <> n.review_time
        or o.change_date <> n.change_date
        or o.is_si <> n.is_si
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_overdue_handle_cl(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,i_name -- 金融工具名称
            ,is_ai_overdue -- 利息是否逾期：1是0否
            ,amount_ai_overdue -- 利息逾期金额
            ,beg_date_ai_overdue -- 利息逾期开始日
            ,is_cp_overdue -- 本金是否逾期：1是0否
            ,amount_cp_overdue -- 本金逾期金额
            ,beg_date_cp_overdue -- 本金逾期开始日
            ,transfer_table_type -- 1:转表内,2:转表外,0:默认值,未进行过转表操作
            ,statu -- 状态 1:待复核,2:已生效
            ,check_name -- 提交人/修改人
            ,check_time -- 提交时间/修改时间
            ,review_user -- 复核人
            ,review_time -- 复核时间
            ,change_date -- 变更日期
            ,is_si -- 是次级标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_overdue_handle_op(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,i_name -- 金融工具名称
            ,is_ai_overdue -- 利息是否逾期：1是0否
            ,amount_ai_overdue -- 利息逾期金额
            ,beg_date_ai_overdue -- 利息逾期开始日
            ,is_cp_overdue -- 本金是否逾期：1是0否
            ,amount_cp_overdue -- 本金逾期金额
            ,beg_date_cp_overdue -- 本金逾期开始日
            ,transfer_table_type -- 1:转表内,2:转表外,0:默认值,未进行过转表操作
            ,statu -- 状态 1:待复核,2:已生效
            ,check_name -- 提交人/修改人
            ,check_time -- 提交时间/修改时间
            ,review_user -- 复核人
            ,review_time -- 复核时间
            ,change_date -- 变更日期
            ,is_si -- 是次级标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.i_code -- 金融工具代码
    ,o.a_type -- 资产类型
    ,o.m_type -- 市场类型
    ,o.i_name -- 金融工具名称
    ,o.is_ai_overdue -- 利息是否逾期：1是0否
    ,o.amount_ai_overdue -- 利息逾期金额
    ,o.beg_date_ai_overdue -- 利息逾期开始日
    ,o.is_cp_overdue -- 本金是否逾期：1是0否
    ,o.amount_cp_overdue -- 本金逾期金额
    ,o.beg_date_cp_overdue -- 本金逾期开始日
    ,o.transfer_table_type -- 1:转表内,2:转表外,0:默认值,未进行过转表操作
    ,o.statu -- 状态 1:待复核,2:已生效
    ,o.check_name -- 提交人/修改人
    ,o.check_time -- 提交时间/修改时间
    ,o.review_user -- 复核人
    ,o.review_time -- 复核时间
    ,o.change_date -- 变更日期
    ,o.is_si -- 是次级标识
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
from ${iol_schema}.ibms_ttrd_overdue_handle_bk o
    left join ${iol_schema}.ibms_ttrd_overdue_handle_op n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_overdue_handle_cl d
        on
            o.i_code = d.i_code
            and o.a_type = d.a_type
            and o.m_type = d.m_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_ttrd_overdue_handle;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_overdue_handle') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_overdue_handle drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_overdue_handle add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_overdue_handle exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_overdue_handle_cl;
alter table ${iol_schema}.ibms_ttrd_overdue_handle exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_overdue_handle_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_overdue_handle to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_overdue_handle_op purge;
drop table ${iol_schema}.ibms_ttrd_overdue_handle_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_overdue_handle_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_overdue_handle',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
