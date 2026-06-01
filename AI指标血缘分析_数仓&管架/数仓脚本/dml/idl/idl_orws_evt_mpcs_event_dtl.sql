/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_orws_evt_mpcs_event_dtl
CreateDate: 20221228
FileType:   DML
Logs:
    Sundexin
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.orws_evt_mpcs_event_dtl drop partition p_${last_date};
alter table ${idl_schema}.orws_evt_mpcs_event_dtl drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.orws_evt_mpcs_event_dtl add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
--第一组 idl_hdws_iml_evt_mpcs_event_dtl_01 迁移逻辑
insert /*+ append(1) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id                       -- 事件编号       
   ,global_chn_seq_num           -- 全局渠道流水号    
   ,prev_global_chn_seq_num      -- 上一全局渠道流水号  
   ,prev_evt_id                  -- 上一事件编号     
   ,evt_typ_cd                   -- 事件类型代码     
   ,menuid                       -- 柜面菜单码      
   ,txn_num                      -- 交易码        
   ,txn_desc                     -- 交易描述       
   ,txn_dt                       -- 交易日期       
   ,txn_tm                       -- 交易时间       
   ,txn_ccy_cd                   -- 交易币种代码     
   ,txn_amt                      -- 交易金额       
   ,acct_bal                     -- 账户余额       
   ,cost_typ_cd                  -- 费用类型代码     
   ,fee_amt                      -- 手续费金额      
   ,evt_status_cd                -- 事件状态代码     
   ,evt_reverse_typ_cd           -- 事件冲正类型代码   
   ,agt_id                       -- 协议编号       
   ,agt_id_name                  -- 协议全称       
   ,agt_blng_acct_num            -- 协议所属账号     
   ,prd_id                       -- 产品编号       
   ,pty_id                       -- 客户编号       
   ,txn_org_id                   -- 交易机构编号     
   ,txn_teller_id                -- 交易柜员编号     
   ,chk_teller_id                -- 复核柜员编号     
   ,auth_teller_id               -- 授权柜员编号     
   ,pty_mgr_id                   -- 客户经理编号     
   ,chn_typ_cd                   -- 渠道类型代码     
   ,chn_id                       -- 渠道编号       
   ,pay_chnl_typ_cd              -- 支付通道类型代码   
   ,cntrpty_id                   -- 交易对手编号     
   ,cntrpty_name                 -- 交易对手名称     
   ,cntrpty_acct_openbk_num      -- 交易对手账户开户行号 
   ,cntrpty_acct_openbk_name     -- 交易对手账户开户行名称
   ,cntrpty_acct_num_id          -- 交易对手账号ID   
   ,cntrpty_acct_num             -- 交易对手账号     
   ,cntrpty_org_id               -- 交易对手机构编号   
   ,cntrpty_org_name             -- 交易对手机构名称   
   ,posting_dt                   -- 入账日期       
   ,posting_tm                   -- 入账时间       
   ,posting_org_id               -- 入账机构编号     
   ,posting_teller_id            -- 入账柜员编号     
   ,posting_ccy_cd               -- 入账币种代码     
   ,posting_amt                  -- 入账金额       
   ,memo_cd                      -- 摘要码        
   ,memo                         -- 摘要         
   ,db_cr_dir_cd                 -- 借贷标志       
   ,city_flg                     -- 同城标志       
   ,crossb_flg                   -- 跨行标志       
   ,ovsea_flg                    -- 境外标志       
   ,cash_tfr_flg                 -- 现转标志       
   ,initor_typ_cd                -- 发起方类型代码    
   ,prim_vchr_type_cd            -- 主凭证种类代码    
   ,prim_vchr_num                -- 主凭证号码      
   ,scd_vchr_type_cd             -- 副凭证种类代码    
   ,scd_vchr_num                 -- 副凭证号码      
   ,assoc_bcs_evt_id             -- 关联核心系统事件编号 
   ,reverse_evt_id               -- 冲正事件编号     
   ,flow_id                      -- 流程编号       
   ,assoc_coll_id                -- 关联抵质押品编号   
   ,nostro_flg                   -- 往账标志       
   ,bal_dir_cd                   -- 余额方向代码     
   ,bal_typ_cd                   -- 余额类型代码     
   ,txn_med_name                 -- 交易介质名称     
   ,txn_med_id                   -- 交易介质编号     
   ,biz_typ_cd                   -- 业务类型代码     
   ,biz_cate_cd                  -- 业务种类代码     
   ,ghb_init_flg                 -- 本行发起标志     
   ,old_vchr_num                 -- 旧凭证号码      
   ,agt_blng_acct_num2           -- 协议所属账号2    
   ,agt_blng_acct_num3           -- 协议所属账号3    
   ,data_src_cd                  -- 数据来源代码     
   ,etl_dt                       -- 数据日期       
   ,job_cd                       -- 任务代码       
   ,etl_timestamp                -- 任务处理时间     
)
select T1.SER_NUM                                       --业务系统事件编号
      ,T1.CORE_TRAN_FLOW                                --全局渠道流水号
      ,''                                               --上一全局渠道流水号
      ,''                                               --上一事件编号
      ,CASE WHEN T1.EVT_TRAN_CODE = 'G155' THEN 'C014'
     WHEN T1.EVT_TRAN_CODE = 'G185' THEN 'C011'
     WHEN T1.EVT_TRAN_CODE = 'L837' THEN 'C027'
     WHEN T1.EVT_TRAN_CODE = 'L846' THEN 'C018'
     WHEN T1.EVT_TRAN_CODE = 'L842' THEN 'C025'
     WHEN T1.EVT_TRAN_CODE = 'L844' THEN 'C025'
     WHEN T1.EVT_TRAN_CODE = 'L848' THEN 'C018'
     WHEN T1.EVT_TRAN_CODE = 'L840' THEN 'C025'
     WHEN T1.EVT_TRAN_CODE = 'G187' THEN 'C012'
     WHEN T1.EVT_TRAN_CODE = 'G188' THEN 'C007'
     ELSE 'L060'
  END                                                   --事件类型代码
      ,''                                               --柜面菜单码
      ,T1.EVT_TRAN_CODE                                 --交易码
      ,T1.TRAN_DESCB                                    --交易描述
    ,CASE WHEN T1.BATCH_DT=to_date('00010101','yyyymmdd') THEN  to_date('${batch_date}','yyyymmdd') ELSE T1.BATCH_DT END    --交易日期  0001转为跑批日期
      ,''                                               --交易时间                                                    
      ,'CNY'                                            --交易币种代码                                                
      ,T1.ENTER_ACCT_AMT                                --交易金额                                                    
      ,0                                                --账户余额                                                    
      ,'1'                                              --费用类型代码                                                
      ,0                                                --费用金额                                                    
      ,'1'                                              --事件状态代码                                                
      ,'1'                                              --事件冲正类型代码                                            
      ,T2.DUBIL_ID                                      --协议编号                                                    
      ,SUBSTR(T2.CONT_EDIT_NUM, 1, 200)                 --协议全称                                                    
      ,T2.DUBIL_ID                                      --协议所属账号                                                
      ,'0900600100001'                                  --产品编号                                                    
      ,T3.CUST_ID                                       --客户编号                                                    
      ,'897001'                                         --交易机构编号                                                
      ,'01770'                                          --交易柜员编号modify''->'01770'                               
      ,'01770'                                          --复核柜员编号modify''->'01770'                               
      ,'01770'                                          --授权柜员编号modify''->'01770'                               
      ,''                                               --客户经理编号                                                
      ,'1008'                                           --渠道类型代码                                                
      ,''                                               --渠道编号                                                    
      ,'05'                                             --支付通道类型代码                                            
      ,''                                               --交易对手客户编号                                            
      --,''                                             --交易对手名称--------------------------------------          
      ,t3.APOT_REPAY_DEDUCT_ACCT_NAME                   --交易对手名称--modify''->t3.APOT_REPAY_DEDUCT_ACCT_NAME      
      --,''                                             --交易对手账户开户行号--------------------------------------  
      ,t3.APOT_REPAY_OPEN_BANK_NUM                      --交易对手账户开户行号--modify''->t3.APOT_REPAY_OPEN_BANK_NUM 
      --,''                                             --交易对手账户开户行名称--------------------------------------
      ,t3.APOT_REPAY_BANK_NAME                          --交易对手账户开户行名称--modify''->t3.APOT_REPAY_BANK_NAME   
      ,''                                               --交易对手账号ID                                              
      --,''                                             --交易对手账号--------------------------------------          
      ,t3.APOT_REPAY_DEDUCT_ACCT_NUM                    --交易对手账号--modify''->t3.APOT_REPAY_DEDUCT_ACCT_NUM       
      ,''                                               --交易对手机构编号                                            
      ,''                                               --交易对手机构名称                                            
      ,T1.BATCH_DT                                      --入账日期                                                    
      ,''                                               --入账时间                                                    
      ,'897001'                                         --入账机构编号                                                
      ,''                                               --入账柜员编号                                                
      ,'CNY'                                            --入账币种代码                                                
      ,T1.ENTER_ACCT_AMT                                --入账金额                                                    
      ,T1.EVT_TRAN_CODE                                 --摘要码                                                      
      ,T1.TRAN_DESCB                                    --摘要                                                        
      ,CASE WHEN T1.DEBIT_CRDT_FLG = '1' THEN 'C' 
     WHEN T1.DEBIT_CRDT_FLG = '0' THEN 'D'
     ELSE 'D'
END                                                     --借贷标志            
      ,'0'                                              --同城标志            
      ,'0'                                              --跨行标志            
      ,'0'                                              --境外标志            
      ,'0'                                              --现转标志            
      ,''                                               --发起方类型代码      
      ,'999'                                            --主凭证种类代码      
      ,''                                               --主凭证号码          
      ,'999'                                            --副凭证种类代码      
      ,''                                               --副凭证号码          
      ,''                                               --关联核心系统事件编号
      ,''                                               --冲正事件编号        
      ,''                                               --流程编号            
      ,''                                               --关联抵质押品编号    
      ,'0'                                              --往账标志            
      ,CASE WHEN T1.DEBIT_CRDT_FLG = '1' THEN 'C' 
     WHEN T1.DEBIT_CRDT_FLG = '0' THEN 'D'
     ELSE 'D'
END                                                     --余额方向代码
      ,''                                               --余额类型代码
      ,''                                               --交易介质名称
      ,''                                               --交易介质编号
      ,''                                               --业务类型代码
      ,''                                               --业务种类代码
      ,''                                               --本行发起标志
      ,''                                               --旧凭证号码
      ,T1.CARD_NO                                       --协议所属账号2
      ,''                                               --协议所属账号3
      ,'MPCS'                                           --数据来源代码
  --    ,'EVT_MPCS_EVENT_DTL_01'                        --ETL任务名称
      ,to_date('${batch_date}','yyyymmdd')              --数据日期
  --    ,''                                             --            
  --    ,'0'                                            --            
  --    ,''                                             --            
  --    ,''                                             --            
  --    ,T1.SUBJ_ID                                     --外部科目编号
  --    ,T1.RB_W_FLG                                    --红蓝字标志  
  --    ,T1.BANK_ID                                     --银行编号    
  --    ,T1.SYN_ID                                      --银团编号    
  --    ,T2.BANK_CONTRI_RATIO                           --我行出资比例
      ,'01'                                             --任务代码    
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')     --任务处理时间
     from ${iml_schema}.evt_wld_acct_ety_tran t1                           --微粒贷会计分录交易事件
left join ${iml_schema}.agt_wld_dubil_info t2                              --微粒贷借据信息
       on t1.tran_ref_no = t2.tran_ref_no
and t1.card_no = t2.card_no
and T2.create_dt <=to_date('${batch_date}', 'yyyymmdd')
and T2.job_cd = 'mpcsf1'
and T2.id_mark <> 'D'
left join ${iml_schema}.agt_wld_acct t3                                    --微粒贷账户
       on t2.acct_id = t3.acct_id
and t2.acct_type_cd = t3.acct_type_cd
and T3.create_dt <=to_date('${batch_date}', 'yyyymmdd')
and T3.job_cd = 'mpcsf1'
and T3.id_mark <> 'D'
    where t1.batch_doc_name = 'G1' || '${batch_date}' || '.tar.gz';

commit;


whenever sqlerror exit sql.sqlcode;
--第二组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --省金服支付业务
insert /*+ append(2) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id                       -- 事件编号       
   ,global_chn_seq_num           -- 全局渠道流水号    
   ,prev_global_chn_seq_num      -- 上一全局渠道流水号  
   ,prev_evt_id                  -- 上一事件编号     
   ,evt_typ_cd                   -- 事件类型代码     
   ,menuid                       -- 柜面菜单码      
   ,txn_num                      -- 交易码        
   ,txn_desc                     -- 交易描述       
   ,txn_dt                       -- 交易日期       
   ,txn_tm                       -- 交易时间       
   ,txn_ccy_cd                   -- 交易币种代码     
   ,txn_amt                      -- 交易金额       
   ,acct_bal                     -- 账户余额       
   ,cost_typ_cd                  -- 费用类型代码     
   ,fee_amt                      -- 手续费金额      
   ,evt_status_cd                -- 事件状态代码     
   ,evt_reverse_typ_cd           -- 事件冲正类型代码   
   ,agt_id                       -- 协议编号       
   ,agt_id_name                  -- 协议全称       
   ,agt_blng_acct_num            -- 协议所属账号     
   ,prd_id                       -- 产品编号       
   ,pty_id                       -- 客户编号       
   ,txn_org_id                   -- 交易机构编号     
   ,txn_teller_id                -- 交易柜员编号     
   ,chk_teller_id                -- 复核柜员编号     
   ,auth_teller_id               -- 授权柜员编号     
   ,pty_mgr_id                   -- 客户经理编号     
   ,chn_typ_cd                   -- 渠道类型代码     
   ,chn_id                       -- 渠道编号       
   ,pay_chnl_typ_cd              -- 支付通道类型代码   
   ,cntrpty_id                   -- 交易对手编号     
   ,cntrpty_name                 -- 交易对手名称     
   ,cntrpty_acct_openbk_num      -- 交易对手账户开户行号 
   ,cntrpty_acct_openbk_name     -- 交易对手账户开户行名称
   ,cntrpty_acct_num_id          -- 交易对手账号ID   
   ,cntrpty_acct_num             -- 交易对手账号     
   ,cntrpty_org_id               -- 交易对手机构编号   
   ,cntrpty_org_name             -- 交易对手机构名称   
   ,posting_dt                   -- 入账日期       
   ,posting_tm                   -- 入账时间       
   ,posting_org_id               -- 入账机构编号     
   ,posting_teller_id            -- 入账柜员编号     
   ,posting_ccy_cd               -- 入账币种代码     
   ,posting_amt                  -- 入账金额       
   ,memo_cd                      -- 摘要码        
   ,memo                         -- 摘要         
   ,db_cr_dir_cd                 -- 借贷标志       
   ,city_flg                     -- 同城标志       
   ,crossb_flg                   -- 跨行标志       
   ,ovsea_flg                    -- 境外标志       
   ,cash_tfr_flg                 -- 现转标志       
   ,initor_typ_cd                -- 发起方类型代码    
   ,prim_vchr_type_cd            -- 主凭证种类代码    
   ,prim_vchr_num                -- 主凭证号码      
   ,scd_vchr_type_cd             -- 副凭证种类代码    
   ,scd_vchr_num                 -- 副凭证号码      
   ,assoc_bcs_evt_id             -- 关联核心系统事件编号 
   ,reverse_evt_id               -- 冲正事件编号     
   ,flow_id                      -- 流程编号       
   ,assoc_coll_id                -- 关联抵质押品编号   
   ,nostro_flg                   -- 往账标志       
   ,bal_dir_cd                   -- 余额方向代码     
   ,bal_typ_cd                   -- 余额类型代码     
   ,txn_med_name                 -- 交易介质名称     
   ,txn_med_id                   -- 交易介质编号     
   ,biz_typ_cd                   -- 业务类型代码     
   ,biz_cate_cd                  -- 业务种类代码     
   ,ghb_init_flg                 -- 本行发起标志     
   ,old_vchr_num                 -- 旧凭证号码      
   ,agt_blng_acct_num2           -- 协议所属账号2    
   ,agt_blng_acct_num3           -- 协议所属账号3    
   ,data_src_cd                  -- 数据来源代码     
   ,etl_dt                       -- 数据日期       
   ,job_cd                       -- 任务代码       
   ,etl_timestamp                -- 任务处理时间     
)
select 'L109'||T1.MIDGROD_FLOW_NUM                                                          --业务系统事件编号
      ,''                                                                                   --全局渠道流水号
      ,''                                                                                   --上一全局渠道流水号
      ,CASE T1.MIDGROD_TRAN_CODE WHEN 'A49F06' THEN T3.PREV_EVT_ID END                      --上一事件编号
      ,'L109'                                                                               --事件类型代码
      ,''                                                                                   --柜面菜单码
      ,T1.MIDGROD_TRAN_CODE                                                                 --交易码
      ,CASE WHEN T1.MIDGROD_TRAN_CODE = 'A49F01' then '汇兑'
     when T1.MIDGROD_TRAN_CODE = 'A49F05' then '汇兑来账退汇'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA59F03' then '汇兑来账'
     when T1.MIDGROD_TRAN_CODE = 'A49F06' then '汇兑来账维护入账'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA59C02' then '轮询交易'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA49C03' then '轮询交易'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA49C04' then '轮询交易'
     when T1.MIDGROD_TRAN_CODE = 'A49F22' then '定期贷记批次处理'
     when T1.MIDGROD_TRAN_CODE = 'A49F25' then '定期借记批次处理'
     else '其他'
end                                                                                         --交易描述
      ,T2.FRONT_DT                                                                          --交易日期
      ,SUBSTR(T2.FRONT_TM,1,2)||':'||SUBSTR(T1.TRAN_TM,3,2)||':'||SUBSTR(T1.TRAN_TM,5,2)    --交易时间
      ,T2.CURR_CD                                                                           --交易币种代码
      ,T1.TRAN_AMT                                                                          --交易金额
      ,''                                                                                   --账户余额
      ,''                                                                                   --费用类型代码
      ,''                                                                                   --费用金额
      ,CASE WHEN T1.STATUS_CD = '1' THEN '1'
     WHEN T1.STATUS_CD = 'E' THEN '2'
     ELSE '9'
END                                                                                         --事件状态代码     
      ,''                                                                                   --事件冲正类型代码   
      ,''                                                                                   --协议编号       
      ,T1.PAY_ACCT_NAME                                                                     --协议全称       
      ,T1.PAY_ACCT                                                                          --协议所属账号     
      ,'EFT'                                                                                --产品编号       
      ,''                                                                                   --客户编号       
      ,T1.PROC_ORG_ID                                                                       --交易机构编号     
      ,T1.PROC_TELLER_ID                                                                    --交易柜员编号     
      ,''                                                                                   --复核柜员编号     
      ,T2.AUTH_TELLER_ID                                                                    --授权柜员编号     
      ,''                                                                                   --客户经理编号     
      ,''                                                                                   --渠道类型代码     
      ,T2.PASS_ID                                                                           --渠道编号       
      ,''                                                                                   --支付通道类型代码   
      ,''                                                                                   --交易对手客户编号   
      ,T1.PAY_ACCT_NAME                                                                     --交易对手名称     
      ,''                                                                                   --交易对手账户开户行号 
      ,''                                                                                   --交易对手账户开户行名称
      ,''                                                                                   --交易对手账号ID   
      ,T1.RECVBL_ACCT                                                                       --交易对手账号     
      ,''                                                                                   --交易对手机构编号   
      ,''                                                                                   --交易对手机构名称   
      ,''                                                                                   --入账日期       
      ,''                                                                                   --入账时间       
      ,''                                                                                   --入账机构编号     
      ,''                                                                                   --入账柜员编号     
      ,''                                                                                   --入账币种代码     
      ,''                                                                                   --入账金额       
      ,''                                                                                   --摘要码        
      ,''                                                                                   --摘要         
      ,'D'                                                                                  --借贷标志       
      ,''                                                                                   --同城标志       
      ,''                                                                                   --跨行标志       
      ,''                                                                                   --境外标志       
      ,''                                                                                   --现转标志       
      ,''                                                                                   --发起方类型代码    
      ,''                                                                                   --主凭证种类代码    
      ,''                                                                                   --主凭证号码      
      ,''                                                                                   --副凭证种类代码    
      ,''                                                                                   --副凭证号码      
      ,T1.HOST_FLOW_NUM                                                                     --关联核心系统事件编号 
      ,''                                                                                   --冲正事件编号     
      ,''                                                                                   --流程编号       
      ,''                                                                                   --关联抵质押品编号   
      ,T2.NOSTRO_FLG                                                                        --往账标志       
      ,''                                                                                   --余额方向代码     
      ,''                                                                                   --余额类型代码     
      ,''                                                                                   --交易介质名称     
      ,''                                                                                   --交易介质编号     
      ,''                                                                                   --业务类型代码     
      ,''                                                                                   --业务种类代码     
      ,''                                                                                   --本行发起标志     
      ,''                                                                                   --旧凭证号码      
      ,''                                                                                   --协议所属账号2    
      ,''                                                                                   --协议所属账号3    
      ,'MPCS'                    
  --  ,'EVT_MPCS_EVENT_DTL_02'                                                              --ETL任务名称
      ,to_date('${batch_date}','yyyymmdd')                                                  --数据日期
  --  ,''                                                                                   --
  --  ,'0'                                                                                  --
  --  ,''                                                                                   --
  --  ,''                                                                                   --
  --  ,''                                                                                   --外部科目编号
  --  ,''                                                                                   --红蓝字标志
  --  ,''                                                                                   --银行编号
  --  ,''                                                                                   --银团编号
  --  ,''                                                                                   --我行出资比例
      ,'02'                                                                                 --任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                      --任务处理时间
     from ${iml_schema}.evt_tef_entry_evt t1                                                --省金服记账事件
inner join ${iml_schema}.evt_tef_tran_evt t2                                                --省金服交易事件
       on t1.front_flow_num = t2.front_flow_num
and t1.front_dt = t2.front_dt
left join (
select PAY_REPORT_INFO_SEQ_NUM,'L109'||C.FRONT_DT||C.FRONT_FLOW_NUM AS PREV_EVT_ID
from ${iml_schema}.evt_tef_tran_evt  c 
where  C.MIDGROD_TRAN_CODE='A49F06' 
and rownum <2 ) t3                                                                          --省金服交易事件
       on t2.init_tran_pay_odd_no = t3.pay_report_info_seq_num
    where t1.front_dt = to_date('${batch_date}','yyyymmdd');

commit;


whenever sqlerror exit sql.sqlcode;
--第三组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --大额支付业务
insert /*+ append(3) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id                       -- 事件编号       
   ,global_chn_seq_num           -- 全局渠道流水号    
   ,prev_global_chn_seq_num      -- 上一全局渠道流水号  
   ,prev_evt_id                  -- 上一事件编号     
   ,evt_typ_cd                   -- 事件类型代码     
   ,menuid                       -- 柜面菜单码      
   ,txn_num                      -- 交易码        
   ,txn_desc                     -- 交易描述       
   ,txn_dt                       -- 交易日期       
   ,txn_tm                       -- 交易时间       
   ,txn_ccy_cd                   -- 交易币种代码     
   ,txn_amt                      -- 交易金额       
   ,acct_bal                     -- 账户余额       
   ,cost_typ_cd                  -- 费用类型代码     
   ,fee_amt                      -- 手续费金额      
   ,evt_status_cd                -- 事件状态代码     
   ,evt_reverse_typ_cd           -- 事件冲正类型代码   
   ,agt_id                       -- 协议编号       
   ,agt_id_name                  -- 协议全称       
   ,agt_blng_acct_num            -- 协议所属账号     
   ,prd_id                       -- 产品编号       
   ,pty_id                       -- 客户编号       
   ,txn_org_id                   -- 交易机构编号     
   ,txn_teller_id                -- 交易柜员编号     
   ,chk_teller_id                -- 复核柜员编号     
   ,auth_teller_id               -- 授权柜员编号     
   ,pty_mgr_id                   -- 客户经理编号     
   ,chn_typ_cd                   -- 渠道类型代码     
   ,chn_id                       -- 渠道编号       
   ,pay_chnl_typ_cd              -- 支付通道类型代码   
   ,cntrpty_id                   -- 交易对手编号     
   ,cntrpty_name                 -- 交易对手名称     
   ,cntrpty_acct_openbk_num      -- 交易对手账户开户行号 
   ,cntrpty_acct_openbk_name     -- 交易对手账户开户行名称
   ,cntrpty_acct_num_id          -- 交易对手账号ID   
   ,cntrpty_acct_num             -- 交易对手账号     
   ,cntrpty_org_id               -- 交易对手机构编号   
   ,cntrpty_org_name             -- 交易对手机构名称   
   ,posting_dt                   -- 入账日期       
   ,posting_tm                   -- 入账时间       
   ,posting_org_id               -- 入账机构编号     
   ,posting_teller_id            -- 入账柜员编号     
   ,posting_ccy_cd               -- 入账币种代码     
   ,posting_amt                  -- 入账金额       
   ,memo_cd                      -- 摘要码        
   ,memo                         -- 摘要         
   ,db_cr_dir_cd                 -- 借贷标志       
   ,city_flg                     -- 同城标志       
   ,crossb_flg                   -- 跨行标志       
   ,ovsea_flg                    -- 境外标志       
   ,cash_tfr_flg                 -- 现转标志       
   ,initor_typ_cd                -- 发起方类型代码    
   ,prim_vchr_type_cd            -- 主凭证种类代码    
   ,prim_vchr_num                -- 主凭证号码      
   ,scd_vchr_type_cd             -- 副凭证种类代码    
   ,scd_vchr_num                 -- 副凭证号码      
   ,assoc_bcs_evt_id             -- 关联核心系统事件编号 
   ,reverse_evt_id               -- 冲正事件编号     
   ,flow_id                      -- 流程编号       
   ,assoc_coll_id                -- 关联抵质押品编号   
   ,nostro_flg                   -- 往账标志       
   ,bal_dir_cd                   -- 余额方向代码     
   ,bal_typ_cd                   -- 余额类型代码     
   ,txn_med_name                 -- 交易介质名称     
   ,txn_med_id                   -- 交易介质编号     
   ,biz_typ_cd                   -- 业务类型代码     
   ,biz_cate_cd                  -- 业务种类代码     
   ,ghb_init_flg                 -- 本行发起标志     
   ,old_vchr_num                 -- 旧凭证号码      
   ,agt_blng_acct_num2           -- 协议所属账号2    
   ,agt_blng_acct_num3           -- 协议所属账号3    
   ,data_src_cd                  -- 数据来源代码     
   ,etl_dt                       -- 数据日期       
   ,job_cd                       -- 任务代码       
   ,etl_timestamp                -- 任务处理时间     
)
select 'L100'||T1.BS_AMT_ENTRY_ID                                                  --业务系统事件编号 
      ,''                                                                          --全局渠道流水号  
      ,''                                                                          --上一全局渠道流水号
      ,'L100'||T2.PAY_DECL_FORM_ID                                                 --上一事件编号   
      ,'L100'                                                                      --事件类型代码   
      ,''                                                                          --柜面菜单码    
      ,T1.MIDGROD_TRAN_CODE                                                        --交易码      
      ,CASE WHEN T1.MIDGROD_TRAN_CODE = 'ZTSA0LF03' then '大额往账'
     WHEN T1.MIDGROD_TRAN_CODE = 'ZTSA0LF01' then '大额往账'
     WHEN T1.MIDGROD_TRAN_CODE = 'A05F01' then '大额往账录入'
     WHEN T1.MIDGROD_TRAN_CODE = 'A05F02' then '大额往账复核'
     WHEN T1.MIDGROD_TRAN_CODE = 'A05F04' then '大额往账删除'
     WHEN T1.MIDGROD_TRAN_CODE = 'A15F01' then '大额维护入账'
     WHEN T1.MIDGROD_TRAN_CODE = 'A05F03' then '大额往账修改'
     WHEN T1.MIDGROD_TRAN_CODE = 'A05F04' then '大额往账删除'
     WHEN T1.MIDGROD_TRAN_CODE = 'A05F06' then '大额往账(退汇)'
     WHEN T1.MIDGROD_TRAN_CODE = 'ZTSA04F01' then '其他渠道录入'
     WHEN T1.MIDGROD_TRAN_CODE = 'A15F01' then '大额维护入账'
     WHEN T1.MIDGROD_TRAN_CODE = 'A15F02' then '大额维护入账冲账'
     WHEN T1.MIDGROD_TRAN_CODE = 'A15F03' then '大额来账挂账转发'
     WHEN T1.MIDGROD_TRAN_CODE = 'A05F01' then '大额退回应答'
     WHEN T1.MIDGROD_TRAN_CODE = 'A15F02' then '大额维护入账冲账'
     WHEN T1.MIDGROD_TRAN_CODE = 'A15F02' then '大额维护入账冲账'
     WHEN T1.MIDGROD_TRAN_CODE = 'A15F04' then '退汇重发'
     WHEN T1.MIDGROD_TRAN_CODE = 'ZTSA04FF1' then '轮询挂账'
     WHEN T1.MIDGROD_TRAN_CODE = 'A05F08' then '大额授权'
     WHEN T1.MIDGROD_TRAN_CODE = 'A08C01' then '大额撤销'
     WHEN T1.MIDGROD_TRAN_CODE = 'A05F10' then '汇票签发'
     WHEN T1.MIDGROD_TRAN_CODE = 'A05F11' then '汇票移存'
     WHEN T1.MIDGROD_TRAN_CODE = 'ZTSA17604' then '大额清算回执'
     WHEN T1.MIDGROD_TRAN_CODE = 'ZTSA04F52' then '流程银行汇兑交易'
     WHEN T1.MIDGROD_TRAN_CODE = 'ZTSA04FF1' then '网银等渠道后续处理'
 END                                                                                                    --交易描述
      ,T1.TRAN_DT                                                                                       --交易日期
      ,SUBSTR(T1.TRAN_TM,1,2)||':'||SUBSTR(T1.TRAN_TM,3,2)||':'||SUBSTR(T1.TRAN_TM,5,2)                 --交易时间
      ,'CNY'                                                                                            --交易币种代码
      ,T1.TRAN_AMT                                                                                      --交易金额
      ,''                                                                                               --账户余额
      ,''                                                                                               --费用类型代码
      ,''                                                                                               --费用金额
      ,CASE WHEN T1.STATUS_CD = '1' THEN '1'
     WHEN T1.STATUS_CD = '0' THEN '2'
     ELSE '9'
END                                                                                                     --事件状态代码     
      ,''                                                                                               --事件冲正类型代码   
      ,''                                                                                               --协议编号       
      ,T1.PAYER_NAME                                                                                    --协议全称       
      ,T1.PAYER_ACCT_NUM                                                                                --协议所属账号     
      ,'HVPS'                                                                                           --产品编号       
      ,''                                                                                               --客户编号       
      ,T1.MGMT_ORG_ID                                                                                   --交易机构编号     
      ,T1.TELLER_ID                                                                                     --交易柜员编号     
      ,T2.CHECK_TELLER_ID                                                                               --复核柜员编号     
      ,T2.AUTH_TELLER_ID                                                                                --授权柜员编号     
      ,''                                                                                               --客户经理编号     
      ,''                                                                                               --渠道类型代码     
      ,T3.SRC_CODE_VAL                                                                                  --渠道编号       
      ,''                                                                                               --支付通道类型代码   
      ,''                                                                                               --交易对手客户编号   
      ,T1.RECVER_NAME                                                                                   --交易对手名称     
      ,''                                                                                               --交易对手账户开户行号 
      ,''                                                                                               --交易对手账户开户行名称
      ,''                                                                                               --交易对手账号ID   
      ,T1.RECVER_ACCT_NUM                                                                               --交易对手账号     
      ,''                                                                                               --交易对手机构编号   
      ,''                                                                                               --交易对手机构名称   
      ,''                                                                                               --入账日期       
      ,''                                                                                               --入账时间       
      ,''                                                                                               --入账机构编号     
      ,''                                                                                               --入账柜员编号     
      ,''                                                                                               --入账币种代码     
      ,''                                                                                               --入账金额       
      ,''                                                                                               --摘要码        
      ,''                                                                                               --摘要         
      ,CASE WHEN T2.DEBIT_CRDT_CD = 'D' THEN 'C' WHEN T2.DEBIT_CRDT_CD = 'C' THEN 'D'  END              --借贷标志
      ,''                                                                                               --同城标志
      ,''                                                                                               --跨行标志
      ,''                                                                                               --境外标志
      ,''                                                                                               --现转标志
      ,''                                                                                               --发起方类型代码
      ,''                                                                                               --主凭证种类代码
      ,''                                                                                               --主凭证号码
      ,''                                                                                               --副凭证种类代码
      ,''                                                                                               --副凭证号码
      ,T1.HOST_FLOW_NUM                                                                                 --关联核心系统事件编号
      ,''                                                                                               --冲正事件编号
      ,''                                                                                               --流程编号
      ,''                                                                                               --关联抵质押品编号
      ,T2.NOSTRO_FLG                                                                                    --往账标志
      ,''                                                                                               --余额方向代码
      ,''                                                                                               --余额类型代码
      ,''                                                                                               --交易介质名称
      ,''                                                                                               --交易介质编号
      ,case when T2.BANK_INT_SYS_EDIT_NUM='2' and T2.CNTPTY_SYS_EDIT_NUM='2'  then T2.BUS_TYPE_CD
     when  T2.BANK_INT_SYS_EDIT_NUM='2' and T2.CNTPTY_SYS_EDIT_NUM='1' then                             --他行为一代支付
         case when T2.BUS_TYPE_CD = '00114'  then 'YL01'                                                --待人行一代支付系统下线后就可以删除该逻辑
              when T2.BUS_TYPE_CD =  '40502'  then 'YL02'
              when T2.BUS_TYPE_CD =  '40501'  then 'YL03'
              when T2.BUS_TYPE_CD = 'CMT100'  then 'YL04'
              when T2.BUS_TYPE_CD = 'CMT108'  then 'YL05'
              when T2.BUS_TYPE_CD = 'CMT101'  then 'YL06'
              when T2.BUS_TYPE_CD = 'CMT102'  then 'YL07'
              when T2.BUS_TYPE_CD = 'CMT121'  then 'YL08'
              when T2.BUS_TYPE_CD = 'CMT122'  then 'YL09'
              when T2.BUS_TYPE_CD = 'CMT123'  then 'YL10'
              when T2.BUS_TYPE_CD = 'CMT124'  then 'YL11'
              when T2.BUS_TYPE_CD = 'CMT103'  then 'YL12'
              when T2.BUS_TYPE_CD = 'CMT105'  then 'YL13'
              when T2.BUS_TYPE_CD =  '00100'  then 'YL14'
              when T2.BUS_TYPE_CD =  '00108'  then 'YL15'
              when T2.BUS_TYPE_CD =  '00101'  then 'YL16'
              when T2.BUS_TYPE_CD =  '00102'  then 'YL17'
              when T2.BUS_TYPE_CD =  '30002'  then 'YL18'
              when T2.BUS_TYPE_CD =  '00106'  then 'YL19'
              when T2.BUS_TYPE_CD =  '00103'  then 'YL20'
              when T2.BUS_TYPE_CD =  '20005'  then 'YL21'
              when T2.BUS_TYPE_CD =  '00104'  then 'YL22'
              when T2.BUS_TYPE_CD =  '00119'  then 'YL23'
              when T2.BUS_TYPE_CD =  '00113'  then 'YL24'
              when T2.BUS_TYPE_CD =  '20105'  then 'YL25'
              when T2.BUS_TYPE_CD =  '30102'  then 'YL26'
              when T2.BUS_TYPE_CD =  '30103'  then 'YL27'
              when T2.BUS_TYPE_CD =  '30104'  then 'YL28'
              when T2.BUS_TYPE_CD =  '30105'  then 'YL29'
           end
       end                                                                                              --业务类型代码
      ,case when T2.BANK_INT_SYS_EDIT_NUM='2' and T2.CNTPTY_SYS_EDIT_NUM='2'  then T2.BUS_KIND_CD
     when T2.BANK_INT_SYS_EDIT_NUM='2' and T2.CNTPTY_SYS_EDIT_NUM='1'  then
         case when T2.BUS_KIND_CD = '00605'  then 'YZ001'
              when T2.BUS_KIND_CD = '00700'  then 'YZ002'
              when T2.BUS_KIND_CD = '00701'  then 'YZ003'
              when T2.BUS_KIND_CD = '00702'  then 'YZ004'
              when T2.BUS_KIND_CD = '00703'  then 'YZ005'
              when T2.BUS_KIND_CD = '00704'  then 'YZ006'
              when T2.BUS_KIND_CD = '00705'  then 'YZ007'
              when T2.BUS_KIND_CD = '00706'  then 'YZ008'
              when T2.BUS_KIND_CD = '00707'  then 'YZ009'
              when T2.BUS_KIND_CD = '00708'  then 'YZ010'
              when T2.BUS_KIND_CD = '00800'  then 'YZ011'
              when T2.BUS_KIND_CD = '00801'  then 'YZ012'
              when T2.BUS_KIND_CD = '00802'  then 'YZ013'
              when T2.BUS_KIND_CD = '00803'  then 'YZ014'
              when T2.BUS_KIND_CD = '00900'  then 'YZ015'
              when T2.BUS_KIND_CD = '00901'  then 'YZ016'
              when T2.BUS_KIND_CD = '00902'  then 'YZ017'
              when T2.BUS_KIND_CD = '00903'  then 'YZ018'
              when T2.BUS_KIND_CD = '01000'  then 'YZ019'
              when T2.BUS_KIND_CD = '01001'  then 'YZ020'
              when T2.BUS_KIND_CD = '01002'  then 'YZ021'
              when T2.BUS_KIND_CD = '01100'  then 'YZ022'
              when T2.BUS_KIND_CD = '01101'  then 'YZ023'
              when T2.BUS_KIND_CD = '01102'  then 'YZ024'
              when T2.BUS_KIND_CD = '09900'  then 'YZ025'
              when T2.BUS_KIND_CD = '09901'  then 'YZ026'
              when T2.BUS_KIND_CD = '04900'  then 'YZ027'
              when T2.BUS_KIND_CD = '04901'  then 'YZ028'
              when T2.BUS_KIND_CD = '04902'  then 'YZ029'
              when T2.BUS_KIND_CD = '04903'  then 'YZ030'
              when T2.BUS_KIND_CD = '00100'  then 'YZ031'
              when T2.BUS_KIND_CD = '00101'  then 'YZ032'
              when T2.BUS_KIND_CD = '00102'  then 'YZ033'
              when T2.BUS_KIND_CD = '00200'  then 'YZ034'
              when T2.BUS_KIND_CD = '00201'  then 'YZ035'
              when T2.BUS_KIND_CD = '00202'  then 'YZ036'
              when T2.BUS_KIND_CD = '00203'  then 'YZ037'
              when T2.BUS_KIND_CD = '00204'  then 'YZ038'
              when T2.BUS_KIND_CD = '00205'  then 'YZ039'
              when T2.BUS_KIND_CD = '00300'  then 'YZ040'
              when T2.BUS_KIND_CD = '00301'  then 'YZ041'
              when T2.BUS_KIND_CD = '00400'  then 'YZ042'
              when T2.BUS_KIND_CD = '00401'  then 'YZ043'
              when T2.BUS_KIND_CD = '00402'  then 'YZ044'
              when T2.BUS_KIND_CD = '00403'  then 'YZ045'
              when T2.BUS_KIND_CD = '00404'  then 'YZ046'
              when T2.BUS_KIND_CD = '00405'  then 'YZ047'
              when T2.BUS_KIND_CD = '00500'  then 'YZ048'
              when T2.BUS_KIND_CD = '00501'  then 'YZ049'
              when T2.BUS_KIND_CD = '00502'  then 'YZ050'
              when T2.BUS_KIND_CD = '00503'  then 'YZ051'
              when T2.BUS_KIND_CD = '00504'  then 'YZ052'
              when T2.BUS_KIND_CD = '00505'  then 'YZ053'
              when T2.BUS_KIND_CD = '00506'  then 'YZ054'
              when T2.BUS_KIND_CD = '00507'  then 'YZ055'
              when T2.BUS_KIND_CD = '00508'  then 'YZ056'
              when T2.BUS_KIND_CD = '00600'  then 'YZ057'
              when T2.BUS_KIND_CD = '00601'  then 'YZ058'
              when T2.BUS_KIND_CD = '00602'  then 'YZ059'
              when T2.BUS_KIND_CD = '00603'  then 'YZ060'
              when T2.BUS_KIND_CD = '00604'  then 'YZ061'
              when T2.BUS_KIND_CD = '05100'  then 'YZ062'
              when T2.BUS_KIND_CD = '05101'  then 'YZ063'
              when T2.BUS_KIND_CD = '05102'  then 'YZ064'
              when T2.BUS_KIND_CD = '05103'  then 'YZ065'
           end
        end                                                                        --业务种类代码
      ,''                                                                          --本行发起标志
      ,''                                                                          --旧凭证号码
      ,''                                                                          --协议所属账号2
      ,''                                                                          --协议所属账号3
      ,'MPCS'                                                                      --数据来源代码
  --  ,'EVT_MPCS_EVENT_DTL_02'                                                     --ETL任务名称
      ,to_date('${batch_date}','yyyymmdd')                                         --数据日期
  --  ,''                                                                          --
  --  ,'0'                                                                         --
  --  ,''                                                                          --
  --  ,''                                                                          --
  --  ,''                                                                          --外部科目编号
  --  ,''                                                                          --红蓝字标志
  --  ,''                                                                          --银行编号
  --  ,''                                                                          --银团编号
  --  ,''                                                                          --我行出资比例
      ,'03'                                                                        --任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')             --任务处理时间
     FROM ${iml_schema}.EVT_BS_AMT_ENTRY_EVT T1                                    --大小额记账事件
INNER JOIN ${iml_schema}.EVT_BIGAMT_TRAN_EVT T2                                    --大额交易事件
       ON T1.BANK_INT_BUS_SEQ_NUM = T2.BANK_INT_BUS_SEQ_NUM
LEFT JOIN (SELECT * FROM(
SELECT  R1.*,ROW_NUMBER() OVER(PARTITION BY R1.TARGET_CD_VAL order by R1.TARGET_CD_VAL) RNUM  from ${iml_schema}.REF_PUB_CD_MAP R1
WHERE R1.SORC_SYS_CD = 'MPCS'
   AND R1.SRC_TAB_EN_NAME = 'MPCS_A08THVTRX'
   AND R1.SRC_FIELD_EN_NAME = 'OPENWINTYPE'
   AND R1.TARGET_TAB_EN_NAME = 'EVT_BIGAMT_TRAN_EVT'
   AND R1.TARGET_TAB_FIELD_EN_NAME = 'EXCH_BUS_TRAN_CHN_CD')
WHERE RNUM=1)T3
       ON T2.EXCH_BUS_TRAN_CHN_CD = T3.TARGET_CD_VAL
    WHERE T1.SYS_CD IN( 'HVPS','hvps')
AND T1.TRAN_DT = to_date('${batch_date}','yyyymmdd');

commit;


whenever sqlerror exit sql.sqlcode;
--第四组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --小额支付业务
insert /*+ append(4) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id                       -- 事件编号       
   ,global_chn_seq_num           -- 全局渠道流水号    
   ,prev_global_chn_seq_num      -- 上一全局渠道流水号  
   ,prev_evt_id                  -- 上一事件编号     
   ,evt_typ_cd                   -- 事件类型代码     
   ,menuid                       -- 柜面菜单码      
   ,txn_num                      -- 交易码        
   ,txn_desc                     -- 交易描述       
   ,txn_dt                       -- 交易日期       
   ,txn_tm                       -- 交易时间       
   ,txn_ccy_cd                   -- 交易币种代码     
   ,txn_amt                      -- 交易金额       
   ,acct_bal                     -- 账户余额       
   ,cost_typ_cd                  -- 费用类型代码     
   ,fee_amt                      -- 手续费金额      
   ,evt_status_cd                -- 事件状态代码     
   ,evt_reverse_typ_cd           -- 事件冲正类型代码   
   ,agt_id                       -- 协议编号       
   ,agt_id_name                  -- 协议全称       
   ,agt_blng_acct_num            -- 协议所属账号     
   ,prd_id                       -- 产品编号       
   ,pty_id                       -- 客户编号       
   ,txn_org_id                   -- 交易机构编号     
   ,txn_teller_id                -- 交易柜员编号     
   ,chk_teller_id                -- 复核柜员编号     
   ,auth_teller_id               -- 授权柜员编号     
   ,pty_mgr_id                   -- 客户经理编号     
   ,chn_typ_cd                   -- 渠道类型代码     
   ,chn_id                       -- 渠道编号       
   ,pay_chnl_typ_cd              -- 支付通道类型代码   
   ,cntrpty_id                   -- 交易对手编号     
   ,cntrpty_name                 -- 交易对手名称     
   ,cntrpty_acct_openbk_num      -- 交易对手账户开户行号 
   ,cntrpty_acct_openbk_name     -- 交易对手账户开户行名称
   ,cntrpty_acct_num_id          -- 交易对手账号ID   
   ,cntrpty_acct_num             -- 交易对手账号     
   ,cntrpty_org_id               -- 交易对手机构编号   
   ,cntrpty_org_name             -- 交易对手机构名称   
   ,posting_dt                   -- 入账日期       
   ,posting_tm                   -- 入账时间       
   ,posting_org_id               -- 入账机构编号     
   ,posting_teller_id            -- 入账柜员编号     
   ,posting_ccy_cd               -- 入账币种代码     
   ,posting_amt                  -- 入账金额       
   ,memo_cd                      -- 摘要码        
   ,memo                         -- 摘要         
   ,db_cr_dir_cd                 -- 借贷标志       
   ,city_flg                     -- 同城标志       
   ,crossb_flg                   -- 跨行标志       
   ,ovsea_flg                    -- 境外标志       
   ,cash_tfr_flg                 -- 现转标志       
   ,initor_typ_cd                -- 发起方类型代码    
   ,prim_vchr_type_cd            -- 主凭证种类代码    
   ,prim_vchr_num                -- 主凭证号码      
   ,scd_vchr_type_cd             -- 副凭证种类代码    
   ,scd_vchr_num                 -- 副凭证号码      
   ,assoc_bcs_evt_id             -- 关联核心系统事件编号 
   ,reverse_evt_id               -- 冲正事件编号     
   ,flow_id                      -- 流程编号       
   ,assoc_coll_id                -- 关联抵质押品编号   
   ,nostro_flg                   -- 往账标志       
   ,bal_dir_cd                   -- 余额方向代码     
   ,bal_typ_cd                   -- 余额类型代码     
   ,txn_med_name                 -- 交易介质名称     
   ,txn_med_id                   -- 交易介质编号     
   ,biz_typ_cd                   -- 业务类型代码     
   ,biz_cate_cd                  -- 业务种类代码     
   ,ghb_init_flg                 -- 本行发起标志     
   ,old_vchr_num                 -- 旧凭证号码      
   ,agt_blng_acct_num2           -- 协议所属账号2    
   ,agt_blng_acct_num3           -- 协议所属账号3    
   ,data_src_cd                  -- 数据来源代码     
   ,etl_dt                       -- 数据日期       
   ,job_cd                       -- 任务代码       
   ,etl_timestamp                -- 任务处理时间     
)
select 'L100'||T1.BS_AMT_ENTRY_ID                          --业务系统事件编号
      ,''                                                  --全局渠道流水号
      ,''                                                  --上一全局渠道流水号
      ,'L100'||T2.PAY_DECL_FORM_ID                         --上一事件编号
      ,'L100'                                              --事件类型代码
      ,''                                                  --柜面菜单码
      ,T1.MIDGROD_TRAN_CODE                                --交易码
      ,case when T1.MIDGROD_TRAN_CODE = 'ZTSA0LF01' then '统一支付小额往账'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA0LF02' then '统一支付小额批量往账'
     when T1.MIDGROD_TRAN_CODE = 'A06F02' then '小额往账复核 '
     when T1.MIDGROD_TRAN_CODE = 'A06F04' then '小额往账删除'
     when T1.MIDGROD_TRAN_CODE = 'A16F01' then '小额维护入账'
     when T1.MIDGROD_TRAN_CODE = 'A16F02' then '小额维护入账冲账'
     when T1.MIDGROD_TRAN_CODE = 'A16F03' then '小额挂账转发'
     when T1.MIDGROD_TRAN_CODE = 'A16F04' then '小额退汇'
     when T1.MIDGROD_TRAN_CODE = 'A16F05' then '提回入账失败处理'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA06F91' then '支票影像报文提入记账'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA06FF2' then '发送失败挂账账务处理'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA06FF3' then '被人行拒票挂账账务处理'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA16131' then '小额实时借记业务报文'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA16132' then '小额实时借记业务回执'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA16FF1' then '来账账务处理'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA16FF2' then '日终小额来账挂账处理'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA17603' then '小额净额清算通知'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA04F52' then '流程银行汇兑交易'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA04FF1' then '网银等渠道后续处理'
     when T1.MIDGROD_TRAN_CODE = 'A06F52' then '发起贷记业务复核'
     when T1.MIDGROD_TRAN_CODE = 'A06F01' then '小额往账录入'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA04F01' then '其他渠道接入'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA14010' then '实时借记回执PKG010来账处理'
     else '其他'
  end                                      --交易描述
      ,T1.TRAN_DT                          --交易日期
      ,SUBSTR(T1.TRAN_TM,1,2)||':'||SUBSTR(T1.TRAN_TM,3,2)||':'||SUBSTR(T1.TRAN_TM,5,2)                          --交易时间
      ,'CNY'                               --交易币种代码
      ,T1.TRAN_AMT                         --交易金额
      ,''                                  --账户余额
      ,''                                  --费用类型代码
      ,''                                  --费用金额
      ,CASE WHEN T1.STATUS_CD = '1' THEN '1'
     WHEN T1.STATUS_CD = '0' THEN '2'
     ELSE '9'
END                                        --事件状态代码     
      ,''                                  --事件冲正类型代码   
      ,''                                  --协议编号       
      ,T1.PAYER_NAME                       --协议全称       
      ,T1.PAYER_ACCT_NUM                   --协议所属账号     
      ,'BEPS'                              --产品编号       
      ,''                                  --客户编号       
      ,T1.MGMT_ORG_ID                      --交易机构编号     
      ,T1.TELLER_ID                        --交易柜员编号     
      ,T2.CHECK_TELLER_ID                  --复核柜员编号     
      ,T2.AUTH_TELLER_ID                   --授权柜员编号     
      ,''                                  --客户经理编号     
      ,''                                  --渠道类型代码     
      ,T3.SRC_CODE_VAL                     --渠道编号       
      ,''                                  --支付通道类型代码   
      ,''                                  --交易对手客户编号   
      ,T1.RECVER_NAME                      --交易对手名称     
      ,''                                  --交易对手账户开户行号 
      ,''                                  --交易对手账户开户行名称
      ,''                                  --交易对手账号ID   
      ,T1.RECVER_ACCT_NUM                  --交易对手账号     
      ,''                                  --交易对手机构编号   
      ,''                                  --交易对手机构名称   
      ,''                                  --入账日期       
      ,''                                  --入账时间       
      ,''                                  --入账机构编号     
      ,''                                  --入账柜员编号     
      ,''                                  --入账币种代码     
      ,''                                  --入账金额       
      ,''                                  --摘要码        
      ,''                                  --摘要         
      ,CASE WHEN T2.DEBIT_CRDT_CD = 'D' THEN 'C' WHEN T2.DEBIT_CRDT_CD = 'C' THEN 'D'  END                          --借贷标志
      ,''                                  --同城标志
      ,''                                  --跨行标志
      ,''                                  --境外标志
      ,''                                  --现转标志
      ,''                                  --发起方类型代码
      ,''                                  --主凭证种类代码
      ,''                                  --主凭证号码
      ,''                                  --副凭证种类代码
      ,''                                  --副凭证号码
      ,T1.HOST_FLOW_NUM                    --关联核心系统事件编号
      ,''                                  --冲正事件编号
      ,''                                  --流程编号
      ,''                                  --关联抵质押品编号
      ,T2.NOSTRO_FLG                       --往账标志
      ,''                                  --余额方向代码
      ,''                                  --余额类型代码
      ,''                                  --交易介质名称
      ,''                                  --交易介质编号
      ,case when T2.BANK_INT_SYS_EDIT_NUM='2' and T2.CNTPTY_SYS_EDIT_NUM='2'  then T2.SCD_GENER_BUS_TYPE_CD
     when  T2.BANK_INT_SYS_EDIT_NUM='2' and T2.CNTPTY_SYS_EDIT_NUM='1' then   --他行为一代支付
         case when T2.SCD_GENER_BUS_TYPE_CD = '00114'  then 'YL01'            --待人行一代支付系统下线后就可以删除该逻辑
              when T2.SCD_GENER_BUS_TYPE_CD =  '40502'  then 'YL02'
              when T2.SCD_GENER_BUS_TYPE_CD =  '40501'  then 'YL03'
              when T2.SCD_GENER_BUS_TYPE_CD = 'CMT100'  then 'YL04'
              when T2.SCD_GENER_BUS_TYPE_CD = 'CMT108'  then 'YL05'
              when T2.SCD_GENER_BUS_TYPE_CD = 'CMT101'  then 'YL06'
              when T2.SCD_GENER_BUS_TYPE_CD = 'CMT102'  then 'YL07'
              when T2.SCD_GENER_BUS_TYPE_CD = 'CMT121'  then 'YL08'
              when T2.SCD_GENER_BUS_TYPE_CD = 'CMT122'  then 'YL09'
              when T2.SCD_GENER_BUS_TYPE_CD = 'CMT123'  then 'YL10'
              when T2.SCD_GENER_BUS_TYPE_CD = 'CMT124'  then 'YL11'
              when T2.SCD_GENER_BUS_TYPE_CD = 'CMT103'  then 'YL12'
              when T2.SCD_GENER_BUS_TYPE_CD = 'CMT105'  then 'YL13'
              when T2.SCD_GENER_BUS_TYPE_CD =  '00100'  then 'YL14'
              when T2.SCD_GENER_BUS_TYPE_CD =  '00108'  then 'YL15'
              when T2.SCD_GENER_BUS_TYPE_CD =  '00101'  then 'YL16'
              when T2.SCD_GENER_BUS_TYPE_CD =  '00102'  then 'YL17'
              when T2.SCD_GENER_BUS_TYPE_CD =  '30002'  then 'YL18'
              when T2.SCD_GENER_BUS_TYPE_CD =  '00106'  then 'YL19'
              when T2.SCD_GENER_BUS_TYPE_CD =  '00103'  then 'YL20'
              when T2.SCD_GENER_BUS_TYPE_CD =  '20005'  then 'YL21'
              when T2.SCD_GENER_BUS_TYPE_CD =  '00104'  then 'YL22'
              when T2.SCD_GENER_BUS_TYPE_CD =  '00119'  then 'YL23'
              when T2.SCD_GENER_BUS_TYPE_CD =  '00113'  then 'YL24'
              when T2.SCD_GENER_BUS_TYPE_CD =  '20105'  then 'YL25'
              when T2.SCD_GENER_BUS_TYPE_CD =  '30102'  then 'YL26'
              when T2.SCD_GENER_BUS_TYPE_CD =  '30103'  then 'YL27'
              when T2.SCD_GENER_BUS_TYPE_CD =  '30104'  then 'YL28'
              when T2.SCD_GENER_BUS_TYPE_CD =  '30105'  then 'YL29'
           end
       end                          --业务类型代码
      ,case when T2.BANK_INT_SYS_EDIT_NUM='2' and T2.CNTPTY_SYS_EDIT_NUM='2'  then T2.BUS_KIND_CD
     when T2.BANK_INT_SYS_EDIT_NUM='2' and T2.CNTPTY_SYS_EDIT_NUM='1'  then
         case when T2.BUS_KIND_CD = '00605'  then 'YZ001'
              when T2.BUS_KIND_CD = '00700'  then 'YZ002'
              when T2.BUS_KIND_CD = '00701'  then 'YZ003'
              when T2.BUS_KIND_CD = '00702'  then 'YZ004'
              when T2.BUS_KIND_CD = '00703'  then 'YZ005'
              when T2.BUS_KIND_CD = '00704'  then 'YZ006'
              when T2.BUS_KIND_CD = '00705'  then 'YZ007'
              when T2.BUS_KIND_CD = '00706'  then 'YZ008'
              when T2.BUS_KIND_CD = '00707'  then 'YZ009'
              when T2.BUS_KIND_CD = '00708'  then 'YZ010'
              when T2.BUS_KIND_CD = '00800'  then 'YZ011'
              when T2.BUS_KIND_CD = '00801'  then 'YZ012'
              when T2.BUS_KIND_CD = '00802'  then 'YZ013'
              when T2.BUS_KIND_CD = '00803'  then 'YZ014'
              when T2.BUS_KIND_CD = '00900'  then 'YZ015'
              when T2.BUS_KIND_CD = '00901'  then 'YZ016'
              when T2.BUS_KIND_CD = '00902'  then 'YZ017'
              when T2.BUS_KIND_CD = '00903'  then 'YZ018'
              when T2.BUS_KIND_CD = '01000'  then 'YZ019'
              when T2.BUS_KIND_CD = '01001'  then 'YZ020'
              when T2.BUS_KIND_CD = '01002'  then 'YZ021'
              when T2.BUS_KIND_CD = '01100'  then 'YZ022'
              when T2.BUS_KIND_CD = '01101'  then 'YZ023'
              when T2.BUS_KIND_CD = '01102'  then 'YZ024'
              when T2.BUS_KIND_CD = '09900'  then 'YZ025'
              when T2.BUS_KIND_CD = '09901'  then 'YZ026'
              when T2.BUS_KIND_CD = '04900'  then 'YZ027'
              when T2.BUS_KIND_CD = '04901'  then 'YZ028'
              when T2.BUS_KIND_CD = '04902'  then 'YZ029'
              when T2.BUS_KIND_CD = '04903'  then 'YZ030'
              when T2.BUS_KIND_CD = '00100'  then 'YZ031'
              when T2.BUS_KIND_CD = '00101'  then 'YZ032'
              when T2.BUS_KIND_CD = '00102'  then 'YZ033'
              when T2.BUS_KIND_CD = '00200'  then 'YZ034'
              when T2.BUS_KIND_CD = '00201'  then 'YZ035'
              when T2.BUS_KIND_CD = '00202'  then 'YZ036'
              when T2.BUS_KIND_CD = '00203'  then 'YZ037'
              when T2.BUS_KIND_CD = '00204'  then 'YZ038'
              when T2.BUS_KIND_CD = '00205'  then 'YZ039'
              when T2.BUS_KIND_CD = '00300'  then 'YZ040'
              when T2.BUS_KIND_CD = '00301'  then 'YZ041'
              when T2.BUS_KIND_CD = '00400'  then 'YZ042'
              when T2.BUS_KIND_CD = '00401'  then 'YZ043'
              when T2.BUS_KIND_CD = '00402'  then 'YZ044'
              when T2.BUS_KIND_CD = '00403'  then 'YZ045'
              when T2.BUS_KIND_CD = '00404'  then 'YZ046'
              when T2.BUS_KIND_CD = '00405'  then 'YZ047'
              when T2.BUS_KIND_CD = '00500'  then 'YZ048'
              when T2.BUS_KIND_CD = '00501'  then 'YZ049'
              when T2.BUS_KIND_CD = '00502'  then 'YZ050'
              when T2.BUS_KIND_CD = '00503'  then 'YZ051'
              when T2.BUS_KIND_CD = '00504'  then 'YZ052'
              when T2.BUS_KIND_CD = '00505'  then 'YZ053'
              when T2.BUS_KIND_CD = '00506'  then 'YZ054'
              when T2.BUS_KIND_CD = '00507'  then 'YZ055'
              when T2.BUS_KIND_CD = '00508'  then 'YZ056'
              when T2.BUS_KIND_CD = '00600'  then 'YZ057'
              when T2.BUS_KIND_CD = '00601'  then 'YZ058'
              when T2.BUS_KIND_CD = '00602'  then 'YZ059'
              when T2.BUS_KIND_CD = '00603'  then 'YZ060'
              when T2.BUS_KIND_CD = '00604'  then 'YZ061'
              when T2.BUS_KIND_CD = '05100'  then 'YZ062'
              when T2.BUS_KIND_CD = '05101'  then 'YZ063'
              when T2.BUS_KIND_CD = '05102'  then 'YZ064'
              when T2.BUS_KIND_CD = '05103'  then 'YZ065'
           end
        end                                             --业务种类代码
      ,'0'                                              --本行发起标志
      ,''                                               --旧凭证号码
      ,''                                               --协议所属账号2
      ,''                                               --协议所属账号3
      ,'MPCS'                                           --数据来源代码
  --  ,'EVT_MPCS_EVENT_DTL_02'                          --ETL任务名称
      ,to_date('${batch_date}','yyyymmdd')              --数据日期
  --  ,''                                               --
  --  ,'0'                                              --
  --  ,''                                               --
  --  ,''                                               --
  --  ,''                                               --外部科目编号
  --  ,''                                               --红蓝字标志
  --  ,''                                               --银行编号
  --  ,''                                               --银团编号
  --  ,''                                               --我行出资比例
      ,'04'                                             --任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')    --任务处理时间
     FROM ${iml_schema}.EVT_BS_AMT_ENTRY_EVT T1                           --大小额记账事件
INNER JOIN ${iml_schema}.EVT_BEPS_TRAN_EVT T2                             --小额交易事件
       ON T1.BANK_INT_BUS_SEQ_NUM = T2.BANK_INT_BUS_SEQ_NUM
LEFT JOIN (SELECT * FROM(
select  R1.*,ROW_NUMBER() OVER(PARTITION BY R1.TARGET_CD_VAL order by R1.TARGET_CD_VAL) RNUM from ${iml_schema}.REF_PUB_CD_MAP R1
WHERE  R1.SORC_SYS_CD = 'MPCS'
   AND R1.SRC_TAB_EN_NAME = 'MPCS_A08TBETRX'
   AND R1.SRC_FIELD_EN_NAME = 'OPNWIN'
   AND R1.TARGET_TAB_EN_NAME = 'EVT_BEPS_TRAN_EVT'
   AND R1.TARGET_TAB_FIELD_EN_NAME = 'EXCH_BUS_CORS_TRAN_CHN_CD')
   WHERE RNUM=1)T3
       ON T2.EXCH_BUS_CORS_TRAN_CHN_CD = T3.TARGET_CD_VAL
    WHERE T1.SYS_CD = 'BEPS'
AND T1.TRAN_DT = to_date('${batch_date}','yyyymmdd')
and trim(T1.BANK_INT_BUS_SEQ_NUM) is not null;

commit;


whenever sqlerror exit sql.sqlcode;
--第五组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --查询
insert /*+ append(5) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id                       -- 事件编号       
   ,global_chn_seq_num           -- 全局渠道流水号    
   ,prev_global_chn_seq_num      -- 上一全局渠道流水号  
   ,prev_evt_id                  -- 上一事件编号     
   ,evt_typ_cd                   -- 事件类型代码     
   ,menuid                       -- 柜面菜单码      
   ,txn_num                      -- 交易码        
   ,txn_desc                     -- 交易描述       
   ,txn_dt                       -- 交易日期       
   ,txn_tm                       -- 交易时间       
   ,txn_ccy_cd                   -- 交易币种代码     
   ,txn_amt                      -- 交易金额       
   ,acct_bal                     -- 账户余额       
   ,cost_typ_cd                  -- 费用类型代码     
   ,fee_amt                      -- 手续费金额      
   ,evt_status_cd                -- 事件状态代码     
   ,evt_reverse_typ_cd           -- 事件冲正类型代码   
   ,agt_id                       -- 协议编号       
   ,agt_id_name                  -- 协议全称       
   ,agt_blng_acct_num            -- 协议所属账号     
   ,prd_id                       -- 产品编号       
   ,pty_id                       -- 客户编号       
   ,txn_org_id                   -- 交易机构编号     
   ,txn_teller_id                -- 交易柜员编号     
   ,chk_teller_id                -- 复核柜员编号     
   ,auth_teller_id               -- 授权柜员编号     
   ,pty_mgr_id                   -- 客户经理编号     
   ,chn_typ_cd                   -- 渠道类型代码     
   ,chn_id                       -- 渠道编号       
   ,pay_chnl_typ_cd              -- 支付通道类型代码   
   ,cntrpty_id                   -- 交易对手编号     
   ,cntrpty_name                 -- 交易对手名称     
   ,cntrpty_acct_openbk_num      -- 交易对手账户开户行号 
   ,cntrpty_acct_openbk_name     -- 交易对手账户开户行名称
   ,cntrpty_acct_num_id          -- 交易对手账号ID   
   ,cntrpty_acct_num             -- 交易对手账号     
   ,cntrpty_org_id               -- 交易对手机构编号   
   ,cntrpty_org_name             -- 交易对手机构名称   
   ,posting_dt                   -- 入账日期       
   ,posting_tm                   -- 入账时间       
   ,posting_org_id               -- 入账机构编号     
   ,posting_teller_id            -- 入账柜员编号     
   ,posting_ccy_cd               -- 入账币种代码     
   ,posting_amt                  -- 入账金额       
   ,memo_cd                      -- 摘要码        
   ,memo                         -- 摘要         
   ,db_cr_dir_cd                 -- 借贷标志       
   ,city_flg                     -- 同城标志       
   ,crossb_flg                   -- 跨行标志       
   ,ovsea_flg                    -- 境外标志       
   ,cash_tfr_flg                 -- 现转标志       
   ,initor_typ_cd                -- 发起方类型代码    
   ,prim_vchr_type_cd            -- 主凭证种类代码    
   ,prim_vchr_num                -- 主凭证号码      
   ,scd_vchr_type_cd             -- 副凭证种类代码    
   ,scd_vchr_num                 -- 副凭证号码      
   ,assoc_bcs_evt_id             -- 关联核心系统事件编号 
   ,reverse_evt_id               -- 冲正事件编号     
   ,flow_id                      -- 流程编号       
   ,assoc_coll_id                -- 关联抵质押品编号   
   ,nostro_flg                   -- 往账标志       
   ,bal_dir_cd                   -- 余额方向代码     
   ,bal_typ_cd                   -- 余额类型代码     
   ,txn_med_name                 -- 交易介质名称     
   ,txn_med_id                   -- 交易介质编号     
   ,biz_typ_cd                   -- 业务类型代码     
   ,biz_cate_cd                  -- 业务种类代码     
   ,ghb_init_flg                 -- 本行发起标志     
   ,old_vchr_num                 -- 旧凭证号码      
   ,agt_blng_acct_num2           -- 协议所属账号2    
   ,agt_blng_acct_num3           -- 协议所属账号3    
   ,data_src_cd                  -- 数据来源代码     
   ,etl_dt                       -- 数据日期       
   ,job_cd                       -- 任务代码       
   ,etl_timestamp                -- 任务处理时间     
)
select 'L101'||T1.QUERYSEQ||T1.QUERYDT||T1.SNDBRN||T1.TRANSTYPE||T1.MSGSRC                          --业务系统事件编号
      ,''                          --全局渠道流水号
      ,''                          --上一全局渠道流水号
      ,''                          --上一事件编号
      ,'L101'                      --事件类型代码
      ,''                          --柜面菜单码
      ,case when T1.MSGSRC = '0' then
               case when T1.Transtype = '3' then  'A08Q02' else 'A08Q12' end
           when T1.MSGSRC = '1' then  'A18314'
      end                          --交易码
      ,case when T1.TRANSTYPE = '1' then  '大额业务查询书'
     when T1.TRANSTYPE = '2' then  '小额业务查询书'
     when T1.TRANSTYPE = '3' then  '行内查询书' 
end                                                              --交易描述
      ,TO_DATE(T1.QUERYDT,'YYYY-MM-DD')                          --交易日期
      ,case when T1.msgsrc = '0' then
          case when nvl(T1.snddt,'0') = '0' then '' else substr(T1.snddt,9,2)||':'||substr(T1.snddt,11,2)||':'||substr(T1.snddt,13,2) end
     else 
          case when nvl(T1.rcvdt,'0') = '0' then '' else substr(T1.rcvdt,9,2)||':'||substr(T1.rcvdt,11,2)||':'||substr(T1.rcvdt,13,2)  end 
end                                       --交易时间
      ,T1.CCYNBR                          --交易币种代码
      ,T1.OLDCLRAMT                       --交易金额
      ,''                                 --账户余额
      ,''                                 --费用类型代码
      ,''                                 --费用金额
      ,CASE WHEN T1.STATUS = '01' THEN '1'
     ELSE '9'
END                                       --事件状态代码
      ,''                                 --事件冲正类型代码
      ,''                                 --协议编号
      ,''                                 --协议全称
      ,''                                 --协议所属账号
      ,case when T1.TRANSTYPE = '1' then  'HVPS'
     when T1.TRANSTYPE = '2' then  'BEPS'
     when T1.TRANSTYPE = '3' then  'CNAPS'
end                                       --产品编号
      ,''                                 --客户编号
      ,T1.MAGEBRN                         --交易机构编号
      ,T1.OPRTLR                          --交易柜员编号
      ,''                                 --复核柜员编号
      ,''                                 --授权柜员编号
      ,''                                 --客户经理编号
      ,case when T1.TRANSTYPE = '1' then '2201'
     when T1.TRANSTYPE = '2' then '2201'
     when T1.TRANSTYPE = '3' then '9999' 
end                                      --渠道类型代码
      ,case when T1.TRANSTYPE = '1' then  'HVPS'
     when T1.TRANSTYPE = '2' then  'BEPS'
     when T1.TRANSTYPE = '3' then  'CNAPS'
end                                --渠道编号
      ,''                          --支付通道类型代码
      ,''                          --交易对手客户编号
      ,''                          --交易对手名称
      ,case when T1.MSGSRC = '0' then T1.RCVBRN
     when T1.MSGSRC = '1' then T1.SNDBRN 
end                                --交易对手账户开户行号
      ,case when T1.MSGSRC = '0' then T2.BKNAME
     when T1.MSGSRC = '1' then T3.BKNAME 
end                                --交易对手账户开户行名称
      ,''                          --交易对手账号ID
      ,''                          --交易对手账号
      ,''                          --交易对手机构编号
      ,''                          --交易对手机构名称
      ,''                          --入账日期
      ,''                          --入账时间
      ,''                          --入账机构编号
      ,''                          --入账柜员编号
      ,''                          --入账币种代码
      ,''                          --入账金额
      ,''                          --摘要码
      ,''                          --摘要
      ,''                          --借贷标志
      ,''                          --同城标志
      ,''                          --跨行标志
      ,''                          --境外标志
      ,''                          --现转标志
      ,''                          --发起方类型代码
      ,''                          --主凭证种类代码
      ,''                          --主凭证号码
      ,''                          --副凭证种类代码
      ,''                          --副凭证号码
      ,''                          --关联核心系统事件编号
      ,''                          --冲正事件编号
      ,''                          --流程编号
      ,''                          --关联抵质押品编号
      ,case when T1.MSGSRC = '0' then '1'
     when T1.MSGSRC = '1' then '0' 
     else '1'
end                                --往账标志
      ,''                          --余额方向代码
      ,''                          --余额类型代码
      ,''                          --交易介质名称
      ,''                          --交易介质编号
      ,''                          --业务类型代码
      ,''                          --业务种类代码
      ,case when T1.MSGSRC = '0' then '1'
     when T1.MSGSRC = '1' then '0'
     else '1'
end                                --本行发起标志
      ,''                          --旧凭证号码
      ,''                          --协议所属账号2
      ,''                          --协议所属账号3
      ,'MPCS'                      --数据来源代码
--    ,'EVT_MPCS_EVENT_DTL_02'                          --ETL任务名称
      ,to_date('${batch_date}','yyyymmdd')              --数据日期
--    ,''                          --
--    ,'0'                         --
--    ,''                          --
--    ,''                          --
--    ,''                          --外部科目编号
--    ,''                          --红蓝字标志
--    ,''                          --银行编号
--    ,''                          --银团编号
--    ,''                          --我行出资比例
      ,'05'                        --任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                          --任务处理时间
     FROM ${iol_schema}.MPCS_A08TQUERYMSG T1--
LEFT JOIN ${iol_schema}.MPCS_A08TBANKINFO T2--
       ON T1.RCVBRN = T2.BKCD
AND T2.START_DT <= to_date('${batch_date}','yyyymmdd')
AND T2.END_DT > to_date('${batch_date}','yyyymmdd')
LEFT JOIN ${iol_schema}.MPCS_A08TBANKINFO T3--
       ON T1.SNDBRN = T3.BKCD
AND T3.START_DT <= to_date('${batch_date}','yyyymmdd')
AND T3.END_DT > to_date('${batch_date}','yyyymmdd')
    WHERE T1.QUERYDT = '${batch_date}';

commit;


whenever sqlerror exit sql.sqlcode;
--第六组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --大小额查复书登记簿
insert /*+ append(6) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id                       -- 事件编号       
   ,global_chn_seq_num           -- 全局渠道流水号    
   ,prev_global_chn_seq_num      -- 上一全局渠道流水号  
   ,prev_evt_id                  -- 上一事件编号     
   ,evt_typ_cd                   -- 事件类型代码     
   ,menuid                       -- 柜面菜单码      
   ,txn_num                      -- 交易码        
   ,txn_desc                     -- 交易描述       
   ,txn_dt                       -- 交易日期       
   ,txn_tm                       -- 交易时间       
   ,txn_ccy_cd                   -- 交易币种代码     
   ,txn_amt                      -- 交易金额       
   ,acct_bal                     -- 账户余额       
   ,cost_typ_cd                  -- 费用类型代码     
   ,fee_amt                      -- 手续费金额      
   ,evt_status_cd                -- 事件状态代码     
   ,evt_reverse_typ_cd           -- 事件冲正类型代码   
   ,agt_id                       -- 协议编号       
   ,agt_id_name                  -- 协议全称       
   ,agt_blng_acct_num            -- 协议所属账号     
   ,prd_id                       -- 产品编号       
   ,pty_id                       -- 客户编号       
   ,txn_org_id                   -- 交易机构编号     
   ,txn_teller_id                -- 交易柜员编号     
   ,chk_teller_id                -- 复核柜员编号     
   ,auth_teller_id               -- 授权柜员编号     
   ,pty_mgr_id                   -- 客户经理编号     
   ,chn_typ_cd                   -- 渠道类型代码     
   ,chn_id                       -- 渠道编号       
   ,pay_chnl_typ_cd              -- 支付通道类型代码   
   ,cntrpty_id                   -- 交易对手编号     
   ,cntrpty_name                 -- 交易对手名称     
   ,cntrpty_acct_openbk_num      -- 交易对手账户开户行号 
   ,cntrpty_acct_openbk_name     -- 交易对手账户开户行名称
   ,cntrpty_acct_num_id          -- 交易对手账号ID   
   ,cntrpty_acct_num             -- 交易对手账号     
   ,cntrpty_org_id               -- 交易对手机构编号   
   ,cntrpty_org_name             -- 交易对手机构名称   
   ,posting_dt                   -- 入账日期       
   ,posting_tm                   -- 入账时间       
   ,posting_org_id               -- 入账机构编号     
   ,posting_teller_id            -- 入账柜员编号     
   ,posting_ccy_cd               -- 入账币种代码     
   ,posting_amt                  -- 入账金额       
   ,memo_cd                      -- 摘要码        
   ,memo                         -- 摘要         
   ,db_cr_dir_cd                 -- 借贷标志       
   ,city_flg                     -- 同城标志       
   ,crossb_flg                   -- 跨行标志       
   ,ovsea_flg                    -- 境外标志       
   ,cash_tfr_flg                 -- 现转标志       
   ,initor_typ_cd                -- 发起方类型代码    
   ,prim_vchr_type_cd            -- 主凭证种类代码    
   ,prim_vchr_num                -- 主凭证号码      
   ,scd_vchr_type_cd             -- 副凭证种类代码    
   ,scd_vchr_num                 -- 副凭证号码      
   ,assoc_bcs_evt_id             -- 关联核心系统事件编号 
   ,reverse_evt_id               -- 冲正事件编号     
   ,flow_id                      -- 流程编号       
   ,assoc_coll_id                -- 关联抵质押品编号   
   ,nostro_flg                   -- 往账标志       
   ,bal_dir_cd                   -- 余额方向代码     
   ,bal_typ_cd                   -- 余额类型代码     
   ,txn_med_name                 -- 交易介质名称     
   ,txn_med_id                   -- 交易介质编号     
   ,biz_typ_cd                   -- 业务类型代码     
   ,biz_cate_cd                  -- 业务种类代码     
   ,ghb_init_flg                 -- 本行发起标志     
   ,old_vchr_num                 -- 旧凭证号码      
   ,agt_blng_acct_num2           -- 协议所属账号2    
   ,agt_blng_acct_num3           -- 协议所属账号3    
   ,data_src_cd                  -- 数据来源代码     
   ,etl_dt                       -- 数据日期       
   ,job_cd                       -- 任务代码       
   ,etl_timestamp                -- 任务处理时间     
)
select 'L102'||T1.REPLYSEQ||T1.REPLYDT||T1.SNDBRN||T1.TRANSTYPE||T1.MSGSRC                          --业务系统事件编号
      ,''                          --全局渠道流水号
      ,''                          --上一全局渠道流水号
      ,T1.OLDQUERYSEQ                          --上一事件编号
      ,'L102'                          --事件类型代码
      ,''                          --柜面菜单码
      ,case when T1.MSGSRC = '0' then
               case when T1.Transtype = '3' then  'A08Q06' else 'A08Q13' end
           when T1.MSGSRC = '1' then  'A18315'
      end                          --交易码
      ,case when T1.TRANSTYPE = '1' then  '大额业务查复书'
     when T1.TRANSTYPE = '2' then  '小额业务查复书'
     when T1.TRANSTYPE = '3' then  '行内查复书' 
end                          --交易描述
      ,TO_DATE(T1.REPLYDT,'YYYY-MM-DD')                          --交易日期
      ,case when T1.msgsrc = '0' then
          case when nvl(T1.snddt,'0') = '0' then '' else substr(T1.snddt,9,2)||':'||substr(T1.snddt,11,2)||':'||substr(T1.snddt,13,2) end
     else 
          case when nvl(T1.rcvdt,'0') = '0' then '' else substr(T1.rcvdt,9,2)||':'||substr(T1.rcvdt,11,2)||':'||substr(T1.rcvdt,13,2)  end 
end                          --交易时间
      ,'CNY'                          --交易币种代码
      ,''                          --交易金额
      ,''                          --账户余额
      ,''                          --费用类型代码
      ,''                          --费用金额
      ,CASE WHEN T1.STATUS = 'Z0' THEN '0'
     WHEN T1.STATUS IN ('01','02','03') THEN '1'
     ELSE '9'
END                          --事件状态代码
      ,''                          --事件冲正类型代码
      ,''                          --协议编号
      ,''                          --协议全称
      ,''                          --协议所属账号
      ,case when T1.TRANSTYPE = '1' then  'HVPS'
     when T1.TRANSTYPE = '2' then  'BEPS'
     when T1.TRANSTYPE = '3' then  'CNAPS'
end                          --产品编号
      ,''                          --客户编号
      ,T1.MAGEBRN                          --交易机构编号
      ,T1.OPRTLR                          --交易柜员编号
      ,''                          --复核柜员编号
      ,''                          --授权柜员编号
      ,''                          --客户经理编号
      ,case when T1.TRANSTYPE = '1' then '2201'
     when T1.TRANSTYPE = '2' then '2201'
     when T1.TRANSTYPE = '3' then '9999' 
end                          --渠道类型代码
      ,case when T1.TRANSTYPE = '1' then  'HVPS'
     when T1.TRANSTYPE = '2' then  'BEPS'
     when T1.TRANSTYPE = '3' then  'CNAPS'
end                          --渠道编号
      ,''                          --支付通道类型代码
      ,''                          --交易对手客户编号
      ,''                          --交易对手名称
      ,case when T1.MSGSRC = '0' then T1.RCVBRN
     when T1.MSGSRC = '1' then T1.SNDBRN 
end                          --交易对手账户开户行号
      ,case when T1.MSGSRC = '0' then T2.BKNAME
     ELSE T3.BKNAME 
end                          --交易对手账户开户行名称
      ,''                          --交易对手账号ID
      ,''                          --交易对手账号
      ,''                          --交易对手机构编号
      ,''                          --交易对手机构名称
      ,''                          --入账日期
      ,''                          --入账时间
      ,''                          --入账机构编号
      ,''                          --入账柜员编号
      ,''                          --入账币种代码
      ,''                          --入账金额
      ,''                          --摘要码
      ,''                          --摘要
      ,''                          --借贷标志
      ,''                          --同城标志
      ,''                          --跨行标志
      ,''                          --境外标志
      ,''                          --现转标志
      ,''                          --发起方类型代码
      ,''                          --主凭证种类代码
      ,''                          --主凭证号码
      ,''                          --副凭证种类代码
      ,''                          --副凭证号码
      ,''                          --关联核心系统事件编号
      ,''                          --冲正事件编号
      ,''                          --流程编号
      ,''                          --关联抵质押品编号
      ,case when T1.MSGSRC = '0' then '1'
     when T1.MSGSRC = '1' then '0' 
     else '1'
end                          --往账标志
      ,''                          --余额方向代码
      ,''                          --余额类型代码
      ,''                          --交易介质名称
      ,''                          --交易介质编号
      ,''                          --业务类型代码
      ,''                          --业务种类代码
      ,case when T1.MSGSRC = '0' then '1'
     when T1.MSGSRC = '1' then '0'
     else '1'
end                          --本行发起标志
      ,''                          --旧凭证号码
      ,''                          --协议所属账号2
      ,''                          --协议所属账号3
      ,'MPCS'                          --数据来源代码
    --  ,'EVT_MPCS_EVENT_DTL_02'                          --ETL任务名称
      ,to_date('${batch_date}','yyyymmdd')                          --数据日期
    --  ,''                          --
    --  ,'0'                          --
    --  ,''                          --
    --  ,''                          --
    --  ,''                          --外部科目编号
    --  ,''                          --红蓝字标志
    --  ,''                          --银行编号
    --  ,''                          --银团编号
    --  ,''                          --我行出资比例
      ,'06'                           --任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                          --任务处理时间
     FROM ${iol_schema}.MPCS_A08TREPLYMSG T1--
LEFT JOIN ${iol_schema}.MPCS_A08TBANKINFO T2--
       ON T1.RCVBRN = T2.BKCD
AND T2.START_DT <= to_date('${batch_date}','yyyymmdd')
AND T2.END_DT > to_date('${batch_date}','yyyymmdd')
LEFT JOIN ${iol_schema}.MPCS_A08TBANKINFO T3--
       ON T1.SNDBRN = T3.BKCD
AND T3.START_DT <= to_date('${batch_date}','yyyymmdd')
AND T3.END_DT > to_date('${batch_date}','yyyymmdd')
    WHERE T1.REPLYDT = '${batch_date}';

commit;


whenever sqlerror exit sql.sqlcode;
--第七组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --大小额自由格式
insert /*+ append(7) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id                       -- 事件编号       
   ,global_chn_seq_num           -- 全局渠道流水号    
   ,prev_global_chn_seq_num      -- 上一全局渠道流水号  
   ,prev_evt_id                  -- 上一事件编号     
   ,evt_typ_cd                   -- 事件类型代码     
   ,menuid                       -- 柜面菜单码      
   ,txn_num                      -- 交易码        
   ,txn_desc                     -- 交易描述       
   ,txn_dt                       -- 交易日期       
   ,txn_tm                       -- 交易时间       
   ,txn_ccy_cd                   -- 交易币种代码     
   ,txn_amt                      -- 交易金额       
   ,acct_bal                     -- 账户余额       
   ,cost_typ_cd                  -- 费用类型代码     
   ,fee_amt                      -- 手续费金额      
   ,evt_status_cd                -- 事件状态代码     
   ,evt_reverse_typ_cd           -- 事件冲正类型代码   
   ,agt_id                       -- 协议编号       
   ,agt_id_name                  -- 协议全称       
   ,agt_blng_acct_num            -- 协议所属账号     
   ,prd_id                       -- 产品编号       
   ,pty_id                       -- 客户编号       
   ,txn_org_id                   -- 交易机构编号     
   ,txn_teller_id                -- 交易柜员编号     
   ,chk_teller_id                -- 复核柜员编号     
   ,auth_teller_id               -- 授权柜员编号     
   ,pty_mgr_id                   -- 客户经理编号     
   ,chn_typ_cd                   -- 渠道类型代码     
   ,chn_id                       -- 渠道编号       
   ,pay_chnl_typ_cd              -- 支付通道类型代码   
   ,cntrpty_id                   -- 交易对手编号     
   ,cntrpty_name                 -- 交易对手名称     
   ,cntrpty_acct_openbk_num      -- 交易对手账户开户行号 
   ,cntrpty_acct_openbk_name     -- 交易对手账户开户行名称
   ,cntrpty_acct_num_id          -- 交易对手账号ID   
   ,cntrpty_acct_num             -- 交易对手账号     
   ,cntrpty_org_id               -- 交易对手机构编号   
   ,cntrpty_org_name             -- 交易对手机构名称   
   ,posting_dt                   -- 入账日期       
   ,posting_tm                   -- 入账时间       
   ,posting_org_id               -- 入账机构编号     
   ,posting_teller_id            -- 入账柜员编号     
   ,posting_ccy_cd               -- 入账币种代码     
   ,posting_amt                  -- 入账金额       
   ,memo_cd                      -- 摘要码        
   ,memo                         -- 摘要         
   ,db_cr_dir_cd                 -- 借贷标志       
   ,city_flg                     -- 同城标志       
   ,crossb_flg                   -- 跨行标志       
   ,ovsea_flg                    -- 境外标志       
   ,cash_tfr_flg                 -- 现转标志       
   ,initor_typ_cd                -- 发起方类型代码    
   ,prim_vchr_type_cd            -- 主凭证种类代码    
   ,prim_vchr_num                -- 主凭证号码      
   ,scd_vchr_type_cd             -- 副凭证种类代码    
   ,scd_vchr_num                 -- 副凭证号码      
   ,assoc_bcs_evt_id             -- 关联核心系统事件编号 
   ,reverse_evt_id               -- 冲正事件编号     
   ,flow_id                      -- 流程编号       
   ,assoc_coll_id                -- 关联抵质押品编号   
   ,nostro_flg                   -- 往账标志       
   ,bal_dir_cd                   -- 余额方向代码     
   ,bal_typ_cd                   -- 余额类型代码     
   ,txn_med_name                 -- 交易介质名称     
   ,txn_med_id                   -- 交易介质编号     
   ,biz_typ_cd                   -- 业务类型代码     
   ,biz_cate_cd                  -- 业务种类代码     
   ,ghb_init_flg                 -- 本行发起标志     
   ,old_vchr_num                 -- 旧凭证号码      
   ,agt_blng_acct_num2           -- 协议所属账号2    
   ,agt_blng_acct_num3           -- 协议所属账号3    
   ,data_src_cd                  -- 数据来源代码     
   ,etl_dt                       -- 数据日期       
   ,job_cd                       -- 任务代码       
   ,etl_timestamp                -- 任务处理时间     
)
select 'L103'||T1.MSGSEQ||T1.CONSIGNDT||T1.SNDBRN||T1.TRANSTYPE||T1.MSGSRC                          --业务系统事件编号
      ,''                          --全局渠道流水号
      ,''                          --上一全局渠道流水号
      ,''                          --上一事件编号
      ,'L103'                          --事件类型代码
      ,''                          --柜面菜单码
      ,'A08M03'                          --交易码
      ,'自由格式报文'                          --交易描述
      ,TO_DATE(T1.CONSIGNDT,'YYYY-MM-DD')                          --交易日期
      ,''                          --交易时间
      ,'CNY'                          --交易币种代码
      ,''                          --交易金额
      ,''                          --账户余额
      ,''                          --费用类型代码
      ,''                          --费用金额
      ,CASE WHEN T1.STATUS = '2' THEN '2'
     WHEN T1.STATUS IN ('1','3','6'，'06') THEN '1'
     ELSE '9'
END                          --事件状态代码
      ,''                          --事件冲正类型代码
      ,''                          --协议编号
      ,''                          --协议全称
      ,''                          --协议所属账号
      ,case when T1.TRANSTYPE = '1' then  'HVPS'
     when T1.TRANSTYPE = '2' then  'BEPS'
     when T1.TRANSTYPE = '3' then  'CNAPS'
end                          --产品编号
      ,''                          --客户编号
      ,T1.MAGEBRN                          --交易机构编号
      ,T1.SNDTLR                          --交易柜员编号
      ,''                          --复核柜员编号
      ,''                          --授权柜员编号
      ,''                          --客户经理编号
      ,''                          --渠道类型代码
      ,''                          --渠道编号
      ,case when T1.TRANSTYPE = '1' then  '04'
     when T1.TRANSTYPE = '2' then  '03'
end                          --支付通道类型代码
      ,''                          --交易对手客户编号
      ,''                          --交易对手名称
      ,''                          --交易对手账户开户行号
      ,''                          --交易对手账户开户行名称
      ,''                          --交易对手账号ID
      ,''                          --交易对手账号
      ,''                          --交易对手机构编号
      ,''                          --交易对手机构名称
      ,''                          --入账日期
      ,''                          --入账时间
      ,''                          --入账机构编号
      ,''                          --入账柜员编号
      ,''                          --入账币种代码
      ,''                          --入账金额
      ,''                          --摘要码
      ,''                          --摘要
      ,''                          --借贷标志
      ,''                          --同城标志
      ,''                          --跨行标志
      ,''                          --境外标志
      ,''                          --现转标志
      ,''                          --发起方类型代码
      ,''                          --主凭证种类代码
      ,''                          --主凭证号码
      ,''                          --副凭证种类代码
      ,''                          --副凭证号码
      ,''                          --关联核心系统事件编号
      ,''                          --冲正事件编号
      ,''                          --流程编号
      ,''                          --关联抵质押品编号
      ,''                          --往账标志
      ,''                          --余额方向代码
      ,''                          --余额类型代码
      ,''                          --交易介质名称
      ,''                          --交易介质编号
      ,''                          --业务类型代码
      ,''                          --业务种类代码
      ,case when T1.MSGSRC = '0' then '1'
     when T1.MSGSRC = '1' then '0'
     else '1'
end                          --本行发起标志
      ,''                          --旧凭证号码
      ,''                          --协议所属账号2
      ,''                          --协议所属账号3
      ,'MPCS'                          --数据来源代码
--      ,'EVT_MPCS_EVENT_DTL_02'                          --ETL任务名称
      ,to_date('${batch_date}','yyyymmdd')                          --数据日期
--      ,''                          --
--      ,'0'                          --
--      ,''                          --
--      ,''                          --
--      ,''                          --外部科目编号
--      ,''                          --红蓝字标志
--      ,''                          --银行编号
--      ,''                          --银团编号
--      ,''                          --我行出资比例
      ,'07'                           --任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                          --任务处理时间
     FROM ${iol_schema}.MPCS_A08TFREEMSG T1--
    WHERE T1.CONSIGNDT = '${batch_date}'
AND T1.MSGSRC = '0';

commit;


whenever sqlerror exit sql.sqlcode;
--第八组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --大小额退回申请登记簿
insert /*+ append(8) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id                       -- 事件编号       
   ,global_chn_seq_num           -- 全局渠道流水号    
   ,prev_global_chn_seq_num      -- 上一全局渠道流水号  
   ,prev_evt_id                  -- 上一事件编号     
   ,evt_typ_cd                   -- 事件类型代码     
   ,menuid                       -- 柜面菜单码      
   ,txn_num                      -- 交易码        
   ,txn_desc                     -- 交易描述       
   ,txn_dt                       -- 交易日期       
   ,txn_tm                       -- 交易时间       
   ,txn_ccy_cd                   -- 交易币种代码     
   ,txn_amt                      -- 交易金额       
   ,acct_bal                     -- 账户余额       
   ,cost_typ_cd                  -- 费用类型代码     
   ,fee_amt                      -- 手续费金额      
   ,evt_status_cd                -- 事件状态代码     
   ,evt_reverse_typ_cd           -- 事件冲正类型代码   
   ,agt_id                       -- 协议编号       
   ,agt_id_name                  -- 协议全称       
   ,agt_blng_acct_num            -- 协议所属账号     
   ,prd_id                       -- 产品编号       
   ,pty_id                       -- 客户编号       
   ,txn_org_id                   -- 交易机构编号     
   ,txn_teller_id                -- 交易柜员编号     
   ,chk_teller_id                -- 复核柜员编号     
   ,auth_teller_id               -- 授权柜员编号     
   ,pty_mgr_id                   -- 客户经理编号     
   ,chn_typ_cd                   -- 渠道类型代码     
   ,chn_id                       -- 渠道编号       
   ,pay_chnl_typ_cd              -- 支付通道类型代码   
   ,cntrpty_id                   -- 交易对手编号     
   ,cntrpty_name                 -- 交易对手名称     
   ,cntrpty_acct_openbk_num      -- 交易对手账户开户行号 
   ,cntrpty_acct_openbk_name     -- 交易对手账户开户行名称
   ,cntrpty_acct_num_id          -- 交易对手账号ID   
   ,cntrpty_acct_num             -- 交易对手账号     
   ,cntrpty_org_id               -- 交易对手机构编号   
   ,cntrpty_org_name             -- 交易对手机构名称   
   ,posting_dt                   -- 入账日期       
   ,posting_tm                   -- 入账时间       
   ,posting_org_id               -- 入账机构编号     
   ,posting_teller_id            -- 入账柜员编号     
   ,posting_ccy_cd               -- 入账币种代码     
   ,posting_amt                  -- 入账金额       
   ,memo_cd                      -- 摘要码        
   ,memo                         -- 摘要         
   ,db_cr_dir_cd                 -- 借贷标志       
   ,city_flg                     -- 同城标志       
   ,crossb_flg                   -- 跨行标志       
   ,ovsea_flg                    -- 境外标志       
   ,cash_tfr_flg                 -- 现转标志       
   ,initor_typ_cd                -- 发起方类型代码    
   ,prim_vchr_type_cd            -- 主凭证种类代码    
   ,prim_vchr_num                -- 主凭证号码      
   ,scd_vchr_type_cd             -- 副凭证种类代码    
   ,scd_vchr_num                 -- 副凭证号码      
   ,assoc_bcs_evt_id             -- 关联核心系统事件编号 
   ,reverse_evt_id               -- 冲正事件编号     
   ,flow_id                      -- 流程编号       
   ,assoc_coll_id                -- 关联抵质押品编号   
   ,nostro_flg                   -- 往账标志       
   ,bal_dir_cd                   -- 余额方向代码     
   ,bal_typ_cd                   -- 余额类型代码     
   ,txn_med_name                 -- 交易介质名称     
   ,txn_med_id                   -- 交易介质编号     
   ,biz_typ_cd                   -- 业务类型代码     
   ,biz_cate_cd                  -- 业务种类代码     
   ,ghb_init_flg                 -- 本行发起标志     
   ,old_vchr_num                 -- 旧凭证号码      
   ,agt_blng_acct_num2           -- 协议所属账号2    
   ,agt_blng_acct_num3           -- 协议所属账号3    
   ,data_src_cd                  -- 数据来源代码     
   ,etl_dt                       -- 数据日期       
   ,job_cd                       -- 任务代码       
   ,etl_timestamp                -- 任务处理时间     
)
select 'L107'||T1.RQSEQ||T1.CONSIGNDT||T1.SNDBRN||T1.OLDTRANSTYPE                          --业务系统事件编号
      ,''                          --全局渠道流水号
      ,''                          --上一全局渠道流水号
      ,''                          --上一事件编号
      ,'L107'                          --事件类型代码
      ,''                          --柜面菜单码
      ,case when T1.OLDTRANSTYPE = '1' then 'A08F01'
     when T1.OLDTRANSTYPE = '2' then 'A06M06'
     else  'A08F01' 
end                          --交易码
      ,case when T1.OLDTRANSTYPE = '1' then '大额退回申请'
     when T1.OLDTRANSTYPE = '2' then '小额退回申请'
end                          --交易描述
      ,TO_DATE(T1.CONSIGNDT,'YYYY-MM-DD')                          --交易日期
      ,''                          --交易时间
      ,'CNY'                          --交易币种代码
      ,''                          --交易金额
      ,''                          --账户余额
      ,''                          --费用类型代码
      ,''                          --费用金额
      ,CASE WHEN T1.STATUS = '05' THEN '2'
     WHEN T1.STATUS = '08' THEN '1'
     ELSE '9'
END                          --事件状态代码
      ,''                          --事件冲正类型代码
      ,''                          --协议编号
      ,''                          --协议全称
      ,''                          --协议所属账号
      ,'CNAPS'                          --产品编号
      ,''                          --客户编号
      ,T1.magbrn                          --交易机构编号
      ,T1.SNDTLR                          --交易柜员编号
      ,''                          --复核柜员编号
      ,''                          --授权柜员编号
      ,''                          --客户经理编号
      ,''                          --渠道类型代码
      ,''                          --渠道编号
      ,''                          --支付通道类型代码
      ,''                          --交易对手客户编号
      ,''                          --交易对手名称
      ,''                          --交易对手账户开户行号
      ,''                          --交易对手账户开户行名称
      ,''                          --交易对手账号ID
      ,''                          --交易对手账号
      ,''                          --交易对手机构编号
      ,''                          --交易对手机构名称
      ,''                          --入账日期
      ,''                          --入账时间
      ,''                          --入账机构编号
      ,''                          --入账柜员编号
      ,''                          --入账币种代码
      ,''                          --入账金额
      ,''                          --摘要码
      ,''                          --摘要
      ,''                          --借贷标志
      ,''                          --同城标志
      ,''                          --跨行标志
      ,''                          --境外标志
      ,''                          --现转标志
      ,''                          --发起方类型代码
      ,''                          --主凭证种类代码
      ,''                          --主凭证号码
      ,''                          --副凭证种类代码
      ,''                          --副凭证号码
      ,''                          --关联核心系统事件编号
      ,''                          --冲正事件编号
      ,''                          --流程编号
      ,''                          --关联抵质押品编号
      ,''                          --往账标志
      ,''                          --余额方向代码
      ,''                          --余额类型代码
      ,''                          --交易介质名称
      ,''                          --交易介质编号
      ,''                          --业务类型代码
      ,''                          --业务种类代码
      ,''                          --本行发起标志
      ,''                          --旧凭证号码
      ,''                          --协议所属账号2
      ,''                          --协议所属账号3
      ,'MPCS'                          --数据来源代码
--      ,'EVT_MPCS_EVENT_DTL_02'                          --ETL任务名称
      ,to_date('${batch_date}','yyyymmdd')                          --数据日期
--      ,''                          --
--      ,'0'                          --
--      ,''                          --
--      ,''                          --
--      ,''                          --外部科目编号
--      ,''                          --红蓝字标志
--      ,''                          --银行编号
--      ,''                          --银团编号
--      ,''                          --我行出资比例
      ,'08'                           --任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                          --任务处理时间
     FROM ${iol_schema}.MPCS_A08TRTNAPPLY T1--
    WHERE T1.CONSIGNDT = '${batch_date}';

commit;


whenever sqlerror exit sql.sqlcode;
--第九组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --大小额查复书登记簿
insert /*+ append(9) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id                       -- 事件编号       
   ,global_chn_seq_num           -- 全局渠道流水号    
   ,prev_global_chn_seq_num      -- 上一全局渠道流水号  
   ,prev_evt_id                  -- 上一事件编号     
   ,evt_typ_cd                   -- 事件类型代码     
   ,menuid                       -- 柜面菜单码      
   ,txn_num                      -- 交易码        
   ,txn_desc                     -- 交易描述       
   ,txn_dt                       -- 交易日期       
   ,txn_tm                       -- 交易时间       
   ,txn_ccy_cd                   -- 交易币种代码     
   ,txn_amt                      -- 交易金额       
   ,acct_bal                     -- 账户余额       
   ,cost_typ_cd                  -- 费用类型代码     
   ,fee_amt                      -- 手续费金额      
   ,evt_status_cd                -- 事件状态代码     
   ,evt_reverse_typ_cd           -- 事件冲正类型代码   
   ,agt_id                       -- 协议编号       
   ,agt_id_name                  -- 协议全称       
   ,agt_blng_acct_num            -- 协议所属账号     
   ,prd_id                       -- 产品编号       
   ,pty_id                       -- 客户编号       
   ,txn_org_id                   -- 交易机构编号     
   ,txn_teller_id                -- 交易柜员编号     
   ,chk_teller_id                -- 复核柜员编号     
   ,auth_teller_id               -- 授权柜员编号     
   ,pty_mgr_id                   -- 客户经理编号     
   ,chn_typ_cd                   -- 渠道类型代码     
   ,chn_id                       -- 渠道编号       
   ,pay_chnl_typ_cd              -- 支付通道类型代码   
   ,cntrpty_id                   -- 交易对手编号     
   ,cntrpty_name                 -- 交易对手名称     
   ,cntrpty_acct_openbk_num      -- 交易对手账户开户行号 
   ,cntrpty_acct_openbk_name     -- 交易对手账户开户行名称
   ,cntrpty_acct_num_id          -- 交易对手账号ID   
   ,cntrpty_acct_num             -- 交易对手账号     
   ,cntrpty_org_id               -- 交易对手机构编号   
   ,cntrpty_org_name             -- 交易对手机构名称   
   ,posting_dt                   -- 入账日期       
   ,posting_tm                   -- 入账时间       
   ,posting_org_id               -- 入账机构编号     
   ,posting_teller_id            -- 入账柜员编号     
   ,posting_ccy_cd               -- 入账币种代码     
   ,posting_amt                  -- 入账金额       
   ,memo_cd                      -- 摘要码        
   ,memo                         -- 摘要         
   ,db_cr_dir_cd                 -- 借贷标志       
   ,city_flg                     -- 同城标志       
   ,crossb_flg                   -- 跨行标志       
   ,ovsea_flg                    -- 境外标志       
   ,cash_tfr_flg                 -- 现转标志       
   ,initor_typ_cd                -- 发起方类型代码    
   ,prim_vchr_type_cd            -- 主凭证种类代码    
   ,prim_vchr_num                -- 主凭证号码      
   ,scd_vchr_type_cd             -- 副凭证种类代码    
   ,scd_vchr_num                 -- 副凭证号码      
   ,assoc_bcs_evt_id             -- 关联核心系统事件编号 
   ,reverse_evt_id               -- 冲正事件编号     
   ,flow_id                      -- 流程编号       
   ,assoc_coll_id                -- 关联抵质押品编号   
   ,nostro_flg                   -- 往账标志       
   ,bal_dir_cd                   -- 余额方向代码     
   ,bal_typ_cd                   -- 余额类型代码     
   ,txn_med_name                 -- 交易介质名称     
   ,txn_med_id                   -- 交易介质编号     
   ,biz_typ_cd                   -- 业务类型代码     
   ,biz_cate_cd                  -- 业务种类代码     
   ,ghb_init_flg                 -- 本行发起标志     
   ,old_vchr_num                 -- 旧凭证号码      
   ,agt_blng_acct_num2           -- 协议所属账号2    
   ,agt_blng_acct_num3           -- 协议所属账号3    
   ,data_src_cd                  -- 数据来源代码     
   ,etl_dt                       -- 数据日期       
   ,job_cd                       -- 任务代码       
   ,etl_timestamp                -- 任务处理时间     
)
select 'L104'||T1.CNTRNO                          --业务系统事件编号
      ,''                          --全局渠道流水号
      ,''                          --上一全局渠道流水号
      ,''                          --上一事件编号
      ,'L104'                          --事件类型代码
      ,''                          --柜面菜单码
      ,'A06M03'                          --交易码
      ,'定期借贷记签约'                          --交易描述
      ,TO_DATE(T1.SIGNDT,'YYYY-MM-DD')                          --交易日期
      ,''                          --交易时间
      ,'CNY'                          --交易币种代码
      ,''                          --交易金额
      ,''                          --账户余额
      ,''                          --费用类型代码
      ,''                          --费用金额
      ,CASE WHEN T1.CNTRST = '0' THEN '1'
     WHEN T1.CNTRST = '1' THEN '2'
     ELSE '9'
END                          --事件状态代码
      ,''                          --事件冲正类型代码
      ,T1.PYERAC                          --协议编号
      ,T1.PYERNA                          --协议全称
      ,''                          --协议所属账号
      ,'CNAPS'                          --产品编号
      ,''                          --客户编号
      ,T1.BRCHNO                          --交易机构编号
      ,T1.USERID                          --交易柜员编号
      ,''                          --复核柜员编号
      ,''                          --授权柜员编号
      ,''                          --客户经理编号
      ,''                          --渠道类型代码
      ,''                          --渠道编号
      ,''                          --支付通道类型代码
      ,''                          --交易对手客户编号
      ,T1.RECVNA                          --交易对手名称
      ,T1.RECVBK                          --交易对手账户开户行号
      ,''                          --交易对手账户开户行名称
      ,''                          --交易对手账号ID
      ,T1.RECVAC                          --交易对手账号
      ,''                          --交易对手机构编号
      ,''                          --交易对手机构名称
      ,''                          --入账日期
      ,''                          --入账时间
      ,''                          --入账机构编号
      ,''                          --入账柜员编号
      ,''                          --入账币种代码
      ,''                          --入账金额
      ,''                          --摘要码
      ,''                          --摘要
      ,CASE WHEN T1.CNTRTP = '1' THEN 'C' 
     WHEN T1.CNTRTP = '0' THEN 'D' 
END                          --借贷标志
      ,''                          --同城标志
      ,''                          --跨行标志
      ,''                          --境外标志
      ,''                          --现转标志
      ,''                          --发起方类型代码
      ,''                          --主凭证种类代码
      ,''                          --主凭证号码
      ,''                          --副凭证种类代码
      ,''                          --副凭证号码
      ,''                          --关联核心系统事件编号
      ,''                          --冲正事件编号
      ,''                          --流程编号
      ,''                          --关联抵质押品编号
      ,T1.IOTYPE                          --往账标志
      ,''                          --余额方向代码
      ,''                          --余额类型代码
      ,''                          --交易介质名称
      ,''                          --交易介质编号
      ,''                          --业务类型代码
      ,''                          --业务种类代码
      ,''                          --本行发起标志
      ,''                          --旧凭证号码
      ,''                          --协议所属账号2
      ,''                          --协议所属账号3
      ,'MPCS'                          --数据来源代码
--      ,'EVT_MPCS_EVENT_DTL_02'                          --ETL任务名称
      ,to_date('${batch_date}','yyyymmdd')                          --数据日期
--      ,''                          --
--      ,'0'                          --
--      ,''                          --
--      ,''                          --
--      ,''                          --外部科目编号
--      ,''                          --红蓝字标志
--      ,''                          --银行编号
--      ,''                          --银团编号
--      ,''                          --我行出资比例
      ,'09'                           --任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                          --任务处理时间
     FROM ${iol_schema}.MPCS_A08TBEFIXSIGN T1--
    WHERE T1.SIGNDT = '${batch_date}'
AND T1.START_DT <= to_date('${batch_date}','yyyymmdd')
AND T1.END_DT > to_date('${batch_date}','yyyymmdd');

commit;


whenever sqlerror exit sql.sqlcode;
--第十组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --小额定期往帐批次登记表
insert /*+ append(10) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id                       -- 事件编号       
   ,global_chn_seq_num           -- 全局渠道流水号    
   ,prev_global_chn_seq_num      -- 上一全局渠道流水号  
   ,prev_evt_id                  -- 上一事件编号     
   ,evt_typ_cd                   -- 事件类型代码     
   ,menuid                       -- 柜面菜单码      
   ,txn_num                      -- 交易码        
   ,txn_desc                     -- 交易描述       
   ,txn_dt                       -- 交易日期       
   ,txn_tm                       -- 交易时间       
   ,txn_ccy_cd                   -- 交易币种代码     
   ,txn_amt                      -- 交易金额       
   ,acct_bal                     -- 账户余额       
   ,cost_typ_cd                  -- 费用类型代码     
   ,fee_amt                      -- 手续费金额      
   ,evt_status_cd                -- 事件状态代码     
   ,evt_reverse_typ_cd           -- 事件冲正类型代码   
   ,agt_id                       -- 协议编号       
   ,agt_id_name                  -- 协议全称       
   ,agt_blng_acct_num            -- 协议所属账号     
   ,prd_id                       -- 产品编号       
   ,pty_id                       -- 客户编号       
   ,txn_org_id                   -- 交易机构编号     
   ,txn_teller_id                -- 交易柜员编号     
   ,chk_teller_id                -- 复核柜员编号     
   ,auth_teller_id               -- 授权柜员编号     
   ,pty_mgr_id                   -- 客户经理编号     
   ,chn_typ_cd                   -- 渠道类型代码     
   ,chn_id                       -- 渠道编号       
   ,pay_chnl_typ_cd              -- 支付通道类型代码   
   ,cntrpty_id                   -- 交易对手编号     
   ,cntrpty_name                 -- 交易对手名称     
   ,cntrpty_acct_openbk_num      -- 交易对手账户开户行号 
   ,cntrpty_acct_openbk_name     -- 交易对手账户开户行名称
   ,cntrpty_acct_num_id          -- 交易对手账号ID   
   ,cntrpty_acct_num             -- 交易对手账号     
   ,cntrpty_org_id               -- 交易对手机构编号   
   ,cntrpty_org_name             -- 交易对手机构名称   
   ,posting_dt                   -- 入账日期       
   ,posting_tm                   -- 入账时间       
   ,posting_org_id               -- 入账机构编号     
   ,posting_teller_id            -- 入账柜员编号     
   ,posting_ccy_cd               -- 入账币种代码     
   ,posting_amt                  -- 入账金额       
   ,memo_cd                      -- 摘要码        
   ,memo                         -- 摘要         
   ,db_cr_dir_cd                 -- 借贷标志       
   ,city_flg                     -- 同城标志       
   ,crossb_flg                   -- 跨行标志       
   ,ovsea_flg                    -- 境外标志       
   ,cash_tfr_flg                 -- 现转标志       
   ,initor_typ_cd                -- 发起方类型代码    
   ,prim_vchr_type_cd            -- 主凭证种类代码    
   ,prim_vchr_num                -- 主凭证号码      
   ,scd_vchr_type_cd             -- 副凭证种类代码    
   ,scd_vchr_num                 -- 副凭证号码      
   ,assoc_bcs_evt_id             -- 关联核心系统事件编号 
   ,reverse_evt_id               -- 冲正事件编号     
   ,flow_id                      -- 流程编号       
   ,assoc_coll_id                -- 关联抵质押品编号   
   ,nostro_flg                   -- 往账标志       
   ,bal_dir_cd                   -- 余额方向代码     
   ,bal_typ_cd                   -- 余额类型代码     
   ,txn_med_name                 -- 交易介质名称     
   ,txn_med_id                   -- 交易介质编号     
   ,biz_typ_cd                   -- 业务类型代码     
   ,biz_cate_cd                  -- 业务种类代码     
   ,ghb_init_flg                 -- 本行发起标志     
   ,old_vchr_num                 -- 旧凭证号码      
   ,agt_blng_acct_num2           -- 协议所属账号2    
   ,agt_blng_acct_num3           -- 协议所属账号3    
   ,data_src_cd                  -- 数据来源代码     
   ,etl_dt                       -- 数据日期       
   ,job_cd                       -- 任务代码       
   ,etl_timestamp                -- 任务处理时间     
)
select 'L105'||T1.DISKNO                          --业务系统事件编号
      ,''                          --全局渠道流水号
      ,''                          --上一全局渠道流水号
      ,''                          --上一事件编号
      ,'L105'                          --事件类型代码
      ,''                          --柜面菜单码
      ,case when substr(T1.PKTYPE, 6, 3) = '133' then 'A06F60'
     when substr(T1.PKTYPE, 6, 3) = '125' then 'A06F50'
end                          --交易码
      ,case when substr(T1.PKTYPE, 6, 3) = '133' then '定期借记导入'
     when substr(T1.PKTYPE, 6, 3) = '125' then '定期贷记导入'
end                          --交易描述
      ,TO_DATE(T1.TRANSDT,'YYYY-MM-DD')                          --交易日期
      ,''                          --交易时间
      ,'CNY'                          --交易币种代码
      ,''                          --交易金额
      ,''                          --账户余额
      ,''                          --费用类型代码
      ,''                          --费用金额
      ,CASE WHEN T1.STATUS = 'T' THEN '1'
     WHEN T1.STATUS = 'Z' THEN '2'
     ELSE '9'
END                          --事件状态代码
      ,''                          --事件冲正类型代码
      ,''                          --协议编号
      ,''                          --协议全称
      ,''                          --协议所属账号
      ,'BEPS'                          --产品编号
      ,''                          --客户编号
      ,T1.MAGBRN                          --交易机构编号
      ,T1.OPRTLR                          --交易柜员编号
      ,''                          --复核柜员编号
      ,T1.CHKTLR                          --授权柜员编号
      ,''                          --客户经理编号
      ,''                          --渠道类型代码
      ,''                          --渠道编号
      ,''                          --支付通道类型代码
      ,''                          --交易对手客户编号
      ,''                          --交易对手名称
      ,''                          --交易对手账户开户行号
      ,''                          --交易对手账户开户行名称
      ,''                          --交易对手账号ID
      ,''                          --交易对手账号
      ,''                          --交易对手机构编号
      ,''                          --交易对手机构名称
      ,''                          --入账日期
      ,''                          --入账时间
      ,''                          --入账机构编号
      ,''                          --入账柜员编号
      ,''                          --入账币种代码
      ,''                          --入账金额
      ,''                          --摘要码
      ,''                          --摘要
      ,''                          --借贷标志
      ,''                          --同城标志
      ,''                          --跨行标志
      ,''                          --境外标志
      ,''                          --现转标志
      ,''                          --发起方类型代码
      ,''                          --主凭证种类代码
      ,''                          --主凭证号码
      ,''                          --副凭证种类代码
      ,''                          --副凭证号码
      ,''                          --关联核心系统事件编号
      ,''                          --冲正事件编号
      ,''                          --流程编号
      ,''                          --关联抵质押品编号
      ,''                          --往账标志
      ,''                          --余额方向代码
      ,''                          --余额类型代码
      ,''                          --交易介质名称
      ,''                          --交易介质编号
      ,''                          --业务类型代码
      ,''                          --业务种类代码
      ,''                          --本行发起标志
      ,''                          --旧凭证号码
      ,''                          --协议所属账号2
      ,''                          --协议所属账号3
      ,'MPCS'                          --数据来源代码
--      ,'EVT_MPCS_EVENT_DTL_02'                          --ETL任务名称
      ,to_date('${batch_date}','yyyymmdd')                          --数据日期
--      ,''                          --
--      ,'0'                          --
--      ,''                          --
--      ,''                          --
--      ,''                          --外部科目编号
--      ,''                          --红蓝字标志
--      ,''                          --银行编号
--      ,''                          --银团编号
--      ,''                          --我行出资比例
      ,'10'                           --任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                          --任务处理时间
     FROM ${iol_schema}.MPCS_A08TBEDISKNO T1--
    WHERE T1.TRANSDT = '${batch_date}';

commit;


whenever sqlerror exit sql.sqlcode;
--第十一组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --小额止付申请登记簿
insert /*+ append(11) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id                       -- 事件编号       
   ,global_chn_seq_num           -- 全局渠道流水号    
   ,prev_global_chn_seq_num      -- 上一全局渠道流水号  
   ,prev_evt_id                  -- 上一事件编号     
   ,evt_typ_cd                   -- 事件类型代码     
   ,menuid                       -- 柜面菜单码      
   ,txn_num                      -- 交易码        
   ,txn_desc                     -- 交易描述       
   ,txn_dt                       -- 交易日期       
   ,txn_tm                       -- 交易时间       
   ,txn_ccy_cd                   -- 交易币种代码     
   ,txn_amt                      -- 交易金额       
   ,acct_bal                     -- 账户余额       
   ,cost_typ_cd                  -- 费用类型代码     
   ,fee_amt                      -- 手续费金额      
   ,evt_status_cd                -- 事件状态代码     
   ,evt_reverse_typ_cd           -- 事件冲正类型代码   
   ,agt_id                       -- 协议编号       
   ,agt_id_name                  -- 协议全称       
   ,agt_blng_acct_num            -- 协议所属账号     
   ,prd_id                       -- 产品编号       
   ,pty_id                       -- 客户编号       
   ,txn_org_id                   -- 交易机构编号     
   ,txn_teller_id                -- 交易柜员编号     
   ,chk_teller_id                -- 复核柜员编号     
   ,auth_teller_id               -- 授权柜员编号     
   ,pty_mgr_id                   -- 客户经理编号     
   ,chn_typ_cd                   -- 渠道类型代码     
   ,chn_id                       -- 渠道编号       
   ,pay_chnl_typ_cd              -- 支付通道类型代码   
   ,cntrpty_id                   -- 交易对手编号     
   ,cntrpty_name                 -- 交易对手名称     
   ,cntrpty_acct_openbk_num      -- 交易对手账户开户行号 
   ,cntrpty_acct_openbk_name     -- 交易对手账户开户行名称
   ,cntrpty_acct_num_id          -- 交易对手账号ID   
   ,cntrpty_acct_num             -- 交易对手账号     
   ,cntrpty_org_id               -- 交易对手机构编号   
   ,cntrpty_org_name             -- 交易对手机构名称   
   ,posting_dt                   -- 入账日期       
   ,posting_tm                   -- 入账时间       
   ,posting_org_id               -- 入账机构编号     
   ,posting_teller_id            -- 入账柜员编号     
   ,posting_ccy_cd               -- 入账币种代码     
   ,posting_amt                  -- 入账金额       
   ,memo_cd                      -- 摘要码        
   ,memo                         -- 摘要         
   ,db_cr_dir_cd                 -- 借贷标志       
   ,city_flg                     -- 同城标志       
   ,crossb_flg                   -- 跨行标志       
   ,ovsea_flg                    -- 境外标志       
   ,cash_tfr_flg                 -- 现转标志       
   ,initor_typ_cd                -- 发起方类型代码    
   ,prim_vchr_type_cd            -- 主凭证种类代码    
   ,prim_vchr_num                -- 主凭证号码      
   ,scd_vchr_type_cd             -- 副凭证种类代码    
   ,scd_vchr_num                 -- 副凭证号码      
   ,assoc_bcs_evt_id             -- 关联核心系统事件编号 
   ,reverse_evt_id               -- 冲正事件编号     
   ,flow_id                      -- 流程编号       
   ,assoc_coll_id                -- 关联抵质押品编号   
   ,nostro_flg                   -- 往账标志       
   ,bal_dir_cd                   -- 余额方向代码     
   ,bal_typ_cd                   -- 余额类型代码     
   ,txn_med_name                 -- 交易介质名称     
   ,txn_med_id                   -- 交易介质编号     
   ,biz_typ_cd                   -- 业务类型代码     
   ,biz_cate_cd                  -- 业务种类代码     
   ,ghb_init_flg                 -- 本行发起标志     
   ,old_vchr_num                 -- 旧凭证号码      
   ,agt_blng_acct_num2           -- 协议所属账号2    
   ,agt_blng_acct_num3           -- 协议所属账号3    
   ,data_src_cd                  -- 数据来源代码     
   ,etl_dt                       -- 数据日期       
   ,job_cd                       -- 任务代码       
   ,etl_timestamp                -- 任务处理时间     
)
select 'L106'||T1.STPYDT||T1.STBKNO||T1.STPYSQ                          --业务系统事件编号
      ,''                          --全局渠道流水号
      ,''                          --上一全局渠道流水号
      ,''                          --上一事件编号
      ,'L106'                          --事件类型代码
      ,''                          --柜面菜单码
      ,'A06M01'                          --交易码
      ,'小额止付申请'                          --交易描述
      ,TO_DATE(T1.SENDDT,'YYYY-MM-DD')                          --交易日期
      ,SUBSTR(T1.SENDTM, 9, 6)                          --交易时间
      ,'CNY'                          --交易币种代码
      ,''                          --交易金额
      ,''                          --账户余额
      ,''                          --费用类型代码
      ,''                          --费用金额
      ,CASE WHEN T1.RPLYST = '1' THEN '1'
     WHEN T1.RPLYST IN ('2','E') THEN '2'
     ELSE '9'
END                          --事件状态代码
      ,''                          --事件冲正类型代码
      ,''                          --协议编号
      ,''                          --协议全称
      ,''                          --协议所属账号
      ,'CNAPS'                          --产品编号
      ,''                          --客户编号
      ,T1.SDTLBR                          --交易机构编号
      ,T1.USERID                          --交易柜员编号
      ,''                          --复核柜员编号
      ,''                          --授权柜员编号
      ,''                          --客户经理编号
      ,''                          --渠道类型代码
      ,''                          --渠道编号
      ,''                          --支付通道类型代码
      ,''                          --交易对手客户编号
      ,''                          --交易对手名称
      ,''                          --交易对手账户开户行号
      ,''                          --交易对手账户开户行名称
      ,''                          --交易对手账号ID
      ,''                          --交易对手账号
      ,''                          --交易对手机构编号
      ,''                          --交易对手机构名称
      ,''                          --入账日期
      ,''                          --入账时间
      ,''                          --入账机构编号
      ,''                          --入账柜员编号
      ,''                          --入账币种代码
      ,''                          --入账金额
      ,''                          --摘要码
      ,''                          --摘要
      ,''                          --借贷标志
      ,''                          --同城标志
      ,''                          --跨行标志
      ,''                          --境外标志
      ,''                          --现转标志
      ,''                          --发起方类型代码
      ,''                          --主凭证种类代码
      ,''                          --主凭证号码
      ,''                          --副凭证种类代码
      ,''                          --副凭证号码
      ,''                          --关联核心系统事件编号
      ,''                          --冲正事件编号
      ,''                          --流程编号
      ,''                          --关联抵质押品编号
      ,''                          --往账标志
      ,''                          --余额方向代码
      ,''                          --余额类型代码
      ,''                          --交易介质名称
      ,''                          --交易介质编号
      ,''                          --业务类型代码
      ,''                          --业务种类代码
      ,''                          --本行发起标志
      ,''                          --旧凭证号码
      ,''                          --协议所属账号2
      ,''                          --协议所属账号3
      ,'MPCS'                          --数据来源代码
--      ,'EVT_MPCS_EVENT_DTL_02'                          --ETL任务名称
      ,to_date('${batch_date}','yyyymmdd')                          --数据日期
--      ,''                          --
--      ,'0'                          --
--      ,''                          --
--      ,''                          --
--      ,''                          --外部科目编号
--      ,''                          --红蓝字标志
--      ,''                          --银行编号
--      ,''                          --银团编号
--      ,''                          --我行出资比例
      ,'11'                           --任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                          --任务处理时间
     FROM ${iol_schema}.MPCS_A08TBESTOPAPPLY T1--
    WHERE T1.SENDDT = '${batch_date}';

commit;


whenever sqlerror exit sql.sqlcode;
--第十二组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --小额维护入账
insert /*+ append(12) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id                       -- 事件编号       
   ,global_chn_seq_num           -- 全局渠道流水号    
   ,prev_global_chn_seq_num      -- 上一全局渠道流水号  
   ,prev_evt_id                  -- 上一事件编号     
   ,evt_typ_cd                   -- 事件类型代码     
   ,menuid                       -- 柜面菜单码      
   ,txn_num                      -- 交易码        
   ,txn_desc                     -- 交易描述       
   ,txn_dt                       -- 交易日期       
   ,txn_tm                       -- 交易时间       
   ,txn_ccy_cd                   -- 交易币种代码     
   ,txn_amt                      -- 交易金额       
   ,acct_bal                     -- 账户余额       
   ,cost_typ_cd                  -- 费用类型代码     
   ,fee_amt                      -- 手续费金额      
   ,evt_status_cd                -- 事件状态代码     
   ,evt_reverse_typ_cd           -- 事件冲正类型代码   
   ,agt_id                       -- 协议编号       
   ,agt_id_name                  -- 协议全称       
   ,agt_blng_acct_num            -- 协议所属账号     
   ,prd_id                       -- 产品编号       
   ,pty_id                       -- 客户编号       
   ,txn_org_id                   -- 交易机构编号     
   ,txn_teller_id                -- 交易柜员编号     
   ,chk_teller_id                -- 复核柜员编号     
   ,auth_teller_id               -- 授权柜员编号     
   ,pty_mgr_id                   -- 客户经理编号     
   ,chn_typ_cd                   -- 渠道类型代码     
   ,chn_id                       -- 渠道编号       
   ,pay_chnl_typ_cd              -- 支付通道类型代码   
   ,cntrpty_id                   -- 交易对手编号     
   ,cntrpty_name                 -- 交易对手名称     
   ,cntrpty_acct_openbk_num      -- 交易对手账户开户行号 
   ,cntrpty_acct_openbk_name     -- 交易对手账户开户行名称
   ,cntrpty_acct_num_id          -- 交易对手账号ID   
   ,cntrpty_acct_num             -- 交易对手账号     
   ,cntrpty_org_id               -- 交易对手机构编号   
   ,cntrpty_org_name             -- 交易对手机构名称   
   ,posting_dt                   -- 入账日期       
   ,posting_tm                   -- 入账时间       
   ,posting_org_id               -- 入账机构编号     
   ,posting_teller_id            -- 入账柜员编号     
   ,posting_ccy_cd               -- 入账币种代码     
   ,posting_amt                  -- 入账金额       
   ,memo_cd                      -- 摘要码        
   ,memo                         -- 摘要         
   ,db_cr_dir_cd                 -- 借贷标志       
   ,city_flg                     -- 同城标志       
   ,crossb_flg                   -- 跨行标志       
   ,ovsea_flg                    -- 境外标志       
   ,cash_tfr_flg                 -- 现转标志       
   ,initor_typ_cd                -- 发起方类型代码    
   ,prim_vchr_type_cd            -- 主凭证种类代码    
   ,prim_vchr_num                -- 主凭证号码      
   ,scd_vchr_type_cd             -- 副凭证种类代码    
   ,scd_vchr_num                 -- 副凭证号码      
   ,assoc_bcs_evt_id             -- 关联核心系统事件编号 
   ,reverse_evt_id               -- 冲正事件编号     
   ,flow_id                      -- 流程编号       
   ,assoc_coll_id                -- 关联抵质押品编号   
   ,nostro_flg                   -- 往账标志       
   ,bal_dir_cd                   -- 余额方向代码     
   ,bal_typ_cd                   -- 余额类型代码     
   ,txn_med_name                 -- 交易介质名称     
   ,txn_med_id                   -- 交易介质编号     
   ,biz_typ_cd                   -- 业务类型代码     
   ,biz_cate_cd                  -- 业务种类代码     
   ,ghb_init_flg                 -- 本行发起标志     
   ,old_vchr_num                 -- 旧凭证号码      
   ,agt_blng_acct_num2           -- 协议所属账号2    
   ,agt_blng_acct_num3           -- 协议所属账号3    
   ,data_src_cd                  -- 数据来源代码     
   ,etl_dt                       -- 数据日期       
   ,job_cd                       -- 任务代码       
   ,etl_timestamp                -- 任务处理时间     
)
select 'L108'||T1.PAY_DECL_FORM_ID                          --业务系统事件编号
      ,''                          --全局渠道流水号
      ,''                          --上一全局渠道流水号
      ,''                          --上一事件编号
      ,'L108'                          --事件类型代码
      ,''                          --柜面菜单码
      ,'A16F01'                          --交易码
      ,'小额维护入账'                          --交易描述
      ,T1.MATN_ENTER_ACCT_DT                          --交易日期
      ,TO_CHAR(T1.RECNT_MODIF_TM,'HH24:MI:SS')                          --交易时间
      ,T1.CURR_CD                          --交易币种代码
      ,T1.TRAN_AMT                          --交易金额
      ,''                          --账户余额
      ,''                          --费用类型代码
      ,''                          --费用金额
      ,'1'                          --事件状态代码
      ,''                          --事件冲正类型代码
      ,T1.MATN_ENTER_ACCT_NUM                          --协议编号
      ,''                          --协议全称
      ,''                          --协议所属账号
      ,'BEPS'                          --产品编号
      ,''                          --客户编号
      ,T1.MATN_ENTER_ACCT_DEPT_ID                          --交易机构编号
      ,T1.MATN_ENTER_ACCT_TELLER_ID                          --交易柜员编号
      ,''                          --复核柜员编号
      ,T1.AUTH_TELLER_ID                          --授权柜员编号
      ,''                          --客户经理编号
      ,''                          --渠道类型代码
      ,''                          --渠道编号
      ,''                          --支付通道类型代码
      ,''                          --交易对手客户编号
      ,''                          --交易对手名称
      ,''                          --交易对手账户开户行号
      ,''                          --交易对手账户开户行名称
      ,''                          --交易对手账号ID
      ,T1.PAYER_ACCT_NUM                          --交易对手账号
      ,''                          --交易对手机构编号
      ,''                          --交易对手机构名称
      ,''                          --入账日期
      ,''                          --入账时间
      ,''                          --入账机构编号
      ,''                          --入账柜员编号
      ,''                          --入账币种代码
      ,''                          --入账金额
      ,''                          --摘要码
      ,''                          --摘要
      ,''                          --借贷标志
      ,''                          --同城标志
      ,''                          --跨行标志
      ,''                          --境外标志
      ,''                          --现转标志
      ,''                          --发起方类型代码
      ,''                          --主凭证种类代码
      ,''                          --主凭证号码
      ,''                          --副凭证种类代码
      ,''                          --副凭证号码
      ,''                          --关联核心系统事件编号
      ,''                          --冲正事件编号
      ,''                          --流程编号
      ,''                          --关联抵质押品编号
      ,''                          --往账标志
      ,''                          --余额方向代码
      ,''                          --余额类型代码
      ,''                          --交易介质名称
      ,''                          --交易介质编号
      ,''                          --业务类型代码
      ,''                          --业务种类代码
      ,''                          --本行发起标志
      ,''                          --旧凭证号码
      ,''                          --协议所属账号2
      ,''                          --协议所属账号3
      ,'MPCS'                          --数据来源代码
--      ,'EVT_MPCS_EVENT_DTL_02'                          --ETL任务名称
      ,to_date('${batch_date}','yyyymmdd')                          --数据日期
--      ,''                          --
--      ,'0'                          --
--      ,''                          --
--      ,''                          --
--      ,''                          --外部科目编号
--      ,''                          --红蓝字标志
--      ,''                          --银行编号
--      ,''                          --银团编号
--      ,''                          --我行出资比例
      ,'12'                        --任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                          --任务处理时间
FROM ${iml_schema}.EVT_BEPS_TRAN_EVT T1--小额交易事件
INNER JOIN ${iol_schema}.MPCS_CPMTINST T2--
 ON T1.matn_enter_acct_dept_id = T2.INSTNO
AND T2.START_DT <= to_date('${batch_date}','yyyymmdd')
AND T2.END_DT > to_date('${batch_date}','yyyymmdd')
    WHERE T1.PROC_STATUS_CD = '6' 
AND T1.NOSTRO_FLG = '1' 
AND T1.DEBIT_CRDT_CD = 'C'
AND T1.MATN_ENTER_ACCT_DT = to_date('${batch_date}','yyyymmdd');

commit;


--第十三组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --省金服查询查复 --业务已下线


whenever sqlerror exit sql.sqlcode;
--第十四组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --大小额查复书登记簿
insert /*+ append(14) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id                       -- 事件编号       
   ,global_chn_seq_num           -- 全局渠道流水号    
   ,prev_global_chn_seq_num      -- 上一全局渠道流水号  
   ,prev_evt_id                  -- 上一事件编号     
   ,evt_typ_cd                   -- 事件类型代码     
   ,menuid                       -- 柜面菜单码      
   ,txn_num                      -- 交易码        
   ,txn_desc                     -- 交易描述       
   ,txn_dt                       -- 交易日期       
   ,txn_tm                       -- 交易时间       
   ,txn_ccy_cd                   -- 交易币种代码     
   ,txn_amt                      -- 交易金额       
   ,acct_bal                     -- 账户余额       
   ,cost_typ_cd                  -- 费用类型代码     
   ,fee_amt                      -- 手续费金额      
   ,evt_status_cd                -- 事件状态代码     
   ,evt_reverse_typ_cd           -- 事件冲正类型代码   
   ,agt_id                       -- 协议编号       
   ,agt_id_name                  -- 协议全称       
   ,agt_blng_acct_num            -- 协议所属账号     
   ,prd_id                       -- 产品编号       
   ,pty_id                       -- 客户编号       
   ,txn_org_id                   -- 交易机构编号     
   ,txn_teller_id                -- 交易柜员编号     
   ,chk_teller_id                -- 复核柜员编号     
   ,auth_teller_id               -- 授权柜员编号     
   ,pty_mgr_id                   -- 客户经理编号     
   ,chn_typ_cd                   -- 渠道类型代码     
   ,chn_id                       -- 渠道编号       
   ,pay_chnl_typ_cd              -- 支付通道类型代码   
   ,cntrpty_id                   -- 交易对手编号     
   ,cntrpty_name                 -- 交易对手名称     
   ,cntrpty_acct_openbk_num      -- 交易对手账户开户行号 
   ,cntrpty_acct_openbk_name     -- 交易对手账户开户行名称
   ,cntrpty_acct_num_id          -- 交易对手账号ID   
   ,cntrpty_acct_num             -- 交易对手账号     
   ,cntrpty_org_id               -- 交易对手机构编号   
   ,cntrpty_org_name             -- 交易对手机构名称   
   ,posting_dt                   -- 入账日期       
   ,posting_tm                   -- 入账时间       
   ,posting_org_id               -- 入账机构编号     
   ,posting_teller_id            -- 入账柜员编号     
   ,posting_ccy_cd               -- 入账币种代码     
   ,posting_amt                  -- 入账金额       
   ,memo_cd                      -- 摘要码        
   ,memo                         -- 摘要         
   ,db_cr_dir_cd                 -- 借贷标志       
   ,city_flg                     -- 同城标志       
   ,crossb_flg                   -- 跨行标志       
   ,ovsea_flg                    -- 境外标志       
   ,cash_tfr_flg                 -- 现转标志       
   ,initor_typ_cd                -- 发起方类型代码    
   ,prim_vchr_type_cd            -- 主凭证种类代码    
   ,prim_vchr_num                -- 主凭证号码      
   ,scd_vchr_type_cd             -- 副凭证种类代码    
   ,scd_vchr_num                 -- 副凭证号码      
   ,assoc_bcs_evt_id             -- 关联核心系统事件编号 
   ,reverse_evt_id               -- 冲正事件编号     
   ,flow_id                      -- 流程编号       
   ,assoc_coll_id                -- 关联抵质押品编号   
   ,nostro_flg                   -- 往账标志       
   ,bal_dir_cd                   -- 余额方向代码     
   ,bal_typ_cd                   -- 余额类型代码     
   ,txn_med_name                 -- 交易介质名称     
   ,txn_med_id                   -- 交易介质编号     
   ,biz_typ_cd                   -- 业务类型代码     
   ,biz_cate_cd                  -- 业务种类代码     
   ,ghb_init_flg                 -- 本行发起标志     
   ,old_vchr_num                 -- 旧凭证号码      
   ,agt_blng_acct_num2           -- 协议所属账号2    
   ,agt_blng_acct_num3           -- 协议所属账号3    
   ,data_src_cd                  -- 数据来源代码     
   ,etl_dt                       -- 数据日期       
   ,job_cd                       -- 任务代码       
   ,etl_timestamp                -- 任务处理时间     
)
select 'L111'||T1.UNOTDATE||T1.UNOTNBR                          --业务系统事件编号
      ,''                          --全局渠道流水号
      ,''                          --上一全局渠道流水号
      ,''                          --上一事件编号
      ,'L111'                          --事件类型代码
      ,''                          --柜面菜单码
      ,'A49M61'                          --交易码
      ,'省金服自由格式书'                          --交易描述
      ,TO_DATE(T1.UNOTDATE,'YYYY-MM-DD')                          --交易日期
      ,''                          --交易时间
      ,'CNY'                          --交易币种代码
      ,''                          --交易金额
      ,''                          --账户余额
      ,''                          --费用类型代码
      ,''                          --费用金额
      ,CASE WHEN T1.STATUS = '00' THEN '1'
     WHEN T1.STATUS = '11' THEN '2'
     ELSE '9'
END                          --事件状态代码
      ,''                          --事件冲正类型代码
      ,''                          --协议编号
      ,''                          --协议全称
      ,''                          --协议所属账号
      ,'EFT'                          --产品编号
      ,''                          --客户编号
      ,T1.MAGBRN                          --交易机构编号
      ,T1.TLRNBR                          --交易柜员编号
      ,''                          --复核柜员编号
      ,''                          --授权柜员编号
      ,''                          --客户经理编号
      ,''                          --渠道类型代码
      ,''                          --渠道编号
      ,''                          --支付通道类型代码
      ,''                          --交易对手客户编号
      ,''                          --交易对手名称
      ,''                          --交易对手账户开户行号
      ,''                          --交易对手账户开户行名称
      ,''                          --交易对手账号ID
      ,''                          --交易对手账号
      ,''                          --交易对手机构编号
      ,''                          --交易对手机构名称
      ,''                          --入账日期
      ,''                          --入账时间
      ,''                          --入账机构编号
      ,''                          --入账柜员编号
      ,''                          --入账币种代码
      ,''                          --入账金额
      ,''                          --摘要码
      ,''                          --摘要
      ,''                          --借贷标志
      ,''                          --同城标志
      ,''                          --跨行标志
      ,''                          --境外标志
      ,''                          --现转标志
      ,''                          --发起方类型代码
      ,''                          --主凭证种类代码
      ,''                          --主凭证号码
      ,''                          --副凭证种类代码
      ,''                          --副凭证号码
      ,''                          --关联核心系统事件编号
      ,''                          --冲正事件编号
      ,''                          --流程编号
      ,''                          --关联抵质押品编号
      ,''                          --往账标志
      ,''                          --余额方向代码
      ,''                          --余额类型代码
      ,''                          --交易介质名称
      ,''                          --交易介质编号
      ,''                          --业务类型代码
      ,''                          --业务种类代码
      ,''                          --本行发起标志
      ,''                          --旧凭证号码
      ,''                          --协议所属账号2
      ,''                          --协议所属账号3
      ,'MPCS'                          --数据来源代码
--      ,'EVT_MPCS_EVENT_DTL_02'                          --ETL任务名称
      ,to_date('${batch_date}','yyyymmdd')                          --数据日期
--      ,''                          --
--      ,'0'                          --
--      ,''                          --
--      ,''                          --
--      ,''                          --外部科目编号
--      ,''                          --红蓝字标志
--      ,''                          --银行编号
--      ,''                          --银团编号
--      ,''                          --我行出资比例
      ,'14'                           --任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                          --任务处理时间
     FROM ${iol_schema}.MPCS_A49TEFFREE T1--
    WHERE T1.IOTYPE = '0'
AND T1.UNOTDATE = '${batch_date}';

commit;


whenever sqlerror exit sql.sqlcode;
--第十五组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --省金服财税业务交易流水登记簿
insert /*+ append(15) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id                       -- 事件编号       
   ,global_chn_seq_num           -- 全局渠道流水号    
   ,prev_global_chn_seq_num      -- 上一全局渠道流水号  
   ,prev_evt_id                  -- 上一事件编号     
   ,evt_typ_cd                   -- 事件类型代码     
   ,menuid                       -- 柜面菜单码      
   ,txn_num                      -- 交易码        
   ,txn_desc                     -- 交易描述       
   ,txn_dt                       -- 交易日期       
   ,txn_tm                       -- 交易时间       
   ,txn_ccy_cd                   -- 交易币种代码     
   ,txn_amt                      -- 交易金额       
   ,acct_bal                     -- 账户余额       
   ,cost_typ_cd                  -- 费用类型代码     
   ,fee_amt                      -- 手续费金额      
   ,evt_status_cd                -- 事件状态代码     
   ,evt_reverse_typ_cd           -- 事件冲正类型代码   
   ,agt_id                       -- 协议编号       
   ,agt_id_name                  -- 协议全称       
   ,agt_blng_acct_num            -- 协议所属账号     
   ,prd_id                       -- 产品编号       
   ,pty_id                       -- 客户编号       
   ,txn_org_id                   -- 交易机构编号     
   ,txn_teller_id                -- 交易柜员编号     
   ,chk_teller_id                -- 复核柜员编号     
   ,auth_teller_id               -- 授权柜员编号     
   ,pty_mgr_id                   -- 客户经理编号     
   ,chn_typ_cd                   -- 渠道类型代码     
   ,chn_id                       -- 渠道编号       
   ,pay_chnl_typ_cd              -- 支付通道类型代码   
   ,cntrpty_id                   -- 交易对手编号     
   ,cntrpty_name                 -- 交易对手名称     
   ,cntrpty_acct_openbk_num      -- 交易对手账户开户行号 
   ,cntrpty_acct_openbk_name     -- 交易对手账户开户行名称
   ,cntrpty_acct_num_id          -- 交易对手账号ID   
   ,cntrpty_acct_num             -- 交易对手账号     
   ,cntrpty_org_id               -- 交易对手机构编号   
   ,cntrpty_org_name             -- 交易对手机构名称   
   ,posting_dt                   -- 入账日期       
   ,posting_tm                   -- 入账时间       
   ,posting_org_id               -- 入账机构编号     
   ,posting_teller_id            -- 入账柜员编号     
   ,posting_ccy_cd               -- 入账币种代码     
   ,posting_amt                  -- 入账金额       
   ,memo_cd                      -- 摘要码        
   ,memo                         -- 摘要         
   ,db_cr_dir_cd                 -- 借贷标志       
   ,city_flg                     -- 同城标志       
   ,crossb_flg                   -- 跨行标志       
   ,ovsea_flg                    -- 境外标志       
   ,cash_tfr_flg                 -- 现转标志       
   ,initor_typ_cd                -- 发起方类型代码    
   ,prim_vchr_type_cd            -- 主凭证种类代码    
   ,prim_vchr_num                -- 主凭证号码      
   ,scd_vchr_type_cd             -- 副凭证种类代码    
   ,scd_vchr_num                 -- 副凭证号码      
   ,assoc_bcs_evt_id             -- 关联核心系统事件编号 
   ,reverse_evt_id               -- 冲正事件编号     
   ,flow_id                      -- 流程编号       
   ,assoc_coll_id                -- 关联抵质押品编号   
   ,nostro_flg                   -- 往账标志       
   ,bal_dir_cd                   -- 余额方向代码     
   ,bal_typ_cd                   -- 余额类型代码     
   ,txn_med_name                 -- 交易介质名称     
   ,txn_med_id                   -- 交易介质编号     
   ,biz_typ_cd                   -- 业务类型代码     
   ,biz_cate_cd                  -- 业务种类代码     
   ,ghb_init_flg                 -- 本行发起标志     
   ,old_vchr_num                 -- 旧凭证号码      
   ,agt_blng_acct_num2           -- 协议所属账号2    
   ,agt_blng_acct_num3           -- 协议所属账号3    
   ,data_src_cd                  -- 数据来源代码     
   ,etl_dt                       -- 数据日期       
   ,job_cd                       -- 任务代码       
   ,etl_timestamp                -- 任务处理时间     
)
select 'L114'||T1.TRANDT||T1.TRANSQ                          --业务系统事件编号
      ,''                          --全局渠道流水号
      ,''                          --上一全局渠道流水号
      ,''                          --上一事件编号
      ,'L114'                          --事件类型代码
      ,''                          --柜面菜单码
      ,case when T1.txntype = '100205' then 'A49F41'
     when T1.txntype = '300205' then 'A59F41'
     else 'A49F41'
end                          --交易码
      ,case when T1.txntype = '100205' then '自缴核销（银行核销）缴款申请'
     when T1.txntype = '300205' then '实时扣税交易通知'
     else '自缴核销（银行核销）缴款申请'
end                          --交易描述
      ,TO_DATE(T1.TRANDT,'YYYY-MM-DD')                          --交易日期
      ,SUBSTR(T1.TRANTM,1,2)||':'||SUBSTR(T1.TRANTM,3,2)||':'||SUBSTR(T1.TRANTM,5,2)                          --交易时间
      ,'CNY'                          --交易币种代码
      ,''                          --交易金额
      ,''                          --账户余额
      ,''                          --费用类型代码
      ,''                          --费用金额
      ,CASE WHEN T1.TRANST = '3' THEN '1'
     WHEN T1.TRANST IN ('1','5','6') THEN '2'
     ELSE '9'
END                          --事件状态代码
      ,''                          --事件冲正类型代码
      ,''                          --协议编号
      ,''                          --协议全称
      ,''                          --协议所属账号
      ,'EFT'                          --产品编号
      ,''                          --客户编号
      ,T1.MAGBRN                          --交易机构编号
      ,T1.USERID                          --交易柜员编号
      ,''                          --复核柜员编号
      ,T1.CKBKUS                          --授权柜员编号
      ,''                          --客户经理编号
      ,''                          --渠道类型代码
      ,''                          --渠道编号
      ,''                          --支付通道类型代码
      ,''                          --交易对手客户编号
      ,''                          --交易对手名称
      ,''                          --交易对手账户开户行号
      ,''                          --交易对手账户开户行名称
      ,''                          --交易对手账号ID
      ,''                          --交易对手账号
      ,''                          --交易对手机构编号
      ,''                          --交易对手机构名称
      ,''                          --入账日期
      ,''                          --入账时间
      ,''                          --入账机构编号
      ,''                          --入账柜员编号
      ,''                          --入账币种代码
      ,''                          --入账金额
      ,''                          --摘要码
      ,''                          --摘要
      ,''                          --借贷标志
      ,''                          --同城标志
      ,''                          --跨行标志
      ,''                          --境外标志
      ,''                          --现转标志
      ,''                          --发起方类型代码
      ,''                          --主凭证种类代码
      ,''                          --主凭证号码
      ,''                          --副凭证种类代码
      ,''                          --副凭证号码
      ,''                          --关联核心系统事件编号
      ,''                          --冲正事件编号
      ,''                          --流程编号
      ,''                          --关联抵质押品编号
      ,case when T1.IOTYPE = 'I' then '0'
     when T1.IOTYPE = 'O' then '1' 
end                          --往账标志
      ,''                          --余额方向代码
      ,''                          --余额类型代码
      ,''                          --交易介质名称
      ,''                          --交易介质编号
      ,''                          --业务类型代码
      ,''                          --业务种类代码
      ,''                          --本行发起标志
      ,''                          --旧凭证号码
      ,''                          --协议所属账号2
      ,''                          --协议所属账号3
      ,'MPCS'                          --数据来源代码
--      ,'EVT_MPCS_EVENT_DTL_02'                          --ETL任务名称
      ,to_date('${batch_date}','yyyymmdd')                          --数据日期
--      ,''                          --
--      ,'0'                          --
--      ,''                          --
--      ,''                          --
--      ,''                          --外部科目编号
--      ,''                          --红蓝字标志
--      ,''                          --银行编号
--      ,''                          --银团编号
--      ,''                          --我行出资比例
      ,'15'                           --任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                          --任务处理时间
     FROM ${iol_schema}.MPCS_A49TEFETSTRAN T1--
    WHERE T1.TRANDT = '${batch_date}'
    AND ETL_DT=to_date('${batch_date}','yyyymmdd');

commit;


whenever sqlerror exit sql.sqlcode;
--第十六组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --省金服财税扣缴协议签约登记簿
insert /*+ append(16) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id                       -- 事件编号       
   ,global_chn_seq_num           -- 全局渠道流水号    
   ,prev_global_chn_seq_num      -- 上一全局渠道流水号  
   ,prev_evt_id                  -- 上一事件编号     
   ,evt_typ_cd                   -- 事件类型代码     
   ,menuid                       -- 柜面菜单码      
   ,txn_num                      -- 交易码        
   ,txn_desc                     -- 交易描述       
   ,txn_dt                       -- 交易日期       
   ,txn_tm                       -- 交易时间       
   ,txn_ccy_cd                   -- 交易币种代码     
   ,txn_amt                      -- 交易金额       
   ,acct_bal                     -- 账户余额       
   ,cost_typ_cd                  -- 费用类型代码     
   ,fee_amt                      -- 手续费金额      
   ,evt_status_cd                -- 事件状态代码     
   ,evt_reverse_typ_cd           -- 事件冲正类型代码   
   ,agt_id                       -- 协议编号       
   ,agt_id_name                  -- 协议全称       
   ,agt_blng_acct_num            -- 协议所属账号     
   ,prd_id                       -- 产品编号       
   ,pty_id                       -- 客户编号       
   ,txn_org_id                   -- 交易机构编号     
   ,txn_teller_id                -- 交易柜员编号     
   ,chk_teller_id                -- 复核柜员编号     
   ,auth_teller_id               -- 授权柜员编号     
   ,pty_mgr_id                   -- 客户经理编号     
   ,chn_typ_cd                   -- 渠道类型代码     
   ,chn_id                       -- 渠道编号       
   ,pay_chnl_typ_cd              -- 支付通道类型代码   
   ,cntrpty_id                   -- 交易对手编号     
   ,cntrpty_name                 -- 交易对手名称     
   ,cntrpty_acct_openbk_num      -- 交易对手账户开户行号 
   ,cntrpty_acct_openbk_name     -- 交易对手账户开户行名称
   ,cntrpty_acct_num_id          -- 交易对手账号ID   
   ,cntrpty_acct_num             -- 交易对手账号     
   ,cntrpty_org_id               -- 交易对手机构编号   
   ,cntrpty_org_name             -- 交易对手机构名称   
   ,posting_dt                   -- 入账日期       
   ,posting_tm                   -- 入账时间       
   ,posting_org_id               -- 入账机构编号     
   ,posting_teller_id            -- 入账柜员编号     
   ,posting_ccy_cd               -- 入账币种代码     
   ,posting_amt                  -- 入账金额       
   ,memo_cd                      -- 摘要码        
   ,memo                         -- 摘要         
   ,db_cr_dir_cd                 -- 借贷标志       
   ,city_flg                     -- 同城标志       
   ,crossb_flg                   -- 跨行标志       
   ,ovsea_flg                    -- 境外标志       
   ,cash_tfr_flg                 -- 现转标志       
   ,initor_typ_cd                -- 发起方类型代码    
   ,prim_vchr_type_cd            -- 主凭证种类代码    
   ,prim_vchr_num                -- 主凭证号码      
   ,scd_vchr_type_cd             -- 副凭证种类代码    
   ,scd_vchr_num                 -- 副凭证号码      
   ,assoc_bcs_evt_id             -- 关联核心系统事件编号 
   ,reverse_evt_id               -- 冲正事件编号     
   ,flow_id                      -- 流程编号       
   ,assoc_coll_id                -- 关联抵质押品编号   
   ,nostro_flg                   -- 往账标志       
   ,bal_dir_cd                   -- 余额方向代码     
   ,bal_typ_cd                   -- 余额类型代码     
   ,txn_med_name                 -- 交易介质名称     
   ,txn_med_id                   -- 交易介质编号     
   ,biz_typ_cd                   -- 业务类型代码     
   ,biz_cate_cd                  -- 业务种类代码     
   ,ghb_init_flg                 -- 本行发起标志     
   ,old_vchr_num                 -- 旧凭证号码      
   ,agt_blng_acct_num2           -- 协议所属账号2    
   ,agt_blng_acct_num3           -- 协议所属账号3    
   ,data_src_cd                  -- 数据来源代码     
   ,etl_dt                       -- 数据日期       
   ,job_cd                       -- 任务代码       
   ,etl_timestamp                -- 任务处理时间     
)
select 'L113'||T1.SIGNDT||T1.SIGNSQ                          --业务系统事件编号
      ,''                          --全局渠道流水号
      ,''                          --上一全局渠道流水号
      ,''                          --上一事件编号
      ,'L113'                          --事件类型代码
      ,''                          --柜面菜单码
      ,'A49M41'                          --交易码
      ,'财税扣缴协议签约'                          --交易描述
      ,TO_DATE(T1.SIGNDT,'YYYY-MM-DD')                          --交易日期
      ,T1.SIGNTM                          --交易时间
      ,'CNY'                          --交易币种代码
      ,''                          --交易金额
      ,''                          --账户余额
      ,''                          --费用类型代码
      ,''                          --费用金额
      ,CASE WHEN T1.SIGNST = '1' THEN '1'
     WHEN T1.SIGNST = '0' THEN '2'
     ELSE '9'
END                          --事件状态代码
      ,''                          --事件冲正类型代码
      ,''                          --协议编号
      ,T1.ACCTNA                          --协议全称
      ,T1.ACCTNO                          --协议所属账号
      ,'EFT'                          --产品编号
      ,''                          --客户编号
      ,T1.BRCHNO                          --交易机构编号
      ,T1.USERID                          --交易柜员编号
      ,''                          --复核柜员编号
      ,T1.CKBKUS                          --授权柜员编号
      ,''                          --客户经理编号
      ,''                          --渠道类型代码
      ,''                          --渠道编号
      ,''                          --支付通道类型代码
      ,''                          --交易对手客户编号
      ,''                          --交易对手名称
      ,''                          --交易对手账户开户行号
      ,''                          --交易对手账户开户行名称
      ,''                          --交易对手账号ID
      ,''                          --交易对手账号
      ,''                          --交易对手机构编号
      ,''                          --交易对手机构名称
      ,''                          --入账日期
      ,''                          --入账时间
      ,''                          --入账机构编号
      ,''                          --入账柜员编号
      ,''                          --入账币种代码
      ,''                          --入账金额
      ,''                          --摘要码
      ,''                          --摘要
      ,''                          --借贷标志
      ,''                          --同城标志
      ,''                          --跨行标志
      ,''                          --境外标志
      ,''                          --现转标志
      ,''                          --发起方类型代码
      ,''                          --主凭证种类代码
      ,''                          --主凭证号码
      ,''                          --副凭证种类代码
      ,''                          --副凭证号码
      ,''                          --关联核心系统事件编号
      ,''                          --冲正事件编号
      ,''                          --流程编号
      ,''                          --关联抵质押品编号
      ,''                          --往账标志
      ,''                          --余额方向代码
      ,''                          --余额类型代码
      ,''                          --交易介质名称
      ,''                          --交易介质编号
      ,''                          --业务类型代码
      ,''                          --业务种类代码
      ,''                          --本行发起标志
      ,''                          --旧凭证号码
      ,''                          --协议所属账号2
      ,''                          --协议所属账号3
      ,'MPCS'                          --数据来源代码
--      ,'EVT_MPCS_EVENT_DTL_02'                          --ETL任务名称
      ,to_date('${batch_date}','yyyymmdd')                          --数据日期
--      ,''                          --
--      ,'0'                          --
--      ,''                          --
--      ,''                          --
--      ,''                          --外部科目编号
--      ,''                          --红蓝字标志
--      ,''                          --银行编号
--      ,''                          --银团编号
--      ,''                          --我行出资比例
      ,'16'                           --任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                          --任务处理时间
     FROM ${iol_schema}.MPCS_A49TEFETSREG T1--
    WHERE T1.SIGNDT = '${batch_date}';

commit;


--第十七组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑    省金服代理业务缴费业务登记薄      --该业务已下线
--第十八组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑    省金服定期借贷记签约表            --该业务已下线
--第十九组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑    省金服代收付集中代扣费签约信息表  --该业务已迁移至小额支付系统


whenever sqlerror exit sql.sqlcode;
--第二十组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --深同城交易流水表
insert /*+ append(20) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id                       -- 事件编号       
   ,global_chn_seq_num           -- 全局渠道流水号    
   ,prev_global_chn_seq_num      -- 上一全局渠道流水号  
   ,prev_evt_id                  -- 上一事件编号     
   ,evt_typ_cd                   -- 事件类型代码     
   ,menuid                       -- 柜面菜单码      
   ,txn_num                      -- 交易码        
   ,txn_desc                     -- 交易描述       
   ,txn_dt                       -- 交易日期       
   ,txn_tm                       -- 交易时间       
   ,txn_ccy_cd                   -- 交易币种代码     
   ,txn_amt                      -- 交易金额       
   ,acct_bal                     -- 账户余额       
   ,cost_typ_cd                  -- 费用类型代码     
   ,fee_amt                      -- 手续费金额      
   ,evt_status_cd                -- 事件状态代码     
   ,evt_reverse_typ_cd           -- 事件冲正类型代码   
   ,agt_id                       -- 协议编号       
   ,agt_id_name                  -- 协议全称       
   ,agt_blng_acct_num            -- 协议所属账号     
   ,prd_id                       -- 产品编号       
   ,pty_id                       -- 客户编号       
   ,txn_org_id                   -- 交易机构编号     
   ,txn_teller_id                -- 交易柜员编号     
   ,chk_teller_id                -- 复核柜员编号     
   ,auth_teller_id               -- 授权柜员编号     
   ,pty_mgr_id                   -- 客户经理编号     
   ,chn_typ_cd                   -- 渠道类型代码     
   ,chn_id                       -- 渠道编号       
   ,pay_chnl_typ_cd              -- 支付通道类型代码   
   ,cntrpty_id                   -- 交易对手编号     
   ,cntrpty_name                 -- 交易对手名称     
   ,cntrpty_acct_openbk_num      -- 交易对手账户开户行号 
   ,cntrpty_acct_openbk_name     -- 交易对手账户开户行名称
   ,cntrpty_acct_num_id          -- 交易对手账号ID   
   ,cntrpty_acct_num             -- 交易对手账号     
   ,cntrpty_org_id               -- 交易对手机构编号   
   ,cntrpty_org_name             -- 交易对手机构名称   
   ,posting_dt                   -- 入账日期       
   ,posting_tm                   -- 入账时间       
   ,posting_org_id               -- 入账机构编号     
   ,posting_teller_id            -- 入账柜员编号     
   ,posting_ccy_cd               -- 入账币种代码     
   ,posting_amt                  -- 入账金额       
   ,memo_cd                      -- 摘要码        
   ,memo                         -- 摘要         
   ,db_cr_dir_cd                 -- 借贷标志       
   ,city_flg                     -- 同城标志       
   ,crossb_flg                   -- 跨行标志       
   ,ovsea_flg                    -- 境外标志       
   ,cash_tfr_flg                 -- 现转标志       
   ,initor_typ_cd                -- 发起方类型代码    
   ,prim_vchr_type_cd            -- 主凭证种类代码    
   ,prim_vchr_num                -- 主凭证号码      
   ,scd_vchr_type_cd             -- 副凭证种类代码    
   ,scd_vchr_num                 -- 副凭证号码      
   ,assoc_bcs_evt_id             -- 关联核心系统事件编号 
   ,reverse_evt_id               -- 冲正事件编号     
   ,flow_id                      -- 流程编号       
   ,assoc_coll_id                -- 关联抵质押品编号   
   ,nostro_flg                   -- 往账标志       
   ,bal_dir_cd                   -- 余额方向代码     
   ,bal_typ_cd                   -- 余额类型代码     
   ,txn_med_name                 -- 交易介质名称     
   ,txn_med_id                   -- 交易介质编号     
   ,biz_typ_cd                   -- 业务类型代码     
   ,biz_cate_cd                  -- 业务种类代码     
   ,ghb_init_flg                 -- 本行发起标志     
   ,old_vchr_num                 -- 旧凭证号码      
   ,agt_blng_acct_num2           -- 协议所属账号2    
   ,agt_blng_acct_num3           -- 协议所属账号3    
   ,data_src_cd                  -- 数据来源代码     
   ,etl_dt                       -- 数据日期       
   ,job_cd                       -- 任务代码       
   ,etl_timestamp                -- 任务处理时间     
)
select 'L120'||TO_CHAR(T1.TRAN_DT,'YYYYMMDD')||T1.MIDGROD_FLOW_NUM                          --业务系统事件编号
      ,''                          --全局渠道流水号
      ,''                          --上一全局渠道流水号
      ,''                          --上一事件编号
      ,'L120'                          --事件类型代码
      ,''                          --柜面菜单码
      ,T1.MIDGROD_TRAN_CODE                          --交易码
      ,case when T1.MIDGROD_TRAN_CODE = 'A68F01' then '汇兑录入'
     when T1.MIDGROD_TRAN_CODE = 'A68F02' then '往账复核'
     when T1.MIDGROD_TRAN_CODE = 'A68M01' then '往账修改'
     when T1.MIDGROD_TRAN_CODE = 'A68F03' then '往账删除'
     when T1.MIDGROD_TRAN_CODE = 'A68F12' then '普通借记提回冲正'
     when T1.MIDGROD_TRAN_CODE = 'A68M21' then '定期借贷记业务签约'
     when T1.MIDGROD_TRAN_CODE = 'A68F22' then '定期贷记业务复核'
     when T1.MIDGROD_TRAN_CODE = 'A68F23' then '定期借机业务录入'
     when T1.MIDGROD_TRAN_CODE = 'A68F21' then '定期贷记业务录入'
     when T1.MIDGROD_TRAN_CODE = 'A68F24' then '定期借记业务复核'
     when T1.MIDGROD_TRAN_CODE = 'A68F0G' then '来账维护入账'
     when T1.MIDGROD_TRAN_CODE = 'A68F0H' then '维护入账冲账'
     when T1.MIDGROD_TRAN_CODE = 'A68F0I' then '来账挂账转发'
     when T1.MIDGROD_TRAN_CODE = 'A68F0L' then '退汇'
     when T1.MIDGROD_TRAN_CODE = 'A68F0M' then '提回入账失败处理'
     when T1.MIDGROD_TRAN_CODE = 'A68F26' then '定期借记业务导入'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA69803' then 'szfs.803.001.01来账'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA69501' then 'szfs.501.001.01来账'
     when T1.MIDGROD_TRAN_CODE = 'A68F0J' then '来账查询处理-退汇来账重发'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA69FC1' then '来包账务处理'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA69106' then 'szfs.106.001.01来账报文处理'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA69202106' then '实时贷记202人行确认报文来账'
     else '其他'
end                          --交易描述
      ,T1.TRAN_DT                          --交易日期
      ,TO_CHAR(T1.NOSTRO_TM,'HH24:Mi:SS')                          --交易时间
      ,T1.CURR_CD                          --交易币种代码
      ,T1.TRAN_AMT                          --交易金额
      ,''                          --账户余额
      ,''                          --费用类型代码
      ,''                          --费用金额
      ,CASE WHEN T1.PROC_STATUS_CD = '1' THEN '1'
     WHEN T1.PROC_STATUS_CD = 'E' THEN '2'
     ELSE '9'
END                          --事件状态代码
      ,''                          --事件冲正类型代码
      ,''                          --协议编号
      ,T1.PAYER_NAME                          --协议全称
      ,T1.PAYER_ACCT_NUM                          --协议所属账号
      ,T1.PROD_CD                          --产品编号
      ,''                          --客户编号
      ,T1.PROC_ORG_ID                          --交易机构编号
      ,T1.INPUT_TELLER_ID                          --交易柜员编号
      ,T1.CHECK_TELLER_ID                          --复核柜员编号
      ,T1.AUTH_TELLER_ID                          --授权柜员编号
      ,''                          --客户经理编号
      ,''                          --渠道类型代码
      ,CASE WHEN T1.EXCH_BUS_CORS_TRAN_CHN_CD = '1001' THEN 'CNT'
     WHEN T1.EXCH_BUS_CORS_TRAN_CHN_CD = '1013' THEN 'PBNK'
     WHEN T1.EXCH_BUS_CORS_TRAN_CHN_CD = '9003' THEN 'ZTS'
     WHEN T1.EXCH_BUS_CORS_TRAN_CHN_CD = '0000' THEN ''
END                          --渠道编号
      ,''                          --支付通道类型代码
      ,''                          --交易对手客户编号
      ,T1.RECVER_NAME                          --交易对手名称
      ,''                          --交易对手账户开户行号
      ,''                          --交易对手账户开户行名称
      ,''                          --交易对手账号ID
      ,T1.RECVER_ACCT_NUM                          --交易对手账号
      ,''                          --交易对手机构编号
      ,''                          --交易对手机构名称
      ,''                          --入账日期
      ,''                          --入账时间
      ,''                          --入账机构编号
      ,''                          --入账柜员编号
      ,''                          --入账币种代码
      ,''                          --入账金额
      ,''                          --摘要码
      ,''                          --摘要
      ,case when T1.DEBIT_CRDT_CD = 'D' then 'C'
     when T1.DEBIT_CRDT_CD = 'C' then 'D'
end                          --借贷标志
      ,''                          --同城标志
      ,''                          --跨行标志
      ,''                          --境外标志
      ,''                          --现转标志
      ,''                          --发起方类型代码
      ,''                          --主凭证种类代码
      ,''                          --主凭证号码
      ,''                          --副凭证种类代码
      ,''                          --副凭证号码
      ,T1.HOST_FLOW_NUM                          --关联核心系统事件编号
      ,''                          --冲正事件编号
      ,''                          --流程编号
      ,''                          --关联抵质押品编号
      ,T1.NOSTRO_FLG                          --往账标志
      ,''                          --余额方向代码
      ,''                          --余额类型代码
      ,''                          --交易介质名称
      ,''                          --交易介质编号
      ,''                          --业务类型代码
      ,''                          --业务种类代码
      ,''                          --本行发起标志
      ,''                          --旧凭证号码
      ,''                          --协议所属账号2
      ,''                          --协议所属账号3
      ,'MPCS'                          --数据来源代码
--      ,'EVT_MPCS_EVENT_DTL_02'                          --ETL任务名称
      ,to_date('${batch_date}','yyyymmdd')                          --数据日期
--      ,''                          --
--      ,'0'                          --
--      ,''                          --
--      ,''                          --
--      ,''                          --外部科目编号
--      ,''                          --红蓝字标志
--      ,''                          --银行编号
--      ,''                          --银团编号
--      ,''                          --我行出资比例
      ,'20'                           --任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                          --任务处理时间
     FROM ${iml_schema}.EVT_TSZFS_TRAN_EVT T1--深同城交易事件
    WHERE T1.TRAN_DT = to_date('${batch_date}','yyyymmdd');

commit;


whenever sqlerror exit sql.sqlcode;
--第二十一组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --深同城金融流水表
insert /*+ append(21) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id                       -- 事件编号       
   ,global_chn_seq_num           -- 全局渠道流水号    
   ,prev_global_chn_seq_num      -- 上一全局渠道流水号  
   ,prev_evt_id                  -- 上一事件编号     
   ,evt_typ_cd                   -- 事件类型代码     
   ,menuid                       -- 柜面菜单码      
   ,txn_num                      -- 交易码        
   ,txn_desc                     -- 交易描述       
   ,txn_dt                       -- 交易日期       
   ,txn_tm                       -- 交易时间       
   ,txn_ccy_cd                   -- 交易币种代码     
   ,txn_amt                      -- 交易金额       
   ,acct_bal                     -- 账户余额       
   ,cost_typ_cd                  -- 费用类型代码     
   ,fee_amt                      -- 手续费金额      
   ,evt_status_cd                -- 事件状态代码     
   ,evt_reverse_typ_cd           -- 事件冲正类型代码   
   ,agt_id                       -- 协议编号       
   ,agt_id_name                  -- 协议全称       
   ,agt_blng_acct_num            -- 协议所属账号     
   ,prd_id                       -- 产品编号       
   ,pty_id                       -- 客户编号       
   ,txn_org_id                   -- 交易机构编号     
   ,txn_teller_id                -- 交易柜员编号     
   ,chk_teller_id                -- 复核柜员编号     
   ,auth_teller_id               -- 授权柜员编号     
   ,pty_mgr_id                   -- 客户经理编号     
   ,chn_typ_cd                   -- 渠道类型代码     
   ,chn_id                       -- 渠道编号       
   ,pay_chnl_typ_cd              -- 支付通道类型代码   
   ,cntrpty_id                   -- 交易对手编号     
   ,cntrpty_name                 -- 交易对手名称     
   ,cntrpty_acct_openbk_num      -- 交易对手账户开户行号 
   ,cntrpty_acct_openbk_name     -- 交易对手账户开户行名称
   ,cntrpty_acct_num_id          -- 交易对手账号ID   
   ,cntrpty_acct_num             -- 交易对手账号     
   ,cntrpty_org_id               -- 交易对手机构编号   
   ,cntrpty_org_name             -- 交易对手机构名称   
   ,posting_dt                   -- 入账日期       
   ,posting_tm                   -- 入账时间       
   ,posting_org_id               -- 入账机构编号     
   ,posting_teller_id            -- 入账柜员编号     
   ,posting_ccy_cd               -- 入账币种代码     
   ,posting_amt                  -- 入账金额       
   ,memo_cd                      -- 摘要码        
   ,memo                         -- 摘要         
   ,db_cr_dir_cd                 -- 借贷标志       
   ,city_flg                     -- 同城标志       
   ,crossb_flg                   -- 跨行标志       
   ,ovsea_flg                    -- 境外标志       
   ,cash_tfr_flg                 -- 现转标志       
   ,initor_typ_cd                -- 发起方类型代码    
   ,prim_vchr_type_cd            -- 主凭证种类代码    
   ,prim_vchr_num                -- 主凭证号码      
   ,scd_vchr_type_cd             -- 副凭证种类代码    
   ,scd_vchr_num                 -- 副凭证号码      
   ,assoc_bcs_evt_id             -- 关联核心系统事件编号 
   ,reverse_evt_id               -- 冲正事件编号     
   ,flow_id                      -- 流程编号       
   ,assoc_coll_id                -- 关联抵质押品编号   
   ,nostro_flg                   -- 往账标志       
   ,bal_dir_cd                   -- 余额方向代码     
   ,bal_typ_cd                   -- 余额类型代码     
   ,txn_med_name                 -- 交易介质名称     
   ,txn_med_id                   -- 交易介质编号     
   ,biz_typ_cd                   -- 业务类型代码     
   ,biz_cate_cd                  -- 业务种类代码     
   ,ghb_init_flg                 -- 本行发起标志     
   ,old_vchr_num                 -- 旧凭证号码      
   ,agt_blng_acct_num2           -- 协议所属账号2    
   ,agt_blng_acct_num3           -- 协议所属账号3    
   ,data_src_cd                  -- 数据来源代码     
   ,etl_dt                       -- 数据日期       
   ,job_cd                       -- 任务代码       
   ,etl_timestamp                -- 任务处理时间     
)
select 'L121'||TO_CHAR(T1.TRAN_DT,'YYYYMMDD')||T1.MIDGROD_FLOW_NUM                          --业务系统事件编号
      ,''                          --全局渠道流水号
      ,''                          --上一全局渠道流水号
      ,'L120'||T2.MIDGROD_FLOW_NUM                          --上一事件编号
      ,'L121'                          --事件类型代码
      ,''                          --柜面菜单码
      ,T1.MIDGROD_TRAN_CODE                          --交易码
      ,case when T1.MIDGROD_TRAN_CODE = 'A68F01' then '汇兑录入'
     when T1.MIDGROD_TRAN_CODE = 'A68F02' then '往账复核'
     when T1.MIDGROD_TRAN_CODE = 'A68M01' then '往账修改'
     when T1.MIDGROD_TRAN_CODE = 'A68F03' then '往账删除'
     when T1.MIDGROD_TRAN_CODE = 'A68F12' then '普通借记提回冲正'
     when T1.MIDGROD_TRAN_CODE = 'A68M21' then '定期借贷记业务签约'
     when T1.MIDGROD_TRAN_CODE = 'A68F22' then '定期贷记业务复核'
     when T1.MIDGROD_TRAN_CODE = 'A68F23' then '定期借机业务录入'
     when T1.MIDGROD_TRAN_CODE = 'A68F21' then '定期贷记业务录入'
     when T1.MIDGROD_TRAN_CODE = 'A68F24' then '定期借记业务复核'
     when T1.MIDGROD_TRAN_CODE = 'A68F0G' then '来账维护入账'
     when T1.MIDGROD_TRAN_CODE = 'A68F0H' then '维护入账冲账'
     when T1.MIDGROD_TRAN_CODE = 'A68F0I' then '来账挂账转发'
     when T1.MIDGROD_TRAN_CODE = 'A68F0L' then '退汇'
     when T1.MIDGROD_TRAN_CODE = 'A68F0M' then '提回入账失败处理'
     when T1.MIDGROD_TRAN_CODE = 'A68F26' then '定期借记业务导入'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA69803' then 'szfs.803.001.01来账'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA69501' then 'szfs.501.001.01来账'
     when T1.MIDGROD_TRAN_CODE = 'A68F0J' then '来账查询处理-退汇来账重发'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA69FC1' then '来包账务处理'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA69106' then 'szfs.106.001.01来账报文处理'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA69202106' then '实时贷记202人行确认报文来账'
     else '其他'
end                          --交易描述
      ,T1.TRAN_DT                          --交易日期
      ,TO_CHAR(T1.TRAN_TM,'HH24:Mi:SS')                          --交易时间
      ,T2.CURR_CD                          --交易币种代码
      ,T1.TRAN_AMT                          --交易金额
      ,''                          --账户余额
      ,''                          --费用类型代码
      ,''                          --费用金额
      ,CASE WHEN T1.STATUS_CD = '1' THEN '1'
     WHEN T1.STATUS_CD = 'E' THEN '2'
     ELSE '9'
END                          --事件状态代码
      ,''                          --事件冲正类型代码
      ,''                          --协议编号
      ,T1.PAYER_NAME                          --协议全称
      ,T1.PAYER_ACCT_NUM                          --协议所属账号
      ,'SZFS'                          --产品编号
      ,''                          --客户编号
      ,T1.MGMT_ORG_ID                          --交易机构编号
      ,T1.TELLER_ID                          --交易柜员编号
      ,''                          --复核柜员编号
      ,''                          --授权柜员编号
      ,''                          --客户经理编号
      ,''                          --渠道类型代码
      ,''                          --渠道编号
      ,''                          --支付通道类型代码
      ,''                          --交易对手客户编号
      ,T1.RECVER_NAME                          --交易对手名称
      ,''                          --交易对手账户开户行号
      ,''                          --交易对手账户开户行名称
      ,''                          --交易对手账号ID
      ,T1.RECVER_ACCT_NUM                          --交易对手账号
      ,''                          --交易对手机构编号
      ,''                          --交易对手机构名称
      ,''                          --入账日期
      ,''                          --入账时间
      ,''                          --入账机构编号
      ,''                          --入账柜员编号
      ,''                          --入账币种代码
      ,''                          --入账金额
      ,''                          --摘要码
      ,''                          --摘要
      ,''                          --借贷标志
      ,''                          --同城标志
      ,''                          --跨行标志
      ,''                          --境外标志
      ,''                          --现转标志
      ,''                          --发起方类型代码
      ,''                          --主凭证种类代码
      ,''                          --主凭证号码
      ,''                          --副凭证种类代码
      ,''                          --副凭证号码
      ,T1.HOST_FLOW_NUM                          --关联核心系统事件编号
      ,''                          --冲正事件编号
      ,''                          --流程编号
      ,''                          --关联抵质押品编号
      ,''                          --往账标志
      ,''                          --余额方向代码
      ,''                          --余额类型代码
      ,''                          --交易介质名称
      ,''                          --交易介质编号
      ,''                          --业务类型代码
      ,''                          --业务种类代码
      ,''                          --本行发起标志
      ,''                          --旧凭证号码
      ,''                          --协议所属账号2
      ,''                          --协议所属账号3
      ,'MPCS'                          --数据来源代码
--      ,'EVT_MPCS_EVENT_DTL_02'                          --ETL任务名称
      ,to_date('${batch_date}','yyyymmdd')                          --数据日期
--      ,''                          --
--      ,'0'                          --
--      ,''                          --
--      ,''                          --
--      ,''                          --外部科目编号
--      ,''                          --红蓝字标志
--      ,''                          --银行编号
--      ,''                          --银团编号
--      ,''                          --我行出资比例
      ,'21'                           --任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                          --任务处理时间
     FROM ${iml_schema}.EVT_TSZFS_ENTRY_EVT T1--深同城记账事件
INNER JOIN ${iml_schema}.EVT_TSZFS_TRAN_EVT T2--深同城交易事件
       ON T1.BANK_INT_BUS_SEQ_NUM = T2.BANK_INT_BUS_SEQ_NUM
    WHERE T1.MIDGROD_TRAN_CODE ='A68F0G'  --本查询只查
and T1.TRAN_DT = to_date('${batch_date}','yyyymmdd');

commit;


whenever sqlerror exit sql.sqlcode;
--第二十二组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --深同城金融流水表
insert /*+ append(22) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id                       -- 事件编号       
   ,global_chn_seq_num           -- 全局渠道流水号    
   ,prev_global_chn_seq_num      -- 上一全局渠道流水号  
   ,prev_evt_id                  -- 上一事件编号     
   ,evt_typ_cd                   -- 事件类型代码     
   ,menuid                       -- 柜面菜单码      
   ,txn_num                      -- 交易码        
   ,txn_desc                     -- 交易描述       
   ,txn_dt                       -- 交易日期       
   ,txn_tm                       -- 交易时间       
   ,txn_ccy_cd                   -- 交易币种代码     
   ,txn_amt                      -- 交易金额       
   ,acct_bal                     -- 账户余额       
   ,cost_typ_cd                  -- 费用类型代码     
   ,fee_amt                      -- 手续费金额      
   ,evt_status_cd                -- 事件状态代码     
   ,evt_reverse_typ_cd           -- 事件冲正类型代码   
   ,agt_id                       -- 协议编号       
   ,agt_id_name                  -- 协议全称       
   ,agt_blng_acct_num            -- 协议所属账号     
   ,prd_id                       -- 产品编号       
   ,pty_id                       -- 客户编号       
   ,txn_org_id                   -- 交易机构编号     
   ,txn_teller_id                -- 交易柜员编号     
   ,chk_teller_id                -- 复核柜员编号     
   ,auth_teller_id               -- 授权柜员编号     
   ,pty_mgr_id                   -- 客户经理编号     
   ,chn_typ_cd                   -- 渠道类型代码     
   ,chn_id                       -- 渠道编号       
   ,pay_chnl_typ_cd              -- 支付通道类型代码   
   ,cntrpty_id                   -- 交易对手编号     
   ,cntrpty_name                 -- 交易对手名称     
   ,cntrpty_acct_openbk_num      -- 交易对手账户开户行号 
   ,cntrpty_acct_openbk_name     -- 交易对手账户开户行名称
   ,cntrpty_acct_num_id          -- 交易对手账号ID   
   ,cntrpty_acct_num             -- 交易对手账号     
   ,cntrpty_org_id               -- 交易对手机构编号   
   ,cntrpty_org_name             -- 交易对手机构名称   
   ,posting_dt                   -- 入账日期       
   ,posting_tm                   -- 入账时间       
   ,posting_org_id               -- 入账机构编号     
   ,posting_teller_id            -- 入账柜员编号     
   ,posting_ccy_cd               -- 入账币种代码     
   ,posting_amt                  -- 入账金额       
   ,memo_cd                      -- 摘要码        
   ,memo                         -- 摘要         
   ,db_cr_dir_cd                 -- 借贷标志       
   ,city_flg                     -- 同城标志       
   ,crossb_flg                   -- 跨行标志       
   ,ovsea_flg                    -- 境外标志       
   ,cash_tfr_flg                 -- 现转标志       
   ,initor_typ_cd                -- 发起方类型代码    
   ,prim_vchr_type_cd            -- 主凭证种类代码    
   ,prim_vchr_num                -- 主凭证号码      
   ,scd_vchr_type_cd             -- 副凭证种类代码    
   ,scd_vchr_num                 -- 副凭证号码      
   ,assoc_bcs_evt_id             -- 关联核心系统事件编号 
   ,reverse_evt_id               -- 冲正事件编号     
   ,flow_id                      -- 流程编号       
   ,assoc_coll_id                -- 关联抵质押品编号   
   ,nostro_flg                   -- 往账标志       
   ,bal_dir_cd                   -- 余额方向代码     
   ,bal_typ_cd                   -- 余额类型代码     
   ,txn_med_name                 -- 交易介质名称     
   ,txn_med_id                   -- 交易介质编号     
   ,biz_typ_cd                   -- 业务类型代码     
   ,biz_cate_cd                  -- 业务种类代码     
   ,ghb_init_flg                 -- 本行发起标志     
   ,old_vchr_num                 -- 旧凭证号码      
   ,agt_blng_acct_num2           -- 协议所属账号2    
   ,agt_blng_acct_num3           -- 协议所属账号3    
   ,data_src_cd                  -- 数据来源代码     
   ,etl_dt                       -- 数据日期       
   ,job_cd                       -- 任务代码       
   ,etl_timestamp                -- 任务处理时间     
)
select 'L121'||TO_CHAR(T1.TRAN_DT,'YYYYMMDD')||T1.MIDGROD_FLOW_NUM                          --业务系统事件编号
      ,''                          --全局渠道流水号
      ,''                          --上一全局渠道流水号
      ,''                          --上一事件编号
      ,'L121'                          --事件类型代码
      ,''                          --柜面菜单码
      ,T1.MIDGROD_TRAN_CODE                          --交易码
      ,case when T1.MIDGROD_TRAN_CODE = 'A68F01' then '汇兑录入'
     when T1.MIDGROD_TRAN_CODE = 'A68F02' then '往账复核'
     when T1.MIDGROD_TRAN_CODE = 'A68M01' then '往账修改'
     when T1.MIDGROD_TRAN_CODE = 'A68F03' then '往账删除'
     when T1.MIDGROD_TRAN_CODE = 'A68F12' then '普通借记提回冲正'
     when T1.MIDGROD_TRAN_CODE = 'A68M21' then '定期借贷记业务签约'
     when T1.MIDGROD_TRAN_CODE = 'A68F22' then '定期贷记业务复核'
     when T1.MIDGROD_TRAN_CODE = 'A68F23' then '定期借机业务录入'
     when T1.MIDGROD_TRAN_CODE = 'A68F21' then '定期贷记业务录入'
     when T1.MIDGROD_TRAN_CODE = 'A68F24' then '定期借记业务复核'
     when T1.MIDGROD_TRAN_CODE = 'A68F0G' then '来账维护入账'
     when T1.MIDGROD_TRAN_CODE = 'A68F0H' then '维护入账冲账'
     when T1.MIDGROD_TRAN_CODE = 'A68F0I' then '来账挂账转发'
     when T1.MIDGROD_TRAN_CODE = 'A68F0L' then '退汇'
     when T1.MIDGROD_TRAN_CODE = 'A68F0M' then '提回入账失败处理'
     when T1.MIDGROD_TRAN_CODE = 'A68F26' then '定期借记业务导入'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA69803' then 'szfs.803.001.01来账'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA69501' then 'szfs.501.001.01来账'
     when T1.MIDGROD_TRAN_CODE = 'A68F0J' then '来账查询处理-退汇来账重发'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA69FC1' then '来包账务处理'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA69106' then 'szfs.106.001.01来账报文处理'
     when T1.MIDGROD_TRAN_CODE = 'ZTSA69202106' then '实时贷记202人行确认报文来账'
     else '其他'
end                          --交易描述
      ,T1.TRAN_DT                          --交易日期
      ,TO_CHAR(T1.TRAN_TM,'HH24:Mi:SS')                          --交易时间
      ,'CNY'                          --交易币种代码
      ,T1.TRAN_AMT                          --交易金额
      ,''                          --账户余额
      ,''                          --费用类型代码
      ,''                          --费用金额
      ,CASE WHEN STATUS_CD = '1' THEN '1'
     WHEN T1.STATUS_CD = 'E' THEN '2'
     ELSE '9'
END                          --事件状态代码
      ,''                          --事件冲正类型代码
      ,''                          --协议编号
      ,T1.PAYER_NAME                          --协议全称
      ,T1.PAYER_ACCT_NUM                          --协议所属账号
      ,'SZFS'                          --产品编号
      ,''                          --客户编号
      ,T1.MGMT_ORG_ID                          --交易机构编号
      ,T1.TELLER_ID                          --交易柜员编号
      ,''                          --复核柜员编号
      ,''                          --授权柜员编号
      ,''                          --客户经理编号
      ,''                          --渠道类型代码
      ,''                          --渠道编号
      ,''                          --支付通道类型代码
      ,''                          --交易对手客户编号
      ,T1.RECVER_NAME                          --交易对手名称
      ,''                          --交易对手账户开户行号
      ,''                          --交易对手账户开户行名称
      ,''                          --交易对手账号ID
      ,T1.RECVER_ACCT_NUM                          --交易对手账号
      ,''                          --交易对手机构编号
      ,''                          --交易对手机构名称
      ,''                          --入账日期
      ,''                          --入账时间
      ,''                          --入账机构编号
      ,''                          --入账柜员编号
      ,''                          --入账币种代码
      ,''                          --入账金额
      ,''                          --摘要码
      ,''                          --摘要
      ,''                          --借贷标志
      ,''                          --同城标志
      ,''                          --跨行标志
      ,''                          --境外标志
      ,''                          --现转标志
      ,''                          --发起方类型代码
      ,''                          --主凭证种类代码
      ,''                          --主凭证号码
      ,''                          --副凭证种类代码
      ,''                          --副凭证号码
      ,T1.HOST_FLOW_NUM                          --关联核心系统事件编号
      ,''                          --冲正事件编号
      ,''                          --流程编号
      ,''                          --关联抵质押品编号
      ,''                          --往账标志
      ,''                          --余额方向代码
      ,''                          --余额类型代码
      ,''                          --交易介质名称
      ,''                          --交易介质编号
      ,''                          --业务类型代码
      ,''                          --业务种类代码
      ,''                          --本行发起标志
      ,''                          --旧凭证号码
      ,''                          --协议所属账号2
      ,''                          --协议所属账号3
      ,'MPCS'                          --数据来源代码
--      ,'EVT_MPCS_EVENT_DTL_02'                          --ETL任务名称
      ,to_date('${batch_date}','yyyymmdd')                          --数据日期
--      ,''                          --
--      ,'0'                          --
--      ,''                          --
--      ,''                          --
--      ,''                          --外部科目编号
--      ,''                          --红蓝字标志
--      ,''                          --银行编号
--      ,''                          --银团编号
--      ,''                          --我行出资比例
      ,'22'                           --任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                          --任务处理时间
     FROM ${iml_schema}.EVT_TSZFS_ENTRY_EVT T1--深同城记账事件
    WHERE T1.MIDGROD_TRAN_CODE <> 'A68F0G'  --本查询只查
and T1.TRAN_DT = to_date('${batch_date}','yyyymmdd');

commit;

--第二十三组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑   --深同城查询查复表      --该业务已下线
--第二十四组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑   --深同城自由格式        --该业务已下线
--第二十五组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑   --深同城定期贷借记业务  --该业务已下线
--第二十六组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑   --SD开户                --该业务已下线


whenever sqlerror exit sql.sqlcode;
--第二十七组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --A63M52银企直连签约与维护
insert /*+ append(27) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id                       -- 事件编号       
   ,global_chn_seq_num           -- 全局渠道流水号    
   ,prev_global_chn_seq_num      -- 上一全局渠道流水号  
   ,prev_evt_id                  -- 上一事件编号     
   ,evt_typ_cd                   -- 事件类型代码     
   ,menuid                       -- 柜面菜单码      
   ,txn_num                      -- 交易码        
   ,txn_desc                     -- 交易描述       
   ,txn_dt                       -- 交易日期       
   ,txn_tm                       -- 交易时间       
   ,txn_ccy_cd                   -- 交易币种代码     
   ,txn_amt                      -- 交易金额       
   ,acct_bal                     -- 账户余额       
   ,cost_typ_cd                  -- 费用类型代码     
   ,fee_amt                      -- 手续费金额      
   ,evt_status_cd                -- 事件状态代码     
   ,evt_reverse_typ_cd           -- 事件冲正类型代码   
   ,agt_id                       -- 协议编号       
   ,agt_id_name                  -- 协议全称       
   ,agt_blng_acct_num            -- 协议所属账号     
   ,prd_id                       -- 产品编号       
   ,pty_id                       -- 客户编号       
   ,txn_org_id                   -- 交易机构编号     
   ,txn_teller_id                -- 交易柜员编号     
   ,chk_teller_id                -- 复核柜员编号     
   ,auth_teller_id               -- 授权柜员编号     
   ,pty_mgr_id                   -- 客户经理编号     
   ,chn_typ_cd                   -- 渠道类型代码     
   ,chn_id                       -- 渠道编号       
   ,pay_chnl_typ_cd              -- 支付通道类型代码   
   ,cntrpty_id                   -- 交易对手编号     
   ,cntrpty_name                 -- 交易对手名称     
   ,cntrpty_acct_openbk_num      -- 交易对手账户开户行号 
   ,cntrpty_acct_openbk_name     -- 交易对手账户开户行名称
   ,cntrpty_acct_num_id          -- 交易对手账号ID   
   ,cntrpty_acct_num             -- 交易对手账号     
   ,cntrpty_org_id               -- 交易对手机构编号   
   ,cntrpty_org_name             -- 交易对手机构名称   
   ,posting_dt                   -- 入账日期       
   ,posting_tm                   -- 入账时间       
   ,posting_org_id               -- 入账机构编号     
   ,posting_teller_id            -- 入账柜员编号     
   ,posting_ccy_cd               -- 入账币种代码     
   ,posting_amt                  -- 入账金额       
   ,memo_cd                      -- 摘要码        
   ,memo                         -- 摘要         
   ,db_cr_dir_cd                 -- 借贷标志       
   ,city_flg                     -- 同城标志       
   ,crossb_flg                   -- 跨行标志       
   ,ovsea_flg                    -- 境外标志       
   ,cash_tfr_flg                 -- 现转标志       
   ,initor_typ_cd                -- 发起方类型代码    
   ,prim_vchr_type_cd            -- 主凭证种类代码    
   ,prim_vchr_num                -- 主凭证号码      
   ,scd_vchr_type_cd             -- 副凭证种类代码    
   ,scd_vchr_num                 -- 副凭证号码      
   ,assoc_bcs_evt_id             -- 关联核心系统事件编号 
   ,reverse_evt_id               -- 冲正事件编号     
   ,flow_id                      -- 流程编号       
   ,assoc_coll_id                -- 关联抵质押品编号   
   ,nostro_flg                   -- 往账标志       
   ,bal_dir_cd                   -- 余额方向代码     
   ,bal_typ_cd                   -- 余额类型代码     
   ,txn_med_name                 -- 交易介质名称     
   ,txn_med_id                   -- 交易介质编号     
   ,biz_typ_cd                   -- 业务类型代码     
   ,biz_cate_cd                  -- 业务种类代码     
   ,ghb_init_flg                 -- 本行发起标志     
   ,old_vchr_num                 -- 旧凭证号码      
   ,agt_blng_acct_num2           -- 协议所属账号2    
   ,agt_blng_acct_num3           -- 协议所属账号3    
   ,data_src_cd                  -- 数据来源代码     
   ,etl_dt                       -- 数据日期       
   ,job_cd                       -- 任务代码       
   ,etl_timestamp                -- 任务处理时间     
)
select 'L125'||T1.SIGN_ID                          --业务系统事件编号
      ,''                          --全局渠道流水号
      ,''                          --上一全局渠道流水号
      ,''                          --上一事件编号
      ,'L125'                          --事件类型代码
      ,''                          --柜面菜单码
      ,'A63M52'                          --交易码
      ,'银企直连签约维护'                          --交易描述
      ,T1.SIGN_DT                          --交易日期
      ,''                          --交易时间
      ,''                          --交易币种代码
      ,''                          --交易金额
      ,''                          --账户余额
      ,''                          --费用类型代码
      ,''                          --费用金额
      ,CASE WHEN T1.STATUS_CD = '0' THEN '1'
     ELSE '9'
END                          --事件状态代码
      ,''                          --事件冲正类型代码
      ,''                          --协议编号
      ,''                          --协议全称
      ,''                          --协议所属账号
      ,'A63'                          --产品编号
      ,''                          --客户编号
      ,T1.CUST_OPEN_ACCT_ORG_ID                          --交易机构编号
      ,''                          --交易柜员编号
      ,''                          --复核柜员编号
      ,''                          --授权柜员编号
      ,''                          --客户经理编号
      ,'2204'                          --渠道类型代码
      ,''                          --渠道编号
      ,''                          --支付通道类型代码
      ,''                          --交易对手客户编号
      ,''                          --交易对手名称
      ,''                          --交易对手账户开户行号
      ,''                          --交易对手账户开户行名称
      ,''                          --交易对手账号ID
      ,''                          --交易对手账号
      ,''                          --交易对手机构编号
      ,''                          --交易对手机构名称
      ,''                          --入账日期
      ,''                          --入账时间
      ,''                          --入账机构编号
      ,''                          --入账柜员编号
      ,''                          --入账币种代码
      ,''                          --入账金额
      ,''                          --摘要码
      ,''                          --摘要
      ,''                          --借贷标志
      ,''                          --同城标志
      ,''                          --跨行标志
      ,''                          --境外标志
      ,''                          --现转标志
      ,''                          --发起方类型代码
      ,''                          --主凭证种类代码
      ,''                          --主凭证号码
      ,''                          --副凭证种类代码
      ,''                          --副凭证号码
      ,''                          --关联核心系统事件编号
      ,''                          --冲正事件编号
      ,''                          --流程编号
      ,''                          --关联抵质押品编号
      ,''                          --往账标志
      ,''                          --余额方向代码
      ,''                          --余额类型代码
      ,''                          --交易介质名称
      ,''                          --交易介质编号
      ,''                          --业务类型代码
      ,''                          --业务种类代码
      ,''                          --本行发起标志
      ,''                          --旧凭证号码
      ,''                          --协议所属账号2
      ,''                          --协议所属账号3
      ,'MPCS'                          --数据来源代码
--      ,'EVT_MPCS_EVENT_DTL_02'                          --ETL任务名称
      ,to_date('${batch_date}','yyyymmdd')                          --数据日期
--      ,''                          --
--      ,'0'                          --
--      ,''                          --
--      ,''                          --
--      ,''                          --外部科目编号
--      ,''                          --红蓝字标志
--      ,''                          --银行编号
--      ,''                          --银团编号
--      ,''                          --我行出资比例
      ,'27'                           --任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                          --任务处理时间
     FROM ${iml_schema}.AGT_BCDL_CUST_SIGN_INFO T1--银企直联客户签约信息
    WHERE T1.SIGN_DT = to_date('${batch_date}','yyyymmdd')
AND T1.CREATE_DT <= to_date('${batch_date}','yyyymmdd')
AND T1.JOB_CD = 'mpcsf1'
AND T1.SRC_TABLE_NAME = 'mpcs_a63tcust';

commit;


whenever sqlerror exit sql.sqlcode;
--第二十八组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --A09F01受托支付
insert /*+ append(28) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id                       -- 事件编号       
   ,global_chn_seq_num           -- 全局渠道流水号    
   ,prev_global_chn_seq_num      -- 上一全局渠道流水号  
   ,prev_evt_id                  -- 上一事件编号     
   ,evt_typ_cd                   -- 事件类型代码     
   ,menuid                       -- 柜面菜单码      
   ,txn_num                      -- 交易码        
   ,txn_desc                     -- 交易描述       
   ,txn_dt                       -- 交易日期       
   ,txn_tm                       -- 交易时间       
   ,txn_ccy_cd                   -- 交易币种代码     
   ,txn_amt                      -- 交易金额       
   ,acct_bal                     -- 账户余额       
   ,cost_typ_cd                  -- 费用类型代码     
   ,fee_amt                      -- 手续费金额      
   ,evt_status_cd                -- 事件状态代码     
   ,evt_reverse_typ_cd           -- 事件冲正类型代码   
   ,agt_id                       -- 协议编号       
   ,agt_id_name                  -- 协议全称       
   ,agt_blng_acct_num            -- 协议所属账号     
   ,prd_id                       -- 产品编号       
   ,pty_id                       -- 客户编号       
   ,txn_org_id                   -- 交易机构编号     
   ,txn_teller_id                -- 交易柜员编号     
   ,chk_teller_id                -- 复核柜员编号     
   ,auth_teller_id               -- 授权柜员编号     
   ,pty_mgr_id                   -- 客户经理编号     
   ,chn_typ_cd                   -- 渠道类型代码     
   ,chn_id                       -- 渠道编号       
   ,pay_chnl_typ_cd              -- 支付通道类型代码   
   ,cntrpty_id                   -- 交易对手编号     
   ,cntrpty_name                 -- 交易对手名称     
   ,cntrpty_acct_openbk_num      -- 交易对手账户开户行号 
   ,cntrpty_acct_openbk_name     -- 交易对手账户开户行名称
   ,cntrpty_acct_num_id          -- 交易对手账号ID   
   ,cntrpty_acct_num             -- 交易对手账号     
   ,cntrpty_org_id               -- 交易对手机构编号   
   ,cntrpty_org_name             -- 交易对手机构名称   
   ,posting_dt                   -- 入账日期       
   ,posting_tm                   -- 入账时间       
   ,posting_org_id               -- 入账机构编号     
   ,posting_teller_id            -- 入账柜员编号     
   ,posting_ccy_cd               -- 入账币种代码     
   ,posting_amt                  -- 入账金额       
   ,memo_cd                      -- 摘要码        
   ,memo                         -- 摘要         
   ,db_cr_dir_cd                 -- 借贷标志       
   ,city_flg                     -- 同城标志       
   ,crossb_flg                   -- 跨行标志       
   ,ovsea_flg                    -- 境外标志       
   ,cash_tfr_flg                 -- 现转标志       
   ,initor_typ_cd                -- 发起方类型代码    
   ,prim_vchr_type_cd            -- 主凭证种类代码    
   ,prim_vchr_num                -- 主凭证号码      
   ,scd_vchr_type_cd             -- 副凭证种类代码    
   ,scd_vchr_num                 -- 副凭证号码      
   ,assoc_bcs_evt_id             -- 关联核心系统事件编号 
   ,reverse_evt_id               -- 冲正事件编号     
   ,flow_id                      -- 流程编号       
   ,assoc_coll_id                -- 关联抵质押品编号   
   ,nostro_flg                   -- 往账标志       
   ,bal_dir_cd                   -- 余额方向代码     
   ,bal_typ_cd                   -- 余额类型代码     
   ,txn_med_name                 -- 交易介质名称     
   ,txn_med_id                   -- 交易介质编号     
   ,biz_typ_cd                   -- 业务类型代码     
   ,biz_cate_cd                  -- 业务种类代码     
   ,ghb_init_flg                 -- 本行发起标志     
   ,old_vchr_num                 -- 旧凭证号码      
   ,agt_blng_acct_num2           -- 协议所属账号2    
   ,agt_blng_acct_num3           -- 协议所属账号3    
   ,data_src_cd                  -- 数据来源代码     
   ,etl_dt                       -- 数据日期       
   ,job_cd                       -- 任务代码       
   ,etl_timestamp                -- 任务处理时间     
)
select 'L126'||T1.SEQNO                          --业务系统事件编号
      ,''                          --全局渠道流水号
      ,''                          --上一全局渠道流水号
      ,''                          --上一事件编号
      ,'L126'                          --事件类型代码
      ,''                          --柜面菜单码
      ,CASE WHEN T1.TRNCD = 'a09f01' THEN 'A09F01' END                          --交易码
      ,CASE WHEN T1.TRNCD IN ('a09f01','A09F01') THEN '受托支付' ELSE '其他' END                          --交易描述
      ,TO_DATE(T1.OPDT,'YYYY-MM-DD')                          --交易日期
      ,SUBSTR(T1.TRNTM,1,2)||':'||SUBSTR(T1.TRNTM,3,2)||':'||SUBSTR(T1.TRNTM,5,2)                          --交易时间
      ,T1.CCY                          --交易币种代码
      ,T1.TRNAMT                          --交易金额
      ,''                          --账户余额
      ,''                          --费用类型代码
      ,''                          --费用金额
      ,CASE WHEN T1.TRNSTAT = '0' THEN '1'
     ELSE '9'
END                          --事件状态代码
      ,''                          --事件冲正类型代码
      ,''                          --协议编号
      ,T1.PAYNAME                          --协议全称
      ,T1.PAYACCT                          --协议所属账号
      ,T1.PRODCD                          --产品编号
      ,''                          --客户编号
      ,T1.MAGEBRN                          --交易机构编号
      ,T1.TLRNO                          --交易柜员编号
      ,T1.CHKTLRNO                          --复核柜员编号
      ,T1.AUTHTLRNO                          --授权柜员编号
      ,''                          --客户经理编号
      ,'2204'                          --渠道类型代码
      ,''                          --渠道编号
      ,''                          --支付通道类型代码
      ,''                          --交易对手客户编号
      ,T1.INCONAME                          --交易对手名称
      ,''                          --交易对手账户开户行号
      ,''                          --交易对手账户开户行名称
      ,''                          --交易对手账号ID
      ,T1.INCOACCT                          --交易对手账号
      ,''                          --交易对手机构编号
      ,''                          --交易对手机构名称
      ,''                          --入账日期
      ,''                          --入账时间
      ,''                          --入账机构编号
      ,''                          --入账柜员编号
      ,''                          --入账币种代码
      ,''                          --入账金额
      ,''                          --摘要码
      ,''                          --摘要
      ,''                          --借贷标志
      ,''                          --同城标志
      ,''                          --跨行标志
      ,''                          --境外标志
      ,''                          --现转标志
      ,''                          --发起方类型代码
      ,''                          --主凭证种类代码
      ,''                          --主凭证号码
      ,''                          --副凭证种类代码
      ,''                          --副凭证号码
      ,''                          --关联核心系统事件编号
      ,''                          --冲正事件编号
      ,''                          --流程编号
      ,''                          --关联抵质押品编号
      ,''                          --往账标志
      ,''                          --余额方向代码
      ,''                          --余额类型代码
      ,''                          --交易介质名称
      ,''                          --交易介质编号
      ,''                          --业务类型代码
      ,''                          --业务种类代码
      ,''                          --本行发起标志
      ,''                          --旧凭证号码
      ,''                          --协议所属账号2
      ,''                          --协议所属账号3
      ,'MPCS'                          --数据来源代码
--      ,'EVT_MPCS_EVENT_DTL_02'                          --ETL任务名称
      ,to_date('${batch_date}','yyyymmdd')                          --数据日期
--      ,''                          --
--      ,'0'                          --
--      ,''                          --
--      ,''                          --
--      ,''                          --外部科目编号
--      ,''                          --红蓝字标志
--      ,''                          --银行编号
--      ,''                          --银团编号
--      ,''                          --我行出资比例
      ,'28'                           --任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                          --任务处理时间
     FROM ${iol_schema}.MPCS_A09TENTRUSTEDPAYLOG T1--
    WHERE T1.OPDT = '${batch_date}';

commit;


--第二十九组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑   --银行代理缴费查询登记簿  --该业务已下线


whenever sqlerror exit sql.sqlcode;
--第三十组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --网银互联A10M31自由格式报文发送
insert /*+ append(30) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id                       -- 事件编号       
   ,global_chn_seq_num           -- 全局渠道流水号    
   ,prev_global_chn_seq_num      -- 上一全局渠道流水号  
   ,prev_evt_id                  -- 上一事件编号     
   ,evt_typ_cd                   -- 事件类型代码     
   ,menuid                       -- 柜面菜单码      
   ,txn_num                      -- 交易码        
   ,txn_desc                     -- 交易描述       
   ,txn_dt                       -- 交易日期       
   ,txn_tm                       -- 交易时间       
   ,txn_ccy_cd                   -- 交易币种代码     
   ,txn_amt                      -- 交易金额       
   ,acct_bal                     -- 账户余额       
   ,cost_typ_cd                  -- 费用类型代码     
   ,fee_amt                      -- 手续费金额      
   ,evt_status_cd                -- 事件状态代码     
   ,evt_reverse_typ_cd           -- 事件冲正类型代码   
   ,agt_id                       -- 协议编号       
   ,agt_id_name                  -- 协议全称       
   ,agt_blng_acct_num            -- 协议所属账号     
   ,prd_id                       -- 产品编号       
   ,pty_id                       -- 客户编号       
   ,txn_org_id                   -- 交易机构编号     
   ,txn_teller_id                -- 交易柜员编号     
   ,chk_teller_id                -- 复核柜员编号     
   ,auth_teller_id               -- 授权柜员编号     
   ,pty_mgr_id                   -- 客户经理编号     
   ,chn_typ_cd                   -- 渠道类型代码     
   ,chn_id                       -- 渠道编号       
   ,pay_chnl_typ_cd              -- 支付通道类型代码   
   ,cntrpty_id                   -- 交易对手编号     
   ,cntrpty_name                 -- 交易对手名称     
   ,cntrpty_acct_openbk_num      -- 交易对手账户开户行号 
   ,cntrpty_acct_openbk_name     -- 交易对手账户开户行名称
   ,cntrpty_acct_num_id          -- 交易对手账号ID   
   ,cntrpty_acct_num             -- 交易对手账号     
   ,cntrpty_org_id               -- 交易对手机构编号   
   ,cntrpty_org_name             -- 交易对手机构名称   
   ,posting_dt                   -- 入账日期       
   ,posting_tm                   -- 入账时间       
   ,posting_org_id               -- 入账机构编号     
   ,posting_teller_id            -- 入账柜员编号     
   ,posting_ccy_cd               -- 入账币种代码     
   ,posting_amt                  -- 入账金额       
   ,memo_cd                      -- 摘要码        
   ,memo                         -- 摘要         
   ,db_cr_dir_cd                 -- 借贷标志       
   ,city_flg                     -- 同城标志       
   ,crossb_flg                   -- 跨行标志       
   ,ovsea_flg                    -- 境外标志       
   ,cash_tfr_flg                 -- 现转标志       
   ,initor_typ_cd                -- 发起方类型代码    
   ,prim_vchr_type_cd            -- 主凭证种类代码    
   ,prim_vchr_num                -- 主凭证号码      
   ,scd_vchr_type_cd             -- 副凭证种类代码    
   ,scd_vchr_num                 -- 副凭证号码      
   ,assoc_bcs_evt_id             -- 关联核心系统事件编号 
   ,reverse_evt_id               -- 冲正事件编号     
   ,flow_id                      -- 流程编号       
   ,assoc_coll_id                -- 关联抵质押品编号   
   ,nostro_flg                   -- 往账标志       
   ,bal_dir_cd                   -- 余额方向代码     
   ,bal_typ_cd                   -- 余额类型代码     
   ,txn_med_name                 -- 交易介质名称     
   ,txn_med_id                   -- 交易介质编号     
   ,biz_typ_cd                   -- 业务类型代码     
   ,biz_cate_cd                  -- 业务种类代码     
   ,ghb_init_flg                 -- 本行发起标志     
   ,old_vchr_num                 -- 旧凭证号码      
   ,agt_blng_acct_num2           -- 协议所属账号2    
   ,agt_blng_acct_num3           -- 协议所属账号3    
   ,data_src_cd                  -- 数据来源代码     
   ,etl_dt                       -- 数据日期       
   ,job_cd                       -- 任务代码       
   ,etl_timestamp                -- 任务处理时间     
)
select 'L128'||T1.INTRACE||T1.NODE                          --业务系统事件编号
      ,''                          --全局渠道流水号
      ,''                          --上一全局渠道流水号
      ,''                          --上一事件编号
      ,'L128'                          --事件类型代码
      ,''                          --柜面菜单码
      ,'A10M31'                          --交易码
      ,'网银互联自由格式报文发送'                          --交易描述
      ,TO_DATE(SUBSTR(T1.INTRACE,1,8),'YYYY-MM-DD')                          --交易日期
      ,SUBSTR(T1.MSGTIME,9,2)||':'||SUBSTR(T1.MSGTIME,11,2)||':'||SUBSTR(T1.MSGTIME,13,2)                          --交易时间
      ,''                          --交易币种代码
      ,''                          --交易金额
      ,''                          --账户余额
      ,''                          --费用类型代码
      ,''                          --费用金额
      ,CASE WHEN T1.STATUS IN ('2','9') THEN '1'
     ELSE '9'
END                          --事件状态代码
      ,''                          --事件冲正类型代码
      ,''                          --协议编号
      ,''                          --协议全称
      ,''                          --协议所属账号
      ,'IBPS'                          --产品编号
      ,''                          --客户编号
      ,T1.NODE                          --交易机构编号
      ,T1.OPERNO1                          --交易柜员编号
      ,T1.OPERNO2                          --复核柜员编号
      ,''                          --授权柜员编号
      ,''                          --客户经理编号
      ,''                          --渠道类型代码
      ,''                          --渠道编号
      ,'05'                          --支付通道类型代码
      ,''                          --交易对手客户编号
      ,''                          --交易对手名称
      ,''                          --交易对手账户开户行号
      ,''                          --交易对手账户开户行名称
      ,''                          --交易对手账号ID
      ,''                          --交易对手账号
      ,''                          --交易对手机构编号
      ,''                          --交易对手机构名称
      ,''                          --入账日期
      ,''                          --入账时间
      ,''                          --入账机构编号
      ,''                          --入账柜员编号
      ,''                          --入账币种代码
      ,''                          --入账金额
      ,''                          --摘要码
      ,''                          --摘要
      ,''                          --借贷标志
      ,''                          --同城标志
      ,''                          --跨行标志
      ,''                          --境外标志
      ,''                          --现转标志
      ,''                          --发起方类型代码
      ,''                          --主凭证种类代码
      ,''                          --主凭证号码
      ,''                          --副凭证种类代码
      ,''                          --副凭证号码
      ,''                          --关联核心系统事件编号
      ,''                          --冲正事件编号
      ,''                          --流程编号
      ,''                          --关联抵质押品编号
      ,''                          --往账标志
      ,''                          --余额方向代码
      ,''                          --余额类型代码
      ,''                          --交易介质名称
      ,''                          --交易介质编号
      ,''                          --业务类型代码
      ,''                          --业务种类代码
      ,''                          --本行发起标志
      ,''                          --旧凭证号码
      ,''                          --协议所属账号2
      ,''                          --协议所属账号3
      ,'MPCS'                          --数据来源代码
--      ,'EVT_MPCS_EVENT_DTL_02'                          --ETL任务名称
      ,to_date('${batch_date}','yyyymmdd')                          --数据日期
--      ,''                          --
--      ,'0'                          --
--      ,''                          --
--      ,''                          --
--      ,''                          --外部科目编号
--      ,''                          --红蓝字标志
--      ,''                          --银行编号
--      ,''                          --银团编号
--      ,''                          --我行出资比例
      ,'30'                           --任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                          --任务处理时间
     FROM ${iol_schema}.MPCS_A10TIBPSMSGLOG T1--
    WHERE SUBSTR(T1.INTRACE,1,8) = '${batch_date}';

commit;


--第三十一组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑   --网银互联A10M31自由格式报文发送  --该业务已下线


whenever sqlerror exit sql.sqlcode;
--第三十二组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --盈米交易流水
insert /*+ append(32) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id                       -- 事件编号       
   ,global_chn_seq_num           -- 全局渠道流水号    
   ,prev_global_chn_seq_num      -- 上一全局渠道流水号  
   ,prev_evt_id                  -- 上一事件编号     
   ,evt_typ_cd                   -- 事件类型代码     
   ,menuid                       -- 柜面菜单码      
   ,txn_num                      -- 交易码        
   ,txn_desc                     -- 交易描述       
   ,txn_dt                       -- 交易日期       
   ,txn_tm                       -- 交易时间       
   ,txn_ccy_cd                   -- 交易币种代码     
   ,txn_amt                      -- 交易金额       
   ,acct_bal                     -- 账户余额       
   ,cost_typ_cd                  -- 费用类型代码     
   ,fee_amt                      -- 手续费金额      
   ,evt_status_cd                -- 事件状态代码     
   ,evt_reverse_typ_cd           -- 事件冲正类型代码   
   ,agt_id                       -- 协议编号       
   ,agt_id_name                  -- 协议全称       
   ,agt_blng_acct_num            -- 协议所属账号     
   ,prd_id                       -- 产品编号       
   ,pty_id                       -- 客户编号       
   ,txn_org_id                   -- 交易机构编号     
   ,txn_teller_id                -- 交易柜员编号     
   ,chk_teller_id                -- 复核柜员编号     
   ,auth_teller_id               -- 授权柜员编号     
   ,pty_mgr_id                   -- 客户经理编号     
   ,chn_typ_cd                   -- 渠道类型代码     
   ,chn_id                       -- 渠道编号       
   ,pay_chnl_typ_cd              -- 支付通道类型代码   
   ,cntrpty_id                   -- 交易对手编号     
   ,cntrpty_name                 -- 交易对手名称     
   ,cntrpty_acct_openbk_num      -- 交易对手账户开户行号 
   ,cntrpty_acct_openbk_name     -- 交易对手账户开户行名称
   ,cntrpty_acct_num_id          -- 交易对手账号ID   
   ,cntrpty_acct_num             -- 交易对手账号     
   ,cntrpty_org_id               -- 交易对手机构编号   
   ,cntrpty_org_name             -- 交易对手机构名称   
   ,posting_dt                   -- 入账日期       
   ,posting_tm                   -- 入账时间       
   ,posting_org_id               -- 入账机构编号     
   ,posting_teller_id            -- 入账柜员编号     
   ,posting_ccy_cd               -- 入账币种代码     
   ,posting_amt                  -- 入账金额       
   ,memo_cd                      -- 摘要码        
   ,memo                         -- 摘要         
   ,db_cr_dir_cd                 -- 借贷标志       
   ,city_flg                     -- 同城标志       
   ,crossb_flg                   -- 跨行标志       
   ,ovsea_flg                    -- 境外标志       
   ,cash_tfr_flg                 -- 现转标志       
   ,initor_typ_cd                -- 发起方类型代码    
   ,prim_vchr_type_cd            -- 主凭证种类代码    
   ,prim_vchr_num                -- 主凭证号码      
   ,scd_vchr_type_cd             -- 副凭证种类代码    
   ,scd_vchr_num                 -- 副凭证号码      
   ,assoc_bcs_evt_id             -- 关联核心系统事件编号 
   ,reverse_evt_id               -- 冲正事件编号     
   ,flow_id                      -- 流程编号       
   ,assoc_coll_id                -- 关联抵质押品编号   
   ,nostro_flg                   -- 往账标志       
   ,bal_dir_cd                   -- 余额方向代码     
   ,bal_typ_cd                   -- 余额类型代码     
   ,txn_med_name                 -- 交易介质名称     
   ,txn_med_id                   -- 交易介质编号     
   ,biz_typ_cd                   -- 业务类型代码     
   ,biz_cate_cd                  -- 业务种类代码     
   ,ghb_init_flg                 -- 本行发起标志     
   ,old_vchr_num                 -- 旧凭证号码      
   ,agt_blng_acct_num2           -- 协议所属账号2    
   ,agt_blng_acct_num3           -- 协议所属账号3    
   ,data_src_cd                  -- 数据来源代码     
   ,etl_dt                       -- 数据日期       
   ,job_cd                       -- 任务代码       
   ,etl_timestamp                -- 任务处理时间     
)
SELECT
a.brokerorderno               业务系统事件编号
,''              全局渠道流水号
,''              上一全局渠道流水号
,''              上一事件编号
,'L200'              事件类型代码
,''              柜面菜单码
,a.trantype              交易码
,case
    when a.trantype ='1' Then '基金购买'
    When a.trantype='2' Then '基金赎回'
    When a.trantype='3' Then '基金转换'
    When a.trantype='4' Then '基金定投扣款'
    When a.trantype='5' Then '设置分红方式'
    else ''
End              交易描述
,to_date(TO_CHAR(to_timestamp(substr(a.transtime,1,8),'YYYYMMDD'),'YYYY-MM-DD'),'YYYY-MM-DD')              交易日期
,TO_CHAR(to_timestamp(substr(a.transtime,9,6),'HH24MISS'),'HH24:MI:SS')              交易时间
,a.ccy              交易币种代码
,trim(a.amount)              交易金额
,''              账户余额
,''              费用类型代码
,''              费用金额
,case
    When a.finalstatus In ('2','3','4') Then '1'
    When a.finalstatus In ('1') Then '2'
    When a.cdflg ='4' Then '2'
    When a.status In ('2','4') Then '2'
     else '9'
End              事件状态代码
,''              事件冲正类型代码
,a.customno              协议编号
,case
    When a.trantype='2'          Then a.payeename
    When a.trantype In ('1','4') Then a.payername
     else ''
End              协议全称
,case
    When a.trantype='2'          Then a.payeeacct
    When a.trantype In ('1','4') Then a.payeracct
    else ''
End              协议所属账号
,a.fundcode              产品编号
,a.customno              客户编号
,nvl(trim(a.payeropbk),'800001')              交易机构编号
,''              交易柜员编号
,''              复核柜员编号
,''              授权柜员编号
,''              客户经理编号
,case
    When a.channel ='NMB' Then '1007'
    When a.channel ='EBK' Then '1006'
    else '1030'
End              渠道类型代码
,a.channel              渠道编号
,'01'              支付通道类型代码
,''              交易对手客户编号
,''              交易对手名称
,''              交易对手账户开户行号
,''              交易对手账户开户行名称
,''              交易对手账号ID
,''              交易对手账号
,''              交易对手机构编号
,''              交易对手机构名称
,to_date(NVL(TO_CHAR(to_timestamp(substr(trim(a.hostdate),1,8),'YYYYMMSS'),'YYYY-MM-SS'),TO_CHAR(to_timestamp(substr(trim(a.transtime),1,8),'YYYYMMDD'),'YYYY-MM-DD')),'YYYY-MM-DD')              入账日期
,''              入账时间
,''              入账机构编号
,''              入账柜员编号
,case
    When a.ccy='156' Then 'CNY'
    When a.ccy='840' Then 'USD'
    When a.ccy='344' Then 'HKD'
    When a.ccy='954' Then 'EUR'
    When a.ccy='392' Then 'JPY'
    When a.ccy='826' Then 'GBP'
     else ''
End              入账币种代码
,TO_CHAR(NVL((case When a.trantype='2' Then trim(a.successamount)  else a.amount  End),'0.00'),'FM999999999999999990.00')              入账金额
,''              摘要码
,''              摘要
,''              借贷标志
,''              同城标志
,'1'              跨行标志
,'0'              境外标志
,'0'              现转标志
,''              发起方类型代码
,''              主凭证种类代码
,''              主凭证号码
,''              副凭证种类代码
,''              副凭证号码
,case
    when a.trantype IN ('1','4') Then a.uppfreetrace
     else ''
End              关联核心系统事件编号
,''              冲正事件编号
,case
    when a.trantype IN ('1','4') Then a.freezerecordid
    else ''
End              流程编号
,''              关联抵质押品编号
,'0'              往账标志
,''              余额方向代码
,''              余额类型代码
,case
    when a.accttype = '1' Then '实体卡'
    when a.accttype = '2' Then 'Ⅱ类账户'
    else ''
End              交易介质名称
,case
    When a.trantype='2'          Then a.payeeacct
    When a.trantype In ('1','4') Then a.payeracct
     else ''
End              交易介质编号
,''              业务类型代码
,''              业务种类代码
,'1'              本行发起标志
,''              旧凭证号码
,''              协议所属账号2
,''              协议所属账号3
,'MPCS'              数据来源代码
--,'EVT_MPCS_EVENT_DTL_02' ETL任务名称
,to_date('${batch_date}','yyyymmdd') 数据日期
--,''                          --
--,'0'                          --
--,''                          --
--,''                          --
--,''                          --外部科目编号
--,''                          --红蓝字标志
--,''                          --银行编号
--,''                          --银团编号
--,''                          --我行出资比例
,'32'                           --任务代码
,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                          --任务处理时间
  from ${iol_schema}.mpcs_a92ordertrans a
  where substr(a.updatetime,1,8) = '${batch_date}';

commit;


whenever sqlerror exit sql.sqlcode;
--第三十三组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --XXX
insert /*+ append(33) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
       evt_id            --事件编号  
      ,evt_typ_cd        --事件类型代码
      ,txn_num           --交易码   
      ,txn_dt            --交易日期  
      ,txn_tm            --交易时间  
      ,txn_org_id        --交易机构编号
      ,data_src_cd       --数据来源代码
--    ,etl_task_name     -- 
      ,etl_dt            --数据日期  
--    ,del_flg           --  
      ,job_cd            --任务代码  
      ,etl_timestamp     --任务处理时间
)
SELECT COALESCE(T1.TRANNBR, '') AS EVT_ID,
       'L040' AS EVT_TYP_CD,
       MUTRCD AS TXN_NUM,
       TO_DATE(TO_CHAR(TRANDATE), 'YYYY-MM-DD') AS TXN_DT,
       SUBSTR(TRANTIME, 1, 2) || ':' || SUBSTR(TRANTIME, 3, 2) || ':' || SUBSTR(TRANTIME, 5, 2) AS TXN_TM,
       COALESCE(T1.BRCNO, '') AS TXN_ORG_ID,
       'MPCS' AS DATA_SRC_CD,
--       'EVT_MPCS_EVENT_DTL_02' AS ETL_TASK_NAME,
       to_date('${batch_date}','yyyymmdd') AS ETL_DT,
--       '0' as DEL_FLG,
       '33' as JOB_CD,
       to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as ETL_TIMESTAMP
  FROM ${iol_schema}.MPCS_A60CFIDCHECK T1
 WHERE TRANDATE = '${batch_date}';

commit;


whenever sqlerror exit sql.sqlcode;
--第三十四组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --XXX
insert /*+ append(34) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
      evt_id                          --事件编号       
     ,global_chn_seq_num              --全局渠道流水号    
     ,prev_global_chn_seq_num         --上一全局渠道流水号  
     ,prev_evt_id                     --上一事件编号     
     ,evt_typ_cd                      --事件类型代码     
     ,menuid                          --柜面菜单码      
     ,txn_num                         --交易码        
     ,txn_desc                        --交易描述       
     ,txn_dt                          --交易日期       
     ,txn_tm                          --交易时间       
     ,txn_ccy_cd                      --交易币种代码     
     ,txn_amt                         --交易金额       
     ,acct_bal                        --账户余额       
     ,cost_typ_cd                     --费用类型代码     
     ,fee_amt                         --手续费金额      
     ,evt_status_cd                   --事件状态代码     
     ,evt_reverse_typ_cd              --事件冲正类型代码   
     ,agt_id                          --协议编号       
     ,agt_id_name                     --协议全称       
     ,agt_blng_acct_num               --协议所属账号     
     ,prd_id                          --产品编号       
     ,pty_id                          --客户编号       
     ,txn_org_id                      --交易机构编号     
     ,txn_teller_id                   --交易柜员编号     
     ,chk_teller_id                   --复核柜员编号     
     ,auth_teller_id                  --授权柜员编号     
     ,pty_mgr_id                      --客户经理编号     
     ,chn_typ_cd                      --渠道类型代码     
     ,chn_id                          --渠道编号       
     ,pay_chnl_typ_cd                 --支付通道类型代码   
     ,cntrpty_id                      --交易对手编号     
     ,cntrpty_name                    --交易对手名称     
     ,cntrpty_acct_openbk_num         --交易对手账户开户行号 
     ,cntrpty_acct_openbk_name        --交易对手账户开户行名称
     ,cntrpty_acct_num_id             --交易对手账号ID   
     ,cntrpty_acct_num                --交易对手账号     
     ,cntrpty_org_id                  --交易对手机构编号   
     ,cntrpty_org_name                --交易对手机构名称   
     ,posting_dt                      --入账日期       
     ,posting_tm                      --入账时间       
     ,posting_org_id                  --入账机构编号     
     ,posting_teller_id               --入账柜员编号     
     ,posting_ccy_cd                  --入账币种代码     
     ,posting_amt                     --入账金额       
     ,memo_cd                         --摘要码        
     ,memo                            --摘要         
     ,db_cr_dir_cd                    --借贷标志       
     ,city_flg                        --同城标志       
     ,crossb_flg                      --跨行标志       
     ,ovsea_flg                       --境外标志       
     ,cash_tfr_flg                    --现转标志       
     ,initor_typ_cd                   --发起方类型代码    
     ,prim_vchr_type_cd               --主凭证种类代码    
     ,prim_vchr_num                   --主凭证号码      
     ,scd_vchr_type_cd                --副凭证种类代码    
     ,scd_vchr_num                    --副凭证号码      
     ,assoc_bcs_evt_id                --关联核心系统事件编号 
     ,reverse_evt_id                  --冲正事件编号     
     ,flow_id                         --流程编号       
     ,assoc_coll_id                   --关联抵质押品编号   
     ,nostro_flg                      --往账标志       
     ,bal_dir_cd                      --余额方向代码     
     ,bal_typ_cd                      --余额类型代码     
     ,txn_med_name                    --交易介质名称     
     ,txn_med_id                      --交易介质编号     
     ,biz_typ_cd                      --业务类型代码     
     ,biz_cate_cd                     --业务种类代码     
     ,data_src_cd                     --数据来源代码     
--     ,del_flg                         --
     ,job_cd                          --任务代码       
--     ,etl_task_name                   --
     ,etl_dt                          --数据日期       
     ,etl_timestamp                   --任务处理时间     
  
)
SELECT
a.unotdate||a.unotnbr||a.unottime     --业务系统事件编号
,''                                   --全局渠道流水号
,''                                   --上一全局渠道流水号
,''                                   --上一事件编号
,'L150'                               --事件类型代码
,''                                   --柜面菜单码
,a.trantype                           --交易码
,b.trantypenm                         --交易描述
,TO_DATE(a.unotdate,'YYYY-MM-DD')     --交易日期
,to_char(TO_DATE(a.unottime,'hh24:mi:ss'), 'hh24:mi:ss')     --交易时间
,a.currencycd                         --交易币种代码
,a.amount                             --交易金额
,''                                   --账户余额
,''                                   --费用类型代码
,''                                   --费用金额
,case a.status
    WHEN '56' THEN '1'
    WHEN '58' THEN '1'
    WHEN '53' THEN '2'
    ELSE '9'
END                                   --事件状态代码
,''                                   --事件冲正类型代码
,a.cntrno                             --协议编号
,''                                   --协议全称
,a.payeracc                           --协议所属账号
,''                                   --产品编号
,''                                   --客户编号
,a.magbrn                             --交易机构编号
,'M0001'                              --交易柜员编号
,''                                   --复核柜员编号
,''                                   --授权柜员编号
,''                                   --客户经理编号
,'2203'                               --渠道类型代码
,'EFT'                                --渠道编号
,'06'                                 --支付通道类型代码
,''                                   --交易对手客户编号
,a.payeename                          --交易对手名称
,a.payeebank                          --交易对手账户开户行号
,'' 交易对手账户开户行名称
,a.payeeacc                           --交易对手账号ID
,a.payeeacc                           --交易对手账号
,''                                   --交易对手机构编号
,''                                   --交易对手机构名称
,to_date(trim(a.hostdate),'YYYYMMDD') --入账日期
,''                                   --入账时间
,a.magbrn                             --入账机构编号
,'M0001'                              --入账柜员编号
,a.currencycd                         --入账币种代码
,a.amount                             --入账金额
,''                                   --摘要码
,''                                   --摘要
,''                                   --借贷标志
,''                                   --同城标志
,'1'                                  --跨行标志
,''                                   --境外标志
,'0'                                  --现转标志
,''                                   --发起方类型代码
,''                                   --主凭证种类代码
,''                                   --主凭证号码
,''                                   --副凭证种类代码
,''                                   --副凭证号码
,''                                   --关联核心系统事件编号
,''                                   --冲正事件编号
,''                                   --流程编号
,''                                   --关联抵质押品编号
,'0'                                  --往账标志
,''                                   --余额方向代码
,''                                   --余额类型代码
,''                                   --交易介质名称
,''                                   --交易介质编号
,''                                   --业务类型代码
,''                                   --业务种类代码
,'MPCS'                               --数据来源代码
--,'0'                                  --删除标志
,'34'                                 --job_cd
--,'EVT_MPCS_EVENT_DTL_02' as etl_task_name
,to_date('${batch_date}','YYYYMMDD')  --数据日期 --V_ETL_DT
,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as ETL_TIMESTAMP
from ${iol_schema}.mpcs_a49teftrx a
left join ${iol_schema}.mpcs_a49teftrantypeinfo b 
       on a.trantype = b.trantype 
      and b.start_dt <= to_date('${batch_date}','yyyymmdd')
      and b.end_dt > to_date('${batch_date}','yyyymmdd')
 where a.unotdate = '${batch_date}' and a.oprchl like '04%' and msgno in ('B00101','B00701')
;
commit;



 whenever sqlerror exit sql.sqlcode;
 --第三十五组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --XXX
 insert /*+ append(35) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id                         --事件编号       
   ,txn_dt                         --交易日期       
   ,prev_evt_id                    --上一事件编号     
   ,assoc_bcs_evt_id               --关联核心系统事件编号 
   ,reverse_evt_id                 --冲正事件编号     
   ,global_chn_seq_num             --全局渠道流水号    
   ,prev_global_chn_seq_num        --上一全局渠道流水号  
   ,evt_typ_cd                     --事件类型代码     
   ,txn_num                        --交易码        
   ,txn_ccy_cd                     --交易币种代码     
   ,txn_amt                        --交易金额       
   ,cost_typ_cd                    --费用类型代码     
   ,fee_amt                        --手续费金额      
   ,evt_reverse_typ_cd             --事件冲正类型代码   
   ,agt_id                         --协议编号       
   ,prd_id                         --产品编号       
   ,pty_id                         --客户编号       
   ,txn_org_id                     --交易机构编号     
   ,txn_teller_id                  --交易柜员编号     
   ,auth_teller_id                 --授权柜员编号     
   ,chk_teller_id                  --复核柜员编号     
   ,pty_mgr_id                     --客户经理编号     
   ,chn_typ_cd                     --渠道类型代码     
   ,flow_id                        --流程编号       
   ,assoc_coll_id                  --关联抵质押品编号   
   ,cntrpty_id                     --交易对手编号     
   ,cntrpty_name                   --交易对手名称     
   ,cntrpty_org_id                 --交易对手机构编号   
   ,cntrpty_org_name               --交易对手机构名称   
   ,cntrpty_acct_num               --交易对手账号     
   ,cntrpty_acct_openbk_num        --交易对手账户开户行号 
   ,cntrpty_acct_openbk_name       --交易对手账户开户行名称
   ,posting_dt                     --入账日期       
   ,posting_tm                     --入账时间       
   ,posting_org_id                 --入账机构编号     
   ,posting_teller_id              --入账柜员编号     
   ,posting_ccy_cd                 --入账币种代码     
   ,posting_amt                    --入账金额       
   ,memo                           --摘要         
   ,nostro_flg                     --往账标志       
   ,db_cr_dir_cd                   --借贷标志       
   ,city_flg                       --同城标志       
   ,crossb_flg                     --跨行标志       
   ,ovsea_flg                      --境外标志       
   ,initor_typ_cd                  --发起方类型代码    
   ,prim_vchr_type_cd              --主凭证种类代码    
   ,prim_vchr_num                  --主凭证号码      
   ,evt_status_cd                  --事件状态代码     
   ,data_src_cd                    --数据来源代码     
--   ,del_flg                        --
   ,txn_tm                         --交易时间       
   ,job_cd                         --任务代码       
--   ,etl_task_name                  --
   ,etl_dt                         --数据日期       
   ,etl_timestamp                  --任务处理时间     
  
 )
SELECT
MAINSEQ
,TO_DATE(TRANSDT,'YYYY-MM-DD')
,''
,hostnbr
,''
,''
,''
,'L010'
,FRONTTRCD
,t1.ccynbr 
,transamt 
,''
,''
,''
,payacct
,''
,''
,MAGEBRN
,OPRTLR
,AUTTLR
,CHKTLR
,''
,''
,''
,''
,incoacct --旧的
,INCONAME 
,''
,''
,incoacct 
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,BOOKSEQNO
,''
,'MPCS'
--,'0'
,substr(rcvdt,9,2)||':'||substr(rcvdt,11,2)||':'||substr(rcvdt,13,2)
,'35' JOB_CD
--,'EVT_MPCS_EVENT_DTL_02' AS ETL_TASK_NAME
,to_date('${batch_date}','YYYYMMDD') etl_dt
,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as ETL_TIMESTAMP
 FROM ${iol_schema}.mpcs_a08thvtrx T1
 WHERE T1.TRANSDT = '${batch_date}';

commit;



whenever sqlerror exit sql.sqlcode;
--第三十六组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --XXX
insert /*+ append(36) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
      evt_id                            --事件编号       
     ,txn_dt                            --交易日期       
     ,prev_evt_id                       --上一事件编号     
     ,assoc_bcs_evt_id                  --关联核心系统事件编号 
     ,reverse_evt_id                    --冲正事件编号     
     ,global_chn_seq_num                --全局渠道流水号    
     ,prev_global_chn_seq_num           --上一全局渠道流水号  
     ,evt_typ_cd                        --事件类型代码     
     ,txn_num                           --交易码        
     ,txn_ccy_cd                        --交易币种代码     
     ,txn_amt                           --交易金额       
     ,cost_typ_cd                       --费用类型代码     
     ,fee_amt                           --手续费金额      
     ,evt_reverse_typ_cd                --事件冲正类型代码   
     ,agt_id                            --协议编号       
     ,prd_id                            --产品编号       
     ,pty_id                            --客户编号       
     ,txn_org_id                        --交易机构编号     
     ,txn_teller_id                     --交易柜员编号     
     ,auth_teller_id                    --授权柜员编号     
     ,chk_teller_id                     --复核柜员编号     
     ,pty_mgr_id                        --客户经理编号     
     ,chn_typ_cd                        --渠道类型代码     
     ,flow_id                           --流程编号       
     ,assoc_coll_id                     --关联抵质押品编号   
     ,cntrpty_id                        --交易对手编号     
     ,cntrpty_name                      --交易对手名称     
     ,cntrpty_org_id                    --交易对手机构编号   
     ,cntrpty_org_name                  --交易对手机构名称   
     ,cntrpty_acct_num                  --交易对手账号     
     ,cntrpty_acct_openbk_num           --交易对手账户开户行号 
     ,cntrpty_acct_openbk_name          --交易对手账户开户行名称
     ,posting_dt                        --入账日期       
     ,posting_tm                        --入账时间       
     ,posting_org_id                    --入账机构编号     
     ,posting_teller_id                 --入账柜员编号     
     ,posting_ccy_cd                    --入账币种代码     
     ,posting_amt                       --入账金额       
     ,memo                              --摘要         
     ,nostro_flg                        --往账标志       
     ,db_cr_dir_cd                      --借贷标志       
     ,city_flg                          --同城标志       
     ,crossb_flg                        --跨行标志       
     ,ovsea_flg                         --境外标志       
     ,initor_typ_cd                     --发起方类型代码    
     ,prim_vchr_type_cd                 --主凭证种类代码    
     ,prim_vchr_num                     --主凭证号码      
     ,evt_status_cd                     --事件状态代码     
     ,data_src_cd                       --数据来源代码     
--     ,del_flg                           --
     ,txn_tm                            --交易时间       
     ,job_cd                            --任务代码       
--     ,etl_task_name                     --
     ,etl_dt                            --数据日期       
     ,etl_timestamp                     --任务处理时间     
)
SELECT
MAINSQ
,TO_DATE(TRANSDT,'YYYY-MM-DD')
,''
,hostnbr
,''
,''
,''
,'L020'
,FRONTTRCD
,t1.crcycd
,transamt
,''
,''
,''
,payacct
,''
,''
,OPRBRN --added by zhuhui in 20160817
,OPRTLR
,AUTTLR
,''
,''
,''
,''
,''
,incoacct
,INCONAME --added by zhuhui in 20160614
,''
,''
,incoacct ----added by zhuhui in 20160614
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,cobkcd
,''
,'MPCS'
--,''
,case nvl(recvdt,'0') when '0' then '' else substr(recvdt,9,2)||':'||substr(recvdt,11,2)||':'||substr(recvdt,13,2) end--advised by zhuihui
,'36' JOB_CD
--,'EVT_MPCS_EVENT_DTL_02' AS ETL_TASK_NAME
,to_date('${batch_date}','YYYYMMDD') etl_dt
,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as ETL_TIMESTAMP
 FROM      ${iol_schema}.mpcs_a08tbetrx T1 
 WHERE TRANSDT = '${batch_date}';

commit;


whenever sqlerror exit sql.sqlcode;
--第三十七组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --XXX
insert /*+ append(37) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
       evt_id                         --事件编号       
      ,txn_dt                         --交易日期       
      ,prev_evt_id                    --上一事件编号     
      ,assoc_bcs_evt_id               --关联核心系统事件编号 
      ,reverse_evt_id                 --冲正事件编号     
      ,global_chn_seq_num             --全局渠道流水号    
      ,prev_global_chn_seq_num        --上一全局渠道流水号  
      ,evt_typ_cd                     --事件类型代码     
      ,txn_num                        --交易码        
      ,txn_ccy_cd                     --交易币种代码     
      ,txn_amt                        --交易金额       
      ,cost_typ_cd                    --费用类型代码     
      ,fee_amt                        --手续费金额      
      ,evt_reverse_typ_cd             --事件冲正类型代码   
      ,agt_id                         --协议编号       
      ,agt_blng_acct_num              --协议所属账号     
      ,prd_id                         --产品编号       
      ,pty_id                         --客户编号       
      ,txn_org_id                     --交易机构编号     
      ,txn_teller_id                  --交易柜员编号     
      ,auth_teller_id                 --授权柜员编号     
      ,chk_teller_id                  --复核柜员编号     
      ,pty_mgr_id                     --客户经理编号     
      ,chn_typ_cd                     --渠道类型代码     
      ,flow_id                        --流程编号       
      ,assoc_coll_id                  --关联抵质押品编号   
      ,cntrpty_id                     --交易对手编号     
      ,cntrpty_name                   --交易对手名称     
      ,cntrpty_org_id                 --交易对手机构编号   
      ,cntrpty_org_name               --交易对手机构名称   
      ,cntrpty_acct_num               --交易对手账号     
      ,cntrpty_acct_openbk_num        --交易对手账户开户行号 
      ,cntrpty_acct_openbk_name       --交易对手账户开户行名称
      ,posting_dt                     --入账日期       
      ,posting_tm                     --入账时间       
      ,posting_org_id                 --入账机构编号     
      ,posting_teller_id              --入账柜员编号     
      ,posting_ccy_cd                 --入账币种代码     
      ,posting_amt                    --入账金额       
      ,memo                           --摘要         
      ,nostro_flg                     --往账标志       
      ,db_cr_dir_cd                   --借贷标志       
      ,city_flg                       --同城标志       
      ,crossb_flg                     --跨行标志       
      ,ovsea_flg                      --境外标志       
      ,initor_typ_cd                  --发起方类型代码    
      ,prim_vchr_type_cd              --主凭证种类代码    
      ,prim_vchr_num                  --主凭证号码      
      ,evt_status_cd                  --事件状态代码     
      ,data_src_cd                    --数据来源代码     
--      ,del_flg                        --
      ,txn_tm                         --交易时间       
      ,job_cd                         --任务代码       
--      ,etl_task_name                  --
      ,etl_dt                         --数据日期       
      ,etl_timestamp                  --任务处理时间     
      ,txn_desc                       --交易描述       
   
)
SELECT
FNTSEQNO
,TO_DATE(TRNDT,'YYYY-MM-DD')
,''
,HOSTSEQNO
,''
,''
,''
,'L030'
,FNTTRNCD
,''
,''
,''
,''
,''
,CONTRACTNO
,ACCTNO
,''
,CUSTNO
,TRNBRCNO
,TLRNO
,AUTHTLRNO
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,'MPCS'
--,'0'
,substr(TRNTS,1,2)||':'||substr(TRNTS,3,2)||':'||substr(TRNTS,5,2)
,'37' JOB_CD
--,'EVT_MPCS_EVENT_DTL_02' AS ETL_TASK_NAME
,to_date('${batch_date}','YYYYMMDD') etl_dt
,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as ETL_TIMESTAMP
,case T1.FNTTRNCD
         when 'A33F01' then
          '资信证明开立'
         when 'A33M01' then
          '资信证明换发'
         when 'A33M02' then
          '资信证明重开'
         when 'A35M01' then
          '存管银行预指定确定'
         when 'A35M02' then
          '签约账户查询/变更'
         when 'A02M52' then
          '批量签约'
          end
 from ${iol_schema}.mpcs_a02tcontracttranlist T1
where trndt = '${batch_date}';

commit;


whenever sqlerror exit sql.sqlcode;
--第三十八组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --XXX
insert /*+ append(38) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id                       -- 事件编号       
   ,global_chn_seq_num           -- 全局渠道流水号    
   ,prev_global_chn_seq_num      -- 上一全局渠道流水号  
   ,prev_evt_id                  -- 上一事件编号     
   ,evt_typ_cd                   -- 事件类型代码     
   ,menuid                       -- 柜面菜单码      
   ,txn_num                      -- 交易码        
--   ,txn_desc                     -- 交易描述       
   ,txn_dt                       -- 交易日期       
   ,txn_tm                       -- 交易时间       
   ,txn_ccy_cd                   -- 交易币种代码     
   ,txn_amt                      -- 交易金额       
   ,acct_bal                     -- 账户余额       
   ,cost_typ_cd                  -- 费用类型代码     
   ,fee_amt                      -- 手续费金额      
   ,evt_status_cd                -- 事件状态代码     
   ,evt_reverse_typ_cd           -- 事件冲正类型代码   
   ,agt_id                       -- 协议编号       
--   ,agt_id_name                  -- 协议全称       
--   ,agt_blng_acct_num            -- 协议所属账号     
   ,prd_id                       -- 产品编号       
   ,pty_id                       -- 客户编号       
   ,txn_org_id                   -- 交易机构编号     
   ,txn_teller_id                -- 交易柜员编号     
   ,chk_teller_id                -- 复核柜员编号     
   ,auth_teller_id               -- 授权柜员编号     
   ,pty_mgr_id                   -- 客户经理编号     
   ,chn_typ_cd                   -- 渠道类型代码     
   ,chn_id                       -- 渠道编号       
--   ,pay_chnl_typ_cd              -- 支付通道类型代码   
   ,cntrpty_id                   -- 交易对手编号     
   ,cntrpty_name                 -- 交易对手名称     
   ,cntrpty_acct_openbk_num      -- 交易对手账户开户行号 
   ,cntrpty_acct_openbk_name     -- 交易对手账户开户行名称
--   ,cntrpty_acct_num_id          -- 交易对手账号ID   
   ,cntrpty_acct_num             -- 交易对手账号     
   ,cntrpty_org_id               -- 交易对手机构编号   
   ,cntrpty_org_name             -- 交易对手机构名称   
   ,posting_dt                   -- 入账日期       
   ,posting_tm                   -- 入账时间       
   ,posting_org_id               -- 入账机构编号     
   ,posting_teller_id            -- 入账柜员编号     
   ,posting_ccy_cd               -- 入账币种代码     
   ,posting_amt                  -- 入账金额       
   ,memo_cd                      -- 摘要码        
   ,memo                         -- 摘要         
   ,db_cr_dir_cd                 -- 借贷标志       
   ,city_flg                     -- 同城标志       
   ,crossb_flg                   -- 跨行标志       
   ,ovsea_flg                    -- 境外标志       
   ,cash_tfr_flg                 -- 现转标志       
   ,initor_typ_cd                -- 发起方类型代码    
   ,prim_vchr_type_cd            -- 主凭证种类代码    
   ,prim_vchr_num                -- 主凭证号码      
   ,scd_vchr_type_cd             -- 副凭证种类代码    
   ,scd_vchr_num                 -- 副凭证号码      
   ,assoc_bcs_evt_id             -- 关联核心系统事件编号 
   ,reverse_evt_id               -- 冲正事件编号     
   ,flow_id                      -- 流程编号       
   ,assoc_coll_id                -- 关联抵质押品编号   
   ,nostro_flg                   -- 往账标志       
   ,bal_dir_cd                   -- 余额方向代码     
--   ,bal_typ_cd                   -- 余额类型代码     
   ,txn_med_name                 -- 交易介质名称     
   ,txn_med_id                   -- 交易介质编号     
--   ,biz_typ_cd                   -- 业务类型代码     
--   ,biz_cate_cd                  -- 业务种类代码     
--   ,ghb_init_flg                 -- 本行发起标志     
--   ,old_vchr_num                 -- 旧凭证号码      
--   ,agt_blng_acct_num2           -- 协议所属账号2    
--   ,agt_blng_acct_num3           -- 协议所属账号3    
   ,data_src_cd                  -- 数据来源代码     
   ,job_cd                       -- 任务代码       
   ,etl_dt                       -- 数据日期       
   ,etl_timestamp                -- 任务处理时间     
)
select
     B.summsq||to_char(B.CNTIDX),
     '',
     '',
     '',
     case when a.projtp = '00' then 'L090'
          when a.projtp = '05' then 'L080' end,
     '',
     '',
     to_date(to_char(A.bachdt),'YYYY-MM-DD'),
     '',
     'CNY',
     B.pytram,
     '',
     '',
     '',
     '1',
     '',
     C.acctno,
     '',
     '',
     A.branch,
     A.tlrnbr,
     '',
     A.chktlr,
     '',
     '1001',
     '',
     '',
     B.acctna,
     '',
     '',
     B.acctno,
     '',
     '',
     to_date(to_char(B.hostdt),'YYYY-MM-DD'),
     '',
     '',
     '',
     'CNY',
     B.pytram,
     A.mmtext,
     A.mmcont,
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     B.hostsq,
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     'MPCS',
--     '0',
     '38' JOB_CD,
--     'EVT_MPCS_EVENT_DTL_02' AS ETL_TASK_NAME,
     to_date('${batch_date}','YYYYMMDD') etl_dt,
     to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as ETL_TIMESTAMP
from ${iol_schema}.mpcs_a60projdf_sign_summary a
,${iol_schema}.mpcs_a60projdf_sign_detail b
,${iol_schema}.mpcs_a60projdf_sign c
where a.summsq = b.summsq 
and a.projno = c.projno 
and a.bachdt='${batch_date}' 
and a.bachdt=b.trandt
and c.start_dt <= to_date('${batch_date}','YYYYMMDD') 
and c.end_dt > to_date('${batch_date}','YYYYMMDD')
and b.respcd='cmd0000' --20160426，只需要成功的记录 
;
commit;


whenever sqlerror exit sql.sqlcode;
--第三十九组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --XXX
insert /*+ append(39) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id                       -- 事件编号       
   ,global_chn_seq_num           -- 全局渠道流水号    
   ,prev_global_chn_seq_num      -- 上一全局渠道流水号  
   ,prev_evt_id                  -- 上一事件编号     
   ,evt_typ_cd                   -- 事件类型代码     
   ,menuid                       -- 柜面菜单码      
   ,txn_num                      -- 交易码        
--   ,txn_desc                     -- 交易描述       
   ,txn_dt                       -- 交易日期       
   ,txn_tm                       -- 交易时间       
   ,txn_ccy_cd                   -- 交易币种代码     
   ,txn_amt                      -- 交易金额       
   ,acct_bal                     -- 账户余额       
   ,cost_typ_cd                  -- 费用类型代码     
   ,fee_amt                      -- 手续费金额      
   ,evt_status_cd                -- 事件状态代码     
   ,evt_reverse_typ_cd           -- 事件冲正类型代码   
   ,agt_id                       -- 协议编号       
--   ,agt_id_name                  -- 协议全称       
--   ,agt_blng_acct_num            -- 协议所属账号     
   ,prd_id                       -- 产品编号       
   ,pty_id                       -- 客户编号       
   ,txn_org_id                   -- 交易机构编号     
   ,txn_teller_id                -- 交易柜员编号     
   ,chk_teller_id                -- 复核柜员编号     
   ,auth_teller_id               -- 授权柜员编号     
   ,pty_mgr_id                   -- 客户经理编号     
   ,chn_typ_cd                   -- 渠道类型代码     
   ,chn_id                       -- 渠道编号       
--   ,pay_chnl_typ_cd              -- 支付通道类型代码   
   ,cntrpty_id                   -- 交易对手编号     
   ,cntrpty_name                 -- 交易对手名称     
   ,cntrpty_acct_openbk_num      -- 交易对手账户开户行号 
   ,cntrpty_acct_openbk_name     -- 交易对手账户开户行名称
--   ,cntrpty_acct_num_id          -- 交易对手账号ID   
   ,cntrpty_acct_num             -- 交易对手账号     
   ,cntrpty_org_id               -- 交易对手机构编号   
   ,cntrpty_org_name             -- 交易对手机构名称   
   ,posting_dt                   -- 入账日期       
   ,posting_tm                   -- 入账时间       
   ,posting_org_id               -- 入账机构编号     
   ,posting_teller_id            -- 入账柜员编号     
   ,posting_ccy_cd               -- 入账币种代码     
   ,posting_amt                  -- 入账金额       
   ,memo_cd                      -- 摘要码        
   ,memo                         -- 摘要         
   ,db_cr_dir_cd                 -- 借贷标志       
   ,city_flg                     -- 同城标志       
   ,crossb_flg                   -- 跨行标志       
   ,ovsea_flg                    -- 境外标志       
   ,cash_tfr_flg                 -- 现转标志       
   ,initor_typ_cd                -- 发起方类型代码    
   ,prim_vchr_type_cd            -- 主凭证种类代码    
   ,prim_vchr_num                -- 主凭证号码      
   ,scd_vchr_type_cd             -- 副凭证种类代码    
   ,scd_vchr_num                 -- 副凭证号码      
   ,assoc_bcs_evt_id             -- 关联核心系统事件编号 
   ,reverse_evt_id               -- 冲正事件编号     
   ,flow_id                      -- 流程编号       
   ,assoc_coll_id                -- 关联抵质押品编号   
   ,nostro_flg                   -- 往账标志       
   ,bal_dir_cd                   -- 余额方向代码     
--   ,bal_typ_cd                   -- 余额类型代码     
   ,txn_med_name                 -- 交易介质名称     
   ,txn_med_id                   -- 交易介质编号     
--   ,biz_typ_cd                   -- 业务类型代码     
--   ,biz_cate_cd                  -- 业务种类代码     
--   ,ghb_init_flg                 -- 本行发起标志     
--   ,old_vchr_num                 -- 旧凭证号码      
--   ,agt_blng_acct_num2           -- 协议所属账号2    
--   ,agt_blng_acct_num3           -- 协议所属账号3    
   ,data_src_cd                  -- 数据来源代码     
   ,job_cd                       -- 任务代码       
   ,etl_dt                       -- 数据日期       
   ,etl_timestamp                -- 任务处理时间     
)
select
     B.batchdt||B.batchno||B.recordno,
     '',
     '',
     '',
     'L080',
     '',
     '',
     to_date(to_char(A.fntdt),'YYYY-MM-DD'),
     '',
     'CNY',
     B.trnamt,
     '',
     '',
     '',
     '1',
     '',
     A.PAYACCTNO,
     '',
     A.CUSTNO,
     '',
     '',
     '',
     '',
     '',
     '1010',
     '',
     '',
     B.payacctname,
     '',
     '',
     B.PAYACCTNO,
     '',
     '',
     to_date(to_char(B.hostseqdt),'YYYY-MM-DD'),
     '',
     '',
     '',
     'CNY',
     B.trnamt,
     B.memocd,
     A.memo,
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     B.hostseqno,
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     'MPCS',
--     '0',
     '39' JOB_CD,
--     'EVT_MPCS_EVENT_DTL_02' AS ETL_TASK_NAME,
     to_date('${batch_date}','YYYYMMDD') etl_dt,
     to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as ETL_TIMESTAMP
from ${iol_schema}.mpcs_a01tbatmanage A, ${iol_schema}.mpcs_a01tbatdetail B
where A.batchdt = B.batchdt and A.batchno = B.batchno
and A.fntdt='${batch_date}'
and b.rspcd in ('cmd0000','000000') --20160426，只需要成功的记录
;
commit;


whenever sqlerror exit sql.sqlcode;
--第四十组 idl_hdws_iml_evt_mpcs_event_dtl_02 迁移逻辑 --代收付集中代扣费签约信息表
insert /*+ append(40) */ into ${idl_schema}.orws_evt_mpcs_event_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
       evt_id                          --事件编号       
      ,global_chn_seq_num              --全局渠道流水号    
      ,prev_global_chn_seq_num         --上一全局渠道流水号  
      ,prev_evt_id                     --上一事件编号     
      ,evt_typ_cd                      --事件类型代码     
      ,menuid                          --柜面菜单码      
      ,txn_num                         --交易码        
      ,txn_dt                          --交易日期       
      ,txn_tm                          --交易时间       
      ,txn_ccy_cd                      --交易币种代码     
      ,txn_amt                         --交易金额       
      ,acct_bal                        --账户余额       
      ,cost_typ_cd                     --费用类型代码     
      ,fee_amt                         --手续费金额      
      ,evt_status_cd                   --事件状态代码     
      ,evt_reverse_typ_cd              --事件冲正类型代码   
      ,agt_id                          --协议编号       
      ,agt_id_name                     --协议全称       
      ,agt_blng_acct_num               --协议所属账号     
      ,prd_id                          --产品编号       
      ,pty_id                          --客户编号       
      ,txn_org_id                      --交易机构编号     
      ,txn_teller_id                   --交易柜员编号     
      ,chk_teller_id                   --复核柜员编号     
      ,auth_teller_id                  --授权柜员编号     
      ,pty_mgr_id                      --客户经理编号     
      ,chn_typ_cd                      --渠道类型代码     
      ,chn_id                          --渠道编号       
      ,pay_chnl_typ_cd                 --支付通道类型代码   
      ,cntrpty_id                      --交易对手编号     
      ,cntrpty_name                    --交易对手名称     
      ,cntrpty_acct_openbk_num         --交易对手账户开户行号 
      ,cntrpty_acct_openbk_name        --交易对手账户开户行名称
      ,cntrpty_acct_num_id             --交易对手账号ID   
      ,cntrpty_acct_num                --交易对手账号     
      ,cntrpty_org_id                  --交易对手机构编号   
      ,cntrpty_org_name                --交易对手机构名称   
      ,posting_dt                      --入账日期       
      ,posting_tm                      --入账时间       
      ,posting_org_id                  --入账机构编号     
      ,posting_teller_id               --入账柜员编号     
      ,posting_ccy_cd                  --入账币种代码     
      ,posting_amt                     --入账金额       
      ,memo_cd                         --摘要码        
      ,memo                            --摘要         
      ,db_cr_dir_cd                    --借贷标志       
      ,city_flg                        --同城标志       
      ,crossb_flg                      --跨行标志       
      ,ovsea_flg                       --境外标志       
      ,cash_tfr_flg                    --现转标志       
      ,initor_typ_cd                   --发起方类型代码    
      ,prim_vchr_type_cd               --主凭证种类代码    
      ,prim_vchr_num                   --主凭证号码      
      ,scd_vchr_type_cd                --副凭证种类代码    
      ,scd_vchr_num                    --副凭证号码      
      ,assoc_bcs_evt_id                --关联核心系统事件编号 
      ,reverse_evt_id                  --冲正事件编号     
      ,flow_id                         --流程编号       
      ,assoc_coll_id                   --关联抵质押品编号   
      ,nostro_flg                      --往账标志       
      ,bal_dir_cd                      --余额方向代码     
      ,bal_typ_cd                      --余额类型代码     
      ,txn_med_name                    --交易介质名称     
      ,txn_med_id                      --交易介质编号     
      ,data_src_cd                     --数据来源代码     
--      ,del_flg                         --
      ,job_cd                          --任务代码       
--      ,etl_task_name,                  --
      ,etl_dt                          --数据日期       
      ,etl_timestamp                   --任务处理时间     
      ,txn_desc                        --交易描述       
      ,biz_typ_cd                      --业务类型代码     
      ,biz_cate_cd                     --业务种类代码        
)
select
      'L116'||b.SIGNDT||b.SIGNSQ as 业务系统事件编号,
      '' as  全局渠道流水号        ,
      '' as  上一全局渠道流水号    ,
      '' as  上一事件编号          ,
      'L116' as  事件类型代码      ,
      ''  as  柜面菜单码           ,
      case b.IOTYPE when 'I' then
      case b.SIGNST when '00' then 'A59M31'
                    when '01' then 'A59M31'
                    when '02' then 'A59M31'
      else 'A59M32' end
                    when 'O' then
                               case b.SIGNST when '00' then 'A49M31'
                                             when '01' then 'A49M31'
                                             when '02' then 'A49M31'
                                             else 'A59M32' end
                                             end   as  交易码                , --A49M31集中代扣费签约A49M32 为解约 同一笔流水
      to_date(b.signdt,'YYYYMMDD') as  交易日期              ,
      substr(b.signtm,1,2)||':'||substr(b.signtm,3,2)||':'||substr(b.signtm,5,2) as  交易时间,
      'CNY'  as 交易币种代码 ,
      '' as  交易金额              ,
      ''  as  账户余额              ,
      ''  as  费用类型代码          ,
      ''  as  费用金额              ,
      case b.SIGNST -- 00 签约成功 01 发送失败  02 发送成功 03 已撤销 04 撤销发送成功  05 签约失败
         when '00' then
          '1'
         when '01' then
          '2'
         when '02' then
          '9'
         when '03' then
          '2'
         when '04' then
          '9'
         when '05' then
          '2'
         else
          '9'
       end  as  事件状态代码     ,
      '' as  事件冲正类型代码      ,
       case b.IOTYPE when 'I' then ''
                     when 'O' then b.payeracc end as  协议编号              ,
      '' as  协议全称              ,
       case b.IOTYPE when 'I' then ''
                     when 'O' then b.payeracc end as  协议所属账号          ,
      'EFT' as  产品编号              ,
      ''                   as  客户编号  ,
      b.brchno as  交易机构编号          ,
      b.userid  as  交易柜员编号          ,
      ''  as  复核柜员编号          ,
      b.ckbkus  as  授权柜员编号          ,
      ''                   as  客户经理编号          ,
      ''                   as  渠道类型代码          ,
      '' as  渠道编号              ,
      ''                   as  支付通道类型代码      ,
      ''                   as  交易对手客户编号      ,
      '' as  交易对手名称          ,
      ''  as  交易对手账户开户行号  ,
      ''  as  交易对手账户开户行名称,
      ''  as  交易对手账号ID        ,
      '' as  交易对手账号          ,
      ''  as  交易对手机构编号      ,
      ''  as  交易对手机构名称      ,
      ''  as  入账日期              ,
      ''  as  入账时间              ,
      ''  as  入账机构编号          ,
      ''  as  入账柜员编号          ,
      ''  as  入账币种代码          ,
      ''  as  入账金额              ,
      ''                   as  摘要码                ,
      ''                   as  摘要                  ,
      ''       as  借贷标志 ,
      ''                   as  同城标志              ,
      ''                   as  跨行标志              ,
      ''                   as  境外标志              ,
      ''                   as  现转标志              ,
      ''                   as  发起方类型代码        ,
      ''                   as  主凭证种类代码        ,
      ''                   as  主凭证号码            ,
      ''                   as  副凭证种类代码        ,
      ''                   as  副凭证号码            ,
      '' as  关联核心系统事件编号  ,
      ''                   as  冲正事件编号          ,
      ''                   as  流程编号              ,
      ''                   as  关联抵质押品编号      ,
      case b.IOTYPE when 'I' then '1'
                    when 'O' then '0' end as  往账标志,--1 来账,0 往账
      ''                   as  余额方向代码          ,
      ''                   as  余额类型代码          ,
      ''                   as  交易介质名称          ,
      ''                   as  交易介质编号          ,
      'MPCS'  as  数据来源代码          ,
--      '0'                   as  删除标志              ,
      '40' JOB_CD               ,
--      'EVT_MPCS_EVENT_DTL_02' AS ETL_TASK_NAME,
      to_date('${batch_date}','YYYYMMDD') as  数据日期,
      to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as ETL_TIMESTAMP,
      '集中代扣费签约'                   as 交易描述    ,
      ''                   as 业务类型代码,
      ''                 as 业务种类代码--b.TRANTYPE
  from ${iol_schema}.mpcs_a49tefrepsign b --代收付集中代扣费签约信息表
 where b.signdt = '${batch_date}';

commit;






-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'orws_evt_mpcs_event_dtl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);