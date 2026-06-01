/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_ast_col_rgst_info
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
--alter table ${idl_schema}.ast_col_rgst_info drop partition p_${last_date};
alter table ${idl_schema}.ast_col_rgst_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.ast_col_rgst_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.ast_col_rgst_info (
    etl_dt  -- 数据日期
    ,asset_id  -- 资产编号
    ,lp_id  -- 法人编号
    ,rgst_seq_num  -- 登记序号
    ,rgst_org_name  -- 登记机构名称
    ,rgst_val  -- 登记价值
    ,rgst_dt  -- 登记日期
    ,rgst_exp_dt  -- 登记到期日期
    ,pre_mtg_flg  -- 预抵押标志
    ,pre_mtg_rgst_dt  -- 预抵押登记日期
    ,pre_mtg_rgst_invalid_dt  -- 预抵押登记失效日期
    ,operr_id  -- 操作员编号
    ,rgst_cert_id  -- 登记证书编号
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
    ,job_cd -- 任务编码

)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.asset_id,chr(13),''),chr(10),'')  -- 资产编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.rgst_seq_num,chr(13),''),chr(10),'')  -- 登记序号
    ,replace(replace(t1.rgst_org_name,chr(13),''),chr(10),'')  -- 登记机构名称
    ,t1.rgst_val  -- 登记价值
    ,t1.rgst_dt  -- 登记日期
    ,t1.rgst_exp_dt  -- 登记到期日期
    ,replace(replace(t1.pre_mtg_flg,chr(13),''),chr(10),'')  -- 预抵押标志
    ,t1.pre_mtg_rgst_dt  -- 预抵押登记日期
    ,t1.pre_mtg_rgst_invalid_dt  -- 预抵押登记失效日期
    ,replace(replace(t1.operr_id,chr(13),''),chr(10),'')  -- 操作员编号
    ,replace(replace(t1.rgst_cert_id,chr(13),''),chr(10),'')  -- 登记证书编号
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务编码

from ${iml_schema}.ast_col_rgst_info t1    --押品登记信息
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'ast_col_rgst_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);