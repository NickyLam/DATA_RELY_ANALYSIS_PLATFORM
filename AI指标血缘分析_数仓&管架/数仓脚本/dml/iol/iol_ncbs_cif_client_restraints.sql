/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cif_client_restraints
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
create table ${iol_schema}.ncbs_cif_client_restraints_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cif_client_restraints
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cif_client_restraints_op purge;
drop table ${iol_schema}.ncbs_cif_client_restraints_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cif_client_restraints_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cif_client_restraints where 0=1;

create table ${iol_schema}.ncbs_cif_client_restraints_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cif_client_restraints where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cif_client_restraints_cl(
            res_seq_no -- 限制编号
            ,restraint_type -- 限制类型
            ,source_type -- 渠道编号
            ,tran_date -- 交易日期
            ,tran_branch -- 核心交易机构编号
            ,maintain_type -- 维护方式
            ,client_no -- 客户编号
            ,start_date -- 开始日期
            ,term -- 存期
            ,term_type -- 期限单位
            ,end_date -- 结束日期
            ,restraints_status -- 限制状态
            ,narrative -- 摘要
            ,user_id -- 交易柜员编号
            ,auth_user_id -- 授权柜员
            ,last_change_date -- 最后修改日期
            ,last_change_user_id -- 最后修改柜员
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,sign_user_id -- 签约柜员
            ,out_sign_user_id -- 解约柜员
            ,sign_channel -- 签约渠道
            ,unlost_time -- 解挂时间
            ,oper_narrative -- 操作备注
            ,start_timestamp -- 加限的交易时间戳
            ,actual_effect_time -- 实际生效时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cif_client_restraints_op(
            res_seq_no -- 限制编号
            ,restraint_type -- 限制类型
            ,source_type -- 渠道编号
            ,tran_date -- 交易日期
            ,tran_branch -- 核心交易机构编号
            ,maintain_type -- 维护方式
            ,client_no -- 客户编号
            ,start_date -- 开始日期
            ,term -- 存期
            ,term_type -- 期限单位
            ,end_date -- 结束日期
            ,restraints_status -- 限制状态
            ,narrative -- 摘要
            ,user_id -- 交易柜员编号
            ,auth_user_id -- 授权柜员
            ,last_change_date -- 最后修改日期
            ,last_change_user_id -- 最后修改柜员
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,sign_user_id -- 签约柜员
            ,out_sign_user_id -- 解约柜员
            ,sign_channel -- 签约渠道
            ,unlost_time -- 解挂时间
            ,oper_narrative -- 操作备注
            ,start_timestamp -- 加限的交易时间戳
            ,actual_effect_time -- 实际生效时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.res_seq_no, o.res_seq_no) as res_seq_no -- 限制编号
    ,nvl(n.restraint_type, o.restraint_type) as restraint_type -- 限制类型
    ,nvl(n.source_type, o.source_type) as source_type -- 渠道编号
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.maintain_type, o.maintain_type) as maintain_type -- 维护方式
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.term, o.term) as term -- 存期
    ,nvl(n.term_type, o.term_type) as term_type -- 期限单位
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.restraints_status, o.restraints_status) as restraints_status -- 限制状态
    ,nvl(n.narrative, o.narrative) as narrative -- 摘要
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.auth_user_id, o.auth_user_id) as auth_user_id -- 授权柜员
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.last_change_user_id, o.last_change_user_id) as last_change_user_id -- 最后修改柜员
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.sign_user_id, o.sign_user_id) as sign_user_id -- 签约柜员
    ,nvl(n.out_sign_user_id, o.out_sign_user_id) as out_sign_user_id -- 解约柜员
    ,nvl(n.sign_channel, o.sign_channel) as sign_channel -- 签约渠道
    ,nvl(n.unlost_time, o.unlost_time) as unlost_time -- 解挂时间
    ,nvl(n.oper_narrative, o.oper_narrative) as oper_narrative -- 操作备注
    ,nvl(n.start_timestamp, o.start_timestamp) as start_timestamp -- 加限的交易时间戳
    ,nvl(n.actual_effect_time, o.actual_effect_time) as actual_effect_time -- 实际生效时间
    ,case when
            n.res_seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.res_seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.res_seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cif_client_restraints_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cif_client_restraints where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.res_seq_no = n.res_seq_no
where (
        o.res_seq_no is null
    )
    or (
        n.res_seq_no is null
    )
    or (
        o.restraint_type <> n.restraint_type
        or o.source_type <> n.source_type
        or o.tran_date <> n.tran_date
        or o.tran_branch <> n.tran_branch
        or o.maintain_type <> n.maintain_type
        or o.client_no <> n.client_no
        or o.start_date <> n.start_date
        or o.term <> n.term
        or o.term_type <> n.term_type
        or o.end_date <> n.end_date
        or o.restraints_status <> n.restraints_status
        or o.narrative <> n.narrative
        or o.user_id <> n.user_id
        or o.auth_user_id <> n.auth_user_id
        or o.last_change_date <> n.last_change_date
        or o.last_change_user_id <> n.last_change_user_id
        or o.tran_timestamp <> n.tran_timestamp
        or o.company <> n.company
        or o.sign_user_id <> n.sign_user_id
        or o.out_sign_user_id <> n.out_sign_user_id
        or o.sign_channel <> n.sign_channel
        or o.unlost_time <> n.unlost_time
        or o.oper_narrative <> n.oper_narrative
        or o.start_timestamp <> n.start_timestamp
        or o.actual_effect_time <> n.actual_effect_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cif_client_restraints_cl(
            res_seq_no -- 限制编号
            ,restraint_type -- 限制类型
            ,source_type -- 渠道编号
            ,tran_date -- 交易日期
            ,tran_branch -- 核心交易机构编号
            ,maintain_type -- 维护方式
            ,client_no -- 客户编号
            ,start_date -- 开始日期
            ,term -- 存期
            ,term_type -- 期限单位
            ,end_date -- 结束日期
            ,restraints_status -- 限制状态
            ,narrative -- 摘要
            ,user_id -- 交易柜员编号
            ,auth_user_id -- 授权柜员
            ,last_change_date -- 最后修改日期
            ,last_change_user_id -- 最后修改柜员
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,sign_user_id -- 签约柜员
            ,out_sign_user_id -- 解约柜员
            ,sign_channel -- 签约渠道
            ,unlost_time -- 解挂时间
            ,oper_narrative -- 操作备注
            ,start_timestamp -- 加限的交易时间戳
            ,actual_effect_time -- 实际生效时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cif_client_restraints_op(
            res_seq_no -- 限制编号
            ,restraint_type -- 限制类型
            ,source_type -- 渠道编号
            ,tran_date -- 交易日期
            ,tran_branch -- 核心交易机构编号
            ,maintain_type -- 维护方式
            ,client_no -- 客户编号
            ,start_date -- 开始日期
            ,term -- 存期
            ,term_type -- 期限单位
            ,end_date -- 结束日期
            ,restraints_status -- 限制状态
            ,narrative -- 摘要
            ,user_id -- 交易柜员编号
            ,auth_user_id -- 授权柜员
            ,last_change_date -- 最后修改日期
            ,last_change_user_id -- 最后修改柜员
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,sign_user_id -- 签约柜员
            ,out_sign_user_id -- 解约柜员
            ,sign_channel -- 签约渠道
            ,unlost_time -- 解挂时间
            ,oper_narrative -- 操作备注
            ,start_timestamp -- 加限的交易时间戳
            ,actual_effect_time -- 实际生效时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.res_seq_no -- 限制编号
    ,o.restraint_type -- 限制类型
    ,o.source_type -- 渠道编号
    ,o.tran_date -- 交易日期
    ,o.tran_branch -- 核心交易机构编号
    ,o.maintain_type -- 维护方式
    ,o.client_no -- 客户编号
    ,o.start_date -- 开始日期
    ,o.term -- 存期
    ,o.term_type -- 期限单位
    ,o.end_date -- 结束日期
    ,o.restraints_status -- 限制状态
    ,o.narrative -- 摘要
    ,o.user_id -- 交易柜员编号
    ,o.auth_user_id -- 授权柜员
    ,o.last_change_date -- 最后修改日期
    ,o.last_change_user_id -- 最后修改柜员
    ,o.tran_timestamp -- 交易时间戳
    ,o.company -- 法人
    ,o.sign_user_id -- 签约柜员
    ,o.out_sign_user_id -- 解约柜员
    ,o.sign_channel -- 签约渠道
    ,o.unlost_time -- 解挂时间
    ,o.oper_narrative -- 操作备注
    ,o.start_timestamp -- 加限的交易时间戳
    ,o.actual_effect_time -- 实际生效时间
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
from ${iol_schema}.ncbs_cif_client_restraints_bk o
    left join ${iol_schema}.ncbs_cif_client_restraints_op n
        on
            o.res_seq_no = n.res_seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cif_client_restraints_cl d
        on
            o.res_seq_no = d.res_seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cif_client_restraints;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cif_client_restraints') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cif_client_restraints drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cif_client_restraints add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cif_client_restraints exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cif_client_restraints_cl;
alter table ${iol_schema}.ncbs_cif_client_restraints exchange partition p_20991231 with table ${iol_schema}.ncbs_cif_client_restraints_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cif_client_restraints to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cif_client_restraints_op purge;
drop table ${iol_schema}.ncbs_cif_client_restraints_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cif_client_restraints_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cif_client_restraints',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
