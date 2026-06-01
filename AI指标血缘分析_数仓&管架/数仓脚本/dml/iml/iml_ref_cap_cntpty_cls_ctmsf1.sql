/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_cap_cntpty_cls_ctmsf1
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
drop table ${iml_schema}.ref_cap_cntpty_cls_ctmsf1_tm purge;
drop table ${iml_schema}.ref_cap_cntpty_cls_ctmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ref_cap_cntpty_cls add partition p_ctmsf1 values ('ctmsf1')(
        subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ref_cap_cntpty_cls modify partition p_ctmsf1
    add subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_cap_cntpty_cls_ctmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_cap_cntpty_cls partition for ('ctmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_cap_cntpty_cls_ctmsf1_tm
compress ${option_switch} for query high
as
select
    cls_id -- 分类编号
    ,lp_id -- 法人编号
    ,tran_dir_cd -- 交易方向代码
    ,cls_abbr -- 分类简称
    ,cls_descb -- 分类描述
    ,super_cls_id -- 上级分类编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_cap_cntpty_cls
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ref_cap_cntpty_cls_ctmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ref_cap_cntpty_cls partition for ('ctmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ctms_tbs_vs_commonatts-
insert into ${iml_schema}.ref_cap_cntpty_cls_ctmsf1_tm(
    cls_id -- 分类编号
    ,lp_id -- 法人编号
    ,tran_dir_cd -- 交易方向代码
    ,cls_abbr -- 分类简称
    ,cls_descb -- 分类描述
    ,super_cls_id -- 上级分类编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    TO_CHAR(P1.COMMONATTS_ID) -- 分类编号
    ,'9999' -- 法人编号
    ,CASE WHEN P1.SINGLEORMULTI = 'S' THEN '02' ELSE '01' END -- 交易方向代码
    ,P1.COMMONATTS_SHORTNAME -- 分类简称
    ,P1.COMMONATTS_DESC -- 分类描述
    ,TO_CHAR(P1.COMMONATTS_ID_PARENT) -- 上级分类编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_vs_commonatts' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_vs_commonatts p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_cap_cntpty_cls_ctmsf1_tm 
  	                                group by 
  	                                        cls_id
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
insert /*+ append */ into ${iml_schema}.ref_cap_cntpty_cls_ctmsf1_ex(
    cls_id -- 分类编号
    ,lp_id -- 法人编号
    ,tran_dir_cd -- 交易方向代码
    ,cls_abbr -- 分类简称
    ,cls_descb -- 分类描述
    ,super_cls_id -- 上级分类编号
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.cls_id, o.cls_id) as cls_id -- 分类编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.tran_dir_cd, o.tran_dir_cd) as tran_dir_cd -- 交易方向代码
    ,nvl(n.cls_abbr, o.cls_abbr) as cls_abbr -- 分类简称
    ,nvl(n.cls_descb, o.cls_descb) as cls_descb -- 分类描述
    ,nvl(n.super_cls_id, o.super_cls_id) as super_cls_id -- 上级分类编号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.cls_id is null
                and o.lp_id is null
            ) or (
                o.tran_dir_cd <> n.tran_dir_cd
                or o.cls_abbr <> n.cls_abbr
                or o.cls_descb <> n.cls_descb
                or o.super_cls_id <> n.super_cls_id
            ) or (
                 case when (
                           n.cls_id is null
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
                n.cls_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_cap_cntpty_cls_ctmsf1_tm n
    full join ${iml_schema}.ref_cap_cntpty_cls_ctmsf1_bk o
        on
            o.cls_id = n.cls_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ref_cap_cntpty_cls truncate partition for ('ctmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ref_cap_cntpty_cls exchange subpartition p_ctmsf1_${batch_date} with table ${iml_schema}.ref_cap_cntpty_cls_ctmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ref_cap_cntpty_cls drop subpartition p_ctmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_cap_cntpty_cls to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ref_cap_cntpty_cls_ctmsf1_tm purge;
drop table ${iml_schema}.ref_cap_cntpty_cls_ctmsf1_ex purge;
drop table ${iml_schema}.ref_cap_cntpty_cls_ctmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_cap_cntpty_cls', partname => 'p_ctmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);