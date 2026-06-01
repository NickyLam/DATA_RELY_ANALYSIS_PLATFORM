/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_ref_ibank_asset_prod_type
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
alter table ${idl_schema}.icrm_ref_ibank_asset_prod_type drop partition p_${last_date};
alter table ${idl_schema}.icrm_ref_ibank_asset_prod_type drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_ref_ibank_asset_prod_type add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_ref_ibank_asset_prod_type partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,prod_type_cd  -- 产品类型代码
    ,lp_id  -- 法人编号
    ,asset_type_cd  -- 资产类型代码
    ,prod_type_name  -- 产品类型名称
    ,auto_ird_flg  -- 自动息差标志
    ,delay_exp_flg  -- 延迟到期标志
    ,amort_way_cd  -- 摊销方式代码
    ,amort_way_name  -- 摊销方式名称
    ,evltion_flg  -- 估值标志
    ,evltion_type_cd  -- 估值类型代码
    ,drawdown_flg  -- 支取标志
    ,provi_flg  -- 计提标志
    ,col_int_flg  -- 收息标志
    ,auto_ovdue_flg  -- 自动逾期标志
    ,on_acct_id  -- 挂账账户编号
    ,on_acct_name  -- 挂账账户名
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'')  -- 产品类型代码
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.asset_type_cd,chr(13),''),chr(10),'')  -- 资产类型代码
    ,replace(replace(t1.prod_type_name,chr(13),''),chr(10),'')  -- 产品类型名称
    ,replace(replace(t1.auto_ird_flg,chr(13),''),chr(10),'')  -- 自动息差标志
    ,replace(replace(t1.delay_exp_flg,chr(13),''),chr(10),'')  -- 延迟到期标志
    ,replace(replace(t1.amort_way_cd,chr(13),''),chr(10),'')  -- 摊销方式代码
    ,replace(replace(t1.amort_way_name,chr(13),''),chr(10),'')  -- 摊销方式名称
    ,replace(replace(t1.evltion_flg,chr(13),''),chr(10),'')  -- 估值标志
    ,replace(replace(t1.evltion_type_cd,chr(13),''),chr(10),'')  -- 估值类型代码
    ,replace(replace(t1.drawdown_flg,chr(13),''),chr(10),'')  -- 支取标志
    ,replace(replace(t1.provi_flg,chr(13),''),chr(10),'')  -- 计提标志
    ,replace(replace(t1.col_int_flg,chr(13),''),chr(10),'')  -- 收息标志
    ,replace(replace(t1.auto_ovdue_flg,chr(13),''),chr(10),'')  -- 自动逾期标志
    ,replace(replace(t1.on_acct_id,chr(13),''),chr(10),'')  -- 挂账账户编号
    ,replace(replace(t1.on_acct_name,chr(13),''),chr(10),'')  -- 挂账账户名
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iml_schema}.ref_ibank_asset_prod_type t1    --同业资产产品类型表
where t1.create_dt<= to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_ref_ibank_asset_prod_type',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);