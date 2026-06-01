/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_fin_am_subj_info
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--alter table ${idl_schema}.fin_am_subj_info drop partition p_${last_date};
alter table ${idl_schema}.fin_am_subj_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.fin_am_subj_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.fin_am_subj_info (
    etl_dt  -- 数据日期
    ,tepla_sob_id  -- 模板账套编号
    ,lp_id  -- 法人编号
    ,subj_id  -- 科目编号
    ,subj_name  -- 科目名称
    ,super_subj_id  -- 上级科目编号
    ,bal_dir_cd  -- 余额方向代码
    ,subj_level_cd  -- 科目等级代码
    ,accti_qtty_flg  -- 核算数量标志
    ,int_accr_flg  -- 计息标志
    ,allow_od_flg  -- 允许透支标志
    ,create_level4_subj_flg  -- 生成四级科目标志
    ,subj_acct_type_cd  -- 科目账户类型代码
    ,entry_org_id  -- 记账机构编号
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识

)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.tepla_sob_id,chr(13),''),chr(10),'')  -- 模板账套编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.subj_id,chr(13),''),chr(10),'')  -- 科目编号
    ,replace(replace(t1.subj_name,chr(13),''),chr(10),'')  -- 科目名称
    ,replace(replace(t1.super_subj_id,chr(13),''),chr(10),'')  -- 上级科目编号
    ,replace(replace(t1.bal_dir_cd,chr(13),''),chr(10),'')  -- 余额方向代码
    ,replace(replace(t1.subj_level_cd,chr(13),''),chr(10),'')  -- 科目等级代码
    ,replace(replace(t1.accti_qtty_flg,chr(13),''),chr(10),'')  -- 核算数量标志
    ,replace(replace(t1.int_accr_flg,chr(13),''),chr(10),'')  -- 计息标志
    ,replace(replace(t1.allow_od_flg,chr(13),''),chr(10),'')  -- 允许透支标志
    ,replace(replace(t1.create_level4_subj_flg,chr(13),''),chr(10),'')  -- 生成四级科目标志
    ,replace(replace(t1.subj_acct_type_cd,chr(13),''),chr(10),'')  -- 科目账户类型代码
    ,replace(replace(t1.entry_org_id,chr(13),''),chr(10),'')  -- 记账机构编号
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识

from ${iml_schema}.fin_am_subj_info t1    --资管科目信息
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'fin_am_subj_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);