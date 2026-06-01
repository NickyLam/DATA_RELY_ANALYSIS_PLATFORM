/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_prod_appl_info_fdmsf1
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
drop table ${iml_schema}.ref_prod_appl_info_fdmsf1_tm purge;
drop table ${iml_schema}.ref_prod_appl_info_fdmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ref_prod_appl_info add partition p_fdmsf1 values ('fdmsf1')(
        subpartition p_fdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ref_prod_appl_info modify partition p_fdmsf1
    add subpartition p_fdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_prod_appl_info_fdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_prod_appl_info partition for ('fdmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_prod_appl_info_fdmsf1_tm
compress ${option_switch} for query high
as
select
    prod_appl_id -- 产品申请编号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,tran_dir_cd -- 交易方向代码
    ,subj_id -- 科目编号
    ,sys_src_abbr -- 系统来源简称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_prod_appl_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ref_prod_appl_info_fdmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ref_prod_appl_info partition for ('fdmsf1') where 0=1;

-- 2.1 insert data to tm table
-- fdms_bal_prod_appl-
insert into ${iml_schema}.ref_prod_appl_info_fdmsf1_tm(
    prod_appl_id -- 产品申请编号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,tran_dir_cd -- 交易方向代码
    ,subj_id -- 科目编号
    ,sys_src_abbr -- 系统来源简称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.BAL_PROD_APPL_ID -- 产品申请编号
    ,P1.PRODUCT_ID -- 产品编号
    ,NVL(TRIM(P1.CURRENCY_UOM_ID),'CNY') -- 币种代码
    ,P1.AMOUNT_DIRECTION -- 交易方向代码
    ,P1.ACCOUNT -- 科目编号
    ,P1.ORIGIN_SYS_ID -- 系统来源简称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fdms_bal_prod_appl' -- 源表名称
    ,'fdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fdms_bal_prod_appl p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_prod_appl_info_fdmsf1_tm 
  	                                group by 
  	                                        prod_appl_id
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
insert /*+ append */ into ${iml_schema}.ref_prod_appl_info_fdmsf1_ex(
    prod_appl_id -- 产品申请编号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,tran_dir_cd -- 交易方向代码
    ,subj_id -- 科目编号
    ,sys_src_abbr -- 系统来源简称
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.prod_appl_id, o.prod_appl_id) as prod_appl_id -- 产品申请编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.tran_dir_cd, o.tran_dir_cd) as tran_dir_cd -- 交易方向代码
    ,nvl(n.subj_id, o.subj_id) as subj_id -- 科目编号
    ,nvl(n.sys_src_abbr, o.sys_src_abbr) as sys_src_abbr -- 系统来源简称
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.prod_appl_id is null
            ) or (
                o.prod_id <> n.prod_id
                or o.curr_cd <> n.curr_cd
                or o.tran_dir_cd <> n.tran_dir_cd
                or o.subj_id <> n.subj_id
                or o.sys_src_abbr <> n.sys_src_abbr
            ) or (
                 case when (
                           n.prod_appl_id is null
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
                n.prod_appl_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_prod_appl_info_fdmsf1_tm n
    full join ${iml_schema}.ref_prod_appl_info_fdmsf1_bk o
        on
            o.prod_appl_id = n.prod_appl_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ref_prod_appl_info truncate partition for ('fdmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ref_prod_appl_info exchange subpartition p_fdmsf1_${batch_date} with table ${iml_schema}.ref_prod_appl_info_fdmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ref_prod_appl_info drop subpartition p_fdmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_prod_appl_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ref_prod_appl_info_fdmsf1_tm purge;
drop table ${iml_schema}.ref_prod_appl_info_fdmsf1_ex purge;
drop table ${iml_schema}.ref_prod_appl_info_fdmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_prod_appl_info', partname => 'p_fdmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);