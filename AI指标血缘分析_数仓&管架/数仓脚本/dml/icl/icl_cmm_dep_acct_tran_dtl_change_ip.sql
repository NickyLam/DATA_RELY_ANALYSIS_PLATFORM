/*
Purpose:    共性加工层-存款账户交易明细:包括所有行内存款账户的金融交易明细，数据来源于新核心系统。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20220930 icl_cmm_dep_acct_tran_dtl_change
Createdate: 20200424
Logs:	      20240102 陈伟峰 新增脚本用于更新IP\MAC地址字段
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--drop table ${icl_schema}.cmm_dep_acct_tran_dtl_bak20240517;
drop table ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_ip_01;
drop table ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_ip_02;


-- 1.2 create table for exchage and add partition
whenever sqlerror continue none;
create table ${icl_schema}.cmm_dep_acct_tran_dtl_bak20240517
as select * from ${icl_schema}.cmm_dep_acct_tran_dtl
where etl_dt >=to_date('20230101','yyyymmdd');
commit;


whenever sqlerror exit sql.sqlcode;
-- 1.3 create table for IP、MAC message
create table ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_ip_01(
sorc_sys_flow_num varchar2(60)
,tran_flow_num varchar2(60)
,tran_dt date 
,acct_bill_flow_num varchar2(60)
,tran_acct_num varchar2(100)
,cust_ip_num varchar2(250)
,cust_termn_mac_addr varchar2(60)
)
nologging
compress ${option_switch} for query high
;

--1.4 常规口径加工
insert /*+ append */ into ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_ip_01(
sorc_sys_flow_num
,tran_flow_num
,tran_dt
,acct_bill_flow_num
,tran_acct_num
,cust_ip_num
,cust_termn_mac_addr
)
select t1.channel_seq_no
       ,t1.reference as tran_flow_num
       ,t1.tran_date as tran_dt
       ,t1.seq_no as acct_bill_flow_num
       ,t2.tran_acct_num
       ,t2.cust_ip_num
       ,t2.cust_termn_mac_addr
 from msl.ncbs_rb_tran_hist t1
 inner join (select sorc_sys_flow_num,
       			 core_tran_dt,
       			 tran_acct_num,
       			 cust_ip_num,
       			 cust_termn_mac_addr
         from ${iml_schema}.evt_onl_bank_tran_flow
        where job_cd = 'osbsf1'
          and core_tran_dt >= add_months(to_date('20230101','yyyymmdd'), -1)
--          and core_tran_dt <= to_date('${batch_date}','yyyymmdd')
          and trim(sorc_sys_flow_num) is not null
          and (trim(cust_ip_num) is not null or trim(cust_termn_mac_addr) is not null)
        union all
       select sorc_sys_flow_num,
       			 core_tran_dt,
       			 tran_acct_num,
       			 cust_ip_num,
       			 cust_termn_mac_addr
         from ${iml_schema}.evt_os_priv_serv_bus_flow
        where tran_dt >= add_months(to_date('20230101','yyyymmdd'), -1)
--          and tran_dt <= to_date('${batch_date}','yyyymmdd')
          and etl_dt >= add_months(to_date('20230101','yyyymmdd'), -1)
--          and etl_dt <= to_date('${batch_date}','yyyymmdd')
          and job_cd = 'osbsi1'
          and trim(sorc_sys_flow_num) is not null
          and (trim(cust_ip_num) is not null or trim(cust_termn_mac_addr) is not null)
        union all
       select sorc_sys_flow_num,
       			 core_tran_dt,
       			 tran_acct_num,
       			 cust_ip_num,
       			 cust_termn_mac_addr
         from ${iml_schema}.evt_os_invest_finc_bus_flow
        where tran_dt >= add_months(to_date('20230101','yyyymmdd'), -1)
--          and tran_dt <= to_date('${batch_date}','yyyymmdd')
          and etl_dt >= add_months(to_date('20230101','yyyymmdd'), -1)
--          and etl_dt <= to_date('${batch_date}','yyyymmdd')
          and job_cd = 'osbsi1'
          and trim(sorc_sys_flow_num) is not null
          and (trim(cust_ip_num) is not null or trim(cust_termn_mac_addr) is not null)
        union all
       select
              sorc_sys_flow_id as sorc_sys_flow_num,
              core_tran_dt as core_tran_dt,
              tran_acct_num as tran_acct_num,
              cust_ip as cust_ip_num,
              cust_termn_mac_addr as cust_termn_mac_addr
         from ${iml_schema}.evt_bank_pc_edit_tran_flow
        where job_cd = 'tbpsf1' -- 20230315 调整关联条件，去掉日期条件，m层是每天全量切片
          and core_tran_dt >= add_months(to_date('20230101','yyyymmdd'), -1)
--          and core_tran_dt <= to_date('${batch_date}','yyyymmdd')
          and trim(sorc_sys_flow_id) is not null
          and (trim(cust_ip) is not null or trim(cust_termn_mac_addr) is not null)
        union all
       select ova_flow_num as sorc_sys_flow_num,
              core_tran_dt as core_tran_dt,
              tran_acct_num as tran_acct_num,
              client_ip as cust_ip_num,
              client_mac as cust_termn_mac_addr
         from ${iml_schema}.evt_priv_onl_bank_tran_flow t
        where tran_dt >= add_months(to_date('20230101','yyyymmdd'), -1)
--          and tran_dt <= to_date('${batch_date}','yyyymmdd')
          and etl_dt >= add_months(to_date('20230101','yyyymmdd'), -1)
--          and etl_dt <= to_date('${batch_date}','yyyymmdd')
          and job_cd = 'osbsi1'
          and trim(ova_flow_num) is not null
          and (trim(client_ip) is not null or trim(client_mac) is not null)
        union all
       select sorc_sys_flow_num as sorc_sys_flow_num,
              tran_tm as core_tran_dt,
              acct_id as tran_acct_num,
              cust_ip as cust_ip_num,
              cust_termn_mac_addr as cust_termn_mac_addr
         from ${iml_schema}.evt_ponl_bk_oper_mgmt_flow t
        where tran_tm >= add_months(to_date('20230101','yyyymmdd'), -1)
--          and tran_tm <= to_date('${batch_date}','yyyymmdd')
          and etl_dt >= add_months(to_date('20230101','yyyymmdd'), -1)
--          and etl_dt <= to_date('${batch_date}','yyyymmdd')
          and job_cd = 'osbsi1'
          and trim(sorc_sys_flow_num) is not null
          and (trim(cust_ip) is not null or trim(cust_termn_mac_addr) is not null)
       ) t2 
       on t1.channel_seq_no=t2.sorc_sys_flow_num
       where t1.tran_date >=to_date('20230101','yyyymmdd')
;
commit;

--1.5.核心自动转存交易场景：
--通过核心协议表逻辑取出来的"签约的全局流水",跟opsprd.ops_trade_flow的全局流水号otf_global_seqno关联，获取到该笔交易的核心internal_key，通过该internal_key关联回核心rb_tran_hist，将核心该表所有涉及该internal_key的交易IP\MAC地址全部刷成OSB系统数据
insert /*+ append */ into ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_ip_01(
sorc_sys_flow_num
,tran_flow_num
,tran_dt
,acct_bill_flow_num
,tran_acct_num
,cust_ip_num
,cust_termn_mac_addr
)
select 
        t3.channel_seq_no as sorc_sys_flow_num
       ,t3.reference as tran_flow_num
       ,t3.tran_date as tran_dt
       ,t3.seq_no as acct_bill_flow_num
       ,t1.otf_accno as tran_acct_num          --账号,
       ,t1.otf_clientip as cust_ip_num    --ip地址,
       ,t1.otf_clientmac as cust_termn_mac_addr     --mac地址,
  from iol.osbs_ops_trade_flow t1 --opsprd.ops_trade_flow
 inner join (select qy.seq_no --签约的全局流水 
                     ,a.internal_key
                from msl.ncbs_rb_acct a --ens_rb.rb_acct  
                join (select ra.base_acct_no,ra.acct_seq_no, raf.fin_prod_type, raf.sign_reference, fti.seq_no,raf.agreement_id
                        from msl.ncbs_rb_agreement_financial raf --ens_rb.rb_agreement_financial 
                       inner join msl.ncbs_rb_agreement ra     --ens_rb.rb_agreement
                          on raf.agreement_id = ra.agreement_id
                       inner join msl.ncbs_rb_fw_tran_info fti  --ens_rb.fw_tran_info  
                          on fti.reference = raf.sign_reference  
                       where raf.agreement_type in ('AXC','LHY','CXDT','TBCK'))qy   --安兴存、灵活盈、储蓄定投、跳板
                   on  qy.agreement_id =a.agreement_id) t2
    on t1.otf_global_seqno=t2.seq_no
 inner join msl.ncbs_rb_tran_hist t3     --ens_rb.rb_tran_hist 
    on t3.internal_key=t2.internal_key
   and t3.cr_dr_ind='C'   --新增
   where t3.tran_date >=to_date('20230101','yyyymmdd');
   commit;
   
--1.6.基金系统基金定投：
--通过基金系统逻辑取出来的"开通基金定投协议时渠道发起全局流水号",跟opsprd.ops_trade_flow的全局流水号otf_global_seqno关联，获取到osbs该笔交易的otf_accno账号和otf_ecifno客户号，通过该账号、客户号关联回核心rb_tran_hist，将核心该表所有涉及该账号的交易IP\MAC地址全部刷成OSB系统数据
--关联逻辑验证起来是没错的，但是没数据
insert /*+ append */ into ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_ip_01(
sorc_sys_flow_num
,tran_flow_num
,tran_dt
,acct_bill_flow_num
,tran_acct_num
,cust_ip_num
,cust_termn_mac_addr
)
select t2.channel_seq_no as  sorc_sys_flow_num        --账号
       ,t2.reference as tran_flow_num
       ,t2.tran_date as tran_dt
       ,t2.seq_no as acct_bill_flow_num
       ,' ' as tran_acct_num
       ,t1.otf_clientip as cust_ip_num    --ip地址
       ,t1.otf_clientmac as cust_termn_mac_addr     --mac地址
  from iol.osbs_ops_trade_flow t1 --opsprd.ops_trade_flow
 inner join msl.ncbs_rb_tran_hist t2  --核心交易流水表
    on t1.otf_accno=t2.base_acct_no
 where t1.otf_global_seqno in (select substr(reserve5, 0, 33) --开通基金定投协议时渠道发起全局流水号
                                     from msl.nfss_tbhistransreq  --cps.tbhistransreq
                                    where trans_code = '100208'
                                      and trim(substr(reserve5, 0, 33)) is not null
                                      and serial_no in
                                          (select serial_no
                                             from msl.nfss_tbautoinvest  --cps.tbautoinvest
                                            where serial_no in (select asso_serial
                                                                  from msl.nfss_tbhistransreq  --cps.tbhistransreq
                                                                 where trans_code = '200208'
                                                                   and trim(asso_serial) is not null) )
                                   )
and trim(t1.otf_global_seqno) is not null
and trim(t1.otf_accno) is not null
and t2.tran_date >=to_date('20230101','yyyymmdd');
   commit;
   
--------------------------------------------------------------------------------------------------------------------------------------------
--1.7.企业网银部分
--特殊规则加工
--新核心 关联方式用渠道流水取前33跟核心的全局流水号关联
insert /*+ append */ into ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_ip_01(
sorc_sys_flow_num
,tran_flow_num
,tran_dt
,acct_bill_flow_num
,tran_acct_num
,cust_ip_num
,cust_termn_mac_addr
)
select t1.channel_seq_no as  sorc_sys_flow_num        --账号
       ,t1.reference as tran_flow_num
       ,t1.tran_date as tran_dt
       ,t1.seq_no as acct_bill_flow_num
       ,' ' as tran_acct_num
       ,t3.ctf_customerip as cust_ip_num
       ,t3.ctf_clientmac as cust_termn_mac_addr
from msl.ncbs_rb_tran_hist t1  --核心交易流水表
inner join msl.tbps_cpr_batch_detail t2
on t1.CHANNEL_SEQ_NO =substr(t2.cbd_sendflowno,1,instr(t2.cbd_sendflowno,'TBP',-1)-1)
and t1.tran_date=to_date(t2.CBD_TRANSDATE,'yyyymmdd')
inner join msl.tbps_cpr_trade_flow  t3   --cbsprd.cpr_trade_flow
on t2.CBD_TRADE_FLOWNO =t3.ctf_trade_flowno  
where t1.tran_date >=to_date('20230501','yyyymmdd')  --处理新一代以后的交易流水
--老核心  关联方式可以用核心记账流水和日期做关联
union all 
select t1.channel_seq_no as  sorc_sys_flow_num        --账号
       ,t1.reference as tran_flow_num
       ,t1.tran_date as tran_dt
       ,t1.seq_no as acct_bill_flow_num
       ,' ' as tran_acct_num
       ,t3.ctf_customerip as cust_ip_num
       ,t3.ctf_clientmac  as cust_termn_mac_addr
from msl.ncbs_rb_tran_hist t1  --核心交易流水表
inner join msl.tbps_cpr_batch_detail t2
on t1.REFERENCE =t2.CBD_TRANSDATE||t2.cbd_hostflow    --新核心交易流水号为旧核心交易日期拼上旧核心交易流水
and t1.tran_date=to_date(t2.CBD_TRANSDATE,'yyyymmdd')
inner join msl.tbps_cpr_trade_flow  t3   --cbsprd.cpr_trade_flow
on t2.CBD_TRADE_FLOWNO =t3.ctf_trade_flowno  
where t1.tran_date <to_date('20230501','yyyymmdd')
AND t1.tran_date>=to_date('20230101','yyyymmdd'); 
commit;


-- 1.8 insert data to tmp table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_ip_02
nologging
compress ${option_switch} for query high
as
select * 
  from (select t1.*
               ,row_number() over(partition by t1.sorc_sys_flow_num,t1.tran_dt,t1.acct_bill_flow_num,t1.tran_flow_num order by t1.sorc_sys_flow_num) rn
          from ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_ip_01 t1
         where (trim(t1.cust_ip_num) is not null or trim(t1.cust_termn_mac_addr) is not null) 
       ) t1 
 where rn=1;



-- 2.0 update data to target table
whenever sqlerror exit sql.sqlcode;
merge into ${icl_schema}.cmm_dep_acct_tran_dtl t1
using ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_ip_02 t2
on (t1.ova_flow_num =t2.sorc_sys_flow_num
and t1.etl_dt=t2.tran_dt
and t1.acct_bill_flow_num =t2.acct_bill_flow_num
and t1.tran_flow_num=t2.tran_flow_num)
when matched then update set t1.client_ip_addr =t2.cust_ip_num,t1.cust_termn_mac_addr=t2.cust_termn_mac_addr
where t1.etl_dt >=to_date('20230101','yyyymmdd');
commit;