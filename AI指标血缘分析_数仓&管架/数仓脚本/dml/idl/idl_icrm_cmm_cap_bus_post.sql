/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_cmm_cap_bus_post
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
alter table ${idl_schema}.icrm_cmm_cap_bus_post drop partition p_${last_date};
alter table ${idl_schema}.icrm_cmm_cap_bus_post drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_cmm_cap_bus_post add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_cmm_cap_bus_post partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,bal_id  -- 余额编号
    ,asset_type_cd  -- 资产类型代码
    ,asset_id  -- 资产编号
    ,tran_acct_b_id  -- 交易账簿编号
    ,dept_id  -- 部门编号
    ,bus_id  -- 业务编号
    ,subj_id  -- 科目编号
    ,stl_dt  -- 结算日期
    ,bus_cate_name  -- 业务类别名称
    ,strk_bal_flg  -- 冲账标志
    ,bond_id  -- 债券编号
    ,curr_cd  -- 币种代码
    ,hold_pos  -- 持有仓位
    ,hold_fac_val  -- 持有面值
    ,net_price_cost  -- 净价成本
    ,int_adj_amt  -- 利息调整金额
    ,evha_val_chag  -- 公允价值变动
    ,int_cost  -- 利息成本
    ,full_price_cost  -- 全价成本
    ,impam_prep  -- 减值准备
    ,spd_prft  -- 价差收益
    ,amort_prft  -- 摊销收益
    ,int_prft  -- 利息收益
    ,evha_val_chag_pl  -- 公允价值变动损益
    ,impam_loss  -- 减值损失
    ,tran_fee  -- 交易费用
    ,actl_int_rat  -- 实际利率
    ,value_dt  -- 起息日期
    ,exp_dt  -- 到期日期
    ,happ_amt  -- 发生金额
    ,job_cd  -- 任务代码
    ,main_asset_id      --主资产编号  
    ,std_prod_id        --标准产品编号 
    ,entry_org_id       --记账机构编号 
    ,asset_type_name    --资产类型名称 
    ,asset_thd_cls_cd   --资产三分类代码
    ,curr_bal           --当前余额   
    ,etl_timestamp  -- ETL数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.bal_id,chr(13),''),chr(10),'')  -- 余额编号
    ,replace(replace(t1.asset_type_cd,chr(13),''),chr(10),'')  -- 资产类型代码
    ,replace(replace(t1.asset_id,chr(13),''),chr(10),'')  -- 资产编号
    ,replace(replace(t1.tran_acct_b_id,chr(13),''),chr(10),'')  -- 交易账簿编号
    ,replace(replace(t1.dept_id,chr(13),''),chr(10),'')  -- 部门编号
    ,replace(replace(t1.bus_id,chr(13),''),chr(10),'')  -- 业务编号
    ,replace(replace(t1.subj_id,chr(13),''),chr(10),'')  -- 科目编号
    ,t1.stl_dt  -- 结算日期
    ,replace(replace(t1.bus_cate_name,chr(13),''),chr(10),'')  -- 业务类别名称
    ,replace(replace(t1.strk_bal_flg,chr(13),''),chr(10),'')  -- 冲账标志
    ,replace(replace(t1.bond_id,chr(13),''),chr(10),'')  -- 债券编号
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.hold_pos  -- 持有仓位
    ,t1.hold_fac_val  -- 持有面值
    ,t1.net_price_cost  -- 净价成本
    ,t1.int_adj_amt  -- 利息调整金额
    ,t1.evha_val_chag  -- 公允价值变动
    ,t1.int_cost  -- 利息成本
    ,t1.full_price_cost  -- 全价成本
    ,t1.impam_prep  -- 减值准备
    ,t1.spd_prft  -- 价差收益
    ,t1.amort_prft  -- 摊销收益
    ,t1.int_prft  -- 利息收益
    ,t1.evha_val_chag_pl  -- 公允价值变动损益
    ,t1.impam_loss  -- 减值损失
    ,t1.tran_fee  -- 交易费用
    ,t1.actl_int_rat  -- 实际利率
    ,t1.value_dt  -- 起息日期
    ,t1.exp_dt  -- 到期日期
    ,t1.happ_amt  -- 发生金额
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,replace(replace(t1.main_asset_id,chr(13),''),chr(10),'') as main_asset_id          --主资产编号     
    ,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id              --标准产品编号    
    ,replace(replace(t1.entry_org_id,chr(13),''),chr(10),'') as entry_org_id            --记账机构编号    
    ,replace(replace(t1.asset_type_name,chr(13),''),chr(10),'') as asset_type_name      --资产类型名称    
    ,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd    --资产三分类代码   
    ,t1.curr_bal as curr_bal                                                            --当前余额      
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${icl_schema}.cmm_cap_bus_post t1    --资金业务持仓
where t1.etl_dt= to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_cmm_cap_bus_post',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);