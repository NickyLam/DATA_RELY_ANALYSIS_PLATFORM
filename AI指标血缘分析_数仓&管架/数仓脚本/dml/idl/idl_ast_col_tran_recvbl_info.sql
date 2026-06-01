/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_ast_col_tran_recvbl_info
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
--alter table ${idl_schema}.ast_col_tran_recvbl_info drop partition p_${last_date};
alter table ${idl_schema}.ast_col_tran_recvbl_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.ast_col_tran_recvbl_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.ast_col_tran_recvbl_info (
    etl_dt  -- 数据日期
    ,asset_id  -- 资产编号
    ,lp_id  -- 法人编号
    ,lc_num  -- 信用证号码
    ,fac_val_amt  -- 票面金额
    ,inv_id  -- 发票编号
    ,inv_dt  -- 发票日期
    ,inv_exp_dt  -- 发票到期日期
    ,aging  -- 账龄
    ,payer_name  -- 付款人名称
    ,bkrpt_clear_flg  -- 破产清算标志
    ,payer_acct_id  -- 付款人账户编号
    ,advise_acct_recvbl_flg  -- 通知应收账款义务人标志
    ,cred_rht_prod_flg  -- 债权产生标志
    ,other_comnt  -- 其他说明
    ,rela_flg  -- 关系标志
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
    ,replace(replace(t1.lc_num,chr(13),''),chr(10),'')  -- 信用证号码
    ,t1.fac_val_amt  -- 票面金额
    ,replace(replace(t1.inv_id,chr(13),''),chr(10),'')  -- 发票编号
    ,t1.inv_dt  -- 发票日期
    ,t1.inv_exp_dt  -- 发票到期日期
    ,t1.aging  -- 账龄
    ,replace(replace(t1.payer_name,chr(13),''),chr(10),'')  -- 付款人名称
    ,replace(replace(t1.bkrpt_clear_flg,chr(13),''),chr(10),'')  -- 破产清算标志
    ,replace(replace(t1.payer_acct_id,chr(13),''),chr(10),'')  -- 付款人账户编号
    ,replace(replace(t1.advise_acct_recvbl_flg,chr(13),''),chr(10),'')  -- 通知应收账款义务人标志
    ,replace(replace(t1.cred_rht_prod_flg,chr(13),''),chr(10),'')  -- 债权产生标志
    ,replace(replace(t1.other_comnt,chr(13),''),chr(10),'')  -- 其他说明
    ,replace(replace(t1.rela_flg,chr(13),''),chr(10),'')  -- 关系标志
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务编码

from ${iml_schema}.ast_col_tran_recvbl_info t1    --押品交易类应收账款信息
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'ast_col_tran_recvbl_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);