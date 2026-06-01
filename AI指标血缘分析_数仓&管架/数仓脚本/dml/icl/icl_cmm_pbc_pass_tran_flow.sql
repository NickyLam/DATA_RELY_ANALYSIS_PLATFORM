/*
Purpose:    共性加工层-人行通道交易流水表:数据来源于中台系统（MPCS）,包括大额交易事件、小额交易事件、省金服交易事件、深同城交易事件、超级网银的交易流水
Author:     Sunline/huangrong
Usage:      python $ETL_HOME/script/main.py 20220630 icl_cmm_pbc_pass_tran_flow
Createdate: 20200302
Logs:   20211107 何桐金 【_evt_bigamt_tran_evt、_evt_bs_amt_entry_evt、_evt_beps_tran_evt、_evt_tef_tran_evt
                        _evt_tef_entry_evt、_evt_tszfs_tran_evt、_evt_tszfs_entry_evt、_evt_super_olbk_tran_evt】增加job_cd过滤条件
		    20220414 朱觉军	新增字段：付款人开户行部门编号，管理机构编号，日志流水号，行内行外标志；
                       修改字段取数逻辑：第三组的业务类型代码，录入柜员编号，复核柜员编号，录入复核柜员部门编号，授权柜员部门编号；
					                     第五组的处理状态代码和往来账标志							
        20220607 李森辉 1、新增字段：收到时间
                        2、修改字段取数逻辑：第五组的付款人开户行部门编号和往来账标志；
        20220827 温旺清 新增数据-财税业务交易信息和国库资金划拨信息，取值来源：a0dtps_rtrq、AODTIPS_GKZJDHWH、a49tefetstran、a08tbankinfo
        20220909 曹永茂 1、调整每组的【任务代码】赋值，方便问题定位
                        2、调整【数据日期】的取数逻辑：t1.etl_dt -> t1.tran_dt; 调整t1的增量条件：t1.etl_dt -> t1.tran_dt
        20220921 翟若平 调整第五组字段【处理状态代码】的加工口径
        20221011 温旺清 调整第五组第六组第七组 ETL_DT加工逻辑
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_pbc_pass_tran_flow drop partition p_${retain_day};
alter table ${icl_schema}.cmm_pbc_pass_tran_flow add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.1 truncate latest 15 days of partition data
set serveroutput on
--set line 200;
declare bat_dt varchar2(10);
    v_p_exists varchar2(10);
    v_sql varchar2(200);
begin    
--dbms_output.put_line('BBB');
for i in 0 .. 14 loop
    bat_dt := to_char(to_date('${batch_date}','yyyymmdd') - i,'yyyymmdd');
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''cmm_pbc_pass_tran_flow'') and partition_name = ''P_'||bat_dt||''' ';
    --dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    --dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table icl.cmm_pbc_pass_tran_flow truncate partition P_'||bat_dt ;
        --dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table icl.cmm_pbc_pass_tran_flow  add partition P_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
       -- dbms_output.put_line(v_sql);
        execute immediate v_sql;
        --dbms_output.put_line('AAA');
    end if;
end loop;
end;
/


--3.1 insert target table data
-- 第一组(大额交易事件)
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_pbc_pass_tran_flow(
       etl_dt                        -- 数据日期
       ,evt_id                       -- 事件编号  
       ,lp_id                        -- 法人编号
       ,pay_decl_form_id             -- 支付报单编号  
       ,tran_dt                      -- 交易日期                          
       ,out_line_pay_tran_seq_num    -- 行外支付交易序号           
       ,bank_int_bus_seq_num         -- 行内业务序号   
       ,bus_origi_bank_no            -- 业务发起行行号
       ,pbc_pass_tran_type_cd        -- 人行通道交易类型代码          
       ,msg_type_id                  -- 报文类型编号             
       ,scd_gener_msg_type_id        -- 二代报文类型编号 
       ,host_flow_num                -- 主机流水号              
       ,tran_flow_num                -- 交易流水号              
       ,send_tran_flow_num           -- 发送交易流水号            
       ,ova_flow_num                 -- 全局流水号              
       ,host_tran_code               -- 主机交易码              
       ,midgrod_tran_code            -- 中台交易码              
       ,curr_cd                      -- 币种代码               
       ,prod_cd                      -- 产品代码               
       ,bus_kind_cd                  -- 业务种类代码             
       ,bus_type_cd                  -- 业务类型代码             
       ,proc_status_cd               -- 处理状态代码             
       ,npc_proc_cd                  -- NPC处理代码            
       ,check_entry_status_cd        -- 对账状态代码             
       ,debit_crdt_cd                -- 借贷代码               
       ,entry_code                   -- 记账分录编码             
       ,acct_gen_cd                  -- 账户大类型代码            
       ,acct_type_cd                 -- 账户类型代码             
       ,e_acct_cd                    -- 电子账户代码             
       ,rec_status_cd                -- 记录状态代码             
       ,mode_pay_cd                  -- 支付方式代码             
       ,exch_bus_tran_chn_cd         -- 汇兑业务交易渠道代码         
       ,ground_proc_status_cd        -- 落地处理状态代码           
       ,verify_proc_status_cd        -- 查证处理状态代码           
       ,nostro_flg                   -- 往来账标志              
       ,charge_flg                   -- 收费标志               
       ,agent_flg                    -- 代理标志               
       ,intnal_acct_flg              -- 内部账标志              
       ,entr_dt                      -- 委托日期               
       ,host_dt                      -- 主机日期               
       ,clear_dt                     -- 清算日期               
       ,check_entry_dt               -- 对账日期               
       ,modif_dt                     -- 修改日期               
       ,modif_tm                     -- 修改时间               
       ,init_entr_dt                 -- 原委托日期              
       ,init_pay_tran_seq_num        -- 原支付交易序号            
       ,tran_amt                     -- 交易金额               
       ,comm_fee_amt                 -- 手续费用金额             
       ,remit_tran_fee_amt           -- 汇划费用金额             
       ,todos                        -- 工本费    
	     ,payer_open_bank_dept_id      -- 付款人开户行部门编号	
       ,payer_open_bank_no           -- 付款人开户行行号           
       ,payer_open_bank_name         -- 付款人开户行名称           
       ,payer_acct_num               -- 付款人账号              
       ,payer_name                   -- 付款人名称              
       ,payer_addr                   -- 付款人地址              
       ,recver_open_bank_no          -- 收款人开户行行号           
       ,recver_open_bank_name        -- 收款人开户行名称           
       ,recver_acct_num              -- 收款人账号              
       ,recver_name                  -- 收款人名称              
       ,recver_addr                  -- 收款人地址              
       ,err_return_code              -- 错误返回编码             
       ,err_info                     -- 错误信息               
       ,prior_level                  -- 优先级别               
       ,input_teller_id              -- 录入柜员编号             
       ,check_teller_id              -- 复核柜员编号             
       ,auth_teller_id               -- 授权柜员编号             
       ,input_check_teller_dept_id   -- 录入复核柜员部门编号         
       ,auth_teller_dept_id          -- 授权柜员部门编号           
       ,reg_main_acct_num            -- 挂账或维护入账账号          
       ,reg_main_name                -- 挂账或维护入账姓名          
       ,matn_enter_acct_dt           -- 维护入账日期             
       ,matn_enter_acct_teller_id    -- 维护入账柜员编号           
       ,matn_enter_acct_dept_id      -- 维护入账部门编号           
       ,vouch_type_cd                -- 凭证类型代码             
       ,vouch_dt                     -- 凭证日期               
       ,vouch_no                     -- 凭证号码               
       ,cert_kind_cd                 -- 证件种类代码             
       ,cert_no                      -- 证件号码               
       ,actl_deduct_acct_num         -- 实际扣账账号             
       ,actl_deduct_acct_name        -- 实际扣账户名称            
       ,rgst_addit_data_tab_name     -- 登记附加数据表名称          
       ,on_acct_rs_cd                -- 挂账原因代码             
       ,auto_refund_flg              -- 自动退汇标志             
       ,auto_refund_cnt              -- 自动退汇次数             
       ,vtual_bind_acct              -- 虚户绑定账户             
       ,vtual_bind_acct_name         -- 虚户绑定账户名称           
       ,vtual_open_acct_org_id       -- 虚户绑定账户开户机构编号
	     ,mgmt_org_id                  -- 管理机构编号
	     ,jnl_flow_num                 -- 日志流水号
	     ,bank_int_out_line_flg        -- 行内行外标志    
       ,revid_tm                     -- 收到时间
       ,job_cd                       -- 任务编码
       ,etl_timestamp                -- etl处理时间戳
)
select  t1.tran_dt                          as  etl_dt                         -- 数据日期
       ,t1.evt_id                           as  evt_id                         -- 事件编号
       ,t1.lp_id                            as  lp_id                          -- 法人编号
       ,t1.pay_decl_form_id                 as  pay_decl_form_id               -- 支付报单编号  
       ,t1.tran_dt                          as  tran_dt                        -- 交易日期    
       ,t1.out_line_pay_tran_seq_num        as  out_line_pay_tran_seq_num      -- 行外支付交易序号    
       ,t1.bank_int_bus_seq_num             as  bank_int_bus_seq_num           -- 行内业务序号 
       ,t1.origi_bank_no                    as  bus_origi_bank_no              -- 业务发起行行号
       ,'01'                                as  pbc_pass_tran_type_cd          -- 人行通道交易类型代码    
       ,t1.msg_type_id                      as  msg_type_id                    -- 报文类型编号      
       ,t1.scd_gener_msg_type_id            as  scd_gener_msg_type_id          -- 二代报文类型编号 
       ,t1.host_flow_num                    as  host_flow_num                  -- 主机流水号       
       ,t1.tran_flow_num                    as  tran_flow_num                  -- 交易流水号       
       ,t1.send_tran_flow_num               as  send_tran_flow_num             -- 发送交易流水号     
       ,t1.ova_flow_num                     as  ova_flow_num                   -- 全局流水号       
       ,t1.host_tran_code                   as  host_tran_code                 -- 主机交易码       
       ,t1.midgrod_tran_code                as  midgrod_tran_code              -- 中台交易码       
       ,t1.curr_cd                          as  curr_cd                        -- 币种代码        
       ,t1.prod_cd                          as  prod_cd                        -- 产品代码        
       ,t1.bus_kind_cd                      as  bus_kind_cd                    -- 业务种类代码      
       ,t1.bus_type_cd                      as  bus_type_cd                    -- 业务类型代码      
       ,t1.proc_status_cd                   as  proc_status_cd                 -- 处理状态代码      
       ,t1.npc_proc_cd                      as  npc_proc_cd                    -- NPC处理代码     
       ,t1.check_entry_status_cd            as  check_entry_status_cd          -- 对账状态代码      
       ,t1.debit_crdt_cd                    as  debit_crdt_cd                  -- 借贷代码        
       ,t2.entry_code                       as  entry_code                     -- 记账分录编码      
       ,t1.acct_gen_cd                      as  acct_gen_cd                    -- 账户大类型代码     
       ,t1.acct_type_cd                     as  acct_type_cd                   -- 账户类型代码      
       ,t1.e_acct_cd                        as  e_acct_cd                      -- 电子账户代码      
       ,t1.rec_status_cd                    as  rec_status_cd                  -- 记录状态代码      
       ,t1.mode_pay_cd                      as  mode_pay_cd                    -- 支付方式代码      
       ,t1.exch_bus_tran_chn_cd             as  exch_bus_tran_chn_cd           -- 汇兑业务交易渠道代码  
       ,t1.ground_proc_status_cd            as  ground_proc_status_cd          -- 落地处理状态代码    
       ,t1.verify_proc_status_cd            as  verify_proc_status_cd          -- 查证处理状态代码    
       ,t1.nostro_flg                       as  nostro_flg                     -- 往来账标志       
       ,t1.charge_flg                       as  charge_flg                     -- 收费标志        
       ,t1.agent_flg                        as  agent_flg                      -- 代理标志        
       ,t1.intnal_acct_flg                  as  intnal_acct_flg                -- 内部账标志               
       ,t1.entr_dt                          as  entr_dt                        -- 委托日期        
       ,t1.host_dt                          as  host_dt                        -- 主机日期        
       ,t1.clear_dt                         as  clear_dt                       -- 清算日期        
       ,t2.check_entry_dt                   as  check_entry_dt                 -- 对账日期        
       ,t1.modif_dt                         as  modif_dt                       -- 修改日期        
       ,t1.modif_tm                         as  modif_tm                       -- 修改时间        
       ,t1.init_entr_dt                     as  init_entr_dt                   -- 原委托日期       
       ,t1.init_pay_tran_seq_num            as  init_pay_tran_seq_num          -- 原支付交易序号     
       ,t1.tran_amt                         as  tran_amt                       -- 交易金额        
       ,t1.comm_fee_amt                     as  comm_fee_amt                   -- 手续费用金额      
       ,t1.remit_tran_fee_amt               as  remit_tran_fee_amt             -- 汇划费用金额      
       ,t1.todos                            as  todos                          -- 工本费
       ,t1.payer_open_bank_dept_id          as payer_open_bank_dept_id         -- 付款人开户行部门编号	   
       ,t1.payer_open_bank_no               as  payer_open_bank_no             -- 付款人开户行行号    
       ,t1.payer_open_bank_name             as  payer_open_bank_name           -- 付款人开户行名称    
       ,t1.payer_acct_num                   as  payer_acct_num                 -- 付款人账号       
       ,t1.payer_name                       as  payer_name                     -- 付款人名称       
       ,t1.payer_addr                       as  payer_addr                     -- 付款人地址       
       ,t1.recver_open_bank_no              as  recver_open_bank_no            -- 收款人开户行行号    
       ,t1.recver_open_bank_name            as  recver_open_bank_name          -- 收款人开户行名称    
       ,t1.recver_acct_num                  as  recver_acct_num                -- 收款人账号       
       ,t1.recver_name                      as  recver_name                    -- 收款人名称       
       ,t1.recver_addr                      as  recver_addr                    -- 收款人地址       
       ,t1.err_return_code                  as  err_return_code                -- 错误返回编码      
       ,t1.err_info                         as  err_info                       -- 错误信息        
       ,t1.prior_level                      as  prior_level                    -- 优先级别        
       ,t1.input_teller_id                  as  input_teller_id                -- 录入柜员编号      
       ,t1.check_teller_id                  as  check_teller_id                -- 复核柜员编号      
       ,t1.auth_teller_id                   as  auth_teller_id                 -- 授权柜员编号      
       ,t1.input_check_teller_dept_id       as  input_check_teller_dept_id     -- 录入复核柜员部门编号  
       ,t1.auth_teller_dept_id              as  auth_teller_dept_id            -- 授权柜员部门编号    
       ,t1.reg_main_acct_num                as  reg_main_acct_num              -- 挂账或维护入账账号   
       ,t1.reg_main_name                    as  reg_main_name                  -- 挂账或维护入账姓名   
       ,t1.matn_enter_acct_dt               as  matn_enter_acct_dt             -- 维护入账日期      
       ,t1.matn_enter_acct_teller_id        as  matn_enter_acct_teller_id      -- 维护入账柜员编号    
       ,t1.matn_enter_acct_dept_id          as  matn_enter_acct_dept_id        -- 维护入账部门编号    
       ,t1.vouch_type_cd                    as  vouch_type_cd                  -- 凭证类型代码      
       ,t1.vouch_dt                         as  vouch_dt                       -- 凭证日期        
       ,t1.vouch_no                         as  vouch_no                       -- 凭证号码        
       ,t1.cert_kind_cd                     as  cert_kind_cd                   -- 证件种类代码      
       ,t1.cert_no                          as  cert_no                        -- 证件号码        
       ,t1.actl_deduct_acct_num             as  actl_deduct_acct_num           -- 实际扣账账号      
       ,t1.actl_deduct_acct_name            as  actl_deduct_acct_name          -- 实际扣账户名称     
       ,t1.rgst_addit_data_name             as  rgst_addit_data_tab_name       -- 登记附加数据表名称   
       ,t1.on_acct_rs_cd                    as  on_acct_rs_cd                  -- 挂账原因代码      
       ,t1.auto_refund_flg                  as  auto_refund_flg                -- 自动退汇标志      
       ,t1.auto_refund_cnt                  as  auto_refund_cnt                -- 自动退汇次数      
       ,t1.vtual_acct_bind_acct             as  vtual_bind_acct                -- 虚户绑定账户      
       ,t1.vtual_acct_bind_acct_name        as  vtual_bind_acct_name           -- 虚户绑定账户名称  
       ,T1.vtual_open_acct_org_id           as  vtual_open_acct_org_id         -- 虚户绑定账户开户机构编号
	     ,t1.mgmt_org_id                      as  mgmt_org_id                    -- 管理机构编号
       ,t1.jnl_flow_num                     as  jnl_flow_num                   -- 日志流水号
       ,''                                  as  bank_int_out_line_flg          -- 行内行外标志    	   
       ,t1.revid_tm                         as  revid_tm                       -- 收到时间
       ,'mpcsi1'                            as  job_cd                         -- 任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
  from ${iml_schema}.evt_bigamt_tran_evt t1       -- 大额交易事件
  left join ${iml_schema}.evt_bs_amt_entry_evt t2 -- 大小额记账事件
    on t1.bank_int_bus_seq_num = t2.bank_int_bus_seq_num
   and t1.pay_decl_form_id = t2.bs_amt_entry_id
   and t1.tran_dt = t2.tran_dt
  and t2.tran_dt <= to_date('${batch_date}','yyyymmdd') and t2.tran_dt >= to_date('${batch_date}','yyyymmdd') - 14
  and t2.job_cd='mpcsi1'
  where t1.tran_dt <= to_date('${batch_date}','yyyymmdd') and t1.tran_dt >= to_date('${batch_date}','yyyymmdd') - 14
    and t1.job_cd='mpcsi1'
;

commit;

-- 第二组（小额交易事件）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_pbc_pass_tran_flow(
        etl_dt                       -- 数据日期
       ,evt_id                       -- 事件编号  
       ,lp_id                        -- 法人编号
       ,pay_decl_form_id             -- 支付报单编号  
       ,tran_dt                      -- 交易日期                          
       ,out_line_pay_tran_seq_num    -- 行外支付交易序号           
       ,bank_int_bus_seq_num         -- 行内业务序号     
       ,bus_origi_bank_no            -- 业务发起行行号
       ,pbc_pass_tran_type_cd        -- 人行通道交易类型代码        
       ,msg_type_id                  -- 报文类型编号             
       ,scd_gener_msg_type_id        -- 二代报文类型编号 
       ,host_flow_num                -- 主机流水号              
       ,tran_flow_num                -- 交易流水号              
       ,send_tran_flow_num           -- 发送交易流水号            
       ,ova_flow_num                 -- 全局流水号              
       ,host_tran_code               -- 主机交易码              
       ,midgrod_tran_code            -- 中台交易码              
       ,curr_cd                      -- 币种代码               
       ,prod_cd                      -- 产品代码               
       ,bus_kind_cd                  -- 业务种类代码             
       ,bus_type_cd                  -- 业务类型代码             
       ,proc_status_cd               -- 处理状态代码             
       ,npc_proc_cd                  -- NPC处理代码            
       ,check_entry_status_cd        -- 对账状态代码             
       ,debit_crdt_cd                -- 借贷代码               
       ,entry_code                   -- 记账分录编码             
       ,acct_gen_cd                  -- 账户大类型代码            
       ,acct_type_cd                 -- 账户类型代码             
       ,e_acct_cd                    -- 电子账户代码             
       ,rec_status_cd                -- 记录状态代码             
       ,mode_pay_cd                  -- 支付方式代码             
       ,exch_bus_tran_chn_cd         -- 汇兑业务交易渠道代码         
       ,ground_proc_status_cd        -- 落地处理状态代码           
       ,verify_proc_status_cd        -- 查证处理状态代码           
       ,nostro_flg                   -- 往来账标志              
       ,charge_flg                   -- 收费标志               
       ,agent_flg                    -- 代理标志               
       ,intnal_acct_flg              -- 内部账标志              
       ,entr_dt                      -- 委托日期               
       ,host_dt                      -- 主机日期               
       ,clear_dt                     -- 清算日期               
       ,check_entry_dt               -- 对账日期               
       ,modif_dt                     -- 修改日期               
       ,modif_tm                     -- 修改时间               
       ,init_entr_dt                 -- 原委托日期              
       ,init_pay_tran_seq_num        -- 原支付交易序号            
       ,tran_amt                     -- 交易金额               
       ,comm_fee_amt                 -- 手续费用金额             
       ,remit_tran_fee_amt           -- 汇划费用金额             
       ,todos                        -- 工本费 
	     ,payer_open_bank_dept_id      -- 付款人开户行部门编号
       ,payer_open_bank_no           -- 付款人开户行行号           
       ,payer_open_bank_name         -- 付款人开户行名称           
       ,payer_acct_num               -- 付款人账号              
       ,payer_name                   -- 付款人名称              
       ,payer_addr                   -- 付款人地址              
       ,recver_open_bank_no          -- 收款人开户行行号           
       ,recver_open_bank_name        -- 收款人开户行名称           
       ,recver_acct_num              -- 收款人账号              
       ,recver_name                  -- 收款人名称              
       ,recver_addr                  -- 收款人地址              
       ,err_return_code              -- 错误返回编码             
       ,err_info                     -- 错误信息               
       ,prior_level                  -- 优先级别               
       ,input_teller_id              -- 录入柜员编号             
       ,check_teller_id              -- 复核柜员编号             
       ,auth_teller_id               -- 授权柜员编号             
       ,input_check_teller_dept_id   -- 录入复核柜员部门编号         
       ,auth_teller_dept_id          -- 授权柜员部门编号           
       ,reg_main_acct_num            -- 挂账或维护入账账号          
       ,reg_main_name                -- 挂账或维护入账姓名          
       ,matn_enter_acct_dt           -- 维护入账日期             
       ,matn_enter_acct_teller_id    -- 维护入账柜员编号           
       ,matn_enter_acct_dept_id      -- 维护入账部门编号           
       ,vouch_type_cd                -- 凭证类型代码             
       ,vouch_dt                     -- 凭证日期               
       ,vouch_no                     -- 凭证号码               
       ,cert_kind_cd                 -- 证件种类代码             
       ,cert_no                      -- 证件号码               
       ,actl_deduct_acct_num         -- 实际扣账账号             
       ,actl_deduct_acct_name        -- 实际扣账户名称            
       ,rgst_addit_data_tab_name     -- 登记附加数据表名称          
       ,on_acct_rs_cd                -- 挂账原因代码             
       ,auto_refund_flg              -- 自动退汇标志             
       ,auto_refund_cnt              -- 自动退汇次数             
       ,vtual_bind_acct              -- 虚户绑定账户             
       ,vtual_bind_acct_name         -- 虚户绑定账户名称           
       ,vtual_open_acct_org_id       -- 虚户绑定账户开户机构编号  
	     ,mgmt_org_id                  -- 管理机构编号
	     ,jnl_flow_num                 -- 日志流水号
	     ,bank_int_out_line_flg        -- 行内行外标志 	   
       ,revid_tm                     -- 收到时间
       ,job_cd                       -- 任务编码
       ,etl_timestamp                -- etl处理时间戳
)
select  t1.tran_dt                          as  etl_dt                          -- 数据日期
       ,t1.evt_id                           as  evt_id                          -- 事件编号
       ,t1.lp_id                            as  lp_id                           -- 法人编号
       ,t1.pay_decl_form_id                 as  pay_decl_form_id                -- 支付报单编号    
       ,t1.tran_dt                          as  tran_dt                         -- 交易日期          
       ,t1.pkg_seq_num ||t1.out_line_pay_tran_seq_num as out_line_pay_tran_seq_num  -- 行外支付交易序号    
       ,t1.bank_int_bus_seq_num             as  bank_int_bus_seq_num            -- 行内业务序号 
       ,t1.origi_bank_no                    as  bus_origi_bank_no               -- 业务发起行行号
       ,'02'                                as  pbc_pass_tran_type_cd           -- 人行通道交易类型代码      
       ,t1.pkg_type                         as  msg_type_id                     -- 报文类型编号      
       ,t1.scd_gener_msg_type_id            as  scd_gener_msg_type_id           -- 二代报文类型编号 
       ,t1.host_flow_num                    as  host_flow_num                   -- 主机流水号       
       ,t1.tran_flow_num                    as  tran_flow_num                   -- 交易流水号       
       ,t1.send_tran_flow_num               as  send_tran_flow_num              -- 发送交易流水号     
       ,t1.ova_flow_num                     as  ova_flow_num                    -- 全局流水号       
       ,t1.host_tran_code                   as  host_tran_code                  -- 主机交易码       
       ,t1.midgrod_tran_code                as  midgrod_tran_code               -- 中台交易码       
       ,t1.curr_cd                          as  curr_cd                         -- 币种代码        
       ,t1.prod_cd                          as  prod_cd                         -- 产品代码        
       ,t1.bus_kind_cd                      as  bus_kind_cd                     -- 业务种类代码      
       ,t1.bus_type_cd                      as  bus_type_cd                     -- 业务类型代码      
       ,t1.proc_status_cd                   as  proc_status_cd                  -- 处理状态代码      
       ,t1.proc_cd                          as  npc_proc_cd                     -- NPC处理代码     
       ,t1.check_entry_status_cd            as  check_entry_status_cd           -- 对账状态代码      
       ,t1.debit_crdt_cd                    as  debit_crdt_cd                   -- 借贷代码        
       ,t2.entry_code                       as  entry_code                      -- 记账分录编码      
       ,t1.acct_gen_cd                      as  acct_gen_cd                     -- 账户大类型代码     
       ,t1.acct_type_cd                     as  acct_type_cd                    -- 账户类型代码      
       ,t1.e_acct_cd                        as  e_acct_cd                       -- 电子账户代码      
       ,t1.rec_status_cd                    as  rec_status_cd                   -- 记录状态代码      
       ,t1.mode_pay_cd                      as  mode_pay_cd                     -- 支付方式代码      
       ,t1.exch_bus_cors_tran_chn_cd        as  exch_bus_tran_chn_cd            -- 汇兑业务交易渠道代码  
       ,t1.ground_proc_status_cd            as  ground_proc_status_cd           -- 落地处理状态代码    
       ,t1.verify_proc_status_cd            as  verify_proc_status_cd           -- 查证处理状态代码    
       ,t1.nostro_flg                       as  nostro_flg                      -- 往来账标志       
       ,t1.charge_flg                       as  charge_flg                      -- 收费标志        
       ,t1.agent_flg                        as  agent_flg                       -- 代理标志        
       ,t1.intnal_acct_flg                  as  intnal_acct_flg                 -- 内部账标志       
       ,t1.entr_dt                          as  entr_dt                         -- 委托日期        
       ,t1.host_dt                          as  host_dt                         -- 主机日期        
       ,t1.clear_dt                         as  clear_dt                        -- 清算日期        
       ,t2.check_entry_dt                   as  check_entry_dt                  -- 对账日期        
       ,t1.recnt_modif_dt                   as  modif_dt                        -- 修改日期        
       ,t1.recnt_modif_tm                   as  modif_tm                        -- 修改时间        
       ,t1.init_entr_dt                     as  init_entr_dt                    -- 原委托日期       
       ,t1.init_pay_tran_seq_num            as  init_pay_tran_seq_num           -- 原支付交易序号     
       ,t1.tran_amt                         as  tran_amt                        -- 交易金额        
       ,t1.comm_fee                         as  comm_fee_amt                    -- 手续费用金额      
       ,t1.remit_tran_fee                   as  remit_tran_fee_amt              -- 汇划费用金额      
       ,t1.todos                            as  todos                           -- 工本费  
       ,t1.payer_open_bank_dept_id          as  payer_open_bank_dept_id         -- 付款人开户行部门编号       
       ,t1.payer_open_bank_no               as  payer_open_bank_no              -- 付款人开户行行号    
       ,t1.payer_open_bank_name             as  payer_open_bank_name            -- 付款人开户行名称    
       ,t1.payer_acct_num                   as  payer_acct_num                  -- 付款人账号       
       ,t1.payer_name                       as  payer_name                      -- 付款人名称       
       ,t1.payer_addr                       as  payer_addr                      -- 付款人地址       
       ,t1.recver_open_bank_no              as  recver_open_bank_no             -- 收款人开户行行号    
       ,t1.recver_open_bank_name            as  recver_open_bank_name           -- 收款人开户行名称    
       ,t1.recver_acct_num                  as  recver_acct_num                 -- 收款人账号       
       ,t1.recver_name                      as  recver_name                     -- 收款人名称       
       ,t1.recver_addr                      as  recver_addr                     -- 收款人地址       
       ,t1.err_code                         as  err_return_code                 -- 错误返回编码      
       ,t1.err_info                         as  err_info                        -- 错误信息        
       ,t1.prior_level                      as  prior_level                     -- 优先级别        
       ,t1.input_teller_id                  as  input_teller_id                 -- 录入柜员编号      
       ,t1.check_teller_id                  as  check_teller_id                 -- 复核柜员编号      
       ,t1.auth_teller_id                   as  auth_teller_id                  -- 授权柜员编号      
       ,t1.input_check_teller_dept_id       as  input_check_teller_dept_id      -- 录入复核柜员部门编号  
       ,t1.auth_teller_dept_id              as  auth_teller_dept_id             -- 授权柜员部门编号    
       ,t1.matn_enter_acct_num              as  reg_main_acct_num               -- 挂账或维护入账账号   
       ,t1.reg_main_name                    as  reg_main_name                   -- 挂账或维护入账姓名   
       ,t1.matn_enter_acct_dt               as  matn_enter_acct_dt              -- 维护入账日期      
       ,t1.matn_enter_acct_teller_id        as  matn_enter_acct_teller_id       -- 维护入账柜员编号    
       ,t1.matn_enter_acct_dept_id          as  matn_enter_acct_dept_id         -- 维护入账部门编号    
       ,t1.vouch_type_cd                    as  vouch_type_cd                   -- 凭证类型代码      
       ,t1.entr_vouch_dt                    as  vouch_dt                        -- 凭证日期        
       ,t1.entr_vouch_num                   as  vouch_no                        -- 凭证号码        
       ,t1.cert_kind_cd                     as  cert_kind_cd                    -- 证件种类代码      
       ,t1.cert_no                          as  cert_no                         -- 证件号码        
       ,t1.actl_deduct_acct_num             as  actl_deduct_acct_num            -- 实际扣账账号      
       ,t1.actl_deduct_acct_name            as  actl_deduct_acct_name           -- 实际扣账户名称     
       ,t1.rgst_addit_data_name             as  rgst_addit_data_tab_name        -- 登记附加数据表名称   
       ,t1.on_acct_rs_cd                    as  on_acct_rs_cd                   -- 挂账原因代码      
       ,t1.auto_refund_flg                  as  auto_refund_flg                 -- 自动退汇标志      
       ,t1.auto_refund_cnt                  as  auto_refund_cnt                 -- 自动退汇次数      
       ,t1.vtual_acct_bind_acct             as  vtual_bind_acct                 -- 虚户绑定账户      
       ,t1.vtual_acct_bind_acct_name        as  vtual_bind_acct_name            -- 虚户绑定账户名称    
       ,t1.vtual_open_acct_org_id           as  vtual_open_acct_org_id          -- 虚户绑定账户开户机构编号
	     ,t1.proc_org_id                      as  mgmt_org_id                     -- 管理机构编号
       ,t1.jnl_flow_num                     as  jnl_flow_num                    -- 日志流水号
       ,t1.bank_int_out_line_flg            as  bank_int_out_line_flg           -- 行内行外标志    
       ,t1.revid_tm                         as  revid_tm                        -- 收到时间
       ,'mpcsi2'                            as  job_cd                          -- 任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
  from ${iml_schema}.evt_beps_tran_evt t1         -- 小额交易事件
  left join ${iml_schema}.evt_bs_amt_entry_evt t2 -- 大小额记账事件
    on t1.bank_int_bus_seq_num = t2.bank_int_bus_seq_num
   and t1.pay_decl_form_id = t2.bs_amt_entry_id
   and t1.tran_dt = t2.tran_dt
   and t2.tran_dt <= to_date('${batch_date}','yyyymmdd') and t2.tran_dt >= to_date('${batch_date}','yyyymmdd') - 14
   and t2.job_cd='mpcsi1'
  where t1.tran_dt <= to_date('${batch_date}','yyyymmdd') and t1.tran_dt >= to_date('${batch_date}','yyyymmdd') - 14
    and t1.job_cd='mpcsi1'
;
commit;

-- 第三组（省金服交易事件）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_pbc_pass_tran_flow(
        etl_dt                       -- 数据日期
       ,evt_id                       -- 事件编号  
       ,lp_id                        -- 法人编号
       ,pay_decl_form_id             -- 支付报单编号  
       ,tran_dt                      -- 交易日期                          
       ,out_line_pay_tran_seq_num    -- 行外支付交易序号           
       ,bank_int_bus_seq_num         -- 行内业务序号    
       ,bus_origi_bank_no            -- 业务发起行行号
       ,pbc_pass_tran_type_cd        -- 人行通道交易类型代码         
       ,msg_type_id                  -- 报文类型编号             
       ,scd_gener_msg_type_id        -- 二代报文类型编号
       ,host_flow_num                -- 主机流水号              
       ,tran_flow_num                -- 交易流水号              
       ,send_tran_flow_num           -- 发送交易流水号            
       ,ova_flow_num                 -- 全局流水号              
       ,host_tran_code               -- 主机交易码              
       ,midgrod_tran_code            -- 中台交易码              
       ,curr_cd                      -- 币种代码               
       ,prod_cd                      -- 产品代码               
       ,bus_kind_cd                  -- 业务种类代码             
       ,bus_type_cd                  -- 业务类型代码             
       ,proc_status_cd               -- 处理状态代码             
       ,npc_proc_cd                  -- NPC处理代码            
       ,check_entry_status_cd        -- 对账状态代码             
       ,debit_crdt_cd                -- 借贷代码               
       ,entry_code                   -- 记账分录编码             
       ,acct_gen_cd                  -- 账户大类型代码            
       ,acct_type_cd                 -- 账户类型代码             
       ,e_acct_cd                    -- 电子账户代码             
       ,rec_status_cd                -- 记录状态代码             
       ,mode_pay_cd                  -- 支付方式代码             
       ,exch_bus_tran_chn_cd         -- 汇兑业务交易渠道代码         
       ,ground_proc_status_cd        -- 落地处理状态代码           
       ,verify_proc_status_cd        -- 查证处理状态代码           
       ,nostro_flg                   -- 往来账标志              
       ,charge_flg                   -- 收费标志               
       ,agent_flg                    -- 代理标志               
       ,intnal_acct_flg              -- 内部账标志              
       ,entr_dt                      -- 委托日期               
       ,host_dt                      -- 主机日期               
       ,clear_dt                     -- 清算日期               
       ,check_entry_dt               -- 对账日期               
       ,modif_dt                     -- 修改日期               
       ,modif_tm                     -- 修改时间               
       ,init_entr_dt                 -- 原委托日期              
       ,init_pay_tran_seq_num        -- 原支付交易序号            
       ,tran_amt                     -- 交易金额               
       ,comm_fee_amt                 -- 手续费用金额             
       ,remit_tran_fee_amt           -- 汇划费用金额             
       ,todos                        -- 工本费 
       ,payer_open_bank_dept_id      -- 付款人开户行部门编号	   
       ,payer_open_bank_no           -- 付款人开户行行号           
       ,payer_open_bank_name         -- 付款人开户行名称           
       ,payer_acct_num               -- 付款人账号              
       ,payer_name                   -- 付款人名称              
       ,payer_addr                   -- 付款人地址              
       ,recver_open_bank_no          -- 收款人开户行行号           
       ,recver_open_bank_name        -- 收款人开户行名称           
       ,recver_acct_num              -- 收款人账号              
       ,recver_name                  -- 收款人名称              
       ,recver_addr                  -- 收款人地址              
       ,err_return_code              -- 错误返回编码             
       ,err_info                     -- 错误信息               
       ,prior_level                  -- 优先级别               
       ,input_teller_id              -- 录入柜员编号             
       ,check_teller_id              -- 复核柜员编号             
       ,auth_teller_id               -- 授权柜员编号             
       ,input_check_teller_dept_id   -- 录入复核柜员部门编号         
       ,auth_teller_dept_id          -- 授权柜员部门编号           
       ,reg_main_acct_num            -- 挂账或维护入账账号          
       ,reg_main_name                -- 挂账或维护入账姓名          
       ,matn_enter_acct_dt           -- 维护入账日期             
       ,matn_enter_acct_teller_id    -- 维护入账柜员编号           
       ,matn_enter_acct_dept_id      -- 维护入账部门编号           
       ,vouch_type_cd                -- 凭证类型代码             
       ,vouch_dt                     -- 凭证日期               
       ,vouch_no                     -- 凭证号码               
       ,cert_kind_cd                 -- 证件种类代码             
       ,cert_no                      -- 证件号码               
       ,actl_deduct_acct_num         -- 实际扣账账号             
       ,actl_deduct_acct_name        -- 实际扣账户名称            
       ,rgst_addit_data_tab_name     -- 登记附加数据表名称          
       ,on_acct_rs_cd                -- 挂账原因代码             
       ,auto_refund_flg              -- 自动退汇标志             
       ,auto_refund_cnt              -- 自动退汇次数             
       ,vtual_bind_acct              -- 虚户绑定账户             
       ,vtual_bind_acct_name         -- 虚户绑定账户名称           
       ,vtual_open_acct_org_id       -- 虚户绑定账户开户机构编号
	     ,mgmt_org_id                  -- 管理机构编号
	     ,jnl_flow_num                 -- 日志流水号
	     ,bank_int_out_line_flg        -- 行内行外标志        
       ,revid_tm                     -- 收到时间
       ,job_cd                       -- 任务编码
       ,etl_timestamp                -- etl处理时间戳
)
select  t1.front_dt                         as  etl_dt                         -- 数据日期
       ,t1.evt_id                           as  evt_id                         -- 事件编号
       ,t1.lp_id                            as  lp_id                          -- 法人编号
       ,t1.front_flow_num                   as  pay_decl_form_id               -- 支付报单编号 
       ,t1.front_dt                         as  tran_dt                        -- 交易日期       
       ,t1.pay_report_info_seq_num          as  out_line_pay_tran_seq_num      -- 行外支付交易序号    
       ,''                                  as  bank_int_bus_seq_num           -- 行内业务序号   
       ,t1.origi_bank_no                    as  bus_origi_bank_no              -- 业务发起行行号
       ,'03'                                as  pbc_pass_tran_type_cd          -- 人行通道交易类型代码    
       ,''                                  as  msg_type_id                    -- 报文类型编号      
       ,t1.msg_id                           as  scd_gener_msg_type_id          -- 二代报文类型编号
       ,t1.host_flow_num                    as  host_flow_num                  -- 主机流水号       
       ,''                                  as  tran_flow_num                  -- 交易流水号       
       ,''                                  as  send_tran_flow_num             -- 发送交易流水号     
       ,t1.ova_flow_num                     as  ova_flow_num                   -- 全局流水号       
       ,''                                  as  host_tran_code                 -- 主机交易码       
       ,t1.midgrod_tran_code                as  midgrod_tran_code              -- 中台交易码       
       ,t1.curr_cd                          as  curr_cd                        -- 币种代码        
       ,''                                  as  prod_cd                        -- 产品代码        
       ,t1.bus_kind_cd                      as  bus_kind_cd                    -- 业务种类代码      
       ,''                                  as  bus_type_cd                    -- 业务类型代码      
       ,t1.status_cd                        as  proc_status_cd                 -- 处理状态代码      
       ,''                                  as  npc_proc_cd                    -- NPC处理代码     
       ,''                                  as  check_entry_status_cd          -- 对账状态代码      
       ,''                                  as  debit_crdt_cd                  -- 借贷代码        
       ,t2.acct_ety_code                    as  entry_code                     -- 记账分录编码      
       ,''                                  as  acct_gen_cd                    -- 账户大类型代码     
       ,t1.acct_type_cd                     as  acct_type_cd                   -- 账户类型代码      
       ,t1.e_acct_cd                        as  e_acct_cd                      -- 电子账户代码      
       ,''                                  as  rec_status_cd                  -- 记录状态代码      
       ,t1.mode_pay_cd                      as  mode_pay_cd                    -- 支付方式代码      
       ,t1.chn_cd                           as  exch_bus_tran_chn_cd           -- 汇兑业务交易渠道代码  
       ,''                                  as  ground_proc_status_cd          -- 落地处理状态代码    
       ,''                                  as  verify_proc_status_cd          -- 查证处理状态代码    
       ,t1.nostro_flg                       as  nostro_flg                     -- 往来账标志       
       ,''                                  as  charge_flg                     -- 收费标志        
       ,''                                  as  agent_flg                      -- 代理标志        
       ,t1.intnal_acct_flg                  as  intnal_acct_flg                -- 内部账标志             
       ,t1.entr_dt                          as  entr_dt                        -- 委托日期        
       ,t1.host_dt                          as  host_dt                        -- 主机日期        
       ,t1.clear_dt                         as  clear_dt                       -- 清算日期        
       ,t2.check_entry_dt                   as  check_entry_dt                 -- 对账日期        
       ,to_date('29991231','yyyymmdd')      as  modif_dt                       -- 修改日期        
       ,to_timestamp('2099-12-31','yyyy-mm-dd hh24:mi:ss.ff6') as  modif_tm    -- 修改时间        
       ,t1.init_entr_dt                     as  init_entr_dt                   -- 原委托日期       
       ,t1.init_tran_pay_odd_no             as  init_pay_tran_seq_num          -- 原支付交易序号     
       ,t1.tran_amt                         as  tran_amt                       -- 交易金额        
       ,t1.comm_fee                         as  comm_fee_amt                   -- 手续费用金额      
       ,0                                   as  remit_tran_fee_amt             -- 汇划费用金额      
       ,t1.todos                            as  todos                          -- 工本费  
       ,''                                  as  payer_open_bank_dept_id        -- 付款人开户行部门编号       
       ,t1.payer_open_bank_no               as  payer_open_bank_no             -- 付款人开户行行号    
       ,''                                  as  payer_open_bank_name           -- 付款人开户行名称    
       ,t1.payer_acct_num                   as  payer_acct_num                 -- 付款人账号       
       ,t1.payer_name                       as  payer_name                     -- 付款人名称       
       ,t1.payer_addr                       as  payer_addr                     -- 付款人地址       
       ,t1.recver_open_bank_no              as  recver_open_bank_no            -- 收款人开户行行号    
       ,''                                  as  recver_open_bank_name          -- 收款人开户行名称    
       ,t1.recver_acct_num                  as  recver_acct_num                -- 收款人账号       
       ,t1.recver_name                      as  recver_name                    -- 收款人名称       
       ,t1.recver_addr                      as  recver_addr                    -- 收款人地址       
       ,t1.err_code                         as  err_return_code                -- 错误返回编码      
       ,t1.err_info                         as  err_info                       -- 错误信息        
       ,''                                  as  prior_level                    -- 优先级别        
       ,t1.teller_id                        as  input_teller_id                -- 录入柜员编号    
       ,t1.teller_id                        as  check_teller_id                -- 复核柜员编号      
       ,t1.auth_teller_id                   as  auth_teller_id                 -- 授权柜员编号  	   
       ,t1.org_id                           as  input_check_teller_dept_id     -- 录入复核柜员部门编号  
       ,t1.auth_teller_dept_id              as  auth_teller_dept_id            -- 授权柜员部门编号    
       ,''                                  as  reg_main_acct_num              -- 挂账或维护入账账号   
       ,''                                  as  reg_main_name                  -- 挂账或维护入账姓名   
       ,to_date('29991231','yyyymmdd')      as  matn_enter_acct_dt             -- 维护入账日期      
       ,''                                  as  matn_enter_acct_teller_id      -- 维护入账柜员编号    
       ,''                                  as  matn_enter_acct_dept_id        -- 维护入账部门编号    
       ,t1.vouch_type_cd                    as  vouch_type_cd                  -- 凭证类型代码      
       ,t1.entr_dt                          as  vouch_dt                       -- 凭证日期        
       ,t1.entr_vouch_id                    as  vouch_no                       -- 凭证号码        
       ,t1.cert_type_cd                     as  cert_kind_cd                   -- 证件种类代码      
       ,t1.cert_no                          as  cert_no                        -- 证件号码        
       ,t1.actl_acct_num                    as  actl_deduct_acct_num           -- 实际扣账账号      
       ,t1.actl_deduct_acct_name            as  actl_deduct_acct_name          -- 实际扣账户名称     
       ,''                                  as  rgst_addit_data_tab_name       -- 登记附加数据表名称   
       ,''                                  as  on_acct_rs_cd                  -- 挂账原因代码      
       ,t1.auto_refund_flg                  as  auto_refund_flg                -- 自动退汇标志      
       ,t1.auto_refund_cnt                  as  auto_refund_cnt                -- 自动退汇次数      
       ,t1.vtual_acct_bind_acct             as  vtual_bind_acct                -- 虚户绑定账户      
       ,t1.vtual_acct_bind_acct_name        as  vtual_bind_acct_name           -- 虚户绑定账户名称    
       ,t1.vtual_open_acct_org_id           as  vtual_open_acct_org_id         -- 虚户绑定账户开户机构编号
	     ,t1.mgmt_org_id                      as  mgmt_org_id                    -- 管理机构编号
	     ,''                                  as  jnl_flow_num                   -- 日志流水号
	     ,''                                  as  bank_int_out_line_flg          -- 行内行外标志 
       ,''                                  as  revid_tm                       -- 收到时间
       ,'mpcsi3'                            as  job_cd                          
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
  from ${iml_schema}.evt_tef_tran_evt t1       -- 省金服交易事件
  left join ${iml_schema}.evt_tef_entry_evt t2 -- 省金服记账事件
   on t1.front_flow_num = t2.front_flow_num
  and t1.front_dt = t2.front_dt
  and t2.front_dt <= to_date('${batch_date}','yyyymmdd') and t2.front_dt >= to_date('${batch_date}','yyyymmdd') - 14
  and t2.job_cd='mpcsi1'
  where t1.front_dt <= to_date('${batch_date}','yyyymmdd') and t1.front_dt >= to_date('${batch_date}','yyyymmdd') - 14
  and t2.acct_ety_code <> '' 
  and t1.job_cd='mpcsi1'
;
commit;

-- 第四组（深同城交易事件）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_pbc_pass_tran_flow(
        etl_dt                       -- 数据日期
       ,evt_id                       -- 事件编号  
       ,lp_id                        -- 法人编号
       ,pay_decl_form_id             -- 支付报单编号  
       ,tran_dt                      -- 交易日期                          
       ,out_line_pay_tran_seq_num    -- 行外支付交易序号           
       ,bank_int_bus_seq_num         -- 行内业务序号   
       ,bus_origi_bank_no            -- 业务发起行行号
       ,pbc_pass_tran_type_cd        -- 人行通道交易类型代码          
       ,msg_type_id                  -- 报文类型编号             
       ,SCD_GENER_MSG_TYPE_ID        -- 二代报文类型编号
       ,host_flow_num                -- 主机流水号              
       ,tran_flow_num                -- 交易流水号              
       ,send_tran_flow_num           -- 发送交易流水号            
       ,ova_flow_num                 -- 全局流水号              
       ,host_tran_code               -- 主机交易码              
       ,midgrod_tran_code            -- 中台交易码              
       ,curr_cd                      -- 币种代码               
       ,prod_cd                      -- 产品代码               
       ,bus_kind_cd                  -- 业务种类代码             
       ,bus_type_cd                  -- 业务类型代码             
       ,proc_status_cd               -- 处理状态代码             
       ,npc_proc_cd                  -- NPC处理代码            
       ,check_entry_status_cd        -- 对账状态代码             
       ,debit_crdt_cd                -- 借贷代码               
       ,entry_code                   -- 记账分录编码             
       ,acct_gen_cd                  -- 账户大类型代码            
       ,acct_type_cd                 -- 账户类型代码             
       ,e_acct_cd                    -- 电子账户代码             
       ,rec_status_cd                -- 记录状态代码             
       ,mode_pay_cd                  -- 支付方式代码             
       ,exch_bus_tran_chn_cd         -- 汇兑业务交易渠道代码         
       ,ground_proc_status_cd        -- 落地处理状态代码           
       ,verify_proc_status_cd        -- 查证处理状态代码           
       ,nostro_flg                   -- 往来账标志              
       ,charge_flg                   -- 收费标志               
       ,agent_flg                    -- 代理标志               
       ,intnal_acct_flg              -- 内部账标志              
       ,entr_dt                      -- 委托日期               
       ,host_dt                      -- 主机日期               
       ,clear_dt                     -- 清算日期               
       ,check_entry_dt               -- 对账日期               
       ,modif_dt                     -- 修改日期               
       ,modif_tm                     -- 修改时间               
       ,init_entr_dt                 -- 原委托日期              
       ,init_pay_tran_seq_num        -- 原支付交易序号            
       ,tran_amt                     -- 交易金额               
       ,comm_fee_amt                 -- 手续费用金额             
       ,remit_tran_fee_amt           -- 汇划费用金额             
       ,todos                        -- 工本费  
       ,payer_open_bank_dept_id      -- 付款人开户行部门编号	   
       ,payer_open_bank_no           -- 付款人开户行行号           
       ,payer_open_bank_name         -- 付款人开户行名称           
       ,payer_acct_num               -- 付款人账号              
       ,payer_name                   -- 付款人名称              
       ,payer_addr                   -- 付款人地址              
       ,recver_open_bank_no          -- 收款人开户行行号           
       ,recver_open_bank_name        -- 收款人开户行名称           
       ,recver_acct_num              -- 收款人账号              
       ,recver_name                  -- 收款人名称              
       ,recver_addr                  -- 收款人地址              
       ,err_return_code              -- 错误返回编码             
       ,err_info                     -- 错误信息               
       ,prior_level                  -- 优先级别               
       ,input_teller_id              -- 录入柜员编号             
       ,check_teller_id              -- 复核柜员编号             
       ,auth_teller_id               -- 授权柜员编号             
       ,input_check_teller_dept_id   -- 录入复核柜员部门编号         
       ,auth_teller_dept_id          -- 授权柜员部门编号           
       ,reg_main_acct_num            -- 挂账或维护入账账号          
       ,reg_main_name                -- 挂账或维护入账姓名          
       ,matn_enter_acct_dt           -- 维护入账日期             
       ,matn_enter_acct_teller_id    -- 维护入账柜员编号           
       ,matn_enter_acct_dept_id      -- 维护入账部门编号           
       ,vouch_type_cd                -- 凭证类型代码             
       ,vouch_dt                     -- 凭证日期               
       ,vouch_no                     -- 凭证号码               
       ,cert_kind_cd                 -- 证件种类代码             
       ,cert_no                      -- 证件号码               
       ,actl_deduct_acct_num         -- 实际扣账账号             
       ,actl_deduct_acct_name        -- 实际扣账户名称            
       ,rgst_addit_data_tab_name     -- 登记附加数据表名称          
       ,on_acct_rs_cd                -- 挂账原因代码             
       ,auto_refund_flg              -- 自动退汇标志             
       ,auto_refund_cnt              -- 自动退汇次数             
       ,vtual_bind_acct              -- 虚户绑定账户             
       ,vtual_bind_acct_name         -- 虚户绑定账户名称           
       ,vtual_open_acct_org_id       -- 虚户绑定账户开户机构编号
	     ,mgmt_org_id                  -- 管理机构编号
	     ,jnl_flow_num                 -- 日志流水号
	     ,bank_int_out_line_flg        -- 行内行外标志        
       ,revid_tm                     -- 收到时间
       ,job_cd                       -- 任务编码
       ,etl_timestamp                -- etl处理时间戳
)
select  t1.etl_dt                                                   as etl_dt                         -- 数据日期
       ,t1.evt_id                                                   as evt_id                         -- 事件编号
       ,t1.lp_id                                                    as lp_id                          -- 法人编号
       ,t1.midgrod_flow_num                                         as pay_decl_form_id               -- 支付报单编号 
       ,t1.tran_dt                                                  as tran_dt                        -- 交易日期      
       ,t1.pay_tran_seq_num                                         as out_line_pay_tran_seq_num      -- 行外支付交易序号    
       ,t1.bank_int_bus_seq_num                                     as bank_int_bus_seq_num           -- 行内业务序号
       ,t1.pay_bank_no                                              as bus_origi_bank_no              -- 业务发起行行号
       ,'04'                                                        as pbc_pass_tran_type_cd          -- 人行通道交易类型代码       
       ,t1.msg_type_id                                              as msg_type_id                    -- 报文类型编号      
       ,t1.msg_type_id                                              as scd_gener_msg_type_id          -- 二代报文类型编号
       ,t1.host_flow_num                                            as host_flow_num                  -- 主机流水号       
       ,t1.tran_flow_num                                            as tran_flow_num                  -- 交易流水号       
       ,t1.send_tran_flow_num                                       as send_tran_flow_num             -- 发送交易流水号     
       ,''                                                          as ova_flow_num                   -- 全局流水号       
       ,t1.host_tran_code                                           as host_tran_code                 -- 主机交易码       
       ,t1.midgrod_tran_code                                        as midgrod_tran_code              -- 中台交易码       
       ,t1.curr_cd                                                  as curr_cd                        -- 币种代码        
       ,t1.prod_cd                                                  as prod_cd                        -- 产品代码        
       ,''                                                          as bus_kind_cd                    -- 业务种类代码      
       ,t1.bus_type_cd                                              as bus_type_cd                    -- 业务类型代码      
       ,t1.proc_status_cd                                           as proc_status_cd                 -- 处理状态代码      
       ,t1.center_return_proc_code                                  as npc_proc_cd                    -- NPC处理代码     
       ,t1.check_entry_status_cd                                    as check_entry_status_cd          -- 对账状态代码      
       ,t1.debit_crdt_cd                                            as debit_crdt_cd                  -- 借贷代码        
       ,t2.acct_ety_code                                            as entry_code                     -- 记账分录编码      
       ,t1.acct_cate_cd                                             as acct_gen_cd                    -- 账户大类型代码     
       ,t1.acct_type_cd                                             as acct_type_cd                   -- 账户类型代码      
       ,''                                                          as e_acct_cd                      -- 电子账户代码      
       ,t1.rec_status_cd                                            as rec_status_cd                  -- 记录状态代码      
       ,t1.mode_pay_cd                                              as mode_pay_cd                    -- 支付方式代码      
       ,t1.exch_bus_cors_tran_chn_cd                                as exch_bus_tran_chn_cd           -- 汇兑业务交易渠道代码  
       ,t1.ground_proc_status_cd                                    as ground_proc_status_cd          -- 落地处理状态代码    
       ,t1.verify_proc_status_cd                                    as verify_proc_status_cd          -- 查证处理状态代码    
       ,t1.nostro_flg                                               as nostro_flg                     -- 往来账标志       
       ,t1.charge_flg                                               as charge_flg                     -- 收费标志        
       ,t1.agent_flg                                                as agent_flg                      -- 代理标志        
       ,t1.intnal_acct_flg                                          as intnal_acct_flg                -- 内部账标志              
       ,t1.dtl_entr_dt                                              as entr_dt                        -- 委托日期        
       ,t1.host_dt                                                  as host_dt                        -- 主机日期        
       ,t1.clear_dt                                                 as clear_dt                       -- 清算日期        
       ,t2.check_entry_dt                                           as check_entry_dt                 -- 对账日期        
       ,to_date(to_char(t1.recnt_modif_tm,'yyyymmdd'),'yyyymmdd')   as modif_dt                       -- 修改日期        
       ,t1.recnt_modif_tm                                           as modif_tm                       -- 修改时间        
       ,t1.init_entr_dt                                             as init_entr_dt                   -- 原委托日期       
       ,t1.init_pay_tran_seq_num                                    as init_pay_tran_seq_num          -- 原支付交易序号     
       ,t1.tran_amt                                                 as tran_amt                       -- 交易金额        
       ,t1.comm_fee                                                 as comm_fee_amt                   -- 手续费用金额      
       ,t1.remit_tran_fee                                           as remit_tran_fee_amt             -- 汇划费用金额      
       ,t1.todos                                                    as todos                          -- 工本费 
       ,''                                                          as payer_open_bank_dept_id        -- 付款人开户行部门编号	   
       ,t1.payer_open_bank_no                                       as payer_open_bank_no             -- 付款人开户行行号    
       ,t1.payer_open_bank_name                                     as payer_open_bank_name           -- 付款人开户行名称    
       ,t1.payer_acct_num                                           as payer_acct_num                 -- 付款人账号       
       ,t1.payer_name                                               as payer_name                     -- 付款人名称       
       ,t1.payer_addr                                               as payer_addr                     -- 付款人地址       
       ,t1.recver_open_bank_no                                      as recver_open_bank_no            -- 收款人开户行行号    
       ,t1.recver_open_bank_name                                    as recver_open_bank_name          -- 收款人开户行名称    
       ,t1.recver_acct_num                                          as recver_acct_num                -- 收款人账号       
       ,t1.recver_name                                              as recver_name                    -- 收款人名称       
       ,t1.recver_addr                                              as recver_addr                    -- 收款人地址       
       ,t1.err_code                                                 as err_return_code                -- 错误返回编码      
       ,t1.err_info                                                 as err_info                       -- 错误信息        
       ,t1.prior_level                                              as prior_level                    -- 优先级别        
       ,t1.input_teller_id                                          as input_teller_id                -- 录入柜员编号      
       ,t1.check_teller_id                                          as check_teller_id                -- 复核柜员编号      
       ,t1.auth_teller_id                                           as auth_teller_id                 -- 授权柜员编号      
       ,t1.input_check_teller_dept_id                               as input_check_teller_dept_id     -- 录入复核柜员部门编号  
       ,t1.auth_teller_dept_id                                      as auth_teller_dept_id            -- 授权柜员部门编号    
       ,t1.matn_enter_acct_acct_num                                 as reg_main_acct_num              -- 挂账或维护入账账号   
       ,t1.reg_main_name                                            as reg_main_name                  -- 挂账或维护入账姓名   
       ,t1.matn_enter_acct_dt                                       as matn_enter_acct_dt             -- 维护入账日期      
       ,t1.matn_enter_acct_teller_id                                as matn_enter_acct_teller_id      -- 维护入账柜员编号    
       ,t1.matn_enter_acct_dept_id                                  as matn_enter_acct_dept_id        -- 维护入账部门编号    
       ,t1.vouch_type_cd                                            as vouch_type_cd                  -- 凭证类型代码      
       ,t1.entr_vouch_dt                                            as vouch_dt                       -- 凭证日期        
       ,t1.entr_vouch_id                                            as vouch_no                       -- 凭证号码        
       ,t1.cert_kind_cd                                             as cert_kind_cd                   -- 证件种类代码      
       ,t1.cert_no                                                  as cert_no                        -- 证件号码        
       ,t1.actl_deduct_acct_num                                     as actl_deduct_acct_num           -- 实际扣账账号      
       ,t1.actl_deduct_acct_name                                    as actl_deduct_acct_name          -- 实际扣账户名称     
       ,t1.rgst_addit_data_name                                     as rgst_addit_data_tab_name       -- 登记附加数据表名称   
       ,t1.on_acct_rs_cd                                            as on_acct_rs_cd                  -- 挂账原因代码      
       ,t1.auto_refund_flg                                          as auto_refund_flg                -- 自动退汇标志      
       ,t1.auto_refund_cnt                                          as auto_refund_cnt                -- 自动退汇次数      
       ,t1.vtual_acct_bind_acct                                     as vtual_bind_acct                -- 虚户绑定账户      
       ,t1.vtual_acct_bind_acct_name                                as vtual_bind_acct_name           -- 虚户绑定账户名称    
       ,t1.vtual_open_acct_org_id                                   as vtual_open_acct_org_id         -- 虚户绑定账户开户机构编号
	     ,t1.proc_org_id                                                as mgmt_org_id                  -- 管理机构编号
       ,''                                                          as jnl_flow_num                   -- 日志流水号
       ,t1.bank_int_out_line_flg                                    as bank_int_out_line_flg          -- 行内行外标志  
       ,''                                                          as revid_tm                       -- 收到时间
       ,'mpcsf4'                                                   as job_cd                          -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp              -- 数据处理时间
  from ${iml_schema}.evt_tszfs_tran_evt t1 --深同城交易事件
  left join (select bank_int_bus_seq_num,tran_dt,acct_ety_code,check_entry_dt
                    ,row_number () over(partition by bank_int_bus_seq_num,tran_dt order by  check_entry_dt desc ) rn 
               from ${iml_schema}.evt_tszfs_entry_evt  --深同城记账事件  
              where tran_dt <= to_date('${batch_date}','yyyymmdd') and tran_dt >= to_date('${batch_date}','yyyymmdd') - 14
                and job_cd='mpcsi1'
              group by bank_int_bus_seq_num,tran_dt,acct_ety_code,check_entry_dt
             ) t2 
    on t1.bank_int_bus_seq_num = t2.bank_int_bus_seq_num
   and t1.tran_dt = t2.tran_dt
   and rn=1
--  and t2.etl_dt <= to_date('${batch_date}','yyyymmdd') and t2.etl_dt >= to_date('${batch_date}','yyyymmdd') - 14
  where  t1.etl_dt <= to_date('${batch_date}','yyyymmdd') and t1.etl_dt >= to_date('${batch_date}','yyyymmdd') - 14
   and t1.job_cd='mpcsf1'
;
commit;

--第五组（共七组）超级网银的交易流水
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_pbc_pass_tran_flow(
       etl_dt                                              -- 数据日期          
       ,evt_id                                             -- 事件编号        
       ,lp_id                                              -- 法人编号        
       ,pay_decl_form_id                                   -- 支付报单编号      
       ,tran_dt                                            -- 交易日期        
       ,out_line_pay_tran_seq_num                          -- 行外支付交易序号    
       ,bank_int_bus_seq_num                               -- 行内业务序号      
       ,bus_origi_bank_no                                  -- 业务发起行行号
       ,pbc_pass_tran_type_cd                              -- 人行通道交易类型代码     
       ,msg_type_id                                        -- 报文类型编号      
       ,scd_gener_msg_type_id                              -- 二代报文类型编号    
       ,host_flow_num                                      -- 主机流水号       
       ,tran_flow_num                                      -- 交易流水号       
       ,send_tran_flow_num                                 -- 发送交易流水号     
       ,ova_flow_num                                       -- 全局流水号       
       ,host_tran_code                                     -- 主机交易码       
       ,midgrod_tran_code                                  -- 中台交易码       
       ,curr_cd                                            -- 币种代码        
       ,prod_cd                                            -- 产品代码        
       ,bus_kind_cd                                        -- 业务种类代码      
       ,bus_type_cd                                        -- 业务类型代码      
       ,proc_status_cd                                     -- 处理状态代码      
       ,npc_proc_cd                                        -- NPC处理代码     
       ,check_entry_status_cd                              -- 对账状态代码      
       ,debit_crdt_cd                                      -- 借贷代码        
       ,entry_code                                         -- 记账分录编码      
       ,acct_gen_cd                                        -- 账户大类型代码     
       ,acct_type_cd                                       -- 账户类型代码      
       ,e_acct_cd                                          -- 电子账户代码      
       ,rec_status_cd                                      -- 记录状态代码      
       ,mode_pay_cd                                        -- 支付方式代码      
       ,exch_bus_tran_chn_cd                               -- 汇兑业务交易渠道代码  
       ,ground_proc_status_cd                              -- 落地处理状态代码    
       ,verify_proc_status_cd                              -- 查证处理状态代码    
       ,nostro_flg                                         -- 往来账标志       
       ,charge_flg                                         -- 收费标志        
       ,agent_flg                                          -- 代理标志        
       ,intnal_acct_flg                                    -- 内部账标志       
       ,entr_dt                                            -- 委托日期        
       ,host_dt                                            -- 主机日期        
       ,clear_dt                                           -- 清算日期        
       ,check_entry_dt                                     -- 对账日期        
       ,modif_dt                                           -- 修改日期        
       ,modif_tm                                           -- 修改时间        
       ,init_entr_dt                                       -- 原委托日期       
       ,init_pay_tran_seq_num                              -- 原支付交易序号     
       ,tran_amt                                           -- 交易金额        
       ,comm_fee_amt                                       -- 手续费用金额      
       ,remit_tran_fee_amt                                 -- 汇划费用金额      
       ,todos                                              -- 工本费   
       ,payer_open_bank_dept_id                            -- 付款人开户行部门编号	   
       ,payer_open_bank_no                                 -- 付款人开户行行号    
       ,payer_open_bank_name                               -- 付款人开户行名称    
       ,payer_acct_num                                     -- 付款人账号       
       ,payer_name                                         -- 付款人名称       
       ,payer_addr                                         -- 付款人地址       
       ,recver_open_bank_no                                -- 收款人开户行行号    
       ,recver_open_bank_name                              -- 收款人开户行名称    
       ,recver_acct_num                                    -- 收款人账号       
       ,recver_name                                        -- 收款人名称       
       ,recver_addr                                        -- 收款人地址       
       ,err_return_code                                    -- 错误返回编码      
       ,err_info                                           -- 错误信息        
       ,prior_level                                        -- 优先级别        
       ,input_teller_id                                    -- 录入柜员编号      
       ,check_teller_id                                    -- 复核柜员编号      
       ,auth_teller_id                                     -- 授权柜员编号      
       ,input_check_teller_dept_id                         -- 录入复核柜员部门编号  
       ,auth_teller_dept_id                                -- 授权柜员部门编号    
       ,reg_main_acct_num                                  -- 挂账或维护入账账号   
       ,reg_main_name                                      -- 挂账或维护入账姓名   
       ,matn_enter_acct_dt                                 -- 维护入账日期      
       ,matn_enter_acct_teller_id                          -- 维护入账柜员编号    
       ,matn_enter_acct_dept_id                            -- 维护入账部门编号    
       ,vouch_type_cd                                      -- 凭证类型代码      
       ,vouch_dt                                           -- 凭证日期        
       ,vouch_no                                           -- 凭证号码        
       ,cert_kind_cd                                       -- 证件种类代码      
       ,cert_no                                            -- 证件号码        
       ,actl_deduct_acct_num                               -- 实际扣账账号      
       ,actl_deduct_acct_name                              -- 实际扣账户名称     
       ,rgst_addit_data_tab_name                           -- 登记附加数据表名称   
       ,on_acct_rs_cd                                      -- 挂账原因代码      
       ,auto_refund_flg                                    -- 自动退汇标志      
       ,auto_refund_cnt                                    -- 自动退汇次数      
       ,vtual_bind_acct                                    -- 虚户绑定账户      
       ,vtual_bind_acct_name                               -- 虚户绑定账户名称    
       ,vtual_open_acct_org_id                             -- 虚户绑定账户开户机构编号
	     ,mgmt_org_id                                        -- 管理机构编号
	     ,jnl_flow_num                                       -- 日志流水号
	     ,bank_int_out_line_flg                              -- 行内行外标志 
       ,revid_tm                                           -- 收到时间
       ,job_cd                                             -- 任务代码        
       ,etl_timestamp                                      -- 数据处理时间                
)
select t1.etl_dt                                                       -- 数据日期
			,t1.evt_id                                                                 -- 事件编号 
			,t1.lp_id                                                                  -- 法人编号
      ,t1.front_flow_num                                                         -- 支付报单编号         
      ,t1.entry_dt                                                               -- 交易日期           
      ,t1.coll_comm_fee_org_id                                                   -- 行外支付交易序号       
      ,t1.bank_int_bus_seq_num                                                   -- 行内业务序号         
      ,t1.init_prtcpt_org_bank_no                                                -- 业务发起行行号
      ,'05' as pbc_pass_tran_type_cd                                             -- 人行通道交易类型代码        
      ,t1.init_msg_idf_id                                                        -- 报文类型编号         
      ,t1.pbc_tran_code                                                          -- 二代报文类型编号       
      ,t1.host_flow_num                                                          -- 主机流水号          
      ,t1.tran_index_num                                                         -- 交易流水号          
      ,''                                                                        -- 发送交易流水号        
      ,t1.ova_flow_num                                                           -- 全局流水号          
      ,t1.host_tran_code                                                         -- 主机交易码          
      ,t1.front_tran_code                                                        -- 中台交易码          
      ,t1.curr_cd                                                                -- 币种代码           
      ,''                                                                        -- 产品代码           
      ,t1.pbc_bus_kind_cd                                                        -- 业务种类代码         
      ,t1.pbc_bus_type_cd                                                        -- 业务类型代码         
      ,t1.tran_status_cd                                                         -- 处理状态代码         
      ,''                                                                        -- NPC处理代码        
      ,t1.host_check_entry_status_cd                                             -- 对账状态代码         
      ,t1.debit_crdt_cd                                                          -- 借贷代码           
      ,t1.acct_ety_code                                                          -- 记账分录编码         
      ,t1.acct_cate_cd                                                           -- 账户大类型代码        
      ,t1.acct_type_cd                                                           -- 账户类型代码         
      ,t1.e_acct_cd                                                              -- 电子账户代码         
      ,''                                                                        -- 记录状态代码         
      ,''                                                                        -- 支付方式代码         
      ,t1.chn_cd                                                                 -- 汇兑业务交易渠道代码     
      ,''                                                                        -- 落地处理状态代码       
      ,''                                                                        -- 查证处理状态代码       
      ,t1.present_wdraw_flg                                                      -- 往来账标志          
      ,t1.charge_flg                                                             -- 收费标志           
      ,''                                                                        -- 代理标志           
      ,''                                                                        -- 内部账标志          
      ,null                                                                      -- 委托日期           
      ,null                                                                      -- 主机日期           
      ,t1.check_entry_dt                                                         -- 清算日期           
      ,t1.check_entry_dt                                                         -- 对账日期           
      ,null                                                                      -- 修改日期           
      ,null                                                                      -- 修改时间           
      ,null                                                                      -- 原委托日期          
      ,t1.tran_index_num                                                         -- 原支付交易序号        
      ,t1.tran_amt                                                               -- 交易金额           
      ,t1.comm_fee                                                               -- 手续费用金额         
      ,0                                                                         -- 汇划费用金额         
      ,0                                                                         -- 工本费    
      ,''                                                                        -- 付款人开户行部门编号	  
      ,t1.payer_open_bank_no                                                     -- 付款人开户行行号       
      ,t1.pay_bank_name                                                          -- 付款人开户行名称       
      ,t1.payer_acct_num                                                         -- 付款人账号          
      ,t1.payer_name                                                             -- 付款人名称          
      ,t1.payer_bank_belong_city_cd                                              -- 付款人地址          
      ,t1.recv_bank_no                                                           -- 收款人开户行行号       
      ,t1.recv_bank_name                                                         -- 收款人开户行名称       
      ,t1.recver_acct_num                                                        -- 收款人账号          
      ,t1.recver_name                                                            -- 收款人名称          
      ,t1.recver_bank_belong_city_cd                                             -- 收款人地址          
      ,''                                                                        -- 错误返回编码         
      ,''                                                                        -- 错误信息           
      ,t1.submit_prior_level                                                     -- 优先级别           
      ,t1.operr_id                                                               -- 录入柜员编号         
      ,t1.operr_id                                                               -- 复核柜员编号         
      ,t1.operr_id                                                               -- 授权柜员编号         
      ,''                                                                        -- 录入复核柜员部门编号     
      ,''                                                                        -- 授权柜员部门编号       
      ,''                                                                        -- 挂账或维护入账账号      
      ,''                                                                        -- 挂账或维护入账姓名      
      ,null                                                                      -- 维护入账日期         
      ,''                                                                        -- 维护入账柜员编号       
      ,''                                                                        -- 维护入账部门编号       
      ,''                                                                        -- 凭证类型代码         
      ,null                                                                      -- 凭证日期           
      ,''                                                                        -- 凭证号码           
      ,'0000'                                                                    -- 证件种类代码         
      ,t1.cert_no                                                                -- 证件号码           
      ,''                                                                        -- 实际扣账账号         
      ,''                                                                        -- 实际扣账户名称        
      ,''                                                                        -- 登记附加数据表名称      
      ,''                                                                        -- 挂账原因代码         
      ,t1.refund_flg                                                             -- 自动退汇标志         
      ,0                                                                         -- 自动退汇次数         
      ,''                                                                        -- 虚户绑定账户         
      ,''                                                                        -- 虚户绑定账户名称       
      ,''                                                                        -- 虚户绑定账户开户机构编号
	    ,t1.tran_brac_id                                                           -- 管理机构编号
      ,''                                                                        -- 日志流水号
      ,''	                                                                       -- 行内行外标志 	  
      ,''                                                                        -- 收到时间
      ,'mpcsi5'                                                                  -- 任务代码           
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')           -- 数据处理时间         
from ${iml_schema}.evt_super_olbk_tran_evt t1                                                                            
where t1.send_bank_dt <= to_date('${batch_date}','yyyymmdd') and t1.send_bank_dt >= to_date('${batch_date}','yyyymmdd') - 14
  and t1.job_cd='mpcsi1';
commit;

--第六组（共七组）国库资金划拨
whenever sqlerror exit sql.sqlcode;
insert /*+ append */into ${icl_schema}.cmm_pbc_pass_tran_flow(
       etl_dt                                              -- 数据日期                  
      ,evt_id                                              -- 事件编号                  
      ,lp_id                                               -- 法人编号                  
      ,pay_decl_form_id                                    -- 支付报单编号                
      ,tran_dt                                             -- 交易日期                  
      ,out_line_pay_tran_seq_num                           -- 行外支付交易序号             
      ,bank_int_bus_seq_num                                -- 行内业务序号                
      ,bus_origi_bank_no                                   -- 业务发起行行号               
      ,pbc_pass_tran_type_cd                               -- 人行通道交易类型代码         
      ,msg_type_id                                         -- 报文类型编号                
      ,scd_gener_msg_type_id                               -- 二代报文类型编号             
      ,host_flow_num                                       -- 主机流水号                 
      ,tran_flow_num                                       -- 交易流水号                 
      ,send_tran_flow_num                                  -- 发送交易流水号               
      ,ova_flow_num                                        -- 全局流水号                 
      ,host_tran_code                                      -- 主机交易码                 
      ,midgrod_tran_code                                   -- 中台交易码                 
      ,curr_cd                                             -- 币种代码                  
      ,prod_cd                                             -- 产品代码                  
      ,bus_kind_cd                                         -- 业务种类代码                
      ,bus_type_cd                                         -- 业务类型代码                
      ,proc_status_cd                                      -- 处理状态代码                
      ,npc_proc_cd                                         -- NPC处理代码               
      ,check_entry_status_cd                               -- 对账状态代码                
      ,debit_crdt_cd                                       -- 借贷代码                  
      ,entry_code                                          -- 记账分录编码                
      ,acct_gen_cd                                         -- 账户大类型代码               
      ,acct_type_cd                                        -- 账户类型代码                
      ,e_acct_cd                                           -- 电子账户代码                
      ,rec_status_cd                                       -- 记录状态代码                
      ,mode_pay_cd                                         -- 支付方式代码                
      ,exch_bus_tran_chn_cd                                -- 汇兑业务交易渠道代码         
      ,ground_proc_status_cd                               -- 落地处理状态代码             
      ,verify_proc_status_cd                               -- 查证处理状态代码             
      ,nostro_flg                                          -- 往来账标志                 
      ,charge_flg                                          -- 收费标志                  
      ,agent_flg                                           -- 代理标志                  
      ,intnal_acct_flg                                     -- 内部账标志                 
      ,entr_dt                                             -- 委托日期                  
      ,host_dt                                             -- 主机日期                  
      ,clear_dt                                            -- 清算日期                  
      ,check_entry_dt                                      -- 对账日期                  
      ,modif_dt                                            -- 修改日期                  
      ,modif_tm                                            -- 修改时间                  
      ,init_entr_dt                                        -- 原委托日期                 
      ,init_pay_tran_seq_num                               -- 原支付交易序号               
      ,tran_amt                                            -- 交易金额                  
      ,comm_fee_amt                                        -- 手续费用金额                
      ,remit_tran_fee_amt                                  -- 汇划费用金额                
      ,todos                                               -- 工本费                   
      ,payer_open_bank_no                                  -- 付款人开户行行号             
      ,payer_open_bank_name                                -- 付款人开户行名称             
      ,payer_acct_num                                      -- 付款人账号                 
      ,payer_name                                          -- 付款人名称                 
      ,payer_addr                                          -- 付款人地址                 
      ,recver_open_bank_no                                 -- 收款人开户行行号             
      ,recver_open_bank_name                               -- 收款人开户行名称             
      ,recver_acct_num                                     -- 收款人账号                 
      ,recver_name                                         -- 收款人名称                 
      ,recver_addr                                         -- 收款人地址                 
      ,err_return_code                                     -- 错误返回编码                
      ,err_info                                            -- 错误信息                  
      ,prior_level                                         -- 优先级别                  
      ,input_teller_id                                     -- 录入柜员编号                
      ,check_teller_id                                     -- 复核柜员编号                
      ,auth_teller_id                                      -- 授权柜员编号                
      ,input_check_teller_dept_id                          -- 录入复核柜员部门编号         
      ,auth_teller_dept_id                                 -- 授权柜员部门编号             
      ,reg_main_acct_num                                   -- 挂账或维护入账账号           
      ,reg_main_name                                       -- 挂账或维护入账姓名           
      ,matn_enter_acct_dt                                  -- 维护入账日期                
      ,matn_enter_acct_teller_id                           -- 维护入账柜员编号             
      ,matn_enter_acct_dept_id                             -- 维护入账部门编号             
      ,vouch_type_cd                                       -- 凭证类型代码                
      ,vouch_dt                                            -- 凭证日期                  
      ,vouch_no                                            -- 凭证号码                  
      ,cert_kind_cd                                        -- 证件种类代码                
      ,cert_no                                             -- 证件号码                  
      ,actl_deduct_acct_num                                -- 实际扣账账号                
      ,actl_deduct_acct_name                               -- 实际扣账户名称               
      ,rgst_addit_data_tab_name                            -- 登记附加数据表名称           
      ,on_acct_rs_cd                                       -- 挂账原因代码                
      ,auto_refund_flg                                     -- 自动退汇标志                
      ,auto_refund_cnt                                     -- 自动退汇次数                
      ,vtual_bind_acct                                     -- 虚户绑定账户                
      ,vtual_bind_acct_name                                -- 虚户绑定账户名称             
      ,vtual_open_acct_org_id                              -- 虚户绑定账户开户机构编号     
      ,job_cd                                              -- 任务编码                  
      ,etl_timestamp                                       -- etl处理时间戳
   )
  select t1.rgst_dt                                   -- 数据日期                  
      ,t1.evt_id                                     -- 事件编号                  
      ,t1.lp_id                                      -- 法人编号                  
      ,t1.rgst_flow_num                              -- 支付报单编号                
      ,t1.rgst_dt                                    -- 交易日期                  
      ,''                                            -- 行外支付交易序号             
      ,''                                            -- 行内业务序号                
      ,''                                            -- 业务发起行行号               
      ,'06'                                          -- 人行通道交易类型代码         
      ,''                                            -- 报文类型编号                
      ,''                                            -- 二代报文类型编号             
      ,t1.core_flow_num                              -- 主机流水号                 
      ,t1.tran_flow_num                              -- 交易流水号                 
      ,''                                            -- 发送交易流水号               
      ,''                                            -- 全局流水号                 
      ,''                                            -- 主机交易码                 
      ,''                                            -- 中台交易码                 
      ,''                                            -- 币种代码                  
      ,''                                            -- 产品代码                  
      ,''                                            -- 业务种类代码                
      ,''                                            -- 业务类型代码                
      ,t1.proc_status_cd                             -- 处理状态代码                
      ,''                                            -- NPC处理代码               
      ,t1.host_check_entry_status_cd                 -- 对账状态代码                
      ,''                                            -- 借贷代码                  
      ,''                                            -- 记账分录编码                
      ,''                                            -- 账户大类型代码               
      ,''                                            -- 账户类型代码                
      ,''                                            -- 电子账户代码                
      ,''                                            -- 记录状态代码                
      ,''                                            -- 支付方式代码                
      ,''                                            -- 汇兑业务交易渠道代码         
      ,''                                            -- 落地处理状态代码             
      ,''                                            -- 查证处理状态代码             
      ,''                                            -- 往来账标志                 
      ,''                                            -- 收费标志                  
      ,''                                            -- 代理标志                  
      ,''                                            -- 内部账标志                 
      ,t1.entr_dt                                    -- 委托日期                  
      ,${iml_schema}.dateformat_min(trim(t1.core_dt))-- 主机日期                  
      ,''                                            -- 清算日期                  
      ,''                                            -- 对账日期                  
      ,''                                            -- 修改日期                  
      ,''                                            -- 修改时间                  
      ,''                                            -- 原委托日期                 
      ,''                                            -- 原支付交易序号               
      ,t1.tran_amt                                   -- 交易金额                  
      ,0                                             -- 手续费用金额                
      ,0                                             -- 汇划费用金额                
      ,0                                             -- 工本费                   
      ,t2.pay_bank_bank_no                           -- 付款人开户行行号             
      ,t2.pay_bank_bank_name                         -- 付款人开户行名称             
      ,t2.payer_acct_id                              -- 付款人账号                 
      ,t2.payer_name                                 -- 付款人名称                 
      ,''                                            -- 付款人地址                 
      ,t2.recv_bank_bank_no                          -- 收款人开户行行号             
      ,t2.recv_bank_bank_name                        -- 收款人开户行名称             
      ,t2.recver_acct_id                             -- 收款人账号                 
      ,t2.recver_name                                -- 收款人名称                 
      ,''                                            -- 收款人地址                 
      ,''                                            -- 错误返回编码                
      ,''                                            -- 错误信息                  
      ,''                                            -- 优先级别                  
      ,''                                            -- 录入柜员编号                
      ,''                                            -- 复核柜员编号                
      ,''                                            -- 授权柜员编号                
      ,''                                            -- 录入复核柜员部门编号         
      ,''                                            -- 授权柜员部门编号             
      ,''                                            -- 挂账或维护入账账号           
      ,''                                            -- 挂账或维护入账姓名           
      ,''                                            -- 维护入账日期                
      ,''                                            -- 维护入账柜员编号             
      ,''                                            -- 维护入账部门编号             
      ,''                                            -- 凭证类型代码                
      ,''                                            -- 凭证日期                  
      ,''                                            -- 凭证号码                  
      ,''                                            -- 证件种类代码                
      ,''                                            -- 证件号码                  
      ,''                                            -- 实际扣账账号                
      ,''                                            -- 实际扣账户名称               
      ,''                                            -- 登记附加数据表名称           
      ,''                                            -- 挂账原因代码                
      ,''                                            -- 自动退汇标志                
      ,0                                             -- 自动退汇次数                
      ,''                                            -- 虚户绑定账户                
      ,''                                            -- 虚户绑定账户名称             
      ,''                                            -- 虚户绑定账户开户机构编号     
      ,'mpcsf6'                                      -- 任务编码  
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   -- 数据处理时间
    from ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl t1
    left join ${iml_schema}.ref_tips_trea_cap_tran_info_h t2
      on t1.recv_bank_bank_no = t2.recv_bank_bank_no
     and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t2.job_cd = 'mpcsf1'
   where t1.rgst_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t1.rgst_dt >= to_date('${batch_date}', 'yyyymmdd') - 14
     and t1.job_cd = 'mpcsf1';
commit;



--第七组（共七组）财税业务交易
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_pbc_pass_tran_flow(
       etl_dt                                              -- 数据日期
       ,evt_id                                             -- 事件编号
       ,lp_id                                              -- 法人编号
       ,pay_decl_form_id                                   -- 支付报单编号
       ,tran_dt                                            -- 交易日期
       ,out_line_pay_tran_seq_num                          -- 行外支付交易序号
       ,bank_int_bus_seq_num                               -- 行内业务序号
       ,bus_origi_bank_no                                  -- 业务发起行行号
       ,pbc_pass_tran_type_cd                              -- 人行通道交易类型代码
       ,msg_type_id                                        -- 报文类型编号
       ,scd_gener_msg_type_id                              -- 二代报文类型编号
       ,host_flow_num                                      -- 主机流水号
       ,tran_flow_num                                      -- 交易流水号
       ,send_tran_flow_num                                 -- 发送交易流水号
       ,ova_flow_num                                       -- 全局流水号
       ,host_tran_code                                     -- 主机交易码
       ,midgrod_tran_code                                  -- 中台交易码
       ,curr_cd                                            -- 币种代码
       ,prod_cd                                            -- 产品代码
       ,bus_kind_cd                                        -- 业务种类代码
       ,bus_type_cd                                        -- 业务类型代码
       ,proc_status_cd                                     -- 处理状态代码
       ,npc_proc_cd                                        -- NPC处理代码
       ,check_entry_status_cd                              -- 对账状态代码
       ,debit_crdt_cd                                      -- 借贷代码
       ,entry_code                                         -- 记账分录编码
       ,acct_gen_cd                                        -- 账户大类型代码
       ,acct_type_cd                                       -- 账户类型代码
       ,e_acct_cd                                          -- 电子账户代码
       ,rec_status_cd                                      -- 记录状态代码
       ,mode_pay_cd                                        -- 支付方式代码
       ,exch_bus_tran_chn_cd                               -- 汇兑业务交易渠道代码
       ,ground_proc_status_cd                              -- 落地处理状态代码
       ,verify_proc_status_cd                              -- 查证处理状态代码
       ,nostro_flg                                         -- 往来账标志
       ,charge_flg                                         -- 收费标志
       ,agent_flg                                          -- 代理标志
       ,intnal_acct_flg                                    -- 内部账标志
       ,entr_dt                                            -- 委托日期
       ,host_dt                                            -- 主机日期
       ,clear_dt                                           -- 清算日期
       ,check_entry_dt                                     -- 对账日期
       ,modif_dt                                           -- 修改日期
       ,modif_tm                                           -- 修改时间
       ,init_entr_dt                                       -- 原委托日期
       ,init_pay_tran_seq_num                              -- 原支付交易序号
       ,tran_amt                                           -- 交易金额
       ,comm_fee_amt                                       -- 手续费用金额
       ,remit_tran_fee_amt                                 -- 汇划费用金额
       ,todos                                              -- 工本费
       ,payer_open_bank_no                                 -- 付款人开户行行号
       ,payer_open_bank_name                               -- 付款人开户行名称
       ,payer_acct_num                                     -- 付款人账号
       ,payer_name                                         -- 付款人名称
       ,payer_addr                                         -- 付款人地址
       ,recver_open_bank_no                                -- 收款人开户行行号
       ,recver_open_bank_name                              -- 收款人开户行名称
       ,recver_acct_num                                    -- 收款人账号
       ,recver_name                                        -- 收款人名称
       ,recver_addr                                        -- 收款人地址
       ,err_return_code                                    -- 错误返回编码
       ,err_info                                           -- 错误信息
       ,prior_level                                        -- 优先级别
       ,input_teller_id                                    -- 录入柜员编号
       ,check_teller_id                                    -- 复核柜员编号
       ,auth_teller_id                                     -- 授权柜员编号
       ,input_check_teller_dept_id                         -- 录入复核柜员部门编号
       ,auth_teller_dept_id                                -- 授权柜员部门编号
       ,reg_main_acct_num                                  -- 挂账或维护入账账号
       ,reg_main_name                                      -- 挂账或维护入账姓名
       ,matn_enter_acct_dt                                 -- 维护入账日期
       ,matn_enter_acct_teller_id                          -- 维护入账柜员编号
       ,matn_enter_acct_dept_id                            -- 维护入账部门编号
       ,vouch_type_cd                                      -- 凭证类型代码
       ,vouch_dt                                           -- 凭证日期
       ,vouch_no                                           -- 凭证号码
       ,cert_kind_cd                                       -- 证件种类代码
       ,cert_no                                            -- 证件号码
       ,actl_deduct_acct_num                               -- 实际扣账账号
       ,actl_deduct_acct_name                              -- 实际扣账户名称
       ,rgst_addit_data_tab_name                           -- 登记附加数据表名称
       ,on_acct_rs_cd                                      -- 挂账原因代码
       ,auto_refund_flg                                    -- 自动退汇标志
       ,auto_refund_cnt                                    -- 自动退汇次数
       ,vtual_bind_acct                                    -- 虚户绑定账户
       ,vtual_bind_acct_name                               -- 虚户绑定账户名称
       ,vtual_open_acct_org_id                             -- 虚户绑定账户开户机构编号
       ,job_cd                                             -- 任务代码
       ,etl_timestamp                                      -- 数据处理时间
)
select ${iml_schema}.dateformat_min(t1.trandt)             -- 数据日期
			,'DW0001'||t1.transq||t1.trandt                      -- 事件编号
			,'9999'                                              -- 法人编号
      ,t1.transq                                           -- 支付报单编号
      ,${iml_schema}.dateformat_min(t1.trandt)             -- 交易日期
      ,''                                                  -- 行外支付交易序号
      ,''                                                  -- 行内业务序号
      ,''                                                  -- 业务发起行行号
      ,'07'                                                -- 人行通道交易类型代码
      ,''                                                  -- 报文类型编号
      ,''                                                  -- 二代报文类型编号
      ,t1.hostsq                                           -- 主机流水号
      ,t1.transq                                           -- 交易流水号
      ,''                                                  -- 发送交易流水号
      ,''                                                  -- 全局流水号
      ,''                                                  -- 主机交易码
      ,''                                                  -- 中台交易码
      ,t1.currencycd                                       -- 币种代码
      ,''                                                  -- 产品代码
      ,''                                                  -- 业务种类代码
      ,''                                                  -- 业务类型代码
      ,t1.transt                                           -- 处理状态代码
      ,''                                                  -- npc处理代码
      ,''                                                  -- 对账状态代码
      ,''                                                  -- 借贷代码
      ,''                                                  -- 记账分录编码
      ,''                                                  -- 账户大类型代码
      ,''                                                  -- 账户类型代码
      ,''                                                  -- 电子账户代码
      ,''                                                  -- 记录状态代码
      ,''                                                  -- 支付方式代码
      ,''                                                  -- 汇兑业务交易渠道代码
      ,''                                                  -- 落地处理状态代码
      ,''                                                  -- 查证处理状态代码
      ,''                                                  -- 往来账标志
      ,''                                                  -- 收费标志
      ,''                                                  -- 代理标志
      ,''                                                  -- 内部账标志
      ,${iml_schema}.dateformat_min(t1.entrustdate)        -- 委托日期
      ,${iml_schema}.dateformat_min(t1.hostdt)             -- 主机日期
      ,${iml_schema}.dateformat_min(t1.txndate)            -- 清算日期
      ,${iml_schema}.dateformat_min(t1.colldate)           -- 对账日期
      ,''                                                  -- 修改日期
      ,''                                                  -- 修改时间
      ,''                                                  -- 原委托日期
      ,''                                                  -- 原支付交易序号
      ,t1.amount                                           -- 交易金额
      ,0                                                   -- 手续费用金额
      ,0                                                   -- 汇划费用金额
      ,0                                                   -- 工本费
      ,t1.payerbank                                        -- 付款人开户行行号
      ,t1.payeraccbank                                     -- 付款人开户行名称
      ,t1.payeracc                                         -- 付款人账号
      ,t1.payername                                        -- 付款人名称
      ,''                                                  -- 付款人地址
      ,t1.payeebank                                        -- 收款人开户行行号
      ,t2.bkname                                           -- 收款人开户行名称
      ,t1.payeeacc                                         -- 收款人账号
      ,t1.payeename                                        -- 收款人名称
      ,''                                                  -- 收款人地址
      ,''                                                  -- 错误返回编码
      ,''                                                  -- 错误信息
      ,''                                                  -- 优先级别
      ,''                                                  -- 录入柜员编号
      ,''                                                  -- 复核柜员编号
      ,''                                                  -- 授权柜员编号
      ,''                                                  -- 录入复核柜员部门编号
      ,''                                                  -- 授权柜员部门编号
      ,''                                                  -- 挂账或维护入账账号
      ,''                                                  -- 挂账或维护入账姓名
      ,''                                                  -- 维护入账日期
      ,''                                                  -- 维护入账柜员编号
      ,''                                                  -- 维护入账部门编号
      ,''                                                  -- 凭证类型代码
      ,''                                                  -- 凭证日期
      ,''                                                  -- 凭证号码
      ,''                                                  -- 证件种类代码
      ,''                                                  -- 证件号码
      ,''                                                  -- 实际扣账账号
      ,''                                                  -- 实际扣账户名称
      ,''                                                  -- 登记附加数据表名称
      ,''                                                  -- 挂账原因代码
      ,''                                                  -- 自动退汇标志
      ,0                                                   -- 自动退汇次数
      ,''                                                  -- 虚户绑定账户
      ,''                                                  -- 虚户绑定账户名称
      ,''                                                  -- 虚户绑定账户开户机构编号
      ,'mpcsf7'                                            -- 任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')           -- 数据处理时间
from ${iol_schema}.mpcs_a49tefetstran t1
left join ${iol_schema}.mpcs_a08tbankinfo t2
  on t1.payeebank = t2.bkcd
 and t2.start_dt <=to_date('${batch_date}','yyyymmdd') 
 and t2.end_dt >to_date('${batch_date}','yyyymmdd') 
where ${iml_schema}.dateformat_min(t1.trandt) <= to_date('${batch_date}','yyyymmdd') 
 and ${iml_schema}.dateformat_min(t1.trandt) >= to_date('${batch_date}','yyyymmdd') - 14;
commit;


-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_pbc_pass_tran_flow', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);