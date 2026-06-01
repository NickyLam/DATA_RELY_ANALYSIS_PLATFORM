/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_ptl_sec_position
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
create table ${iol_schema}.fams_ptl_sec_position_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_ptl_sec_position;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_ptl_sec_position_op purge;
drop table ${iol_schema}.fams_ptl_sec_position_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_ptl_sec_position_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_ptl_sec_position where 0=1;

create table ${iol_schema}.fams_ptl_sec_position_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_ptl_sec_position where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_ptl_sec_position_cl(
            portfolio_id -- 组合代码
            ,sec_acct_id -- 证券管理账户/通道代码，无通道无证券管理账户的存999999
            ,finprod_id -- 金融产品代码
            ,branch -- 分支序号
            ,inv_aim -- 投资目的，无投资目的的存999999
            ,hoding_type -- 持仓类型，实际、在途、质押、融入、融出
            ,cdate -- 日期
            ,amount -- 数量
            ,ccy -- 币种，资产对应的币种
            ,p_finprod_id -- 母金融产品代码
            ,face_value -- 百元面值
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_ptl_sec_position_op(
            portfolio_id -- 组合代码
            ,sec_acct_id -- 证券管理账户/通道代码，无通道无证券管理账户的存999999
            ,finprod_id -- 金融产品代码
            ,branch -- 分支序号
            ,inv_aim -- 投资目的，无投资目的的存999999
            ,hoding_type -- 持仓类型，实际、在途、质押、融入、融出
            ,cdate -- 日期
            ,amount -- 数量
            ,ccy -- 币种，资产对应的币种
            ,p_finprod_id -- 母金融产品代码
            ,face_value -- 百元面值
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.portfolio_id, o.portfolio_id) as portfolio_id -- 组合代码
    ,nvl(n.sec_acct_id, o.sec_acct_id) as sec_acct_id -- 证券管理账户/通道代码，无通道无证券管理账户的存999999
    ,nvl(n.finprod_id, o.finprod_id) as finprod_id -- 金融产品代码
    ,nvl(n.branch, o.branch) as branch -- 分支序号
    ,nvl(n.inv_aim, o.inv_aim) as inv_aim -- 投资目的，无投资目的的存999999
    ,nvl(n.hoding_type, o.hoding_type) as hoding_type -- 持仓类型，实际、在途、质押、融入、融出
    ,nvl(n.cdate, o.cdate) as cdate -- 日期
    ,nvl(n.amount, o.amount) as amount -- 数量
    ,nvl(n.ccy, o.ccy) as ccy -- 币种，资产对应的币种
    ,nvl(n.p_finprod_id, o.p_finprod_id) as p_finprod_id -- 母金融产品代码
    ,nvl(n.face_value, o.face_value) as face_value -- 百元面值
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,case when
            n.portfolio_id is null
            and n.sec_acct_id is null
            and n.finprod_id is null
            and n.branch is null
            and n.inv_aim is null
            and n.hoding_type is null
            and n.cdate is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.portfolio_id is null
            and n.sec_acct_id is null
            and n.finprod_id is null
            and n.branch is null
            and n.inv_aim is null
            and n.hoding_type is null
            and n.cdate is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.portfolio_id is null
            and n.sec_acct_id is null
            and n.finprod_id is null
            and n.branch is null
            and n.inv_aim is null
            and n.hoding_type is null
            and n.cdate is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_ptl_sec_position_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_ptl_sec_position where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.portfolio_id = n.portfolio_id
            and o.sec_acct_id = n.sec_acct_id
            and o.finprod_id = n.finprod_id
            and o.branch = n.branch
            and o.inv_aim = n.inv_aim
            and o.hoding_type = n.hoding_type
            and o.cdate = n.cdate
where (
        o.portfolio_id is null
        and o.sec_acct_id is null
        and o.finprod_id is null
        and o.branch is null
        and o.inv_aim is null
        and o.hoding_type is null
        and o.cdate is null
    )
    or (
        n.portfolio_id is null
        and n.sec_acct_id is null
        and n.finprod_id is null
        and n.branch is null
        and n.inv_aim is null
        and n.hoding_type is null
        and n.cdate is null
    )
    or (
        o.amount <> n.amount
        or o.ccy <> n.ccy
        or o.p_finprod_id <> n.p_finprod_id
        or o.face_value <> n.face_value
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_ptl_sec_position_cl(
            portfolio_id -- 组合代码
            ,sec_acct_id -- 证券管理账户/通道代码，无通道无证券管理账户的存999999
            ,finprod_id -- 金融产品代码
            ,branch -- 分支序号
            ,inv_aim -- 投资目的，无投资目的的存999999
            ,hoding_type -- 持仓类型，实际、在途、质押、融入、融出
            ,cdate -- 日期
            ,amount -- 数量
            ,ccy -- 币种，资产对应的币种
            ,p_finprod_id -- 母金融产品代码
            ,face_value -- 百元面值
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_ptl_sec_position_op(
            portfolio_id -- 组合代码
            ,sec_acct_id -- 证券管理账户/通道代码，无通道无证券管理账户的存999999
            ,finprod_id -- 金融产品代码
            ,branch -- 分支序号
            ,inv_aim -- 投资目的，无投资目的的存999999
            ,hoding_type -- 持仓类型，实际、在途、质押、融入、融出
            ,cdate -- 日期
            ,amount -- 数量
            ,ccy -- 币种，资产对应的币种
            ,p_finprod_id -- 母金融产品代码
            ,face_value -- 百元面值
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.portfolio_id -- 组合代码
    ,o.sec_acct_id -- 证券管理账户/通道代码，无通道无证券管理账户的存999999
    ,o.finprod_id -- 金融产品代码
    ,o.branch -- 分支序号
    ,o.inv_aim -- 投资目的，无投资目的的存999999
    ,o.hoding_type -- 持仓类型，实际、在途、质押、融入、融出
    ,o.cdate -- 日期
    ,o.amount -- 数量
    ,o.ccy -- 币种，资产对应的币种
    ,o.p_finprod_id -- 母金融产品代码
    ,o.face_value -- 百元面值
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.fams_ptl_sec_position_bk o
    left join ${iol_schema}.fams_ptl_sec_position_op n
        on
            o.portfolio_id = n.portfolio_id
            and o.sec_acct_id = n.sec_acct_id
            and o.finprod_id = n.finprod_id
            and o.branch = n.branch
            and o.inv_aim = n.inv_aim
            and o.hoding_type = n.hoding_type
            and o.cdate = n.cdate
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_ptl_sec_position_cl d
        on
            o.portfolio_id = d.portfolio_id
            and o.sec_acct_id = d.sec_acct_id
            and o.finprod_id = d.finprod_id
            and o.branch = d.branch
            and o.inv_aim = d.inv_aim
            and o.hoding_type = d.hoding_type
            and o.cdate = d.cdate
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.fams_ptl_sec_position;

-- 4.2 exchange partition
alter table ${iol_schema}.fams_ptl_sec_position exchange partition p_19000101 with table ${iol_schema}.fams_ptl_sec_position_cl;
alter table ${iol_schema}.fams_ptl_sec_position exchange partition p_20991231 with table ${iol_schema}.fams_ptl_sec_position_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_ptl_sec_position to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_ptl_sec_position_op purge;
drop table ${iol_schema}.fams_ptl_sec_position_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_ptl_sec_position_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_ptl_sec_position',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
