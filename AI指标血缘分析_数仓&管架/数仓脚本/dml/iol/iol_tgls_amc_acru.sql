/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_amc_acru
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
create table ${iol_schema}.tgls_amc_acru_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_amc_acru
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_amc_acru_op purge;
drop table ${iol_schema}.tgls_amc_acru_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_amc_acru_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_amc_acru where 0=1;

create table ${iol_schema}.tgls_amc_acru_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_amc_acru where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_amc_acru_cl(
            acruid -- 会计规则表主键
            ,stacid -- 账套标记
            ,busicd -- 业务类型，取值参考数据字典业务类型
            ,prducd -- 产品编号
            ,trancd -- 子交易
            ,acelto -- 目标要素
            ,sortno -- 执行顺序
            ,status -- 是否启用，是为y，否为n
            ,condit -- 限定条件
            ,formul -- 取数公式
            ,groutp -- 多行分组
            ,measno -- 计量规则标号
            ,condna -- 限定条件名称
            ,formna -- 取数公式名称
            ,remark -- 规则说明
            ,condsm -- 取数条件说明
            ,formsm -- 取数公式说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_amc_acru_op(
            acruid -- 会计规则表主键
            ,stacid -- 账套标记
            ,busicd -- 业务类型，取值参考数据字典业务类型
            ,prducd -- 产品编号
            ,trancd -- 子交易
            ,acelto -- 目标要素
            ,sortno -- 执行顺序
            ,status -- 是否启用，是为y，否为n
            ,condit -- 限定条件
            ,formul -- 取数公式
            ,groutp -- 多行分组
            ,measno -- 计量规则标号
            ,condna -- 限定条件名称
            ,formna -- 取数公式名称
            ,remark -- 规则说明
            ,condsm -- 取数条件说明
            ,formsm -- 取数公式说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acruid, o.acruid) as acruid -- 会计规则表主键
    ,nvl(n.stacid, o.stacid) as stacid -- 账套标记
    ,nvl(n.busicd, o.busicd) as busicd -- 业务类型，取值参考数据字典业务类型
    ,nvl(n.prducd, o.prducd) as prducd -- 产品编号
    ,nvl(n.trancd, o.trancd) as trancd -- 子交易
    ,nvl(n.acelto, o.acelto) as acelto -- 目标要素
    ,nvl(n.sortno, o.sortno) as sortno -- 执行顺序
    ,nvl(n.status, o.status) as status -- 是否启用，是为y，否为n
    ,nvl(n.condit, o.condit) as condit -- 限定条件
    ,nvl(n.formul, o.formul) as formul -- 取数公式
    ,nvl(n.groutp, o.groutp) as groutp -- 多行分组
    ,nvl(n.measno, o.measno) as measno -- 计量规则标号
    ,nvl(n.condna, o.condna) as condna -- 限定条件名称
    ,nvl(n.formna, o.formna) as formna -- 取数公式名称
    ,nvl(n.remark, o.remark) as remark -- 规则说明
    ,nvl(n.condsm, o.condsm) as condsm -- 取数条件说明
    ,nvl(n.formsm, o.formsm) as formsm -- 取数公式说明
    ,case when
            n.acruid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.acruid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.acruid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_amc_acru_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_amc_acru where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.acruid = n.acruid
where (
        o.acruid is null
    )
    or (
        n.acruid is null
    )
    or (
        o.stacid <> n.stacid
        or o.busicd <> n.busicd
        or o.prducd <> n.prducd
        or o.trancd <> n.trancd
        or o.acelto <> n.acelto
        or o.sortno <> n.sortno
        or o.status <> n.status
        or o.condit <> n.condit
        or o.formul <> n.formul
        or o.groutp <> n.groutp
        or o.measno <> n.measno
        or o.condna <> n.condna
        or o.formna <> n.formna
        or o.remark <> n.remark
        or o.condsm <> n.condsm
        or o.formsm <> n.formsm
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_amc_acru_cl(
            acruid -- 会计规则表主键
            ,stacid -- 账套标记
            ,busicd -- 业务类型，取值参考数据字典业务类型
            ,prducd -- 产品编号
            ,trancd -- 子交易
            ,acelto -- 目标要素
            ,sortno -- 执行顺序
            ,status -- 是否启用，是为y，否为n
            ,condit -- 限定条件
            ,formul -- 取数公式
            ,groutp -- 多行分组
            ,measno -- 计量规则标号
            ,condna -- 限定条件名称
            ,formna -- 取数公式名称
            ,remark -- 规则说明
            ,condsm -- 取数条件说明
            ,formsm -- 取数公式说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_amc_acru_op(
            acruid -- 会计规则表主键
            ,stacid -- 账套标记
            ,busicd -- 业务类型，取值参考数据字典业务类型
            ,prducd -- 产品编号
            ,trancd -- 子交易
            ,acelto -- 目标要素
            ,sortno -- 执行顺序
            ,status -- 是否启用，是为y，否为n
            ,condit -- 限定条件
            ,formul -- 取数公式
            ,groutp -- 多行分组
            ,measno -- 计量规则标号
            ,condna -- 限定条件名称
            ,formna -- 取数公式名称
            ,remark -- 规则说明
            ,condsm -- 取数条件说明
            ,formsm -- 取数公式说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acruid -- 会计规则表主键
    ,o.stacid -- 账套标记
    ,o.busicd -- 业务类型，取值参考数据字典业务类型
    ,o.prducd -- 产品编号
    ,o.trancd -- 子交易
    ,o.acelto -- 目标要素
    ,o.sortno -- 执行顺序
    ,o.status -- 是否启用，是为y，否为n
    ,o.condit -- 限定条件
    ,o.formul -- 取数公式
    ,o.groutp -- 多行分组
    ,o.measno -- 计量规则标号
    ,o.condna -- 限定条件名称
    ,o.formna -- 取数公式名称
    ,o.remark -- 规则说明
    ,o.condsm -- 取数条件说明
    ,o.formsm -- 取数公式说明
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
from ${iol_schema}.tgls_amc_acru_bk o
    left join ${iol_schema}.tgls_amc_acru_op n
        on
            o.acruid = n.acruid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_amc_acru_cl d
        on
            o.acruid = d.acruid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_amc_acru;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_amc_acru') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_amc_acru drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_amc_acru add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_amc_acru exchange partition p_${batch_date} with table ${iol_schema}.tgls_amc_acru_cl;
alter table ${iol_schema}.tgls_amc_acru exchange partition p_20991231 with table ${iol_schema}.tgls_amc_acru_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_amc_acru to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_amc_acru_op purge;
drop table ${iol_schema}.tgls_amc_acru_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_amc_acru_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_amc_acru',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
