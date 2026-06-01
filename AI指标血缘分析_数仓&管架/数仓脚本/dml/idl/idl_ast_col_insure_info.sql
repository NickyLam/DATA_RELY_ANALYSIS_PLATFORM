/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_ast_col_insure_info
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
--alter table ${idl_schema}.ast_col_insure_info drop partition p_${last_date};
alter table ${idl_schema}.ast_col_insure_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.ast_col_insure_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.ast_col_insure_info (
    etl_dt  -- 数据日期
    ,asset_id  -- 资产编号
    ,lp_id  -- 法人编号
    ,insure_seq_num  -- 保险序号
    ,insure_pl_id  -- 保险单编号
    ,insu_comp_name  -- 保险公司名称
    ,insu_comp_orgnz_cd  -- 保险公司组织机构代码
    ,full_amt_insure_flg  -- 全额投保标志
    ,insure_insud_amt  -- 保险承保金额
    ,begin_dt  -- 起始日期
    ,exp_dt  -- 到期日期
    ,check_guar_dt  -- 核保日期
    ,fst_ctfer_name  -- 第一核保人姓名
    ,secd_ctfer_name  -- 第二核保人姓名
    ,operr_id  -- 操作员编号
    ,insure_status_cd  -- 保险状态代码
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
    ,job_cd -- 任务编码
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.asset_id,chr(13),''),chr(10),'')  -- 资产编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.insure_seq_num,chr(13),''),chr(10),'')  -- 保险序号
    ,replace(replace(t1.insure_pl_id,chr(13),''),chr(10),'')  -- 保险单编号
    ,replace(replace(t1.insu_comp_name,chr(13),''),chr(10),'')  -- 保险公司名称
    ,replace(replace(t1.insu_comp_orgnz_cd,chr(13),''),chr(10),'')  -- 保险公司组织机构代码
    ,replace(replace(t1.full_amt_insure_flg,chr(13),''),chr(10),'')  -- 全额投保标志
    ,t1.insure_insud_amt  -- 保险承保金额
    ,t1.begin_dt  -- 起始日期
    ,t1.exp_dt  -- 到期日期
    ,t1.check_guar_dt  -- 核保日期
    ,replace(replace(t1.fst_ctfer_name,chr(13),''),chr(10),'')  -- 第一核保人姓名
    ,replace(replace(t1.secd_ctfer_name,chr(13),''),chr(10),'')  -- 第二核保人姓名
    ,replace(replace(t1.operr_id,chr(13),''),chr(10),'')  -- 操作员编号
    ,replace(replace(t1.insure_status_cd,chr(13),''),chr(10),'')  -- 保险状态代码
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务编码
from ${iml_schema}.ast_col_insure_info t1    --押品保险信息
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'ast_col_insure_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);