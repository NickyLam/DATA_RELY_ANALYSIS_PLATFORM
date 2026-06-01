/*
purpose:    共性加工层-电子渠道预约交易计划，包含行内电子渠道定时预约交易计划信息，数据来源手机银行TBPS，企业银行OSBS
author:     sunline
usage:      python $ETL_HOME/script/main.py 20200930 icl_cmm_elec_chn_precon_tran_plan
createdate: 20220418
logs:
            20220418 朱觉军  新增模型 
            
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_elec_chn_precon_tran_plan drop partition p_${retain_day};
alter table ${icl_schema}.cmm_elec_chn_precon_tran_plan add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop temporary table cmm_elec_chn_precon_tran_plan_ex
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_elec_chn_precon_tran_plan_ex purge;

-- 2.1 create temporary table cmm_elec_chn_precon_tran_plan_ex
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_elec_chn_precon_tran_plan_ex         
nologging                                                 
compress ${option_switch} for query high                  
as                                                        
select * from ${icl_schema}.cmm_elec_chn_precon_tran_plan where 0=1;

-- 2.2 insert into data to temporary table cmm_elec_chn_precon_tran_plan_ex

--第一组 （共四组） --企业手机银行预约转账计划			

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_elec_chn_precon_tran_plan_ex(
         etl_dt                          --数据日期
        ,lp_id                           --法人编号
        ,timing_task_id                  --定时任务编号
        ,timing_task_type_cd             --定时任务类型代码 
        ,cust_id                         --客户编号
        ,timing_task_fomult_dt           --定时任务制定日期
        ,timing_kind_cd                  --定时种类代码
        ,timing_freq_kind_cd             --定时频率种类代码
        ,timing_rule_descb               --定时规则描述
        ,timing_task_status_cd           --定时任务状态代码
        ,timing_task_start_dt            --定时任务开始日期
        ,timing_task_end_dt              --定时任务结束日期
        ,timing_task_cancel_dt           --定时任务取消日期
        ,payer_bank_no                   --付款人行号
        ,payer_acct_id                   --付款人账户编号
        ,cntpty_acct_id                  --交易对手账号
        ,cntpty_acct_name                --交易对手账户名称
        ,cntpty_acct_open_bank_num       --交易对手账户开户行号
        ,cntpty_acct_open_bank_name      --交易对手账户开户行名
        ,cntpty_acct_prov_cd             --交易对手账户省份代码
        ,cntpty_acct_city_cd             --交易对手账户城市代码
        ,cntpty_acct_org_id              --交易对手账户机构编号
        ,cntpty_acct_org_name            --交易对手账户机构名称
        ,cntpty_acct_clear_bk_num        --交易对手账户清算行号
        ,cntpty_mobile_no                --交易对手手机号码
        ,plan_exec_cnt                   --计划执行次数
        ,execed_cnt                      --已执行次数
        ,sucs_cnt                        --成功次数
        ,sucs_amt                        --成功金额
        ,fail_cnt                        --失败次数
        ,fail_amt                        --失败金额
        ,not_exec_cnt                    --未执行次数
        ,plan_src_cd                     --计划来源代码
        ,job_cd                         -- 任务代码            
        ,etl_timestamp                  -- 数据处理时间  
)                             
select 
    to_date('${batch_date}','yyyymmdd')                                               --数据日期
    ,'9999'                                                                           --法人编号
    ,t1.top_trade_flowno                                                              --定时任务编号
    ,'0'                                                                              --定时任务类型代码 /*0 预约转账； 1 自动收钱交易*/
    ,t1.top_cui_ecifno                                                                --客户编号
    ,${iml_schema}.dateformat_min(t1.top_transdate)                                   --定时任务制定日期 
    ,t1.top_timertype                                                                 --定时种类代码
    ,'O'                                                                              --定时频率种类代码 /*CD1812*/
    ,t1.top_timerrule                                                                 --定时规则描述
    ,decode(t1.top_state,'5','4','4','5','a','3','6','4','7','5','9','6',t1.top_state)--定时任务状态代码
    ,${iml_schema}.dateformat_min(t1.top_begindate)                                   --定时任务开始日期 
    ,${iml_schema}.dateformat_max(t1.top_enddate)                                     --定时任务结束日期 
    ,${iml_schema}.dateformat_max(t1.top_canceldate)                                  --定时任务取消日期 
    ,nvl(trim(t2.tod_payerdeptid),'800001')                                           --付款人行号
    ,t2.tod_payeracno                                                                 --付款人账户编号
    ,t2.tod_payeeacno                                                                 --交易对手账号
    ,t2.tod_payeeacname                                                               --交易对手账户名称
    ,case when t2.tod_transcode = 'BankInnerTransfer'
          then '313586000006' else t2.tod_payeebankid end                             --交易对手账户开户行号
    ,case when t2.tod_transcode = 'BankInnerTransfer'
          then '广东华兴银行' else t2.tod_payeebankname end                           --交易账户开户行名
    ,decode(trim(t2.TOD_PROVINCECODE),null,null,trim(t2.TOD_PROVINCECODE)||'0000')    --交易对手账户省份代码
    ,t2.tod_citycode                                                                  --交易对手账户城市代码
    ,t2.tod_bankcode                                                                  --交易对手账户机构编号
    ,t2.tod_lname                                                                     --交易对手账户机构名称
    ,t2.tod_dreccode                                                                  --交易对手账户清算行号
    ,t2.tod_payeemobile                                                               --交易对手手机号码
    ,t1.top_ordertimes                                                                --计划执行次数
    ,t1.top_exetimes                                                                  --已执行次数
    ,t1.top_suctimes                                                                  --成功次数
    ,t1.top_sucamt                                                                    --成功金额
    ,t1.top_failtimes                                                                 --失败次数
    ,t1.top_failamt                                                                   --失败金额
    ,t1.top_remaintimes                                                               --未执行次数
    ,'01'                                                                             --计划来源代码 /*01-企业手机银行预约转账计划 02-个人手机银行预约交易计划 03-个人手机银行个人资金归集计划 04-个人手机银行资金自动归集定时计划*/
    ,'tbpsf1'                                                                         -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                  -- etl处理时间戳  
from ${iol_schema}.tbps_cpr_transfer_order_plan t1		--预约转账计划表			
inner join ${iol_schema}.tbps_cpr_transfer_order_detail t2	--预约转账明细表	
on t1.top_trade_flowno = t2.tod_trade_flowno
and t2.tod_transcode in ('BankInnerTransfer','Transfer')
and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
and t2.end_dt > to_date('${batch_date}','yyyymmdd')				
where t1.top_state <> '8'
and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
and t1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


--第二组 （共四组） --个人手机银行预约交易计划			

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_elec_chn_precon_tran_plan_ex(
         etl_dt                          --数据日期
        ,lp_id                           --法人编号
        ,timing_task_id                  --定时任务编号
        ,timing_task_type_cd             --定时任务类型代码 
        ,cust_id                         --客户编号
        ,timing_task_fomult_dt           --定时任务制定日期
        ,timing_kind_cd                  --定时种类代码
        ,timing_freq_kind_cd             --定时频率种类代码
        ,timing_rule_descb               --定时规则描述
        ,timing_task_status_cd           --定时任务状态代码
        ,timing_task_start_dt            --定时任务开始日期
        ,timing_task_end_dt              --定时任务结束日期
        ,timing_task_cancel_dt           --定时任务取消日期
        ,payer_bank_no                   --付款人行号
        ,payer_acct_id                   --付款人账户编号
        ,cntpty_acct_id                  --交易对手账号
        ,cntpty_acct_name                --交易对手账户名称
        ,cntpty_acct_open_bank_num       --交易对手账户开户行号
        ,cntpty_acct_open_bank_name      --交易对手账户开户行名
        ,cntpty_acct_prov_cd             --交易对手账户省份代码
        ,cntpty_acct_city_cd             --交易对手账户城市代码
        ,cntpty_acct_org_id              --交易对手账户机构编号
        ,cntpty_acct_org_name            --交易对手账户机构名称
        ,cntpty_acct_clear_bk_num        --交易对手账户清算行号
        ,cntpty_mobile_no                --交易对手手机号码
        ,plan_exec_cnt                   --计划执行次数
        ,execed_cnt                      --已执行次数
        ,sucs_cnt                        --成功次数
        ,sucs_amt                        --成功金额
        ,fail_cnt                        --失败次数
        ,fail_amt                        --失败金额
        ,not_exec_cnt                    --未执行次数
        ,plan_src_cd                     --计划来源代码
        ,job_cd                         -- 任务代码            
        ,etl_timestamp                  -- 数据处理时间  
)                             
select 
    to_date('${batch_date}','yyyymmdd')                                            --数据日期
    ,'9999'                                                                        --法人编号
    ,t1.tts_schedule_no                                                            --定时任务编号
    ,'0'                                                                           --定时任务类型代码 
    ,t1.tts_ecifno                                                                 --客户编号
    ,${iml_schema}.dateformat_min(t1.tts_submittime)                               --定时任务制定日期
    ,t1.tts_type                                                                   --定时种类代码
    ,t1.tts_tranfreq                                                               --定时频率种类代码
    ,t1.tts_timerrule                                                              --定时规则描述
    ,t1.tts_state                                                                  --定时任务状态代码
    ,${iml_schema}.dateformat_min(t1.tts_begindate)                                --定时任务开始日期
    ,${iml_schema}.dateformat_max(t1.tts_enddate)                                  --定时任务结束日期
    ,${iml_schema}.dateformat_max(t1.tts_canceldate)                               --定时任务取消日期
    ,t2.tst_payerdeptid                                                            --付款人行号
    ,t2.tst_payaccno                                                               --付款人账户编号
    ,t2.tst_rcvaccno                                                               --交易对手账号
    ,t2.tst_rcvaccname                                                             --交易对手账户名称
    ,t2.tst_rcvbankid                                                              --交易对手账户开户行号
    ,t2.tst_rcvbankname                                                            --交易对手账户开户行名
    ,decode(trim(t2.tst_provincecode),null,null,trim(t2.tst_provincecode)||'0000') --交易对手账户省份代码
    ,t2.tst_citycode                                                               --交易对手账户城市代码
    ,t2.tst_rcvbankbranch                                                          --交易对手账户机构编号
    ,t2.tst_rcvbankbranchname                                                      --交易对手账户机构名称
    ,t2.tst_clearingnode                                                           --交易对手账户清算行号
    ,t2.tst_rcvmobile                                                              --交易对手手机号码
    ,t1.tts_plantimes                                                              --计划执行次数
    ,t1.tts_exetimes                                                               --已执行次数
    ,t1.tts_successtimes                                                           --成功次数
    ,t1.tts_successamt                                                             --成功金额
    ,t1.tts_failtimes                                                              --失败次数
    ,t1.tts_failamt                                                                --失败金额
    ,t1.tts_residuetimes                                                           --未执行次数
    ,'02'                                                                          --计划来源代码
    ,'osbsf1'                                                                      -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳 
from
${iol_schema}.osbs_tps_tran_schedule t1	 --个人预约交易计划表
inner join					
${iol_schema}.osbs_tps_schedule_transferinfo t2	--个人预约交易信息表	
on t1.tts_schedule_no = t2.tst_schedule_no
and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
and t2.end_Dt > to_date('${batch_date}','yyyymmdd')
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
and t1.end_Dt > to_date('${batch_date}','yyyymmdd')	
;
commit;

--第三组 （共四组） --个人手机银行资金归集					

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_elec_chn_precon_tran_plan_ex(
         etl_dt                          --数据日期
        ,lp_id                           --法人编号
        ,timing_task_id                  --定时任务编号
        ,timing_task_type_cd             --定时任务类型代码 
        ,cust_id                         --客户编号
        ,timing_task_fomult_dt           --定时任务制定日期
        ,timing_kind_cd                  --定时种类代码
        ,timing_freq_kind_cd             --定时频率种类代码
        ,timing_rule_descb               --定时规则描述
        ,timing_task_status_cd           --定时任务状态代码
        ,timing_task_start_dt            --定时任务开始日期
        ,timing_task_end_dt              --定时任务结束日期
        ,timing_task_cancel_dt           --定时任务取消日期
        ,payer_bank_no                   --付款人行号
        ,payer_acct_id                   --付款人账户编号
        ,cntpty_acct_id                  --交易对手账号
        ,cntpty_acct_name                --交易对手账户名称
        ,cntpty_acct_open_bank_num       --交易对手账户开户行号
        ,cntpty_acct_open_bank_name      --交易对手账户开户行名
        ,cntpty_acct_prov_cd             --交易对手账户省份代码
        ,cntpty_acct_city_cd             --交易对手账户城市代码
        ,cntpty_acct_org_id              --交易对手账户机构编号
        ,cntpty_acct_org_name            --交易对手账户机构名称
        ,cntpty_acct_clear_bk_num        --交易对手账户清算行号
        ,cntpty_mobile_no                --交易对手手机号码
        ,plan_exec_cnt                   --计划执行次数
        ,execed_cnt                      --已执行次数
        ,sucs_cnt                        --成功次数
        ,sucs_amt                        --成功金额
        ,fail_cnt                        --失败次数
        ,fail_amt                        --失败金额
        ,not_exec_cnt                    --未执行次数
        ,plan_src_cd                     --计划来源代码
        ,job_cd                         -- 任务代码            
        ,etl_timestamp                  -- 数据处理时间  
)                             
select 
    to_date('${batch_date}','yyyymmdd')                 --数据日期
    ,'9999'                                             --法人编号  
    ,t1.tgs_capticalgather_no                           --定时任务编号
    ,'1'                                                --定时任务类型代码 
    ,t1.tgs_ecifno                                      --客户编号
    ,${iml_schema}.dateformat_min(t1.tgs_submitdate)    --定时任务制定日期
    ,t1.tgs_type                                        --定时种类代码
    ,t1.tgs_tranfreq                                    --定时频率种类代码
    ,t1.tgs_periodrule                                  --定时规则描述
    ,t1.tgs_state                                       --定时任务状态代码
    ,${iml_schema}.dateformat_min(t1.tgs_begindate)     --定时任务开始日期
    ,${iml_schema}.dateformat_max(t1.tgs_enddate)       --定时任务结束日期
    ,${iml_schema}.dateformat_max(t1.tgs_canceldate)    --定时任务取消日期
    ,''                                                 --付款人行号
    ,t2.tgt_payaccno                                    --付款人账户编号
    ,t2.tgt_payaccno                                    --交易对手账号
    ,t2.tgt_payaccname                                  --交易对手账户名称
    ,t2.tgt_paybankid                                   --交易对手账户开户行号
    ,t2.tgt_paybankname                                 --交易对手账户开户行名
    ,''                                                 --交易对手账户省份代码
    ,''                                                 --交易对手账户城市代码
    ,''                                                 --交易对手账户机构编号
    ,''                                                 --交易对手账户机构名称
    ,''                                                 --交易对手账户清算行号
    ,''                                                 --交易对手手机号码
    ,t1.tgs_plantimes                                   --计划执行次数
    ,t1.tgs_exetimes                                    --已执行次数
    ,t1.tgs_successtimes                                --成功次数
    ,t1.tgs_successamt                                  --成功金额
    ,t1.tgs_failtimes                                   --失败次数
    ,t1.tgs_failamt                                     --失败金额
    ,t1.tgs_residuetimes                                --未执行次数
    ,'03'                                               --计划来源代码
    ,'osbsf1'                                           -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳  
from
${iol_schema}.osbs_tps_capticalgather_schedule t1		--个人资金归集计划表
inner join	
${iol_schema}.osbs_tps_capticalgather_template t2   --个人资金归集交易信息表		
on t1.tgs_capticalgather_no = t2.tgt_capticalgather_no
and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
and t2.end_dt > to_date('${batch_date}','yyyymmdd')				
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
and t1.end_dt > to_date('${batch_date}','yyyymmdd')	
;
commit;
---第四组 （共四组） --个人手机银行资金自动归集定时计划			

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_elec_chn_precon_tran_plan_ex(
         etl_dt                          --数据日期
        ,lp_id                           --法人编号
        ,timing_task_id                  --定时任务编号
        ,timing_task_type_cd             --定时任务类型代码 
        ,cust_id                         --客户编号
        ,timing_task_fomult_dt           --定时任务制定日期
        ,timing_kind_cd                  --定时种类代码
        ,timing_freq_kind_cd             --定时频率种类代码
        ,timing_rule_descb               --定时规则描述
        ,timing_task_status_cd           --定时任务状态代码
        ,timing_task_start_dt            --定时任务开始日期
        ,timing_task_end_dt              --定时任务结束日期
        ,timing_task_cancel_dt           --定时任务取消日期
        ,payer_bank_no                   --付款人行号
        ,payer_acct_id                   --付款人账户编号
        ,cntpty_acct_id                  --交易对手账号
        ,cntpty_acct_name                --交易对手账户名称
        ,cntpty_acct_open_bank_num       --交易对手账户开户行号
        ,cntpty_acct_open_bank_name      --交易对手账户开户行名
        ,cntpty_acct_prov_cd             --交易对手账户省份代码
        ,cntpty_acct_city_cd             --交易对手账户城市代码
        ,cntpty_acct_org_id              --交易对手账户机构编号
        ,cntpty_acct_org_name            --交易对手账户机构名称
        ,cntpty_acct_clear_bk_num        --交易对手账户清算行号
        ,cntpty_mobile_no                --交易对手手机号码
        ,plan_exec_cnt                   --计划执行次数
        ,execed_cnt                      --已执行次数
        ,sucs_cnt                        --成功次数
        ,sucs_amt                        --成功金额
        ,fail_cnt                        --失败次数
        ,fail_amt                        --失败金额
        ,not_exec_cnt                    --未执行次数
        ,plan_src_cd                     --计划来源代码
        ,job_cd                         -- 任务代码            
        ,etl_timestamp                  -- 数据处理时间  
)                             
select 
    to_date('${batch_date}','yyyymmdd')                --数据日期
    ,'9999'                                            --法人编号
    ,t1.tcr_collectno                                  --定时任务编号
    ,'1'                                               --定时任务类型代码 
    ,t1.tcr_ecifno                                     --客户编号
    ,${iml_schema}.dateformat_min(t1.tcr_transdate)    --定时任务制定日期
    ,t1.tcr_periodtype                                 --定时种类代码
    ,t1.tcr_periodfreq                                 --定时频率种类代码
    ,t1.tcr_periodrule                                 --定时规则描述
    ,t1.tcr_periodstate                                --定时任务状态代码
    ,${iml_schema}.dateformat_min(t1.tcr_begindate)    --定时任务开始日期
    ,${iml_schema}.dateformat_max(t1.tcr_enddate)      --定时任务结束日期
    ,${iml_schema}.dateformat_max(t1.tcr_canceldate)   --定时任务取消日期
    ,''                                                --付款人行号
    ,t2.tcd_payeracno                                  --付款人账户编号
    ,t2.tcd_payeracno                                  --交易对手账号
    ,t2.tcd_payeracname                                --交易对手账户名称
    ,t2.tcd_payerbankid                                --交易对手账户开户行号
    ,t2.tcd_payerbankname                              --交易对手账户开户行名
    ,''                                                --交易对手账户省份代码
    ,''                                                --交易对手账户城市代码
    ,''                                                --交易对手账户机构编号
    ,''                                                --交易对手账户机构名称
    ,''                                                --交易对手账户清算行号
    ,''                                                --交易对手手机号码
    ,t1.tcr_ordertimes                                 --计划执行次数
    ,t1.tcr_exetimes                                   --已执行次数
    ,t1.tcr_suctimes                                   --成功次数
    ,t1.tcr_sucamt                                     --成功金额
    ,t1.tcr_failtimes                                  --失败次数
    ,t1.tcr_failamt                                    --失败金额
    ,t1.tcr_remaintimes                                --未执行次数
    ,'04'                                              --计划来源代码
    ,'osbsf1'                                          -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳 
from
${iol_schema}.osbs_tps_collectsrule t1	--资金自动归集定时计划表
inner join				
${iol_schema}.osbs_tps_collectsdetail t2  --个人资金自动归集交易具体信息表		
on t1.tcr_collectno = t2.tcd_collectdelno
and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
and t2.end_dt > to_date('${batch_date}','yyyymmdd')				
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
and t1.end_Dt > to_date('${batch_date}','yyyymmdd')	
;
commit;
-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_elec_chn_precon_tran_plan exchange partition p_${batch_date} with table ${icl_schema}.cmm_elec_chn_precon_tran_plan_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_elec_chn_precon_tran_plan_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_elec_chn_precon_tran_plan',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);
