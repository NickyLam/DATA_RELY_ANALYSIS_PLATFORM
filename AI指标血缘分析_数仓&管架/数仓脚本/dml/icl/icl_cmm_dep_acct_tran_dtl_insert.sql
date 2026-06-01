/*
Purpose:    共性加工层-重插脚本，此脚本由手工生成。
Author:     Sunline
Usage:      @icl cmm_dep_acct_tran_dtl.sql
CreateDate: 20210922
FileType:   DML
Logs:     

*/
set serveroutput on
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;



declare
  o_cnt number(22, 0) := 0; -- 原表数据量
  b_cnt number(22, 0) := 0; -- 备份表数据量
  v_flag number(10)   := 0; -- 判断标志
begin
-- 判断原表中的分区并在重建后的表增加所有的分区
  for tb in (select table_name, partition_name, substr(partition_name, 3) as etl_dt
               from user_tab_partitions
              where table_name = upper('cmm_dep_acct_tran_dtl_bak20241206')
                and substr(partition_name, 3) <> '19000101'
                and substr(partition_name, 3) >= '20230101' 
                and substr(partition_name, 3) <= '20231231' 
            ) loop

    -- 判断分区是否存在
  select count(1)
    into v_flag
    from all_tab_partitions
   where table_name = upper('cmm_dep_acct_tran_dtl')
     and table_owner = 'ICL'
     and partition_name = tb.partition_name;

  -- 如果分区已经存在，则删除分区
  if v_flag <> 0 then

    execute immediate 'alter table icl.cmm_dep_acct_tran_dtl drop partition ' || tb.partition_name;

    end if;

      execute immediate 'alter table icl.cmm_dep_acct_tran_dtl add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt ||',''yyyymmdd''))';
 
    end loop;
 
   -- 回插所有数据
   insert /*+ append */ into icl.cmm_dep_acct_tran_dtl(
     etl_dt                        -- 数据日期
    ,lp_id                         -- 法人编号
    ,tran_flow_num                 -- 交易流水号
    ,tran_dt                       -- 交易日期
    ,tran_timestamp                -- 交易时间戳
    ,init_tran_timestamp           -- 原交易时间戳
    ,acct_bill_flow_num            -- 账单流水号
    ,ova_flow_num                  -- 全局流水号
    ,tran_flg_num                  -- 交易标识号
    ,acct_org_id                   -- 账户机构编号
    ,dep_sub_acct_id               -- 存款分户编号
    ,cust_acct_id                  -- 客户账户编号
    ,sub_acct_id                   -- 子户编号
    ,init_dep_sub_acct_id          -- 原分户编号
    ,init_sub_acct_id              -- 原子户编号
    ,cust_id                       -- 客户编号
    ,cust_name                     -- 客户名称
    ,cust_type_cd                  -- 客户类型代码
    ,bus_prod_id                   -- 业务产品编号
    ,tran_kind_cd                  -- 交易类型代码
    ,elec_tran_kind_cd             -- 电子交易种类代码
    ,tran_status_cd                -- 交易状态代码
    ,debit_crdt_dir_cd             -- 借贷方向代码
    ,cash_proj_cd                  -- 现金项目代码
    ,tran_vouch_id                 -- 交易凭证编号
    ,vouch_kind_cd                 -- 凭证种类代码
    ,memo_cd                       -- 摘要代码
    ,memo_cd_descb                 -- 摘要代码描述
    ,chn_cd                        -- 渠道代码
    ,cntpty_inter_acct_id          -- 交易对手分户编号
    ,cntpty_acct_id                -- 交易对手账户编号
    ,cntpty_sub_acct_id            -- 交易对手子账户编号
    ,cntpty_acct_name              -- 交易对手账户名称
    ,cntpty_open_bank_id           -- 交易对手账户开户行编号
    ,cntpty_acct_open_bank_cd      -- 交易对手账户开户行代码
    ,cntpty_open_bank_name         -- 交易对手账户开户行名称
    ,real_cntpty_acct_id           -- 真实交易对手账户编号
    ,real_cntpty_acct_name         -- 真实交易对手账户名称
    ,real_cntpty_fin_inst_cd       -- 真实交易对手金融机构代码
    ,real_cntpty_fin_inst_name     -- 真实交易对手金融机构名称
    ,tran_org_id                   -- 交易机构编号
    ,tran_curr_cd                  -- 交易币种代码
    ,tran_amt                      -- 交易金额
    ,tran_bal                      -- 交易余额
    ,tran_teller_id                -- 交易柜员编号
    ,check_teller_id               -- 复核柜员编号
    ,auth_teller_id                -- 授权柜员编号
    ,entry_teller_id               -- 记帐柜员编号
    ,erase_acct_flg                -- 抹账标志
    ,revs_flg                      -- 冲正标志
    ,cash_trans_flg                -- 现转标志
    ,unexp_draw_flg                -- 提前支取标志
    ,beps_unpasew_flg              -- 小额免密标志
    ,bal_chk_flg                   -- 勾对标志
    ,cross_bor_tran_flg            -- 跨境交易标志
    ,termn_id                      -- 终端编号
    ,tran_cd                       -- 交易代码
    ,tran_descb                    -- 交易描述
    ,rece_type_cd                  -- 回单类型代码
    ,tran_name                     -- 交易名称
    ,prpery_sys_code               -- 外围系统编码
    ,rece_id                       -- 回单编号
    ,rece_descb_info               -- 回单描述信息
    ,agent_cust_id                 -- 代理人客户编号
    ,agent_name                    -- 代理人名称
    ,agent_cert_type_cd            -- 代理人证件类型代码
    ,agent_cert_no                 -- 代理人证件号码
    ,agent_gender_cd               -- 代理人性别代码
    ,agent_nation_cd               -- 代理人国籍代码
    ,agent_cert_start_dt           -- 代理人证件开始日
    ,agent_cert_exp_dt             -- 代理人证件到期日
    ,agent_phone                   -- 代理人联系电话
    ,agent_licen_issue_autho_site  -- 代理人发证机关所在地
    ,agent_rs                      -- 代理原因
    ,agent_type_cd                 -- 代理类型代码
    ,operr_cert_type_cd            -- 经办人证件类型代码
    ,operr_cert_no                 -- 经办人证件号码
    ,operr_name                    -- 经办人名称
    ,client_ip_addr                -- 客户端ip地址
    ,cust_termn_mac_addr           -- 客户终端mac地址
    ,entry_flg                     -- 记账标志
    ,revs_tran_dt                  -- 冲正交易日期
    ,revs_tran_flow_num            -- 冲正交易流水号
    ,revs_tran_code                -- 冲正交易码
    ,job_cd                        -- 任务代码
    ,etl_timestamp                 -- etl处理时间戳
)
select 
    /*+ parallel(a,8) */
     t1.etl_dt                         -- 数据日期
    ,t1.lp_id                         -- 法人编号
    ,t1.tran_flow_num                 -- 交易流水号
    ,t1.tran_dt                       -- 交易日期
    ,t1.tran_timestamp                -- 交易时间戳
    ,t1.init_tran_timestamp           -- 原交易时间戳
    ,t1.acct_bill_flow_num            -- 账单流水号
    ,t1.ova_flow_num                  -- 全局流水号
    ,t1.tran_flg_num                  -- 交易标识号
    ,t1.acct_org_id                   -- 账户机构编号
    ,t1.dep_sub_acct_id               -- 存款分户编号
    ,t1.cust_acct_id                  -- 客户账户编号
    ,t1.sub_acct_id                   -- 子户编号
    ,t1.init_dep_sub_acct_id          -- 原分户编号
    ,t1.init_sub_acct_id              -- 原子户编号
    ,t1.cust_id                       -- 客户编号
    ,t1.cust_name                     -- 客户名称
    ,t1.cust_type_cd                  -- 客户类型代码
    ,t1.bus_prod_id                   -- 业务产品编号
    ,t1.tran_kind_cd                  -- 交易类型代码
    ,t1.elec_tran_kind_cd             -- 电子交易种类代码
    ,t1.tran_status_cd                -- 交易状态代码
    ,t1.debit_crdt_dir_cd             -- 借贷方向代码
    ,t1.cash_proj_cd                  -- 现金项目代码
    ,t1.tran_vouch_id                 -- 交易凭证编号
    ,t1.vouch_kind_cd                 -- 凭证种类代码
    ,t1.memo_cd                       -- 摘要代码
    ,nvl(t2.memo_code_descb,t1.memo_cd_descb) -- 摘要代码描述
    ,t1.chn_cd                        -- 渠道代码
    ,t1.cntpty_inter_acct_id          -- 交易对手分户编号
    ,t1.cntpty_acct_id                -- 交易对手账户编号
    ,t1.cntpty_sub_acct_id            -- 交易对手子账户编号
    ,t1.cntpty_acct_name              -- 交易对手账户名称
    ,t1.cntpty_open_bank_id           -- 交易对手账户开户行编号
    ,t1.cntpty_acct_open_bank_cd      -- 交易对手账户开户行代码
    ,t1.cntpty_open_bank_name         -- 交易对手账户开户行名称
    ,t1.real_cntpty_acct_id           -- 真实交易对手账户编号
    ,t1.real_cntpty_acct_name         -- 真实交易对手账户名称
    ,t1.real_cntpty_fin_inst_cd       -- 真实交易对手金融机构代码
    ,t1.real_cntpty_fin_inst_name     -- 真实交易对手金融机构名称
    ,t1.tran_org_id                   -- 交易机构编号
    ,t1.tran_curr_cd                  -- 交易币种代码
    ,t1.tran_amt                      -- 交易金额
    ,t1.tran_bal                      -- 交易余额
    ,t1.tran_teller_id                -- 交易柜员编号
    ,t1.check_teller_id               -- 复核柜员编号
    ,t1.auth_teller_id                -- 授权柜员编号
    ,t1.entry_teller_id               -- 记帐柜员编号
    ,t1.erase_acct_flg                -- 抹账标志
    ,t1.revs_flg                      -- 冲正标志
    ,t1.cash_trans_flg                -- 现转标志
    ,t1.unexp_draw_flg                -- 提前支取标志
    ,t1.beps_unpasew_flg              -- 小额免密标志
    ,t1.bal_chk_flg                   -- 勾对标志
    ,'0'            -- 跨境交易标志
    ,t1.termn_id                      -- 终端编号
    ,t1.tran_cd                       -- 交易代码
    ,t1.tran_descb                    -- 交易描述
    ,t1.rece_type_cd                  -- 回单类型代码
    ,t1.tran_name                     -- 交易名称
    ,t1.prpery_sys_code               -- 外围系统编码
    ,t1.rece_id                       -- 回单编号
    ,t1.rece_descb_info               -- 回单描述信息
    ,t1.agent_cust_id                 -- 代理人客户编号
    ,t1.agent_name                    -- 代理人名称
    ,t1.agent_cert_type_cd            -- 代理人证件类型代码
    ,t1.agent_cert_no                 -- 代理人证件号码
    ,t1.agent_gender_cd               -- 代理人性别代码
    ,t1.agent_nation_cd               -- 代理人国籍代码
    ,t1.agent_cert_start_dt           -- 代理人证件开始日
    ,t1.agent_cert_exp_dt             -- 代理人证件到期日
    ,t1.agent_phone                   -- 代理人联系电话
    ,t1.agent_licen_issue_autho_site  -- 代理人发证机关所在地
    ,t1.agent_rs                      -- 代理原因
    ,t1.agent_type_cd                 -- 代理类型代码
    ,t1.operr_cert_type_cd            -- 经办人证件类型代码
    ,t1.operr_cert_no                 -- 经办人证件号码
    ,t1.operr_name                    -- 经办人名称
    ,t1.client_ip_addr                -- 客户端ip地址
    ,t1.cust_termn_mac_addr           -- 客户终端mac地址
    ,t1.entry_flg                     -- 记账标志
    ,t1.revs_tran_dt                  -- 冲正交易日期
    ,t1.revs_tran_flow_num            -- 冲正交易流水号
    ,t1.revs_tran_code                -- 冲正交易码
    ,t1.job_cd                        -- 任务代码
    ,t1.etl_timestamp                 -- etl处理时间戳
    
 from icl.cmm_dep_acct_tran_dtl_bak20241206 t1
 left join iml.ref_tran_memo_code_para_tab t2
   on t1.memo_cd = t2.memo_code
  and t2.job_cd = 'ncbsf1'
  and t2.start_dt <= t1.etl_dt
  and t2.end_dt > t1.etl_dt
 where t1.etl_dt <= to_date('20231231','yyyymmdd')
   and t1.etl_dt >= to_date('20230101','yyyymmdd')
 ;
 commit;
  
 --  dbms_output.put_line('cmm_dep_acct_tran_dtl');
end;

/
declare
  o_cnt number(22, 0) := 0; -- 原表数据量
  b_cnt number(22, 0) := 0; -- 备份表数据量
  v_flag number(10)   := 0; -- 判断标志
begin
-- 判断原表中的分区并在重建后的表增加所有的分区
  for tb in (select table_name, partition_name, substr(partition_name, 3) as etl_dt
               from user_tab_partitions
              where table_name = upper('cmm_dep_acct_tran_dtl_bak20241206')
                and substr(partition_name, 3) <> '19000101'
                and substr(partition_name, 3) <='20221231'
            ) loop

    -- 判断分区是否存在
  select count(1)
    into v_flag
    from all_tab_partitions
   where table_name = upper('cmm_dep_acct_tran_dtl')
     and table_owner = 'ICL'
     and partition_name = tb.partition_name;

  -- 如果分区已经存在，则删除分区
  if v_flag <> 0 then

    execute immediate 'alter table icl.cmm_dep_acct_tran_dtl drop partition ' || tb.partition_name;

    end if;

      execute immediate 'alter table icl.cmm_dep_acct_tran_dtl add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt ||',''yyyymmdd''))';
 
   end loop;
 
   -- 回插所有数据
   insert /*+ append */ into icl.cmm_dep_acct_tran_dtl(
     etl_dt                        -- 数据日期
    ,lp_id                         -- 法人编号
    ,tran_flow_num                 -- 交易流水号
    ,tran_dt                       -- 交易日期
    ,tran_timestamp                -- 交易时间戳
    ,init_tran_timestamp           -- 原交易时间戳
    ,acct_bill_flow_num            -- 账单流水号
    ,ova_flow_num                  -- 全局流水号
    ,tran_flg_num                  -- 交易标识号
    ,acct_org_id                   -- 账户机构编号
    ,dep_sub_acct_id               -- 存款分户编号
    ,cust_acct_id                  -- 客户账户编号
    ,sub_acct_id                   -- 子户编号
    ,init_dep_sub_acct_id          -- 原分户编号
    ,init_sub_acct_id              -- 原子户编号
    ,cust_id                       -- 客户编号
    ,cust_name                     -- 客户名称
    ,cust_type_cd                  -- 客户类型代码
    ,bus_prod_id                   -- 业务产品编号
    ,tran_kind_cd                  -- 交易类型代码
    ,elec_tran_kind_cd             -- 电子交易种类代码
    ,tran_status_cd                -- 交易状态代码
    ,debit_crdt_dir_cd             -- 借贷方向代码
    ,cash_proj_cd                  -- 现金项目代码
    ,tran_vouch_id                 -- 交易凭证编号
    ,vouch_kind_cd                 -- 凭证种类代码
    ,memo_cd                       -- 摘要代码
    ,memo_cd_descb                 -- 摘要代码描述
    ,chn_cd                        -- 渠道代码
    ,cntpty_inter_acct_id          -- 交易对手分户编号
    ,cntpty_acct_id                -- 交易对手账户编号
    ,cntpty_sub_acct_id            -- 交易对手子账户编号
    ,cntpty_acct_name              -- 交易对手账户名称
    ,cntpty_open_bank_id           -- 交易对手账户开户行编号
    ,cntpty_acct_open_bank_cd      -- 交易对手账户开户行代码
    ,cntpty_open_bank_name         -- 交易对手账户开户行名称
    ,real_cntpty_acct_id           -- 真实交易对手账户编号
    ,real_cntpty_acct_name         -- 真实交易对手账户名称
    ,real_cntpty_fin_inst_cd       -- 真实交易对手金融机构代码
    ,real_cntpty_fin_inst_name     -- 真实交易对手金融机构名称
    ,tran_org_id                   -- 交易机构编号
    ,tran_curr_cd                  -- 交易币种代码
    ,tran_amt                      -- 交易金额
    ,tran_bal                      -- 交易余额
    ,tran_teller_id                -- 交易柜员编号
    ,check_teller_id               -- 复核柜员编号
    ,auth_teller_id                -- 授权柜员编号
    ,entry_teller_id               -- 记帐柜员编号
    ,erase_acct_flg                -- 抹账标志
    ,revs_flg                      -- 冲正标志
    ,cash_trans_flg                -- 现转标志
    ,unexp_draw_flg                -- 提前支取标志
    ,beps_unpasew_flg              -- 小额免密标志
    ,bal_chk_flg                   -- 勾对标志
    ,cross_bor_tran_flg            -- 跨境交易标志
    ,termn_id                      -- 终端编号
    ,tran_cd                       -- 交易代码
    ,tran_descb                    -- 交易描述
    ,rece_type_cd                  -- 回单类型代码
    ,tran_name                     -- 交易名称
    ,prpery_sys_code               -- 外围系统编码
    ,rece_id                       -- 回单编号
    ,rece_descb_info               -- 回单描述信息
    ,agent_cust_id                 -- 代理人客户编号
    ,agent_name                    -- 代理人名称
    ,agent_cert_type_cd            -- 代理人证件类型代码
    ,agent_cert_no                 -- 代理人证件号码
    ,agent_gender_cd               -- 代理人性别代码
    ,agent_nation_cd               -- 代理人国籍代码
    ,agent_cert_start_dt           -- 代理人证件开始日
    ,agent_cert_exp_dt             -- 代理人证件到期日
    ,agent_phone                   -- 代理人联系电话
    ,agent_licen_issue_autho_site  -- 代理人发证机关所在地
    ,agent_rs                      -- 代理原因
    ,agent_type_cd                 -- 代理类型代码
    ,operr_cert_type_cd            -- 经办人证件类型代码
    ,operr_cert_no                 -- 经办人证件号码
    ,operr_name                    -- 经办人名称
    ,client_ip_addr                -- 客户端ip地址
    ,cust_termn_mac_addr           -- 客户终端mac地址
    ,entry_flg                     -- 记账标志
    ,revs_tran_dt                  -- 冲正交易日期
    ,revs_tran_flow_num            -- 冲正交易流水号
    ,revs_tran_code                -- 冲正交易码
    ,job_cd                        -- 任务代码
    ,etl_timestamp                 -- etl处理时间戳
)
select 
    /*+ parallel(a,8) */
     t1.etl_dt                         -- 数据日期
    ,t1.lp_id                         -- 法人编号
    ,t1.tran_flow_num                 -- 交易流水号
    ,t1.tran_dt                       -- 交易日期
    ,t1.tran_timestamp                -- 交易时间戳
    ,t1.init_tran_timestamp           -- 原交易时间戳
    ,t1.acct_bill_flow_num            -- 账单流水号
    ,t1.ova_flow_num                  -- 全局流水号
    ,t1.tran_flg_num                  -- 交易标识号
    ,t1.acct_org_id                   -- 账户机构编号
    ,t1.dep_sub_acct_id               -- 存款分户编号
    ,t1.cust_acct_id                  -- 客户账户编号
    ,t1.sub_acct_id                   -- 子户编号
    ,t1.init_dep_sub_acct_id          -- 原分户编号
    ,t1.init_sub_acct_id              -- 原子户编号
    ,t1.cust_id                       -- 客户编号
    ,t1.cust_name                     -- 客户名称
    ,t1.cust_type_cd                  -- 客户类型代码
    ,t1.bus_prod_id                   -- 业务产品编号
    ,t1.tran_kind_cd                  -- 交易类型代码
    ,t1.elec_tran_kind_cd             -- 电子交易种类代码
    ,t1.tran_status_cd                -- 交易状态代码
    ,t1.debit_crdt_dir_cd             -- 借贷方向代码
    ,t1.cash_proj_cd                  -- 现金项目代码
    ,t1.tran_vouch_id                 -- 交易凭证编号
    ,t1.vouch_kind_cd                 -- 凭证种类代码
    ,t1.memo_cd                       -- 摘要代码
    ,nvl(t2.memo_code_descb,t1.memo_cd_descb) -- 摘要代码描述
    ,t1.chn_cd                        -- 渠道代码
    ,t1.cntpty_inter_acct_id          -- 交易对手分户编号
    ,t1.cntpty_acct_id                -- 交易对手账户编号
    ,t1.cntpty_sub_acct_id            -- 交易对手子账户编号
    ,t1.cntpty_acct_name              -- 交易对手账户名称
    ,t1.cntpty_open_bank_id           -- 交易对手账户开户行编号
    ,t1.cntpty_acct_open_bank_cd      -- 交易对手账户开户行代码
    ,t1.cntpty_open_bank_name         -- 交易对手账户开户行名称
    ,t1.real_cntpty_acct_id           -- 真实交易对手账户编号
    ,t1.real_cntpty_acct_name         -- 真实交易对手账户名称
    ,t1.real_cntpty_fin_inst_cd       -- 真实交易对手金融机构代码
    ,t1.real_cntpty_fin_inst_name     -- 真实交易对手金融机构名称
    ,t1.tran_org_id                   -- 交易机构编号
    ,t1.tran_curr_cd                  -- 交易币种代码
    ,t1.tran_amt                      -- 交易金额
    ,t1.tran_bal                      -- 交易余额
    ,t1.tran_teller_id                -- 交易柜员编号
    ,t1.check_teller_id               -- 复核柜员编号
    ,t1.auth_teller_id                -- 授权柜员编号
    ,t1.entry_teller_id               -- 记帐柜员编号
    ,t1.erase_acct_flg                -- 抹账标志
    ,t1.revs_flg                      -- 冲正标志
    ,t1.cash_trans_flg                -- 现转标志
    ,t1.unexp_draw_flg                -- 提前支取标志
    ,t1.beps_unpasew_flg              -- 小额免密标志
    ,t1.bal_chk_flg                   -- 勾对标志
    ,'0'            -- 跨境交易标志
    ,t1.termn_id                      -- 终端编号
    ,t1.tran_cd                       -- 交易代码
    ,t1.tran_descb                    -- 交易描述
    ,t1.rece_type_cd                  -- 回单类型代码
    ,t1.tran_name                     -- 交易名称
    ,t1.prpery_sys_code               -- 外围系统编码
    ,t1.rece_id                       -- 回单编号
    ,t1.rece_descb_info               -- 回单描述信息
    ,t1.agent_cust_id                 -- 代理人客户编号
    ,t1.agent_name                    -- 代理人名称
    ,t1.agent_cert_type_cd            -- 代理人证件类型代码
    ,t1.agent_cert_no                 -- 代理人证件号码
    ,t1.agent_gender_cd               -- 代理人性别代码
    ,t1.agent_nation_cd               -- 代理人国籍代码
    ,t1.agent_cert_start_dt           -- 代理人证件开始日
    ,t1.agent_cert_exp_dt             -- 代理人证件到期日
    ,t1.agent_phone                   -- 代理人联系电话
    ,t1.agent_licen_issue_autho_site  -- 代理人发证机关所在地
    ,t1.agent_rs                      -- 代理原因
    ,t1.agent_type_cd                 -- 代理类型代码
    ,t1.operr_cert_type_cd            -- 经办人证件类型代码
    ,t1.operr_cert_no                 -- 经办人证件号码
    ,t1.operr_name                    -- 经办人名称
    ,t1.client_ip_addr                -- 客户端ip地址
    ,t1.cust_termn_mac_addr           -- 客户终端mac地址
    ,t1.entry_flg                     -- 记账标志
    ,t1.revs_tran_dt                  -- 冲正交易日期
    ,t1.revs_tran_flow_num            -- 冲正交易流水号
    ,t1.revs_tran_code                -- 冲正交易码
    ,t1.job_cd                        -- 任务代码
    ,t1.etl_timestamp                 -- etl处理时间戳
    
 from icl.cmm_dep_acct_tran_dtl_bak20241206 t1
 left join iml.ref_tran_memo_code_para_tab t2
   on t1.memo_cd = t2.memo_code
  and t2.job_cd = 'ncbsf1'
  and t2.start_dt <= t1.etl_dt
  and t2.end_dt > t1.etl_dt
 where t1.etl_dt <= to_date('20221231','yyyymmdd');
 commit;
  
 --  dbms_output.put_line('cmm_dep_acct_tran_dtl');
end;
/