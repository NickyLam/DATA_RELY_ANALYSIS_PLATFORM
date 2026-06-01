/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_cmm_bill_discount_info
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
alter table ${idl_schema}.icrm_cmm_bill_discount_info drop partition p_${last_date};
alter table ${idl_schema}.icrm_cmm_bill_discount_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_cmm_bill_discount_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_cmm_bill_discount_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,bus_id  -- 业务编号
    ,batch_id  -- 批次编号
    ,bill_id  -- 票据编号
    ,subj_id  -- 科目编号
    ,int_adj_subj_id  -- 利息调整科目编号
    ,bill_prod_id  -- 票据产品编号
    ,bill_med_cd  -- 票据介质代码
    ,bill_kind_cd  -- 票据种类代码
    ,draw_dt  -- 出票日期
    ,exp_dt  -- 到期日期
    ,actl_exp_dt  -- 实际到期日期
    ,appl_dt  -- 申请日期
    ,bus_dt  -- 业务日期
    ,stl_dt  -- 结算日期
    ,repo_dt  -- 回购日期
    ,curr_cd  -- 币种代码
    ,fac_val_amt  -- 票面金额
    ,stl_amt  -- 结算金额
    ,repo_amt  -- 回购金额
    ,int_amt  -- 利息金额
    ,repo_int_amt  -- 回购利息金额
    ,discnt_int_rat  -- 贴现利率
    ,currt_bal  -- 当期余额
    ,int_adj_bal  -- 利息调整余额
    ,td_acru_int  -- 当日应计利息
    ,currt_acru_int  -- 当期应计利息
    ,bus_type_cd  -- 业务类型代码
    ,tran_dir_cd  -- 交易方向代码
    ,cntpty_id  -- 交易对手编号
    ,cntpty_name  -- 交易对手名称
    ,cntpty_bank_no  -- 交易对手行号
    ,cntpty_cate_cd  -- 交易对手类别代码
    ,cntpty_type_cd  -- 交易对手类型代码
    ,hxb_acpt_flg  -- 我行承兑标志
    ,bill_src_cd  -- 票据来源代码
    ,sys_in_flg  -- 系统内标志
    ,quot_way_cd  -- 报价方式代码
    ,stl_way_cd  -- 结算方式代码
    ,lock_flg  -- 锁定标志
    ,hold_days  -- 持票天数
    ,defer_days  -- 顺延天数
    ,valid_flg  -- 有效标志
    ,bus_status_cd  -- 业务状态代码
    ,entry_status_cd  -- 记账状态代码
    ,lmt_id  -- 额度编号
    ,lmt_status_cd  -- 额度状态代码
    ,cust_mgr_id  -- 客户经理编号
    ,dept_id  -- 部门编号
    ,bus_org_id  -- 业务机构编号
    ,acct_instit_id  -- 账务机构编号
    ,job_cd  -- 任务代码
    ,std_prod_id                          -- 标准产品编号      
    ,bill_num                             -- 票据号码        
    ,cont_id                              -- 合同编号        
    ,ctr_nt_id                            -- 成交单编号       
    ,exp_repo_agt_id                      -- 到期回购协议编号    
    ,bill_cont_id                         -- 票据合同编号      
    ,actl_repo_dt                         -- 实际回购日期      
    ,redem_int_rat                        -- 赎回利率        
    ,asset_thd_cls_cd                     -- 资产三分类代码     
    ,discnt_dt                            -- 贴现日期        
    ,discnt_ps_unify_soci_crdt_cd_cert    -- 贴现人统一社会信用代码证
    ,discnt_ps_name                       -- 贴现人名称       
    ,bf_cntpty_flg                        -- 前交易对手标志     
    ,bf_cntpty_name                       -- 前交易对手名称     
    ,bf_cntpty_type_cd                    -- 前交易对手类型代码   
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.bus_id,chr(13),''),chr(10),'')  -- 业务编号
    ,replace(replace(t1.batch_id,chr(13),''),chr(10),'')  -- 批次编号
    ,replace(replace(t1.bill_id,chr(13),''),chr(10),'')  -- 票据编号
    ,replace(replace(t1.subj_id,chr(13),''),chr(10),'')  -- 科目编号
    ,replace(replace(t1.int_adj_subj_id,chr(13),''),chr(10),'')  -- 利息调整科目编号
    ,replace(replace(t1.bill_prod_id,chr(13),''),chr(10),'')  -- 票据产品编号
    ,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'')  -- 票据介质代码
    ,replace(replace(t1.bill_kind_cd,chr(13),''),chr(10),'')  -- 票据种类代码
    ,t1.draw_dt  -- 出票日期
    ,t1.exp_dt  -- 到期日期
    ,t1.actl_exp_dt  -- 实际到期日期
    ,t1.appl_dt  -- 申请日期
    ,t1.bus_dt  -- 业务日期
    ,t1.stl_dt  -- 结算日期
    ,t1.repo_dt  -- 回购日期
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.fac_val_amt  -- 票面金额
    ,t1.stl_amt  -- 结算金额
    ,t1.repo_amt  -- 回购金额
    ,t1.int_amt  -- 利息金额
    ,t1.repo_int_amt  -- 回购利息金额
    ,t1.discnt_int_rat  -- 贴现利率
    ,t1.currt_bal  -- 当期余额
    ,t1.int_adj_bal  -- 利息调整余额
    ,t1.td_acru_int  -- 当日应计利息
    ,t1.currt_acru_int  -- 当期应计利息
    ,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'')  -- 业务类型代码
    ,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'')  -- 交易方向代码
    ,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'')  -- 交易对手编号
    ,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'')  -- 交易对手名称
    ,replace(replace(t1.cntpty_bank_no,chr(13),''),chr(10),'')  -- 交易对手行号
    ,replace(replace(t1.cntpty_cate_cd,chr(13),''),chr(10),'')  -- 交易对手类别代码
    ,replace(replace(t1.cntpty_type_cd,chr(13),''),chr(10),'')  -- 交易对手类型代码
    ,replace(replace(t1.hxb_acpt_flg,chr(13),''),chr(10),'')  -- 我行承兑标志
    ,replace(replace(t1.bill_src_cd,chr(13),''),chr(10),'')  -- 票据来源代码
    ,replace(replace(t1.sys_in_flg,chr(13),''),chr(10),'')  -- 系统内标志
    ,replace(replace(t1.quot_way_cd,chr(13),''),chr(10),'')  -- 报价方式代码
    ,replace(replace(t1.stl_way_cd,chr(13),''),chr(10),'')  -- 结算方式代码
    ,replace(replace(t1.lock_flg,chr(13),''),chr(10),'')  -- 锁定标志
    ,t1.hold_days  -- 持票天数
    ,t1.defer_days  -- 顺延天数
    ,replace(replace(t1.valid_flg,chr(13),''),chr(10),'')  -- 有效标志
    ,replace(replace(t1.bus_status_cd,chr(13),''),chr(10),'')  -- 业务状态代码
    ,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'')  -- 记账状态代码
    ,replace(replace(t1.lmt_id,chr(13),''),chr(10),'')  -- 额度编号
    ,replace(replace(t1.lmt_status_cd,chr(13),''),chr(10),'')  -- 额度状态代码
    ,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'')  -- 客户经理编号
    ,replace(replace(t1.dept_id,chr(13),''),chr(10),'')  -- 部门编号
    ,replace(replace(t1.bus_org_id,chr(13),''),chr(10),'')  -- 业务机构编号
    ,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'')  -- 账务机构编号
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id                                                 -- 标准产品编号      
    ,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num                                                       -- 票据号码        
    ,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id                                                         -- 合同编号        
    ,replace(replace(t1.ctr_nt_id,chr(13),''),chr(10),'') as ctr_nt_id                                                     -- 成交单编号       
    ,replace(replace(t1.exp_repo_agt_id,chr(13),''),chr(10),'') as exp_repo_agt_id                                         -- 到期回购协议编号    
    ,replace(replace(t1.bill_cont_id,chr(13),''),chr(10),'') as bill_cont_id                                               -- 票据合同编号      
    ,t1.actl_repo_dt as actl_repo_dt                                                                                      -- 实际回购日期      
    ,t1.redem_int_rat as redem_int_rat                                                                                    -- 赎回利率        
    ,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd                                       -- 资产三分类代码     
    ,t1.discnt_dt as discnt_dt                                                                                            -- 贴现日期        
    ,replace(replace(t1.discnt_ps_unify_soci_crdt_cd_cert,chr(13),''),chr(10),'') as discnt_ps_unify_soci_crdt_cd_cert     -- 贴现人统一社会信用代码证
    ,replace(replace(t1.discnt_ps_name,chr(13),''),chr(10),'') as discnt_ps_name                                           -- 贴现人名称       
    ,replace(replace(t1.bf_cntpty_flg,chr(13),''),chr(10),'') as bf_cntpty_flg                                             -- 前交易对手标志     
    ,replace(replace(t1.bf_cntpty_name,chr(13),''),chr(10),'') as bf_cntpty_name                                           -- 前交易对手名称     
    ,replace(replace(t1.bf_cntpty_type_cd,chr(13),''),chr(10),'') as bf_cntpty_type_cd                                     -- 前交易对手类型代码   
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${icl_schema}.cmm_bill_discount_info t1    --票据转贴现信息
where t1.etl_dt= to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_cmm_bill_discount_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);