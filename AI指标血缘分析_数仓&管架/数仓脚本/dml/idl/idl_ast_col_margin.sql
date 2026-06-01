/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_ast_col_margin
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
--alter table ${idl_schema}.ast_col_margin drop partition p_${last_date};
alter table ${idl_schema}.ast_col_margin drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.ast_col_margin add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.ast_col_margin (
    etl_dt  -- 数据日期
    ,asset_id  -- 资产编号
    ,lp_id  -- 法人编号
    ,col_acct_num  -- 押品账号
    ,begin_dt  -- 起始日期
    ,closing_dt  -- 截止日期
    ,acct_bal  -- 账户余额
    ,margin_flow_id  -- 保证金流水编号
    ,is_cmplt_froz_flg  -- 是否完成冻结标志
    ,margin_froz_amt  -- 保证金冻结金额
    ,remark  -- 备注
    ,sub_acct_id  -- 子账户编号
    ,open_acct_org  -- 开户机构
    ,aval_bal  -- 可用余额
    ,curr_cd  -- 币种代码
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
    ,job_cd -- 任务编码
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.asset_id,chr(13),''),chr(10),'')  -- 资产编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.col_acct_num,chr(13),''),chr(10),'')  -- 押品账号
    ,t1.begin_dt  -- 起始日期
    ,t1.closing_dt  -- 截止日期
    ,t1.acct_bal  -- 账户余额
    ,replace(replace(t1.margin_flow_id,chr(13),''),chr(10),'')  -- 保证金流水编号
    ,replace(replace(t1.is_cmplt_froz_flg,chr(13),''),chr(10),'')  -- 是否完成冻结标志
    ,t1.margin_froz_amt  -- 保证金冻结金额
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 备注
    ,replace(replace(t1.sub_acct_id,chr(13),''),chr(10),'')  -- 子账户编号
    ,replace(replace(t1.open_acct_org,chr(13),''),chr(10),'')  -- 开户机构
    ,t1.aval_bal  -- 可用余额
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务编码
from ${iml_schema}.ast_col_margin t1    --押品保证金
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'ast_col_margin',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);