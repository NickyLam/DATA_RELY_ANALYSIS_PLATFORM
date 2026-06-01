/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_fin_am_sob
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
--alter table ${idl_schema}.fin_am_sob drop partition p_${last_date};
alter table ${idl_schema}.fin_am_sob drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.fin_am_sob add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.fin_am_sob (
    etl_dt  -- 数据日期
    ,sob_id  -- 账套编号
    ,lp_id  -- 法人编号
    ,sob_name  -- 账套名称
    ,sob_fname  -- 账套全称
    ,sob_cate_cd  -- 账套类别代码
    ,curr_cd  -- 币种代码
    ,tepla_sob_id  -- 模板账套编号
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识

)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.sob_id,chr(13),''),chr(10),'')  -- 账套编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.sob_name,chr(13),''),chr(10),'')  -- 账套名称
    ,replace(replace(t1.sob_fname,chr(13),''),chr(10),'')  -- 账套全称
    ,replace(replace(t1.sob_cate_cd,chr(13),''),chr(10),'')  -- 账套类别代码
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,replace(replace(t1.tepla_sob_id,chr(13),''),chr(10),'')  -- 模板账套编号
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识

from ${iml_schema}.fin_am_sob t1    --资管账套
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'fin_am_sob',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);