/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_fkd_other_asset_proof_icmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.ast_fkd_other_asset_proof add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_fkd_other_asset_proof_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_fkd_other_asset_proof partition for ('icmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ast_fkd_other_asset_proof_icmsf1_tm purge;
drop table ${iml_schema}.ast_fkd_other_asset_proof_icmsf1_op purge;
drop table ${iml_schema}.ast_fkd_other_asset_proof_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_fkd_other_asset_proof_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,asset_proof_list_id -- 资产证明列表编号
    ,bus_flow_num -- 业务流水号
    ,other_asset_proof_type -- 其他资产证明类型
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_fkd_other_asset_proof partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.ast_fkd_other_asset_proof_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_fkd_other_asset_proof partition for ('icmsf1') where 0=1;

create table ${iml_schema}.ast_fkd_other_asset_proof_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_fkd_other_asset_proof partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_fkd_other_asset_list-
insert into ${iml_schema}.ast_fkd_other_asset_proof_icmsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,asset_proof_list_id -- 资产证明列表编号
    ,bus_flow_num -- 业务流水号
    ,other_asset_proof_type -- 其他资产证明类型
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '304002'||P1.SERIALNO -- 资产编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 资产证明列表编号
    ,P1.RELATIVESERIALNO -- 业务流水号
    ,P1.OTHERASSETTYPE -- 其他资产证明类型
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_fkd_other_asset_list' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_fkd_other_asset_list p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_fkd_other_asset_proof_icmsf1_tm 
  	                                group by 
  	                                        asset_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ast_fkd_other_asset_proof_icmsf1_cl(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,asset_proof_list_id -- 资产证明列表编号
    ,bus_flow_num -- 业务流水号
    ,other_asset_proof_type -- 其他资产证明类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_fkd_other_asset_proof_icmsf1_op(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,asset_proof_list_id -- 资产证明列表编号
    ,bus_flow_num -- 业务流水号
    ,other_asset_proof_type -- 其他资产证明类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.asset_id, o.asset_id) as asset_id -- 资产编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.asset_proof_list_id, o.asset_proof_list_id) as asset_proof_list_id -- 资产证明列表编号
    ,nvl(n.bus_flow_num, o.bus_flow_num) as bus_flow_num -- 业务流水号
    ,nvl(n.other_asset_proof_type, o.other_asset_proof_type) as other_asset_proof_type -- 其他资产证明类型
    ,case when
            n.asset_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.asset_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.asset_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_fkd_other_asset_proof_icmsf1_tm n
    full join (select * from ${iml_schema}.ast_fkd_other_asset_proof_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
where (
        o.asset_id is null
        and o.lp_id is null
    )
    or (
        n.asset_id is null
        and n.lp_id is null
    )
    or (
        o.asset_proof_list_id <> n.asset_proof_list_id
        or o.bus_flow_num <> n.bus_flow_num
        or o.other_asset_proof_type <> n.other_asset_proof_type
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ast_fkd_other_asset_proof_icmsf1_cl(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,asset_proof_list_id -- 资产证明列表编号
    ,bus_flow_num -- 业务流水号
    ,other_asset_proof_type -- 其他资产证明类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_fkd_other_asset_proof_icmsf1_op(
            asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,asset_proof_list_id -- 资产证明列表编号
    ,bus_flow_num -- 业务流水号
    ,other_asset_proof_type -- 其他资产证明类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.asset_id -- 资产编号
    ,o.lp_id -- 法人编号
    ,o.asset_proof_list_id -- 资产证明列表编号
    ,o.bus_flow_num -- 业务流水号
    ,o.other_asset_proof_type -- 其他资产证明类型
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_fkd_other_asset_proof_icmsf1_bk o
    left join ${iml_schema}.ast_fkd_other_asset_proof_icmsf1_op n
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ast_fkd_other_asset_proof_icmsf1_cl d
        on
            o.asset_id = d.asset_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.ast_fkd_other_asset_proof;
alter table ${iml_schema}.ast_fkd_other_asset_proof truncate partition for ('icmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.ast_fkd_other_asset_proof exchange subpartition p_icmsf1_19000101 with table ${iml_schema}.ast_fkd_other_asset_proof_icmsf1_cl;
alter table ${iml_schema}.ast_fkd_other_asset_proof exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.ast_fkd_other_asset_proof_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_fkd_other_asset_proof to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ast_fkd_other_asset_proof_icmsf1_tm purge;
drop table ${iml_schema}.ast_fkd_other_asset_proof_icmsf1_op purge;
drop table ${iml_schema}.ast_fkd_other_asset_proof_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ast_fkd_other_asset_proof_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_fkd_other_asset_proof', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
