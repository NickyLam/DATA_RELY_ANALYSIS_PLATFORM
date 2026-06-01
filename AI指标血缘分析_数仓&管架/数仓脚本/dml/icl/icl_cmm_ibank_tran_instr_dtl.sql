/*
Purpose: 共性加工层-同业交易指令明细
Author: Sunline
Usage: python $ETL_HOME/script/main.py 20200630 icl_cmm_ibank_tran_instr_dtl
Createdate: 20200717
Logs:  20200911  陈伟峰 增加主键字段【obj_id】、【instr_bus_type_cd】,修改加工口径
          20250429  陈伟峰 调整【ibms_ttrd_set_instruction_his】算法为全量流水

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_ibank_tran_instr_dtl drop partition p_${retain_day};
alter table ${icl_schema}.cmm_ibank_tran_instr_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));


whenever sqlerror continue none;
drop table ${icl_schema}.cmm_ibank_tran_instr_dtl_ex purge;

-- 2.1 insert into ex table
create table ${icl_schema}.cmm_ibank_tran_instr_dtl_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_ibank_tran_instr_dtl where 0=1;



--第一组（共二组）历史指令明细
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_ibank_tran_instr_dtl_ex(
    etl_dt                                  -- 数据日期
    ,lp_id                                  -- 法人编号
    ,instr_seq_num                          -- 指令序号
    ,parent_instr_seq_num                   -- 父指令序号
    ,ext_instr_seq_num                      -- 外部指令序号
    ,rela_cap_instr_seq_num                 -- 关联资金指令序号
    ,rela_vch_instr_seq_num                 -- 关联券指令序号
    ,rela_main_instr_seq_num                -- 关联主指令序号
    ,actl_accti_main_seq_num                -- 实际核算主指令序号
    ,adj_entry_main_seq_num                 -- 调账主指令序号
    ,intnal_tran_flow_num                   -- 内部交易流水号
    ,obj_id                                 -- 对象编号
	,instr_bus_type_cd                      -- 指令业务类型代码
    ,ext_secu_acct_id                       -- 外部证券账户编号
    ,intnal_secu_acct_id                    -- 内部证券账户编号
    ,intnal_cap_acct_id                     -- 内部资金账户编号
    ,parent_instm_market_type_id            -- 父金融工具市场类型编号
    ,parent_instm_asset_type_id             -- 父金融工具资产类型编号
    ,parent_fin_instm_id                    -- 父金融工具编号
    ,instr_type_cd                          -- 指令类型代码
    ,instr_status_cd                        -- 指令状态代码
	,acpt_pay_instr_cd                      -- 收付款指令代码
    ,tran_bus_type_cd                       -- 交易业务类型代码
    ,stl_way_cd                             -- 结算方式代码
    ,stl_type_cd                            -- 结算类型代码
    ,apv_status_cd                          -- 审批状态代码
    ,actl_rp_flg                            -- 实收付标志
    ,clear_flow_flg                         -- 清算流水标志
    ,surviv_term_flg                        -- 存续期标志
    ,cntpty_id                              -- 交易对手编号
    ,cntpty_name                            -- 交易对手名称
    ,exec_market_id                         -- 执行市场编号
    ,memo_info                              -- 摘要信息
    ,theory_clear_dt                        -- 理论清算日期
    ,theory_stl_dt                          -- 理论结算日期
    ,actl_stl_dt                            -- 实际结算日期
    ,tran_dt                                -- 交易日期
    ,cfm_dt                                 -- 确认日期
    ,repay_dt                               -- 还款日期
    ,final_mender_id                        -- 最后修改人编号
    ,final_mender_name                      -- 最后修改人名称
    ,checker_id                             -- 复核人编号
    ,operr_id                               -- 经办人编号
    ,operr_name                             -- 经办人名称
    ,curr_cd                                -- 币种代码
    ,acru_int                               -- 应计利息
    ,pric_bal                               -- 本金余额
    ,recvbl_uncol_int                       -- 应收未收利息
    ,recvbl_uncol_pric                      -- 应收未收本金
    ,chg_qtty                               -- 变动数量
    ,job_cd                                 -- 任务代码
    ,etl_timestamp                          -- 数据处理时间
)
select
     to_date('${batch_date}', 'yyyymmdd')                                                              -- 数据日期
    ,'9999'                                                                                            -- 法人编号
    ,t1.inst_id                                                                                        -- 指令序号
    ,t1.inst_grp_id                                                                                    -- 父指令序号
    ,t1.ext_ord_id                                                                                     -- 外部指令序号
    ,t1.ref_cash_inst_id                                                                               -- 关联资金指令序号
    ,t1.ref_secu_inst_id                                                                               -- 关联券指令序号
    ,t1.ref_inst_id                                                                                    -- 关联主指令序号
    ,t1.real_account_inst_id                                                                           -- 实际核算主指令序号
    ,t1.his_inst_id                                                                                    -- 调账主指令序号
    ,t1.trade_id                                                                                       -- 内部交易流水号
    ,t4.obj_id                                                                                         -- 对象编号
	,t2.biz_type                                                                                       -- 指令业务类型代码
    ,t2.secu_acct_id                                                                                   -- 外部证券账户编号
    ,t2.ext_secu_acct_id                                                                               -- 内部证券账户编号
    ,t1.cash_acct_id                                                                                   -- 内部资金账户编号
    ,t1.h_m_type                                                                                       -- 父金融工具市场类型
    ,t1.h_a_type                                                                                       -- 父金融工具资产类型
    ,t1.h_i_code                                                                                       -- 父金融工具编号
    ,t1.inst_type                                                                                      -- 指令类型代码
    ,t1.state                                                                                          -- 指令状态代码
	,t3.direction                                                                                      -- 收付款指令代码
    ,t1.trd_type                                                                                       -- 交易业务类型代码
    ,t1.set_type                                                                                       -- 结算方式代码
    ,t1.settlemode                                                                                     -- 结算类型代码
    ,t1.approvestatus                                                                                  -- 审批状态代码
    ,t1.is_real_acctg                                                                                  -- 实收付标志
    ,t1.is_match                                                                                       -- 清算流水标志
    ,t1.is_period_inst                                                                                 -- 存续期标志
    ,t1.party_id                                                                                       -- 交易对手编号
    ,t1.party_name                                                                                     -- 交易对手名称
    ,t1.exe_market                                                                                     -- 执行市场编号
    ,t1.memo                                                                                           -- 摘要信息
    ,to_date(trim(t1.theory_set_date), 'yyyy-mm-dd')                                                   -- 理论清算日期
    ,to_date(trim(t1.cal_date), 'yyyy-mm-dd')                                                          -- 理论结算日期
    ,to_date(trim(t1.real_set_date), 'yyyy-mm-dd')                                                     -- 实际结算日期
    ,to_date(trim(t1.orddate), 'yyyy-mm-dd')                                                           -- 交易日期
    ,case when trim(t1.condate) is not null then to_date(trim(t1.condate), 'yyyy-mm-dd')
	      else null end                                                                                -- 确认日期
    ,case when (t1.state = 999 
	        or to_date(trim(t1.real_set_date), 'yyyy-mm-dd') > to_date('${batch_date}', 'yyyymmdd')) 
          then to_date(trim(t1.real_set_date), 'yyyy-mm-dd')                                                 
          else to_date('${batch_date}', 'yyyymmdd') end                                                -- 还款日期
    ,t1.update_user_id                                                                                 -- 最后修改人编号
    ,t1.update_user                                                                                    -- 最后修改人名称
    ,t1.account_user                                                                                   -- 复核人编号
    ,t1.operator_id                                                                                    -- 经办人编号
    ,t1.operator_name                                                                                  -- 经办人名称
    ,t2.currency                                                                                       -- 币种代码
    ,t2.real_ai                                                                                        -- 应计利息
    ,t2.real_cp                                                                                        -- 本金余额
    ,t2.due_ai                                                                                         -- 应收未收利息
    ,t2.due_cp                                                                                         -- 应收未收本金
    ,t3.amount                                                                                         -- 变动数量
    ,'ibmsf12'                                                                                          -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳                  -- 数据处理时间
 from ${iol_schema}.ibms_ttrd_set_instruction_his t1 --主指令表
inner join ${iol_schema}.ibms_ttrd_set_instruction_secu_his t2 --券指令表
   on t1.inst_id = t2.acctg_inst_id
  and t1.h_i_code = t2.i_code
  and t1.h_a_type = t2.a_type
  and t1.h_m_type = t2.m_type
--  and t1.ref_secu_inst_id = t2.secu_inst_id  
  and t2.etl_dt <= to_date('${batch_date}', 'yyyymmdd')	
inner join  ${iol_schema}.ibms_ttrd_accounting_secu_obj_his t4
  on t4.i_code=t1.h_i_code 
  and t4.a_type=t1.h_a_type 
  and t4.m_type=t1.h_m_type
  and replace(t4.beg_date,'-','')='${batch_date}' 
left join (select acctg_inst_id,direction,currency,ABS(sum(amount)) as amount
             from ${iol_schema}.ibms_ttrd_set_instruction_cash_his   --资金指令表
            where etl_dt <= to_date('${batch_date}', 'yyyymmdd')	
		    group by acctg_inst_id,direction,currency ) t3 
  on t1.inst_id = t3.acctg_inst_id
left join ${iol_schema}.ibms_ttrd_cashlb T5 
  on t1.h_i_code=T5.i_code 
 and t1.h_a_type=T5.a_type 
 and t1.h_m_type=T5.m_type 
 and T5.start_dt<= to_date('${batch_date}', 'yyyymmdd')
 and T5.end_dt> to_date('${batch_date}', 'yyyymmdd')
where t1.inst_grp_id > 0 
 and t3.amount<>0 
 and t1.state not in(99999,-999,-888) 
 and T5.p_type='0170'  
 and t4.real_amount+t4.due_amount+t4.ai+t4.due_ai<>0 
 and t3.direction='IN'
--  and t1.ref_cash_inst_id = t3.cash_inst_id
 --left join ${iml_schema}.agt_secu_acct_accti_bal_h t4    --证券账户核算余额历史
 --  on t1.h_i_code = t4.fin_instm_id
--  and t1.h_a_type = t4.asset_type_id
--  and t1.h_m_type = t4.market_type_id	
--  and t1.trade_id = t4.tran_num
 -- and t4.ext_vch_acct_id = t2.ext_secu_acct_id
 -- and t4.intnal_vch_acct_id = t2.secu_acct_id
 -- and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 -- and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')   
 -- and t4.job_cd ='ibmsf1'	
and to_date(t1.real_set_date,'yyyy-mm-dd') <= to_date('${batch_date}', 'yyyymmdd')	
;

commit;

--第二组（共二组）当前指令明细
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_ibank_tran_instr_dtl_ex(
    etl_dt                                  -- 数据日期
    ,lp_id                                  -- 法人编号
    ,instr_seq_num                          -- 指令序号
    ,parent_instr_seq_num                   -- 父指令序号
    ,ext_instr_seq_num                      -- 外部指令序号
    ,rela_cap_instr_seq_num                 -- 关联资金指令序号
    ,rela_vch_instr_seq_num                 -- 关联券指令序号
    ,rela_main_instr_seq_num                -- 关联主指令序号
    ,actl_accti_main_seq_num                -- 实际核算主指令序号
    ,adj_entry_main_seq_num                 -- 调账主指令序号
    ,intnal_tran_flow_num                   -- 内部交易流水号
    ,obj_id                                 -- 对象编号
	,instr_bus_type_cd                      -- 指令业务类型代码
    ,ext_secu_acct_id                       -- 外部证券账户编号
    ,intnal_secu_acct_id                    -- 内部证券账户编号
    ,intnal_cap_acct_id                     -- 内部资金账户编号
    ,parent_instm_market_type_id            -- 父金融工具市场类型编号
    ,parent_instm_asset_type_id             -- 父金融工具资产类型编号
    ,parent_fin_instm_id                    -- 父金融工具编号
    ,instr_type_cd                          -- 指令类型代码
    ,instr_status_cd                        -- 指令状态代码
	,acpt_pay_instr_cd                      -- 收付款指令代码
    ,tran_bus_type_cd                       -- 交易业务类型代码
    ,stl_way_cd                             -- 结算方式代码
    ,stl_type_cd                            -- 结算类型代码
    ,apv_status_cd                          -- 审批状态代码
    ,actl_rp_flg                            -- 实收付标志
    ,clear_flow_flg                         -- 清算流水标志
    ,surviv_term_flg                        -- 存续期标志
    ,cntpty_id                              -- 交易对手编号
    ,cntpty_name                            -- 交易对手名称
    ,exec_market_id                         -- 执行市场编号
    ,memo_info                              -- 摘要信息
    ,theory_clear_dt                        -- 理论清算日期
    ,theory_stl_dt                          -- 理论结算日期
    ,actl_stl_dt                            -- 实际结算日期
    ,tran_dt                                -- 交易日期
    ,cfm_dt                                 -- 确认日期
    ,repay_dt                               -- 还款日期
    ,final_mender_id                        -- 最后修改人编号
    ,final_mender_name                      -- 最后修改人名称
    ,checker_id                             -- 复核人编号
    ,operr_id                               -- 经办人编号
    ,operr_name                             -- 经办人名称
    ,curr_cd                                -- 币种代码
    ,acru_int                               -- 应计利息
    ,pric_bal                               -- 本金余额
    ,recvbl_uncol_int                       -- 应收未收利息
    ,recvbl_uncol_pric                      -- 应收未收本金
    ,chg_qtty                               -- 变动数量
    ,job_cd                                 -- 任务代码
    ,etl_timestamp                          -- 数据处理时间
)
select
     to_date('${batch_date}', 'yyyymmdd')                                                              -- 数据日期
    ,'9999'                                                                                            -- 法人编号
    ,t1.inst_id                                                                                        -- 指令序号
    ,t1.inst_grp_id                                                                                    -- 父指令序号
    ,t1.ext_ord_id                                                                                     -- 外部指令序号
    ,t1.ref_cash_inst_id                                                                               -- 关联资金指令序号
    ,t1.ref_secu_inst_id                                                                               -- 关联券指令序号
    ,t1.ref_inst_id                                                                                    -- 关联主指令序号
    ,t1.real_account_inst_id                                                                           -- 实际核算主指令序号
    ,t1.his_inst_id                                                                                    -- 调账主指令序号
    ,t1.trade_id                                                                                       -- 内部交易流水号
    ,t4.obj_id                                                                                         -- 对象编号
	,t2.biz_type                                                                                       -- 指令业务类型代码
    ,t2.secu_acct_id                                                                                   -- 外部证券账户编号
    ,t2.ext_secu_acct_id                                                                               -- 内部证券账户编号
    ,t1.cash_acct_id                                                                                   -- 内部资金账户编号
    ,t1.h_m_type                                                                                       -- 父金融工具市场类型
    ,t1.h_a_type                                                                                       -- 父金融工具资产类型
    ,t1.h_i_code                                                                                       -- 父金融工具编号
    ,t1.inst_type                                                                                      -- 指令类型代码
    ,t1.state                                                                                          -- 指令状态代码
    ,t3.direction                                                                                      -- 收付款指令代码
    ,t1.trd_type                                                                                       -- 交易业务类型代码
    ,t1.set_type                                                                                       -- 结算方式代码
    ,t1.settlemode                                                                                     -- 结算类型代码
    ,t1.approvestatus                                                                                  -- 审批状态代码
    ,t1.is_real_acctg                                                                                  -- 实收付标志
    ,t1.is_match                                                                                       -- 清算流水标志
    ,t1.is_period_inst                                                                                 -- 存续期标志
    ,t1.party_id                                                                                       -- 交易对手编号
    ,t1.party_name                                                                                     -- 交易对手名称
    ,t1.exe_market                                                                                     -- 执行市场编号
    ,t1.memo                                                                                           -- 摘要信息
    ,to_date(trim(t1.theory_set_date), 'yyyy-mm-dd')                                                   -- 理论清算日期
    ,to_date(trim(t1.cal_date), 'yyyy-mm-dd')                                                          -- 理论结算日期
    ,to_date(trim(t1.real_set_date), 'yyyy-mm-dd')                                                     -- 实际结算日期
    ,to_date(trim(t1.orddate), 'yyyy-mm-dd')                                                           -- 交易日期
    ,case when trim(t1.condate) is not null then to_date(trim(t1.condate), 'yyyy-mm-dd')
	      else null end                                                                                -- 确认日期
    ,case when (t1.state = 999 
	        or to_date(trim(t1.real_set_date), 'yyyy-mm-dd') > to_date('${batch_date}', 'yyyymmdd')) 
          then to_date(trim(t1.real_set_date), 'yyyy-mm-dd')                                                 
          else to_date('${batch_date}', 'yyyymmdd') end                                                -- 还款日期
    ,t1.update_user_id                                                                                 -- 最后修改人编号
    ,t1.update_user                                                                                    -- 最后修改人名称
    ,t1.account_user                                                                                   -- 复核人编号
    ,t1.operator_id                                                                                    -- 经办人编号
    ,t1.operator_name                                                                                  -- 经办人名称
    ,t2.currency                                                                                       -- 币种代码
    ,t2.real_ai                                                                                        -- 应计利息
    ,t2.real_cp                                                                                        -- 本金余额
    ,t2.due_ai                                                                                         -- 应收未收利息
    ,t2.due_cp                                                                                         -- 应收未收本金
    ,t3.amount                                                                                         -- 变动数量
    ,'ibmsf11'                                                                                          -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳                  -- 数据处理时间
 from ${iol_schema}.ibms_ttrd_set_instruction t1 --主指令表
inner join ${iol_schema}.ibms_ttrd_set_instruction_secu t2 --券指令表
   on t1.inst_id = t2.acctg_inst_id
  and t1.h_i_code = t2.i_code
  and t1.h_a_type = t2.a_type
  and t1.h_m_type = t2.m_type
--  and t1.ref_secu_inst_id = t2.secu_inst_id
  and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')	
 inner join  ${iol_schema}.ibms_ttrd_accounting_secu_obj t4  
  on t4.i_code=t1.h_i_code 
  and t4.a_type=t1.h_a_type 
  and t4.m_type=t1.h_m_type
  and replace(t4.beg_date,'-','')='${batch_date}'
left join (select acctg_inst_id,direction,currency,ABS(sum(amount)) as amount
             from ${iol_schema}.ibms_ttrd_set_instruction_cash   --资金指令表
            where start_dt <= to_date('${batch_date}', 'yyyymmdd')
              and end_dt > to_date('${batch_date}', 'yyyymmdd')
		    group by acctg_inst_id,direction,currency ) t3 
  on t1.inst_id = t3.acctg_inst_id
left join ${iol_schema}.ibms_ttrd_cashlb T5 
  on t1.h_i_code=T5.i_code 
 and t1.h_a_type=T5.a_type 
 and t1.h_m_type=T5.m_type  
 and T5.start_dt<= to_date('${batch_date}', 'yyyymmdd')
 and T5.end_dt> to_date('${batch_date}', 'yyyymmdd')
left join ${icl_schema}.cmm_ibank_tran_instr_dtl_ex t6
  on t6.instr_seq_num=t1.inst_id
 and t6.obj_id=t4.obj_id
 and t6.instr_bus_type_cd=t2.biz_type
 and t6.etl_dt=to_date('${batch_date}', 'yyyymmdd')	
where t1.inst_grp_id > 0 
 and t3.amount<>0 
 and t1.state not in(99999,-999,-888) 
 and T5.p_type='0170'  
 and t4.real_amount+t4.due_amount+t4.ai+t4.due_ai<>0 
 and t3.direction='IN'
-- left join ${iml_schema}.agt_secu_acct_accti_bal_h t4    --证券账户核算余额历史   
--   on t1.h_i_code = t4.fin_instm_id
--  and t1.h_a_type = t4.asset_type_id
 -- and t1.h_m_type = t4.market_type_id
--  and t1.trade_id = t4.tran_num
 -- and t4.ext_vch_acct_id = t2.ext_secu_acct_id
 -- and t4.intnal_vch_acct_id = t2.secu_acct_id
--  and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
--  and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
--  and t4.job_cd ='ibmsf1'
 and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and (trim(t6.instr_seq_num) is null 
       and trim(t6.obj_id) is null 
       and trim(t6.instr_bus_type_cd) is null)
;
commit;


-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_ibank_tran_instr_dtl exchange partition p_${batch_date} with table ${icl_schema}.cmm_ibank_tran_instr_dtl_ex
;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_ibank_tran_instr_dtl_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_ibank_tran_instr_dtl',partname => 'p_${batch_date}',granularity => 'PARTITION', degree => 8, cascade => true);
