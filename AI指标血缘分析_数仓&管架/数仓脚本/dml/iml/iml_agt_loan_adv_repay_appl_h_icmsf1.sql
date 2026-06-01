/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_adv_repay_appl_h_icmsf1
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
alter table ${iml_schema}.agt_loan_adv_repay_appl_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_adv_repay_appl_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_adv_repay_appl_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_adv_repay_appl_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_adv_repay_appl_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_adv_repay_appl_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_adv_repay_appl_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,tran_type_cd -- 交易类型代码
    ,rela_obj_flow_num -- 关联对象流水号
    ,rela_obj_type_name -- 关联对象类型名称
    ,rela_dubil_id -- 关联借据编号
    ,appl_status_cd -- 申请状态代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,acct_flg -- 账户标志
    ,acct_type_cd -- 账户类型代码
    ,repay_acct_name -- 还款账户名称
    ,repay_acct_id -- 还款账户编号
    ,actl_recv_pric -- 实收本金
    ,actl_recv_int -- 实收利息
    ,actl_recv_pnlt -- 实收罚息
    ,actl_recv_comp_int -- 实收复息
    ,actl_recv_fee -- 实收费用
    ,repay_tot_amt -- 还款总金额
    ,adv_repay_way_cd -- 提前还款方式代码
    ,adv_repay_int_accr_way_cd -- 提前还款计息方式代码
    ,adv_repay_int_accr_base_cd -- 提前还款计息基础代码
    ,adv_repay_amt_type_cd -- 提前还款金额类型代码
    ,adv_repay_amt -- 提前还款金额
    ,adv_rtn_pric -- 提前归还本金
    ,adv_rtn_int -- 提前归还利息
    ,adv_rtn_fee -- 提前归还费用
    ,penalty_amt -- 违约金金额
    ,deduct_seq_cd -- 扣款顺序代码
    ,onl_pay_flg -- 在线支付标志
    ,core_tran_flow_num -- 核心交易流水号
    ,core_tran_status_cd -- 核心交易状态代码
    ,appl_dt -- 申请日期
    ,core_tran_dt -- 核心交易日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,belong_strip_line_cd -- 所属条线代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_adv_repay_appl_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_adv_repay_appl_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_adv_repay_appl_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_adv_repay_appl_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_adv_repay_appl_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_afterloan_payment-1
insert into ${iml_schema}.agt_loan_adv_repay_appl_h_icmsf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,tran_type_cd -- 交易类型代码
    ,rela_obj_flow_num -- 关联对象流水号
    ,rela_obj_type_name -- 关联对象类型名称
    ,rela_dubil_id -- 关联借据编号
    ,appl_status_cd -- 申请状态代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,acct_flg -- 账户标志
    ,acct_type_cd -- 账户类型代码
    ,repay_acct_name -- 还款账户名称
    ,repay_acct_id -- 还款账户编号
    ,actl_recv_pric -- 实收本金
    ,actl_recv_int -- 实收利息
    ,actl_recv_pnlt -- 实收罚息
    ,actl_recv_comp_int -- 实收复息
    ,actl_recv_fee -- 实收费用
    ,repay_tot_amt -- 还款总金额
    ,adv_repay_way_cd -- 提前还款方式代码
    ,adv_repay_int_accr_way_cd -- 提前还款计息方式代码
    ,adv_repay_int_accr_base_cd -- 提前还款计息基础代码
    ,adv_repay_amt_type_cd -- 提前还款金额类型代码
    ,adv_repay_amt -- 提前还款金额
    ,adv_rtn_pric -- 提前归还本金
    ,adv_rtn_int -- 提前归还利息
    ,adv_rtn_fee -- 提前归还费用
    ,penalty_amt -- 违约金金额
    ,deduct_seq_cd -- 扣款顺序代码
    ,onl_pay_flg -- 在线支付标志
    ,core_tran_flow_num -- 核心交易流水号
    ,core_tran_status_cd -- 核心交易状态代码
    ,appl_dt -- 申请日期
    ,core_tran_dt -- 核心交易日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,belong_strip_line_cd -- 所属条线代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206002'||P1.SERIALNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 申请流水号
    ,nvl(TRIM(P1.TRANSCODE),'-') -- 交易类型代码
    ,P1.RELATIVESERIALNO -- 关联对象流水号
    ,P1.OBJECTTYPE -- 关联对象类型名称
    ,P1.LOANNO -- 关联借据编号
    ,nvl(TRIM(P1.APPLYSTATUS),'-') -- 申请状态代码
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CUSTOMERNAME -- 客户名称
    ,P1.PRODUCTID -- 产品编号
    ,nvl(TRIM(P1.PAYMENTCURRENCY),'-') -- 币种代码
    ,nvl(TRIM(P1.PAYACCOUNTFLAG),'-') -- 账户标志
    ,nvl(TRIM(P1.PAYACCOUNTTYPE),'-') -- 账户类型代码
    ,P1.PAYACCOUNTNAME -- 还款账户名称
    ,P1.PAYACCOUNTNO -- 还款账户编号
    ,P1.ACTUALPAYPRINCIPALAMT -- 实收本金
    ,P1.ACTUALPAYINTERESTAMT -- 实收利息
    ,P1.ACTUALPAYPRINCIPALPENALTYAMT -- 实收罚息
    ,P1.ACTUALPAYINTERESTPENALTYAMT -- 实收复息
    ,P1.ACTUALPAYFEEAMT -- 实收费用
    ,P1.PAYAMT -- 还款总金额
    ,nvl(TRIM(P1.PREPAYTYPE),'-') -- 提前还款方式代码
    ,nvl(TRIM(P1.PREPAYINTERESTDAYSFLAG),'-') -- 提前还款计息方式代码
    ,nvl(TRIM(P1.PREPAYINTERESTBASEFLAG),'-') -- 提前还款计息基础代码
    ,nvl(TRIM(P1.PREPAYAMTFLAG),'-') -- 提前还款金额类型代码
    ,P1.PREPAYAMT -- 提前还款金额
    ,P1.PREPAYPRINCIPALAMT -- 提前归还本金
    ,P1.PREPAYINTERESTAMT -- 提前归还利息
    ,P1.PREPAYFEEAMT -- 提前归还费用
    ,P1.VIOLATEAMT -- 违约金金额
    ,nvl(TRIM(P1.PAYRULETYPE),'-') -- 扣款顺序代码
    ,nvl(TRIM(P1.AUTOPAYFLAG),'-') -- 在线支付标志
    ,P1.TRANSNO -- 核心交易流水号
    ,nvl(TRIM(P1.TRANSSTATUS),'-') -- 核心交易状态代码
    ,P1.EXCUTEDATE -- 申请日期
    ,P1.TRANSDATE -- 核心交易日期
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,nvl(trim(P1.UPDATEUSERID),0) -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 变更日期
    ,nvl(TRIM(P1.BELONGDEPT),'-') -- 所属条线代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_afterloan_payment' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_afterloan_payment p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_adv_repay_appl_h_icmsf1_tm 
  	                                group by 
  	                                        appl_id
  	                                        ,lp_id
  	                                        ,appl_flow_num
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
        into ${iml_schema}.agt_loan_adv_repay_appl_h_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,tran_type_cd -- 交易类型代码
    ,rela_obj_flow_num -- 关联对象流水号
    ,rela_obj_type_name -- 关联对象类型名称
    ,rela_dubil_id -- 关联借据编号
    ,appl_status_cd -- 申请状态代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,acct_flg -- 账户标志
    ,acct_type_cd -- 账户类型代码
    ,repay_acct_name -- 还款账户名称
    ,repay_acct_id -- 还款账户编号
    ,actl_recv_pric -- 实收本金
    ,actl_recv_int -- 实收利息
    ,actl_recv_pnlt -- 实收罚息
    ,actl_recv_comp_int -- 实收复息
    ,actl_recv_fee -- 实收费用
    ,repay_tot_amt -- 还款总金额
    ,adv_repay_way_cd -- 提前还款方式代码
    ,adv_repay_int_accr_way_cd -- 提前还款计息方式代码
    ,adv_repay_int_accr_base_cd -- 提前还款计息基础代码
    ,adv_repay_amt_type_cd -- 提前还款金额类型代码
    ,adv_repay_amt -- 提前还款金额
    ,adv_rtn_pric -- 提前归还本金
    ,adv_rtn_int -- 提前归还利息
    ,adv_rtn_fee -- 提前归还费用
    ,penalty_amt -- 违约金金额
    ,deduct_seq_cd -- 扣款顺序代码
    ,onl_pay_flg -- 在线支付标志
    ,core_tran_flow_num -- 核心交易流水号
    ,core_tran_status_cd -- 核心交易状态代码
    ,appl_dt -- 申请日期
    ,core_tran_dt -- 核心交易日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,belong_strip_line_cd -- 所属条线代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_adv_repay_appl_h_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,tran_type_cd -- 交易类型代码
    ,rela_obj_flow_num -- 关联对象流水号
    ,rela_obj_type_name -- 关联对象类型名称
    ,rela_dubil_id -- 关联借据编号
    ,appl_status_cd -- 申请状态代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,acct_flg -- 账户标志
    ,acct_type_cd -- 账户类型代码
    ,repay_acct_name -- 还款账户名称
    ,repay_acct_id -- 还款账户编号
    ,actl_recv_pric -- 实收本金
    ,actl_recv_int -- 实收利息
    ,actl_recv_pnlt -- 实收罚息
    ,actl_recv_comp_int -- 实收复息
    ,actl_recv_fee -- 实收费用
    ,repay_tot_amt -- 还款总金额
    ,adv_repay_way_cd -- 提前还款方式代码
    ,adv_repay_int_accr_way_cd -- 提前还款计息方式代码
    ,adv_repay_int_accr_base_cd -- 提前还款计息基础代码
    ,adv_repay_amt_type_cd -- 提前还款金额类型代码
    ,adv_repay_amt -- 提前还款金额
    ,adv_rtn_pric -- 提前归还本金
    ,adv_rtn_int -- 提前归还利息
    ,adv_rtn_fee -- 提前归还费用
    ,penalty_amt -- 违约金金额
    ,deduct_seq_cd -- 扣款顺序代码
    ,onl_pay_flg -- 在线支付标志
    ,core_tran_flow_num -- 核心交易流水号
    ,core_tran_status_cd -- 核心交易状态代码
    ,appl_dt -- 申请日期
    ,core_tran_dt -- 核心交易日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,belong_strip_line_cd -- 所属条线代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.appl_id, o.appl_id) as appl_id -- 申请编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.appl_flow_num, o.appl_flow_num) as appl_flow_num -- 申请流水号
    ,nvl(n.tran_type_cd, o.tran_type_cd) as tran_type_cd -- 交易类型代码
    ,nvl(n.rela_obj_flow_num, o.rela_obj_flow_num) as rela_obj_flow_num -- 关联对象流水号
    ,nvl(n.rela_obj_type_name, o.rela_obj_type_name) as rela_obj_type_name -- 关联对象类型名称
    ,nvl(n.rela_dubil_id, o.rela_dubil_id) as rela_dubil_id -- 关联借据编号
    ,nvl(n.appl_status_cd, o.appl_status_cd) as appl_status_cd -- 申请状态代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.acct_flg, o.acct_flg) as acct_flg -- 账户标志
    ,nvl(n.acct_type_cd, o.acct_type_cd) as acct_type_cd -- 账户类型代码
    ,nvl(n.repay_acct_name, o.repay_acct_name) as repay_acct_name -- 还款账户名称
    ,nvl(n.repay_acct_id, o.repay_acct_id) as repay_acct_id -- 还款账户编号
    ,nvl(n.actl_recv_pric, o.actl_recv_pric) as actl_recv_pric -- 实收本金
    ,nvl(n.actl_recv_int, o.actl_recv_int) as actl_recv_int -- 实收利息
    ,nvl(n.actl_recv_pnlt, o.actl_recv_pnlt) as actl_recv_pnlt -- 实收罚息
    ,nvl(n.actl_recv_comp_int, o.actl_recv_comp_int) as actl_recv_comp_int -- 实收复息
    ,nvl(n.actl_recv_fee, o.actl_recv_fee) as actl_recv_fee -- 实收费用
    ,nvl(n.repay_tot_amt, o.repay_tot_amt) as repay_tot_amt -- 还款总金额
    ,nvl(n.adv_repay_way_cd, o.adv_repay_way_cd) as adv_repay_way_cd -- 提前还款方式代码
    ,nvl(n.adv_repay_int_accr_way_cd, o.adv_repay_int_accr_way_cd) as adv_repay_int_accr_way_cd -- 提前还款计息方式代码
    ,nvl(n.adv_repay_int_accr_base_cd, o.adv_repay_int_accr_base_cd) as adv_repay_int_accr_base_cd -- 提前还款计息基础代码
    ,nvl(n.adv_repay_amt_type_cd, o.adv_repay_amt_type_cd) as adv_repay_amt_type_cd -- 提前还款金额类型代码
    ,nvl(n.adv_repay_amt, o.adv_repay_amt) as adv_repay_amt -- 提前还款金额
    ,nvl(n.adv_rtn_pric, o.adv_rtn_pric) as adv_rtn_pric -- 提前归还本金
    ,nvl(n.adv_rtn_int, o.adv_rtn_int) as adv_rtn_int -- 提前归还利息
    ,nvl(n.adv_rtn_fee, o.adv_rtn_fee) as adv_rtn_fee -- 提前归还费用
    ,nvl(n.penalty_amt, o.penalty_amt) as penalty_amt -- 违约金金额
    ,nvl(n.deduct_seq_cd, o.deduct_seq_cd) as deduct_seq_cd -- 扣款顺序代码
    ,nvl(n.onl_pay_flg, o.onl_pay_flg) as onl_pay_flg -- 在线支付标志
    ,nvl(n.core_tran_flow_num, o.core_tran_flow_num) as core_tran_flow_num -- 核心交易流水号
    ,nvl(n.core_tran_status_cd, o.core_tran_status_cd) as core_tran_status_cd -- 核心交易状态代码
    ,nvl(n.appl_dt, o.appl_dt) as appl_dt -- 申请日期
    ,nvl(n.core_tran_dt, o.core_tran_dt) as core_tran_dt -- 核心交易日期
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.modif_dt, o.modif_dt) as modif_dt -- 变更日期
    ,nvl(n.belong_strip_line_cd, o.belong_strip_line_cd) as belong_strip_line_cd -- 所属条线代码
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.appl_flow_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.appl_flow_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.appl_flow_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_adv_repay_appl_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_adv_repay_appl_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.appl_flow_num = n.appl_flow_num
where (
        o.appl_id is null
        and o.lp_id is null
        and o.appl_flow_num is null
    )
    or (
        n.appl_id is null
        and n.lp_id is null
        and n.appl_flow_num is null
    )
    or (
        o.tran_type_cd <> n.tran_type_cd
        or o.rela_obj_flow_num <> n.rela_obj_flow_num
        or o.rela_obj_type_name <> n.rela_obj_type_name
        or o.rela_dubil_id <> n.rela_dubil_id
        or o.appl_status_cd <> n.appl_status_cd
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.prod_id <> n.prod_id
        or o.curr_cd <> n.curr_cd
        or o.acct_flg <> n.acct_flg
        or o.acct_type_cd <> n.acct_type_cd
        or o.repay_acct_name <> n.repay_acct_name
        or o.repay_acct_id <> n.repay_acct_id
        or o.actl_recv_pric <> n.actl_recv_pric
        or o.actl_recv_int <> n.actl_recv_int
        or o.actl_recv_pnlt <> n.actl_recv_pnlt
        or o.actl_recv_comp_int <> n.actl_recv_comp_int
        or o.actl_recv_fee <> n.actl_recv_fee
        or o.repay_tot_amt <> n.repay_tot_amt
        or o.adv_repay_way_cd <> n.adv_repay_way_cd
        or o.adv_repay_int_accr_way_cd <> n.adv_repay_int_accr_way_cd
        or o.adv_repay_int_accr_base_cd <> n.adv_repay_int_accr_base_cd
        or o.adv_repay_amt_type_cd <> n.adv_repay_amt_type_cd
        or o.adv_repay_amt <> n.adv_repay_amt
        or o.adv_rtn_pric <> n.adv_rtn_pric
        or o.adv_rtn_int <> n.adv_rtn_int
        or o.adv_rtn_fee <> n.adv_rtn_fee
        or o.penalty_amt <> n.penalty_amt
        or o.deduct_seq_cd <> n.deduct_seq_cd
        or o.onl_pay_flg <> n.onl_pay_flg
        or o.core_tran_flow_num <> n.core_tran_flow_num
        or o.core_tran_status_cd <> n.core_tran_status_cd
        or o.appl_dt <> n.appl_dt
        or o.core_tran_dt <> n.core_tran_dt
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.modif_dt <> n.modif_dt
        or o.belong_strip_line_cd <> n.belong_strip_line_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_adv_repay_appl_h_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,tran_type_cd -- 交易类型代码
    ,rela_obj_flow_num -- 关联对象流水号
    ,rela_obj_type_name -- 关联对象类型名称
    ,rela_dubil_id -- 关联借据编号
    ,appl_status_cd -- 申请状态代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,acct_flg -- 账户标志
    ,acct_type_cd -- 账户类型代码
    ,repay_acct_name -- 还款账户名称
    ,repay_acct_id -- 还款账户编号
    ,actl_recv_pric -- 实收本金
    ,actl_recv_int -- 实收利息
    ,actl_recv_pnlt -- 实收罚息
    ,actl_recv_comp_int -- 实收复息
    ,actl_recv_fee -- 实收费用
    ,repay_tot_amt -- 还款总金额
    ,adv_repay_way_cd -- 提前还款方式代码
    ,adv_repay_int_accr_way_cd -- 提前还款计息方式代码
    ,adv_repay_int_accr_base_cd -- 提前还款计息基础代码
    ,adv_repay_amt_type_cd -- 提前还款金额类型代码
    ,adv_repay_amt -- 提前还款金额
    ,adv_rtn_pric -- 提前归还本金
    ,adv_rtn_int -- 提前归还利息
    ,adv_rtn_fee -- 提前归还费用
    ,penalty_amt -- 违约金金额
    ,deduct_seq_cd -- 扣款顺序代码
    ,onl_pay_flg -- 在线支付标志
    ,core_tran_flow_num -- 核心交易流水号
    ,core_tran_status_cd -- 核心交易状态代码
    ,appl_dt -- 申请日期
    ,core_tran_dt -- 核心交易日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,belong_strip_line_cd -- 所属条线代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_adv_repay_appl_h_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,tran_type_cd -- 交易类型代码
    ,rela_obj_flow_num -- 关联对象流水号
    ,rela_obj_type_name -- 关联对象类型名称
    ,rela_dubil_id -- 关联借据编号
    ,appl_status_cd -- 申请状态代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,acct_flg -- 账户标志
    ,acct_type_cd -- 账户类型代码
    ,repay_acct_name -- 还款账户名称
    ,repay_acct_id -- 还款账户编号
    ,actl_recv_pric -- 实收本金
    ,actl_recv_int -- 实收利息
    ,actl_recv_pnlt -- 实收罚息
    ,actl_recv_comp_int -- 实收复息
    ,actl_recv_fee -- 实收费用
    ,repay_tot_amt -- 还款总金额
    ,adv_repay_way_cd -- 提前还款方式代码
    ,adv_repay_int_accr_way_cd -- 提前还款计息方式代码
    ,adv_repay_int_accr_base_cd -- 提前还款计息基础代码
    ,adv_repay_amt_type_cd -- 提前还款金额类型代码
    ,adv_repay_amt -- 提前还款金额
    ,adv_rtn_pric -- 提前归还本金
    ,adv_rtn_int -- 提前归还利息
    ,adv_rtn_fee -- 提前归还费用
    ,penalty_amt -- 违约金金额
    ,deduct_seq_cd -- 扣款顺序代码
    ,onl_pay_flg -- 在线支付标志
    ,core_tran_flow_num -- 核心交易流水号
    ,core_tran_status_cd -- 核心交易状态代码
    ,appl_dt -- 申请日期
    ,core_tran_dt -- 核心交易日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,belong_strip_line_cd -- 所属条线代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.appl_id -- 申请编号
    ,o.lp_id -- 法人编号
    ,o.appl_flow_num -- 申请流水号
    ,o.tran_type_cd -- 交易类型代码
    ,o.rela_obj_flow_num -- 关联对象流水号
    ,o.rela_obj_type_name -- 关联对象类型名称
    ,o.rela_dubil_id -- 关联借据编号
    ,o.appl_status_cd -- 申请状态代码
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.prod_id -- 产品编号
    ,o.curr_cd -- 币种代码
    ,o.acct_flg -- 账户标志
    ,o.acct_type_cd -- 账户类型代码
    ,o.repay_acct_name -- 还款账户名称
    ,o.repay_acct_id -- 还款账户编号
    ,o.actl_recv_pric -- 实收本金
    ,o.actl_recv_int -- 实收利息
    ,o.actl_recv_pnlt -- 实收罚息
    ,o.actl_recv_comp_int -- 实收复息
    ,o.actl_recv_fee -- 实收费用
    ,o.repay_tot_amt -- 还款总金额
    ,o.adv_repay_way_cd -- 提前还款方式代码
    ,o.adv_repay_int_accr_way_cd -- 提前还款计息方式代码
    ,o.adv_repay_int_accr_base_cd -- 提前还款计息基础代码
    ,o.adv_repay_amt_type_cd -- 提前还款金额类型代码
    ,o.adv_repay_amt -- 提前还款金额
    ,o.adv_rtn_pric -- 提前归还本金
    ,o.adv_rtn_int -- 提前归还利息
    ,o.adv_rtn_fee -- 提前归还费用
    ,o.penalty_amt -- 违约金金额
    ,o.deduct_seq_cd -- 扣款顺序代码
    ,o.onl_pay_flg -- 在线支付标志
    ,o.core_tran_flow_num -- 核心交易流水号
    ,o.core_tran_status_cd -- 核心交易状态代码
    ,o.appl_dt -- 申请日期
    ,o.core_tran_dt -- 核心交易日期
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.modif_dt -- 变更日期
    ,o.belong_strip_line_cd -- 所属条线代码
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
from ${iml_schema}.agt_loan_adv_repay_appl_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_adv_repay_appl_h_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.appl_flow_num = n.appl_flow_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_adv_repay_appl_h_icmsf1_cl d
        on
            o.appl_id = d.appl_id
            and o.lp_id = d.lp_id
            and o.appl_flow_num = d.appl_flow_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_adv_repay_appl_h;
--alter table ${iml_schema}.agt_loan_adv_repay_appl_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_adv_repay_appl_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_adv_repay_appl_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_adv_repay_appl_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_adv_repay_appl_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_adv_repay_appl_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_adv_repay_appl_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_adv_repay_appl_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_adv_repay_appl_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_adv_repay_appl_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_adv_repay_appl_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_adv_repay_appl_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_adv_repay_appl_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_adv_repay_appl_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
