/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_rpinform_pub
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
create table ${iol_schema}.icms_rpinform_pub_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_rpinform_pub
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_rpinform_pub_op purge;
drop table ${iol_schema}.icms_rpinform_pub_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_rpinform_pub_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_rpinform_pub where 0=1;

create table ${iol_schema}.icms_rpinform_pub_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_rpinform_pub where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_rpinform_pub_cl(
            serialno -- 流水号
            ,credit_id2 -- 证件号码2(组织机构代码/统一社会信用代码)
            ,bash_date -- 日期
            ,relative_name -- 关联方名称
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,business_type -- 业务类型
            ,relative_id -- 关联方编号
            ,job -- 担任职务或关联关系
            ,credit_id1 -- 关联方证件号码
            ,remark -- 备注
            ,shares_percent -- 持股比例
            ,relative_parent_id -- 上级关联方编号
            ,relationship -- 关联关系类型
            ,belong_org_name -- 单位归属的企业集团全称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_rpinform_pub_op(
            serialno -- 流水号
            ,credit_id2 -- 证件号码2(组织机构代码/统一社会信用代码)
            ,bash_date -- 日期
            ,relative_name -- 关联方名称
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,business_type -- 业务类型
            ,relative_id -- 关联方编号
            ,job -- 担任职务或关联关系
            ,credit_id1 -- 关联方证件号码
            ,remark -- 备注
            ,shares_percent -- 持股比例
            ,relative_parent_id -- 上级关联方编号
            ,relationship -- 关联关系类型
            ,belong_org_name -- 单位归属的企业集团全称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.credit_id2, o.credit_id2) as credit_id2 -- 证件号码2(组织机构代码/统一社会信用代码)
    ,nvl(n.bash_date, o.bash_date) as bash_date -- 日期
    ,nvl(n.relative_name, o.relative_name) as relative_name -- 关联方名称
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.business_type, o.business_type) as business_type -- 业务类型
    ,nvl(n.relative_id, o.relative_id) as relative_id -- 关联方编号
    ,nvl(n.job, o.job) as job -- 担任职务或关联关系
    ,nvl(n.credit_id1, o.credit_id1) as credit_id1 -- 关联方证件号码
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.shares_percent, o.shares_percent) as shares_percent -- 持股比例
    ,nvl(n.relative_parent_id, o.relative_parent_id) as relative_parent_id -- 上级关联方编号
    ,nvl(n.relationship, o.relationship) as relationship -- 关联关系类型
    ,nvl(n.belong_org_name, o.belong_org_name) as belong_org_name -- 单位归属的企业集团全称
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_rpinform_pub_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_rpinform_pub where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.credit_id2 <> n.credit_id2
        or o.bash_date <> n.bash_date
        or o.relative_name <> n.relative_name
        or o.migtflag <> n.migtflag
        or o.business_type <> n.business_type
        or o.relative_id <> n.relative_id
        or o.job <> n.job
        or o.credit_id1 <> n.credit_id1
        or o.remark <> n.remark
        or o.shares_percent <> n.shares_percent
        or o.relative_parent_id <> n.relative_parent_id
        or o.relationship <> n.relationship
        or o.belong_org_name <> n.belong_org_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_rpinform_pub_cl(
            serialno -- 流水号
            ,credit_id2 -- 证件号码2(组织机构代码/统一社会信用代码)
            ,bash_date -- 日期
            ,relative_name -- 关联方名称
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,business_type -- 业务类型
            ,relative_id -- 关联方编号
            ,job -- 担任职务或关联关系
            ,credit_id1 -- 关联方证件号码
            ,remark -- 备注
            ,shares_percent -- 持股比例
            ,relative_parent_id -- 上级关联方编号
            ,relationship -- 关联关系类型
            ,belong_org_name -- 单位归属的企业集团全称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_rpinform_pub_op(
            serialno -- 流水号
            ,credit_id2 -- 证件号码2(组织机构代码/统一社会信用代码)
            ,bash_date -- 日期
            ,relative_name -- 关联方名称
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,business_type -- 业务类型
            ,relative_id -- 关联方编号
            ,job -- 担任职务或关联关系
            ,credit_id1 -- 关联方证件号码
            ,remark -- 备注
            ,shares_percent -- 持股比例
            ,relative_parent_id -- 上级关联方编号
            ,relationship -- 关联关系类型
            ,belong_org_name -- 单位归属的企业集团全称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.credit_id2 -- 证件号码2(组织机构代码/统一社会信用代码)
    ,o.bash_date -- 日期
    ,o.relative_name -- 关联方名称
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.business_type -- 业务类型
    ,o.relative_id -- 关联方编号
    ,o.job -- 担任职务或关联关系
    ,o.credit_id1 -- 关联方证件号码
    ,o.remark -- 备注
    ,o.shares_percent -- 持股比例
    ,o.relative_parent_id -- 上级关联方编号
    ,o.relationship -- 关联关系类型
    ,o.belong_org_name -- 单位归属的企业集团全称
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
from ${iol_schema}.icms_rpinform_pub_bk o
    left join ${iol_schema}.icms_rpinform_pub_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_rpinform_pub_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_rpinform_pub;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_rpinform_pub') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_rpinform_pub drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_rpinform_pub add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_rpinform_pub exchange partition p_${batch_date} with table ${iol_schema}.icms_rpinform_pub_cl;
alter table ${iol_schema}.icms_rpinform_pub exchange partition p_20991231 with table ${iol_schema}.icms_rpinform_pub_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_rpinform_pub to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_rpinform_pub_op purge;
drop table ${iol_schema}.icms_rpinform_pub_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_rpinform_pub_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_rpinform_pub',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
