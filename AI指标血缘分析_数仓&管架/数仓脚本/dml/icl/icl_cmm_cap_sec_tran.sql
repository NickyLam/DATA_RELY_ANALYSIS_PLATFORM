/*
Purpose:    共性加工层-资金现券交易
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20200531 icl_cmm_cap_sec_tran -
CreateDate: 20190808
Logs:       20200110 翟若平 增加字段[客户编号]
            20200327 翟若平 增加字段[标准产品编号]
			      20200916 陈伟峰 增加T1表过滤条件【tran_status_cd in ('A','M')】
            20210318 陈伟峰 增加字段【信贷借据编号】
            20210804 陈伟峰 M层agt_bond_tran表切换源表 ctms_tbs_vs_payment_bondsdeals->ctms_tbs_v_bondsdeals，去除【tran_status_cd in ('A','M')】过滤条件
            20210826 何桐金 增加字段【交易账户编号、交易账户开户行行号、交易对手账号】
            20211123 陈伟峰 增加字段 【交易对手账户开户行行号】，调整【交易对手账号】加工逻辑
            20220305 调整字段【交易账户编号、交易账户开户行行号、交易对手账号、交易对手账户开户行行号】加工逻辑
            20220330 谢 宁   新增字段【交易账户开户行行名、交易对手账户开户行行名】
            20220916 陈伟峰 调整pty_cap_cntpty_info关联条件，因M层已将agt_bond_tran.cntpty_id做处理，改成与pty_cap_cntpty_info.cntpty_id关联
            20230628 徐子豪 新增字段【交易清算账户编号】、【交易清算银行行号】、【交易清算银行名称】
            20240617  饶雅  新增字段 【记账机构编号】
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_cap_sec_tran drop partition p_${retain_day};
alter table ${icl_schema}.cmm_cap_sec_tran add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_cap_sec_tran_ex purge;

-- 2.1 insert data to ex table
create table icl.cmm_cap_sec_tran_ex nologging
compress
as select * from icl.cmm_cap_sec_tran where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into icl.cmm_cap_sec_tran_ex(
   etl_dt                    -- 数据日期
   ,lp_id                    -- 法人编号
   ,bus_id                   -- 业务编号
   ,dept_id                  -- 部门编号
   ,tran_acct_b_id           -- 交易账簿编号
   ,tran_acct_b_name         -- 交易账簿名称
   ,acct_b_attr_cd           -- 账簿属性代码
   ,std_prod_id              -- 标准产品编号
   ,cust_id                  -- 客户编号
   ,entry_org_id             -- 记账机构编号
   ,tran_acct_id             -- 交易账户编号
   ,tran_acct_open_bank_no   -- 交易账户开户行行号
   ,tran_acct_open_bank_bank_name   -- 交易账户开户行行名
   ,cntpty_acct_id           -- 交易对手账号
   ,cntpty_acct_open_bank_no -- 交易对手账户开户行行号
   ,cntpty_acct_open_bank_bank_name -- 交易对手账户开户行行名
   ,crdt_out_acct_flow_num   -- 信贷借据编号
   ,cntpty_id                -- 交易对手编号
   ,cntpty_name              -- 交易对手名称
   ,portf_id                 -- 投组编号
   ,portf_name               -- 投组名称
   ,asset_type_cd            -- 资产类型代码
   ,asset_four_cls_cd        -- 资产四分类代码
   ,tran_dir_cd              -- 交易方向代码
   ,tran_dt                  -- 交易日期
   ,stl_dt                   -- 结算日期
   ,curr_cd                  -- 币种代码
   ,stl_amt                  -- 结算金额
   ,bond_fac_val             -- 债券面值
   ,tran_net_price           -- 交易净价
   ,tran_full_price          -- 交易全价
   ,exp_yld_rat              -- 到期收益率
   ,bond_id                  -- 债券编号
   ,bond_name                -- 债券名称
   ,bond_type_cd             -- 债券类型代码
   ,acru_int                 -- 应计利息
   ,tran_fee                 -- 交易费用
   ,tran_tax                 -- 交易税金
   ,tran_comm                -- 交易佣金
   ,dealer_id                -- 交易员编号
   ,dealer_name              -- 交易员名称
   ,tran_src_cd              -- 交易来源代码
   ,tran_id                  -- 交易编号
   ,tran_clear_acct_id       -- 交易清算账户编号
   ,tran_clear_bank_no       -- 交易清算银行行号
   ,tran_clear_bank_name     -- 交易清算银行名称
   ,remark                   -- 备注
   ,job_cd
   ,etl_timestamp            -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')                 -- 数据日期
   ,t1.lp_id                                           -- 法人编号
   ,t1.bus_id                                          -- 业务编号
   ,t1.dept_id                                         -- 部门编号
   ,t1.acct_b_id                                       -- 交易账簿编号
   ,t1.acct_b_name                                     -- 交易账簿名称
   ,t1.acct_b_attr_cd                                  -- 账簿属性代码 B 银行账户 T 交易账户
   ,t1.std_prod_id                                     -- 标准产品编号
   ,t3.cust_id                                         -- 客户编号
   ,t9.departmentid                                    -- 记账机构编号
   ,decode(t1.tran_dir_cd,'01',nvl(trim(t6.ghb_cap_acct_id),t7.ghb_cap_acct_id),nvl(trim(t6.cntpty_cap_acct_id),t7.cntpty_cap_acct_id))   --交易账户编号
   ,decode(t1.tran_dir_cd,'01',nvl(trim(t6.ghb_cap_open_ibank_no),t7.ghb_cap_open_ibank_no),nvl(trim(t6.cntpty_cap_open_ibank_no),t7.cntpty_cap_open_ibank_no)) --交易账户开户行行号
   ,decode(t1.tran_dir_cd,'01',nvl(trim(t6.ghb_cap_open_bank_name),t7.ghb_cap_open_bank_name),nvl(trim(t6.cntpty_cap_open_bank_name),t7.cntpty_cap_open_bank_name))    -- 交易账户开户行行名
   ,decode(t1.tran_dir_cd,'01',nvl(trim(t6.cntpty_cap_acct_id),t7.cntpty_cap_acct_id),nvl(trim(t6.ghb_cap_acct_id),t7.ghb_cap_acct_id)) --交易对手账号
   ,decode(t1.tran_dir_cd,'01',nvl(trim(t6.cntpty_cap_open_ibank_no),t7.cntpty_cap_open_ibank_no),nvl(trim(t6.ghb_cap_open_ibank_no),t7.ghb_cap_open_ibank_no)) --交易对手账户开户行行号
   ,decode(t1.tran_dir_cd,'01',nvl(trim(t6.cntpty_cap_open_bank_name),t7.cntpty_cap_open_bank_name),nvl(trim(t6.ghb_cap_open_bank_name),t7.ghb_cap_open_bank_name)) -- 交易对手账户开户行行名
   ,t1.tran_id                                         -- 信贷借据编号
   ,t1.cntpty_id                                       -- 交易对手编号
   ,t1.cntpty_name                                     -- 交易对手名称
   ,t1.portf_id                                        -- 投组编号
   ,t1.portf_name                                      -- 投组名称
   ,t1.asset_type_cd                                   -- 资产类型代码
   ,t1.asset_cls4_cd                                   -- 资产四分类代码
   ,t1.tran_dir_cd                                     -- 交易方向代码
   ,t1.tran_dt                                         -- 交易日期
   ,t1.dlvy_dt                                         -- 结算日期
   ,t1.curr_cd                                         -- 币种代码
   ,t1.stl_amt                                         -- 结算金额
   ,t1.stl_amt                                         -- 债券面值
   ,t1.tran_net_price                                  -- 交易净价
   ,t1.tran_full_price                                 -- 交易全价
   ,t1.exp_yld_rat                                     -- 到期收益率
   ,t1.bond_id                                         -- 债券编号
   ,t1.bond_name                                       -- 债券名称
   ,t1.bond_type_cd                                    -- 债券类型代码
   ,t1.acru_int_tot                                    -- 应计利息
   ,t1.comm_fee                                        -- 交易费用
   ,t1.tax                                             -- 交易税金
   ,t1.comm                                            -- 交易佣金
   ,t1.dealer_id                                       -- 交易员编号
   ,t1.dealer_name                                     -- 交易员名称
   ,t1.tran_src_cd                                     -- 交易来源代码
   ,t1.tran_id                                         -- 交易编号
   ,t8.cash_acc_no                                     -- 交易清算账户编号
   ,t8.cash_acc_bank_ex                                -- 交易清算银行行号
   ,t8.cash_acc_bank                                   -- 交易清算银行名称
   ,''                                                 -- 备注 先置空
   ,t1.job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
  from ${iml_schema}.agt_bond_tran t1
  /*left join ${iol_schema}.ctms_tbs_vs_payment_bondsdeals T2
    on t1.bus_id = t2.deal_id
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   */
  left join ${iml_schema}.pty_cap_cntpty_info t3
    on t1.cntpty_id = t3.cntpty_id
   and t3.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd = 'ctmsf1'
   and t3.id_mark <> 'D'
  left join ${iml_schema}.agt_prod_rela_h t4
    on t1.agt_id = t4.agt_id
   and t1.lp_id = t4.lp_id
   and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd in ('ctmsf1','ctmsf2')
  left join ${iml_schema}.evt_sec_clear_info  t6
    on t1.tran_id=t6.init_tran_id
   and t6.job_cd ='ctmsf1'
  left join ${iml_schema}.evt_udwtr_distr_tran_clear_dtl t7
    on t1.tran_id=t7.init_tran_id
   and t7.job_cd ='ctmsf1'   
  left join ${iol_schema}.ctms_wtrade_tr_si t8
    on t1.dept_id = t8.aspclient_id                             
   and t1.tran_dir_cd = decode(t8.bs,'B','01','S','02','00')
   and t1.tran_id = t8.serial_number
   and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t8.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.ctms_tbs_interface_portf_depart_mapping t9
    on t1.acct_b_id = t9.keepfolder_id                             
   and t9.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t9.end_dt > to_date('${batch_date}','yyyymmdd')
 where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ctmsf1'
   and t1.id_mark <>'D'
 --  and (('${batch_date}' > '20200925' and t1.tran_status_cd in ('A','M'))or('${batch_date}' <= '20200925'))
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_cap_sec_tran exchange partition p_${batch_date} with table ${icl_schema}.cmm_cap_sec_tran_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_cap_sec_tran_ex purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_cap_sec_tran',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);

