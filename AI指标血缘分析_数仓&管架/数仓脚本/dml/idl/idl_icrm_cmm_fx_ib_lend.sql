/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_cmm_fx_ib_lend
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
alter table ${idl_schema}.icrm_cmm_fx_ib_lend drop partition p_${last_date};
alter table ${idl_schema}.icrm_cmm_fx_ib_lend drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_cmm_fx_ib_lend add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_cmm_fx_ib_lend partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,bus_id  -- 业务编号
    ,dept_id  -- 部门编号
    ,entry_org_id  -- 记账机构编号
    ,tran_acct_b_id  -- 交易账簿编号
    ,cust_id  -- 客户编号
    ,cntpty_id  -- 交易对手编号
    ,cntpty_name  -- 交易对手名称
    ,portf_id  -- 投组编号
    ,portf_name  -- 投组名称
    ,portf_class_name  -- 投组类型名称
    ,inv_port_status_cd  -- 投资组合状态代码
    ,subj_id  -- 科目编号
    ,tran_aim_cd  -- 交易目的代码
    ,tran_dir_cd  -- 交易方向代码
    ,tran_mode_cd  -- 交易模式代码
    ,clear_way_cd  -- 清算方式代码
    ,ib_lend_type_cd  -- 拆借类型代码
    ,clear_org_cd  -- 清算机构代码
    ,input_dt  -- 录入日期
    ,tran_dt  -- 交易日期
    ,value_dt  -- 起息日期
    ,exp_dt  -- 到期日期
    ,tenor  -- 期限
    ,int_rat_adj_way_cd  -- 利率调整方式代码
    ,int_accr_base_cd  -- 计息基准代码
    ,int_rat_float_dir_cd  -- 利率浮动方向代码
    ,int_rat_float_point  -- 利率浮动点数
    ,int_rat_tenor_cd  -- 利率期限代码
    ,exec_int_rat  -- 执行利率
    ,curr_cd  -- 币种代码
    ,tran_amt  -- 交易金额
    ,exp_amt  -- 到期金额
    ,usd_tran_amt  -- 折美元交易金额
    ,acru_int  -- 应计利息
    ,currt_bal  -- 当期余额
    ,td_acru_int  -- 当日应计利息
    ,currt_acru_int  -- 当期应计利息
    ,pay_int_ped_cd  -- 付息周期代码
    ,fir_pay_int_dt  -- 首次付息日期
    ,pay_stub_proc_way_cd  -- 付息残段处理方式代码
    ,bag_status_cd  -- 成交状态代码
    ,tran_src_cd  -- 交易来源代码
    ,tran_site_cd  -- 交易场所代码
    ,bag_id  -- 成交编号
    ,tran_id  -- 交易编号
    ,std_prod_id               --标准产品编号  
    ,asset_thd_cls_cd          --资产三分类代码 
    ,int_recvbl_subj_id        --应收利息科目编号
    ,int_income_subj_id        --利息收入科目编号
    ,int_rat_adj_freq_cd       --利率调整频率代码
    ,base_rat                  --基准利率    
    ,bond_id                   --债券编号    
    ,bond_fac_val              --债券面值    
    ,bond_curr                 --债券币种    
    ,inpwn_ratio               --质押比例    
    ,inpwn_way_cd              --质押方式代码  
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.bus_id,chr(13),''),chr(10),'')  -- 业务编号
    ,replace(replace(t1.dept_id,chr(13),''),chr(10),'')  -- 部门编号
    ,replace(replace(t1.entry_org_id,chr(13),''),chr(10),'')  -- 记账机构编号
    ,replace(replace(t1.tran_acct_b_id,chr(13),''),chr(10),'')  -- 交易账簿编号
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'')  -- 交易对手编号
    ,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'')  -- 交易对手名称
    ,replace(replace(t1.portf_id,chr(13),''),chr(10),'')  -- 投组编号
    ,replace(replace(t1.portf_name,chr(13),''),chr(10),'')  -- 投组名称
    ,replace(replace(t1.portf_class_name,chr(13),''),chr(10),'')  -- 投组类型名称
    ,replace(replace(t1.inv_port_status_cd,chr(13),''),chr(10),'')  -- 投资组合状态代码
    ,replace(replace(t1.subj_id,chr(13),''),chr(10),'')  -- 科目编号
    ,replace(replace(t1.tran_aim_cd,chr(13),''),chr(10),'')  -- 交易目的代码
    ,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'')  -- 交易方向代码
    ,replace(replace(t1.tran_mode_cd,chr(13),''),chr(10),'')  -- 交易模式代码
    ,replace(replace(t1.clear_way_cd,chr(13),''),chr(10),'')  -- 清算方式代码
    ,replace(replace(t1.ib_lend_type_cd,chr(13),''),chr(10),'')  -- 拆借类型代码
    ,replace(replace(t1.clear_org_cd,chr(13),''),chr(10),'')  -- 清算机构代码
    ,t1.input_dt  -- 录入日期
    ,t1.tran_dt  -- 交易日期
    ,t1.value_dt  -- 起息日期
    ,t1.exp_dt  -- 到期日期
    ,t1.tenor  -- 期限
    ,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'')  -- 利率调整方式代码
    ,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'')  -- 计息基准代码
    ,replace(replace(t1.int_rat_float_dir_cd,chr(13),''),chr(10),'')  -- 利率浮动方向代码
    ,t1.int_rat_float_point  -- 利率浮动点数
    ,replace(replace(t1.int_rat_tenor_cd,chr(13),''),chr(10),'')  -- 利率期限代码
    ,t1.exec_int_rat  -- 执行利率
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.tran_amt  -- 交易金额
    ,t1.exp_amt  -- 到期金额
    ,t1.usd_tran_amt  -- 折美元交易金额
    ,t1.acru_int  -- 应计利息
    ,t1.currt_bal  -- 当期余额
    ,t1.td_acru_int  -- 当日应计利息
    ,t1.currt_acru_int  -- 当期应计利息
    ,replace(replace(t1.pay_int_ped_cd,chr(13),''),chr(10),'')  -- 付息周期代码
    ,t1.fir_pay_int_dt  -- 首次付息日期
    ,replace(replace(t1.pay_stub_proc_way_cd,chr(13),''),chr(10),'')  -- 付息残段处理方式代码
    ,replace(replace(t1.bag_status_cd,chr(13),''),chr(10),'')  -- 成交状态代码
    ,replace(replace(t1.tran_src_cd,chr(13),''),chr(10),'')  -- 交易来源代码
    ,replace(replace(t1.tran_site_cd,chr(13),''),chr(10),'')  -- 交易场所代码
    ,replace(replace(t1.bag_id,chr(13),''),chr(10),'')  -- 成交编号
    ,replace(replace(t1.tran_id,chr(13),''),chr(10),'')  -- 交易编号
    ,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id                   --标准产品编号  
    ,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd         --资产三分类代码 
    ,replace(replace(t1.int_recvbl_subj_id,chr(13),''),chr(10),'') as int_recvbl_subj_id     --应收利息科目编号
    ,replace(replace(t1.int_income_subj_id,chr(13),''),chr(10),'') as int_income_subj_id     --利息收入科目编号
    ,replace(replace(t1.int_rat_adj_freq_cd,chr(13),''),chr(10),'') as int_rat_adj_freq_cd   --利率调整频率代码
    ,t1.base_rat as base_rat                                                                 --基准利率    
    ,replace(replace(t1.bond_id,chr(13),''),chr(10),'') as bond_id                           --债券编号    
    ,t1.bond_fac_val as bond_fac_val                                                         --债券面值    
    ,replace(replace(t1.bond_curr,chr(13),''),chr(10),'') as bond_curr                       --债券币种    
    ,t1.inpwn_ratio as inpwn_ratio                                                           --质押比例    
    ,replace(replace(t1.inpwn_way_cd,chr(13),''),chr(10),'') as inpwn_way_cd                 --质押方式代码  
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${icl_schema}.cmm_fx_ib_lend t1    --外汇同业拆借
where t1.etl_dt=to_date('${batch_date}','yyyymmdd')
and t1.tran_dt= to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_cmm_fx_ib_lend',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);