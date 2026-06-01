/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_prd_ibank_post_asset
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
alter table ${idl_schema}.icrm_prd_ibank_post_asset drop partition p_${last_date};
alter table ${idl_schema}.icrm_prd_ibank_post_asset drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_prd_ibank_post_asset add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_prd_ibank_post_asset partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,prod_id  -- 产品编号
    ,lp_id  -- 法人编号
    ,prod_type_cd  -- 产品类型代码
    ,prod_cd  -- 产品代码
    ,prod_name  -- 产品名称
    ,effect_dt  -- 生效日期
    ,ftp_int_rat  -- ftp利率
    ,remark  -- 备注
    ,value_dt  -- 起息日期
    ,exp_dt  -- 到期日期
    ,rgst_type_cd  -- 登记类型代码
    ,proj  -- 项目
    ,risk_wt  -- 风险权重
    ,risk_asset_tot  -- 风险资产总额
    ,rgst_dt  -- 登记日期
    ,market_inst  -- MARKET_INST
    ,customer_manager  -- CUSTOMER_MANAGER
    ,asset_type_cd  -- 资产类型代码
    ,market_type_cd  -- 市场类型代码
    ,vch_accti_obj_id  -- 券核算对象编号
    ,amt  -- 金额
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.prod_id,chr(13),''),chr(10),'')  -- 产品编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'')  -- 产品类型代码
    ,replace(replace(t1.prod_cd,chr(13),''),chr(10),'')  -- 产品代码
    ,replace(replace(t1.prod_name,chr(13),''),chr(10),'')  -- 产品名称
    ,t1.effect_dt  -- 生效日期
    ,t1.ftp_int_rat  -- ftp利率
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 备注
    ,t1.value_dt  -- 起息日期
    ,t1.exp_dt  -- 到期日期
    ,replace(replace(t1.rgst_type_cd,chr(13),''),chr(10),'')  -- 登记类型代码
    ,replace(replace(t1.proj,chr(13),''),chr(10),'')  -- 项目
    ,replace(replace(t1.risk_wt,chr(13),''),chr(10),'')  -- 风险权重
    ,t1.risk_asset_tot  -- 风险资产总额
    ,t1.rgst_dt  -- 登记日期
    ,replace(replace(t1.market_inst,chr(13),''),chr(10),'')  -- MARKET_INST
    ,replace(replace(t1.customer_manager,chr(13),''),chr(10),'')  -- CUSTOMER_MANAGER
    ,replace(replace(t1.asset_type_cd,chr(13),''),chr(10),'')  -- 资产类型代码
    ,replace(replace(t1.market_type_cd,chr(13),''),chr(10),'')  -- 市场类型代码
    ,replace(replace(t1.vch_accti_obj_id,chr(13),''),chr(10),'')  -- 券核算对象编号
    ,t1.amt  -- 金额
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iml_schema}.prd_ibank_post_asset t1    --同业持仓资产
where t1.create_dt<= to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_prd_ibank_post_asset',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);