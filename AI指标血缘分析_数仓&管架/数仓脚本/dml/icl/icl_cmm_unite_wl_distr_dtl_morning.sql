/*
Purpose:    共性加工层-联合网贷放款明细：包括所有的花呗、借呗、网商贷、微粒贷、借呗三期、京东金融等网络贷款的放款明细信息。数据来源于综合信贷管理系统(ICMS)和中台系统(MPCS)。
Author:     Sunline/
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_unite_wl_distr_dtl
Createdate: 20210727
Logs:       20250109 谢宁 新增微业贷
            20250730 陈伟峰 新增乐分期
            20251222 陈伟峰 新增对公微业贷203050100002
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_unite_wl_distr_dtl drop partition p_${retain_day};
alter table ${icl_schema}.cmm_unite_wl_distr_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_unite_wl_distr_dtl_ex purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_unite_wl_distr_dtl_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_unite_wl_distr_dtl where 0=1;


--第一组（共二组）微业贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_distr_dtl_ex(
     etl_dt             --数据日期
     ,lp_id              --法人编号
     ,dubil_id           --借据编号
     ,cust_id            --客户编号
     ,cust_name          --客户姓名
     ,cust_cert_type_cd  --客户证件类型代码
     ,cust_cert_no       --客户证件号码
     ,crdt_id            --授信编号
     ,loan_appl_form_num --贷款申请单号
     ,distr_flow_num     --放款流水号
     ,prod_id            --产品编号
     ,loan_contr_no      --贷款合同号
     ,loan_status_cd     --贷款状态代码
     ,loan_usage         --贷款用途
     ,curr_cd            --币种代码
     ,distr_amt          --放款金额
     ,appl_dt            --申请日期
     ,distr_dt           --放款日期
     ,loan_pd_cnt        --贷款期次数
     ,repay_way_cd       --还款方式代码
     ,grace_period_days  --宽限期天数
     ,int_rat_type_cd    --利率类型代码
     ,loan_day_int_rat   --贷款日利率
     ,pric_repay_freq    --本金还款频率
     ,int_repay_freq     --利息还款频率
     ,guar_type_cd       --担保类型代码
     ,recvbl_num         --收款帐号
     ,recvbl_num_type_cd --收款帐号类型代码
     ,recvbl_num_bank_num -- 收款帐号银行行号
     ,recvbl_num_bank_name -- 收款帐号银行行名
     ,repay_num          --还款帐号
     ,repay_num_type_cd  --还款帐号类型代码
     ,intnal_carr_idf    --内部结转标识
     ,job_cd             --任务代码
     ,etl_timestamp      --数据处理时间
)
select
      to_date('${batch_date}','yyyymmdd')   --数据日期
     ,'9999'                                --法人编号
     ,t2.dubil_id                           --借据编号
     ,t2.cust_id                            --客户编号
     ,t2.cust_name                          --客户姓名
     ,'2313'                                --客户证件类型代码
     ,nvl(trim(t1.bus_lics_id),t5.csldsocicrdtid)    --客户证件号码
     ,t2.out_acct_flow_num                  --授信编号
     ,t2.out_acct_flow_num                  --贷款申请单号
     ,t2.out_acct_flow_num                  --放款流水号
     ,t2.prod_id                            --产品编号
     ,t2.cont_id                            --贷款合同号
     ,decode(t2.distr_status_cd,'01','3','02','3','03','1','04','2','-','0','0')                    --贷款状态代码**
     ,t2.loan_usage_cd                      --贷款用途
     ,t2.curr_cd                            --币种代码
     ,t2.loan_amt                           --放款金额
     ,t2.effect_dt                          --申请日期
     ,t2.effect_dt                          --放款日期
     ,t2.loan_tenor                         --贷款期次数
     ,t2.repay_way_cd                       --还款方式代码 /*3按期付息到期还本 - 4按频率付息，一次还本；4组合还款 - 10组合还款；6到期一次还本付息 - 3一次性还本付息/前收息；F分期 - 1等额本息*/
     ,t4.grace_period --宽限期天数
     ,t2.base_rat_type_cd                   --利率类型代码
     ,t2.loan_int_rat /360                  --贷款日利率
     ,t4.repay_freq_cd                      --本金还款频率
     ,t4.repay_freq_cd                      --利息还款频率
     ,decode(t4.guar_way_cd,'1','D','2','C','3','B','4','A','0401','C','0402','C','-')--担保类型代码
     ,t2.distr_acct_id                      --收款帐号
     ,''                                    --收款帐号类型代码
     ,'' -- 收款帐号银行行号
     ,'' -- 收款帐号银行行名
     ,t2.repay_num_id                       --还款帐号
     ,''                                    --还款帐号类型代码
     ,''                                    --内部结转标识
     ,'icmsf1'                              --任务代码
     ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')     --数据处理时间
from ${iml_schema}.agt_wyd_dubil_h t2
 left join ${iml_schema}.agt_wyd_out_acct_appl t1
   on t1.out_acct_flow_num = t2.out_acct_flow_num
  and t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  and t1.job_cd = 'icmsf1'
  and t1.tran_status_cd = '1' --放款成功
 /*left join ${iml_schema}.agt_wyd_tran_flow t3
   on t2.dubil_id = t3.dubil_id
  and t3.etl_dt = to_date('${batch_date}', 'yyyymmdd')*/
 left join ${iml_schema}.agt_wyd_dubil_attach_info t4
   on t2.dubil_id = t4.dubil_id
  and t4.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  and t4.job_cd = 'icmsf1'
/* left join ${iml_schema}.evt_wyd_tran_flow t5
   on t2.dubil_id = t5.dubil_id
  and t5.tran_code = '1001'
  and t5.job_cd = 'icmsi1'
  and t5.etl_dt = to_date('${batch_date}', 'yyyymmdd')*/
left join ${iol_schema}.icms_wyd_with_drawal t5
   on t1.out_acct_flow_num=t5.applseqnum
  and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where t2.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'icmsf1'
   and trunc(t2.effect_dt) = to_date('${batch_date}', 'yyyymmdd')
   and t1.prod_id in ('201020100063','203050100002') --微业贷3.0\对公微业贷
;
commit;


--第二组（共二组）分期乐
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_distr_dtl_ex(
     etl_dt              --数据日期
     ,lp_id              --法人编号
     ,dubil_id           --借据编号
     ,cust_id            --客户编号
     ,cust_name          --客户姓名
     ,cust_cert_type_cd  --客户证件类型代码
     ,cust_cert_no       --客户证件号码
     ,crdt_id            --授信编号
     ,loan_appl_form_num --贷款申请单号
     ,distr_flow_num     --放款流水号
     ,prod_id            --产品编号
     ,loan_contr_no      --贷款合同号
     ,loan_status_cd     --贷款状态代码
     ,loan_usage         --贷款用途
     ,curr_cd            --币种代码
     ,distr_amt          --放款金额
     ,appl_dt            --申请日期
     ,distr_dt           --放款日期
     ,loan_pd_cnt        --贷款期次数
     ,repay_way_cd       --还款方式代码
     ,grace_period_days  --宽限期天数
     ,int_rat_type_cd    --利率类型代码
     ,loan_day_int_rat   --贷款日利率
     ,pric_repay_freq    --本金还款频率
     ,int_repay_freq     --利息还款频率
     ,guar_type_cd       --担保类型代码
     ,recvbl_num         --收款帐号
     ,recvbl_num_type_cd --收款帐号类型代码
	 ,recvbl_num_bank_num -- 收款帐号银行行号
     ,recvbl_num_bank_name -- 收款帐号银行行名
     ,repay_num          --还款帐号
     ,repay_num_type_cd  --还款帐号类型代码
     ,intnal_carr_idf    --内部结转标识
     ,job_cd             --任务代码
     ,etl_timestamp      --数据处理时间
)
select
      to_date('${batch_date}','yyyymmdd')   --数据日期
     ,t1.lp_id                                --法人编号
     ,t1.dubil_id                                --借据编号
     ,t1.cust_id                                 --客户编号
     ,t1.cust_name                               --客户姓名
     ,t3.cert_type_cd                            --客户证件类型代码
     ,t3.cert_no                                 --客户证件号码
     ,t1.lim_appl_id                             --授信编号
     ,''                                          --贷款申请单号
     ,t1.out_acct_flow_num                       --放款流水号
     ,t1.prod_id                                 --产品编号
     ,t1.rela_cont_id                            --贷款合同号
     ,decode (t1.apv_status_cd,'Approving','3','Finished','1','Refused','2','-')     --贷款状态代码
     ,t1.loan_usage                              --贷款用途
     ,t1.curr_cd                                 --币种代码
     ,t1.distr_amt                               --放款金额
     ,t1.begin_dt                                --申请日期
     ,t1.begin_dt                                --放款日期
     ,t1.loan_tenor                              --贷款期次数
     ,t1.repay_way_cd                            --还款方式代码
     ,t2.grace_period                            --宽限期天数
     ,t2.int_rat_mode_cd                         --利率类型代码
     ,t1.year_int_rat/365                        --贷款日利率
     ,''                                         --本金还款频率
     ,''                                         --利息还款频率
     ,t2.guar_way_cd                             --担保类型代码
     ,t1.recvbl_bank_card_num                    --收款帐号
     ,'01'                                       --收款帐号类型代码
	 ,t1.recvbl_bank_card_ibank_no               --收款帐号银行行号
     ,t1.recvbl_acct_open_bank_num               --收款帐号银行行名
     ,''                                         --还款帐号
     ,''                                         --还款帐号类型代码
     ,''                                         --内部结转标识
     ,t1.job_cd                                  --任务代码
     ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')     --数据处理时间
from ${iml_schema}.agt_lx_out_acct_appl t1
  left join ${iml_schema}.agt_lx_dubil_info_h t2
    on t1.dubil_id = t2.dubil_id
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_lx_loan_cont_info_h t5
    on t1.rela_cont_id = t5.cont_id
   and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t5.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_lx_crdt_appl t3
     on t5.crdt_appl_id = t3.appl_flow_num
   and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd = 'icmsf1'
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'icmsf1'
   and t1.begin_dt= to_date('${batch_date}', 'yyyymmdd')
   and t1.apv_status_cd ='Finished'
;
commit;

delete from ${icl_schema}.cmm_icl_batch_jnl  where etl_dt = to_date('${batch_date}', 'yyyymmdd') and tab_name = 'cmm_unite_wl_distr_dtl_morning';
commit;
whenever sqlerror exit sql.sqlcode;
insert into ${icl_schema}.cmm_icl_batch_jnl(
    etl_dt	                           -- 数据日期
   ,tab_name                           -- 表名
	 ,batch_status                       -- 跑批状态
	 ,batch_tm                           -- 跑批时间
	 ,etl_timestamp                      -- etl处理时间
)
select
   to_date('${batch_date}', 'yyyymmdd')                               -- 跑批日期
   ,'cmm_unite_wl_distr_dtl_morning'
   ,1                                                                 -- 跑批状态
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- 跑批时间
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- etl处理时间
from dual;
;
commit;


-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_unite_wl_distr_dtl exchange partition p_${batch_date} with table ${icl_schema}.cmm_unite_wl_distr_dtl_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_unite_wl_distr_dtl_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_unite_wl_distr_dtl',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);