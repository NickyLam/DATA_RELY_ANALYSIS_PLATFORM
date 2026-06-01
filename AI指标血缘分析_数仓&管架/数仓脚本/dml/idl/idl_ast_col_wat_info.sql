/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_ast_col_wat_info
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
--alter table ${idl_schema}.ast_col_wat_info drop partition p_${last_date};
alter table ${idl_schema}.ast_col_wat_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.ast_col_wat_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.ast_col_wat_info (
    etl_dt  -- 数据日期
    ,asset_id  -- 资产编号
    ,lp_id  -- 法人编号
    ,wat_id  -- 权证编号
    ,wat_num  -- 权证号码
    ,wat_name  -- 权证名称
    ,wat_type_cd  -- 权证类型代码
    ,licen_issue_autho_name  -- 发证机关名称
    ,issue_dt  -- 发证日期
    ,valid_closing_dt  -- 有效截止日期
    ,rgst_dt  -- 登记日期
    ,rgst_emply_id  -- 登记员工编号
    ,insto_flow_id  -- 入库流程编号
    ,acss_cont_id  -- 从合同编号
    ,pri_contr_id  -- 主合同编号
    ,insto_id  -- 入库编号
    ,insto_dt  -- 入库日期
    ,ex_flow_id  -- 出库流程编号
    ,ex_dt  -- 出库日期
    ,latest_debit_flow_id  -- 最新借用流程编号
    ,latest_debit_dt  -- 最新借用日期
    ,rn_flow_id  -- 续借流程编号
    ,rn_dt  -- 续借日期
    ,rn_cnt  -- 续借次数
    ,latest_rtn_dt  -- 最新归还日期
    ,wat_status_cd  -- 权证状态代码
    ,uniq_wat_flg  -- 唯一权证标志
    ,flow_status_cd  -- 流程状态代码
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
    ,job_cd -- 任务编码

)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.asset_id,chr(13),''),chr(10),'')  -- 资产编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.wat_id,chr(13),''),chr(10),'')  -- 权证编号
    ,replace(replace(t1.wat_num,chr(13),''),chr(10),'')  -- 权证号码
    ,replace(replace(t1.wat_name,chr(13),''),chr(10),'')  -- 权证名称
    ,replace(replace(t1.wat_type_cd,chr(13),''),chr(10),'')  -- 权证类型代码
    ,replace(replace(t1.licen_issue_autho_name,chr(13),''),chr(10),'')  -- 发证机关名称
    ,t1.issue_dt  -- 发证日期
    ,t1.valid_closing_dt  -- 有效截止日期
    ,t1.rgst_dt  -- 登记日期
    ,replace(replace(t1.rgst_emply_id,chr(13),''),chr(10),'')  -- 登记员工编号
    ,replace(replace(t1.insto_flow_id,chr(13),''),chr(10),'')  -- 入库流程编号
    ,replace(replace(t1.acss_cont_id,chr(13),''),chr(10),'')  -- 从合同编号
    ,replace(replace(t1.pri_contr_id,chr(13),''),chr(10),'')  -- 主合同编号
    ,replace(replace(t1.insto_id,chr(13),''),chr(10),'')  -- 入库编号
    ,t1.insto_dt  -- 入库日期
    ,replace(replace(t1.ex_flow_id,chr(13),''),chr(10),'')  -- 出库流程编号
    ,t1.ex_dt  -- 出库日期
    ,replace(replace(t1.latest_debit_flow_id,chr(13),''),chr(10),'')  -- 最新借用流程编号
    ,t1.latest_debit_dt  -- 最新借用日期
    ,replace(replace(t1.rn_flow_id,chr(13),''),chr(10),'')  -- 续借流程编号
    ,t1.rn_dt  -- 续借日期
    ,t1.rn_cnt  -- 续借次数
    ,t1.latest_rtn_dt  -- 最新归还日期
    ,replace(replace(t1.wat_status_cd,chr(13),''),chr(10),'')  -- 权证状态代码
    ,replace(replace(t1.uniq_wat_flg,chr(13),''),chr(10),'')  -- 唯一权证标志
    ,replace(replace(t1.flow_status_cd,chr(13),''),chr(10),'')  -- 流程状态代码
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务编码

from ${iml_schema}.ast_col_wat_info t1    --押品权证信息
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'ast_col_wat_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);