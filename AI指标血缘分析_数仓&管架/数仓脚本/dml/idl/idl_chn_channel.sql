/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_chn_channel
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
--alter table ${idl_schema}.chn_channel drop partition p_${last_date};
alter table ${idl_schema}.chn_channel drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.chn_channel add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.chn_channel (
    etl_dt  -- 数据日期
    ,chn_id  -- 渠道编号
    ,lp_id  -- 法人编号
    ,chn_type_cd  -- 渠道类型代码
    ,chn_name  -- 渠道名称
    ,chn_status_cd  -- 渠道状态代码
    ,effect_dt  -- 生效日期
    ,invalid_dt  -- 失效日期
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识

)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.chn_id,chr(13),''),chr(10),'')  -- 渠道编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.chn_type_cd,chr(13),''),chr(10),'')  -- 渠道类型代码
    ,replace(replace(t1.chn_name,chr(13),''),chr(10),'')  -- 渠道名称
    ,replace(replace(t1.chn_status_cd,chr(13),''),chr(10),'')  -- 渠道状态代码
    ,t1.effect_dt  -- 生效日期
    ,t1.invalid_dt  -- 失效日期
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识

from ${iml_schema}.chn_channel t1    --渠道
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'chn_channel',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);