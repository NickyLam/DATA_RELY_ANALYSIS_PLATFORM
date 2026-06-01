/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_ast_ghb_finc_prod_inpwn_info
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
--alter table ${idl_schema}.ast_ghb_finc_prod_inpwn_info drop partition p_${last_date};
alter table ${idl_schema}.ast_ghb_finc_prod_inpwn_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.ast_ghb_finc_prod_inpwn_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.ast_ghb_finc_prod_inpwn_info (
    etl_dt  -- 数据日期
    ,asset_id  -- 资产编号
    ,lp_id  -- 法人编号
    ,finc_prod_id  -- 理财产品编号
    ,finc_prod_name  -- 理财产品名称
    ,cap_stl_acct_num  -- 资金结算账号
    ,margin_acct_num  -- 保证金账号
    ,cap_avl_days  -- 资金到帐天数
    ,value_dt  -- 起息日期
    ,exp_dt  -- 到期日期
    ,inpwn_lot  -- 质押份额
    ,expe_yld_rat  -- 预期收益率
    ,curr_cd  -- 币种代码
    ,tot_lot  -- 总份额
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
    ,job_cd -- 任务编码

)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.asset_id,chr(13),''),chr(10),'')  -- 资产编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.finc_prod_id,chr(13),''),chr(10),'')  -- 理财产品编号
    ,replace(replace(t1.finc_prod_name,chr(13),''),chr(10),'')  -- 理财产品名称
    ,replace(replace(t1.cap_stl_acct_num,chr(13),''),chr(10),'')  -- 资金结算账号
    ,replace(replace(t1.margin_acct_num,chr(13),''),chr(10),'')  -- 保证金账号
    ,t1.cap_avl_days  -- 资金到帐天数
    ,t1.value_dt  -- 起息日期
    ,t1.exp_dt  -- 到期日期
    ,t1.inpwn_lot  -- 质押份额
    ,t1.expe_yld_rat  -- 预期收益率
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.tot_lot  -- 总份额
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务编码

from ${iml_schema}.ast_ghb_finc_prod_inpwn_info t1    --本行理财产品质押信息
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'ast_ghb_finc_prod_inpwn_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);