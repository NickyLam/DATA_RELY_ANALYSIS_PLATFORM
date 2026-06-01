/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_fin_am_sob_famsf2
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
drop table ${iml_schema}.fin_am_sob_famsf2_tm purge;
drop table ${iml_schema}.fin_am_sob_famsf2_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.fin_am_sob add partition p_famsf2 values ('famsf2')(
        subpartition p_famsf2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.fin_am_sob modify partition p_famsf2
    add subpartition p_famsf2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.fin_am_sob_famsf2_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.fin_am_sob partition for ('famsf2')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.fin_am_sob_famsf2_tm
compress ${option_switch} for query high
as
select
    sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,sob_name -- 账套名称
    ,sob_fname -- 账套全称
    ,sob_cate_cd -- 账套类别代码
    ,curr_cd -- 币种代码
    ,tepla_sob_id -- 模板账套编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.fin_am_sob
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.fin_am_sob_famsf2_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.fin_am_sob partition for ('famsf2') where 0=1;

-- 2.1 insert data to tm table
-- fams_bok_bookset-1
insert into ${iml_schema}.fin_am_sob_famsf2_tm(
    sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,sob_name -- 账套名称
    ,sob_fname -- 账套全称
    ,sob_cate_cd -- 账套类别代码
    ,curr_cd -- 币种代码
    ,tepla_sob_id -- 模板账套编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.BOOKSET_ID -- 账套编号
    ,'9999' -- 法人编号
    ,P1.BOOKSET_NAME -- 账套名称
    ,P1.BOOKSET_FULLNAME -- 账套全称
    ,P1.BOOKSET_TYPE -- 账套类别代码
    ,P1.STANDARD_CCY -- 币种代码
    ,P1.BOOKSET_ID_TMPL -- 模板账套编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_bok_bookset' -- 源表名称
    ,'famsf2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_bok_bookset p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.fin_am_sob_famsf2_tm 
  	                                group by 
  	                                        sob_id
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.fin_am_sob_famsf2_ex(
    sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,sob_name -- 账套名称
    ,sob_fname -- 账套全称
    ,sob_cate_cd -- 账套类别代码
    ,curr_cd -- 币种代码
    ,tepla_sob_id -- 模板账套编号
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.sob_id, o.sob_id) as sob_id -- 账套编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.sob_name, o.sob_name) as sob_name -- 账套名称
    ,nvl(n.sob_fname, o.sob_fname) as sob_fname -- 账套全称
    ,nvl(n.sob_cate_cd, o.sob_cate_cd) as sob_cate_cd -- 账套类别代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.tepla_sob_id, o.tepla_sob_id) as tepla_sob_id -- 模板账套编号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.sob_id is null
                and o.lp_id is null
            ) or (
                o.sob_name <> n.sob_name
                or o.sob_fname <> n.sob_fname
                or o.sob_cate_cd <> n.sob_cate_cd
                or o.curr_cd <> n.curr_cd
                or o.tepla_sob_id <> n.tepla_sob_id
            ) or (
                 case when (
                           n.sob_id is null
                           and n.lp_id is null
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
                n.sob_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.fin_am_sob_famsf2_tm n
    full join ${iml_schema}.fin_am_sob_famsf2_bk o
        on
            o.sob_id = n.sob_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.fin_am_sob truncate partition for ('famsf2') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.fin_am_sob exchange subpartition p_famsf2_${batch_date} with table ${iml_schema}.fin_am_sob_famsf2_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.fin_am_sob drop subpartition p_famsf2_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.fin_am_sob to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.fin_am_sob_famsf2_tm purge;
drop table ${iml_schema}.fin_am_sob_famsf2_ex purge;
drop table ${iml_schema}.fin_am_sob_famsf2_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'fin_am_sob', partname => 'p_famsf2_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);