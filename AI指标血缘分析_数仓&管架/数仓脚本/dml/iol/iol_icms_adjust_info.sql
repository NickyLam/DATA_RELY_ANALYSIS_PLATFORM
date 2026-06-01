/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_adjust_info
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
create table ${iol_schema}.icms_adjust_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_adjust_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_adjust_info_op purge;
drop table ${iol_schema}.icms_adjust_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_adjust_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_adjust_info where 0=1;

create table ${iol_schema}.icms_adjust_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_adjust_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_adjust_info_cl(
            serialno -- 流水号
            ,signname -- 标注名称
            ,migtflag -- 
            ,adjustlevel -- 调整层级
            ,signid -- 关联借据号
            ,inputorgid -- 登记机构
            ,remark -- 备注
            ,updateuserid -- 更新人
            ,inputdate -- 登记时间
            ,type -- 更改类型
            ,updateorgid -- 更新机构
            ,inputuserid -- 登记人
            ,relativeserialno -- 关联流水号
            ,reason -- 更改原因
            ,coverage -- 覆盖范围
            ,adjusttype -- 调整类型
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_adjust_info_op(
            serialno -- 流水号
            ,signname -- 标注名称
            ,migtflag -- 
            ,adjustlevel -- 调整层级
            ,signid -- 关联借据号
            ,inputorgid -- 登记机构
            ,remark -- 备注
            ,updateuserid -- 更新人
            ,inputdate -- 登记时间
            ,type -- 更改类型
            ,updateorgid -- 更新机构
            ,inputuserid -- 登记人
            ,relativeserialno -- 关联流水号
            ,reason -- 更改原因
            ,coverage -- 覆盖范围
            ,adjusttype -- 调整类型
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.signname, o.signname) as signname -- 标注名称
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.adjustlevel, o.adjustlevel) as adjustlevel -- 调整层级
    ,nvl(n.signid, o.signid) as signid -- 关联借据号
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.type, o.type) as type -- 更改类型
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.relativeserialno, o.relativeserialno) as relativeserialno -- 关联流水号
    ,nvl(n.reason, o.reason) as reason -- 更改原因
    ,nvl(n.coverage, o.coverage) as coverage -- 覆盖范围
    ,nvl(n.adjusttype, o.adjusttype) as adjusttype -- 调整类型
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
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
from (select * from ${iol_schema}.icms_adjust_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_adjust_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.signname <> n.signname
        or o.migtflag <> n.migtflag
        or o.adjustlevel <> n.adjustlevel
        or o.signid <> n.signid
        or o.inputorgid <> n.inputorgid
        or o.remark <> n.remark
        or o.updateuserid <> n.updateuserid
        or o.inputdate <> n.inputdate
        or o.type <> n.type
        or o.updateorgid <> n.updateorgid
        or o.inputuserid <> n.inputuserid
        or o.relativeserialno <> n.relativeserialno
        or o.reason <> n.reason
        or o.coverage <> n.coverage
        or o.adjusttype <> n.adjusttype
        or o.updatedate <> n.updatedate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_adjust_info_cl(
            serialno -- 流水号
            ,signname -- 标注名称
            ,migtflag -- 
            ,adjustlevel -- 调整层级
            ,signid -- 关联借据号
            ,inputorgid -- 登记机构
            ,remark -- 备注
            ,updateuserid -- 更新人
            ,inputdate -- 登记时间
            ,type -- 更改类型
            ,updateorgid -- 更新机构
            ,inputuserid -- 登记人
            ,relativeserialno -- 关联流水号
            ,reason -- 更改原因
            ,coverage -- 覆盖范围
            ,adjusttype -- 调整类型
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_adjust_info_op(
            serialno -- 流水号
            ,signname -- 标注名称
            ,migtflag -- 
            ,adjustlevel -- 调整层级
            ,signid -- 关联借据号
            ,inputorgid -- 登记机构
            ,remark -- 备注
            ,updateuserid -- 更新人
            ,inputdate -- 登记时间
            ,type -- 更改类型
            ,updateorgid -- 更新机构
            ,inputuserid -- 登记人
            ,relativeserialno -- 关联流水号
            ,reason -- 更改原因
            ,coverage -- 覆盖范围
            ,adjusttype -- 调整类型
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.signname -- 标注名称
    ,o.migtflag -- 
    ,o.adjustlevel -- 调整层级
    ,o.signid -- 关联借据号
    ,o.inputorgid -- 登记机构
    ,o.remark -- 备注
    ,o.updateuserid -- 更新人
    ,o.inputdate -- 登记时间
    ,o.type -- 更改类型
    ,o.updateorgid -- 更新机构
    ,o.inputuserid -- 登记人
    ,o.relativeserialno -- 关联流水号
    ,o.reason -- 更改原因
    ,o.coverage -- 覆盖范围
    ,o.adjusttype -- 调整类型
    ,o.updatedate -- 更新时间
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
from ${iol_schema}.icms_adjust_info_bk o
    left join ${iol_schema}.icms_adjust_info_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_adjust_info_cl d
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
--truncate table ${iol_schema}.icms_adjust_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_adjust_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_adjust_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_adjust_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_adjust_info exchange partition p_${batch_date} with table ${iol_schema}.icms_adjust_info_cl;
alter table ${iol_schema}.icms_adjust_info exchange partition p_20991231 with table ${iol_schema}.icms_adjust_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_adjust_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_adjust_info_op purge;
drop table ${iol_schema}.icms_adjust_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_adjust_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_adjust_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
