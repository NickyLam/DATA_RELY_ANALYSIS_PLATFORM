/*
Purpose:    整合模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_prod_rela_h_ifcsi1
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
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_prod_rela_h add partition p_ifcsi1 values ('ifcsi1')(
        subpartition p_ifcsi1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ifcsi1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

create table ${iml_schema}.agt_prod_rela_h_ifcsi1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_prod_rela_h partition for ('ifcsi1') 
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_prod_rela_h_ifcsi1_tm purge;
drop table ${iml_schema}.agt_prod_rela_h_ifcsi1_op purge;
drop table ${iml_schema}.agt_prod_rela_h_ifcsi1_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_prod_rela_h_ifcsi1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,agt_prod_rela_type_cd -- 协议产品关系类型代码
    ,prod_id -- 产品编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_prod_rela_h partition for ('ifcsi1')
where 0=1
;

create table ${iml_schema}.agt_prod_rela_h_ifcsi1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_prod_rela_h partition for ('ifcsi1') where 0=1;

create table ${iml_schema}.agt_prod_rela_h_ifcsi1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_prod_rela_h partition for ('ifcsi1') where 0=1;

-- 3.1 get new data into table
-- ifcs_bk_dep_prod_acct_info-
insert into ${iml_schema}.agt_prod_rela_h_ifcsi1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,agt_prod_rela_type_cd -- 协议产品关系类型代码
    ,prod_id -- 产品编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '120015'||P1.DEP_ACCT_ID||P1.DEP_PROD_SUB_ACCT_ID -- 协议编号
    ,'9999' -- 法人编号
    ,'01' -- 协议产品关系类型代码
    ,case when P1.DPS_TYPE_CD ='S01' AND P1.PROD_ID = 'S02CNY12M00002' then '102010100001'   --腾讯个人活期存款
          when P1.DPS_TYPE_CD ='S02' AND P1.PROD_ID = 'S02CNY12M00001' then '102020500001'  --微众定期存款
          else ' '
     end -- 产品编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifcs_bk_dep_prod_acct_info' -- 源表名称
    ,'ifcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifcs_bk_dep_prod_acct_info p1
where  1 = 1 
    and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;


commit;


whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_prod_rela_h_ifcsi1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,agt_prod_rela_type_cd
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

-- 3.2 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_prod_rela_h_ifcsi1_op(
        agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,agt_prod_rela_type_cd -- 协议产品关系类型代码
    ,prod_id -- 产品编号
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,src_table_name -- 源表名称
        ,job_cd -- 任务编码
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.agt_id -- 协议编号
    ,n.lp_id -- 法人编号
    ,n.agt_prod_rela_type_cd -- 协议产品关系类型代码
    ,n.prod_id -- 产品编号
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark -- 增删标志
    ,n.src_table_name -- 源表名称
    ,'ifcsi1' as job_cd -- 任务编码
    ,n.etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_prod_rela_h_ifcsi1_tm n
    left join ${iml_schema}.agt_prod_rela_h_ifcsi1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.agt_prod_rela_type_cd = n.agt_prod_rela_type_cd
where (
        o.agt_id is null
        and o.lp_id is null
        and o.agt_prod_rela_type_cd is null
    )
    or (
        o.prod_id <> n.prod_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_prod_rela_h_ifcsi1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,agt_prod_rela_type_cd -- 协议产品关系类型代码
    ,prod_id -- 产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_prod_rela_h_ifcsi1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,agt_prod_rela_type_cd -- 协议产品关系类型代码
    ,prod_id -- 产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.agt_prod_rela_type_cd -- 协议产品关系类型代码
    ,o.prod_id -- 产品编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_prod_rela_h_ifcsi1_bk o
    left join ${iml_schema}.agt_prod_rela_h_ifcsi1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.agt_prod_rela_type_cd = n.agt_prod_rela_type_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;


-- 4.1 rebuild partition
whenever sqlerror continue none;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_prod_rela_h') 
               and substr(subpartition_name,1,8)=upper('p_ifcsi1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_prod_rela_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_prod_rela_h modify partition p_ifcsi1 
add subpartition p_ifcsi1_${batch_date} values (to_date('${batch_date}','YYYYMMDD'));
  
-- 4.2 exchange partition
alter table ${iml_schema}.agt_prod_rela_h exchange subpartition p_ifcsi1_${batch_date} with table ${iml_schema}.agt_prod_rela_h_ifcsi1_cl;
alter table ${iml_schema}.agt_prod_rela_h exchange subpartition p_ifcsi1_20991231 with table ${iml_schema}.agt_prod_rela_h_ifcsi1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_prod_rela_h to ${iml_schema};

-- 5.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_prod_rela_h_ifcsi1_tm purge;
drop table ${iml_schema}.agt_prod_rela_h_ifcsi1_op purge;
drop table ${iml_schema}.agt_prod_rela_h_ifcsi1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_prod_rela_h_ifcsi1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_prod_rela_h', partname => 'p_ifcsi1_20991231', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1', no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
