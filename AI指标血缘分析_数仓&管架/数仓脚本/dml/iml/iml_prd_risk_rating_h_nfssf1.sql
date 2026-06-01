/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_risk_rating_h_nfssf1
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
alter table ${iml_schema}.prd_risk_rating_h add partition p_nfssf1 values ('nfssf1')(
        subpartition p_nfssf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_nfssf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_risk_rating_h_nfssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_risk_rating_h partition for ('nfssf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_risk_rating_h_nfssf1_tm purge;
drop table ${iml_schema}.prd_risk_rating_h_nfssf1_op purge;
drop table ${iml_schema}.prd_risk_rating_h_nfssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_risk_rating_h_nfssf1_tm nologging
compress ${option_switch} for query high
as select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,rating_type_cd -- 评级类型代码
    ,rating_rest_cd -- 评级结果代码
    ,rating_dt -- 评级日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_risk_rating_h partition for ('nfssf1')
where 0=1
;

create table ${iml_schema}.prd_risk_rating_h_nfssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_risk_rating_h partition for ('nfssf1') where 0=1;

create table ${iml_schema}.prd_risk_rating_h_nfssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_risk_rating_h partition for ('nfssf1') where 0=1;

-- 3.1 get new data into table
-- nfss_ft_product-risk_grade
insert into ${iml_schema}.prd_risk_rating_h_nfssf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,rating_type_cd -- 评级类型代码
    ,rating_rest_cd -- 评级结果代码
    ,rating_dt -- 评级日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223010'||P1.PRODUCT_CODE -- 产品编号
    ,'9999' -- 法人编号
    ,'CD1152' -- 评级类型代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.RISK_GRADE END -- 评级结果代码
    ,${iml_schema}.DATEFORMAT_MIN(null) -- 评级日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nfss_ft_product' -- 源表名称
    ,'nfssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nfss_ft_product p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.RISK_GRADE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NFSS'
        AND R1.SRC_TAB_EN_NAME= 'NFSS_FT_PRODUCT'
        AND R1.SRC_FIELD_EN_NAME= 'RISK_GRADE'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_RISK_RATING_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'RATING_REST_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_risk_rating_h_nfssf1_tm 
  	                                group by 
  	                                        prod_id
  	                                        ,lp_id
  	                                        ,rating_type_cd
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
        into ${iml_schema}.prd_risk_rating_h_nfssf1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,rating_type_cd -- 评级类型代码
    ,rating_rest_cd -- 评级结果代码
    ,rating_dt -- 评级日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_risk_rating_h_nfssf1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,rating_type_cd -- 评级类型代码
    ,rating_rest_cd -- 评级结果代码
    ,rating_dt -- 评级日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.rating_type_cd, o.rating_type_cd) as rating_type_cd -- 评级类型代码
    ,nvl(n.rating_rest_cd, o.rating_rest_cd) as rating_rest_cd -- 评级结果代码
    ,nvl(n.rating_dt, o.rating_dt) as rating_dt -- 评级日期
    ,case when
            n.prod_id is null
            and n.lp_id is null
            and n.rating_type_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prod_id is null
            and n.lp_id is null
            and n.rating_type_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prod_id is null
            and n.lp_id is null
            and n.rating_type_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_risk_rating_h_nfssf1_tm n
    full join (select * from ${iml_schema}.prd_risk_rating_h_nfssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.rating_type_cd = n.rating_type_cd
where (
        o.prod_id is null
        and o.lp_id is null
        and o.rating_type_cd is null
    )
    or (
        n.prod_id is null
        and n.lp_id is null
        and n.rating_type_cd is null
    )
    or (
        o.rating_rest_cd <> n.rating_rest_cd
        or o.rating_dt <> n.rating_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_risk_rating_h_nfssf1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,rating_type_cd -- 评级类型代码
    ,rating_rest_cd -- 评级结果代码
    ,rating_dt -- 评级日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_risk_rating_h_nfssf1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,rating_type_cd -- 评级类型代码
    ,rating_rest_cd -- 评级结果代码
    ,rating_dt -- 评级日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prod_id -- 产品编号
    ,o.lp_id -- 法人编号
    ,o.rating_type_cd -- 评级类型代码
    ,o.rating_rest_cd -- 评级结果代码
    ,o.rating_dt -- 评级日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_risk_rating_h_nfssf1_bk o
    left join ${iml_schema}.prd_risk_rating_h_nfssf1_op n
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.rating_type_cd = n.rating_type_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_risk_rating_h_nfssf1_cl d
        on
            o.prod_id = d.prod_id
            and o.lp_id = d.lp_id
            and o.rating_type_cd = d.rating_type_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_risk_rating_h;
--alter table ${iml_schema}.prd_risk_rating_h truncate partition for ('nfssf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('prd_risk_rating_h') 
               and substr(subpartition_name,1,8)=upper('p_nfssf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.prd_risk_rating_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.prd_risk_rating_h modify partition p_nfssf1 
add subpartition p_nfssf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.prd_risk_rating_h exchange subpartition p_nfssf1_${batch_date} with table ${iml_schema}.prd_risk_rating_h_nfssf1_cl;
alter table ${iml_schema}.prd_risk_rating_h exchange subpartition p_nfssf1_20991231 with table ${iml_schema}.prd_risk_rating_h_nfssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_risk_rating_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_risk_rating_h_nfssf1_tm purge;
drop table ${iml_schema}.prd_risk_rating_h_nfssf1_op purge;
drop table ${iml_schema}.prd_risk_rating_h_nfssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_risk_rating_h_nfssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_risk_rating_h', partname => 'p_nfssf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
