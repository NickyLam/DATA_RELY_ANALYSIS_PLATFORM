/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wld_joint_credit_line_info
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
create table ${iol_schema}.icms_wld_joint_credit_line_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_wld_joint_credit_line_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wld_joint_credit_line_info_op purge;
drop table ${iol_schema}.icms_wld_joint_credit_line_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wld_joint_credit_line_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wld_joint_credit_line_info where 0=1;

create table ${iol_schema}.icms_wld_joint_credit_line_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wld_joint_credit_line_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wld_joint_credit_line_info_cl(
            bizno -- 流水号
            ,custid -- 客户号
            ,idtype -- 证件类型
            ,idno -- 证件号码
            ,loancode -- 产品类型
            ,currentlimit -- 可用额度
            ,settledate -- 结清日期
            ,applydate -- 申请日期
            ,signage -- 新旧微粒贷标识
            ,limitamount -- 额度金额
            ,effectiveflag -- 生效标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wld_joint_credit_line_info_op(
            bizno -- 流水号
            ,custid -- 客户号
            ,idtype -- 证件类型
            ,idno -- 证件号码
            ,loancode -- 产品类型
            ,currentlimit -- 可用额度
            ,settledate -- 结清日期
            ,applydate -- 申请日期
            ,signage -- 新旧微粒贷标识
            ,limitamount -- 额度金额
            ,effectiveflag -- 生效标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.bizno, o.bizno) as bizno -- 流水号
    ,nvl(n.custid, o.custid) as custid -- 客户号
    ,nvl(n.idtype, o.idtype) as idtype -- 证件类型
    ,nvl(n.idno, o.idno) as idno -- 证件号码
    ,nvl(n.loancode, o.loancode) as loancode -- 产品类型
    ,nvl(n.currentlimit, o.currentlimit) as currentlimit -- 可用额度
    ,nvl(n.settledate, o.settledate) as settledate -- 结清日期
    ,nvl(n.applydate, o.applydate) as applydate -- 申请日期
    ,nvl(n.signage, o.signage) as signage -- 新旧微粒贷标识
    ,nvl(n.limitamount, o.limitamount) as limitamount -- 额度金额
    ,nvl(n.effectiveflag, o.effectiveflag) as effectiveflag -- 生效标识
    ,case when
            n.bizno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bizno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bizno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_wld_joint_credit_line_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_wld_joint_credit_line_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.bizno = n.bizno
where (
        o.bizno is null
    )
    or (
        n.bizno is null
    )
    or (
        o.custid <> n.custid
        or o.idtype <> n.idtype
        or o.idno <> n.idno
        or o.loancode <> n.loancode
        or o.currentlimit <> n.currentlimit
        or o.settledate <> n.settledate
        or o.applydate <> n.applydate
        or o.signage <> n.signage
        or o.limitamount <> n.limitamount
        or o.effectiveflag <> n.effectiveflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wld_joint_credit_line_info_cl(
            bizno -- 流水号
            ,custid -- 客户号
            ,idtype -- 证件类型
            ,idno -- 证件号码
            ,loancode -- 产品类型
            ,currentlimit -- 可用额度
            ,settledate -- 结清日期
            ,applydate -- 申请日期
            ,signage -- 新旧微粒贷标识
            ,limitamount -- 额度金额
            ,effectiveflag -- 生效标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wld_joint_credit_line_info_op(
            bizno -- 流水号
            ,custid -- 客户号
            ,idtype -- 证件类型
            ,idno -- 证件号码
            ,loancode -- 产品类型
            ,currentlimit -- 可用额度
            ,settledate -- 结清日期
            ,applydate -- 申请日期
            ,signage -- 新旧微粒贷标识
            ,limitamount -- 额度金额
            ,effectiveflag -- 生效标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.bizno -- 流水号
    ,o.custid -- 客户号
    ,o.idtype -- 证件类型
    ,o.idno -- 证件号码
    ,o.loancode -- 产品类型
    ,o.currentlimit -- 可用额度
    ,o.settledate -- 结清日期
    ,o.applydate -- 申请日期
    ,o.signage -- 新旧微粒贷标识
    ,o.limitamount -- 额度金额
    ,o.effectiveflag -- 生效标识
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
from ${iol_schema}.icms_wld_joint_credit_line_info_bk o
    left join ${iol_schema}.icms_wld_joint_credit_line_info_op n
        on
            o.bizno = n.bizno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_wld_joint_credit_line_info_cl d
        on
            o.bizno = d.bizno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_wld_joint_credit_line_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_wld_joint_credit_line_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_wld_joint_credit_line_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_wld_joint_credit_line_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_wld_joint_credit_line_info exchange partition p_${batch_date} with table ${iol_schema}.icms_wld_joint_credit_line_info_cl;
alter table ${iol_schema}.icms_wld_joint_credit_line_info exchange partition p_20991231 with table ${iol_schema}.icms_wld_joint_credit_line_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wld_joint_credit_line_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wld_joint_credit_line_info_op purge;
drop table ${iol_schema}.icms_wld_joint_credit_line_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_wld_joint_credit_line_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wld_joint_credit_line_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
