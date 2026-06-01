/*
Purpose:    共性加工层-联合网贷还款明细：包括所有的花呗、借呗、网商贷、微粒贷、借呗三期、京东金融等网络贷款的还款明细信息。数据来源于综合信贷管理系统(ICMS)和中台系统(MPCS)。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20221112 icl_cmm_unite_wl_repay_dtl
CreateDate: 20190815
Logs:       20200110 翟若平 增加京东贷还款信息
            20200508 周沁晖 花呗分组 调整[核销标志]逻辑
            20200515 周沁晖 调整京东金融组字段[产品编号]的取数逻辑
                            调整网商贷组字段【产品编号】的取数逻辑
            20210707 陈伟峰 调整微粒贷一组，增加evt_tran_code='L870'
            20211112 陈伟峰 调整微粒贷一组，增加(subj_id='111001156304001010' and debit_crdt_flg='0' and rb_w_flg<>'R'))
            20220513 李森辉 1、取数数据源调整，调整花呗、借呗、京东贷、网商贷的取数源，由旧零售信贷系统调整为综合信贷管理系统。微粒贷取数源保持不变。
                            2、调整第五组借呗三期字段【产品编号】的加工口径。
            20220607 李森辉 新增字段【还款前的应收未收正常本金、还款前的应收未收逾期本金、还款前的应收未收正常利息、还款前的应收未收逾期利息、还款前的应收未收逾期本金罚息、还款前的应收未收逾期利息罚息】
            20220720 李森辉 新一代改造，evt_wld_acct_ety_tran.debit_crdt_flg码值调整（0/1 -> D/C），同步调整取数逻辑。
            20220908 李森辉 新一代改造，evt_wld_acct_ety_tran.rb_w_flg码值调整（B/R -> N/R），同步调整取数逻辑。
            20220913 李森辉 新一代改造，evt_jd_repay_dtl.repay_type_cd码值调整，同步调整取数逻辑。
            20230113 陈伟峰 调整【产品编号】加工逻辑
            20230511 陈伟峰 新增第七组-综合信贷微粒贷数据
            20230606 陈伟峰 调整微粒贷部分的还款流水取数逻辑
            20230711 陈伟峰 调整综合信贷微粒贷部分还款流水编号取值逻辑，取CORE_TRAN_FLOW
            20230921 徐子豪 根据M层调整蚂蚁花呗结清数据存放分区,同步修改取值方式为 job_cd in ('myhbf1','myhbf2')
			20250120 谢宁 新增字节小微贷
			20250220 谢宁 新增微业贷
			20250120 谢宁 字节小微贷增加增量条件trunc(t1.tran_dt) = to_date('${batch_date}','yyyymmdd')
			20250506 陈伟峰 字节小微贷增量条件trunc(t1.tran_dt) -->acct_dt
            20250730 陈伟峰 新增乐分期
			20250730 谢宁 新增唯品联合贷
            20251209 陈伟峰 调整微粒贷一组的【客户编号】字段取值逻辑，从借据表取
            20260112 陈伟峰 新增富民联合网贷
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_unite_wl_repay_dtl drop partition p_${retain_day};
alter table ${icl_schema}.cmm_unite_wl_repay_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop tmp table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_unite_wl_repay_dtl_ex purge;
drop table ${icl_schema}.cmm_unite_wl_repay_dtl_ex01 purge;

/*
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_unite_wl_repay_dtl_ex01
nologging
compress ${option_switch} for query high
as
select t1.ser_num               -- 还款流水编号
       ,t1.batch_dt             -- 还款日期
       ,t1.tran_ref_no          -- 交易参考号
       ,t1.card_no              -- 卡号
       ,t1.evt_tran_code        -- 事件交易码
       ,t1.curr_cd              -- 币种代码
       ,t1.debit_crdt_flg       -- 借贷标志
       ,t1.enter_acct_amt       -- 入账金额
       ,t1.bal_compnt_group_cd  -- 余额成分组代码
       ,t1.subj_id              -- 科目编号
	     ,t1.rb_w_flg             -- 红蓝字标志
	     ,t1.etl_dt               -- ETL处理日期
	     ,t1.job_cd               -- 任务编码
  from ${iml_schema}.evt_wld_acct_ety_tran t1
	 where (t1.evt_tran_code in ('L840', 'L842', 'L844', 'L846', 'L848','L870')
			or (t1.subj_id='111001156304001010' and t1.debit_crdt_flg='D' and t1.rb_w_flg<>'R')
			or (t1.evt_tran_code ='G202' and t1.rb_w_flg='N'))
	   and t1.etl_dt = to_date('${batch_date}','yyyymmdd')
	   and t1.job_cd in('mpcsi1','icmsi1')
;
*/

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_unite_wl_repay_dtl_ex01
nologging
compress ${option_switch} for query high
as
select t1.ser_num               -- 还款流水编号
       ,t1.batch_dt             -- 还款日期
       ,t1.tran_ref_no          -- 交易参考号
       ,t1.card_no              -- 卡号
       ,t1.evt_tran_code        -- 事件交易码
       ,t1.curr_cd              -- 币种代码
       ,t1.debit_crdt_flg       -- 借贷标志
       ,t1.enter_acct_amt       -- 入账金额
       ,t1.bal_compnt_group_cd  -- 余额成分组代码
       ,t1.subj_id              -- 科目编号
	     ,t1.rb_w_flg             -- 红蓝字标志
	     ,t1.etl_dt               -- ETL处理日期
	     ,t1.job_cd               -- 任务编码
	     ,t1.core_tran_flow       -- 核心交易流水
  from ${iml_schema}.evt_wld_acct_ety_tran t1
 where ((t1.rb_w_flg='N' AND t1.evt_tran_code ='G202')
        or (t1.subj_id='111001156304001010' and t1.debit_crdt_flg = 'D' AND t1.rb_w_flg in ('N','R')))
   and t1.etl_dt = to_date('${batch_date}','yyyymmdd') 
   and t1.job_cd in('mpcsi1','icmsi1')
;

-- 1.3 create table for exchage and add partition
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_unite_wl_repay_dtl_ex 
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_unite_wl_repay_dtl where 0=1;

-- 第一组 花呗
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_dtl_ex(
       etl_dt                        -- 数据日期
       ,lp_id                        -- 法人编号
       ,dubil_id                     -- 借据编号
       ,cust_id                      -- 客户编号
       ,prod_id                      -- 产品编号
       ,repay_acct_id                -- 还款账户编号
       ,repay_flow_id                -- 还款流水编号
       ,repay_dt                     -- 还款日期
       ,intnal_carr_flg              -- 内部结转标志
       ,wrt_off_flg                  -- 核销标志
       ,adv_repay_flg                -- 提前还款标志
       ,ovdue_repay_flg              -- 逾期还款标志
       ,acru_non_acru_cd             -- 应计非应计代码
       ,repay_type_cd                -- 还款类型代码
       ,curr_cd                      -- 币种代码
       ,curr_nomal_pric_bal          -- 当前正常本金余额
       ,currt_repay_amt              -- 当期还款金额
       ,currt_repay_pric             -- 当期还款本金
       ,currt_repay_nomal_pric       -- 当期还款正常本金
       ,currt_repay_ovdue_pric       -- 当期还款逾期本金
       ,curr_repay_int               -- 当前还款利息
       ,currt_repay_nomal_int        -- 当期还款正常利息
       ,currt_repay_ovdue_int        -- 当期还款逾期利息
       ,currt_repay_pnlt             -- 当期还款罚息
       ,currt_repay_ovdue_pric_pnlt  -- 当期还款逾期本金罚息
       ,currt_repay_ovdue_int_pnlt   -- 当期还款逾期利息罚息
       ,currt_repay_fee              -- 当期还款费用
       ,currt_repay_fee_rat          -- 当期还款费率
       ,bf_repay_recvbl_uncol_nomal_pric       -- 还款前的应收未收正常本金
       ,bf_repay_recvbl_uncol_ovdue_pric       -- 还款前的应收未收逾期本金
       ,bf_repay_recvbl_uncol_nomal_int        -- 还款前的应收未收正常利息
       ,bf_repay_recvbl_uncol_ovdue_int        -- 还款前的应收未收逾期利息
       ,bf_repay_recvbl_uncol_ovdue_pric_pnlt  -- 还款前的应收未收逾期本金罚息
       ,bf_repay_recvbl_uncol_ovdue_int_pnlt   -- 还款前的应收未收逾期利息罚息
       ,job_cd                       -- 任务代码
       ,etl_timestamp                -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                -- 数据日期
       ,t1.lp_id                                                          -- 法人编号
       ,t1.dubil_id                                                       -- 借据编号
       ,t2.cust_id                                                        -- 客户编号
       ,t2.prod_id                                                        -- 产品编号
       ,t2.repay_acct_id                                                  -- 还款账户编号
       ,t1.tran_flow_num || t1.repay_type_cd                              -- 还款流水编号
       ,t1.repay_dt                                                       -- 还款日期
       ,decode(t1.intnal_carr_flg, 'Y', '1', '0')                         -- 内部结转标志
       ,decode(t1.wrt_off_flg, 'Y', '1', '0')                             -- 核销标志
       ,decode(t1.repay_type_cd, '02', '1', '0')                          -- 提前还款标志
       ,decode(t1.repay_type_cd, '03', '1', '0')                          -- 逾期还款标志
       ,t1.acru_non_acru_flg                                              -- 应计非应计代码
       ,t1.repay_type_cd                                                  -- 还款类型代码
       ,t2.curr_cd                                                        -- 币种代码
       ,t4.bal                                                            -- 当前正常本金余额
       ,t1.paid_tot_amt                                                   -- 当期还款金额
       ,nvl(t1.paid_nomal_pric, 0) + nvl(t1.paid_ovdue_pric, 0)           -- 当期还款本金
       ,t1.paid_nomal_pric                                                -- 当期还款正常本金
       ,t1.paid_ovdue_pric                                                -- 当期还款逾期本金
       ,nvl(t1.paid_nomal_int, 0) + nvl(t1.paid_ovdue_int, 0)             -- 当前还款利息
       ,t1.paid_nomal_int                                                 -- 当期还款正常利息
       ,t1.paid_ovdue_int                                                 -- 当期还款逾期利息
       ,nvl(t1.paid_ovdue_pric_pnlt, 0) + nvl(t1.paid_ovdue_int_pnlt, 0)  -- 当期还款罚息
       ,t1.paid_ovdue_pric_pnlt                                           -- 当期还款逾期本金罚息
       ,t1.paid_ovdue_int_pnlt                                            -- 当期还款逾期利息罚息
       ,t1.repay_plat_serv_fee                                            -- 当期还款费用
       ,t1.repay_plat_serv_fee_ratio                                      -- 当期还款费率
       ,''                                                                -- 还款前的应收未收正常本金
       ,''                                                                -- 还款前的应收未收逾期本金
       ,''                                                                -- 还款前的应收未收正常利息
       ,''                                                                -- 还款前的应收未收逾期利息
       ,''                                                                -- 还款前的应收未收逾期本金罚息
       ,''                                                                -- 还款前的应收未收逾期利息罚息
       ,t1.job_cd                                                         -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')    -- 数据处理时间
  from ${iml_schema}.evt_acp_repay_dtl t1
 inner join ${iml_schema}.agt_acp_dubil t2
    on t1.dubil_id = t2.dubil_id
   and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.job_cd in ('myhbf1','myhbf2')
   and t2.id_mark<>'D'
  left join ${iml_schema}.agt_bal_h t4
    on t2.agt_id = t4.agt_id
   and t4.bal_type_cd = '005007'
   and t4.job_cd = 'myhbf1'
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
 where to_date(to_char(t1.repay_dt,'yyyymmdd'),'yyyymmdd') = to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'myhbi1'
;
commit;

-- 第二组 借呗
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_dtl_ex(
       etl_dt                        -- 数据日期
       ,lp_id                        -- 法人编号
       ,dubil_id                     -- 借据编号
       ,cust_id                      -- 客户编号
       ,prod_id                      -- 产品编号
       ,repay_acct_id                -- 还款账户编号
       ,repay_flow_id                -- 还款流水编号
       ,repay_dt                     -- 还款日期
       ,intnal_carr_flg              -- 内部结转标志
       ,wrt_off_flg                  -- 核销标志
       ,adv_repay_flg                -- 提前还款标志
       ,ovdue_repay_flg              -- 逾期还款标志
       ,acru_non_acru_cd             -- 应计非应计代码
       ,repay_type_cd                -- 还款类型代码
       ,curr_cd                      -- 币种代码
       ,curr_nomal_pric_bal          -- 当前正常本金余额
       ,currt_repay_amt              -- 当期还款金额
       ,currt_repay_pric             -- 当期还款本金
       ,currt_repay_nomal_pric       -- 当期还款正常本金
       ,currt_repay_ovdue_pric       -- 当期还款逾期本金
       ,curr_repay_int               -- 当前还款利息
       ,currt_repay_nomal_int        -- 当期还款正常利息
       ,currt_repay_ovdue_int        -- 当期还款逾期利息
       ,currt_repay_pnlt             -- 当期还款罚息
       ,currt_repay_ovdue_pric_pnlt  -- 当期还款逾期本金罚息
       ,currt_repay_ovdue_int_pnlt   -- 当期还款逾期利息罚息
       ,currt_repay_fee              -- 当期还款费用
       ,currt_repay_fee_rat          -- 当期还款费率
       ,bf_repay_recvbl_uncol_nomal_pric       -- 还款前的应收未收正常本金
       ,bf_repay_recvbl_uncol_ovdue_pric       -- 还款前的应收未收逾期本金
       ,bf_repay_recvbl_uncol_nomal_int        -- 还款前的应收未收正常利息
       ,bf_repay_recvbl_uncol_ovdue_int        -- 还款前的应收未收逾期利息
       ,bf_repay_recvbl_uncol_ovdue_pric_pnlt  -- 还款前的应收未收逾期本金罚息
       ,bf_repay_recvbl_uncol_ovdue_int_pnlt   -- 还款前的应收未收逾期利息罚息
       ,job_cd                       -- 任务代码
       ,etl_timestamp                -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                                                    -- 数据日期
       ,t1.lp_id                                                                                              -- 法人编号
       ,t1.dubil_id                                                                                           -- 借据编号
       ,t2.cust_id                                                                                            -- 客户编号
       ,t2.prod_id                                                                                            -- 产品编号
       ,t2.repay_acct_id                                                                                      -- 还款账户编号
       ,t1.tran_flow_num                                                                                      -- 还款流水编号
       ,t1.repay_dt                                                                                           -- 还款日期
       ,'0'                                                                                                   -- 内部结转标志
       ,decode(t1.wrt_off_flg, 'Y', '1', '0')                                                                 -- 核销标志
       ,decode(t1.repay_type_cd, '02', '1', '0')                                                              -- 提前还款标志
       ,decode(t1.repay_type_cd, '03', '1', '0')                                                              -- 逾期还款标志
       ,t1.acru_non_acru_flg                                                                                  -- 应计非应计代码
       ,t1.repay_type_cd                                                                                      -- 还款类型代码
       ,nvl(trim(t2.curr_cd), 'CNY')                                                                          -- 币种代码
       ,t4.bal                                                                                                -- 当前正常本金余额
       ,t1.paid_tot_amt                                                                                       -- 当期还款金额
       ,nvl(t1.paid_nomal_pric, 0) + nvl(t1.paid_ovdue_pric, 0)                                               -- 当期还款本金
       ,t1.paid_nomal_pric                                                                                    -- 当期还款正常本金
       ,t1.paid_ovdue_pric                                                                                    -- 当期还款逾期本金
       ,nvl(t1.paid_nomal_int, 0) + nvl(t1.paid_ovdue_int, 0)                                                 -- 当前还款利息
       ,t1.paid_nomal_int                                                                                     -- 当期还款正常利息
       ,t1.paid_ovdue_int                                                                                     -- 当期还款逾期利息
       ,nvl(t1.paid_ovdue_pric_pnlt, 0) + nvl(t1.paid_ovdue_int_pnlt, 0)                                      -- 当期还款罚息
       ,t1.paid_ovdue_pric_pnlt                                                                               -- 当期还款逾期本金罚息
       ,t1.paid_ovdue_int_pnlt                                                                                -- 当期还款逾期利息罚息
       ,t1.plat_serv_fee_amt                                                                                  -- 当期还款费用
       ,case when nvl(t1.paid_tot_amt, 0) = 0 then 0 else nvl(t1.plat_serv_fee_amt, 0) / t1.paid_tot_amt end  -- 当期还款费率
       ,t1.rpbl_nomal_pric                                                                                    -- 还款前的应收未收正常本金
       ,t1.rpbl_ovdue_pric                                                                                    -- 还款前的应收未收逾期本金
       ,t1.rpbl_nomal_int                                                                                     -- 还款前的应收未收正常利息
       ,t1.rpbl_ovdue_int                                                                                     -- 还款前的应收未收逾期利息
       ,t1.rpbl_ovdue_pric_pnlt                                                                               -- 还款前的应收未收逾期本金罚息
       ,t1.rpbl_ovdue_int_pnlt                                                                                -- 还款前的应收未收逾期利息罚息
       ,t1.job_cd                                                                                             -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')                                        -- 数据处理时间
  from ${iml_schema}.evt_ajb_repay_dtl_flow t1
 inner join ${iml_schema}.agt_ajb_dubil t2
    on t1.dubil_id = t2.dubil_id
   and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'myjbf2'
   and t2.id_mark<>'D'
 --and t2.etl_dt = to_date('${batch_date}','yyyymmdd')  -- delete by molanhong
  left join ${iml_schema}.agt_bal_h t4
    on t2.agt_id = t4.agt_id
   and t4.bal_type_cd = '005006'
   and t4.job_cd = 'myjbf2'
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
 where to_date(to_char(t1.repay_dt,'yyyymmdd'),'yyyymmdd') = to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'myjbi2'
;
commit;    

-- 第三组 网商贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_dtl_ex(
       etl_dt                        -- 数据日期
       ,lp_id                        -- 法人编号
       ,dubil_id                     -- 借据编号
       ,cust_id                      -- 客户编号
       ,prod_id                      -- 产品编号
       ,repay_acct_id                -- 还款账户编号
       ,repay_flow_id                -- 还款流水编号
       ,repay_dt                     -- 还款日期
       ,intnal_carr_flg              -- 内部结转标志
       ,wrt_off_flg                  -- 核销标志
       ,adv_repay_flg                -- 提前还款标志
       ,ovdue_repay_flg              -- 逾期还款标志
       ,acru_non_acru_cd             -- 应计非应计代码
       ,repay_type_cd                -- 还款类型代码
       ,curr_cd                      -- 币种代码
       ,curr_nomal_pric_bal          -- 当前正常本金余额
       ,currt_repay_amt              -- 当期还款金额
       ,currt_repay_pric             -- 当期还款本金
       ,currt_repay_nomal_pric       -- 当期还款正常本金
       ,currt_repay_ovdue_pric       -- 当期还款逾期本金
       ,curr_repay_int               -- 当前还款利息
       ,currt_repay_nomal_int        -- 当期还款正常利息
       ,currt_repay_ovdue_int        -- 当期还款逾期利息
       ,currt_repay_pnlt             -- 当期还款罚息
       ,currt_repay_ovdue_pric_pnlt  -- 当期还款逾期本金罚息
       ,currt_repay_ovdue_int_pnlt   -- 当期还款逾期利息罚息
       ,currt_repay_fee              -- 当期还款费用
       ,currt_repay_fee_rat          -- 当期还款费率
       ,bf_repay_recvbl_uncol_nomal_pric       -- 还款前的应收未收正常本金
       ,bf_repay_recvbl_uncol_ovdue_pric       -- 还款前的应收未收逾期本金
       ,bf_repay_recvbl_uncol_nomal_int        -- 还款前的应收未收正常利息
       ,bf_repay_recvbl_uncol_ovdue_int        -- 还款前的应收未收逾期利息
       ,bf_repay_recvbl_uncol_ovdue_pric_pnlt  -- 还款前的应收未收逾期本金罚息
       ,bf_repay_recvbl_uncol_ovdue_int_pnlt   -- 还款前的应收未收逾期利息罚息
       ,job_cd                       -- 任务代码
       ,etl_timestamp                -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                                                            -- 数据日期
       ,t1.lp_id                                                                                                      -- 法人编号
       ,t1.dubil_id                                                                                                   -- 借据编号
       ,t2.cust_id                                                                                                    -- 客户编号
       ,t2.prod_id                                                                                                    -- 产品编号
       ,t2.repay_acct_id                                                                                              -- 还款账户编号
       ,t1.repay_flow_num                                                                                             -- 还款流水编号
       ,t1.repay_dt                                                                                                   -- 还款日期
       ,'0'                                                                                                           -- 内部结转标志
       ,'0'                                                                                                           -- 核销标志
       ,decode(t1.repay_type_cd, '02', '1', '0')                                                                      -- 提前还款标志
       ,decode(t1.repay_type_cd, '03', '1', '0')                                                                      -- 逾期还款标志
       ,t1.bf_repay_acru_flg                                                                                          -- 应计非应计代码
       ,t1.repay_type_cd                                                                                              -- 还款类型代码
       ,t2.curr_cd                                                                                                    -- 币种代码
       ,t4.bal                                                                                                        -- 当前正常本金余额
       ,t1.rpbl_tot_amt                                                                                               -- 当期还款金额
       ,nvl(t1.paid_nomal_pric, 0) + nvl(t1.paid_ovdue_pric, 0)                                                       -- 当期还款本金
       ,t1.paid_nomal_pric                                                                                            -- 当期还款正常本金
       ,t1.paid_ovdue_pric                                                                                            -- 当期还款逾期本金
       ,nvl(t1.paid_nomal_int, 0) + nvl(t1.paid_ovdue_int, 0)                                                         -- 当前还款利息
       ,t1.paid_nomal_int                                                                                             -- 当期还款正常利息
       ,t1.paid_ovdue_int                                                                                             -- 当期还款逾期利息
       ,nvl(t1.paid_ovdue_pric_pnlt, 0) + nvl(t1.paid_ovdue_int_pnlt, 0)                                              -- 当期还款罚息
       ,t1.paid_ovdue_pric_pnlt                                                                                       -- 当期还款逾期本金罚息
       ,t1.paid_ovdue_int_pnlt                                                                                        -- 当期还款逾期利息罚息
       ,0                                                                                                             -- 当期还款费用
       ,0                                                                                                             -- 当期还款费率
       ,t1.rpbl_nomal_pric                                                                                            -- 还款前的应收未收正常本金
       ,t1.rpbl_ovdue_pric                                                                                            -- 还款前的应收未收逾期本金
       ,t1.rpbl_nomal_int                                                                                             -- 还款前的应收未收正常利息
       ,t1.rpbl_ovdue_int                                                                                             -- 还款前的应收未收逾期利息
       ,t1.rpbl_ovdue_pric_pnlt                                                                                       -- 还款前的应收未收逾期本金罚息
       ,t1.rpbl_ovdue_int_pnlt                                                                                        -- 还款前的应收未收逾期利息罚息
       ,t1.job_cd                                                                                                     -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')                                                -- 数据处理时间
  from ${iml_schema}.evt_myloan_repay_dtl t1
 inner join ${iml_schema}.agt_myloan_dubil t2
    on t1.dubil_id = t2.dubil_id
   and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'mybkf1'
   and t2.id_mark<>'D'
  left join ${iml_schema}.agt_bal_h t4
    on t2.agt_id = t4.agt_id
   and t4.bal_type_cd = '005006'
   and t4.job_cd = 'mybkf1'
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
 where to_date(to_char(t1.repay_dt,'yyyymmdd'),'yyyymmdd') = to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'mybki1'
;
commit;

-- 第四组 微粒贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_dtl_ex(
       etl_dt                        -- 数据日期
       ,lp_id                        -- 法人编号
       ,dubil_id                     -- 借据编号
       ,cust_id                      -- 客户编号
       ,prod_id                      -- 产品编号
       ,repay_acct_id                -- 还款账户编号
       ,repay_flow_id                -- 还款流水编号
       ,repay_dt                     -- 还款日期
       ,intnal_carr_flg              -- 内部结转标志
       ,wrt_off_flg                  -- 核销标志
       ,adv_repay_flg                -- 提前还款标志
       ,ovdue_repay_flg              -- 逾期还款标志
       ,acru_non_acru_cd             -- 应计非应计代码
       ,repay_type_cd                -- 还款类型代码
       ,curr_cd                      -- 币种代码
       ,curr_nomal_pric_bal          -- 当前正常本金余额
       ,currt_repay_amt              -- 当期还款金额
       ,currt_repay_pric             -- 当期还款本金
       ,currt_repay_nomal_pric       -- 当期还款正常本金
       ,currt_repay_ovdue_pric       -- 当期还款逾期本金
       ,curr_repay_int               -- 当前还款利息
       ,currt_repay_nomal_int        -- 当期还款正常利息
       ,currt_repay_ovdue_int        -- 当期还款逾期利息
       ,currt_repay_pnlt             -- 当期还款罚息
       ,currt_repay_ovdue_pric_pnlt  -- 当期还款逾期本金罚息
       ,currt_repay_ovdue_int_pnlt   -- 当期还款逾期利息罚息
       ,currt_repay_fee              -- 当期还款费用
       ,currt_repay_fee_rat          -- 当期还款费率
       ,bf_repay_recvbl_uncol_nomal_pric       -- 还款前的应收未收正常本金
       ,bf_repay_recvbl_uncol_ovdue_pric       -- 还款前的应收未收逾期本金
       ,bf_repay_recvbl_uncol_nomal_int        -- 还款前的应收未收正常利息
       ,bf_repay_recvbl_uncol_ovdue_int        -- 还款前的应收未收逾期利息
       ,bf_repay_recvbl_uncol_ovdue_pric_pnlt  -- 还款前的应收未收逾期本金罚息
       ,bf_repay_recvbl_uncol_ovdue_int_pnlt   -- 还款前的应收未收逾期利息罚息
       ,job_cd                       -- 任务代码
       ,etl_timestamp                -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                 -- 数据日期
       ,t1.lp_id                                                           -- 法人编号
       ,t1.dubil_id                                                        -- 借据编号
       ,max(t2.cust_id)                                                    -- 客户编号
       ,t6.prod_id                                                         -- 产品编号
       ,max(t2.apot_repay_deduct_acct_num)                                 -- 还款账户编号
       ,t3.ser_num                                                         -- 还款流水编号
       ,t3.batch_dt                                                        -- 还款日期
       ,'0'                                                                -- 内部结转标志
       ,max(decode(t3.evt_tran_code, 'G188', '1', 'G911', '1', '0'))       -- 核销标志
       ,max(decode(t3.evt_tran_code, 'L846', '1', 'L848', '1', '0'))       -- 提前还款标志
       ,max(case when t3.evt_tran_code = 'L840' then '1'
                 when t3.evt_tran_code = 'L842' and t1.curr_ovdue_days > 0 then '1'
                 else '0'
            end)                                                           -- 逾期还款标志
       ,'0'                                                                -- 应计非应计代码
       ,max(decode(t2.apot_repay_type_cd, 'F', '02', '00'))                -- 还款类型代码
       ,max(t3.curr_cd)                                                    -- 币种代码
       ,max(nvl(t4.amt, 0) * nvl(t5.ratio, 1))                             -- 当前正常本金余额
       ,sum(case when t3.evt_tran_code ='G202' and t3.rb_w_flg ='N' and t3.debit_crdt_flg = 'D' and t3.bal_compnt_group_cd = 'LP' then -t3.enter_acct_amt 
                 when t3.evt_tran_code ='G202' and t3.rb_w_flg ='N' and t3.debit_crdt_flg = 'C' and t3.bal_compnt_group_cd = 'LP' then t3.enter_acct_amt 
	               when t3.debit_crdt_flg='D' then t3.enter_acct_amt
			           else 0 end)                                               -- 当期还款金额
       ,sum(case when t3.evt_tran_code ='G202' and t3.rb_w_flg ='N' and t3.debit_crdt_flg = 'D' and t3.bal_compnt_group_cd = 'LP' then -t3.enter_acct_amt 
                 when t3.evt_tran_code ='G202' and t3.rb_w_flg ='N' and t3.debit_crdt_flg = 'C' and t3.bal_compnt_group_cd = 'LP' then t3.enter_acct_amt 
	               when t3.debit_crdt_flg = 'D' and t3.bal_compnt_group_cd = 'LP' then t3.enter_acct_amt 
                 else 0 end)                                               -- 当期还款本金
       ,sum(case when t3.evt_tran_code ='G202' and t3.rb_w_flg ='N' and t3.debit_crdt_flg = 'D' and t3.bal_compnt_group_cd = 'LP' then -t3.enter_acct_amt 
                 when t3.evt_tran_code ='G202' and t3.rb_w_flg ='N' and t3.debit_crdt_flg = 'C' and t3.bal_compnt_group_cd = 'LP' then t3.enter_acct_amt 
	               when t3.debit_crdt_flg = 'D' and t3.bal_compnt_group_cd = 'LP' and t3.evt_tran_code not in ('L840', 'L842','L870') then t3.enter_acct_amt 
	               else 0 end)                                               -- 当期还款正常本金
       ,sum(case when t3.debit_crdt_flg = 'D' and t3.bal_compnt_group_cd = 'LP' and t3.evt_tran_code in ('L840', 'L842') 
                 then t3.enter_acct_amt else 0 end)                        -- 当期还款逾期本金
       ,sum(case when t3.evt_tran_code ='G202' and t3.rb_w_flg ='N' and t3.debit_crdt_flg = 'D' and t3.bal_compnt_group_cd = 'LI' then -t3.enter_acct_amt 
                 when t3.evt_tran_code ='G202' and t3.rb_w_flg ='N' and t3.debit_crdt_flg = 'C' and t3.bal_compnt_group_cd = 'LI' then t3.enter_acct_amt   
	               when t3.debit_crdt_flg = 'D' and t3.bal_compnt_group_cd = 'LI' and t3.subj_id='111001156304001010' then t3.enter_acct_amt 
	               else 0 end)                                               -- 当前还款利息
       ,sum(case when t3.evt_tran_code ='G202' and t3.rb_w_flg ='N' and t3.debit_crdt_flg = 'D' and t3.bal_compnt_group_cd = 'LI' then -t3.enter_acct_amt 
                 when t3.evt_tran_code ='G202' and t3.rb_w_flg ='N' and t3.debit_crdt_flg = 'C' and t3.bal_compnt_group_cd = 'LI' then t3.enter_acct_amt
	               when t3.debit_crdt_flg = 'D' and t3.bal_compnt_group_cd = 'LI' and t3.subj_id='111001156304001010' and t3.evt_tran_code not in ('L840', 'L842','L870') then t3.enter_acct_amt 
			           else 0 end)                                               -- 当期还款正常利息
       ,sum(case when t3.debit_crdt_flg = 'D' and t3.bal_compnt_group_cd = 'LI' and t3.subj_id='111001156304001010' and t3.evt_tran_code in ('L840', 'L842') then t3.enter_acct_amt else 0 end)  -- 当期还款逾期利息
       ,sum(case when t3.debit_crdt_flg = 'D' and t3.bal_compnt_group_cd = 'LT' and t3.subj_id='111001156304001010' then t3.enter_acct_amt else 0 end)  -- 当期还款罚息
       ,0                                                                  -- 当期还款逾期本金罚息
       ,0                                                                  -- 当期还款逾期利息罚息
       ,0                                                                  -- 当期还款费用
       ,0                                                                  -- 当期还款费率
       ,''                                                                 -- 还款前的应收未收正常本金
       ,''                                                                 -- 还款前的应收未收逾期本金
       ,''                                                                 -- 还款前的应收未收正常利息
       ,''                                                                 -- 还款前的应收未收逾期利息
       ,''                                                                 -- 还款前的应收未收逾期本金罚息
       ,''                                                                 -- 还款前的应收未收逾期利息罚息
       ,t1.job_cd                                                          -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')     -- 数据处理时间    
  from ${iml_schema}.agt_wld_dubil_info t1 
 inner join ${iml_schema}.agt_wld_acct t2
    on t1.acct_id = t2.acct_id  
   and t1.acct_type_cd = t2.acct_type_cd
   and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'mpcsf1'
   and t2.id_mark<>'D'
 inner join ${icl_schema}.cmm_unite_wl_repay_dtl_ex01 t3
    on t1.tran_ref_no = t3.tran_ref_no  
   and t1.card_no = t3.card_no
   and t3.job_cd ='mpcsi1'
 left join ${iml_schema}.agt_amt_h t4
   on t1.agt_id = t4.agt_id
  and t4.amt_type_cd = '001011'
  and t4.job_cd = 'mpcsf1'
  and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t4.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iml_schema}.agt_int_org_rela_h t5
   on t1.agt_id = t5.agt_id
  and t5.org_id = '897001'
  and t5.job_cd = 'mpcsf1'
  and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t5.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iml_schema}.agt_prod_rela_h t6
    on t1.intnal_dubil_id = substr(t6.agt_id,7)
   and t6.start_dt <=to_date('${batch_date}','yyyymmdd')
   and t6.end_dt >=to_date('${batch_date}','yyyymmdd')
   and t6.job_cd ='mpcsf1'
   and t6.agt_prod_rela_type_cd = '02'
where t1.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.job_cd = 'mpcsf1'
  and t1.id_mark<>'D'
group by t1.lp_id
         ,t1.job_cd
         ,t1.dubil_id
         ,t3.ser_num
         ,t3.batch_dt
         ,t6.prod_id
;
commit;    
 
-- 第五组 借呗三期
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_dtl_ex(
       etl_dt                        -- 数据日期
       ,lp_id                        -- 法人编号
       ,dubil_id                     -- 借据编号
       ,cust_id                      -- 客户编号
       ,prod_id                      -- 产品编号
       ,repay_acct_id                -- 还款账户编号
       ,repay_flow_id                -- 还款流水编号
       ,repay_dt                     -- 还款日期
       ,intnal_carr_flg              -- 内部结转标志
       ,wrt_off_flg                  -- 核销标志
       ,adv_repay_flg                -- 提前还款标志
       ,ovdue_repay_flg              -- 逾期还款标志
       ,acru_non_acru_cd             -- 应计非应计代码
       ,repay_type_cd                -- 还款类型代码
       ,curr_cd                      -- 币种代码
       ,curr_nomal_pric_bal          -- 当前正常本金余额
       ,currt_repay_amt              -- 当期还款金额
       ,currt_repay_pric             -- 当期还款本金
       ,currt_repay_nomal_pric       -- 当期还款正常本金
       ,currt_repay_ovdue_pric       -- 当期还款逾期本金
       ,curr_repay_int               -- 当前还款利息
       ,currt_repay_nomal_int        -- 当期还款正常利息
       ,currt_repay_ovdue_int        -- 当期还款逾期利息
       ,currt_repay_pnlt             -- 当期还款罚息
       ,currt_repay_ovdue_pric_pnlt  -- 当期还款逾期本金罚息
       ,currt_repay_ovdue_int_pnlt   -- 当期还款逾期利息罚息
       ,currt_repay_fee              -- 当期还款费用
       ,currt_repay_fee_rat          -- 当期还款费率
       ,bf_repay_recvbl_uncol_nomal_pric       -- 还款前的应收未收正常本金
       ,bf_repay_recvbl_uncol_ovdue_pric       -- 还款前的应收未收逾期本金
       ,bf_repay_recvbl_uncol_nomal_int        -- 还款前的应收未收正常利息
       ,bf_repay_recvbl_uncol_ovdue_int        -- 还款前的应收未收逾期利息
       ,bf_repay_recvbl_uncol_ovdue_pric_pnlt  -- 还款前的应收未收逾期本金罚息
       ,bf_repay_recvbl_uncol_ovdue_int_pnlt   -- 还款前的应收未收逾期利息罚息
       ,job_cd                       -- 任务代码
       ,etl_timestamp                -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                                                    -- 数据日期
       ,t1.lp_id                                                                                              -- 法人编号
       ,t1.dubil_id                                                                                           -- 借据编号
       ,t2.cust_id                                                                                            -- 客户编号
       ,t2.prod_id                                                                                            -- 产品编号
       ,t2.repay_acct_id                                                                                      -- 还款账户编号
       ,t1.repay_flow_num                                                                                     -- 还款流水编号
       ,t1.repay_dt                                                                                           -- 还款日期
       ,'0'                                                                                                   -- 内部结转标志
       ,decode(t1.wrt_off_flg, 'Y', '1', '0')                                                                 -- 核销标志
       ,decode(t1.repay_type_cd, '02', '1', '0')                                                              -- 提前还款标志
       ,decode(t1.repay_type_cd, '03', '1', '0')                                                              -- 逾期还款标志
       ,t1.acru_non_acru_flg                                                                                  -- 应计非应计代码
       ,t1.repay_type_cd                                                                                      -- 还款类型代码
       ,nvl(trim(t2.curr_cd), 'CNY')                                                                          -- 币种代码
       ,t4.bal                                                                                                -- 当前正常本金余额
       ,t1.paid_tot_amt                                                                                       -- 当期还款金额
       ,nvl(t1.paid_nomal_pric, 0) + nvl(t1.paid_ovdue_pric, 0)                                               -- 当期还款本金
       ,t1.paid_nomal_pric                                                                                    -- 当期还款正常本金
       ,t1.paid_ovdue_pric                                                                                    -- 当期还款逾期本金
       ,nvl(t1.paid_nomal_int, 0) + nvl(t1.paid_ovdue_int, 0)                                                 -- 当前还款利息
       ,t1.paid_nomal_int                                                                                     -- 当期还款正常利息
       ,t1.paid_ovdue_int                                                                                     -- 当期还款逾期利息
       ,nvl(t1.paid_ovdue_pric_pnlt,0) + nvl(t1.paid_ovdue_int_pnlt, 0)                                       -- 当期还款罚息
       ,t1.paid_ovdue_pric_pnlt                                                                               -- 当期还款逾期本金罚息
       ,t1.paid_ovdue_int_pnlt                                                                                -- 当期还款逾期利息罚息
       ,t1.plat_serv_fee_amt                                                                                  -- 当期还款费用
       ,case when nvl(t1.paid_tot_amt, 0) = 0 then 0 else nvl(t1.plat_serv_fee_amt, 0) / t1.paid_tot_amt end  -- 当期还款费率
       ,t1.rpbl_nomal_pric                                                                                    -- 还款前的应收未收正常本金
       ,t1.rpbl_ovdue_pric                                                                                    -- 还款前的应收未收逾期本金
       ,t1.rpbl_nomal_int                                                                                     -- 还款前的应收未收正常利息
       ,t1.rpbl_ovdue_int                                                                                     -- 还款前的应收未收逾期利息
       ,t1.rpbl_ovdue_pric_pnlt                                                                               -- 还款前的应收未收逾期本金罚息
       ,t1.rpbl_ovdue_int_pnlt                                                                                -- 还款前的应收未收逾期利息罚息
       ,t1.job_cd                                                                                             -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')                                        -- 数据处理时间
  from ${iml_schema}.evt_ajb_ped_3_repay_dtl t1
 inner join ${iml_schema}.agt_ajb_ped_3_dubil t2
    on t1.dubil_id = t2.dubil_id
   and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'myjbf3'
   and t2.id_mark<>'D'
  left join ${iml_schema}.agt_bal_h t4
    on t2.agt_id = t4.agt_id
   and t4.bal_type_cd = '005006'
   and t4.job_cd = 'myjbf3'
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
 where to_date(to_char(t1.repay_dt,'yyyymmdd'),'yyyymmdd') = to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'myjbi3'
;
commit;

-- 第六组 京东贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_dtl_ex(
       etl_dt                        -- 数据日期
       ,lp_id                        -- 法人编号
       ,dubil_id                     -- 借据编号
       ,cust_id                      -- 客户编号
       ,prod_id                      -- 产品编号
       ,repay_acct_id                -- 还款账户编号
       ,repay_flow_id                -- 还款流水编号
       ,repay_dt                     -- 还款日期
       ,intnal_carr_flg              -- 内部结转标志
       ,wrt_off_flg                  -- 核销标志
       ,adv_repay_flg                -- 提前还款标志
       ,ovdue_repay_flg              -- 逾期还款标志
       ,acru_non_acru_cd             -- 应计非应计代码
       ,repay_type_cd                -- 还款类型代码
       ,curr_cd                      -- 币种代码
       ,curr_nomal_pric_bal          -- 当前正常本金余额
       ,currt_repay_amt              -- 当期还款金额
       ,currt_repay_pric             -- 当期还款本金
       ,currt_repay_nomal_pric       -- 当期还款正常本金
       ,currt_repay_ovdue_pric       -- 当期还款逾期本金
       ,curr_repay_int               -- 当前还款利息
       ,currt_repay_nomal_int        -- 当期还款正常利息
       ,currt_repay_ovdue_int        -- 当期还款逾期利息
       ,currt_repay_pnlt             -- 当期还款罚息
       ,currt_repay_ovdue_pric_pnlt  -- 当期还款逾期本金罚息
       ,currt_repay_ovdue_int_pnlt   -- 当期还款逾期利息罚息
       ,currt_repay_fee              -- 当期还款费用
       ,currt_repay_fee_rat          -- 当期还款费率
       ,bf_repay_recvbl_uncol_nomal_pric       -- 还款前的应收未收正常本金
       ,bf_repay_recvbl_uncol_ovdue_pric       -- 还款前的应收未收逾期本金
       ,bf_repay_recvbl_uncol_nomal_int        -- 还款前的应收未收正常利息
       ,bf_repay_recvbl_uncol_ovdue_int        -- 还款前的应收未收逾期利息
       ,bf_repay_recvbl_uncol_ovdue_pric_pnlt  -- 还款前的应收未收逾期本金罚息
       ,bf_repay_recvbl_uncol_ovdue_int_pnlt   -- 还款前的应收未收逾期利息罚息
       ,job_cd                       -- 任务代码
       ,etl_timestamp                -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                             -- 数据日期
       ,t1.lp_id                                                                       -- 法人编号
       ,t1.dubil_id                                                                    -- 借据编号
       ,t2.cust_id                                                                     -- 客户编号
       ,t1.prod_id                                                                     -- 产品编号
       ,t2.loan_repay_num                                                              -- 还款账户编号
       ,t1.repay_flow_num                                                              -- 还款流水编号
       ,t1.repay_dt                                                                    -- 还款日期
       ,'0'                                                                            -- 内部结转标志
       ,'0'                                                                            -- 核销标志
       ,decode(t1.repay_type_cd, '07', '1', '0')                                       -- 提前还款标志
       ,decode(t1.repay_type_cd, '08', '1', '0')                                       -- 逾期还款标志
       ,'0'                                                                            -- 应计非应计代码
       ,t1.repay_type_cd                                                               -- 还款类型代码
       ,nvl(trim(t2.curr_cd), 'CNY')                                                   -- 币种代码
       ,t4.bal                                                                         -- 当前正常本金余额
       ,nvl(t1.paid_pric_amt, 0) + nvl(t1.paid_int_amt, 0) + nvl(t1.paid_pnlt_amt, 0)  -- 当期还款金额
       ,nvl(t1.paid_pric_amt, 0)                                                       -- 当期还款本金
       ,nvl(t1.paid_pric_amt, 0)                                                       -- 当期还款正常本金
       ,0                                                                              -- 当期还款逾期本金
       ,nvl(t1.paid_int_amt, 0)                                                        -- 当前还款利息
       ,nvl(t1.paid_int_amt, 0)                                                        -- 当期还款正常利息
       ,0                                                                              -- 当期还款逾期利息
       ,nvl(t1.paid_pnlt_amt,0)                                                        -- 当期还款罚息
       ,nvl(t1.paid_pnlt_amt,0)                                                        -- 当期还款逾期本金罚息
       ,0                                                                              -- 当期还款逾期利息罚息
       ,t1.serv_fee                                                                    -- 当期还款费用
       ,case when nvl(t1.paid_pric_amt, 0) + nvl(t1.paid_int_amt, 0) + nvl(t1.paid_pnlt_amt, 0) = 0 then 0
             else nvl(t1.serv_fee, 0) / (nvl(t1.paid_pric_amt, 0) + nvl(t1.paid_int_amt, 0) + nvl(t1.paid_pnlt_amt, 0)) 
        end                                                                            -- 当期还款费率
       ,''                                                                             -- 还款前的应收未收正常本金
       ,''                                                                             -- 还款前的应收未收逾期本金
       ,''                                                                             -- 还款前的应收未收正常利息
       ,''                                                                             -- 还款前的应收未收逾期利息
       ,''                                                                             -- 还款前的应收未收逾期本金罚息
       ,''                                                                             -- 还款前的应收未收逾期利息罚息
       ,t1.job_cd                                                                      -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')                 -- 数据处理时间
  from ${iml_schema}.evt_jd_repay_dtl t1
 inner join ${iml_schema}.agt_jd_loan_dubil_info t2
    on t1.dubil_id = t2.dubil_id
   and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'jdjrf1'
   and t2.id_mark<>'D'
  left join ${iml_schema}.agt_bal_h t4
    on t2.agt_id = t4.agt_id
   and t4.bal_type_cd = '005008'
   and t4.job_cd = 'jdjrf1'
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
 where to_date(to_char(t1.repay_dt,'yyyymmdd'),'yyyymmdd') = to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'jdjri1'
;
commit;  


-- 第七组 微粒贷-综合信贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_dtl_ex(
       etl_dt                        -- 数据日期
       ,lp_id                        -- 法人编号
       ,dubil_id                     -- 借据编号
       ,cust_id                      -- 客户编号
       ,prod_id                      -- 产品编号
       ,repay_acct_id                -- 还款账户编号
       ,repay_flow_id                -- 还款流水编号
       ,repay_dt                     -- 还款日期
       ,intnal_carr_flg              -- 内部结转标志
       ,wrt_off_flg                  -- 核销标志
       ,adv_repay_flg                -- 提前还款标志
       ,ovdue_repay_flg              -- 逾期还款标志
       ,acru_non_acru_cd             -- 应计非应计代码
       ,repay_type_cd                -- 还款类型代码
       ,curr_cd                      -- 币种代码
       ,curr_nomal_pric_bal          -- 当前正常本金余额
       ,currt_repay_amt              -- 当期还款金额
       ,currt_repay_pric             -- 当期还款本金
       ,currt_repay_nomal_pric       -- 当期还款正常本金
       ,currt_repay_ovdue_pric       -- 当期还款逾期本金
       ,curr_repay_int               -- 当前还款利息
       ,currt_repay_nomal_int        -- 当期还款正常利息
       ,currt_repay_ovdue_int        -- 当期还款逾期利息
       ,currt_repay_pnlt             -- 当期还款罚息
       ,currt_repay_ovdue_pric_pnlt  -- 当期还款逾期本金罚息
       ,currt_repay_ovdue_int_pnlt   -- 当期还款逾期利息罚息
       ,currt_repay_fee              -- 当期还款费用
       ,currt_repay_fee_rat          -- 当期还款费率
       ,bf_repay_recvbl_uncol_nomal_pric       -- 还款前的应收未收正常本金
       ,bf_repay_recvbl_uncol_ovdue_pric       -- 还款前的应收未收逾期本金
       ,bf_repay_recvbl_uncol_nomal_int        -- 还款前的应收未收正常利息
       ,bf_repay_recvbl_uncol_ovdue_int        -- 还款前的应收未收逾期利息
       ,bf_repay_recvbl_uncol_ovdue_pric_pnlt  -- 还款前的应收未收逾期本金罚息
       ,bf_repay_recvbl_uncol_ovdue_int_pnlt   -- 还款前的应收未收逾期利息罚息
       ,job_cd                       -- 任务代码
       ,etl_timestamp                -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                 -- 数据日期
       ,t1.lp_id                                                           -- 法人编号
       ,t1.dubil_id                                                        -- 借据编号
       ,t1.cust_id                                                         -- 客户编号
       ,t1.prod_id                                                         -- 产品编号
       ,max(t2.apot_repay_deduct_acct_num)                                 -- 还款账户编号
       ,t3.core_tran_flow                                                  -- 还款流水编号
       ,t3.batch_dt                                                        -- 还款日期
       ,'0'                                                                -- 内部结转标志
       ,max(decode(t3.evt_tran_code, 'G188', '1', 'G911', '1', '0'))       -- 核销标志
       ,max(decode(t3.evt_tran_code, 'L846', '1', 'L848', '1', '0'))       -- 提前还款标志
       ,max(case when t3.evt_tran_code = 'L840' then '1'
                 when t3.evt_tran_code = 'L842' and t1.curr_ovdue_days > 0 then '1'
                 else '0'
            end)                                                           -- 逾期还款标志
       ,'0'                                                                -- 应计非应计代码
       ,max(decode(t2.apot_repay_type_cd, 'F', '02', '00'))                -- 还款类型代码
       ,max(t3.curr_cd)                                                    -- 币种代码
       ,t2.curr_bal * t2.bank_contri_ratio                             -- 当前正常本金余额
       ,sum(case when t3.evt_tran_code ='G202' and t3.rb_w_flg ='N' and t3.debit_crdt_flg = 'D' and t3.bal_compnt_group_cd = 'LP' then -t3.enter_acct_amt 
                 when t3.evt_tran_code ='G202' and t3.rb_w_flg ='N' and t3.debit_crdt_flg = 'C' and t3.bal_compnt_group_cd = 'LP' then t3.enter_acct_amt 
	               when t3.debit_crdt_flg='D' then t3.enter_acct_amt
			           else 0 end)                                               -- 当期还款金额
       ,sum(case when t3.evt_tran_code ='G202' and t3.rb_w_flg ='N' and t3.debit_crdt_flg = 'D' and t3.bal_compnt_group_cd = 'LP' then -t3.enter_acct_amt 
                 when t3.evt_tran_code ='G202' and t3.rb_w_flg ='N' and t3.debit_crdt_flg = 'C' and t3.bal_compnt_group_cd = 'LP' then t3.enter_acct_amt 
	               when t3.debit_crdt_flg = 'D' and t3.bal_compnt_group_cd = 'LP' then t3.enter_acct_amt 
                 else 0 end)                                               -- 当期还款本金
       ,sum(case when t3.evt_tran_code ='G202' and t3.rb_w_flg ='N' and t3.debit_crdt_flg = 'D' and t3.bal_compnt_group_cd = 'LP' then -t3.enter_acct_amt 
                 when t3.evt_tran_code ='G202' and t3.rb_w_flg ='N' and t3.debit_crdt_flg = 'C' and t3.bal_compnt_group_cd = 'LP' then t3.enter_acct_amt 
	               when t3.debit_crdt_flg = 'D' and t3.bal_compnt_group_cd = 'LP' and t3.evt_tran_code not in ('L840', 'L842','L870') then t3.enter_acct_amt 
	               else 0 end)                                               -- 当期还款正常本金
       ,sum(case when t3.debit_crdt_flg = 'D' and t3.bal_compnt_group_cd = 'LP' and t3.evt_tran_code in ('L840', 'L842') 
                 then t3.enter_acct_amt else 0 end)                        -- 当期还款逾期本金
       ,sum(case when t3.evt_tran_code ='G202' and t3.rb_w_flg ='N' and t3.debit_crdt_flg = 'D' and t3.bal_compnt_group_cd = 'LI' then -t3.enter_acct_amt 
                 when t3.evt_tran_code ='G202' and t3.rb_w_flg ='N' and t3.debit_crdt_flg = 'C' and t3.bal_compnt_group_cd = 'LI' then t3.enter_acct_amt   
	               when t3.debit_crdt_flg = 'D' and t3.bal_compnt_group_cd = 'LI' and t3.subj_id='111001156304001010' then t3.enter_acct_amt 
	               else 0 end)                                               -- 当前还款利息
       ,sum(case when t3.evt_tran_code ='G202' and t3.rb_w_flg ='N' and t3.debit_crdt_flg = 'D' and t3.bal_compnt_group_cd = 'LI' then -t3.enter_acct_amt 
                 when t3.evt_tran_code ='G202' and t3.rb_w_flg ='N' and t3.debit_crdt_flg = 'C' and t3.bal_compnt_group_cd = 'LI' then t3.enter_acct_amt
	               when t3.debit_crdt_flg = 'D' and t3.bal_compnt_group_cd = 'LI' and t3.subj_id='111001156304001010' and t3.evt_tran_code not in ('L840', 'L842','L870') then t3.enter_acct_amt 
			           else 0 end)                                               -- 当期还款正常利息
       ,sum(case when t3.debit_crdt_flg = 'D' and t3.bal_compnt_group_cd = 'LI' and t3.subj_id='111001156304001010' and t3.evt_tran_code in ('L840', 'L842') then t3.enter_acct_amt else 0 end)  -- 当期还款逾期利息
       ,sum(case when t3.debit_crdt_flg = 'D' and t3.bal_compnt_group_cd = 'LT' and t3.subj_id='111001156304001010' then t3.enter_acct_amt else 0 end)  -- 当期还款罚息
       ,0                                                                  -- 当期还款逾期本金罚息
       ,0                                                                  -- 当期还款逾期利息罚息
       ,0                                                                  -- 当期还款费用
       ,0                                                                  -- 当期还款费率
       ,''                                                                 -- 还款前的应收未收正常本金
       ,''                                                                 -- 还款前的应收未收逾期本金
       ,''                                                                 -- 还款前的应收未收正常利息
       ,''                                                                 -- 还款前的应收未收逾期利息
       ,''                                                                 -- 还款前的应收未收逾期本金罚息
       ,''                                                                 -- 还款前的应收未收逾期利息罚息
       ,t1.job_cd                                                          -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')     -- 数据处理时间    
  from ${iml_schema}.agt_wld_dubil_info_h t1 
 inner join ${iml_schema}.agt_wld_acct_h t2
    on t1.acct_id = t2.acct_id  
   and t1.acct_type_cd = t2.acct_type_cd
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'icmsf1'
 inner join ${icl_schema}.cmm_unite_wl_repay_dtl_ex01 t3
    on t1.tran_ref_no = t3.tran_ref_no  
   and t1.card_no = t3.card_no
   and t3.job_cd ='icmsi1'
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'icmsf1'
 group by t1.lp_id
         ,t1.job_cd
         ,t1.dubil_id
         ,t3.core_tran_flow
         ,t3.batch_dt
         ,t1.prod_id
         ,t2.curr_bal * t2.bank_contri_ratio
         ,t1.cust_id
;
commit;

-- 第八组 字节小微贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_dtl_ex(
       etl_dt                        -- 数据日期
       ,lp_id                        -- 法人编号
       ,dubil_id                     -- 借据编号
       ,cust_id                      -- 客户编号
       ,prod_id                      -- 产品编号
       ,repay_acct_id                -- 还款账户编号
       ,repay_flow_id                -- 还款流水编号
       ,repay_dt                     -- 还款日期
       ,intnal_carr_flg              -- 内部结转标志
       ,wrt_off_flg                  -- 核销标志
       ,adv_repay_flg                -- 提前还款标志
       ,ovdue_repay_flg              -- 逾期还款标志
       ,acru_non_acru_cd             -- 应计非应计代码
       ,repay_type_cd                -- 还款类型代码
       ,curr_cd                      -- 币种代码
       ,curr_nomal_pric_bal          -- 当前正常本金余额
       ,currt_repay_amt              -- 当期还款金额
       ,currt_repay_pric             -- 当期还款本金
       ,currt_repay_nomal_pric       -- 当期还款正常本金
       ,currt_repay_ovdue_pric       -- 当期还款逾期本金
       ,curr_repay_int               -- 当前还款利息
       ,currt_repay_nomal_int        -- 当期还款正常利息
       ,currt_repay_ovdue_int        -- 当期还款逾期利息
       ,currt_repay_pnlt             -- 当期还款罚息
       ,currt_repay_ovdue_pric_pnlt  -- 当期还款逾期本金罚息
       ,currt_repay_ovdue_int_pnlt   -- 当期还款逾期利息罚息
       ,currt_repay_fee              -- 当期还款费用
       ,currt_repay_fee_rat          -- 当期还款费率
       ,bf_repay_recvbl_uncol_nomal_pric       -- 还款前的应收未收正常本金
       ,bf_repay_recvbl_uncol_ovdue_pric       -- 还款前的应收未收逾期本金
       ,bf_repay_recvbl_uncol_nomal_int        -- 还款前的应收未收正常利息
       ,bf_repay_recvbl_uncol_ovdue_int        -- 还款前的应收未收逾期利息
       ,bf_repay_recvbl_uncol_ovdue_pric_pnlt  -- 还款前的应收未收逾期本金罚息
       ,bf_repay_recvbl_uncol_ovdue_int_pnlt   -- 还款前的应收未收逾期利息罚息
       ,job_cd                       -- 任务代码
       ,etl_timestamp                -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                 -- 数据日期
       ,t1.lp_id                                                           -- 法人编号
       ,t1.intnal_dubil_id                                                 -- 借据编号
       ,t3.cust_id                                                         -- 客户编号
       ,t3.prod_id                                                         -- 产品编号
       ,t2.repay_num_id                                                    -- 还款账户编号
       ,t1.tran_flow_num || t1.perds                                       -- 还款流水编号
       ,t1.tran_dt                                                         -- 还款日期
       ,'0'                                                                -- 内部结转标志
       ,''                                                                 -- 核销标志
       ,case when t1.repay_type_cd = '13' then '1' else '0' end            -- 提前还款标志
       ,Case when t1.repay_type_cd = '11' then '1' else '0' end            -- 逾期还款标志
       ,t2.non_acru_flg                                                    -- 应计非应计代码
       ,t1.repay_type_cd                                                   -- 还款类型代码
       ,'CNY'                                                              -- 币种代码
       ,nvl(t3.nomal_pric_bal,0)                                           -- 当前正常本金余额
       ,nvl(t1.actl_recv_amt,0)                                            -- 当期还款金额
       ,nvl(t1.pric_amt,0)                                                 -- 当期还款本金
       ,case when t1.repay_type_cd in ('12') then  nvl(t1.pric_amt,0) end       -- 当期还款正常本金
       ,case when t1.repay_type_cd in ('11') then  nvl(t1.pric_amt,0) end       -- 当期还款逾期本金
       ,nvl(t1.int_amt,0)                                                  -- 当前还款利息
       ,case when t1.repay_type_cd in ('12') then nvl(t1.int_amt,0) end         -- 当期还款正常利息
       ,case when t1.repay_type_cd in ('11') then nvl(t1.int_amt,0) end         -- 当期还款逾期利息
       ,nvl(t1.pnlt_amt,0)                                                 -- 当期还款罚息
       ,''                                                                 -- 当期还款逾期本金罚息
       ,''                                                                 -- 当期还款逾期利息罚息
       ,nvl(t1.paid_adv_repay_comm_fee,0)                                  -- 当期还款费用
       ,''                                                                 -- 当期还款费率
       ,''                                                                 -- 还款前的应收未收正常本金
       ,''                                                                 -- 还款前的应收未收逾期本金
       ,''                                                                 -- 还款前的应收未收正常利息
       ,''                                                                 -- 还款前的应收未收逾期利息
       ,''                                                                 -- 还款前的应收未收逾期本金罚息
       ,''                                                                 -- 还款前的应收未收逾期利息罚息
       ,t1.job_cd                                                          -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')     -- 数据处理时间    
  from ${iml_schema}.agt_zjdk_repay_dtl t1
  left join ${iml_schema}.evt_zjdk_repay_flow t2
    on t1.intnal_dubil_id = t2.intnal_dubil_id
   and t1.tran_flow_num = t2.tran_flow_num
   and t1.acct_dt = t2.acct_dt
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_zjdk_dubil_info_h t3
    on t1.intnal_dubil_id = t3.intnal_dubil_id
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'icmsf1'
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'icmsf1'
   and t1.acct_dt = to_date('${batch_date}','yyyymmdd')
;
commit;

-- 第九组 微业贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_dtl_ex(
       etl_dt                        -- 数据日期
       ,lp_id                        -- 法人编号
       ,dubil_id                     -- 借据编号
       ,cust_id                      -- 客户编号
       ,prod_id                      -- 产品编号
       ,repay_acct_id                -- 还款账户编号
       ,repay_flow_id                -- 还款流水编号
       ,repay_dt                     -- 还款日期
       ,intnal_carr_flg              -- 内部结转标志
       ,wrt_off_flg                  -- 核销标志
       ,adv_repay_flg                -- 提前还款标志
       ,ovdue_repay_flg              -- 逾期还款标志
       ,acru_non_acru_cd             -- 应计非应计代码
       ,repay_type_cd                -- 还款类型代码
       ,curr_cd                      -- 币种代码
       ,curr_nomal_pric_bal          -- 当前正常本金余额
       ,currt_repay_amt              -- 当期还款金额
       ,currt_repay_pric             -- 当期还款本金
       ,currt_repay_nomal_pric       -- 当期还款正常本金
       ,currt_repay_ovdue_pric       -- 当期还款逾期本金
       ,curr_repay_int               -- 当前还款利息
       ,currt_repay_nomal_int        -- 当期还款正常利息
       ,currt_repay_ovdue_int        -- 当期还款逾期利息
       ,currt_repay_pnlt             -- 当期还款罚息
       ,currt_repay_ovdue_pric_pnlt  -- 当期还款逾期本金罚息
       ,currt_repay_ovdue_int_pnlt   -- 当期还款逾期利息罚息
       ,currt_repay_fee              -- 当期还款费用
       ,currt_repay_fee_rat          -- 当期还款费率
       ,bf_repay_recvbl_uncol_nomal_pric       -- 还款前的应收未收正常本金
       ,bf_repay_recvbl_uncol_ovdue_pric       -- 还款前的应收未收逾期本金
       ,bf_repay_recvbl_uncol_nomal_int        -- 还款前的应收未收正常利息
       ,bf_repay_recvbl_uncol_ovdue_int        -- 还款前的应收未收逾期利息
       ,bf_repay_recvbl_uncol_ovdue_pric_pnlt  -- 还款前的应收未收逾期本金罚息
       ,bf_repay_recvbl_uncol_ovdue_int_pnlt   -- 还款前的应收未收逾期利息罚息
       ,job_cd                       -- 任务代码
       ,etl_timestamp                -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                 -- 数据日期
       ,t1.lp_id                                                           -- 法人编号
       ,t1.dubil_id                                                        -- 借据编号
       ,t1.cust_id                                                         -- 客户编号
       ,t1.prod_id                                                         -- 产品编号
       ,t2.repay_num_id                                                    -- 还款账户编号**
       ,t1.repay_flow_num                                                  -- 还款流水编号
       ,t1.repay_dt                                                        -- 还款日期
       ,'0'                                                                -- 内部结转标志
       ,''                                                                 -- 核销标志
       ,case when t1.repay_type_cd in ('05','06') then '1' else '0' end    -- 提前还款标志
       ,case when t1.repay_type_cd = '03' then '1' else '0' end            -- 逾期还款标志
       ,''                                                                 -- 应计非应计代码
       ,t1.repay_type_cd                                                   -- 还款类型代码
       ,'CNY'                                                              -- 币种代码
       ,nvl(t2.loan_bal,0)                                                 -- 当前正常本金余额
       ,nvl(t1.repay_pric,0)+nvl(t1.repay_int,0)+nvl(t1.repay_pnlt,0)+nvl(t1.repay_fee,0) -- 当期还款金额
       ,nvl(t1.repay_pric,0)                                               -- 当期还款本金
       ,case when t1.repay_type_cd in ('01') then nvl(t1.repay_pric,0) end -- 当期还款正常本金
       ,case when t1.repay_type_cd in ('03') then nvl(t1.repay_pric,0) end -- 当期还款逾期本金
       ,nvl(t1.repay_int,0)                                                -- 当前还款利息
       ,case when t1.repay_type_cd in ('01') then nvl(t1.repay_int,0) end  -- 当期还款正常利息
       ,case when t1.repay_type_cd in ('03') then nvl(t1.repay_int,0) end  -- 当期还款逾期利息
       ,nvl(t1.repay_pnlt,0)                                               -- 当期还款罚息
       ,case when t1.repay_type_cd in ('01') then nvl(t1.repay_pnlt,0) end -- 当期还款逾期本金罚息
       ,case when t1.repay_type_cd in ('03') then nvl(t1.repay_pnlt,0) end -- 当期还款逾期利息罚息
       ,nvl(t1.repay_fee,0)                                                -- 当期还款费用
       ,''                                                                 -- 当期还款费率
       ,''                                                                 -- 还款前的应收未收正常本金
       ,''                                                                 -- 还款前的应收未收逾期本金
       ,''                                                                 -- 还款前的应收未收正常利息
       ,''                                                                 -- 还款前的应收未收逾期利息
       ,''                                                                 -- 还款前的应收未收逾期本金罚息
       ,''                                                                 -- 还款前的应收未收逾期利息罚息
       ,t1.job_cd                                                          -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')     -- 数据处理时间    
  from ${iml_schema}.evt_wyd_repay_dtl t1
  left join ${iml_schema}.agt_wyd_dubil_h t2
    on t1.dubil_id = t2.dubil_id
   and t2.etl_dt = to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'icmsf1'
 where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'icmsi1'
   and trunc(t1.repay_dt) = to_date('${batch_date}','yyyymmdd')
;
commit;

-- 第十组 唯品合作贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_dtl_ex(
       etl_dt                        -- 数据日期
       ,lp_id                        -- 法人编号
       ,dubil_id                     -- 借据编号
       ,cust_id                      -- 客户编号
       ,prod_id                      -- 产品编号
       ,repay_acct_id                -- 还款账户编号
       ,repay_flow_id                -- 还款流水编号
       ,repay_dt                     -- 还款日期
       ,intnal_carr_flg              -- 内部结转标志
       ,wrt_off_flg                  -- 核销标志
       ,adv_repay_flg                -- 提前还款标志
       ,ovdue_repay_flg              -- 逾期还款标志
       ,acru_non_acru_cd             -- 应计非应计代码
       ,repay_type_cd                -- 还款类型代码
       ,curr_cd                      -- 币种代码
       ,curr_nomal_pric_bal          -- 当前正常本金余额
       ,currt_repay_amt              -- 当期还款金额
       ,currt_repay_pric             -- 当期还款本金
       ,currt_repay_nomal_pric       -- 当期还款正常本金
       ,currt_repay_ovdue_pric       -- 当期还款逾期本金
       ,curr_repay_int               -- 当前还款利息
       ,currt_repay_nomal_int        -- 当期还款正常利息
       ,currt_repay_ovdue_int        -- 当期还款逾期利息
       ,currt_repay_pnlt             -- 当期还款罚息
       ,currt_repay_ovdue_pric_pnlt  -- 当期还款逾期本金罚息
       ,currt_repay_ovdue_int_pnlt   -- 当期还款逾期利息罚息
       ,currt_repay_fee              -- 当期还款费用
       ,currt_repay_fee_rat          -- 当期还款费率
       ,bf_repay_recvbl_uncol_nomal_pric       -- 还款前的应收未收正常本金
       ,bf_repay_recvbl_uncol_ovdue_pric       -- 还款前的应收未收逾期本金
       ,bf_repay_recvbl_uncol_nomal_int        -- 还款前的应收未收正常利息
       ,bf_repay_recvbl_uncol_ovdue_int        -- 还款前的应收未收逾期利息
       ,bf_repay_recvbl_uncol_ovdue_pric_pnlt  -- 还款前的应收未收逾期本金罚息
       ,bf_repay_recvbl_uncol_ovdue_int_pnlt   -- 还款前的应收未收逾期利息罚息
       ,job_cd                       -- 任务代码
       ,etl_timestamp                -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                 -- 数据日期
       ,t1.lp_id                                                           -- 法人编号
       ,t1.dubil_id                                                        -- 借据编号
       ,t2.cust_id                                                         -- 客户编号
       ,t1.prod_id                                                         -- 产品编号
       ,t2.repay_num_id                                                    -- 还款账户编号
       ,t1.repay_flow_num || t1.ths_tm_comp_perds                          -- 还款流水编号
       ,t1.tran_dt                                                         -- 还款日期
       ,'0'                                                                -- 内部结转标志
       ,''                                                                 -- 核销标志
       ,case when t1.callbk_type_cd in ('ER','PO') then '1' else '0' end   -- 提前还款标志
       ,case when t1.ovdue_days > 0 then '1' else '0' end                  -- 逾期还款标志
       ,''                                                                 -- 应计非应计代码
       ,t1.callbk_type_cd                                                  -- 还款类型代码
       ,'CNY'                                                              -- 币种代码
       ,nvl(t2.dubil_bal,0)                                                -- 当前正常本金余额
       ,nvl(t1.paid_tot,0)                                                 -- 当期还款金额
       ,nvl(t1.paid_pric,0)                                                -- 当期还款本金
       ,case when t1.callbk_type_cd in ('PS','NS') then  nvl(t1.paid_pric,0) end -- 当期还款正常本金
       ,case when t1.ovdue_days > 0 then nvl(t1.paid_pric,0) end           -- 当期还款逾期本金
       ,nvl(t1.paid_int,0)                                                 -- 当前还款利息
       ,case when t1.callbk_type_cd in ('PS','NS') then nvl(t1.paid_int,0) end  -- 当期还款正常利息
       ,case when t1.ovdue_days > 0 then nvl(t1.paid_int,0) end            -- 当期还款逾期利息
       ,nvl(t1.paid_pnlt,0)                                                -- 当期还款罚息
       ,''                                                                 -- 当期还款逾期本金罚息
       ,''                                                                 -- 当期还款逾期利息罚息
       ,nvl(t1.paid_other_fee,0)                                           -- 当期还款费用
       ,''                                                                 -- 当期还款费率
       ,''                                                                 -- 还款前的应收未收正常本金
       ,''                                                                 -- 还款前的应收未收逾期本金
       ,''                                                                 -- 还款前的应收未收正常利息
       ,''                                                                 -- 还款前的应收未收逾期利息
       ,''                                                                 -- 还款前的应收未收逾期本金罚息
       ,''                                                                 -- 还款前的应收未收逾期利息罚息
       ,t1.job_cd                                                          -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')     -- 数据处理时间    
  from (select t1.repay_flow_num         as repay_flow_num
		        ,t1.dubil_id             as dubil_id
                ,t1.prod_id			     as prod_id
				,t1.callbk_type_cd       as callbk_type_cd
				,t1.tran_dt              as tran_dt
				,t2.curr_cd              as curr_cd
				,t2.repay_perds          as ths_tm_comp_perds
				,t2.ovdue_days           as ovdue_days
				,t2.paid_tot             as paid_tot
				,t2.paid_pric            as paid_pric
				,t2.paid_int             as paid_int
				,t2.paid_pnlt            as paid_pnlt
				,t2.paid_comp_int        as paid_comp_int
				,t2.paid_other_fee       as paid_other_fee
				,t1.job_cd               as job_cd
				,t1.lp_id                as lp_id
           from ${iml_schema}.evt_wph_repay_flow t1
		 inner join ${iml_schema}.evt_wph_repay_dtl t2 --正常还款
		    on t1.repay_flow_num = t2.repay_flow_num
		   and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd')
		 where t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
       /* union all 
	     select  t1.repay_flow_num       as repay_flow_num
		        ,t1.dubil_id             as dubil_id
				,t1.prod_id			     as prod_id
				,t1.callbk_type_cd       as callbk_type_cd
				,t1.tran_dt              as tran_dt
				,t2.curr_cd              as curr_cd
				,t2.repay_perds          as ths_tm_comp_perds
				,t2.ovdue_days           as ovdue_days
				,t2.paid_tot             as paid_tot
				,t2.paid_pric            as paid_pric
				,t2.paid_int             as paid_int
				,t2.paid_pnlt            as paid_pnlt
				,t2.paid_comp_int        as paid_comp_int
				,t2.paid_other_fee       as paid_other_fee
				,t1.job_cd               as job_cd
				,t1.lp_id                as lp_id
           from ${iml_schema}.evt_wph_repay_flow t1
		 inner join (select repay_flow_num
		                   ,dubil_id
						   ,curr_cd
						   ,ths_tm_comp_perds as repay_perds
						   ,ovdue_days
						   ,sum(nvl(ths_tm_comp_tot_invtor,0) + nvl(ths_tm_comp_tot_fubon,0)) as paid_tot   --总额
						   ,sum(nvl(ths_tm_comp_pric_invtor,0) + nvl(ths_tm_comp_pric_fubon,0)) as paid_pric--本金发生额
						   ,sum(nvl(ths_tm_comp_int_invtor,0) + nvl(ths_tm_comp_int_fubon,0)) as paid_int  --利息发生额
						   ,sum(nvl(ths_tm_comp_pnlt_invtor,0) + nvl(ths_tm_comp_pnlt_fubon,0)) as paid_pnlt --罚息发生额
						   ,sum(nvl(ths_tm_comp_comp_int_invtor,0) + nvl(ths_tm_comp_comp_int_fubon,0)) as paid_comp_int--复息发生额
						   ,0 as paid_other_fee
		               from ${iml_schema}.evt_wph_comp_dtl
		             where etl_dt = to_date('${batch_date}', 'yyyymmdd')
					 group by repay_flow_num,dubil_id,curr_cd,ths_tm_comp_perds,ovdue_days
					) t2 --代偿还款
		    on t1.repay_flow_num = t2.repay_flow_num
		 where t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')*/
       )t1
  left join ${iml_schema}.agt_wph_dubil_info_h t2
     on t1.dubil_id = t2.dubil_id
	and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
	and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
where  1 = 1
;
commit;
 

-- 第十一组 分期乐
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_dtl_ex(
       etl_dt                        -- 数据日期
       ,lp_id                        -- 法人编号
       ,dubil_id                     -- 借据编号
       ,cust_id                      -- 客户编号
       ,prod_id                      -- 产品编号
       ,repay_acct_id                -- 还款账户编号
       ,repay_flow_id                -- 还款流水编号
       ,repay_dt                     -- 还款日期
       ,intnal_carr_flg              -- 内部结转标志
       ,wrt_off_flg                  -- 核销标志
       ,adv_repay_flg                -- 提前还款标志
       ,ovdue_repay_flg              -- 逾期还款标志
       ,acru_non_acru_cd             -- 应计非应计代码
       ,repay_type_cd                -- 还款类型代码
       ,curr_cd                      -- 币种代码
       ,curr_nomal_pric_bal          -- 当前正常本金余额
       ,currt_repay_amt              -- 当期还款金额
       ,currt_repay_pric             -- 当期还款本金
       ,currt_repay_nomal_pric       -- 当期还款正常本金
       ,currt_repay_ovdue_pric       -- 当期还款逾期本金
       ,curr_repay_int               -- 当前还款利息
       ,currt_repay_nomal_int        -- 当期还款正常利息
       ,currt_repay_ovdue_int        -- 当期还款逾期利息
       ,currt_repay_pnlt             -- 当期还款罚息
       ,currt_repay_ovdue_pric_pnlt  -- 当期还款逾期本金罚息
       ,currt_repay_ovdue_int_pnlt   -- 当期还款逾期利息罚息
       ,currt_repay_fee              -- 当期还款费用
       ,currt_repay_fee_rat          -- 当期还款费率
       ,bf_repay_recvbl_uncol_nomal_pric       -- 还款前的应收未收正常本金
       ,bf_repay_recvbl_uncol_ovdue_pric       -- 还款前的应收未收逾期本金
       ,bf_repay_recvbl_uncol_nomal_int        -- 还款前的应收未收正常利息
       ,bf_repay_recvbl_uncol_ovdue_int        -- 还款前的应收未收逾期利息
       ,bf_repay_recvbl_uncol_ovdue_pric_pnlt  -- 还款前的应收未收逾期本金罚息
       ,bf_repay_recvbl_uncol_ovdue_int_pnlt   -- 还款前的应收未收逾期利息罚息
       ,job_cd                       -- 任务代码
       ,etl_timestamp                -- 数据处理时间
)
select
        to_date('${batch_date}','yyyymmdd')                            -- 数据日期
       ,t1.lp_id                                                          -- 法人编号
       ,t1.dubil_id                                                       --借据编号
       ,t3.cust_id                                                        --客户编号
       ,t3.prod_id                                                        --产品编号
       ,t1.repay_num_id                                                   --还款账户编号
       ,t1.src_appl_flow_num ||t1.dubil_id||t1.repay_perds||t1.repay_type_cd   --还款流水编号
       ,t1.repay_dt                                                       --还款日期
       ,''                                                                --内部结转标志
       ,''                                                                --核销标志
       ,case when t1.repay_type_cd ='PO' then '1' else '0' end     --提前还款标志
       ,case when t1.repay_type_cd ='08' then '1' else '0' end     --逾期还款标志
       ,''                                                                --应计非应计代码
       ,t1.repay_type_cd                                                  --还款类型代码
       ,t1.curr_cd                                                        --币种代码
       ,sum(t3.nomal_pric_bal)                                           --当前正常本金余额
       ,sum(t1.paid_amt_tot)                                             --当期还款金额
       ,sum(t1.paid_pric)                                                --当期还款本金
       ,sum(t1.paid_pric)                                                --当前还款正常本金
       ,0                                                                 --当期还款逾期本金
       ,sum(t1.paid_int)                                                 --当期还款利息
       ,sum(t1.paid_int)                                                 --当期还款正常利息
       ,0                                                                  --当期还款逾期利息
       ,sum(t1.paid_pnlt)                                                --当期还款罚息
       ,0                                                                  --当期还款逾期本金罚息
       ,0                                                                  --当期还款逾期利息罚息
       ,0                                                                  --当期还款费用
       ,0                                                                  --当期还款费率
       ,0                                                                  --还款前的应收未收正常本金
       ,0                                                                  --还款前的应收未收逾期本金
       ,0                                                                  --还款前的应收未收正常利息
       ,0                                                                  --还款前的应收未收逾期利息
       ,0                                                                  --还款前的应收未收逾期本金罚息
       ,0                                                                  --还款前的应收未收逾期利息罚息
       ,t1.job_cd                                                          -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')     -- 数据处理时间    
  from ${iml_schema}.evt_lx_repay_dtl t1
  left join ${iml_schema}.agt_lx_dubil_info_h t3
    on t1.dubil_id = t3.dubil_id
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'icmsf1'
 where t1.job_cd = 'icmsi1'
   and trunc(t1.repay_dt) = to_date('${batch_date}','yyyymmdd')
group by t1.lp_id
           ,t1.dubil_id
           ,t3.cust_id
           ,t3.prod_id
           ,t1.repay_num_id
           ,t1.src_appl_flow_num
           ,t1.repay_perds
           ,t1.repay_dt
           ,t1.repay_type_cd
           ,t1.curr_cd
           ,t1.job_cd
;
commit;
 


-- 第十二组 富民联合贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_dtl_ex(
       etl_dt                        -- 数据日期
       ,lp_id                        -- 法人编号
       ,dubil_id                     -- 借据编号
       ,cust_id                      -- 客户编号
       ,prod_id                      -- 产品编号
       ,repay_acct_id                -- 还款账户编号
       ,repay_flow_id                -- 还款流水编号
       ,repay_dt                     -- 还款日期
       ,intnal_carr_flg              -- 内部结转标志
       ,wrt_off_flg                  -- 核销标志
       ,adv_repay_flg                -- 提前还款标志
       ,ovdue_repay_flg              -- 逾期还款标志
       ,acru_non_acru_cd             -- 应计非应计代码
       ,repay_type_cd                -- 还款类型代码
       ,curr_cd                      -- 币种代码
       ,curr_nomal_pric_bal          -- 当前正常本金余额
       ,currt_repay_amt              -- 当期还款金额
       ,currt_repay_pric             -- 当期还款本金
       ,currt_repay_nomal_pric       -- 当期还款正常本金
       ,currt_repay_ovdue_pric       -- 当期还款逾期本金
       ,curr_repay_int               -- 当前还款利息
       ,currt_repay_nomal_int        -- 当期还款正常利息
       ,currt_repay_ovdue_int        -- 当期还款逾期利息
       ,currt_repay_pnlt             -- 当期还款罚息
       ,currt_repay_ovdue_pric_pnlt  -- 当期还款逾期本金罚息
       ,currt_repay_ovdue_int_pnlt   -- 当期还款逾期利息罚息
       ,currt_repay_fee              -- 当期还款费用
       ,currt_repay_fee_rat          -- 当期还款费率
       ,bf_repay_recvbl_uncol_nomal_pric       -- 还款前的应收未收正常本金
       ,bf_repay_recvbl_uncol_ovdue_pric       -- 还款前的应收未收逾期本金
       ,bf_repay_recvbl_uncol_nomal_int        -- 还款前的应收未收正常利息
       ,bf_repay_recvbl_uncol_ovdue_int        -- 还款前的应收未收逾期利息
       ,bf_repay_recvbl_uncol_ovdue_pric_pnlt  -- 还款前的应收未收逾期本金罚息
       ,bf_repay_recvbl_uncol_ovdue_int_pnlt   -- 还款前的应收未收逾期利息罚息
       ,job_cd                       -- 任务代码
       ,etl_timestamp                -- 数据处理时间
)
select
        to_date('${batch_date}','yyyymmdd')                                        --数据日期
       ,t1.lp_id                                                                      --法人编号
       ,t1.dubil_id                                                                   --借据编号
       ,t2.cust_id                                                                    --客户编号
       ,t2.prod_id                                                                    --产品编号
       ,t1.repay_num_id                                                               --还款账户编号
       ,t1.repay_flow_num                                                             --还款流水编号
       ,t1.repay_dt                                                                   --还款日期
       ,''                                                                            --内部结转标志
       ,t2.wrt_off_flg                                                                --核销标志
       ,case when t1.repay_type_cd ='13' then '1' else '0' end                 --提前还款标志
       ,case when t1.repay_type_cd ='11' then '1' else '0' end                 --逾期还款标志
       ,t2.acru_non_acru_cd                                                           --应计非应计代码
       ,t1.repay_type_cd                                                              --还款类型代码
       ,t1.curr_cd                                                                    --币种代码
       ,t2.nomal_pric_bal                                                             --当前正常本金余额
       ,t1.repay_amt                                                                  --当期还款金额
       ,t1.paid_pric                                                                  --当期还款本金
       ,case when t1.repay_type_cd ='12' then t1.paid_pric else 0 end          --当前还款正常本金
       ,case when t1.repay_type_cd ='11' then t1.paid_pric else 0 end          --当期还款逾期本金
       ,t1.paid_int                                                                   --当期还款利息
       ,case when t1.repay_type_cd ='12' then t1.paid_int else 0 end           --当期还款正常利息
       ,case when t1.repay_type_cd ='11' then t1.paid_int else 0 end           --当期还款逾期利息
       ,t1.paid_pnlt                                                                  --当期还款罚息
       ,''                                                                            --当期还款逾期本金罚息
       ,''                                                                            --当期还款逾期利息罚息
       ,t1.paid_adv_repay_comm_fee                                                    --当期还款费用
       ,''                                                                            --当期还款费率
       ,t2.nomal_pric_bal                                                             --还款前的应收未收正常本金
       ,t2.ovdue_pric_bal                                                             --还款前的应收未收逾期本金
       ,t2.nomal_int_bal                                                              --还款前的应收未收正常利息
       ,t2.ovdue_int_bal                                                              --还款前的应收未收逾期利息
       ,''                                                                            --还款前的应收未收逾期本金罚息
       ,t2.pnlt_bal                                                                   --还款前的应收未收逾期利息罚息
       ,'icms_lh'                                                                     -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')                -- 数据处理时间    
  from ${iml_schema}.evt_lhwd_repay_dtl t1
  left join ${iml_schema}.agt_lhwd_dubil_info_h t2
    on t1.dubil_id = t2.dubil_id
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'icmsi1'
 where t1.job_cd = 'icmsf1'
   and trunc(t1.repay_dt) = to_date('${batch_date}','yyyymmdd')
;
commit;

delete from ${icl_schema}.cmm_icl_batch_jnl where etl_dt = to_date('${batch_date}', 'yyyymmdd') and tab_name = 'cmm_unite_wl_repay_dtl';
commit;
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_icl_batch_jnl(
       etl_dt          -- 数据日期
       ,tab_name       -- 表名
       ,batch_status   -- 跑批状态
       ,batch_tm       -- 跑批时间
       ,etl_timestamp  -- etl处理时间
)
select to_date('${batch_date}', 'yyyymmdd')                              -- 跑批日期
       ,'cmm_unite_wl_repay_dtl'                                         -- 表名
       ,1                                                                -- 跑批状态
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 跑批时间
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间
  from dual;
;
commit; 

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_unite_wl_repay_dtl exchange partition p_${batch_date} with table ${icl_schema}.cmm_unite_wl_repay_dtl_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_unite_wl_repay_dtl_ex purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_unite_wl_repay_dtl',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);