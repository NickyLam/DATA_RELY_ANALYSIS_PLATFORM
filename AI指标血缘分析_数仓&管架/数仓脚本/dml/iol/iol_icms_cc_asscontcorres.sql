/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_cc_asscontcorres
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
create table ${iol_schema}.icms_cc_asscontcorres_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_cc_asscontcorres
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_cc_asscontcorres_op purge;
drop table ${iol_schema}.icms_cc_asscontcorres_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cc_asscontcorres_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_cc_asscontcorres where 0=1;

create table ${iol_schema}.icms_cc_asscontcorres_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_cc_asscontcorres where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_cc_asscontcorres_cl(
            contno -- 合同编号
            ,asscontno -- 对应担保合同编号
            ,assconttype -- 担保合同类型 1保证合同 2抵押合同 3质押合同
            ,useassamt -- 担保金额
            ,useasscurrency -- 担保币种
            ,state -- 生效状态 0－未生效，1-生效
            ,state2 -- 到期状态 0-初始值 1-正常到期  2-强制到期 3-发生终止
            ,iscopy -- 是否引用 0：是 1：否
            ,datasourceflag -- 数据来源标志 1-信贷；2-小企业；3-零售；4-新信贷
            ,barsign -- 条线
            ,contype -- 合同类型 1 额度合同  2 贷款合同
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_cc_asscontcorres_op(
            contno -- 合同编号
            ,asscontno -- 对应担保合同编号
            ,assconttype -- 担保合同类型 1保证合同 2抵押合同 3质押合同
            ,useassamt -- 担保金额
            ,useasscurrency -- 担保币种
            ,state -- 生效状态 0－未生效，1-生效
            ,state2 -- 到期状态 0-初始值 1-正常到期  2-强制到期 3-发生终止
            ,iscopy -- 是否引用 0：是 1：否
            ,datasourceflag -- 数据来源标志 1-信贷；2-小企业；3-零售；4-新信贷
            ,barsign -- 条线
            ,contype -- 合同类型 1 额度合同  2 贷款合同
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.contno, o.contno) as contno -- 合同编号
    ,nvl(n.asscontno, o.asscontno) as asscontno -- 对应担保合同编号
    ,nvl(n.assconttype, o.assconttype) as assconttype -- 担保合同类型 1保证合同 2抵押合同 3质押合同
    ,nvl(n.useassamt, o.useassamt) as useassamt -- 担保金额
    ,nvl(n.useasscurrency, o.useasscurrency) as useasscurrency -- 担保币种
    ,nvl(n.state, o.state) as state -- 生效状态 0－未生效，1-生效
    ,nvl(n.state2, o.state2) as state2 -- 到期状态 0-初始值 1-正常到期  2-强制到期 3-发生终止
    ,nvl(n.iscopy, o.iscopy) as iscopy -- 是否引用 0：是 1：否
    ,nvl(n.datasourceflag, o.datasourceflag) as datasourceflag -- 数据来源标志 1-信贷；2-小企业；3-零售；4-新信贷
    ,nvl(n.barsign, o.barsign) as barsign -- 条线
    ,nvl(n.contype, o.contype) as contype -- 合同类型 1 额度合同  2 贷款合同
    ,case when
            n.contno is null
            and n.asscontno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.contno is null
            and n.asscontno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.contno is null
            and n.asscontno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_cc_asscontcorres_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_cc_asscontcorres where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.contno = n.contno
            and o.asscontno = n.asscontno
where (
        o.contno is null
        and o.asscontno is null
    )
    or (
        n.contno is null
        and n.asscontno is null
    )
    or (
        o.assconttype <> n.assconttype
        or o.useassamt <> n.useassamt
        or o.useasscurrency <> n.useasscurrency
        or o.state <> n.state
        or o.state2 <> n.state2
        or o.iscopy <> n.iscopy
        or o.datasourceflag <> n.datasourceflag
        or o.barsign <> n.barsign
        or o.contype <> n.contype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_cc_asscontcorres_cl(
            contno -- 合同编号
            ,asscontno -- 对应担保合同编号
            ,assconttype -- 担保合同类型 1保证合同 2抵押合同 3质押合同
            ,useassamt -- 担保金额
            ,useasscurrency -- 担保币种
            ,state -- 生效状态 0－未生效，1-生效
            ,state2 -- 到期状态 0-初始值 1-正常到期  2-强制到期 3-发生终止
            ,iscopy -- 是否引用 0：是 1：否
            ,datasourceflag -- 数据来源标志 1-信贷；2-小企业；3-零售；4-新信贷
            ,barsign -- 条线
            ,contype -- 合同类型 1 额度合同  2 贷款合同
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_cc_asscontcorres_op(
            contno -- 合同编号
            ,asscontno -- 对应担保合同编号
            ,assconttype -- 担保合同类型 1保证合同 2抵押合同 3质押合同
            ,useassamt -- 担保金额
            ,useasscurrency -- 担保币种
            ,state -- 生效状态 0－未生效，1-生效
            ,state2 -- 到期状态 0-初始值 1-正常到期  2-强制到期 3-发生终止
            ,iscopy -- 是否引用 0：是 1：否
            ,datasourceflag -- 数据来源标志 1-信贷；2-小企业；3-零售；4-新信贷
            ,barsign -- 条线
            ,contype -- 合同类型 1 额度合同  2 贷款合同
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.contno -- 合同编号
    ,o.asscontno -- 对应担保合同编号
    ,o.assconttype -- 担保合同类型 1保证合同 2抵押合同 3质押合同
    ,o.useassamt -- 担保金额
    ,o.useasscurrency -- 担保币种
    ,o.state -- 生效状态 0－未生效，1-生效
    ,o.state2 -- 到期状态 0-初始值 1-正常到期  2-强制到期 3-发生终止
    ,o.iscopy -- 是否引用 0：是 1：否
    ,o.datasourceflag -- 数据来源标志 1-信贷；2-小企业；3-零售；4-新信贷
    ,o.barsign -- 条线
    ,o.contype -- 合同类型 1 额度合同  2 贷款合同
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
from ${iol_schema}.icms_cc_asscontcorres_bk o
    left join ${iol_schema}.icms_cc_asscontcorres_op n
        on
            o.contno = n.contno
            and o.asscontno = n.asscontno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_cc_asscontcorres_cl d
        on
            o.contno = d.contno
            and o.asscontno = d.asscontno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_cc_asscontcorres;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_cc_asscontcorres') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_cc_asscontcorres drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_cc_asscontcorres add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_cc_asscontcorres exchange partition p_${batch_date} with table ${iol_schema}.icms_cc_asscontcorres_cl;
alter table ${iol_schema}.icms_cc_asscontcorres exchange partition p_20991231 with table ${iol_schema}.icms_cc_asscontcorres_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_cc_asscontcorres to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_cc_asscontcorres_op purge;
drop table ${iol_schema}.icms_cc_asscontcorres_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_cc_asscontcorres_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_cc_asscontcorres',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
