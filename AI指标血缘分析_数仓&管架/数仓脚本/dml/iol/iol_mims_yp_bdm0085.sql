/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_yp_bdm0085
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
create table ${iol_schema}.mims_yp_bdm0085_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_yp_bdm0085
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_yp_bdm0085_op purge;
drop table ${iol_schema}.mims_yp_bdm0085_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_yp_bdm0085_op nologging
for exchange with table
${iol_schema}.mims_yp_bdm0085;

create table ${iol_schema}.mims_yp_bdm0085_cl nologging
for exchange with table
${iol_schema}.mims_yp_bdm0085;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_yp_bdm0085_cl(
            sccode -- 押品编号
            ,collztnno -- 信贷合同号
            ,bailaccount -- 保证金号
            ,customerno -- 客户号
            ,creditcustno -- 授信占用方客户号
            ,collztntlrcd -- 信贷客户经理柜员号
            ,collztnbranchid -- 信贷客户经理所属机构名称
            ,swtbizid -- 业务流水号
            ,flag -- 冻结标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_yp_bdm0085_op(
            sccode -- 押品编号
            ,collztnno -- 信贷合同号
            ,bailaccount -- 保证金号
            ,customerno -- 客户号
            ,creditcustno -- 授信占用方客户号
            ,collztntlrcd -- 信贷客户经理柜员号
            ,collztnbranchid -- 信贷客户经理所属机构名称
            ,swtbizid -- 业务流水号
            ,flag -- 冻结标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sccode, o.sccode) as sccode -- 押品编号
    ,nvl(n.collztnno, o.collztnno) as collztnno -- 信贷合同号
    ,nvl(n.bailaccount, o.bailaccount) as bailaccount -- 保证金号
    ,nvl(n.customerno, o.customerno) as customerno -- 客户号
    ,nvl(n.creditcustno, o.creditcustno) as creditcustno -- 授信占用方客户号
    ,nvl(n.collztntlrcd, o.collztntlrcd) as collztntlrcd -- 信贷客户经理柜员号
    ,nvl(n.collztnbranchid, o.collztnbranchid) as collztnbranchid -- 信贷客户经理所属机构名称
    ,nvl(n.swtbizid, o.swtbizid) as swtbizid -- 业务流水号
    ,nvl(n.flag, o.flag) as flag -- 冻结标识
    ,case when
            n.sccode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sccode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sccode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_yp_bdm0085_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_yp_bdm0085 where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sccode = n.sccode
where (
        o.sccode is null
    )
    or (
        n.sccode is null
    )
    or (
        o.collztnno <> n.collztnno
        or o.bailaccount <> n.bailaccount
        or o.customerno <> n.customerno
        or o.creditcustno <> n.creditcustno
        or o.collztntlrcd <> n.collztntlrcd
        or o.collztnbranchid <> n.collztnbranchid
        or o.swtbizid <> n.swtbizid
        or o.flag <> n.flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_yp_bdm0085_cl(
            sccode -- 押品编号
            ,collztnno -- 信贷合同号
            ,bailaccount -- 保证金号
            ,customerno -- 客户号
            ,creditcustno -- 授信占用方客户号
            ,collztntlrcd -- 信贷客户经理柜员号
            ,collztnbranchid -- 信贷客户经理所属机构名称
            ,swtbizid -- 业务流水号
            ,flag -- 冻结标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_yp_bdm0085_op(
            sccode -- 押品编号
            ,collztnno -- 信贷合同号
            ,bailaccount -- 保证金号
            ,customerno -- 客户号
            ,creditcustno -- 授信占用方客户号
            ,collztntlrcd -- 信贷客户经理柜员号
            ,collztnbranchid -- 信贷客户经理所属机构名称
            ,swtbizid -- 业务流水号
            ,flag -- 冻结标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sccode -- 押品编号
    ,o.collztnno -- 信贷合同号
    ,o.bailaccount -- 保证金号
    ,o.customerno -- 客户号
    ,o.creditcustno -- 授信占用方客户号
    ,o.collztntlrcd -- 信贷客户经理柜员号
    ,o.collztnbranchid -- 信贷客户经理所属机构名称
    ,o.swtbizid -- 业务流水号
    ,o.flag -- 冻结标识
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
from ${iol_schema}.mims_yp_bdm0085_bk o
    left join ${iol_schema}.mims_yp_bdm0085_op n
        on
            o.sccode = n.sccode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_yp_bdm0085_cl d
        on
            o.sccode = d.sccode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mims_yp_bdm0085;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mims_yp_bdm0085') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mims_yp_bdm0085 drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mims_yp_bdm0085 add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mims_yp_bdm0085 exchange partition p_${batch_date} with table ${iol_schema}.mims_yp_bdm0085_cl;
alter table ${iol_schema}.mims_yp_bdm0085 exchange partition p_20991231 with table ${iol_schema}.mims_yp_bdm0085_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_yp_bdm0085 to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_yp_bdm0085_op purge;
drop table ${iol_schema}.mims_yp_bdm0085_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_yp_bdm0085_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_yp_bdm0085',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
