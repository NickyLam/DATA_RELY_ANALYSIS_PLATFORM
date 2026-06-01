/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_apv_mini_loan_attach_info_h_icmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,apv_flow_num -- 审批流水号
    ,comm_fee_amt -- 手续费金额
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,recver_open_bank_rg_cd -- 收款人开户行地区代码
    ,tenor_type_cd -- 期限类型代码
    ,loan_ratio -- 贷款比例
    ,secd_repay_acct_id -- 第二还款账户编号
    ,major_guartor_name -- 主要担保人名称
    ,major_guartor_id -- 主要担保人编号
    ,enter_acct_org_id -- 入账机构编号
    ,comm_fee_mode_pay_cd -- 手续费支付方式代码
    ,bank_int_flg -- 行内标志
    ,loan_usage_tran_amt -- 贷款用途交易金额
    ,resv_pric -- 保留本金
    ,stud_loan_deflt_prod_id -- 助贷默认产品编号
    ,indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,apved_dt -- 审批通过日期
    ,secd_repay_acct_name -- 第二还款账户名称
    ,prtcpt_deduct_flg -- 参与批扣标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_bap_upl_loan-1
insert into ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,apv_flow_num -- 审批流水号
    ,comm_fee_amt -- 手续费金额
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,recver_open_bank_rg_cd -- 收款人开户行地区代码
    ,tenor_type_cd -- 期限类型代码
    ,loan_ratio -- 贷款比例
    ,secd_repay_acct_id -- 第二还款账户编号
    ,major_guartor_name -- 主要担保人名称
    ,major_guartor_id -- 主要担保人编号
    ,enter_acct_org_id -- 入账机构编号
    ,comm_fee_mode_pay_cd -- 手续费支付方式代码
    ,bank_int_flg -- 行内标志
    ,loan_usage_tran_amt -- 贷款用途交易金额
    ,resv_pric -- 保留本金
    ,stud_loan_deflt_prod_id -- 助贷默认产品编号
    ,indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,apved_dt -- 审批通过日期
    ,secd_repay_acct_name -- 第二还款账户名称
    ,prtcpt_deduct_flg -- 参与批扣标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300006'||P1.SERIALNO -- 协议编号
    ,P1.SERIALNO -- 审批流水号
    ,P1.FEESUM -- 手续费金额
    ,nvl(trim(P1.PAYMENTTYPE),'0') -- 放款支付方式代码
    ,nvl(trim(P1.PAYBANKADDCODE),'000000') -- 收款人开户行地区代码
    ,nvl(trim(P1.LOANKIND),'-') -- 期限类型代码
    ,P1.BUSINESSPROP -- 贷款比例
    ,P1.PAYACCOUNTNO2 -- 第二还款账户编号
    ,P1.WARRANTOR -- 主要担保人名称
    ,P1.WARRANTORID -- 主要担保人编号
    ,P1.INCOMEORGID -- 入账机构编号
    ,nvl(trim(P1.FEEPAYMENT),'-') -- 手续费支付方式代码
    ,nvl(trim(P1.BANKINOUTFLAG),'-') -- 行内标志
    ,P1.LOANTRADESUM -- 贷款用途交易金额
    ,P1.HOLDCORPUS -- 保留本金
    ,P1.SUBBUSINESSTYPE -- 助贷默认产品编号
    ,P1.FEERATIO -- 个人贷款手续费率
    ,P1.APPROVEDATE -- 审批通过日期
    ,P1.PAYACCOUNTNAME2 -- 第二还款账户名称
    ,nvl(trim(P1.BATCHPAYMENTFLAG),'-') -- 参与批扣标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_bap_upl_loan' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_bap_upl_loan p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,apv_flow_num
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,apv_flow_num -- 审批流水号
    ,comm_fee_amt -- 手续费金额
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,recver_open_bank_rg_cd -- 收款人开户行地区代码
    ,tenor_type_cd -- 期限类型代码
    ,loan_ratio -- 贷款比例
    ,secd_repay_acct_id -- 第二还款账户编号
    ,major_guartor_name -- 主要担保人名称
    ,major_guartor_id -- 主要担保人编号
    ,enter_acct_org_id -- 入账机构编号
    ,comm_fee_mode_pay_cd -- 手续费支付方式代码
    ,bank_int_flg -- 行内标志
    ,loan_usage_tran_amt -- 贷款用途交易金额
    ,resv_pric -- 保留本金
    ,stud_loan_deflt_prod_id -- 助贷默认产品编号
    ,indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,apved_dt -- 审批通过日期
    ,secd_repay_acct_name -- 第二还款账户名称
    ,prtcpt_deduct_flg -- 参与批扣标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,apv_flow_num -- 审批流水号
    ,comm_fee_amt -- 手续费金额
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,recver_open_bank_rg_cd -- 收款人开户行地区代码
    ,tenor_type_cd -- 期限类型代码
    ,loan_ratio -- 贷款比例
    ,secd_repay_acct_id -- 第二还款账户编号
    ,major_guartor_name -- 主要担保人名称
    ,major_guartor_id -- 主要担保人编号
    ,enter_acct_org_id -- 入账机构编号
    ,comm_fee_mode_pay_cd -- 手续费支付方式代码
    ,bank_int_flg -- 行内标志
    ,loan_usage_tran_amt -- 贷款用途交易金额
    ,resv_pric -- 保留本金
    ,stud_loan_deflt_prod_id -- 助贷默认产品编号
    ,indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,apved_dt -- 审批通过日期
    ,secd_repay_acct_name -- 第二还款账户名称
    ,prtcpt_deduct_flg -- 参与批扣标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.apv_flow_num, o.apv_flow_num) as apv_flow_num -- 审批流水号
    ,nvl(n.comm_fee_amt, o.comm_fee_amt) as comm_fee_amt -- 手续费金额
    ,nvl(n.distr_mode_pay_cd, o.distr_mode_pay_cd) as distr_mode_pay_cd -- 放款支付方式代码
    ,nvl(n.recver_open_bank_rg_cd, o.recver_open_bank_rg_cd) as recver_open_bank_rg_cd -- 收款人开户行地区代码
    ,nvl(n.tenor_type_cd, o.tenor_type_cd) as tenor_type_cd -- 期限类型代码
    ,nvl(n.loan_ratio, o.loan_ratio) as loan_ratio -- 贷款比例
    ,nvl(n.secd_repay_acct_id, o.secd_repay_acct_id) as secd_repay_acct_id -- 第二还款账户编号
    ,nvl(n.major_guartor_name, o.major_guartor_name) as major_guartor_name -- 主要担保人名称
    ,nvl(n.major_guartor_id, o.major_guartor_id) as major_guartor_id -- 主要担保人编号
    ,nvl(n.enter_acct_org_id, o.enter_acct_org_id) as enter_acct_org_id -- 入账机构编号
    ,nvl(n.comm_fee_mode_pay_cd, o.comm_fee_mode_pay_cd) as comm_fee_mode_pay_cd -- 手续费支付方式代码
    ,nvl(n.bank_int_flg, o.bank_int_flg) as bank_int_flg -- 行内标志
    ,nvl(n.loan_usage_tran_amt, o.loan_usage_tran_amt) as loan_usage_tran_amt -- 贷款用途交易金额
    ,nvl(n.resv_pric, o.resv_pric) as resv_pric -- 保留本金
    ,nvl(n.stud_loan_deflt_prod_id, o.stud_loan_deflt_prod_id) as stud_loan_deflt_prod_id -- 助贷默认产品编号
    ,nvl(n.indv_loan_comm_fee_rat, o.indv_loan_comm_fee_rat) as indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,nvl(n.apved_dt, o.apved_dt) as apved_dt -- 审批通过日期
    ,nvl(n.secd_repay_acct_name, o.secd_repay_acct_name) as secd_repay_acct_name -- 第二还款账户名称
    ,nvl(n.prtcpt_deduct_flg, o.prtcpt_deduct_flg) as prtcpt_deduct_flg -- 参与批扣标志
    ,case when
            n.agt_id is null
            and n.apv_flow_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.apv_flow_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.apv_flow_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.apv_flow_num = n.apv_flow_num
where (
        o.agt_id is null
        and o.apv_flow_num is null
    )
    or (
        n.agt_id is null
        and n.apv_flow_num is null
    )
    or (
        o.comm_fee_amt <> n.comm_fee_amt
        or o.distr_mode_pay_cd <> n.distr_mode_pay_cd
        or o.recver_open_bank_rg_cd <> n.recver_open_bank_rg_cd
        or o.tenor_type_cd <> n.tenor_type_cd
        or o.loan_ratio <> n.loan_ratio
        or o.secd_repay_acct_id <> n.secd_repay_acct_id
        or o.major_guartor_name <> n.major_guartor_name
        or o.major_guartor_id <> n.major_guartor_id
        or o.enter_acct_org_id <> n.enter_acct_org_id
        or o.comm_fee_mode_pay_cd <> n.comm_fee_mode_pay_cd
        or o.bank_int_flg <> n.bank_int_flg
        or o.loan_usage_tran_amt <> n.loan_usage_tran_amt
        or o.resv_pric <> n.resv_pric
        or o.stud_loan_deflt_prod_id <> n.stud_loan_deflt_prod_id
        or o.indv_loan_comm_fee_rat <> n.indv_loan_comm_fee_rat
        or o.apved_dt <> n.apved_dt
        or o.secd_repay_acct_name <> n.secd_repay_acct_name
        or o.prtcpt_deduct_flg <> n.prtcpt_deduct_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,apv_flow_num -- 审批流水号
    ,comm_fee_amt -- 手续费金额
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,recver_open_bank_rg_cd -- 收款人开户行地区代码
    ,tenor_type_cd -- 期限类型代码
    ,loan_ratio -- 贷款比例
    ,secd_repay_acct_id -- 第二还款账户编号
    ,major_guartor_name -- 主要担保人名称
    ,major_guartor_id -- 主要担保人编号
    ,enter_acct_org_id -- 入账机构编号
    ,comm_fee_mode_pay_cd -- 手续费支付方式代码
    ,bank_int_flg -- 行内标志
    ,loan_usage_tran_amt -- 贷款用途交易金额
    ,resv_pric -- 保留本金
    ,stud_loan_deflt_prod_id -- 助贷默认产品编号
    ,indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,apved_dt -- 审批通过日期
    ,secd_repay_acct_name -- 第二还款账户名称
    ,prtcpt_deduct_flg -- 参与批扣标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,apv_flow_num -- 审批流水号
    ,comm_fee_amt -- 手续费金额
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,recver_open_bank_rg_cd -- 收款人开户行地区代码
    ,tenor_type_cd -- 期限类型代码
    ,loan_ratio -- 贷款比例
    ,secd_repay_acct_id -- 第二还款账户编号
    ,major_guartor_name -- 主要担保人名称
    ,major_guartor_id -- 主要担保人编号
    ,enter_acct_org_id -- 入账机构编号
    ,comm_fee_mode_pay_cd -- 手续费支付方式代码
    ,bank_int_flg -- 行内标志
    ,loan_usage_tran_amt -- 贷款用途交易金额
    ,resv_pric -- 保留本金
    ,stud_loan_deflt_prod_id -- 助贷默认产品编号
    ,indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,apved_dt -- 审批通过日期
    ,secd_repay_acct_name -- 第二还款账户名称
    ,prtcpt_deduct_flg -- 参与批扣标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.apv_flow_num -- 审批流水号
    ,o.comm_fee_amt -- 手续费金额
    ,o.distr_mode_pay_cd -- 放款支付方式代码
    ,o.recver_open_bank_rg_cd -- 收款人开户行地区代码
    ,o.tenor_type_cd -- 期限类型代码
    ,o.loan_ratio -- 贷款比例
    ,o.secd_repay_acct_id -- 第二还款账户编号
    ,o.major_guartor_name -- 主要担保人名称
    ,o.major_guartor_id -- 主要担保人编号
    ,o.enter_acct_org_id -- 入账机构编号
    ,o.comm_fee_mode_pay_cd -- 手续费支付方式代码
    ,o.bank_int_flg -- 行内标志
    ,o.loan_usage_tran_amt -- 贷款用途交易金额
    ,o.resv_pric -- 保留本金
    ,o.stud_loan_deflt_prod_id -- 助贷默认产品编号
    ,o.indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,o.apved_dt -- 审批通过日期
    ,o.secd_repay_acct_name -- 第二还款账户名称
    ,o.prtcpt_deduct_flg -- 参与批扣标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.apv_flow_num = n.apv_flow_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.apv_flow_num = d.apv_flow_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h;
--alter table ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_apv_mini_loan_attach_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_apv_mini_loan_attach_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_apv_mini_loan_attach_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
