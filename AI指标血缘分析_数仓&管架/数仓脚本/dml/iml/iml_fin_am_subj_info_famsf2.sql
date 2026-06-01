/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_fin_am_subj_info_famsf2
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
drop table ${iml_schema}.fin_am_subj_info_famsf2_tm purge;
drop table ${iml_schema}.fin_am_subj_info_famsf2_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.fin_am_subj_info add partition p_famsf2 values ('famsf2')(
        subpartition p_famsf2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.fin_am_subj_info modify partition p_famsf2
    add subpartition p_famsf2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.fin_am_subj_info_famsf2_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.fin_am_subj_info partition for ('famsf2')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.fin_am_subj_info_famsf2_tm
compress ${option_switch} for query high
as
select
    tepla_sob_id -- 模板账套编号
    ,lp_id -- 法人编号
    ,subj_id -- 科目编号
    ,subj_name -- 科目名称
    ,super_subj_id -- 上级科目编号
    ,bal_dir_cd -- 科目余额方向
    ,subj_level_cd -- 科目等级代码
    ,accti_qtty_flg -- 核算数量标志
    ,int_accr_flg -- 计息标志
    ,allow_od_flg -- 允许透支标志
    ,create_level4_subj_flg -- 生成四级科目标志
    ,subj_acct_type_cd -- 科目账户类型代码
    ,entry_org_id -- 记账机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.fin_am_subj_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.fin_am_subj_info_famsf2_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.fin_am_subj_info partition for ('famsf2') where 0=1;

-- 2.1 insert data to tm table
-- fams_ban_bok_subject-1
insert into ${iml_schema}.fin_am_subj_info_famsf2_tm(
    tepla_sob_id -- 模板账套编号
    ,lp_id -- 法人编号
    ,subj_id -- 科目编号
    ,subj_name -- 科目名称
    ,super_subj_id -- 上级科目编号
    ,bal_dir_cd -- 科目余额方向
    ,subj_level_cd -- 科目等级代码
    ,accti_qtty_flg -- 核算数量标志
    ,int_accr_flg -- 计息标志
    ,allow_od_flg -- 允许透支标志
    ,create_level4_subj_flg -- 生成四级科目标志
    ,subj_acct_type_cd -- 科目账户类型代码
    ,entry_org_id -- 记账机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.BOOKSET_ID -- 模板账套编号
    ,'9999' -- 法人编号
    ,P1.SUBJECT_NO -- 科目编号
    ,P1.SUBJECT_NAME -- 科目名称
    ,P1.FSUBJECT_ID -- 上级科目编号
    ,P1.BAL_FLAG -- 科目余额方向
    ,P1.SUBJECT_LEVEL -- 科目等级代码
    ,P1.ACC_QUA_FLAG -- 核算数量标志
    ,nvl(trim(P1.ACC_INT_FLAG),'-') -- 计息标志
    ,P1.OVERDRAWN_FLAG -- 允许透支标志
    ,P1.GEN_DETSUB_FLAG -- 生成四级科目标志
    ,NVL(TRIM(P1.ACCT_TYPE),'00') -- 科目账户类型代码
    ,P1.ORGCODE -- 记账机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_ban_bok_subject' -- 源表名称
    ,'famsf2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_ban_bok_subject p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.fin_am_subj_info_famsf2_tm 
  	                                group by 
  	                                        tepla_sob_id
  	                                        ,lp_id
  	                                        ,subj_id
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
insert /*+ append */ into ${iml_schema}.fin_am_subj_info_famsf2_ex(
    tepla_sob_id -- 模板账套编号
    ,lp_id -- 法人编号
    ,subj_id -- 科目编号
    ,subj_name -- 科目名称
    ,super_subj_id -- 上级科目编号
    ,bal_dir_cd -- 科目余额方向
    ,subj_level_cd -- 科目等级代码
    ,accti_qtty_flg -- 核算数量标志
    ,int_accr_flg -- 计息标志
    ,allow_od_flg -- 允许透支标志
    ,create_level4_subj_flg -- 生成四级科目标志
    ,subj_acct_type_cd -- 科目账户类型代码
    ,entry_org_id -- 记账机构编号
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.tepla_sob_id, o.tepla_sob_id) as tepla_sob_id -- 模板账套编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.subj_id, o.subj_id) as subj_id -- 科目编号
    ,nvl(n.subj_name, o.subj_name) as subj_name -- 科目名称
    ,nvl(n.super_subj_id, o.super_subj_id) as super_subj_id -- 上级科目编号
    ,nvl(n.bal_dir_cd, o.bal_dir_cd) as bal_dir_cd -- 科目余额方向
    ,nvl(n.subj_level_cd, o.subj_level_cd) as subj_level_cd -- 科目等级代码
    ,nvl(n.accti_qtty_flg, o.accti_qtty_flg) as accti_qtty_flg -- 核算数量标志
    ,nvl(n.int_accr_flg, o.int_accr_flg) as int_accr_flg -- 计息标志
    ,nvl(n.allow_od_flg, o.allow_od_flg) as allow_od_flg -- 允许透支标志
    ,nvl(n.create_level4_subj_flg, o.create_level4_subj_flg) as create_level4_subj_flg -- 生成四级科目标志
    ,nvl(n.subj_acct_type_cd, o.subj_acct_type_cd) as subj_acct_type_cd -- 科目账户类型代码
    ,nvl(n.entry_org_id, o.entry_org_id) as entry_org_id -- 记账机构编号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.tepla_sob_id is null
                and o.lp_id is null
                and o.subj_id is null
            ) or (
                o.subj_name <> n.subj_name
                or o.super_subj_id <> n.super_subj_id
                or o.bal_dir_cd <> n.bal_dir_cd
                or o.subj_level_cd <> n.subj_level_cd
                or o.accti_qtty_flg <> n.accti_qtty_flg
                or o.int_accr_flg <> n.int_accr_flg
                or o.allow_od_flg <> n.allow_od_flg
                or o.create_level4_subj_flg <> n.create_level4_subj_flg
                or o.subj_acct_type_cd <> n.subj_acct_type_cd
                or o.entry_org_id <> n.entry_org_id
            ) or (
                 case when (
                           n.tepla_sob_id is null
                           and n.lp_id is null
                           and n.subj_id is null
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
                n.tepla_sob_id is null
                and n.lp_id is null
                and n.subj_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.fin_am_subj_info_famsf2_tm n
    full join ${iml_schema}.fin_am_subj_info_famsf2_bk o
        on
            o.tepla_sob_id = n.tepla_sob_id
            and o.lp_id = n.lp_id
            and o.subj_id = n.subj_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.fin_am_subj_info truncate partition for ('famsf2') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.fin_am_subj_info exchange subpartition p_famsf2_${batch_date} with table ${iml_schema}.fin_am_subj_info_famsf2_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.fin_am_subj_info drop subpartition p_famsf2_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.fin_am_subj_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.fin_am_subj_info_famsf2_tm purge;
drop table ${iml_schema}.fin_am_subj_info_famsf2_ex purge;
drop table ${iml_schema}.fin_am_subj_info_famsf2_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'fin_am_subj_info', partname => 'p_famsf2_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);