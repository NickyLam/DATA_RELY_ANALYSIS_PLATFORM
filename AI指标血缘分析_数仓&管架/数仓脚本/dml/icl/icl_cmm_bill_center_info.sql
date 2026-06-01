/*
Purpose:    共性加工层-商业承兑汇票中心基本信息，包括电票和纸票，数据来源于票据系统
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_bill_center_info
Createdate: 20190821
Logs: 20201202 陈伟峰 M层修改ref_rgst_cter_bill_info_para算法（快照->拉链），同步修改
      20210312 周沁晖 1、新增字段【票据付息方式代码、放款日期、承兑日期、兑付日期、客户编号、客户经理编号、出票人客户编号、出票人经办人编号、出票人类型代码、承兑人类型代码、承兑机构编号、流转状态代码、库存状态代码、电票状态代码、票据处理中状态代码、小票标志、再贴现标志、数据来源代码】；
                      2、调整第一组票据中心组【票据类型代码、出票日期、到期日期、出票人名称、出票人账号、出票人开户行行号、出票人开户行名称、收款人名称、收款人账号、收款人开户行行号、收款人开户行名称、承兑人名称、承兑人账号、承兑人开户行行号、承兑人开户行名称、所属机构编号】字段逻辑；
                      3、新增第二组票据系统票据信息、第三组电子票据信息、第四组他行承兑票据信息
      20210323 陈伟峰 evt_rgst_cter_bill_ccution、evt_elec_bill_tran_flow调整算法ev_i改为ev_f
      20210408 周沁晖 第一组:调整字段【承兑人开户行名称、小票标志】
                      第二组：调整字段【出票人客户编号、小票标志、再贴现标志】
      20210821 陈伟峰 调整票据系统票据信息（银承部分）的出票人客户编号-DRAWER_CUST_ID取值逻辑，从票据系统的【网银客户签约信息表】中取
      20211107 何桐金 【iml_agt_elec_bill_info_h、iml_ref_ibank_info】增加job_cd过滤条件
      20211116 陈伟峰 新增字段【代客托收标志】
      20221025 温旺清 1、新增字段【出票人组织机构代码、出票人社会信用代码、承兑人社会信用代码】 
                      2、修改02,03,04组别【子票据区间号码】默认值-
                      3、第二组中的【票据处理中状态代码】置空处理
                      4、新增第五组和第六组
      20230104 温旺清 1、修改落标【bill_type_cd】的代码：01-> AC01,02 -> AC02
      20230714 徐子豪 1、新增字段【贴现行名称、收款人社会信用代码】
      20240222 饶雅      新增字段【贴现行机构编号】
      20240325 饶雅      新增字段【贴现行联行号】
                         调整字段【贴现行名称】加工规则，取联行号名称
      20240506  饶雅     临时表tmp_cmm_bill_center_info_01,BRH_NAME字段类型从varchar2(60)扩长到varchar2(500)
                         调整【兑付日期】加工逻辑
      20260316 陈伟峰 配合票据元数据变更，调整临时表tmp_cmm_bill_center_info_01中SIGN_ACCT_ID的字段长度
	  20260407 周文龙 修改临时表的创建规则
      

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_bill_center_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_bill_center_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_bill_center_info_ex purge;
drop table ${icl_schema}.tmp_cmm_bill_center_info_01 purge;
drop table ${icl_schema}.tmp_cmm_bill_center_info_02 purge;
drop table ${icl_schema}.tmp_cmm_bill_center_info_03 purge;
drop table ${icl_schema}.tmp_cmm_bill_center_info_04 purge;
drop table ${icl_schema}.tmp_cmm_bill_center_info_05 purge;
drop table ${icl_schema}.tmp_cmm_bill_center_info_06 purge;
drop table ${icl_schema}.tmp_cmm_bill_center_info_07 purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_bill_center_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_bill_center_info where 0=1;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_bill_center_info_02
nologging
compress ${option_switch} for query high
as
select distinct draft.bill_num
 from ${iml_schema}.ref_rgst_cter_bill_info_para draft,${iml_schema}.agt_bill_redcst_dtl d
where draft.rgst_id = d.bill_id
  and d.entry_status_cd = '03'
  and d.create_dt <= to_date('${batch_date}', 'yyyymmdd')
  and d.job_cd = 'bdmsf1'
  and d.id_mark <> 'D'
  and draft.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and draft.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and draft.job_cd = 'bdmsf1';
commit;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_bill_center_info_03
nologging
compress ${option_switch} for query high
as
select distinct draft.bill_num
 from ${iml_schema}.ref_rgst_cter_bill_info_para draft
where draft.bill_src_cd in ('SR026','SR020')
  and draft.bill_belong_org_id <> '896001'
  and draft.bill_amt <= 5000000
  and draft.bill_type_cd = 'AC01'
  and draft.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and draft.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and draft.job_cd = 'bdmsf1';
commit;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_bill_center_info_04
nologging
compress ${option_switch} for query high
as
select di1.bill_num,
       di1.role_src_cd,
       di1.bill_type_cd as draft_type1,
       ac.bill_type_cd as draft_type2,
       di1.draw_dt,
       di1.fac_val_exp_dt,
       di1.bill_belong_org_id as belong_branch_id,
       di1.drawer_name,
       di1.drawer_acct_num,
       di1.drawer_open_bank_num,
       di1.drawer_open_bank_name,
       di1.recver_name,
       di1.recver_acct_num,
       di1.recver_open_bank_num,
       di1.recver_open_bank_name,
       di1.accptor_name,
       di1.accptor_acct_num,
       di1.accptor_open_bank_num,
       di1.accptor_open_bank_name
  from (select bill_id,
               bill_num,
               role_src_cd,
               bill_type_cd,
               draw_dt,
               fac_val_exp_dt,
               bill_belong_org_id,
               drawer_name,
               drawer_acct_num,
               drawer_open_bank_num,
               drawer_open_bank_name,
               recver_name,
               recver_acct_num,
               recver_open_bank_num,
               recver_open_bank_name,
               accptor_name,
               accptor_acct_num,
               accptor_open_bank_num,
               accptor_open_bank_name,
               row_number() over(partition by bill_num order by bill_id desc) as rn
          from ${iml_schema}.agt_bill_info
         where create_dt <= to_date('${batch_date}', 'yyyymmdd')
           and job_cd = 'bdmsf1'
           and id_mark <> 'D') di1
  left join ${iml_schema}.agt_bill_acpt_dtl ad
    on di1.bill_id = ad.bill_id
   and ad.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and ad.job_cd = 'bdmsf1'
   and ad.id_mark <> 'D'
  left join ${iml_schema}.agt_bill_acpt_batch ac
    on ad.batch_id = ac.batch_id
   and ac.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and ac.job_cd = 'bdmsf1'
   and ac.id_mark <> 'D'
 where di1.rn = 1;
commit;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_bill_center_info_05
nologging
compress ${option_switch} for query high
as
select tran_dt,
       bill_id,
       rgst_id,
       row_number() over(partition by bill_id order by rgst_id desc) as rn
  from ${iml_schema}.evt_rgst_cter_bill_ccution
 where job_cd = 'bdmsf1'
   and bus_type_cd = '103'
   and bus_attr_cd = '005'
   and start_dt <= to_date('${batch_date}','yyyymmdd')
 and end_dt > to_date('${batch_date}','yyyymmdd');
commit;


whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_bill_center_info_06
as 
select trim(sys_prtcptr_bigamt_bank_name) as sys_prtcptr_bigamt_bank_name,
       trim(sys_prtcptr_bigamt_bank_no) as sys_prtcptr_bigamt_bank_no,
       party_id,
       mem_org_cd,
       row_number() over(partition by trim(sys_prtcptr_bigamt_bank_no) order by party_id desc) as rn
from ${iml_schema}.pty_cpes_mem
where create_dt <= to_date('${batch_date}','yyyymmdd')
and job_cd = 'bdmsf1'
and id_mark <> 'D';
commit;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_bill_center_info_07
nologging
compress ${option_switch} for query high
as
select d.rgst_id  as draft_id            -- 票据编号 
      ,bad.bill_num as draft_number        -- 票据号码 
      ,pay.sugst_pay_appl_dt as cash_dt   -- 结清日期
  from ${iml_schema}.agt_ba_exp_cash_appl_h pay
 inner join ${iml_schema}.agt_bill_acpt_dtl bad  
    on bad.acpt_dtl_id=pay.lt_id
   and bad.job_cd='bdmsf1'  
   and bad.create_dt <=to_date('${batch_date}','yyyymmdd') 
   and bad.id_mark< >'D'
 inner join ${iml_schema}.ref_rgst_cter_bill_info_para d  
    on d.bill_num=bad.bill_num 
   and d.bill_status_cd='S21'  
   and d.bill_ccution_status_cd='F00'
   and d.start_dt <=to_date('${batch_date}','yyyymmdd') 
   and d.end_dt >to_date('${batch_date}','yyyymmdd')
   and d.job_cd = 'bdmsf1'
 where pay.entry_status_cd='03'
   and pay.job_cd='bdmsf1' 
   and pay.start_dt <=to_date('${batch_date}','yyyymmdd') 
   and pay.end_dt >to_date('${batch_date}','yyyymmdd')
 union all
select pay.draft_id      -- 票据编号
      ,pay.draft_number  -- 票据号码
      ,${iml_schema}.dateformat_min(pay.set_date) as cash_dt     -- 结清日期 
  from ${iol_schema}.bdms_cpes_prmtpay_apply pay 
 where pay.account_status='02'    
   and pay.settle_result='R20'
   and pay.set_date <='${batch_date}';
commit;

--第一组（共六组）票据中心票据信息
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_bill_center_info_ex(
     etl_dt                                --数据日期
    ,lp_id                                 --法人编号
    ,bill_id                               --票据编号
    ,bill_num                              --票据号码
    ,bill_sub_intrv_id                     --子票据区间号码
    ,bill_med_cd                           --票据介质代码
    ,bill_type_cd                          --票据类型代码
    ,bill_pay_int_way_cd                   --票据付息方式代码
    ,draw_dt                               --出票日期
    ,exp_dt                                --到期日期
    ,distr_dt                              --放款日期
    ,acpt_dt                               --承兑日期
    ,cash_dt                               --兑付日期
    ,curr_cd                               --币种代码
    ,fac_val_amt                           --票面金额
    ,cust_id                               --客户编号
    ,cust_mgr_id                           --客户经理编号
    ,drawer_cust_id                        --出票人客户编号
    ,drawer_name                           --出票人名称
    ,drawer_acct_num                       --出票人账号
    ,drawer_open_bank_no                   --出票人开户行行号
    ,drawer_open_bank_name                 --出票人开户行名称
    ,drawer_operr_id                       --出票人经办人编号
    ,drawer_type_cd                        --出票人类型代码
    ,DRAWER_ORGNZ_CD                       --出票人组织机构代码
	  ,DRAWER_SOCI_CRDT_CD                   --出票人社会信用代码
    ,recver_name                           --收款人名称
    ,recver_acct_num                       --收款人账号
    ,recver_open_bank_no                   --收款人开户行行号
    ,recver_open_bank_name                 --收款人开户行名称
    ,recver_soci_crdt_cd                   --收款人社会信用代码
    ,pay_bank_bank_no                      --付款行行号
    ,pay_bank_name                         --付款行名称
    ,pay_org_id                            --付款机构编号
    ,pay_cfm_org_id                        --付款确认机构编号
    ,accptor_name                          --承兑人名称
    ,accptor_acct_num                      --承兑人账号
    ,accptor_open_bank_no                  --承兑人开户行行号
    ,accptor_open_bank_name                --承兑人开户行名称
    ,accptor_type_cd                       --承兑人类型代码
    ,acpt_org_id                           --承兑机构编号
    ,accptor_soci_crdt_cd                  --承兑人社会信用代码
    ,holder_org_id                         --持票人机构编号
    ,holder_org_name                       --持票人机构名称
    ,discnt_bank_org_id                    --贴现行机构编号
    ,discnt_ibank_no                       --贴现行联行号
    ,discnt_bank_name                      --贴现行名称
    ,endors_cnt                            --背书次数
    ,lock_flg                              --锁定标志
    ,loss_flg                              --挂失标志
    ,hxb_acpt_flg                          --我行承兑标志
    ,pay_cfm_flg                           --付款确认标志
    ,payoff_flg                            --结清标志
    ,recs_flg                              --追偿标志
    ,valet_coll_flg                        --代客托收标志
    ,risk_status_cd                        --风险状态代码
    ,bill_src_cd                           --票据来源代码
    ,bill_status_cd                        --票据状态代码
    ,ccution_status_cd                     --流转状态代码
    ,invtry_status_cd                      --库存状态代码
    ,ele_bill_status_cd                    --电票状态代码
    ,bill_proc_mdl_status_cd               --票据处理中状态代码
    ,belong_org_id                         --所属机构编号
    ,receipt_flg                           --小票标志
    ,redcst_flg                            --再贴现标志
    ,data_src_cd                           --数据来源代码
    ,job_cd                                --任务编码
    ,etl_timestamp                         --数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd')                               --数据日期
    ,t1.lp_id                                                         --法人编号
    ,t1.rgst_id                                                       --票据编号
    ,t1.bill_num                                                      --票据号码
    ,t1.bill_sub_intrv_id                                             --子票据区间号码
    ,t1.bill_med_cd                                                   --票据介质代码
    ,case when t1.bill_type_cd = '-' then
            (case when t6.role_src_cd <> '01' then t6.draft_type1
                  when t6.role_src_cd = '01' then nvl(replace(t6.draft_type1,'-',''), t6.draft_type2)
                  when substr(t1.bill_num, 0, 1) = '1' then 'AC01'
                  when substr(t1.bill_num, 0, 1) = '2' then 'AC02'
                  else t1.bill_type_cd
             end)
     else t1.bill_type_cd
     end                                                              --票据类型代码
    ,'0'                                                              --票据付息方式代码
    ,decode(t1.draw_dt,date'0001-01-01',t6.draw_dt,t1.draw_dt)        --出票日期
    ,decode(t1.exp_dt,date'2999-12-31',t6.fac_val_exp_dt,t1.exp_dt)   --到期日期
    ,t5.tran_dt                                                       --放款日期
    ,decode(t1.draw_dt,date'0001-01-01',t6.draw_dt,t1.draw_dt)        --承兑日期
    ,t14.cash_dt                                                      --兑付日期
    ,'CNY'                                                            --币种代码
    ,t1.bill_amt                                                      --票面金额
    ,nvl(trim(t4.cust_id),t11.cust_id)                                --客户编号
    ,t4.cust_mgr_id                                                   --客户经理编号
    ,t8.cust_no                                                       --出票人客户编号
    ,nvl(trim(t1.drawer_name),t6.drawer_name)                         --出票人名称
    ,nvl(trim(t1.drawer_acct_num),t6.drawer_acct_num)                 --出票人账号
    ,nvl(trim(t1.drawer_open_bank_no),t6.drawer_open_bank_num)        --出票人开户行行号
    ,nvl(trim(t1.drawer_open_bank_name),t6.drawer_open_bank_name)     --出票人开户行名称
    ,''                                                               --出票人经办人编号
    ,'RC01'                                                           --出票人类型代码
    ,''                                                               --出票人组织机构代码
	  ,t12.drawer_soci_crdt_cd                                          --出票人社会信用代码
    ,nvl(trim(t1.recver_name),t6.recver_name)                         --收款人名称
    ,nvl(trim(t1.recver_acct_num),t6.recver_acct_num)                 --收款人账号
    ,nvl(trim(t1.recver_open_bank_no),t6.recver_open_bank_num)        --收款人开户行行号
    ,nvl(trim(t1.recver_open_bank_name),t6.recver_open_bank_name)     --收款人开户行名称
    ,t12.recver_soci_crdt_cd                                          --收款人社会信用代码
    ,t1.pay_bank_no                                                   --付款行行号
    ,t1.pay_bank_name                                                 --付款行名称
    ,t1.pay_bank_org_cd                                               --付款机构编号
    ,t1.pay_cfm_org_cd                                                --付款确认机构编号
    ,nvl(trim(t1.accptor_name),t6.accptor_name)                                                                --承兑人名称
    ,nvl(trim(t1.accptor_acct_num),t6.accptor_acct_num)                                                        --承兑人账号
    ,nvl(trim(t1.accptor_open_bank_no),t6.accptor_open_bank_num)                                               --承兑人开户行行号
    ,nvl(trim(t1.accptor_open_bank_name),nvl(trim(t7.sys_prtcptr_bigamt_bank_name),t6.accptor_open_bank_name)) --承兑人开户行名称
    ,decode(t1.bill_type_cd, 'AC01', 'RC00', 'RC01')                    --承兑人类型代码
    ,t7.mem_org_cd                                                    --承兑机构编号
    ,t12.accptor_soci_crdt_cd                                         --承兑人社会信用代码
    ,t1.holder_org_cd                                                 --持票人机构编号
    ,t1.holder_org_name                                               --持票人机构名称
    ,t1.discnt_bk_org_cd                                              --贴现行机构编号
    ,t13.sys_prtcptr_bigamt_bank_no                                   --贴现行联行号
    ,t13.sys_prtcptr_bigamt_bank_name                                 --贴现行名称
    ,0                                                                --背书次数    ---未入仓  DPC_DRAFT_INFO.ENDORSE_TIMES 样本数据全部为0
    ,t1.lock_flg                                                      --锁定标志
    ,'0'                                                              --挂失标志    ---未入仓  DPC_DRAFT_INFO.REPORT_OF_LOSS_FLAG 样本数据全部为空
    ,t1.hxb_acpt_flg                                                  --我行承兑标志
    ,t1.pay_cfm_flg                                                   --付款确认标志
    ,t1.payoff_flg                                                    --结清标志*
    ,t1.recs_flg                                                      --追偿标志
    ,'0'                                                              --代客托收标志
    ,t1.risk_bill_status_cd                                           --风险状态代码
    ,t1.bill_src_cd                                                   --票据来源代码
    ,t1.bill_status_cd                                                --票据状态代码
    ,t1.bill_ccution_status_cd                                        --流转状态代码
    ,t1.bill_invtry_status_cd                                         --库存状态代码
    ,''                                                               --电票状态代码
    ,case when t1.bill_ccution_status_cd in 'F00' then '00'           --处理结束
          when t1.bill_ccution_status_cd in ('F01','F16') then '01'   --承兑受理中
          when t1.bill_ccution_status_cd in ('F22') then '02'         --未用退回受理中
          when t1.bill_ccution_status_cd in ('F14','F15') then '05'   --托收在途
          when t1.bill_ccution_status_cd in ('F05','F06','F07') and t4.tran_dir_cd = '02' then '06' --转卖中 F05 买断  F06 F07 首期转贴现
          when t1.bill_ccution_status_cd in ('F05','F06','F07') and t4.tran_dir_cd = '01' then '04' --买入中
          when t1.bill_ccution_status_cd in ('F08','F09') and t4.tran_dir_cd = '01' then '07' --买入反售处理中
          when t1.bill_ccution_status_cd in ('F08','F09') and t4.tran_dir_cd = '02' then '08' --卖出回购处理中
          when t1.bill_ccution_status_cd in ('F22') and t1.risk_bill_status_cd ='RS01' then '09' --挂失处理中
          when t1.bill_ccution_status_cd in ('F23') and t1.risk_bill_status_cd ='RS01' then '10' --解挂处理中
          when t1.bill_ccution_status_cd in ('F02') then '11'         --质押处理中。
          when t1.bill_ccution_status_cd in ('F03') then '12'         --解除质押处理中
          when t1.bill_ccution_status_cd in ('F13') then '13'         --保证处理中
          when t1.bill_ccution_status_cd in ('F12') then '15'         --代保管处理中
          else '' end                                                 --票据处理中状态代码
    ,nvl(trim(t1.bill_belong_org_id),t6.belong_branch_id)             --所属机构编号
    ,case when t9.bill_num is not null then '1'
          when t10.bill_num is not null then '1'
          else '0' end                                                --小票标志
    ,case when t9.bill_num is not null then '1' else '0' end          --再贴现标志
    ,'01'                                                             --数据来源代码
    ,t1.job_cd
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  --数据处理时间
  from ${iml_schema}.ref_rgst_cter_bill_info_para t1
  left join (select bill_id,
                    max(cont_id) as cont_id
               from ${iml_schema}.agt_bill_discount_dtl
              where create_dt <= to_date('${batch_date}','yyyymmdd')
                and job_cd = 'bdmsf1'
                and id_mark <> 'D'
              group by bill_id) t3
    on t1.rgst_id = t3.bill_id
  left join ${iml_schema}.agt_bill_discount_batch t4
    on t4.batch_id = t3.cont_id
   and t4.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.job_cd = 'bdmsf1'
   and t4.id_mark <> 'D'
  left join ${icl_schema}.tmp_cmm_bill_center_info_05 t5
    on t1.rgst_id = t5.bill_id
   and t5.rn = 1
  left join ${icl_schema}.tmp_cmm_bill_center_info_04 t6
    on t1.bill_num = t6.bill_num
  left join ${icl_schema}.tmp_cmm_bill_center_info_06 t7
    on t1.accptor_open_bank_no = t7.sys_prtcptr_bigamt_bank_no
   and t7.rn = 1
  left join (select cust_no,
                    id,
                    account_no,
                    row_number() over(partition by account_no order by id desc) as rn
               from ${iol_schema}.bdms_bms_cust_account_info
              where start_dt <= to_date('${batch_date}','yyyymmdd')
                and end_dt > to_date('${batch_date}','yyyymmdd')) t8
    on t1.drawer_acct_num = t8.account_no
   and t8.rn = 1
  left join ${icl_schema}.tmp_cmm_bill_center_info_02 t9
   on t1.bill_num = t9.bill_num
  and t1.bill_src_cd in ('SR020', 'SR026', 'SR005', 'SR006', 'SR007')
  left join ${icl_schema}.tmp_cmm_bill_center_info_03 t10
    on t1.bill_num = t10.bill_num
   and t1.bill_src_cd in ('SR020', 'SR026')
  left join ${iml_schema}.pty_cust_org_rela_h t11
    on t11.org_id =t4.cust_belong_org_id
   and t11.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t11.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t11.job_cd = 'bdmsf1'
  left join (select cp.bill_num,
               cp.drawer_soci_crdt_cd,
               cp.accptor_soci_crdt_cd,
               cp.recver_soci_crdt_cd,
               row_number() over(partition by bill_num order by bill_id desc) as rn
          from ${iml_schema}.agt_cpes_bill_info cp
         where trim(cp.bill_num) is not null
           and cp.start_dt <= to_date('${batch_date}','yyyymmdd')
           and cp.end_dt > to_date('${batch_date}','yyyymmdd')
           and cp.job_cd = 'bdmsf1') t12   
    on t1.bill_num = t12.bill_num
   and t12.rn =1
 left join ${icl_schema}.tmp_cmm_bill_center_info_06 t13
 on t1.discnt_bk_org_cd = t13.mem_org_cd
 and t13.rn=1
 left join ${icl_schema}.tmp_cmm_bill_center_info_07 t14
 on t1.rgst_id=t14.draft_id
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'bdmsf1'
;
commit;


--第二组（共六组）票据系统票据信息
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_bill_center_info_ex(
     etl_dt                                --数据日期
    ,lp_id                                 --法人编号
    ,bill_id                               --票据编号
    ,bill_num                              --票据号码
    ,bill_sub_intrv_id                     --子票据区间号码
    ,bill_med_cd                           --票据介质代码
    ,bill_type_cd                          --票据类型代码
    ,bill_pay_int_way_cd                   --票据付息方式代码
    ,draw_dt                               --出票日期
    ,exp_dt                                --到期日期
    ,distr_dt                              --放款日期
    ,acpt_dt                               --承兑日期
    ,cash_dt                               --兑付日期
    ,curr_cd                               --币种代码
    ,fac_val_amt                           --票面金额
    ,cust_id                               --客户编号
    ,cust_mgr_id                           --客户经理编号
    ,drawer_cust_id                        --出票人客户编号
    ,drawer_name                           --出票人名称
    ,drawer_acct_num                       --出票人账号
    ,drawer_open_bank_no                   --出票人开户行行号
    ,drawer_open_bank_name                 --出票人开户行名称
    ,drawer_operr_id                       --出票人经办人编号
    ,drawer_type_cd                        --出票人类型代码
    ,DRAWER_ORGNZ_CD                       --出票人组织机构代码
	  ,DRAWER_SOCI_CRDT_CD                   --出票人社会信用代码
    ,recver_name                           --收款人名称
    ,recver_acct_num                       --收款人账号
    ,recver_open_bank_no                   --收款人开户行行号
    ,recver_open_bank_name                 --收款人开户行名称
    ,recver_soci_crdt_cd                   --收款人社会信用代码
    ,pay_bank_bank_no                      --付款行行号
    ,pay_bank_name                         --付款行名称
    ,pay_org_id                            --付款机构编号
    ,pay_cfm_org_id                        --付款确认机构编号
    ,accptor_name                          --承兑人名称
    ,accptor_acct_num                      --承兑人账号
    ,accptor_open_bank_no                  --承兑人开户行行号
    ,accptor_open_bank_name                --承兑人开户行名称
    ,accptor_type_cd                       --承兑人类型代码
    ,acpt_org_id                           --承兑机构编号
    ,accptor_soci_crdt_cd                  --承兑人社会信用代码
    ,holder_org_id                         --持票人机构编号
    ,holder_org_name                       --持票人机构名称
    ,discnt_bank_org_id                    --贴现行机构编号
    ,discnt_ibank_no                       --贴现行联行号
    ,discnt_bank_name                      --贴现行名称
    ,endors_cnt                            --背书次数
    ,lock_flg                              --锁定标志
    ,loss_flg                              --挂失标志
    ,hxb_acpt_flg                          --我行承兑标志
    ,pay_cfm_flg                           --付款确认标志
    ,payoff_flg                            --结清标志
    ,recs_flg                              --追偿标志
    ,valet_coll_flg                        --代客托收标志
    ,risk_status_cd                        --风险状态代码
    ,bill_src_cd                           --票据来源代码
    ,bill_status_cd                        --票据状态代码
    ,ccution_status_cd                     --流转状态代码
    ,invtry_status_cd                      --库存状态代码
    ,ele_bill_status_cd                    --电票状态代码
    ,bill_proc_mdl_status_cd               --票据处理中状态代码
    ,belong_org_id                         --所属机构编号
    ,receipt_flg                           --小票标志
    ,redcst_flg                            --再贴现标志
    ,data_src_cd                           --数据来源代码
    ,job_cd                                --任务编码
    ,etl_timestamp                         --数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd')                               --数据日期
    ,t1.lp_id                                                         --法人编号
    ,t1.bill_id                                                       --票据编号
    ,t1.bill_num                                                      --票据号码
    ,'-'                                                             --子票据区间号码
    ,t1.bill_med_cd                                                   --票据介质代码
    ,t1.bill_type_cd                                                  --票据类型代码
    ,nvl(trim(t2.pay_int_way_cd),'5')                                 --票据付息方式代码
    ,t1.draw_dt                                                       --出票日期
    ,t1.fac_val_exp_dt                                                --到期日期
    ,t2.buy_dt                                                        --放款日期
    ,nvl(decode(t4.tran_dt,to_date('29991231','yyyymmdd'),to_date(null,'yyyymmdd'),to_date('00010101','yyyymmdd'),to_date(null,'yyyymmdd'),t4.tran_dt),t1.draw_dt)                                      --承兑日期
    ,t18.cash_dt                                                      --兑付日期
    ,'CNY'                                                            --币种代码
    ,t1.bill_amt                                                      --票面金额
    ,case when t1.role_src_cd = '01' then t10.party_id
          else t2.cust_id end                                         --客户编号
    ,case when t1.role_src_cd = '01' then t4.cust_mgr_id
          else t2.cust_mgr_id end                                     --客户经理编号
    ,t13.cust_id                                                      --出票人客户编号
    ,t1.drawer_name                                                   --出票人名称
    ,t1.drawer_acct_num                                               --出票人账号
    ,case when nvl(trim(t1.drawer_open_bank_num), '0') = '0' then t7.ibank_no
          else t1.drawer_open_bank_num end                            --出票人开户行行号
    ,t1.drawer_open_bank_name                                         --出票人开户行名称
    ,t4.cust_mgr_id                                                   --出票人经办人编号
    ,t1.drawer_cate_cd                                                --出票人类型代码
    ,t1.drawer_orgnz_cd                                               --出票人组织机构代码
	  ,t16.drawer_soci_crdt_cd                                          --出票人社会信用代码
    ,t1.recver_name                                                   --收款人名称
    ,t1.recver_acct_num                                               --收款人账号
    ,case when nvl(trim(t1.recver_open_bank_num), '0') = '0' then t8.ibank_no
          else t1.recver_open_bank_num end                            --收款人开户行行号
    ,t1.recver_open_bank_name                                         --收款人开户行名称
    ,t16.recver_soci_crdt_cd                                          --收款人社会信用代码
    ,t4.pay_bank_bank_no                                              --付款行行号
    ,t5.bank_fname                                                    --付款行名称
    ,t4.org_id                                                        --付款机构编号
    ,t4.org_id                                                        --付款确认机构编号
    ,t1.accptor_name                                                  --承兑人名称
    ,t1.accptor_acct_num                                              --承兑人账号
    ,case when nvl(trim(t1.accptor_open_bank_num), '0') = '0' then t9.ibank_no
          else t1.accptor_open_bank_num end                           --承兑人开户行行号
    ,t1.accptor_open_bank_name                                        --承兑人开户行名称
    ,t1.accptor_cate_cd                                               --承兑人类型代码
    ,t4.org_id                                                        --承兑机构编号
    ,t16.accptor_soci_crdt_cd                                         --承兑人社会信用代码
    ,''                                                               --持票人机构编号
    ,''                                                               --持票人机构名称
    ,t16.discnt_bk_org_cd                                             --贴现行机构编号
    ,t17.sys_prtcptr_bigamt_bank_no                                   --贴现行联行号
    ,t17.sys_prtcptr_bigamt_bank_name                                 --贴现行名称
    ,''                                                               --背书次数
    ,''                                                               --锁定标志
    ,decode(t1a.vouch_status_cd, '1', '1', '0')                       --挂失标志
    ,case when t1.bill_type_cd = 'AC01' and t1.hxb_acpt_flg is not null then '1'
          else '0' end                                                --我行承兑标志
    ,'1'                                                              --付款确认标志
    ,t3.payoff_flg                                                    --结清标志*
    ,'1'                                                              --追偿标志
    ,case when --t1.bill_status_cd = '006'                            --托收在途*
           t1.bill_status_cd = '95'                                   --纸票
           and t1.bill_med_cd = '2'                                   --纸质票据
           and trim(t15.batch_id) is not null
          then '1' else '0' end                                       --代客托收标志
    ,'-'                                                              --风险状态代码
    ,t1.role_src_cd                                                   --票据来源代码
    ,t1b.vouch_status_cd                                              --票据状态代码
    ,'-'                                                              --流转状态代码
    ,t1.bill_status_cd                                                --库存状态代码*
    ,t6.bill_recv_ps_status_cd                                        --电票状态代码
    ,''                                                               --票据处理中状态代码
    ,nvl(trim(t1.bill_belong_org_id),t4.org_id)                       --所属机构编号
    --,nvl(trim(t1.receipt_flg),0)
    --,nvl(trim(t1c.vouch_status_cd),0)
    ,case when t9a.bill_num is not null then '1'
          when t10a.bill_num is not null then '1'
          else nvl(trim(t1.receipt_flg),0) end                        --小票标志
    ,case when t9a.bill_num is not null then '1'
          else nvl(trim(t1c.vouch_status_cd),0) end                   --再贴现标志
    ,'02'                                                             --数据来源代码
    ,t1.job_cd
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  --数据处理时间
  from ${iml_schema}.agt_bill_info t1
  left join ${iml_schema}.agt_bill_discnt_batch t2
    on t1.discnt_batch_id = t2.batch_id
   and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'bdmsf1'
   and t2.id_mark <> 'D'
  left join (select bill_id,
                    max(batch_id) as batch_id,
                    max(payoff_flg) as payoff_flg
               from ${iml_schema}.agt_bill_acpt_dtl
              where create_dt <=to_date('${batch_date}', 'yyyymmdd')
                and job_cd = 'bdmsf1'
                and id_mark <> 'D'
              group by bill_id) t3
    on t1.bill_id = t3.bill_id
  left join ${iml_schema}.agt_bill_acpt_batch t4
    on t3.batch_id = t4.batch_id
   and t4.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.job_cd = 'bdmsf1'
   and t4.h_data_flg <> 'system_ht'
   and t4.id_mark <> 'D'
  left join ${iml_schema}.ref_ibank_info t5
    on t4.pay_bank_bank_no = t5.ibank_no
   and t5.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t5.job_cd = 'bdmsf1'
   and t5.id_mark <> 'D'
  left join (select bill_id,
                    curr_status_cd as bill_recv_ps_status_cd,  --bill_recv_ps_status_cd modify byxn20220617
                    bill_num,
                    drawer_acct_id,
                    row_number() over(partition by bill_num order by bill_id desc) as rn
               from ${iml_schema}.agt_elec_bill_info_h
              where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')
                and job_cd = 'bdmsf1') t6
    on t1.bill_num = t6.bill_num
   and t6.rn = 1
  left join (select ibank_no,
                    bank_fname,
                    row_number() over(partition by bank_fname order by ibank_no desc) as rn
               from ${iml_schema}.ref_ibank_info
              where create_dt <= to_date('${batch_date}','yyyymmdd')
                and job_cd = 'bdmsf1'
                and id_mark <> 'D') t7
    on t1.drawer_open_bank_name = t7.bank_fname
   and t7.rn = 1
  left join (select ibank_no,
                    bank_fname,
                    row_number() over(partition by bank_fname order by ibank_no desc) as rn
               from ${iml_schema}.ref_ibank_info
              where create_dt <= to_date('${batch_date}','yyyymmdd')
                and job_cd = 'bdmsf1'
                and id_mark <> 'D') t8
    on t1.recver_open_bank_name = t8.bank_fname
   and t8.rn = 1
  left join (select ibank_no,
                    bank_fname,
                    row_number() over(partition by bank_fname order by ibank_no desc) as rn
               from ${iml_schema}.ref_ibank_info
              where create_dt <= to_date('${batch_date}','yyyymmdd')
                and job_cd = 'bdmsf1'
                and id_mark <> 'D') t9
    on t1.accptor_open_bank_name = t9.bank_fname
   and t9.rn = 1
  left join ${iml_schema}.pty_cust t10
    on t4.drawer_cust_id = t10.cust_id
   and t10.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t10.job_cd = 'eifsf1'
   and t10.id_mark <> 'D'
  left join (select appl_id,
                    bill_id,
                    appl_dt,
                    row_number() over(partition by bill_id order by appl_id desc) as rn
               from ${iml_schema}.agt_ba_exp_cash_appl_h
              where entry_status_cd = '03'
                and start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')
                and job_cd = 'bdmsf1'
               ) t12
    on t1.bill_id = t12.bill_id
   and t12.rn = 1
  left join ${iml_schema}.agt_vouch_status_h t1a
    on t1.vouch_id = t1a.vouch_id
   and t1a.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1a.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1a.job_cd = 'bdmsf1'
   and t1a.vouch_status_type_cd = 'CD1451'
  left join ${iml_schema}.agt_vouch_status_h t1b
    on t1.vouch_id = t1b.vouch_id
   and t1b.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1b.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1b.job_cd = 'bdmsf1'
   and t1b.vouch_status_type_cd = 'CD1489'
  left join ${iml_schema}.agt_vouch_status_h t1c
    on t1.vouch_id = t1c.vouch_id
   and t1c.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1c.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1c.job_cd = 'bdmsf1'
   and t1c.vouch_status_type_cd = 'CD1674'
  left join ${icl_schema}.tmp_cmm_bill_center_info_02 t9a
    on t1.bill_num = t9a.bill_num
   and t1.role_src_cd in ('02','03')
  left join ${icl_schema}.tmp_cmm_bill_center_info_03 t10a
    on t1.bill_num = t10a.bill_num
   and t1.role_src_cd = '02'
  left join (select src_agt_id,
                    cust_id,
                    cust_name,
                    sign_acct_id,
                    row_number() over(partition by sign_acct_id order by sign_acct_id,update_dt desc) as rn
               from ${iml_schema}.agt_bill_cust_sign_info
              where create_dt <= to_date('${batch_date}', 'yyyymmdd')
                and job_cd = 'bdmsf1'
                and id_mark <> 'D') t13
         on nvl(trim(t6.drawer_acct_id),t1.drawer_acct_num) = t13.sign_acct_id
        and t13.rn = 1           
  /*left join ${iml_schema}.agt_bill_cust_sign_info t13
    on nvl(trim(t6.drawer_acct_id),t1.drawer_acct_num) = t13.sign_acct_id  
   and t13.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t13.job_cd = 'bdmsf1'
   and t13.id_mark <> 'D'*/
  left join ${iml_schema}.agt_bill_coll_dtl t14
    on t1.bill_id = t14.bill_id
   and t14.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t14.end_dt > to_date('${batch_date}','yyyymmdd')
   and t14.job_cd = 'bdmsf1'
   and t14.entry_status_cd = '03'--*
   and t14.valet_coll_flg = '1'
   and t14.id_mark <> 'D'
  left join ${iml_schema}.agt_bill_coll_batch t15
    on t14.batch_id = t15.batch_id
   and t15.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t15.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t15.job_cd = 'bdmsf1'
   and t15.valet_coll_flg = '1'
   and t15.agt_apv_status_cd in ('02','03','05')  --*
  /*left join ${iml_schema}.agt_valet_bill_coll_dtl t14 --bdms_cust_collection_details
    on t1.bill_id = t14.bill_id
   and t14.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t14.job_cd = 'bdmsf1'
   and t14.id_mark <> 'D'
   and t14.entry_status_cd ='9'
   left join ${iml_schema}.agt_valet_bill_coll_batch t15 --bdms_cust_collection_contract t15
    on t15.batch_id = t14.batch_id
   and t15.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t15.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t15.job_cd = 'bdmsf1'
   and t15.agt_apv_status_cd in('02','03','05')*/
  left join (select cp.bill_num,
               cp.drawer_soci_crdt_cd,
               cp.accptor_soci_crdt_cd,
               cp.recver_soci_crdt_cd,
               cp.discnt_bk_org_cd,
               row_number() over(partition by bill_num order by bill_id desc) as rn
          from ${iml_schema}.agt_cpes_bill_info cp
         where trim(cp.bill_num) is not null
           and cp.start_dt <= to_date('${batch_date}','yyyymmdd')
           and cp.end_dt > to_date('${batch_date}','yyyymmdd')
           and cp.job_cd = 'bdmsf1') t16
    on t1.bill_num = t16.bill_num
   and t16.rn = 1
 left join ${icl_schema}.tmp_cmm_bill_center_info_06 t17
 on t16.discnt_bk_org_cd = t17.mem_org_cd
 and t17.rn=1
 left join ${icl_schema}.tmp_cmm_bill_center_info_07 t18
 on t1.bill_id=t18.draft_id
 where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'bdmsf1'
   and t1.id_mark <> 'D'
   and t1.h_data_flg <> 'system_ht'
;
commit;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_bill_center_info_01
nologging
compress ${option_switch} for query high
as
select csi.sign_acct_id,
       csi.cust_id,
       ci.open_acct_org_id,
       ac.acc_bank_no as ibank_no,
       trim(bi.br_no) as brh_no,
       trim(bi.br_name) as brh_name,
       row_number() over(partition by csi.sign_acct_id order by csi.src_agt_id,ci.open_acct_org_id) as rn
  from ${iml_schema}.pty_cust ci
 inner join ${iml_schema}.agt_bill_cust_sign_info csi
    on csi.cust_id = ci.party_id
   and csi.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and csi.job_cd = 'bdmsf1'
   and csi.id_mark <> 'D'
  left join ${iol_schema}.bdms_bms_cust_account_info ac
    on csi.sign_acct_id= ac.account_no
   and ac.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and ac.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.bdms_bctl bi
    on trim(ac.acc_bank_no) = trim(bi.bank_no)
   and bi.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and bi.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where ci.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and ci.job_cd = 'bdmsf1'
   and ci.id_mark <> 'D';
commit;

--第三组（共六组）电子票据信息
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_bill_center_info_ex(
     etl_dt                                --数据日期
    ,lp_id                                 --法人编号
    ,bill_id                               --票据编号
    ,bill_num                              --票据号码
    ,bill_sub_intrv_id                     --子票据区间号码
    ,bill_med_cd                           --票据介质代码
    ,bill_type_cd                          --票据类型代码
    ,bill_pay_int_way_cd                   --票据付息方式代码
    ,draw_dt                               --出票日期
    ,exp_dt                                --到期日期
    ,distr_dt                              --放款日期
    ,acpt_dt                               --承兑日期
    ,cash_dt                               --兑付日期
    ,curr_cd                               --币种代码
    ,fac_val_amt                           --票面金额
    ,cust_id                               --客户编号
    ,cust_mgr_id                           --客户经理编号
    ,drawer_cust_id                        --出票人客户编号
    ,drawer_name                           --出票人名称
    ,drawer_acct_num                       --出票人账号
    ,drawer_open_bank_no                   --出票人开户行行号
    ,drawer_open_bank_name                 --出票人开户行名称
    ,drawer_operr_id                       --出票人经办人编号
    ,drawer_type_cd                        --出票人类型代码
    ,DRAWER_ORGNZ_CD                       --出票人组织机构代码
	  ,DRAWER_SOCI_CRDT_CD                   --出票人社会信用代码
    ,recver_name                           --收款人名称
    ,recver_acct_num                       --收款人账号
    ,recver_open_bank_no                   --收款人开户行行号
    ,recver_open_bank_name                 --收款人开户行名称
    ,recver_soci_crdt_cd                   --收款人社会信用代码
    ,pay_bank_bank_no                      --付款行行号
    ,pay_bank_name                         --付款行名称
    ,pay_org_id                            --付款机构编号
    ,pay_cfm_org_id                        --付款确认机构编号
    ,accptor_name                          --承兑人名称
    ,accptor_acct_num                      --承兑人账号
    ,accptor_open_bank_no                  --承兑人开户行行号
    ,accptor_open_bank_name                --承兑人开户行名称
    ,accptor_type_cd                       --承兑人类型代码
    ,acpt_org_id                           --承兑机构编号
    ,accptor_soci_crdt_cd                  --承兑人社会信用代码
    ,holder_org_id                         --持票人机构编号
    ,holder_org_name                       --持票人机构名称
    ,discnt_bank_org_id                    --贴现行机构编号
    ,discnt_ibank_no                       --贴现行联行号
    ,discnt_bank_name                      --贴现行名称
    ,endors_cnt                            --背书次数
    ,lock_flg                              --锁定标志
    ,loss_flg                              --挂失标志
    ,hxb_acpt_flg                          --我行承兑标志
    ,pay_cfm_flg                           --付款确认标志
    ,payoff_flg                            --结清标志
    ,recs_flg                              --追偿标志
    ,valet_coll_flg                        --代客托收标志
    ,risk_status_cd                        --风险状态代码
    ,bill_src_cd                           --票据来源代码
    ,bill_status_cd                        --票据状态代码
    ,ccution_status_cd                     --流转状态代码
    ,invtry_status_cd                      --库存状态代码
    ,ele_bill_status_cd                    --电票状态代码
    ,bill_proc_mdl_status_cd               --票据处理中状态代码
    ,belong_org_id                         --所属机构编号
    ,receipt_flg                           --小票标志
    ,redcst_flg                            --再贴现标志
    ,data_src_cd                           --数据来源代码
    ,job_cd                                --任务编码
    ,etl_timestamp                         --数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd')                               --数据日期
    ,t1.lp_id                                                         --法人编号
    ,t1.bill_num                                                      --票据编号
    ,t1.bill_num                                                      --票据号码
    ,'-'                                                             --子票据区间号码
    ,'1'                                                              --票据介质代码
    ,'AC02'                                                              --票据类型代码
    ,'5'                                                              --票据付息方式代码
    ,t1.draw_dt                                                       --出票日期
    ,t1.exp_dt                                                        --到期日期
    ,''                                                               --放款日期
    ,nvl(decode(t8.tran_dt,to_date('29991231','yyyymmdd'),to_date(null,'yyyymmdd'),to_date('00010101','yyyymmdd'),to_date(null,'yyyymmdd'),t8.tran_dt),t1.draw_dt)--承兑日期
    ,t11.cash_dt                                                      --兑付日期
    ,'CNY'                                                            --币种代码
    ,t1.bill_amt                                                      --票面金额
    ,t3.cust_id                                                       --客户编号
    ,''                                                               --客户经理编号
    ,t4.cust_id                                                       --出票人客户编号
    ,t1.drawer_name                                                   --出票人名称
    ,t1.drawer_acct_id                                                --出票人账号
    ,t6.ibank_no                                                      --出票人开户行行号
    ,t6.bank_fname                                                    --出票人开户行名称
    ,''                                                               --出票人经办人编号
    ,t1.drawer_cate_cd                                                --出票人类型代码
    ,''                                                               --出票人组织机构代码
	  ,t9.drawer_soci_crdt_cd                                           --出票人社会信用代码
    ,t1.recver_name                                                   --收款人名称
    ,t1.recver_acct_id                                                --收款人账号
    ,t5.ibank_no                                                      --收款人开户行行号
    ,t5.bank_fname                                                    --收款人开户行名称
    ,t9.recver_soci_crdt_cd                                           --收款人社会信用代码
    ,''                                                               --付款行行号
    ,''                                                               --付款行名称
    ,''                                                               --付款机构编号
    ,''                                                               --付款确认机构编号
    ,t1.accptor_name                                                  --承兑人名称
    ,t1.accptor_acct_id                                               --承兑人账号
    ,t1.accptor_open_bank_no                                          --承兑人开户行行号
    ,t3.brh_name                                                      --承兑人开户行名称
    ,t1.accptor_cate_cd                                               --承兑人类型代码
    ,t8.org_id                                                        --承兑机构编号
    ,t9.accptor_soci_crdt_cd                                          --承兑人社会信用代码
    ,''                                                               --持票人机构编号
    ,''                                                               --持票人机构名称
    ,t9.discnt_bk_org_cd                                              --贴现行机构编号
    ,t10.sys_prtcptr_bigamt_bank_no                                   --贴现行联行号
    ,t10.sys_prtcptr_bigamt_bank_name                                 --贴现行名称
    ,''                                                               --背书次数
    ,t1.lock_flg                                                      --锁定标志
    ,'0'                                                              --挂失标志
    ,'1'                                                              --我行承兑标志
    ,'1'                                                              --付款确认标志
    ,'0'                                                              --结清标志
    ,'1'                                                              --追偿标志
    ,case when trim(t7.bill_num) is not null 
          then '1' else '0' end                                       --代客托收标志
    ,'-'                                                              --风险状态代码
    ,'SR001'                                                          --票据来源代码
    ,t1.bill_send_ps_status_cd                                        --票据状态代码
    ,'-'                                                              --流转状态代码
    ,'-'                                                              --库存状态代码
    ,t1.bill_recv_ps_status_cd                                        --电票状态代码
    ,'001'                                                            --票据处理中状态代码
    ,t3.brh_no                                                        --所属机构编号
    ,'0'                                                              --小票标志
    ,'0'                                                              --再贴现标志
    ,'03'                                                             --数据来源代码
    ,t1.job_cd
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  --数据处理时间
  from ${iml_schema}.agt_elec_bill_info_h t1
 inner join ${iml_schema}.evt_elec_bill_tran_flow t2
    on t1.bill_num = t2.bill_num
   and t2.bill_status_cd = 'E002_02_20'
   and t2.tran_id = 'E002_02'
   and t2.etl_dt  = to_date('${batch_date}','yyyymmdd')
   and t2.job_cd  = 'bdmsf1'
   and t2.h_data_flg <> 'system_ht'
-- and t2.info_type_cd = '02'
-- and t2.bus_cd = '02'
-- and t2.tran_status_descb = '04'
-- and t2.job_cd = 'bdmsf1'
  left join (select bill_id,
                    max(batch_id) as batch_id
               from ${iml_schema}.agt_bill_acpt_dtl
              where create_dt <=to_date('${batch_date}', 'yyyymmdd')
                and h_data_flg <> 'system_ht'
                and job_cd = 'bdmsf1'
                and id_mark <> 'D'
              group by bill_id) t9
    on t1.bill_id = t9.bill_id
  left join ${iml_schema}.agt_bill_acpt_batch t8
    on t9.batch_id = t8.batch_id
   and t8.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t8.job_cd = 'bdmsf1'
   and t8.h_data_flg <> 'system_ht'
   and t8.id_mark <> 'D'
  left join ${icl_schema}.tmp_cmm_bill_center_info_01 t3
    on t1.accptor_acct_id = t3.sign_acct_id
   and t3.rn = 1 
  left join ${icl_schema}.tmp_cmm_bill_center_info_01 t4
    on t1.drawer_acct_id = t4.sign_acct_id
   and t4.rn = 1
  left join ${iml_schema}.ref_ibank_info t5
    on t1.recver_open_bank_no = t5.ibank_no
   and t5.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t5.job_cd = 'bdmsf1'
   and t5.id_mark <> 'D'
  left join ${iml_schema}.ref_ibank_info t6
    on t1.drawer_open_bank_no = t6.ibank_no
   and t6.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t6.job_cd = 'bdmsf1'
   and t6.id_mark <> 'D'
  left join (select distinct bill_num 
               from ${iml_schema}.evt_elec_bill_tran_flow  --bdms_tbl_swt_business_log
              where tran_id IN ('E020_01')
                and bill_status_cd like '%10'
                and reqer_cate_cd = 'RC01'
                and etl_dt = to_date('${batch_date}','yyyymmdd')
                ---info_type_cd = '17'   --提示付款  cd1452
                --and bus_cd = '01'         --发起方  cd1453
                --and REQER_CATE_CD = 'RC01'     --未入M层
                --and revo_flg = '00'       --撤销标志
                --and tran_status_descb = '03' --电票   --交易状态代码
                and job_cd ='bdmsf1'
                ) t7
    on t1.bill_num = t7.bill_num
  left join (select cp.bill_num,
               cp.drawer_soci_crdt_cd,
               cp.accptor_soci_crdt_cd,
               cp.recver_soci_crdt_cd,
               cp.discnt_bk_org_cd,
               row_number() over(partition by bill_num order by bill_id desc) as rn
          from ${iml_schema}.agt_cpes_bill_info cp
         where trim(cp.bill_num) is not null
           and cp.start_dt <= to_date('${batch_date}','yyyymmdd')
           and cp.end_dt > to_date('${batch_date}','yyyymmdd')
           and cp.job_cd = 'bdmsf1') t9
    on t1.bill_num = t9.bill_num
   and t9.rn = 1
 left join ${icl_schema}.tmp_cmm_bill_center_info_06 t10
 on  t9.discnt_bk_org_cd = t10.mem_org_cd
 and  t10.rn=1
  left join ${icl_schema}.tmp_cmm_bill_center_info_07 t11
 on t1.bill_id=t11.draft_id
 where t1.bill_type_cd = 'AC02'
   and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'bdmsf1'
;
commit;

--第四组（共六组）他行承兑票据信息
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_bill_center_info_ex(
    etl_dt                                --数据日期
    ,lp_id                                 --法人编号
    ,bill_id                               --票据编号
    ,bill_num                              --票据号码
    ,bill_sub_intrv_id                     --子票据区间号码
    ,bill_med_cd                           --票据介质代码
    ,bill_type_cd                          --票据类型代码
    ,bill_pay_int_way_cd                   --票据付息方式代码
    ,draw_dt                               --出票日期
    ,exp_dt                                --到期日期
    ,distr_dt                              --放款日期
    ,acpt_dt                               --承兑日期
    ,cash_dt                               --兑付日期
    ,curr_cd                               --币种代码
    ,fac_val_amt                           --票面金额
    ,cust_id                               --客户编号
    ,cust_mgr_id                           --客户经理编号
    ,drawer_cust_id                        --出票人客户编号
    ,drawer_name                           --出票人名称
    ,drawer_acct_num                       --出票人账号
    ,drawer_open_bank_no                   --出票人开户行行号
    ,drawer_open_bank_name                 --出票人开户行名称
    ,drawer_operr_id                       --出票人经办人编号
    ,drawer_type_cd                        --出票人类型代码
    ,DRAWER_ORGNZ_CD                       --出票人组织机构代码
	  ,DRAWER_SOCI_CRDT_CD                   --出票人社会信用代码
    ,recver_name                           --收款人名称
    ,recver_acct_num                       --收款人账号
    ,recver_open_bank_no                   --收款人开户行行号
    ,recver_open_bank_name                 --收款人开户行名称
    ,recver_soci_crdt_cd                   --收款人社会信用代码
    ,pay_bank_bank_no                      --付款行行号
    ,pay_bank_name                         --付款行名称
    ,pay_org_id                            --付款机构编号
    ,pay_cfm_org_id                        --付款确认机构编号
    ,accptor_name                          --承兑人名称
    ,accptor_acct_num                      --承兑人账号
    ,accptor_open_bank_no                  --承兑人开户行行号
    ,accptor_open_bank_name                --承兑人开户行名称
    ,accptor_type_cd                       --承兑人类型代码
    ,acpt_org_id                           --承兑机构编号
    ,accptor_soci_crdt_cd                  --承兑人社会信用代码
    ,holder_org_id                         --持票人机构编号
    ,holder_org_name                       --持票人机构名称
    ,discnt_bank_org_id                    --贴现行机构编号
    ,discnt_ibank_no                       --贴现行联行号
    ,discnt_bank_name                      --贴现行名称
    ,endors_cnt                            --背书次数
    ,lock_flg                              --锁定标志
    ,loss_flg                              --挂失标志
    ,hxb_acpt_flg                          --我行承兑标志
    ,pay_cfm_flg                           --付款确认标志
    ,payoff_flg                            --结清标志
    ,recs_flg                              --追偿标志
    ,valet_coll_flg                        --代客托收标志
    ,risk_status_cd                        --风险状态代码
    ,bill_src_cd                           --票据来源代码
    ,bill_status_cd                        --票据状态代码
    ,ccution_status_cd                     --流转状态代码
    ,invtry_status_cd                      --库存状态代码
    ,ele_bill_status_cd                    --电票状态代码
    ,bill_proc_mdl_status_cd               --票据处理中状态代码
    ,belong_org_id                         --所属机构编号
    ,receipt_flg                           --小票标志
    ,redcst_flg                            --再贴现标志
    ,data_src_cd                           --数据来源代码
    ,job_cd                                --任务编码
    ,etl_timestamp                         --数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd')                               --数据日期
    ,t1.lp_id                                                         --法人编号
    ,t1.bill_id                                                       --票据编号
    ,t1.bill_num                                                      --票据号码
    ,'-'                                                             --子票据区间号码
    ,'1'                                                              --票据介质代码
    ,t1.bill_type_cd                                                  --票据类型代码
    ,'5'                                                              --票据付息方式代码
    ,t1.draw_dt                                                       --出票日期
    ,t1.exp_dt                                                        --到期日期
    ,t2.appl_dt                                                       --放款日期t8.tran_dt
    ,t1.draw_dt                                                       --承兑日期
    ,t12.cash_dt                                                      --兑付日期
    ,'CNY'                                                            --币种代码
    ,t1.bill_amt                                                      --票面金额
    ,t7.cust_id                                                       --客户编号
    ,''                                                               --客户经理编号
    ,t7.cust_id                                                       --出票人客户编号
    ,t7.cust_name                                                     --出票人名称
    ,t1.drawer_acct_id                                                --出票人账号
    ,t6.ibank_no                                                      --出票人开户行行号
    ,t6.bank_fname                                                    --出票人开户行名称
    ,''                                                               --出票人经办人编号
    ,t1.drawer_cate_cd                                                --出票人类型代码
    ,''                                                               --出票人组织机构代码
	  ,t10.drawer_soci_crdt_cd                                          --出票人社会信用代码
    ,t1.recver_name                                                   --收款人名称
    ,t1.recver_acct_id                                                --收款人账号
    ,t5.ibank_no                                                      --收款人开户行行号
    ,t5.bank_fname                                                    --收款人开户行名称
    ,t10.recver_soci_crdt_cd                                          --收款人社会信用代码
    ,''                                                               --付款行行号
    ,''                                                               --付款行名称
    ,''                                                               --付款机构编号
    ,''                                                               --付款确认机构编号
    ,t1.accptor_name                                                  --承兑人名称
    ,t1.accptor_acct_id                                               --承兑人账号
    ,t3.ibank_no                                                      --承兑人开户行行号
    ,t3.bank_fname                                                    --承兑人开户行名称
    ,t1.accptor_cate_cd                                               --承兑人类型代码
    ,t4.br_no                                                         --承兑机构编号
    ,t10.accptor_soci_crdt_cd                                         --承兑人社会信用代码
    ,''                                                               --持票人机构编号
    ,''                                                               --持票人机构名称
    ,t10.discnt_bk_org_cd                                             --贴现行机构编号
    ,t11.sys_prtcptr_bigamt_bank_no                                   --贴现行联行号
    ,t11.sys_prtcptr_bigamt_bank_name                                 --贴现行名称
    ,''                                                               --背书次数
    ,t1.lock_flg                                                      --锁定标志
    ,'0'                                                              --挂失标志
    ,'1'                                                              --我行承兑标志
    ,'1'                                                              --付款确认标志
    ,'0'                                                              --结清标志
    ,'1'                                                              --追偿标志
    ,case when trim(t9.bill_num) is not null 
          then '1' else '0' end                                       --代客托收标志
    ,'-'                                                              --风险状态代码
    ,'-'                                                              --票据来源代码
    ,t1.bill_send_ps_status_cd                                        --票据状态代码
    ,'-'                                                              --流转状态代码
    ,'-'                                                              --库存状态代码
    ,'020006'                                                         --电票状态代码
    ,case t1.bill_send_ps_status_cd when '020001' then '002'
     else '001' end                                                   --票据处理中状态代码
    ,t4.br_no                                                         --所属机构编号
    ,'0'                                                              --小票标志
    ,'0'                                                              --再贴现标志
    ,'04'                                                             --数据来源代码
    ,t1.job_cd
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  --数据处理时间
  from ${iml_schema}.agt_elec_bill_info_h t1
 inner join ${iml_schema}.evt_elec_bill_tran_flow t2
    on t1.bill_num = t2.bill_num
   and t2.bill_status_cd = 'E002_01_20' --提示承兑申请
   and t2.tran_id = 'E002_01'
   and t2.etl_dt  = to_date('${batch_date}','yyyymmdd')
   and t2.job_cd  = 'bdmsf1'
   and t2.h_data_flg <> 'system_ht'
   --and t2.info_type_cd = '02'
   --and t2.bus_cd = '01'
   --and t2.tran_status_descb = '05'
   --and t2.job_cd = 'bdmsf1'
 inner join ${iml_schema}.ref_ibank_info t3
    on t1.accptor_open_bank_no = t3.ibank_no
   and t3.job_cd='bdmsf1'
   and not exists (select 1 from ${iol_schema}.bdms_bctl bi
                           where t3.ibank_no = bi.bank_no
                             and bi.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                             and bi.end_dt > to_date('${batch_date}', 'yyyymmdd'))
 inner join (select b.id,
                    b.bank_no,
                    a.ibank_no,
                    b.br_no,
                    row_number() over(partition by b.bank_no order by b.id asc) as rn
               from ${iml_schema}.ref_ibank_info a
               left join ${iol_schema}.bdms_bctl b
                 on a.ibank_no = b.bank_no
                and b.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and b.end_dt > to_date('${batch_date}', 'yyyymmdd')
              where a.create_dt <= to_date('${batch_date}', 'yyyymmdd')
                and a.id_mark <> 'D'
                and a.job_cd = 'bdmsf1') t4
    on t1.drawer_open_bank_no = t4.bank_no
   and t4.rn = 1
  left join ${iml_schema}.ref_ibank_info t5
    on t1.recver_open_bank_no = t5.ibank_no
   and t5.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t5.job_cd = 'bdmsf1'
   and t5.id_mark <> 'D'
  left join ${iml_schema}.ref_ibank_info t6
    on t1.drawer_open_bank_no = t6.ibank_no
   and t6.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t6.job_cd = 'bdmsf1'
   and t6.id_mark <> 'D'
 inner join (select src_agt_id,
                    cust_id,
                    cust_name,
                    sign_acct_id,
                    row_number() over(partition by sign_acct_id order by src_agt_id asc) as rn
               from ${iml_schema}.agt_bill_cust_sign_info
              where create_dt <= to_date('${batch_date}', 'yyyymmdd')
                and job_cd = 'bdmsf1'
                and id_mark <> 'D'
               ) t7
    on t1.drawer_acct_id = t7.sign_acct_id
   and t7.rn = 1
  /*left join ${iml_schema}.evt_elec_bill_tran_flow t8
    on t1.bill_num = t8.bill_num
   and t8.info_type_cd = '02'
   --and t8.bus_cd = '01'
   and t8.tran_status_descb = '05'
   --and t8.revo_flg = '00'
   and t8.job_cd = 'bdmsf1'*/
  left join (select distinct bill_num 
               from ${iml_schema}.evt_elec_bill_tran_flow  --bdms_tbl_swt_business_log
              where tran_id in ('E020_01', 'E021_01') --E020_01提示付款申请,E021_01逾期提示付款申请
                and bill_status_cd like '%20' --处理完成
                and reqer_cate_cd = 'RC01' --公司
                and etl_dt = to_date('${batch_date}','yyyymmdd')
                --info_type_cd = '17'   --提示付款  cd1452
                --and bus_cd = '01'         --发起方  cd1453
                --and REQER_CATE_CD = 'RC01'      --未入M层
                --and revo_flg = '00'       --撤销标志
                --and tran_status_descb = '03' --电票   --交易状态代码
                and job_cd = 'bdmsf1'
                ) T9
    on t1.bill_num = t9.bill_num
  left join (select cp.bill_num,
               cp.drawer_soci_crdt_cd,
               cp.accptor_soci_crdt_cd,
               cp.recver_soci_crdt_cd,
               cp.discnt_bk_org_cd,
               row_number() over(partition by bill_num order by bill_id desc) as rn
          from ${iml_schema}.agt_cpes_bill_info cp
         where trim(cp.bill_num) is not null
           and cp.start_dt <= to_date('${batch_date}','yyyymmdd')
           and cp.end_dt > to_date('${batch_date}','yyyymmdd')
           and cp.job_cd = 'bdmsf1') t10
    on t1.bill_num = t10.bill_num
   and t10.rn = 1
  left join ${icl_schema}.tmp_cmm_bill_center_info_06 t11
  on  t10.discnt_bk_org_cd = t11.mem_org_cd
  and  t11.rn=1   
  left join ${icl_schema}.tmp_cmm_bill_center_info_07 t12
  on t1.bill_id=t12.draft_id
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd='bdmsf1'
;
commit;

--第五组（共六组）票交所商票电子票据商票代开信息
 whenever sqlerror exit sql.sqlcode; 
insert /*+ append */ into ${icl_schema}.cmm_bill_center_info_ex(
    etl_dt                                --数据日期
    ,lp_id                                 --法人编号
    ,bill_id                               --票据编号
    ,bill_num                              --票据号码
    ,bill_sub_intrv_id                     --子票据区间号码
    ,bill_med_cd                           --票据介质代码
    ,bill_type_cd                          --票据类型代码
    ,bill_pay_int_way_cd                   --票据付息方式代码
    ,draw_dt                               --出票日期
    ,exp_dt                                --到期日期
    ,distr_dt                              --放款日期
    ,acpt_dt                               --承兑日期
    ,cash_dt                               --兑付日期
    ,curr_cd                               --币种代码
    ,fac_val_amt                           --票面金额
    ,cust_id                               --客户编号
    ,cust_mgr_id                           --客户经理编号
    ,drawer_cust_id                        --出票人客户编号
    ,drawer_name                           --出票人名称
    ,drawer_acct_num                       --出票人账号
    ,drawer_open_bank_no                   --出票人开户行行号
    ,drawer_open_bank_name                 --出票人开户行名称
    ,drawer_operr_id                       --出票人经办人编号
    ,drawer_type_cd                        --出票人类型代码
    ,DRAWER_ORGNZ_CD                       --出票人组织机构代码
	  ,DRAWER_SOCI_CRDT_CD                   --出票人社会信用代码
    ,recver_name                           --收款人名称
    ,recver_acct_num                       --收款人账号
    ,recver_open_bank_no                   --收款人开户行行号
    ,recver_open_bank_name                 --收款人开户行名称
    ,recver_soci_crdt_cd                   --收款人社会信用代码
    ,pay_bank_bank_no                      --付款行行号
    ,pay_bank_name                         --付款行名称
    ,pay_org_id                            --付款机构编号
    ,pay_cfm_org_id                        --付款确认机构编号
    ,accptor_name                          --承兑人名称
    ,accptor_acct_num                      --承兑人账号
    ,accptor_open_bank_no                  --承兑人开户行行号
    ,accptor_open_bank_name                --承兑人开户行名称
    ,accptor_type_cd                       --承兑人类型代码
    ,acpt_org_id                           --承兑机构编号
    ,accptor_soci_crdt_cd                  --承兑人社会信用代码
    ,holder_org_id                         --持票人机构编号
    ,holder_org_name                       --持票人机构名称
    ,discnt_bank_org_id                    --贴现行机构编号
    ,discnt_ibank_no                       --贴现行联行号
    ,discnt_bank_name                      --贴现行名称
    ,endors_cnt                            --背书次数
    ,lock_flg                              --锁定标志
    ,loss_flg                              --挂失标志
    ,hxb_acpt_flg                          --我行承兑标志
    ,pay_cfm_flg                           --付款确认标志
    ,payoff_flg                            --结清标志
    ,recs_flg                              --追偿标志
    ,valet_coll_flg                        --代客托收标志
    ,risk_status_cd                        --风险状态代码
    ,bill_src_cd                           --票据来源代码
    ,bill_status_cd                        --票据状态代码
    ,ccution_status_cd                     --流转状态代码
    ,invtry_status_cd                      --库存状态代码
    ,ele_bill_status_cd                    --电票状态代码
    ,bill_proc_mdl_status_cd               --票据处理中状态代码
    ,belong_org_id                         --所属机构编号
    ,receipt_flg                           --小票标志
    ,redcst_flg                            --再贴现标志
    ,data_src_cd                           --数据来源代码
    ,job_cd                                --任务编码
    ,etl_timestamp                         --数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd')                               --数据日期
    ,t1.lp_id                                                         --法人编号
    ,t1.rgst_id                                                       --票据编号
    ,t1.bill_num                                                      --票据号码
    ,t1.bill_sub_intrv_id                                             --子票据区间号码
    ,t1.bill_med_cd                                                   --票据介质代码
    ,t1.bill_type_cd                                                  --票据类型代码
    ,'5'                                                              --票据付息方式代码
    ,t1.draw_dt                                                       --出票日期
    ,t1.exp_dt                                                        --到期日期
    ,t2.tran_dt                                                       --放款日期t8.tran_dt
    ,t1.draw_dt                                                       --承兑日期
    ,t12.cash_dt                                                      --兑付日期
    ,'CNY'                                                            --币种代码
    ,t1.bill_amt                                                      --票面金额
    ,t10.cust_id                                                      --客户编号
    ,''                                                               --客户经理编号
    ,t10.cust_id                                                      --出票人客户编号
    ,t10.cust_name                                                    --出票人名称
    ,t1.drawer_acct_id                                                --出票人账号
    ,t6.ibank_no                                                      --出票人开户行行号
    ,t6.bank_fname                                                    --出票人开户行名称
    ,''                                                               --出票人经办人编号
    ,'RC01'                                                           --出票人类型代码
    ,''                                                               --出票人组织机构代码
    ,t9.drawer_soci_crdt_cd                                           --出票人社会信用代码
    ,t1.recver_acct_name                                              --收款人名称
    ,t1.recver_acct_id                                                --收款人账号
    ,t5.ibank_no                                                      --收款人开户行行号
    ,t5.bank_fname                                                    --收款人开户行名称
    ,t9.recver_soci_crdt_cd                                           --收款人社会信用代码
    ,t1.pay_bank_bank_no                                              --付款行行号
    ,t1.pay_bank_name                                                 --付款行名称
    ,t1.pay_bank_org_cd                                               --付款机构编号
    ,''                                                               --付款确认机构编号
    ,t1.accptor_name                                                  --承兑人名称
    ,t1.accptor_acct_id                                               --承兑人账号
    ,t1.accptor_open_bank_no                                          --承兑人开户行行号
    ,t1.accptor_open_bank_name                                        --承兑人开户行名称
    ,'RC01'                                                           --承兑人类型代码
    ,t4.br_no                                                         --承兑机构编号
    ,t9.accptor_soci_crdt_cd                                          --承兑人社会信用代码
    ,''                                                               --持票人机构编号
    ,''                                                               --持票人机构名称
    ,t9.discnt_bk_org_cd                                              --贴现行机构编号
    ,t11.sys_prtcptr_bigamt_bank_no                                   --贴现行联行号
    ,t11.sys_prtcptr_bigamt_bank_name                                 --贴现行名称
    ,t1.endors_cnt                                                    --背书次数
    ,t1.lock_flg                                                      --锁定标志
    ,'0'                                                              --挂失标志
    ,'1'                                                              --我行承兑标志
    ,'1'                                                              --付款确认标志
    ,t1.payoff_flg                                                    --结清标志
    ,'1'                                                              --追偿标志
    ,case when trim(t7.bill_num) is not null 
          then '1' else '0' end                                       --代客托收标志
    ,t1.risk_bill_status_cd                                           --风险状态代码
    ,t1.bill_src_tran_cd                                              --票据来源代码
    ,t1.bill_status_cd                                                --票据状态代码
    ,t1.bill_ccution_status_cd                                        --流转状态代码
    ,'-'                                                              --库存状态代码
    ,''                                                         --电票状态代码
    ,case when t1.bill_ccution_status_cd in  'F00' then '001'  --处理结束
     when t1.bill_ccution_status_cd in ('F01','F16','F505') then '002' --承兑受理中
     when t1.bill_ccution_status_cd in ('F22') then '003'       --未用退回受理中
     when t1.bill_ccution_status_cd in ('F14','F15') then '006' --托收在途
     when t1.bill_ccution_status_cd in ('F22') and t1.risk_bill_status_cd ='RS01' then '010' --挂失处理中
     when t1.bill_ccution_status_cd in ('F23') and t1.risk_bill_status_cd ='RS01' then '011' --解挂处理中
     when t1.bill_ccution_status_cd in ('F02') then '012' --质押处理中。
     when t1.bill_ccution_status_cd in ('F03') then '013' --解除质押处理中
     when t1.bill_ccution_status_cd in ('F13') then '014' --保证处理中
     when t1.bill_ccution_status_cd in ('F12') then '016' --代保管处理中
     else '000' end                                                   --票据处理中状态代码
    ,t4.br_no                                                         --所属机构编号
    ,'0'                                                              --小票标志
    ,'0'                                                              --再贴现标志
    ,'05'                                                             --数据来源代码
    ,t1.job_cd
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  --数据处理时间
  from ${iml_schema}.ref_corp_rgst_bill_info_para t1
 inner join ${iml_schema}.evt_corp_rgst_bill_ccution_evt t2
    on t1.rgst_id = t2.bill_id
   and t2.bus_type_cd = '505'
   and t2.tran_status_cd ='TS0002'
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt  > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd  = 'bdmsf1'
 left join (select b.id,
                    b.bank_no,
                    a.ibank_no,
                    b.br_no,
                    row_number() over(partition by b.bank_no order by b.id asc) as rn
               from ${iml_schema}.ref_ibank_info a
               left join ${iol_schema}.bdms_bctl b
                 on a.ibank_no = b.bank_no
                and b.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and b.end_dt > to_date('${batch_date}', 'yyyymmdd')
              where a.create_dt <= to_date('${batch_date}', 'yyyymmdd')
                and a.id_mark <> 'D'
                and a.job_cd = 'bdmsf1') t4
    on t1.drawer_open_bank_no = t4.bank_no
   and t4.rn = 1
  left join ${iml_schema}.ref_ibank_info t5
    on t1.recver_open_bank_no = t5.ibank_no
   and t5.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t5.job_cd = 'bdmsf1'
   and t5.id_mark <> 'D'
  left join ${iml_schema}.ref_ibank_info t6
    on t1.drawer_open_bank_no = t6.ibank_no
   and t6.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t6.job_cd = 'bdmsf1'
   and t6.id_mark <> 'D'
  left join (select distinct bill_id,bill_num 
               from ${iml_schema}.evt_corp_rgst_bill_ccution_evt  --bdms_tbl_swt_business_log
              where bus_type_cd ='110'
                and prod_id ='22110001' 
                and tran_status_cd ='TS0001' 
                and start_dt <= to_date('${batch_date}','yyyymmdd')
                and end_dt   > to_date('${batch_date}','yyyymmdd')
                and job_cd ='bdmsf1'
                ) t7
    on t1.bill_num = t7.bill_num
   and t1.rgst_id = t7.bill_id
 left join (select src_agt_id,
                    cust_id,
                    cust_name,
                    sign_acct_id,
                    row_number() over(partition by sign_acct_id order by src_agt_id asc) as rn
               from ${iml_schema}.agt_bill_cust_sign_info
              where create_dt <= to_date('${batch_date}', 'yyyymmdd')
                and job_cd = 'bdmsf1'
                and id_mark <> 'D'
               ) t10
    on t1.drawer_acct_id = t10.sign_acct_id
   and t10.rn = 1
  left join (select cp.bill_num,
               cp.drawer_soci_crdt_cd,
               cp.accptor_soci_crdt_cd,
               cp.recver_soci_crdt_cd,
               cp.discnt_bk_org_cd,
               row_number() over(partition by bill_num order by bill_id desc) as rn
          from ${iml_schema}.agt_cpes_bill_info cp
         where trim(cp.bill_num) is not null
           and cp.start_dt <= to_date('${batch_date}','yyyymmdd')
           and cp.end_dt > to_date('${batch_date}','yyyymmdd')
           and cp.job_cd = 'bdmsf1')  t9
    on t1.bill_num = t9.bill_num
   and t9.rn = 1
 left join ${icl_schema}.tmp_cmm_bill_center_info_06 t11
  on  t9.discnt_bk_org_cd = t11.mem_org_cd
  and  t11.rn=1  
 left join ${icl_schema}.tmp_cmm_bill_center_info_07 t12
 on t1.rgst_id=t12.draft_id
where t1.bill_type_cd = 'AC02'
   and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'bdmsf1'
;
commit;

--第六组（共六组）票交所他行承兑代开票据信息
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_bill_center_info_ex(
     etl_dt                                --数据日期
    ,lp_id                                 --法人编号
    ,bill_id                               --票据编号
    ,bill_num                              --票据号码
    ,bill_sub_intrv_id                     --子票据区间号码
    ,bill_med_cd                           --票据介质代码
    ,bill_type_cd                          --票据类型代码
    ,bill_pay_int_way_cd                   --票据付息方式代码
    ,draw_dt                               --出票日期
    ,exp_dt                                --到期日期
    ,distr_dt                              --放款日期
    ,acpt_dt                               --承兑日期
    ,cash_dt                               --兑付日期
    ,curr_cd                               --币种代码
    ,fac_val_amt                           --票面金额
    ,cust_id                               --客户编号
    ,cust_mgr_id                           --客户经理编号
    ,drawer_cust_id                        --出票人客户编号
    ,drawer_name                           --出票人名称
    ,drawer_acct_num                       --出票人账号
    ,drawer_open_bank_no                   --出票人开户行行号
    ,drawer_open_bank_name                 --出票人开户行名称
    ,drawer_operr_id                       --出票人经办人编号
    ,drawer_type_cd                        --出票人类型代码
    ,DRAWER_ORGNZ_CD                       --出票人组织机构代码
	  ,DRAWER_SOCI_CRDT_CD                   --出票人社会信用代码
    ,recver_name                           --收款人名称
    ,recver_acct_num                       --收款人账号
    ,recver_open_bank_no                   --收款人开户行行号
    ,recver_open_bank_name                 --收款人开户行名称
    ,recver_soci_crdt_cd                   --收款人社会信用代码
    ,pay_bank_bank_no                      --付款行行号
    ,pay_bank_name                         --付款行名称
    ,pay_org_id                            --付款机构编号
    ,pay_cfm_org_id                        --付款确认机构编号
    ,accptor_name                          --承兑人名称
    ,accptor_acct_num                      --承兑人账号
    ,accptor_open_bank_no                  --承兑人开户行行号
    ,accptor_open_bank_name                --承兑人开户行名称
    ,accptor_type_cd                       --承兑人类型代码
    ,acpt_org_id                           --承兑机构编号
    ,accptor_soci_crdt_cd                  --承兑人社会信用代码
    ,holder_org_id                         --持票人机构编号
    ,holder_org_name                       --持票人机构名称
    ,discnt_bank_org_id                    --贴现行机构编号
    ,discnt_ibank_no                       --贴现行联行号
    ,discnt_bank_name                      --贴现行名称
    ,endors_cnt                            --背书次数
    ,lock_flg                              --锁定标志
    ,loss_flg                              --挂失标志
    ,hxb_acpt_flg                          --我行承兑标志
    ,pay_cfm_flg                           --付款确认标志
    ,payoff_flg                            --结清标志
    ,recs_flg                              --追偿标志
    ,valet_coll_flg                        --代客托收标志
    ,risk_status_cd                        --风险状态代码
    ,bill_src_cd                           --票据来源代码
    ,bill_status_cd                        --票据状态代码
    ,ccution_status_cd                     --流转状态代码
    ,invtry_status_cd                      --库存状态代码
    ,ele_bill_status_cd                    --电票状态代码
    ,bill_proc_mdl_status_cd               --票据处理中状态代码
    ,belong_org_id                         --所属机构编号
    ,receipt_flg                           --小票标志
    ,redcst_flg                            --再贴现标志
    ,data_src_cd                           --数据来源代码
    ,job_cd                                --任务编码
    ,etl_timestamp                         --数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd')  --数据日期
    ,t1.lp_id                            --法人编号
    ,t1.rgst_id                          --票据编号
    ,t1.bill_num                         --票据号码
    ,t1.bill_sub_intrv_id                --子票据区间号码
    ,t1.bill_med_cd                      --票据介质代码
    ,t1.bill_type_cd                     --票据类型代码
    ,'5'                                 --票据付息方式代码
    ,t1.draw_dt                          --出票日期
    ,t1.exp_dt                           --到期日期
    ,t2.tran_dt                          --放款日期t8.tran_dt
    ,t1.draw_dt                          --承兑日期
    ,t12.cash_dt                         --兑付日期
    ,'CNY'                               --币种代码
    ,t1.bill_amt                         --票面金额
    ,t7.cust_id                          --客户编号
    ,''                                  --客户经理编号
    ,t7.cust_id                          --出票人客户编号
    ,t7.cust_name                        --出票人名称
    ,t1.drawer_acct_id                   --出票人账号
    ,t6.ibank_no                         --出票人开户行行号
    ,t6.bank_fname                       --出票人开户行名称
    ,''                                  --出票人经办人编号
    ,'RC01'                              --出票人类型代码
    ,''                                  --出票人组织机构代码
	  ,t10.drawer_soci_crdt_cd             --出票人社会信用代码
    ,t1.recver_name                      --收款人名称
    ,t1.recver_acct_id                   --收款人账号
    ,t5.ibank_no                         --收款人开户行行号
    ,t5.bank_fname                       --收款人开户行名称
    ,t10.recver_soci_crdt_cd             --收款人社会信用代码
    ,t1.pay_bank_bank_no                 --付款行行号
    ,t1.pay_bank_name                    --付款行名称
    ,t1.pay_bank_org_cd                  --付款机构编号
    ,''                                  --付款确认机构编号
    ,t1.accptor_name                     --承兑人名称
    ,t1.accptor_acct_id                  --承兑人账号
    ,t3.ibank_no                         --承兑人开户行行号
    ,t3.bank_fname                       --承兑人开户行名称
    ,'RC01'                              --承兑人类型代码
    ,t4.br_no                            --承兑机构编号
    ,t10.accptor_soci_crdt_cd            --承兑人社会信用代码
    ,''                                  --持票人机构编号
    ,''                                  --持票人机构名称
    ,t10.discnt_bk_org_cd                --贴现行机构编号
    ,t11.sys_prtcptr_bigamt_bank_no      --贴现行联行号
    ,t11.sys_prtcptr_bigamt_bank_name    --贴现行名称
    ,t1.endors_cnt                       --背书次数
    ,t1.lock_flg                         --锁定标志
    ,'0'                                 --挂失标志
    ,'1'                                 --我行承兑标志
    ,'1'                                 --付款确认标志
    ,t1.payoff_flg                       --结清标志
    ,'1'                                 --追偿标志
    ,case when trim(t9.bill_num) is not null 
          then '1' else '0' end          --代客托收标志
    ,t1.risk_bill_status_cd              --风险状态代码
    ,t1.bill_src_tran_cd                 --票据来源代码
    ,t1.bill_status_cd                   --票据状态代码
    ,t1.bill_ccution_status_cd           --流转状态代码
    ,'-'                                 --库存状态代码
    ,'020006'                            --电票状态代码
    ,case when t1.bill_ccution_status_cd in  'F00' then '001'               --处理结束
          when t1.bill_ccution_status_cd in ('F01','F16','F505') then '002' --承兑受理中
          when t1.bill_ccution_status_cd in ('F22') then '003'              --未用退回受理中
          when t1.bill_ccution_status_cd in ('F14','F15') then '006'        --托收在途
          when t1.bill_ccution_status_cd in ('F22') and t1.risk_bill_status_cd ='RS01' then '010' --挂失处理中
          when t1.bill_ccution_status_cd in ('F23') and t1.risk_bill_status_cd ='RS01' then '011' --解挂处理中
          when t1.bill_ccution_status_cd in ('F02') then '012'              --质押处理中
          when t1.bill_ccution_status_cd in ('F03') then '013'              --解除质押处理中
          when t1.bill_ccution_status_cd in ('F13') then '014'              --保证处理中
          when t1.bill_ccution_status_cd in ('F12') then '016'              --代保管处理中
     else '000' end                      --票据处理中状态代码
    ,t4.br_no                            --所属机构编号
    ,'0'                                 --小票标志
    ,'0'                                 --再贴现标志
    ,'06'                                                             --数据来源代码
    ,t1.job_cd
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  --数据处理时间
  from ${iml_schema}.ref_corp_rgst_bill_info_para t1
 inner join ${iml_schema}.evt_corp_rgst_bill_ccution_evt t2
    on t1.rgst_id = t2.bill_id
   and t2.bus_type_cd = '501'
   and t2.tran_status_cd = 'TS0002'
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd  = 'bdmsf1'
 inner join ${iml_schema}.ref_ibank_info t3
    on t1.accptor_open_bank_no = t3.ibank_no
   and t3.job_cd='bdmsf1'
   and not exists (select 1 from ${iol_schema}.bdms_bctl bi
                           where t3.ibank_no = bi.bank_no
                             and bi.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                             and bi.end_dt > to_date('${batch_date}', 'yyyymmdd'))
 inner join (select b.id,
                    b.bank_no,
                    a.ibank_no,
                    b.br_no,
                    row_number() over(partition by b.bank_no order by b.id asc) as rn
               from ${iml_schema}.ref_ibank_info a
               left join ${iol_schema}.bdms_bctl b
                 on a.ibank_no = b.bank_no
                and b.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and b.end_dt > to_date('${batch_date}', 'yyyymmdd')
              where a.create_dt <= to_date('${batch_date}', 'yyyymmdd')
                and a.id_mark <> 'D'
                and a.job_cd = 'bdmsf1') t4
    on t1.drawer_open_bank_no = t4.bank_no
   and t4.rn = 1
  left join ${iml_schema}.ref_ibank_info t5
    on t1.recver_open_bank_no = t5.ibank_no
   and t5.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t5.job_cd = 'bdmsf1'
   and t5.id_mark <> 'D'
  left join ${iml_schema}.ref_ibank_info t6
    on t1.drawer_open_bank_no = t6.ibank_no
   and t6.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t6.job_cd = 'bdmsf1'
   and t6.id_mark <> 'D'
 inner join (select src_agt_id,
                    cust_id,
                    cust_name,
                    sign_acct_id,
                    row_number() over(partition by sign_acct_id order by src_agt_id asc) as rn
               from ${iml_schema}.agt_bill_cust_sign_info
              where create_dt <= to_date('${batch_date}', 'yyyymmdd')
                and job_cd = 'bdmsf1'
                and id_mark <> 'D'
               ) t7
    on t1.drawer_acct_id = t7.sign_acct_id
   and t7.rn = 1
  left join (select distinct bill_id,bill_num 
               from ${iml_schema}.evt_corp_rgst_bill_ccution_evt  --bdms_tbl_swt_business_log
              where prod_id in ('22110001', '21110001') --提示付款申请的业务号
                and tran_status_cd like 'TS0002'
                and start_dt <= to_date('${batch_date}','yyyymmdd')
                and end_dt > to_date('${batch_date}','yyyymmdd')
                and job_cd = 'bdmsf1'
                ) t9
    on t1.bill_num = t9.bill_num
   and t1.rgst_id = t9.bill_id
  left join (select cp.bill_num,
               cp.drawer_soci_crdt_cd,
               cp.accptor_soci_crdt_cd,
               cp.recver_soci_crdt_cd,
               cp.discnt_bk_org_cd,
               row_number() over(partition by bill_num order by bill_id desc) as rn
          from ${iml_schema}.agt_cpes_bill_info cp
         where trim(cp.bill_num) is not null
           and cp.start_dt <= to_date('${batch_date}','yyyymmdd')
           and cp.end_dt > to_date('${batch_date}','yyyymmdd')
           and cp.job_cd = 'bdmsf1')  t10
    on t1.bill_num = t10.bill_num
   and t10.rn =1
 left join ${icl_schema}.tmp_cmm_bill_center_info_06 t11
  on  t10.discnt_bk_org_cd = t11.mem_org_cd
  and  t11.rn=1  
  left join ${icl_schema}.tmp_cmm_bill_center_info_07 t12
  on t1.rgst_id=t12.draft_id
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd='bdmsf1'
;
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_bill_center_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_bill_center_info_ex;

-- 3.1 drop ex table
--drop table ${icl_schema}.cmm_bill_center_info_ex purge;
--drop table ${icl_schema}.tmp_cmm_bill_center_info_01 purge;
--drop table ${icl_schema}.tmp_cmm_bill_center_info_02 purge;
--drop table ${icl_schema}.tmp_cmm_bill_center_info_03 purge;
--drop table ${icl_schema}.tmp_cmm_bill_center_info_04 purge;
--drop table ${icl_schema}.tmp_cmm_bill_center_info_05 purge;
--drop table ${icl_schema}.tmp_cmm_bill_center_info_06 purge;
--drop table ${icl_schema}.tmp_cmm_bill_center_info_07 purge;
-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_bill_center_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);