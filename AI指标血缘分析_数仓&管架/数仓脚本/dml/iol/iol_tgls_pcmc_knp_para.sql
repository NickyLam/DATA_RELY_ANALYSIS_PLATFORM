/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_pcmc_knp_para
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
create table ${iol_schema}.tgls_pcmc_knp_para_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_pcmc_knp_para
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_pcmc_knp_para_op purge;
drop table ${iol_schema}.tgls_pcmc_knp_para_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_pcmc_knp_para_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_pcmc_knp_para where 0=1;

create table ${iol_schema}.tgls_pcmc_knp_para_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_pcmc_knp_para where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_pcmc_knp_para_cl(
            subscd -- 子系统编码
            ,paratp -- 参数类型
            ,paracd -- 参数编码
            ,corpcode -- 法人编码
            ,parana -- 参数描述
            ,paraam -- 金额参数
            ,paradt -- 日期参数
            ,parach -- 扩展参数A
            ,parbch -- 扩展参数B
            ,parcch -- 扩展参数C
            ,pardch -- 扩展参数D
            ,parech -- 扩展参数E
            ,sortno -- 排序号
            ,area_no_str -- 区域编码（无效字段）
            ,i18n_code -- 国际化资源编码
            ,disable -- 是否禁用，1禁用optd标签不受影响，其他标签会过滤掉禁用的
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_pcmc_knp_para_op(
            subscd -- 子系统编码
            ,paratp -- 参数类型
            ,paracd -- 参数编码
            ,corpcode -- 法人编码
            ,parana -- 参数描述
            ,paraam -- 金额参数
            ,paradt -- 日期参数
            ,parach -- 扩展参数A
            ,parbch -- 扩展参数B
            ,parcch -- 扩展参数C
            ,pardch -- 扩展参数D
            ,parech -- 扩展参数E
            ,sortno -- 排序号
            ,area_no_str -- 区域编码（无效字段）
            ,i18n_code -- 国际化资源编码
            ,disable -- 是否禁用，1禁用optd标签不受影响，其他标签会过滤掉禁用的
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.subscd, o.subscd) as subscd -- 子系统编码
    ,nvl(n.paratp, o.paratp) as paratp -- 参数类型
    ,nvl(n.paracd, o.paracd) as paracd -- 参数编码
    ,nvl(n.corpcode, o.corpcode) as corpcode -- 法人编码
    ,nvl(n.parana, o.parana) as parana -- 参数描述
    ,nvl(n.paraam, o.paraam) as paraam -- 金额参数
    ,nvl(n.paradt, o.paradt) as paradt -- 日期参数
    ,nvl(n.parach, o.parach) as parach -- 扩展参数A
    ,nvl(n.parbch, o.parbch) as parbch -- 扩展参数B
    ,nvl(n.parcch, o.parcch) as parcch -- 扩展参数C
    ,nvl(n.pardch, o.pardch) as pardch -- 扩展参数D
    ,nvl(n.parech, o.parech) as parech -- 扩展参数E
    ,nvl(n.sortno, o.sortno) as sortno -- 排序号
    ,nvl(n.area_no_str, o.area_no_str) as area_no_str -- 区域编码（无效字段）
    ,nvl(n.i18n_code, o.i18n_code) as i18n_code -- 国际化资源编码
    ,nvl(n.disable, o.disable) as disable -- 是否禁用，1禁用optd标签不受影响，其他标签会过滤掉禁用的
    ,case when
            n.subscd is null
            and n.paratp is null
            and n.paracd is null
            and n.corpcode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.subscd is null
            and n.paratp is null
            and n.paracd is null
            and n.corpcode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.subscd is null
            and n.paratp is null
            and n.paracd is null
            and n.corpcode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_pcmc_knp_para_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_pcmc_knp_para where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.subscd = n.subscd
            and o.paratp = n.paratp
            and o.paracd = n.paracd
            and o.corpcode = n.corpcode
where (
        o.subscd is null
        and o.paratp is null
        and o.paracd is null
        and o.corpcode is null
    )
    or (
        n.subscd is null
        and n.paratp is null
        and n.paracd is null
        and n.corpcode is null
    )
    or (
        o.parana <> n.parana
        or o.paraam <> n.paraam
        or o.paradt <> n.paradt
        or o.parach <> n.parach
        or o.parbch <> n.parbch
        or o.parcch <> n.parcch
        or o.pardch <> n.pardch
        or o.parech <> n.parech
        or o.sortno <> n.sortno
        or o.area_no_str <> n.area_no_str
        or o.i18n_code <> n.i18n_code
        or o.disable <> n.disable
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_pcmc_knp_para_cl(
            subscd -- 子系统编码
            ,paratp -- 参数类型
            ,paracd -- 参数编码
            ,corpcode -- 法人编码
            ,parana -- 参数描述
            ,paraam -- 金额参数
            ,paradt -- 日期参数
            ,parach -- 扩展参数A
            ,parbch -- 扩展参数B
            ,parcch -- 扩展参数C
            ,pardch -- 扩展参数D
            ,parech -- 扩展参数E
            ,sortno -- 排序号
            ,area_no_str -- 区域编码（无效字段）
            ,i18n_code -- 国际化资源编码
            ,disable -- 是否禁用，1禁用optd标签不受影响，其他标签会过滤掉禁用的
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_pcmc_knp_para_op(
            subscd -- 子系统编码
            ,paratp -- 参数类型
            ,paracd -- 参数编码
            ,corpcode -- 法人编码
            ,parana -- 参数描述
            ,paraam -- 金额参数
            ,paradt -- 日期参数
            ,parach -- 扩展参数A
            ,parbch -- 扩展参数B
            ,parcch -- 扩展参数C
            ,pardch -- 扩展参数D
            ,parech -- 扩展参数E
            ,sortno -- 排序号
            ,area_no_str -- 区域编码（无效字段）
            ,i18n_code -- 国际化资源编码
            ,disable -- 是否禁用，1禁用optd标签不受影响，其他标签会过滤掉禁用的
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.subscd -- 子系统编码
    ,o.paratp -- 参数类型
    ,o.paracd -- 参数编码
    ,o.corpcode -- 法人编码
    ,o.parana -- 参数描述
    ,o.paraam -- 金额参数
    ,o.paradt -- 日期参数
    ,o.parach -- 扩展参数A
    ,o.parbch -- 扩展参数B
    ,o.parcch -- 扩展参数C
    ,o.pardch -- 扩展参数D
    ,o.parech -- 扩展参数E
    ,o.sortno -- 排序号
    ,o.area_no_str -- 区域编码（无效字段）
    ,o.i18n_code -- 国际化资源编码
    ,o.disable -- 是否禁用，1禁用optd标签不受影响，其他标签会过滤掉禁用的
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
from ${iol_schema}.tgls_pcmc_knp_para_bk o
    left join ${iol_schema}.tgls_pcmc_knp_para_op n
        on
            o.subscd = n.subscd
            and o.paratp = n.paratp
            and o.paracd = n.paracd
            and o.corpcode = n.corpcode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_pcmc_knp_para_cl d
        on
            o.subscd = d.subscd
            and o.paratp = d.paratp
            and o.paracd = d.paracd
            and o.corpcode = d.corpcode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_pcmc_knp_para;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_pcmc_knp_para') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_pcmc_knp_para drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_pcmc_knp_para add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_pcmc_knp_para exchange partition p_${batch_date} with table ${iol_schema}.tgls_pcmc_knp_para_cl;
alter table ${iol_schema}.tgls_pcmc_knp_para exchange partition p_20991231 with table ${iol_schema}.tgls_pcmc_knp_para_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_pcmc_knp_para to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_pcmc_knp_para_op purge;
drop table ${iol_schema}.tgls_pcmc_knp_para_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_pcmc_knp_para_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_pcmc_knp_para',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
