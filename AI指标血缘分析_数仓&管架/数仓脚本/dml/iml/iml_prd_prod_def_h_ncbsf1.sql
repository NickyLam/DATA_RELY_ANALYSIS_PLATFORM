/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_prod_def_h_ncbsf1
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
alter table ${iml_schema}.prd_prod_def_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_prod_def_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_prod_def_h partition for ('ncbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_prod_def_h_ncbsf1_tm purge;
drop table ${iml_schema}.prd_prod_def_h_ncbsf1_op purge;
drop table ${iml_schema}.prd_prod_def_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_prod_def_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,compnt_type_cd -- 组件类型代码
    ,compnt_id -- 组件编号
    ,attr_key -- 属性键值
    ,attr_val -- 属性值
    ,evt_cls_cd -- 事件分类代码
    ,prod_status_cd -- 产品状态代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_prod_def_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.prd_prod_def_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_prod_def_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.prd_prod_def_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_prod_def_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_mb_prod_define-1
insert into ${iml_schema}.prd_prod_def_h_ncbsf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,compnt_type_cd -- 组件类型代码
    ,compnt_id -- 组件编号
    ,attr_key -- 属性键值
    ,attr_val -- 属性值
    ,evt_cls_cd -- 事件分类代码
    ,prod_status_cd -- 产品状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.PROD_TYPE -- 产品编号
    ,'9999' -- 法人编号
    ,P1.SEQ_NO -- 序号
    ,P1.ASSEMBLE_TYPE -- 组件类型代码
    ,P1.ASSEMBLE_ID -- 组件编号
    ,P1.ATTR_KEY -- 属性键值
    ,P1.ATTR_VALUE -- 属性值
    ,nvl(trim(P1.EVENT_DEFAULT),'-') -- 事件分类代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.STATUS END  -- 产品状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_mb_prod_define' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_mb_prod_define p1
 left join ${iml_schema}.ref_pub_cd_map r1 on P1.STATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NCBS'
        AND R1.SRC_TAB_EN_NAME= 'NCBS_MB_PROD_DEFINE'
        AND R1.SRC_FIELD_EN_NAME= 'STATUS'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_PROD_DEF_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PROD_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_prod_def_h_ncbsf1_tm 
  	                                group by 
  	                                        prod_id
  	                                        ,lp_id
  	                                        ,seq_num
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
        into ${iml_schema}.prd_prod_def_h_ncbsf1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,compnt_type_cd -- 组件类型代码
    ,compnt_id -- 组件编号
    ,attr_key -- 属性键值
    ,attr_val -- 属性值
    ,evt_cls_cd -- 事件分类代码
    ,prod_status_cd -- 产品状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_prod_def_h_ncbsf1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,compnt_type_cd -- 组件类型代码
    ,compnt_id -- 组件编号
    ,attr_key -- 属性键值
    ,attr_val -- 属性值
    ,evt_cls_cd -- 事件分类代码
    ,prod_status_cd -- 产品状态代码
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
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.compnt_type_cd, o.compnt_type_cd) as compnt_type_cd -- 组件类型代码
    ,nvl(n.compnt_id, o.compnt_id) as compnt_id -- 组件编号
    ,nvl(n.attr_key, o.attr_key) as attr_key -- 属性键值
    ,nvl(n.attr_val, o.attr_val) as attr_val -- 属性值
    ,nvl(n.evt_cls_cd, o.evt_cls_cd) as evt_cls_cd -- 事件分类代码
    ,nvl(n.prod_status_cd, o.prod_status_cd) as prod_status_cd -- 产品状态代码
    ,case when
            n.prod_id is null
            and n.lp_id is null
            and n.seq_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prod_id is null
            and n.lp_id is null
            and n.seq_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prod_id is null
            and n.lp_id is null
            and n.seq_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_prod_def_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.prd_prod_def_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.seq_num = n.seq_num
where (
        o.prod_id is null
        and o.lp_id is null
        and o.seq_num is null
    )
    or (
        n.prod_id is null
        and n.lp_id is null
        and n.seq_num is null
    )
    or (
        o.compnt_type_cd <> n.compnt_type_cd
        or o.compnt_id <> n.compnt_id
        or o.attr_key <> n.attr_key
        or o.attr_val <> n.attr_val
        or o.evt_cls_cd <> n.evt_cls_cd
        or o.prod_status_cd <> n.prod_status_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_prod_def_h_ncbsf1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,compnt_type_cd -- 组件类型代码
    ,compnt_id -- 组件编号
    ,attr_key -- 属性键值
    ,attr_val -- 属性值
    ,evt_cls_cd -- 事件分类代码
    ,prod_status_cd -- 产品状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_prod_def_h_ncbsf1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,compnt_type_cd -- 组件类型代码
    ,compnt_id -- 组件编号
    ,attr_key -- 属性键值
    ,attr_val -- 属性值
    ,evt_cls_cd -- 事件分类代码
    ,prod_status_cd -- 产品状态代码
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
    ,o.seq_num -- 序号
    ,o.compnt_type_cd -- 组件类型代码
    ,o.compnt_id -- 组件编号
    ,o.attr_key -- 属性键值
    ,o.attr_val -- 属性值
    ,o.evt_cls_cd -- 事件分类代码
    ,o.prod_status_cd -- 产品状态代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_prod_def_h_ncbsf1_bk o
    left join ${iml_schema}.prd_prod_def_h_ncbsf1_op n
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.seq_num = n.seq_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_prod_def_h_ncbsf1_cl d
        on
            o.prod_id = d.prod_id
            and o.lp_id = d.lp_id
            and o.seq_num = d.seq_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_prod_def_h;
alter table ${iml_schema}.prd_prod_def_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.prd_prod_def_h exchange subpartition p_ncbsf1_19000101 with table ${iml_schema}.prd_prod_def_h_ncbsf1_cl;
alter table ${iml_schema}.prd_prod_def_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.prd_prod_def_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_prod_def_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_prod_def_h_ncbsf1_tm purge;
drop table ${iml_schema}.prd_prod_def_h_ncbsf1_op purge;
drop table ${iml_schema}.prd_prod_def_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_prod_def_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_prod_def_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
