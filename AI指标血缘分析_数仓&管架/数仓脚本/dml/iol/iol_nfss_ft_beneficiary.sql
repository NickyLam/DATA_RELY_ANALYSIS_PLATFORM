/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_ft_beneficiary
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
create table ${iol_schema}.nfss_ft_beneficiary_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_ft_beneficiary
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_ft_beneficiary_op purge;
drop table ${iol_schema}.nfss_ft_beneficiary_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_ft_beneficiary_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_ft_beneficiary where 0=1;

create table ${iol_schema}.nfss_ft_beneficiary_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_ft_beneficiary where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_ft_beneficiary_cl(
            id -- 主键序号
            ,product_id -- 产品id
            ,nationnality -- 国籍
            ,name -- 受益人姓名
            ,phone -- 受益人手机号
            ,id_type -- 受益人证件类型
            ,id_no -- 受益人证件号码
            ,valid_time -- 证件有效期
            ,created_by -- 创建者
            ,updated_by -- 修改者
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_ft_beneficiary_op(
            id -- 主键序号
            ,product_id -- 产品id
            ,nationnality -- 国籍
            ,name -- 受益人姓名
            ,phone -- 受益人手机号
            ,id_type -- 受益人证件类型
            ,id_no -- 受益人证件号码
            ,valid_time -- 证件有效期
            ,created_by -- 创建者
            ,updated_by -- 修改者
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键序号
    ,nvl(n.product_id, o.product_id) as product_id -- 产品id
    ,nvl(n.nationnality, o.nationnality) as nationnality -- 国籍
    ,nvl(n.name, o.name) as name -- 受益人姓名
    ,nvl(n.phone, o.phone) as phone -- 受益人手机号
    ,nvl(n.id_type, o.id_type) as id_type -- 受益人证件类型
    ,nvl(n.id_no, o.id_no) as id_no -- 受益人证件号码
    ,nvl(n.valid_time, o.valid_time) as valid_time -- 证件有效期
    ,nvl(n.created_by, o.created_by) as created_by -- 创建者
    ,nvl(n.updated_by, o.updated_by) as updated_by -- 修改者
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 修改时间
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nfss_ft_beneficiary_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_ft_beneficiary where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.product_id <> n.product_id
        or o.nationnality <> n.nationnality
        or o.name <> n.name
        or o.phone <> n.phone
        or o.id_type <> n.id_type
        or o.id_no <> n.id_no
        or o.valid_time <> n.valid_time
        or o.created_by <> n.created_by
        or o.updated_by <> n.updated_by
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_ft_beneficiary_cl(
            id -- 主键序号
            ,product_id -- 产品id
            ,nationnality -- 国籍
            ,name -- 受益人姓名
            ,phone -- 受益人手机号
            ,id_type -- 受益人证件类型
            ,id_no -- 受益人证件号码
            ,valid_time -- 证件有效期
            ,created_by -- 创建者
            ,updated_by -- 修改者
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_ft_beneficiary_op(
            id -- 主键序号
            ,product_id -- 产品id
            ,nationnality -- 国籍
            ,name -- 受益人姓名
            ,phone -- 受益人手机号
            ,id_type -- 受益人证件类型
            ,id_no -- 受益人证件号码
            ,valid_time -- 证件有效期
            ,created_by -- 创建者
            ,updated_by -- 修改者
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键序号
    ,o.product_id -- 产品id
    ,o.nationnality -- 国籍
    ,o.name -- 受益人姓名
    ,o.phone -- 受益人手机号
    ,o.id_type -- 受益人证件类型
    ,o.id_no -- 受益人证件号码
    ,o.valid_time -- 证件有效期
    ,o.created_by -- 创建者
    ,o.updated_by -- 修改者
    ,o.create_time -- 创建时间
    ,o.update_time -- 修改时间
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
from ${iol_schema}.nfss_ft_beneficiary_bk o
    left join ${iol_schema}.nfss_ft_beneficiary_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_ft_beneficiary_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nfss_ft_beneficiary;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nfss_ft_beneficiary') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nfss_ft_beneficiary drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nfss_ft_beneficiary add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nfss_ft_beneficiary exchange partition p_${batch_date} with table ${iol_schema}.nfss_ft_beneficiary_cl;
alter table ${iol_schema}.nfss_ft_beneficiary exchange partition p_20991231 with table ${iol_schema}.nfss_ft_beneficiary_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_ft_beneficiary to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_ft_beneficiary_op purge;
drop table ${iol_schema}.nfss_ft_beneficiary_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_ft_beneficiary_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_ft_beneficiary',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
