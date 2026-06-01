/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_securityinfo
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
create table ${iol_schema}.mims_si_securityinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_si_securityinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_securityinfo_op purge;
drop table ${iol_schema}.mims_si_securityinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_securityinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_securityinfo where 0=1;

create table ${iol_schema}.mims_si_securityinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_securityinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_securityinfo_cl(
            sccode -- 
            ,guartype -- 
            ,createuser -- 
            ,deptcode -- 
            ,createdate -- 
            ,conominium -- 
            ,conshare -- 
            ,effecttype -- 
            ,isinsure -- 
            ,guaregisterstate -- 
            ,guainsurestate -- 
            ,state -- 
            ,usestate -- 
            ,guaspecialstate -- 
            ,bxability -- 
            ,isotherguar -- 
            ,isgencust -- 
            ,confmamt -- 
            ,confmcurrency -- 
            ,evaldate -- 
            ,datasourceflag -- 
            ,exapstate -- 
            ,editstate -- 
            ,bxability2 -- 
            ,isgain -- 
            ,ismodify -- 
            ,guarinfoname -- 
            ,controlchange -- 
            ,updates -- 
            ,upduser -- 
            ,issaveowner -- 是否保存我行
            ,amount -- 优先受偿权数额
            ,issequence -- 是否第一顺位 C0101         0 否、1 是
            ,guarsign -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_securityinfo_op(
            sccode -- 
            ,guartype -- 
            ,createuser -- 
            ,deptcode -- 
            ,createdate -- 
            ,conominium -- 
            ,conshare -- 
            ,effecttype -- 
            ,isinsure -- 
            ,guaregisterstate -- 
            ,guainsurestate -- 
            ,state -- 
            ,usestate -- 
            ,guaspecialstate -- 
            ,bxability -- 
            ,isotherguar -- 
            ,isgencust -- 
            ,confmamt -- 
            ,confmcurrency -- 
            ,evaldate -- 
            ,datasourceflag -- 
            ,exapstate -- 
            ,editstate -- 
            ,bxability2 -- 
            ,isgain -- 
            ,ismodify -- 
            ,guarinfoname -- 
            ,controlchange -- 
            ,updates -- 
            ,upduser -- 
            ,issaveowner -- 是否保存我行
            ,amount -- 优先受偿权数额
            ,issequence -- 是否第一顺位 C0101         0 否、1 是
            ,guarsign -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sccode, o.sccode) as sccode -- 
    ,nvl(n.guartype, o.guartype) as guartype -- 
    ,nvl(n.createuser, o.createuser) as createuser -- 
    ,nvl(n.deptcode, o.deptcode) as deptcode -- 
    ,nvl(n.createdate, o.createdate) as createdate -- 
    ,nvl(n.conominium, o.conominium) as conominium -- 
    ,nvl(n.conshare, o.conshare) as conshare -- 
    ,nvl(n.effecttype, o.effecttype) as effecttype -- 
    ,nvl(n.isinsure, o.isinsure) as isinsure -- 
    ,nvl(n.guaregisterstate, o.guaregisterstate) as guaregisterstate -- 
    ,nvl(n.guainsurestate, o.guainsurestate) as guainsurestate -- 
    ,nvl(n.state, o.state) as state -- 
    ,nvl(n.usestate, o.usestate) as usestate -- 
    ,nvl(n.guaspecialstate, o.guaspecialstate) as guaspecialstate -- 
    ,nvl(n.bxability, o.bxability) as bxability -- 
    ,nvl(n.isotherguar, o.isotherguar) as isotherguar -- 
    ,nvl(n.isgencust, o.isgencust) as isgencust -- 
    ,nvl(n.confmamt, o.confmamt) as confmamt -- 
    ,nvl(n.confmcurrency, o.confmcurrency) as confmcurrency -- 
    ,nvl(n.evaldate, o.evaldate) as evaldate -- 
    ,nvl(n.datasourceflag, o.datasourceflag) as datasourceflag -- 
    ,nvl(n.exapstate, o.exapstate) as exapstate -- 
    ,nvl(n.editstate, o.editstate) as editstate -- 
    ,nvl(n.bxability2, o.bxability2) as bxability2 -- 
    ,nvl(n.isgain, o.isgain) as isgain -- 
    ,nvl(n.ismodify, o.ismodify) as ismodify -- 
    ,nvl(n.guarinfoname, o.guarinfoname) as guarinfoname -- 
    ,nvl(n.controlchange, o.controlchange) as controlchange -- 
    ,nvl(n.updates, o.updates) as updates -- 
    ,nvl(n.upduser, o.upduser) as upduser -- 
    ,nvl(n.issaveowner, o.issaveowner) as issaveowner -- 是否保存我行
    ,nvl(n.amount, o.amount) as amount -- 优先受偿权数额
    ,nvl(n.issequence, o.issequence) as issequence -- 是否第一顺位 C0101         0 否、1 是
    ,nvl(n.guarsign, o.guarsign) as guarsign -- 
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
from (select * from ${iol_schema}.mims_si_securityinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_si_securityinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sccode = n.sccode
where (
        o.sccode is null
    )
    or (
        n.sccode is null
    )
    or (
        o.guartype <> n.guartype
        or o.createuser <> n.createuser
        or o.deptcode <> n.deptcode
        or o.createdate <> n.createdate
        or o.conominium <> n.conominium
        or o.conshare <> n.conshare
        or o.effecttype <> n.effecttype
        or o.isinsure <> n.isinsure
        or o.guaregisterstate <> n.guaregisterstate
        or o.guainsurestate <> n.guainsurestate
        or o.state <> n.state
        or o.usestate <> n.usestate
        or o.guaspecialstate <> n.guaspecialstate
        or o.bxability <> n.bxability
        or o.isotherguar <> n.isotherguar
        or o.isgencust <> n.isgencust
        or o.confmamt <> n.confmamt
        or o.confmcurrency <> n.confmcurrency
        or o.evaldate <> n.evaldate
        or o.datasourceflag <> n.datasourceflag
        or o.exapstate <> n.exapstate
        or o.editstate <> n.editstate
        or o.bxability2 <> n.bxability2
        or o.isgain <> n.isgain
        or o.ismodify <> n.ismodify
        or o.guarinfoname <> n.guarinfoname
        or o.controlchange <> n.controlchange
        or o.updates <> n.updates
        or o.upduser <> n.upduser
        or o.issaveowner <> n.issaveowner
        or o.amount <> n.amount
        or o.issequence <> n.issequence
        or o.guarsign <> n.guarsign
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_securityinfo_cl(
            sccode -- 
            ,guartype -- 
            ,createuser -- 
            ,deptcode -- 
            ,createdate -- 
            ,conominium -- 
            ,conshare -- 
            ,effecttype -- 
            ,isinsure -- 
            ,guaregisterstate -- 
            ,guainsurestate -- 
            ,state -- 
            ,usestate -- 
            ,guaspecialstate -- 
            ,bxability -- 
            ,isotherguar -- 
            ,isgencust -- 
            ,confmamt -- 
            ,confmcurrency -- 
            ,evaldate -- 
            ,datasourceflag -- 
            ,exapstate -- 
            ,editstate -- 
            ,bxability2 -- 
            ,isgain -- 
            ,ismodify -- 
            ,guarinfoname -- 
            ,controlchange -- 
            ,updates -- 
            ,upduser -- 
            ,issaveowner -- 是否保存我行
            ,amount -- 优先受偿权数额
            ,issequence -- 是否第一顺位 C0101         0 否、1 是
            ,guarsign -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_securityinfo_op(
            sccode -- 
            ,guartype -- 
            ,createuser -- 
            ,deptcode -- 
            ,createdate -- 
            ,conominium -- 
            ,conshare -- 
            ,effecttype -- 
            ,isinsure -- 
            ,guaregisterstate -- 
            ,guainsurestate -- 
            ,state -- 
            ,usestate -- 
            ,guaspecialstate -- 
            ,bxability -- 
            ,isotherguar -- 
            ,isgencust -- 
            ,confmamt -- 
            ,confmcurrency -- 
            ,evaldate -- 
            ,datasourceflag -- 
            ,exapstate -- 
            ,editstate -- 
            ,bxability2 -- 
            ,isgain -- 
            ,ismodify -- 
            ,guarinfoname -- 
            ,controlchange -- 
            ,updates -- 
            ,upduser -- 
            ,issaveowner -- 是否保存我行
            ,amount -- 优先受偿权数额
            ,issequence -- 是否第一顺位 C0101         0 否、1 是
            ,guarsign -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sccode -- 
    ,o.guartype -- 
    ,o.createuser -- 
    ,o.deptcode -- 
    ,o.createdate -- 
    ,o.conominium -- 
    ,o.conshare -- 
    ,o.effecttype -- 
    ,o.isinsure -- 
    ,o.guaregisterstate -- 
    ,o.guainsurestate -- 
    ,o.state -- 
    ,o.usestate -- 
    ,o.guaspecialstate -- 
    ,o.bxability -- 
    ,o.isotherguar -- 
    ,o.isgencust -- 
    ,o.confmamt -- 
    ,o.confmcurrency -- 
    ,o.evaldate -- 
    ,o.datasourceflag -- 
    ,o.exapstate -- 
    ,o.editstate -- 
    ,o.bxability2 -- 
    ,o.isgain -- 
    ,o.ismodify -- 
    ,o.guarinfoname -- 
    ,o.controlchange -- 
    ,o.updates -- 
    ,o.upduser -- 
    ,o.issaveowner -- 是否保存我行
    ,o.amount -- 优先受偿权数额
    ,o.issequence -- 是否第一顺位 C0101         0 否、1 是
    ,o.guarsign -- 
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
from ${iol_schema}.mims_si_securityinfo_bk o
    left join ${iol_schema}.mims_si_securityinfo_op n
        on
            o.sccode = n.sccode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_si_securityinfo_cl d
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
--truncate table ${iol_schema}.mims_si_securityinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mims_si_securityinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mims_si_securityinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mims_si_securityinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mims_si_securityinfo exchange partition p_${batch_date} with table ${iol_schema}.mims_si_securityinfo_cl;
alter table ${iol_schema}.mims_si_securityinfo exchange partition p_20991231 with table ${iol_schema}.mims_si_securityinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_si_securityinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_securityinfo_op purge;
drop table ${iol_schema}.mims_si_securityinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_si_securityinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_si_securityinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
