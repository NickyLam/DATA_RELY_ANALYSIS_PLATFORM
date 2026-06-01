/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ps_cust_lmt_dtl_h_pppsf1
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
alter table ${iml_schema}.agt_ps_cust_lmt_dtl_h add partition p_pppsf1 values ('pppsf1')(
        subpartition p_pppsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_pppsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ps_cust_lmt_dtl_h_pppsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ps_cust_lmt_dtl_h partition for ('pppsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_ps_cust_lmt_dtl_h_pppsf1_tm purge;
drop table ${iml_schema}.agt_ps_cust_lmt_dtl_h_pppsf1_op purge;
drop table ${iml_schema}.agt_ps_cust_lmt_dtl_h_pppsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ps_cust_lmt_dtl_h_pppsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,lmt_type_descb -- 限额类型描述
    ,lmt_agt_id -- 限额协议编号
    ,lmt_obj_id -- 限额对象编号
    ,lmt_type_val -- 限制类型值
    ,remark -- 备注
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ps_cust_lmt_dtl_h partition for ('pppsf1')
where 0=1
;

create table ${iml_schema}.agt_ps_cust_lmt_dtl_h_pppsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ps_cust_lmt_dtl_h partition for ('pppsf1') where 0=1;

create table ${iml_schema}.agt_ps_cust_lmt_dtl_h_pppsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ps_cust_lmt_dtl_h partition for ('pppsf1') where 0=1;

-- 3.1 get new data into table
-- ppps_t_txn_limit_detail-1
insert into ${iml_schema}.agt_ps_cust_lmt_dtl_h_pppsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,lmt_type_descb -- 限额类型描述
    ,lmt_agt_id -- 限额协议编号
    ,lmt_obj_id -- 限额对象编号
    ,lmt_type_val -- 限制类型值
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300032'||P1.LIMIT_AGREEMENT_ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.LIMIT_TEMPLATE_ITEM -- 限额类型描述
    ,P1.LIMIT_AGREEMENT_ID -- 限额协议编号
    ,P1.LIMIT_OBJECT_ID -- 限额对象编号
    ,P1.ITEM_VALUE -- 限制类型值
    ,P1.REMARK -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ppps_t_txn_limit_detail' -- 源表名称
    ,'pppsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ppps_t_txn_limit_detail p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_ps_cust_lmt_dtl_h_pppsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,lmt_type_descb
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
        into ${iml_schema}.agt_ps_cust_lmt_dtl_h_pppsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,lmt_type_descb -- 限额类型描述
    ,lmt_agt_id -- 限额协议编号
    ,lmt_obj_id -- 限额对象编号
    ,lmt_type_val -- 限制类型值
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ps_cust_lmt_dtl_h_pppsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,lmt_type_descb -- 限额类型描述
    ,lmt_agt_id -- 限额协议编号
    ,lmt_obj_id -- 限额对象编号
    ,lmt_type_val -- 限制类型值
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.lmt_type_descb, o.lmt_type_descb) as lmt_type_descb -- 限额类型描述
    ,nvl(n.lmt_agt_id, o.lmt_agt_id) as lmt_agt_id -- 限额协议编号
    ,nvl(n.lmt_obj_id, o.lmt_obj_id) as lmt_obj_id -- 限额对象编号
    ,nvl(n.lmt_type_val, o.lmt_type_val) as lmt_type_val -- 限制类型值
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.lmt_type_descb is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.lmt_type_descb is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.lmt_type_descb is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ps_cust_lmt_dtl_h_pppsf1_tm n
    full join (select * from ${iml_schema}.agt_ps_cust_lmt_dtl_h_pppsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.lmt_type_descb = n.lmt_type_descb
where (
        o.agt_id is null
        and o.lp_id is null
        and o.lmt_type_descb is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.lmt_type_descb is null
    )
    or (
        o.lmt_agt_id <> n.lmt_agt_id
        or o.lmt_obj_id <> n.lmt_obj_id
        or o.lmt_type_val <> n.lmt_type_val
        or o.remark <> n.remark
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_ps_cust_lmt_dtl_h_pppsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,lmt_type_descb -- 限额类型描述
    ,lmt_agt_id -- 限额协议编号
    ,lmt_obj_id -- 限额对象编号
    ,lmt_type_val -- 限制类型值
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ps_cust_lmt_dtl_h_pppsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,lmt_type_descb -- 限额类型描述
    ,lmt_agt_id -- 限额协议编号
    ,lmt_obj_id -- 限额对象编号
    ,lmt_type_val -- 限制类型值
    ,remark -- 备注
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
    ,o.lmt_type_descb -- 限额类型描述
    ,o.lmt_agt_id -- 限额协议编号
    ,o.lmt_obj_id -- 限额对象编号
    ,o.lmt_type_val -- 限制类型值
    ,o.remark -- 备注
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
from ${iml_schema}.agt_ps_cust_lmt_dtl_h_pppsf1_bk o
    left join ${iml_schema}.agt_ps_cust_lmt_dtl_h_pppsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.lmt_type_descb = n.lmt_type_descb
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_ps_cust_lmt_dtl_h_pppsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.lmt_type_descb = d.lmt_type_descb
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_ps_cust_lmt_dtl_h;
--alter table ${iml_schema}.agt_ps_cust_lmt_dtl_h truncate partition for ('pppsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_ps_cust_lmt_dtl_h') 
               and substr(subpartition_name,1,8)=upper('p_pppsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_ps_cust_lmt_dtl_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_ps_cust_lmt_dtl_h modify partition p_pppsf1 
add subpartition p_pppsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_ps_cust_lmt_dtl_h exchange subpartition p_pppsf1_${batch_date} with table ${iml_schema}.agt_ps_cust_lmt_dtl_h_pppsf1_cl;
alter table ${iml_schema}.agt_ps_cust_lmt_dtl_h exchange subpartition p_pppsf1_20991231 with table ${iml_schema}.agt_ps_cust_lmt_dtl_h_pppsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ps_cust_lmt_dtl_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_ps_cust_lmt_dtl_h_pppsf1_tm purge;
drop table ${iml_schema}.agt_ps_cust_lmt_dtl_h_pppsf1_op purge;
drop table ${iml_schema}.agt_ps_cust_lmt_dtl_h_pppsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_ps_cust_lmt_dtl_h_pppsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ps_cust_lmt_dtl_h', partname => 'p_pppsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
