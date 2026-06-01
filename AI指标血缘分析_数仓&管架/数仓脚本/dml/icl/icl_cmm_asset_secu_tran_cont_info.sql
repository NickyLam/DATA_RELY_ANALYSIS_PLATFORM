/*
purpose:    共性加工层-资产证券化转让合同信息:数据主要来源ABSS系统产品基本信息表、资产池信息表、产品分档信息表
author:     sunline
usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_asset_secu_tran_cont_info
createdate: 20200710
logs:       20220524 陈伟峰 新增字段【交易对手编号、交易对手名称、交易对手账号、交易对手开户行名称、交易对手转账日期、交易对手已支付金额】
            20230905 徐子豪 新增字段【不良资产标志】
            20251126 陈伟峰 新增字段【交易对手证件类型CNTPTY_CERT_TYPE、交易对手证件号码CNTPTY_CERT_NO】

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_asset_secu_tran_cont_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_asset_secu_tran_cont_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop temporary table cmm_asset_secu_tran_cont_info_ex
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_asset_secu_tran_cont_info_ex purge;

-- 2.1 create temporary table cmm_asset_secu_tran_cont_info_ex
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_asset_secu_tran_cont_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_asset_secu_tran_cont_info where 0=1;

-- 2.2 insert into data to temporary table cmm_asset_secu_tran_cont_info_ex

--第一组（共一组）资产证券化转让合同信息

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_asset_secu_tran_cont_info_ex(
				etl_dt                          -- 数据日期
				,lp_id                          -- 法人编号
			  ,cont_id                        -- 合同编号
				,prod_id                        -- 产品编号
				,asset_pool_id                  -- 资产池编号
				,prod_type_cd                   -- 产品类型代码
				,prod_status_cd                 -- 产品状态代码
				,prod_bus_status_cd             -- 产品业务状态代码
				,prod_mode_cd                   -- 产品模式代码
				,asset_pool_type_cd             -- 资产池类型代码
				,asset_pool_char_cd             -- 资产池性质代码
				,asset_pool_status_cd           -- 资产池状态代码
				,tran_calc_way_cd               -- 转让计算方式代码
				,cntpty_org_type_cd             -- 交易对手机构类型代码
                ,cntpty_id                      -- 交易对手编号
                ,cntpty_name                    -- 交易对手名称
                ,cntpty_cert_type               -- 交易对手证件类型
                ,cntpty_cert_no                 -- 交易对手证件号码
                ,cntpty_acct_num                -- 交易对手账号
                ,cntpty_open_bank_name          -- 交易对手开户行名称
                ,cntpty_tran_dt                 -- 交易对手转账日期
                ,cntpty_pay_amt                 -- 交易对手已支付金额
				,pay_dt_rule_cd                 -- 支付日期规则代码
				,ts_cd                          -- 暂存代码
				,user_def_coll_ped_flg          -- 自定义归集周期标志
				,clearup_repo_flg               -- 清仓回购标志
				,non_asset_flg                  -- 不良资产标志
				,tran_plat_name                 -- 交易平台名称
				,prod_name                      -- 产品名称
				,pkg_dt                         -- 封包日期
				,begin_dt                       -- 起始日期
				,exp_dt                         -- 到期日期
				,rgst_teller_id                 -- 登记柜员编号
				,rgst_org_id                    -- 登记机构编号
				,mgmt_org_id                    -- 管理机构编号
				,acct_instit_id                 -- 账务机构编号
				,curr_cd                        -- 币种代码
				,asset_tot_amt                  -- 资产总金额
				,issue_tot_amt                  -- 发行总金额
				,asset_tran_consideration_amt   -- 资产转让对价金额
				,asset_tran_comm_fee            -- 资产转让手续费
				,prod_self_hold_amt             -- 产品自持比例
				,issue_qtty                     -- 发行数量
				,bank_rgst_center_amt		        -- 银登中心登记金额
				,job_cd                         -- 任务代码
				,etl_timestamp                  -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                -- 数据日期                  --> etl_dt
       ,'9999'                                                            -- 法人编号		               --> lp_id
       ,t1.tran_contr_id                                                  -- 合同编号                  --> cont_id
       ,t1.abs_prod_id                                                    -- 产品编号                  --> prod_id
       ,t1.asset_pool_id                                                  -- 资产池编号                --> asset_pool_id
       ,t1.prod_type_cd                                                   -- 产品类型代码CD2111        --> prod_type_cd
       ,t1.prod_status_cd                                                 -- 产品状态代码              --> prod_status_cd
       ,t1.prod_bus_status_cd                                             -- 产品业务状态代码          --> prod_bus_status_cd
       ,t1.prod_mode_cd                                                   -- 产品模式代码CD2114        --> prod_mode_cd
       ,t2.asset_pool_type_cd                                             -- 资产池类型代码CD2080      --> asset_pool_type_cd
       ,t2.asset_pool_char_cd                                             -- 资产池性质代码CD2109      --> asset_pool_char_cd
       ,t2.asset_pool_status_cd                                           -- 资产池状态代码CD2079      --> asset_pool_status_cd
       ,t1.tran_cosdetn_calc_way_cd                                       -- 转让计算方式代码CD1539    --> tran_calc_way_cd
       ,t1.tran_org_type_cd                                               -- 交易对手机构类型代码CD2115--> cntpty_org_type_cd
       ,t5.prtcptr_id                                                     -- 交易对手编号              --> cntpty_id
       ,t5.prtcptr_name                                                   -- 交易对手名称              --> cntpty_name
       ,t6.certtype                                                       -- 交易对手证件类型
       ,t6.certid                                                         -- 交易对手证件号码
       ,t4.accountno                                                      -- 交易对手账号              --> cntpty_acct_num
       ,t4.accountbank                                                    -- 交易对手开户行名称        --> cntpty_open_bank_name
       ,t1.cntpty_tran_dt                                                 -- 交易对手转账日期          --> cntpty_tran_dt
       ,t1.cntpty_pay_amt                                                 -- 交易对手已支付金额        --> cntpty_pay_amt
       ,t1.setment_way_cd                                                 -- 支付日期规则代码CD2052    --> pay_dt_rule_cd
       ,t1.ts_flg                                                         -- 暂存代码                  --> ts_cd
       ,t1.def_coll_ped_flg                                               -- 自定义归集周期标志        --> user_def_coll_ped_flg
       ,t1.supt_clearup_repo_flg                                          -- 清仓回购标志              --> clearup_repo_flg
       ,t2.non_asset_flg                                                  -- 不良资产标志              --> non_asset_flg
       ,t1.tran_plat_cd                                                   -- 交易平台名称              --> tran_plat_name
       ,t1.prod_name                                                      -- 产品名称                  --> prod_name
       ,t2.pkg_dt                                                         -- 封包日期                  --> pkg_dt
       ,t1.tran_cont_begin_dt                                             -- 起始日期                  --> begin_dt
       ,t1.tran_cont_exp_dt                                               -- 到期日期                  --> exp_dt
       ,t1.rgstrat_id                                                     -- 登记柜员编号              --> rgst_teller_id
       ,t1.rgst_org_id                                                    -- 登记机构编号              --> rgst_org_id
       ,substr(t1.rgst_org_id,1,3)                                        -- 管理机构编号              --> mgmt_org_id
       ,t1.rgst_org_id                                                    -- 账务机构编号              --> acct_instit_id
       ,t1.curr_cd                                                        -- 币种代码                  --> curr_cd
       ,t1.asset_tot                                                      -- 资产总金额                --> asset_tot_amt
       ,t1.cfm_issue_tot                                                  -- 发行总金额                --> issue_tot_amt
       ,t1.asset_tran_cosdetn                                             -- 资产转让对价金额          --> asset_tran_consideration_amt
       ,t1.tran_comm_fee                                                  -- 资产转让手续费            --> asset_tran_comm_fee
       ,t3.selfholdamount                                                 -- 产品自持金额              --> prod_self_hold_amt
       ,''                                                                -- 发行数量                  --> issue_qtty
       ,0                                                                 -- 银登中心登记金额          --> bank_rgst_center_rgst_amt
       ,t1.job_cd                                                         -- 任务代码                  --> job_cd
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- etl处理时间戳             --> etl_timestamp
from ${iml_schema}.prd_abs_prod_info_h t1
left join ${iml_schema}.agt_asset_pool_info_h t2
  on t1.asset_pool_id = t2.asset_pool_id
 and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t2.job_cd = 'abssf1'
left join (select dd.abs_prod_id
                 ,sum(cc.self_hold_ratio * cc.tranch_amt) as selfholdamount
             from ${iml_schema}.prd_abs_prod_info_h dd
             left join ${iml_schema}.prd_abs_prod_tranch_info_h cc
                    on cc.abs_prod_id = dd.abs_prod_id
                   and cc.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                   and cc.end_dt > to_date('${batch_date}', 'yyyymmdd')
                   and cc.job_cd = 'abssf1'
            where dd.start_dt <= to_date('${batch_date}', 'yyyymmdd')
              and dd.end_dt > to_date('${batch_date}', 'yyyymmdd')
              and dd.job_cd = 'abssf1'
              group by dd.abs_prod_id
          ) t3
  on t1.abs_prod_id =t3.abs_prod_id
  left join ${iol_schema}.abss_abs_account_info t4
    on t1.abs_prod_id = t4.productid
   and t4.start_dt <=to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt >to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.pty_abs_prtcptr_info_h t5
    on t4.accountaffiorg = t5.party_id
   and t5.start_dt <=to_date('${batch_date}', 'yyyymmdd')
   and t5.end_dt >to_date('${batch_date}', 'yyyymmdd')
   and t5.job_cd='abssf1'
  left join ${iol_schema}.abss_abs_rela_person_info t6
    on t4.accountaffiorg = t6.relapersonid
   and t6.start_dt <=to_date('${batch_date}', 'yyyymmdd')
   and t6.end_dt >to_date('${batch_date}', 'yyyymmdd')
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t1.job_cd = 'abssf1'
 and trim(t1.tran_contr_id) is not null
 and t1.prod_status_cd<>'51';

commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_asset_secu_tran_cont_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_asset_secu_tran_cont_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_asset_secu_tran_cont_info_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_asset_secu_tran_cont_info', partname => 'p_${batch_date}', granularity => 'partition', degree => 8, cascade => true);