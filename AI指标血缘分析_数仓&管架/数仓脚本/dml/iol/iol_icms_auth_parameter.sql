/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_auth_parameter
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
create table ${iol_schema}.icms_auth_parameter_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_auth_parameter
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_auth_parameter_op purge;
drop table ${iol_schema}.icms_auth_parameter_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_auth_parameter_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_auth_parameter where 0=1;

create table ${iol_schema}.icms_auth_parameter_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_auth_parameter where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_auth_parameter_cl(
            parameterid -- 参数编号
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,parameterclassification -- 参数分类
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,parametername -- 参数名称
            ,rangetype -- 值域类型值域类型(sql/码值/金额/数值/日期)
            ,updatedate -- 更新日期
            ,parametertype -- 参数类型参数类型（字符型等）
            ,datarange -- 值域
            ,status -- 状态状态(启用、停用)
            ,inputdate -- 登记日期
            ,remark -- 备注
            ,businesssql -- 执行sql
            ,rangesqlkey -- 取值范围sql
            ,corporgid -- 法人机构编号
            ,entityattribute -- 实体属性
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_auth_parameter_op(
            parameterid -- 参数编号
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,parameterclassification -- 参数分类
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,parametername -- 参数名称
            ,rangetype -- 值域类型值域类型(sql/码值/金额/数值/日期)
            ,updatedate -- 更新日期
            ,parametertype -- 参数类型参数类型（字符型等）
            ,datarange -- 值域
            ,status -- 状态状态(启用、停用)
            ,inputdate -- 登记日期
            ,remark -- 备注
            ,businesssql -- 执行sql
            ,rangesqlkey -- 取值范围sql
            ,corporgid -- 法人机构编号
            ,entityattribute -- 实体属性
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.parameterid, o.parameterid) as parameterid -- 参数编号
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.parameterclassification, o.parameterclassification) as parameterclassification -- 参数分类
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.parametername, o.parametername) as parametername -- 参数名称
    ,nvl(n.rangetype, o.rangetype) as rangetype -- 值域类型值域类型(sql/码值/金额/数值/日期)
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.parametertype, o.parametertype) as parametertype -- 参数类型参数类型（字符型等）
    ,nvl(n.datarange, o.datarange) as datarange -- 值域
    ,nvl(n.status, o.status) as status -- 状态状态(启用、停用)
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.businesssql, o.businesssql) as businesssql -- 执行sql
    ,nvl(n.rangesqlkey, o.rangesqlkey) as rangesqlkey -- 取值范围sql
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.entityattribute, o.entityattribute) as entityattribute -- 实体属性
    ,case when
            n.parameterid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.parameterid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.parameterid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_auth_parameter_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_auth_parameter where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.parameterid = n.parameterid
where (
        o.parameterid is null
    )
    or (
        n.parameterid is null
    )
    or (
        o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.parameterclassification <> n.parameterclassification
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.parametername <> n.parametername
        or o.rangetype <> n.rangetype
        or o.updatedate <> n.updatedate
        or o.parametertype <> n.parametertype
        or o.datarange <> n.datarange
        or o.status <> n.status
        or o.inputdate <> n.inputdate
        or o.remark <> n.remark
        or o.businesssql <> n.businesssql
        or o.rangesqlkey <> n.rangesqlkey
        or o.corporgid <> n.corporgid
        or o.entityattribute <> n.entityattribute
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_auth_parameter_cl(
            parameterid -- 参数编号
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,parameterclassification -- 参数分类
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,parametername -- 参数名称
            ,rangetype -- 值域类型值域类型(sql/码值/金额/数值/日期)
            ,updatedate -- 更新日期
            ,parametertype -- 参数类型参数类型（字符型等）
            ,datarange -- 值域
            ,status -- 状态状态(启用、停用)
            ,inputdate -- 登记日期
            ,remark -- 备注
            ,businesssql -- 执行sql
            ,rangesqlkey -- 取值范围sql
            ,corporgid -- 法人机构编号
            ,entityattribute -- 实体属性
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_auth_parameter_op(
            parameterid -- 参数编号
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,parameterclassification -- 参数分类
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,parametername -- 参数名称
            ,rangetype -- 值域类型值域类型(sql/码值/金额/数值/日期)
            ,updatedate -- 更新日期
            ,parametertype -- 参数类型参数类型（字符型等）
            ,datarange -- 值域
            ,status -- 状态状态(启用、停用)
            ,inputdate -- 登记日期
            ,remark -- 备注
            ,businesssql -- 执行sql
            ,rangesqlkey -- 取值范围sql
            ,corporgid -- 法人机构编号
            ,entityattribute -- 实体属性
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.parameterid -- 参数编号
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.parameterclassification -- 参数分类
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.parametername -- 参数名称
    ,o.rangetype -- 值域类型值域类型(sql/码值/金额/数值/日期)
    ,o.updatedate -- 更新日期
    ,o.parametertype -- 参数类型参数类型（字符型等）
    ,o.datarange -- 值域
    ,o.status -- 状态状态(启用、停用)
    ,o.inputdate -- 登记日期
    ,o.remark -- 备注
    ,o.businesssql -- 执行sql
    ,o.rangesqlkey -- 取值范围sql
    ,o.corporgid -- 法人机构编号
    ,o.entityattribute -- 实体属性
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
from ${iol_schema}.icms_auth_parameter_bk o
    left join ${iol_schema}.icms_auth_parameter_op n
        on
            o.parameterid = n.parameterid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_auth_parameter_cl d
        on
            o.parameterid = d.parameterid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_auth_parameter;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_auth_parameter') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_auth_parameter drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_auth_parameter add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_auth_parameter exchange partition p_${batch_date} with table ${iol_schema}.icms_auth_parameter_cl;
alter table ${iol_schema}.icms_auth_parameter exchange partition p_20991231 with table ${iol_schema}.icms_auth_parameter_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_auth_parameter to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_auth_parameter_op purge;
drop table ${iol_schema}.icms_auth_parameter_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_auth_parameter_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_auth_parameter',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
