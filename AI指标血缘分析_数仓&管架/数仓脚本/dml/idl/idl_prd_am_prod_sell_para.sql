/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_prd_am_prod_sell_para
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
--alter table ${idl_schema}.prd_am_prod_sell_para drop partition p_${last_date};
alter table ${idl_schema}.prd_am_prod_sell_para drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.prd_am_prod_sell_para add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.prd_am_prod_sell_para (
    etl_dt  -- 数据日期
    ,prod_id  -- 产品编号
    ,lp_id  -- 法人编号
    ,am_prod_id  -- 资管产品编号
    ,finc_prod_id  -- 理财产品编号
    ,sell_chn_cd_comb  -- 销售渠道代码组合
    ,sell_rg_cd_comb  -- 销售地区代码组合
    ,target_cust_type_cd_comb  -- 目标客户类型代码组合
    ,coll_amt_uplmi  -- 募集金额上限
    ,coll_amt_lolmi  -- 募集金额下限
    ,plan_coll_amt  -- 计划募集金额
    ,subscr_amt_sp  -- 认购金额起点
    ,least_supp_amt  -- 最少追加金额
    ,huge_redem_ratio  -- 巨额赎回比例
    ,lowt_book_lot  -- 最低账面份额
    ,lowt_redem_lot  -- 最低赎回份额
    ,inpwned_flg  -- 可质押标志
    ,fir_coll_start_dt  -- 首次募集开始日期
    ,fir_coll_end_dt  -- 首次募集结束日期
    ,supt_consmt_flg  -- 支持代销标志
    ,allow_adv_termnt_flg  -- 允许提前终止标志
    ,allow_cust_redem_flg  -- 允许客户赎回标志
    ,deflt_redem_flg  -- 可违约赎回标志
    ,advd_found_flg  -- 可提前成立标志
    ,invest_flg  -- 可续投标志
    ,ibank_cust_id_comb  -- 同业客户编号组合
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识

)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.prod_id,chr(13),''),chr(10),'')  -- 产品编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.am_prod_id,chr(13),''),chr(10),'')  -- 资管产品编号
    ,replace(replace(t1.finc_prod_id,chr(13),''),chr(10),'')  -- 理财产品编号
    ,replace(replace(t1.sell_chn_cd_comb,chr(13),''),chr(10),'')  -- 销售渠道代码组合
    ,replace(replace(t1.sell_rg_cd_comb,chr(13),''),chr(10),'')  -- 销售地区代码组合
    ,replace(replace(t1.target_cust_type_cd_comb,chr(13),''),chr(10),'')  -- 目标客户类型代码组合
    ,t1.coll_amt_uplmi  -- 募集金额上限
    ,t1.coll_amt_lolmi  -- 募集金额下限
    ,t1.plan_coll_amt  -- 计划募集金额
    ,t1.subscr_amt_sp  -- 认购金额起点
    ,t1.least_supp_amt  -- 最少追加金额
    ,t1.huge_redem_ratio  -- 巨额赎回比例
    ,t1.lowt_book_lot  -- 最低账面份额
    ,t1.lowt_redem_lot  -- 最低赎回份额
    ,replace(replace(t1.inpwned_flg,chr(13),''),chr(10),'')  -- 可质押标志
    ,t1.fir_coll_start_dt  -- 首次募集开始日期
    ,t1.fir_coll_end_dt  -- 首次募集结束日期
    ,replace(replace(t1.supt_consmt_flg,chr(13),''),chr(10),'')  -- 支持代销标志
    ,replace(replace(t1.allow_adv_termnt_flg,chr(13),''),chr(10),'')  -- 允许提前终止标志
    ,replace(replace(t1.allow_cust_redem_flg,chr(13),''),chr(10),'')  -- 允许客户赎回标志
    ,replace(replace(t1.deflt_redem_flg,chr(13),''),chr(10),'')  -- 可违约赎回标志
    ,replace(replace(t1.advd_found_flg,chr(13),''),chr(10),'')  -- 可提前成立标志
    ,replace(replace(t1.invest_flg,chr(13),''),chr(10),'')  -- 可续投标志
    ,replace(replace(t1.ibank_cust_id_comb,chr(13),''),chr(10),'')  -- 同业客户编号组合
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识

from ${iml_schema}.prd_am_prod_sell_para t1    --资管产品销售参数
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'prd_am_prod_sell_para',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);