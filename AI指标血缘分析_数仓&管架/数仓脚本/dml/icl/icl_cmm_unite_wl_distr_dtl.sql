/*
Purpose:    共性加工层-联合网贷放款明细：包括所有的花呗、借呗、网商贷、微粒贷、借呗三期、京东金融等网络贷款的放款明细信息。数据来源于综合信贷管理系统(ICMS)和中台系统(MPCS)。
Author:     Sunline/
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_unite_wl_distr_dtl
Createdate: 20210727
Logs:       20220517 李森辉 1、【第一组蚂蚁借据】：调整字段【客户编号】的取数口径
                            2、【第二组蚂蚁借呗三期】：调整取数来源表和来源字段，调整字段【客户编号】的取数口径
                            3、【第三组蚂蚁花呗】：调整取数来源表和来源字段，调整字段【客户编号】的取数口径
                            4、【第五组蚂蚁网商贷】：调整取数来源表和来源字段，调整字段【客户编号】的取数口径
            20220818 李森辉 调整【还款方式代码】加工口径，联合网贷源系统不落标，C层转码落标
            20221123 温旺清 调整【放款日期 DISTR_DT】加工逻辑，调整粒度为时间戳
            20230113 陈伟峰 调整【产品编号】加工逻辑
            20230511 陈伟峰 新增第七组-综合信贷微粒贷数据
            20230925 陈伟峰 新增第八组-网商贷债权直转
            20230927 徐子豪 根据M层调整蚂蚁花呗结清数据存放分区,同步修改取值方式为 job_cd in ('myhbf1','myhbf2')
		    20241105 谢宁 增加日志表输出
		    20250109 陈伟峰 调整网商贷部分逻辑，过滤房抵贷数据
		    20250109 谢宁 新增字节小微贷
			20250109 谢宁 新增微业贷
			20250422 谢宁 字节小微贷改用借据表作为主表
			20250720 谢宁 新增唯品合作贷
            20250730 陈伟峰 新增乐分期
            20260112 陈伟峰 新增富民联合网贷
            20260114 陈伟峰 调整agt_wyd_dubil_attach_info的担保方式取值逻辑，改为直取guar_way_cd
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

--第一组（共十三组）蚂蚁借呗
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
     to_date('${batch_date}','yyyymmdd') --数据日期
     ,'9999'                  --法人编号
     ,t1.contract_no          --借据编号
     ,t2.cust_id              --客户编号
     ,t1.name                 --客户姓名
     ,t1.cert_type            --客户证件类型代码
     ,t1.cert_no              --客户证件号码
     ,t1.credit_no            --授信编号
     ,t1.apply_no             --贷款申请单号
     ,t1.fund_seq_no          --放款流水号
     ,t2.prod_id              --产品编号
     ,t1.contract_no          --贷款合同号
     ,t1.loan_status          --贷款状态代码
     ,t1.loan_use             --贷款用途
     ,t1.currency             --币种代码
     ,t1.encash_amt/100       --放款金额
     ,trunc(${iml_schema}.dateformat_min(t1.apply_date))         --申请日期
     ,to_date(t1.encash_date,'yyyy-mm-dd hh24:mi:ss')            --放款日期
     ,t1.total_terms          --贷款期次数
     ,decode (t1.repay_mode,'1','1','2','2','3','4','4','10','6','3','F','1','-')  --还款方式代码 /*3按期付息到期还本 - 4按频率付息，一次还本；4组合还款 - 10组合还款；6到期一次还本付息 - 3一次性还本付息/前收息；F分期 - 1等额本息*/
     ,t1.grace_day            --宽限期天数
     ,t1.rate_type            --利率类型代码
     ,t1.day_rate             --贷款日利率
     ,t1.prin_repay_frequency --本金还款频率
     ,t1.int_repay_frequency  --利息还款频率
     ,t1.guarantee_type       --担保类型代码
     ,t1.encash_acct_no       --收款帐号
     ,t1.encash_acct_type     --收款帐号类型代码
     ,''     -- 收款帐号银行行号
     ,''    -- 收款帐号银行行名
     ,t1.repay_acct_no        --还款帐号
     ,t1.repay_acct_type      --还款帐号类型代码
     ,'0'                     --内部结转标识
     ,'myjbi2' job_cd         --任务代码
     ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   --数据处理时间
from ${iol_schema}.icms_myjb_loan_detail t1
left join ${iml_schema}.agt_ajb_dubil t2
  on t2.dubil_id = t1.contract_no
 and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
 and t2.id_mark <> 'D'
 and t2.job_cd = 'myjbf2'
where trunc(to_timestamp(t1.encash_date,'yyyy-mm-dd hh24:mi:ss.ff6'))=to_date('${batch_date}','yyyymmdd')
  and t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;

--第二组（共十三组）蚂蚁借呗三期
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_distr_dtl_ex(
     etl_dt               -- 数据日期
     ,lp_id               -- 法人编号
     ,dubil_id            -- 借据编号
     ,cust_id             -- 客户编号
     ,cust_name           -- 客户姓名
     ,cust_cert_type_cd   -- 客户证件类型代码
     ,cust_cert_no        -- 客户证件号码
     ,crdt_id             -- 授信编号
     ,loan_appl_form_num  -- 贷款申请单号
     ,distr_flow_num      -- 放款流水号
     ,prod_id             -- 产品编号
     ,loan_contr_no       -- 贷款合同号
     ,loan_status_cd      -- 贷款状态代码
     ,loan_usage          -- 贷款用途
     ,curr_cd             -- 币种代码
     ,distr_amt           -- 放款金额
     ,appl_dt             -- 申请日期
     ,distr_dt            -- 放款日期
     ,loan_pd_cnt         -- 贷款期次数
     ,repay_way_cd        -- 还款方式代码
     ,grace_period_days   -- 宽限期天数
     ,int_rat_type_cd     -- 利率类型代码
     ,loan_day_int_rat    -- 贷款日利率
     ,pric_repay_freq     -- 本金还款频率
     ,int_repay_freq      -- 利息还款频率
     ,guar_type_cd        -- 担保类型代码
     ,recvbl_num          -- 收款帐号
     ,recvbl_num_type_cd  -- 收款帐号类型代码
     ,recvbl_num_bank_num -- 收款帐号银行行号
     ,recvbl_num_bank_name -- 收款帐号银行行名
     ,repay_num           -- 还款帐号
     ,repay_num_type_cd   -- 还款帐号类型代码
     ,intnal_carr_idf     -- 内部结转标识
     ,job_cd              -- 任务代码
     ,etl_timestamp       -- 数据处理时间
)
select
     to_date('${batch_date}','yyyymmdd')  --数据日期
     ,'9999'                              --法人编号
     ,t1.contractno                       --借据编号
     ,t2.cust_id                          --客户编号
     ,t1.name                             --客户姓名
     ,t1.certtype                         --客户证件类型代码
     ,t1.certno                           --客户证件号码
     ,t1.creditno                         --授信编号
     ,t1.applyno                          --贷款申请单号
     ,t1.fundseqno                        --放款流水号
     ,t2.prod_id                          --产品编号
     ,t1.contractno                       --贷款合同号
     ,t1.loanstatus                       --贷款状态代码
     ,t1.loanuse                          --贷款用途
     ,t1.currency                         --币种代码
     ,t1.encashamt/100                    --放款金额
     ,trunc(${iml_schema}.dateformat_min(t1.applydate))        --申请日期
     ,to_date(t1.encashdate,'yyyy-mm-dd hh24:mi:ss')           --放款日期
     ,t1.totalterms                       --贷款期次数
     ,decode (t1.repaymode,'1','1','2','2','3','4','4','10','6','3','F','1','-')  --还款方式代码 /*3按期付息到期还本 - 4按频率付息，一次还本；4组合还款 - 10组合还款；6到期一次还本付息 - 3一次性还本付息/前收息；F分期 - 1等额本息*/
     ,t1.graceday                         --宽限期天数
     ,t1.ratetype                         --利率类型代码
     ,t1.dayrate                          --贷款日利率
     ,t1.prinrepayfrequency               --本金还款频率
     ,t1.intrepayfrequency                --利息还款频率
     ,t1.guaranteetype                    --担保类型代码
     ,t1.encashacctno                     --收款帐号
     ,t1.encashaccttype                   --收款帐号类型代码
     ,'' -- 收款帐号银行行号
     ,'' -- 收款帐号银行行名
     ,t1.repayacctno                      --还款帐号
     ,t1.repayaccttype                    --还款帐号类型代码
     ,'0'                                 --内部结转标识
     ,'myjbi3' job_cd                     --任务代码
     ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')      --数据处理时间
from ${iol_schema}.icms_myjb_loan_detail3 t1
left join ${iml_schema}.agt_ajb_ped_3_dubil t2
  on t1.contractno=t2.dubil_id
 and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
 and t2.id_mark <> 'D'
 and t2.job_cd = 'myjbf3'
where trunc(to_timestamp(t1.encashdate,'yyyy-mm-dd hh24:mi:ss.ff6'))=to_date('${batch_date}','yyyymmdd')
  and t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;

--第三组（共十三组）蚂蚁花呗
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
     ,job_cd                       --任务代码
     ,etl_timestamp                --数据处理时间
)
select to_date('${batch_date}','yyyymmdd')          --数据日期
       ,'9999'                                      --法人编号
       ,t1.contractno                               --借据编号
       ,t2.cust_id                                  --客户编号
       ,t1.name                                     --客户姓名
       ,decode(t1.certtype,'1','1010','1000')       --客户证件类型代码
       ,t1.certno                                   --客户证件号码
       ,t1.creditno                                 --授信编号
       ,t1.applyno                                  --贷款申请单号
       ,t1.fundseqno                                --放款流水号
       ,t2.prod_id                                  --产品编号
       ,t1.contractno                               --贷款合同号
       ,t1.loanstatus                               --贷款状态代码
       ,t1.loanuse                                  --贷款用途
       ,t1.currency                                 --币种代码
       ,t1.encashamt/100                            --放款金额
       ,trunc(${iml_schema}.dateformat_min(t1.applydate))           --申请日期
       ,to_date(t1.encashdate,'yyyy-mm-dd hh24:mi:ss')              --放款日期
       ,t1.totalterms                               --贷款期次数
       ,decode (t1.repaymode,'1','1','2','2','3','4','4','10','6','3','F','1','-')  --还款方式代码 /*3按期付息到期还本 - 4按频率付息，一次还本；4组合还款 - 10组合还款；6到期一次还本付息 - 3一次性还本付息/前收息；F分期 - 1等额本息*/
       ,t1.graceday                                 --宽限期天数
       ,t1.ratetype   		                          --利率类型代码
       ,t1.dayrate                                  --贷款日利率
       ,t1.prinrepayfrequency                       --本金还款频率
       ,t1.intrepayfrequency                        --利息还款频率
       ,t1.guaranteetype                            --担保类型代码
       ,t1.encashacctno                             --收款帐号
       ,t1.repayaccttype                            --收款帐号类型代码
       ,'' -- 收款帐号银行行号
       ,'' -- 收款帐号银行行名
       ,t1.repayacctno                              --还款帐号
       ,t1.repayaccttype                            --还款帐号类型代码
       ,t1.internaltransfertag                      --内部结转标识
       ,'myhbi1' job_cd                             --任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')--数据处理时间
  from ${iol_schema}.icms_myhb_bill_loan_detail t1
  left join ${iml_schema}.agt_acp_dubil t2
    on t2.dubil_id = t1.contractno
   and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.id_mark <> 'D'
   and t2.job_cd in ('myhbf1','myhbf2')
 where trunc(to_timestamp(t1.encashdate,'yyyy-mm-dd hh24:mi:ss.ff6'))=to_date('${batch_date}','yyyymmdd')
   and t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;

--第四组（共十三组）京东贷
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
     ,job_cd                       --任务代码
     ,etl_timestamp                --数据处理时间
)
select
     to_date('${batch_date}','yyyymmdd')  --数据日期
     ,'9999'                              --法人编号
     ,t1.loanno                           --借据编号
     ,t1.cusid                            --客户编号
     ,t1.cusname                          --客户姓名
     ,'1000'                              --客户证件类型代码
     ,t1.certno                           --客户证件号码
     ,''                                  --授信编号
     ,''                                  --贷款申请单号
     ,t1.loanserno                        --放款流水号
     ,t1.prdcode                          --产品编号
     ,t1.contno                           --贷款合同号
     ,'1'                                 --贷款状态代码
     ,t1.loanuseway                       --贷款用途
     ,t1.currency                         --币种代码
     ,t1.loanamt/100                      --放款金额
     ,trunc(${iml_schema}.dateformat_min(t1.loanstartdt))   --申请日期
     ,to_date(t1.loanstartdt,'yyyy-mm-dd hh24:mi:ss')       --放款日期
     ,t1.loanterms                        --贷款期次数
     ,decode(t1.repaytype,'1','2','2','2','-')         --还款方式代码 落标转码：1等额本金/2分期还款 - 2等额本金
     ,t1.extenddays                       --宽限期天数
     ,t1.ratetype                         --利率类型代码
     ,t1.execrate/360                     --贷款日利率
     ,t1.repayprinhz                      --本金还款频率
     ,t1.repayinthz                       --利息还款频率
     ,t1.granttype                        --担保类型代码
     ,t1.loaninneraccount                 --收款帐号
     ,'01'                                --收款帐号类型代码
     ,'' -- 收款帐号银行行号
     ,'' -- 收款帐号银行行名
     ,t1.loanrepayaccount                 --还款帐号
     ,'01'                                --还款帐号类型代码
     ,'0'                                 --内部结转标识
     ,'jdjri1' job_cd                      --任务代码
     ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                --数据处理时间
from ${iol_schema}.icms_jdjr_acc_loan t1
where to_date(t1.loanstartdt,'yyyymmdd')=to_date('${batch_date}','yyyymmdd')
 and t1.start_dt<=to_date('${batch_date}','yyyymmdd')
 and t1.end_dt>to_date('${batch_date}','yyyymmdd');
commit;

--第五组（共十三组）网商贷
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
     ,t1.contractno                         --借据编号
     ,t2.cust_id                            --客户编号
     ,t1.mybkname                           --客户姓名
     ,decode(t1.certtype,'1','1010','1000') --客户证件类型代码
     ,t1.certno                             --客户证件号码
     ,t1.creditno                           --授信编号
     ,''                                    --贷款申请单号
     ,t1.fundseqno                          --放款流水号
     ,t2.prod_id                            --产品编号
     ,t1.contractno                         --贷款合同号
     ,t1.loanstatus                         --贷款状态代码
     ,t1.loanuse                            --贷款用途
     ,t1.currency                           --币种代码
     ,t1.encashamt/100                      --放款金额
     ,trunc(${iml_schema}.dateformat_min(t1.applydate))       --申请日期
     ,to_date(t1.encashdate,'yyyy-mm-dd hh24:mi:ss')          --放款日期
     ,t1.totalterms                         --贷款期次数
     ,decode (t1.repaymode,'1','1','2','2','3','4','4','10','6','3','F','1','-')  --还款方式代码 /*3按期付息到期还本 - 4按频率付息，一次还本；4组合还款 - 10组合还款；6到期一次还本付息 - 3一次性还本付息/前收息；F分期 - 1等额本息*/
     ,t1.graceday                           --宽限期天数
     ,t1.ratetype                           --利率类型代码
     ,t1.dayrate                            --贷款日利率
     ,t1.prinrepayfrequency                 --本金还款频率
     ,t1.intrepayfrequency                  --利息还款频率
     ,t1.guaranteetype                      --担保类型代码
     ,t1.encashacctno                       --收款帐号
     ,t1.encashaccttype                     --收款帐号类型代码
     ,'' -- 收款帐号银行行号
     ,'' -- 收款帐号银行行名
     ,t1.repayacctno                        --还款帐号
     ,t1.repayaccttype                      --还款帐号类型代码
     ,'0'                                   --内部结转标识
     ,'mybki1' job_cd                       --任务代码
     ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')     --数据处理时间
from ${iol_schema}.icms_mybk_loan_detail t1
inner join ${iml_schema}.agt_myloan_dubil t2
  on t2.dubil_id = t1.contractno
 and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
 and t2.id_mark <> 'D'
 and t2.job_cd = 'mybkf1'
where trunc(to_timestamp(t1.encashdate,'yyyy-mm-dd hh24:mi:ss.ff6'))=to_date('${batch_date}','yyyymmdd')
  and t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;

--第六组（共十三组）微粒贷
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
      to_date('${batch_date}','yyyymmdd')     --数据日期
     ,'9999'                                  --法人编号
     ,t1.loan_receipt_nbr                     --借据编号
     ,t3.cbscustno                            --客户编号
     ,t3.name                                 --客户姓名
     ,decode(t3.id_type,'I','1026','1000')    --客户证件类型代码
     ,t3.id_no                                --客户证件号码
     ,''                                      --授信编号
     ,''                                      --贷款申请单号
     ,substr(t4.batchfilename,1,10)||t4.seqno --放款流水号
     ,t6.prod_id                              --产品编号
     ,t1.loan_receipt_nbr                     --贷款合同号
     ,t1.loan_status                          --贷款状态代码
     ,'消费'                                  --贷款用途
     ,'CNY'                                   --币种代码
     ,t4.post_amt                             --放款金额
     ,trunc(${iml_schema}.dateformat_min(t1.request_time))   --申请日期
     ,to_date(t1.register_date,'yyyy-mm-dd hh24:mi:ss')      --放款日期
     ,t1.loan_init_term                       --贷款期次数
     ,'-'                                     --还款方式代码
     ,0                                       --宽限期天数
     ,''                                      --利率类型代码
     ,''                                      --贷款日利率
     ,''                                      --本金还款频率
     ,''                                      --利息还款频率
     ,''                                      --担保类型代码
     ,t1.card_no                              --收款帐号
     ,'01'                                    --收款帐号类型代码
     ,'' -- 收款帐号银行行号
     ,'' -- 收款帐号银行行名
     ,t2.dd_bank_acct_no                      --还款帐号
     ,'01'                                    --还款帐号类型代码
     ,'0'                                     --内部结转标识
     ,'mpcsf1' job_cd                         --任务代码
     ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')    --数据处理时间
from ${iol_schema}.mpcs_a0ntm_loan t1
 join ${iol_schema}.mpcs_a0ntm_account t2
   on t1.acct_no = t2.acct_no
  and t1.acct_type = t2.acct_type
  and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
left join ${iol_schema}.mpcs_a0ntm_customer t3
   on t2.cust_id = t3.cust_id
  and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
inner join ${iol_schema}.mpcs_a0nds_accounting_flow t4
  on t1.ref_nbr=t4.ref_nbr
  and t1.register_date=t4.batchdate
  and t4.db_cr_ind='D' --贷款
  and t4.bnp_group='LP' --本金
left join ${iol_schema}.mpcs_a0nwldzqinfo t5
   on t5.ref_nbr=t1.ref_nbr
  and to_date(t5.partition_date,'yyyy/mm/dd')=t4.batchdate
  left join ${iml_schema}.agt_prod_rela_h t6
    on t1.loan_id = substr(t6.agt_id,7)
   and t6.start_dt <=to_date('${batch_date}','yyyymmdd')
   and t6.end_dt >=to_date('${batch_date}','yyyymmdd')
   and t6.job_cd ='mpcsf1'
   and t6.agt_prod_rela_type_cd = '02'
where t1.register_date=to_date('${batch_date}','yyyy/mm/dd')
  and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')	;
commit;

--第七组（共十三组）微粒贷--综合信贷
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
     ,t1.lp_id           -- 法人编号
     ,t1.dubil_id        -- 借据编号
     ,t1.cust_id         -- 客户编号
     ,t3.customername    -- 客户姓名
     ,t3.certtype        -- 客户证件类型代码
     ,t3.certid          -- 客户证件号码
     ,''                 -- 授信编号
     ,''                 -- 贷款申请单号
     ,t4.tran_ref_no     -- 放款流水号
     ,t1.prod_id         -- 产品编号
     ,t1.dubil_id        -- 贷款合同号
     ,t1.loan_status_cd  -- 贷款状态代码
     ,case when t1.prod_id = '202010100008'  then  '消费'  --个人消费类贷款用途   --测试环境产品号，投产待调整 投产后产品号 202010100008
           when t1.prod_id = '202020100003' then  '经营'  --个人经营类贷款用途  --测试环境产品号，投产待调整 投产后产品号 202020100003
           else ' ' end                    -- 贷款用途
     ,'CNY'              -- 币种代码
     ,t4.enter_acct_amt  -- 放款金额
     ,t1.appl_tm         -- 申请日期
     ,t4.batch_dt        -- 放款日期
     ,t1.loan_tot_perds  -- 贷款期次数
     ,'-'                -- 还款方式代码
     ,0                  -- 宽限期天数
     ,''                 -- 利率类型代码
     ,''                 -- 贷款日利率
     ,''                 -- 本金还款频率
     ,''                 -- 利息还款频率
     ,''                 -- 担保类型代码
     ,t1.card_no         -- 收款帐号
     ,'01'               -- 收款帐号类型代码
     ,'' -- 收款帐号银行行号
     ,'' -- 收款帐号银行行名
     ,t2.apot_repay_deduct_acct_num  -- 还款帐号
     ,'01'               -- 还款帐号类型代码
     ,'0'                -- 内部结转标识
     ,t4.job_cd           --任务代码
     ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   --数据处理时间
from ${iml_schema}.evt_wld_acct_ety_tran t4
inner join ${iml_schema}.agt_wld_dubil_info_h t1
  on t1.tran_ref_no = t4.tran_ref_no 
 and t1.loan_rgst_dt = t4.batch_dt
 and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t1.job_cd ='icmsf1'
left join ${iml_schema}.agt_wld_acct_h t2
  on t1.acct_id = t2.acct_id 
 and t1.acct_type_cd = t2.acct_type_cd
 and t2.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t2.end_dt >to_date('${batch_date}', 'yyyymmdd')
 and t2.job_cd ='icmsf1'
left join ${iol_schema}.icms_customer_info_wld t3
  on t1.cust_id = t3.customerid
 and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
where t4.batch_dt= to_date('${batch_date}','yyyymmdd')
  and t4.job_cd ='icmsi1'
  and t4.debit_crdt_flg='D' --贷款
  and t4.bal_compnt_group_cd='LP'  --本金
  ;
commit;


--第八组（共十三组）网商贷
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
     ,t1.contractno                         --借据编号
     ,t2.cust_id                            --客户编号
     ,t1.name                               --客户姓名
     ,decode(t1.certtype,'1','1010','1000') --客户证件类型代码
     ,t1.certno                             --客户证件号码
     ,t1.creditno                           --授信编号
     ,''                                    --贷款申请单号
     ,t1.fundseqno                          --放款流水号
     ,t2.prod_id                            --产品编号
     ,t1.contractno                         --贷款合同号
     ,t1.loanstatus                         --贷款状态代码
     ,t1.loanuse                            --贷款用途
     ,t1.currency                           --币种代码
     ,t1.encashamt/100                      --放款金额
     ,trunc(${iml_schema}.dateformat_min(t1.applydate))       --申请日期
     ,to_date(t1.encashdate,'yyyy-mm-dd hh24:mi:ss')          --放款日期
     ,t1.totalterms                         --贷款期次数
     ,decode (t1.repaymode,'1','1','2','2','3','4','4','10','6','3','F','1','-')  --还款方式代码 /*3按期付息到期还本 - 4按频率付息，一次还本；4组合还款 - 10组合还款；6到期一次还本付息 - 3一次性还本付息/前收息；F分期 - 1等额本息*/
     ,t1.graceday                           --宽限期天数
     ,t1.ratetype                           --利率类型代码
     ,t1.dayrate                            --贷款日利率
     ,t1.prinrepayfrequency                 --本金还款频率
     ,t1.intrepayfrequency                  --利息还款频率
     ,t1.guaranteetype                      --担保类型代码
     ,t1.encashacctno                       --收款帐号
     ,t1.encashaccttype                     --收款帐号类型代码
     ,'' -- 收款帐号银行行号
     ,'' -- 收款帐号银行行名
     ,t1.repayacctno                        --还款帐号
     ,t1.repayaccttype                      --还款帐号类型代码
     ,'0'                                   --内部结转标识
     ,'mybki2'                              --任务代码
     ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')     --数据处理时间
from ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso t1
left join ${iml_schema}.agt_myloan_dubil t2
  on t2.dubil_id = t1.contractno
 and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
 and t2.id_mark <> 'D'
 and t2.job_cd = 'mybkf1'
where trunc(to_timestamp(t1.encashdate,'yyyy-mm-dd hh24:mi:ss.ff6'))=to_date('${batch_date}','yyyymmdd')
  and t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


--第九组（共十三组）字节小微贷
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
     ,t1.intnal_dubil_id                    --借据编号
     ,t1.cust_id                            --客户编号
     ,t1.cust_name                          --客户姓名
     ,t4.cert_type_cd                       --客户证件类型代码
     ,t4.cert_no                            --客户证件号码
     ,t2.lmt_cont_id                        --授信编号
     ,t1.intnal_dubil_id                    --贷款申请单号
     ,t4.appl_id                            --放款流水号
     ,t1.prod_id                            --产品编号
     ,t2.cont_id                            --贷款合同号
     ,decode(t2.cont_valid_flg,'1','1','4') --贷款状态代码
     ,'100200'                              --贷款用途
     ,t1.curr_cd                            --币种代码
     ,t1.dubil_amt                          --放款金额
     ,t1.appl_dt                            --申请日期
     ,t1.begin_dt                           --放款日期
     ,t1.loan_tot_perds                     --贷款期次数
     ,decode(t1.repay_way_cd,'01','2','02','1','03','3','04','1','-')                       --还款方式代码 /*3按期付息到期还本 - 4按频率付息，一次还本；4组合还款 - 10组合还款；6到期一次还本付息 - 3一次性还本付息/前收息；f分期 -1等额本息*/
     ,t1.grace_days                         --宽限期天数
     ,t1.int_rat_mode_cd                    --利率类型代码
     ,(t1.exec_int_rat /360)                --贷款日利率
     ,''                                    --本金还款频率
     ,''                                    --利息还款频率
     ,t1.guar_way_cd                        --担保类型代码
     ,t4.bank_card_num                      
     ,'01'                                  --收款帐号类型代码
     ,t5.distr_ibank_no                     -- 收款帐号银行行号
     ,t5.cntpty_open_acct_bank_name         -- 收款帐号银行行名
     ,t1.repay_num_id                       --还款帐号
     ,decode(t1.repay_num_type_cd,'1','01','-') --还款帐号类型代码
     ,''                                    --内部结转标识
     ,'icmsf1'                              --任务代码
     ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')     --数据处理时间
from ${iml_schema}.agt_zjdk_dubil_info_h t1
  left join ${iml_schema}.agt_zjdk_loan_cont_info_h t2
    on t1.intnal_dubil_id = t2.intnal_dubil_id
   and t2.lmt_cont_flg = '02'
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_zjdk_crdt_appl_info_h t4
    on t1.intnal_dubil_id = t4.intnal_dubil_id
   and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t4.CRDT_STATUS_CD = 'Finished'
   and t4.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_zjdk_loan_out_acct_appl_h t5
    on t1.intnal_dubil_id = t5.intnal_dubil_id
   and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t5.end_Dt > to_date('${batch_date}', 'yyyymmdd')
   and t5.distr_sucs_flg = '02' --成功
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'icmsf1'
   and trunc(t1.begin_dt) = to_date('${batch_date}', 'yyyymmdd')
;
commit;


--第十组（共十三组）微业贷
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
     ,t4.guar_way_cd                        --担保类型代码
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
;
commit;


--第十一组（共十三组）唯品合作贷
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
     ,'9999'                                --法人编号
     ,t1.dubil_id                           --借据编号
     ,t1.cust_id                            --客户编号
     ,t2.cust_name                          --客户姓名
     ,t2.cert_type_cd                       --客户证件类型代码
     ,t2.cert_no                            --客户证件号码
     ,null                                  --授信编号
     ,t1.dubil_id                           --贷款申请单号
     ,t1.out_acct_flow_num                  --放款流水号
     ,t2.prod_id                            --产品编号
     ,t2.cont_id                            --贷款合同号
     ,'1'                                   --贷款状态代码
     ,t1.loan_usage_cd                      --贷款用途
     ,t1.curr_cd                            --币种代码
     ,t2.DISTR_AMT                          --放款金额
     ,t2.distr_dt                           --申请日期
     ,t2.distr_dt                           --放款日期
     ,t1.tot_perds                          --贷款期次数
     ,t2.repay_way_cd                       --还款方式代码 /*3按期付息到期还本 - 4按频率付息，一次还本；4组合还款 - 10组合还款；6到期一次还本付息 - 3一次性还本付息/前收息；f分期 -1等额本息*/
     ,t1.grace_period_days                  --宽限期天数
     ,t2.base_rat_type_cd                   --利率类型代码*
     ,(t2.exec_int_rat /360)                --贷款日利率
     ,''                                    --本金还款频率
     ,''                                    --利息还款频率
     ,t2.main_guar_way_cd                   --担保类型代码
     ,t2.enter_id                      
     ,'01'                                  --收款帐号类型代码
	 ,'' -- 收款帐号银行行号
     ,t3.orgname                            -- 收款帐号银行行名
     ,t1.repay_num_id                       --还款帐号
     ,'-'                                   --还款帐号类型代码
     ,''                                    --内部结转标识
     ,'icmsf1'                              --任务代码
     ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')     --数据处理时间
from ${iml_schema}.agt_wph_dubil_info_h t1
  inner join ${iml_schema}.agt_wph_out_acct_appl t2
    on t1.out_acct_flow_num = t2.out_acct_flow_num
   and t2.distr_sucs_flg = '1'
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'icmsf1'
   and t2.distr_dt=to_date('${batch_date}', 'yyyymmdd')
  left join (select internalkey as dubil_id
                   ,repayaccttype as accttype
                   ,repayacctname as  acctname --入账账户名
				   ,repayacctno as acctno --入账账户号
				   ,repaychannel as orgname --入账账户机构名称
                   ,row_number() over(partition by internalkey order by inputdate desc)as rn  
             from ${iol_schema}.icms_wph_deduction_result
			 where start_dt <= to_date('${batch_date}', 'yyyymmdd')
			   and end_dt > to_date('${batch_date}', 'yyyymmdd')	 
            ) t3
   on t1.dubil_id = t3.dubil_id
  and t3.rn=1
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'icmsf1'
;
commit;



--第十二组（共十三组）分期乐
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

--第十三组（共十三组）富民联合贷
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
      to_date('${batch_date}','yyyymmdd')                                                                --数据日期
     ,t1.lp_id                                                                                              --法人编号
     ,t3.dubil_id                                                                                           --借据编号
     ,t1.cust_id                                                                                            --客户编号
     ,t1.cust_name                                                                                          --客户姓名
     ,t2.certtype                                                                                           --客户证件类型代码
     ,t2.certid                                                                                             --客户证件号码
     ,t1.partner_out_acct_flow_num                                                                          --授信编号
     ,t1.partner_ova_flow_num                                                                               --贷款申请单号
     ,t1.out_acct_flow_num                                                                                  --放款流水号
     ,t1.prod_id                                                                                            --产品编号
     ,t1.cont_id                                                                                            --贷款合同号
     ,decode(t1.apv_status_cd,'Finished','1','Approving','3','Refused','2','Reject','2','-')            --贷款状态代码
     ,t1.loan_usage_cd                                                                                      --贷款用途
     ,t1.curr_cd                                                                                            --币种代码
     ,t1.out_acct_amt                                                                                       --放款金额
     ,t1.out_acct_dt                                                                                        --申请日期
     ,t1.out_acct_dt                                                                                        --放款日期
     ,''                                                                                                    --贷款期次数
     ,t1.repay_way_cd                                                                                       --还款方式代码
     ,t1.grace_period                                                                                       --宽限期天数
     ,t1.base_rat_type_cd                                                                                   --利率类型代码
     ,t1.exec_int_rat/365                                                                                   --贷款日利率
     ,''                                                                                                    --本金还款频率
     ,''                                                                                                    --利息还款频率
     ,t1.major_guar_way_cd                                                                                  --担保类型代码
     ,t1.enter_id                                                                                           --收款帐号
     ,t1.enter_type_cd                                                                                      --收款帐号类型代码
     ,''                                                                                                    --收款帐号银行行号
     ,t1.enter_open_acct_org_name                                                                           --收款帐号银行行名
     ,t1.repay_num_id                                                                                       --还款帐号
     ,t1.repay_num_type_cd                                                                                  --还款帐号类型代码
     ,''                                                                                                    --内部结转标识
     ,'icms_lh'                                                                                             --任务代码
     ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                                       --数据处理时间
from ${iml_schema}.agt_lhwd_out_acct_appl t1
left join ${iol_schema}.icms_customer_info_lhdk t2
  on t1.cust_id = t2.customerid
 and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
left join ${iml_schema}.agt_lhwd_dubil_info_h t3
  on t1.out_acct_flow_num=t3.out_acct_flow_num
 and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t3.job_cd = 'icmsi1'
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t1.job_cd = 'icmsf1'
  and t1.out_acct_dt= to_date('${batch_date}', 'yyyymmdd')
;
commit;


delete from ${icl_schema}.cmm_icl_batch_jnl  where etl_dt = to_date('${batch_date}', 'yyyymmdd') and tab_name = 'cmm_unite_wl_distr_dtl';
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
   ,'cmm_unite_wl_distr_dtl'
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