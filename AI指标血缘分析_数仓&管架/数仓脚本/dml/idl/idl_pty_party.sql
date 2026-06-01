/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_pty_party
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
--alter table ${idl_schema}.pty_party drop partition p_${last_date};
alter table ${idl_schema}.pty_party drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.pty_party add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.pty_party (
    etl_dt  -- 数据日期
    ,party_id  -- 当事人编号
    ,lp_id  -- 法人编号
    ,src_party_id  -- 源当事人编号
    ,party_name  -- 当事人名称
    ,party_type_cd  -- 当事人类型代码
    ,effect_dt  -- 生效日期
    ,invalid_dt  -- 失效日期
    ,src_party_type_cd  -- 源当事人类型代码
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
    ,job_cd --任务代码
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.party_id,chr(13),''),chr(10),'')  -- 当事人编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.src_party_id,chr(13),''),chr(10),'')  -- 源当事人编号
    ,replace(replace(t1.party_name,chr(13),''),chr(10),'')  -- 当事人名称
    ,replace(replace(t1.party_type_cd,chr(13),''),chr(10),'')  -- 当事人类型代码
    ,t1.effect_dt  -- 生效日期
    ,t1.invalid_dt  -- 失效日期
    ,replace(replace(t1.src_party_type_cd,chr(13),''),chr(10),'')  -- 源当事人类型代码
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
	,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  --任务代码
from ${iml_schema}.pty_party t1    --当事人
where etl_dt = to_date('${batch_date}','yyyymmdd') ;
commit;

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'pty_party',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);