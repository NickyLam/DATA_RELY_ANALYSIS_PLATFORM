/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_postn_para_uussf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_postn_para_uussf1_tm purge;
drop table ${iml_schema}.ref_postn_para_uussf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ref_postn_para add partition p_uussf1 values ('uussf1')(
        subpartition p_uussf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ref_postn_para modify partition p_uussf1
    add subpartition p_uussf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_postn_para_uussf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_postn_para partition for ('uussf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_postn_para_uussf1_tm
compress ${option_switch} for query high
as
select
    post_id -- 岗位编号
    ,org_id -- 机构编号
    ,post_name -- 岗位名称
    ,base_post_flg -- 基准岗位标志
    ,strip_line_id -- 条线编号
    ,order_id -- 序列编号
    ,type_cd -- 类型代码
    ,status_cd -- 状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_postn_para
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ref_postn_para_uussf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ref_postn_para partition for ('uussf1') where 0=1;

-- 2.1 insert data to tm table
-- uuss_uus_post-
insert into ${iml_schema}.ref_postn_para_uussf1_tm(
    post_id -- 岗位编号
    ,org_id -- 机构编号
    ,post_name -- 岗位名称
    ,base_post_flg -- 基准岗位标志
    ,strip_line_id -- 条线编号
    ,order_id -- 序列编号
    ,type_cd -- 类型代码
    ,status_cd -- 状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.POSTCODE -- 岗位编号
    ,P1.ORGANCODE -- 机构编号
    ,P1.POSTNAME -- 岗位名称
    ,P1.ISBASEPOST -- 基准岗位标志
    ,P1.LINECODE -- 条线编号
    ,P1.SERIALCODE -- 序列编号
    ,P1.TYPE -- 类型代码
    ,P1.ENABLESTATE -- 状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'uuss_uus_post' -- 源表名称
    ,'uussf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.uuss_uus_post p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_postn_para_uussf1_tm 
  	                                group by 
  	                                        post_id
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.ref_postn_para_uussf1_ex(
    post_id -- 岗位编号
    ,org_id -- 机构编号
    ,post_name -- 岗位名称
    ,base_post_flg -- 基准岗位标志
    ,strip_line_id -- 条线编号
    ,order_id -- 序列编号
    ,type_cd -- 类型代码
    ,status_cd -- 状态代码
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.post_id, o.post_id) as post_id -- 岗位编号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.post_name, o.post_name) as post_name -- 岗位名称
    ,nvl(n.base_post_flg, o.base_post_flg) as base_post_flg -- 基准岗位标志
    ,nvl(n.strip_line_id, o.strip_line_id) as strip_line_id -- 条线编号
    ,nvl(n.order_id, o.order_id) as order_id -- 序列编号
    ,nvl(n.type_cd, o.type_cd) as type_cd -- 类型代码
    ,nvl(n.status_cd, o.status_cd) as status_cd -- 状态代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.post_id is null
            ) or (
                o.org_id <> n.org_id
                or o.post_name <> n.post_name
                or o.base_post_flg <> n.base_post_flg
                or o.strip_line_id <> n.strip_line_id
                or o.order_id <> n.order_id
                or o.type_cd <> n.type_cd
                or o.status_cd <> n.status_cd
            ) or (
                 case when (
                           n.post_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.post_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_postn_para_uussf1_tm n
    full join ${iml_schema}.ref_postn_para_uussf1_bk o
        on
            o.post_id = n.post_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ref_postn_para truncate partition for ('uussf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ref_postn_para exchange subpartition p_uussf1_${batch_date} with table ${iml_schema}.ref_postn_para_uussf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ref_postn_para drop subpartition p_uussf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_postn_para to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ref_postn_para_uussf1_tm purge;
drop table ${iml_schema}.ref_postn_para_uussf1_ex purge;
drop table ${iml_schema}.ref_postn_para_uussf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_postn_para', partname => 'p_uussf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);