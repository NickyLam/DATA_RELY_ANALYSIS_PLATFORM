/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_wph_out_acct_appl_icmsf1
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
alter table ${iml_schema}.agt_wph_out_acct_appl add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_wph_out_acct_appl_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wph_out_acct_appl partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_wph_out_acct_appl_icmsf1_tm purge;
drop table ${iml_schema}.agt_wph_out_acct_appl_icmsf1_op purge;
drop table ${iml_schema}.agt_wph_out_acct_appl_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wph_out_acct_appl_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,distr_amt -- 放款金额
    ,distr_dt -- 放款日期
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,distr_sucs_flg -- 放款成功标志
    ,enter_id -- 入账账户编号
    ,enter_name -- 入账账户名称
    ,enter_open_bank_name -- 入账账户开户行名称
    ,stl_acct_num_id -- 结算账号编号
    ,repay_way_cd -- 还款方式代码
    ,exp_dt -- 到期日期
    ,tran_dt -- 交易日期
    ,grace_days -- 宽限天数
    ,loan_org_id -- 贷款机构编号
    ,loan_arriv_dt_term -- 贷款到账日期
    ,loan_type_cd -- 贷款类型代码
    ,loan_usage_cd -- 贷款用途代码
    ,loan_tenor -- 贷款期限
    ,main_guar_way_cd -- 主担保方式代码
    ,int_set_way_cd -- 结息方式代码
    ,int_set_ped_cd -- 结息周期代码
    ,ped_corp_cd -- 周期单位代码
    ,int_rat_mode_cd -- 利率模式代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,float_range -- 浮动点数
    ,exec_int_rat -- 执行利率
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,out_acct_org_id -- 出账机构编号
    ,clear_tran_id -- 清算交易编号
    ,happ_dt -- 发生日期
    ,flow_dt -- 流程日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wph_out_acct_appl partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_wph_out_acct_appl_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wph_out_acct_appl partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_wph_out_acct_appl_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wph_out_acct_appl partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_wph_business_putout-1
insert into ${iml_schema}.agt_wph_out_acct_appl_icmsf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,distr_amt -- 放款金额
    ,distr_dt -- 放款日期
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,distr_sucs_flg -- 放款成功标志
    ,enter_id -- 入账账户编号
    ,enter_name -- 入账账户名称
    ,enter_open_bank_name -- 入账账户开户行名称
    ,stl_acct_num_id -- 结算账号编号
    ,repay_way_cd -- 还款方式代码
    ,exp_dt -- 到期日期
    ,tran_dt -- 交易日期
    ,grace_days -- 宽限天数
    ,loan_org_id -- 贷款机构编号
    ,loan_arriv_dt_term -- 贷款到账日期
    ,loan_type_cd -- 贷款类型代码
    ,loan_usage_cd -- 贷款用途代码
    ,loan_tenor -- 贷款期限
    ,main_guar_way_cd -- 主担保方式代码
    ,int_set_way_cd -- 结息方式代码
    ,int_set_ped_cd -- 结息周期代码
    ,ped_corp_cd -- 周期单位代码
    ,int_rat_mode_cd -- 利率模式代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,float_range -- 浮动点数
    ,exec_int_rat -- 执行利率
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,out_acct_org_id -- 出账机构编号
    ,clear_tran_id -- 清算交易编号
    ,happ_dt -- 发生日期
    ,flow_dt -- 流程日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206015'||P1.SERIALNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 出账流水号
    ,P1.CONTRACTSERIALNO -- 合同编号
    ,P1.PRODUCTID -- 产品编号
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CUSTOMERNAME -- 客户名称
    ,nvl(trim(P1.CERTTYPE),'0000') -- 证件类型代码
    ,P1.CERTID -- 证件号码
    ,P1.BUSINESSSUM -- 放款金额
    ,${iml_schema}.dateformat_max2(P1.PUTOUTDATE) -- 放款日期
    ,nvl(trim(P1.PAYMENTTYPE),'-') -- 放款支付方式代码
    ,decode(P1.LOANSTATUS,' ','-','0','1','1','0',P1.LOANSTATUS) -- 放款成功标志
    ,P1.LOANACCOUNTNO -- 入账账户编号
    ,P2.ACCTNAME -- 入账账户名称
    ,P2.BANKNAME -- 入账账户开户行名称
    ,P1.SETTLEMENTACCOUNT -- 结算账号编号
    ,nvl(trim(P1.REPAYTYPE),'-') -- 还款方式代码
    ,${iml_schema}.dateformat_max2(P1.MATURITY) -- 到期日期
    ,${iml_schema}.dateformat_min(P1.TRANDATE) -- 交易日期
    ,P1.GRACEDAYS -- 宽限天数
    ,P1.LENDINGORGID -- 贷款机构编号
    ,P2.PAYTIME -- 贷款到账日期
    ,nvl(trim(P1.LOANTYPE),'-') -- 贷款类型代码
    ,nvl(trim(P1.REASONCODE),'000000') -- 贷款用途代码
    ,to_number(nvl(trim(P1.TERM),'0')) -- 贷款期限
    ,nvl(trim(P1.VOUCHTYPE),'-') -- 主担保方式代码
    ,nvl(trim(P1.INTERESTREPAYCYCLE),'-') -- 结息方式代码
    ,nvl(trim(P1.CYCLEFREQ),'-') -- 结息周期代码
    ,nvl(trim(P1.TERMTYPE),'-') -- 周期单位代码
    ,nvl(trim(P1.RATEMODEL),'-') -- 利率模式代码
    ,nvl(trim(P1.BASERATETYPE),'-') -- 基准利率类型代码
    ,P1.BASERATE -- 基准利率
    ,nvl(trim(P1.RATEFLOATTYPE),'-') -- 利率浮动方式代码
    ,nvl(trim(P1.RATEADJUSTTYPE),'-') -- 利率调整方式代码
    ,P1.FLOATRANGE -- 浮动点数
    ,P1.EXECUTERATE -- 执行利率
    ,P1.OVERDUERATE -- 逾期利率
    ,nvl(trim(P1.OVERDUERATEFLOATTYPE),'-') -- 逾期利率浮动方式代码
    ,P1.OVERDUERATEFLOATVALUE -- 逾期利率浮动值
    ,P1.PUTOUTORGID -- 出账机构编号
    ,P2.PAYINSTREQNO -- 清算交易编号
    ,${iml_schema}.dateformat_min(P1.OCCURDATE) -- 发生日期
    ,${iml_schema}.dateformat_max2(P1.BIZDATE) -- 流程日期
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_wph_business_putout' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_wph_business_putout p1
   left join ${iol_schema}.icms_wph_loan_payment_result p2 
     on p1.internalkey = p2.internalkey
    and p2.start_dt <= to_date('${batch_date}','yyyymmdd') and p2.end_dt > to_date('${batch_date}','yyyymmdd')
  where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_wph_out_acct_appl_icmsf1_tm 
  	                                group by 
  	                                        appl_id
  	                                        ,lp_id
  	                                        ,out_acct_flow_num
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
        into ${iml_schema}.agt_wph_out_acct_appl_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,distr_amt -- 放款金额
    ,distr_dt -- 放款日期
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,distr_sucs_flg -- 放款成功标志
    ,enter_id -- 入账账户编号
    ,enter_name -- 入账账户名称
    ,enter_open_bank_name -- 入账账户开户行名称
    ,stl_acct_num_id -- 结算账号编号
    ,repay_way_cd -- 还款方式代码
    ,exp_dt -- 到期日期
    ,tran_dt -- 交易日期
    ,grace_days -- 宽限天数
    ,loan_org_id -- 贷款机构编号
    ,loan_arriv_dt_term -- 贷款到账日期
    ,loan_type_cd -- 贷款类型代码
    ,loan_usage_cd -- 贷款用途代码
    ,loan_tenor -- 贷款期限
    ,main_guar_way_cd -- 主担保方式代码
    ,int_set_way_cd -- 结息方式代码
    ,int_set_ped_cd -- 结息周期代码
    ,ped_corp_cd -- 周期单位代码
    ,int_rat_mode_cd -- 利率模式代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,float_range -- 浮动点数
    ,exec_int_rat -- 执行利率
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,out_acct_org_id -- 出账机构编号
    ,clear_tran_id -- 清算交易编号
    ,happ_dt -- 发生日期
    ,flow_dt -- 流程日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_wph_out_acct_appl_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,distr_amt -- 放款金额
    ,distr_dt -- 放款日期
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,distr_sucs_flg -- 放款成功标志
    ,enter_id -- 入账账户编号
    ,enter_name -- 入账账户名称
    ,enter_open_bank_name -- 入账账户开户行名称
    ,stl_acct_num_id -- 结算账号编号
    ,repay_way_cd -- 还款方式代码
    ,exp_dt -- 到期日期
    ,tran_dt -- 交易日期
    ,grace_days -- 宽限天数
    ,loan_org_id -- 贷款机构编号
    ,loan_arriv_dt_term -- 贷款到账日期
    ,loan_type_cd -- 贷款类型代码
    ,loan_usage_cd -- 贷款用途代码
    ,loan_tenor -- 贷款期限
    ,main_guar_way_cd -- 主担保方式代码
    ,int_set_way_cd -- 结息方式代码
    ,int_set_ped_cd -- 结息周期代码
    ,ped_corp_cd -- 周期单位代码
    ,int_rat_mode_cd -- 利率模式代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,float_range -- 浮动点数
    ,exec_int_rat -- 执行利率
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,out_acct_org_id -- 出账机构编号
    ,clear_tran_id -- 清算交易编号
    ,happ_dt -- 发生日期
    ,flow_dt -- 流程日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
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
    ,nvl(n.out_acct_flow_num, o.out_acct_flow_num) as out_acct_flow_num -- 出账流水号
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.distr_amt, o.distr_amt) as distr_amt -- 放款金额
    ,nvl(n.distr_dt, o.distr_dt) as distr_dt -- 放款日期
    ,nvl(n.distr_mode_pay_cd, o.distr_mode_pay_cd) as distr_mode_pay_cd -- 放款支付方式代码
    ,nvl(n.distr_sucs_flg, o.distr_sucs_flg) as distr_sucs_flg -- 放款成功标志
    ,nvl(n.enter_id, o.enter_id) as enter_id -- 入账账户编号
    ,nvl(n.enter_name, o.enter_name) as enter_name -- 入账账户名称
    ,nvl(n.enter_open_bank_name, o.enter_open_bank_name) as enter_open_bank_name -- 入账账户开户行名称
    ,nvl(n.stl_acct_num_id, o.stl_acct_num_id) as stl_acct_num_id -- 结算账号编号
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.grace_days, o.grace_days) as grace_days -- 宽限天数
    ,nvl(n.loan_org_id, o.loan_org_id) as loan_org_id -- 贷款机构编号
    ,nvl(n.loan_arriv_dt_term, o.loan_arriv_dt_term) as loan_arriv_dt_term -- 贷款到账日期
    ,nvl(n.loan_type_cd, o.loan_type_cd) as loan_type_cd -- 贷款类型代码
    ,nvl(n.loan_usage_cd, o.loan_usage_cd) as loan_usage_cd -- 贷款用途代码
    ,nvl(n.loan_tenor, o.loan_tenor) as loan_tenor -- 贷款期限
    ,nvl(n.main_guar_way_cd, o.main_guar_way_cd) as main_guar_way_cd -- 主担保方式代码
    ,nvl(n.int_set_way_cd, o.int_set_way_cd) as int_set_way_cd -- 结息方式代码
    ,nvl(n.int_set_ped_cd, o.int_set_ped_cd) as int_set_ped_cd -- 结息周期代码
    ,nvl(n.ped_corp_cd, o.ped_corp_cd) as ped_corp_cd -- 周期单位代码
    ,nvl(n.int_rat_mode_cd, o.int_rat_mode_cd) as int_rat_mode_cd -- 利率模式代码
    ,nvl(n.base_rat_type_cd, o.base_rat_type_cd) as base_rat_type_cd -- 基准利率类型代码
    ,nvl(n.base_rat, o.base_rat) as base_rat -- 基准利率
    ,nvl(n.int_rat_float_way_cd, o.int_rat_float_way_cd) as int_rat_float_way_cd -- 利率浮动方式代码
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.float_range, o.float_range) as float_range -- 浮动点数
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.ovdue_int_rat, o.ovdue_int_rat) as ovdue_int_rat -- 逾期利率
    ,nvl(n.ovdue_int_rat_float_way_cd, o.ovdue_int_rat_float_way_cd) as ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,nvl(n.ovdue_int_rat_flo_val, o.ovdue_int_rat_flo_val) as ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,nvl(n.out_acct_org_id, o.out_acct_org_id) as out_acct_org_id -- 出账机构编号
    ,nvl(n.clear_tran_id, o.clear_tran_id) as clear_tran_id -- 清算交易编号
    ,nvl(n.happ_dt, o.happ_dt) as happ_dt -- 发生日期
    ,nvl(n.flow_dt, o.flow_dt) as flow_dt -- 流程日期
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.out_acct_flow_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.out_acct_flow_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.out_acct_flow_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wph_out_acct_appl_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_wph_out_acct_appl_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.out_acct_flow_num = n.out_acct_flow_num
where (
        o.appl_id is null
        and o.lp_id is null
        and o.out_acct_flow_num is null
    )
    or (
        n.appl_id is null
        and n.lp_id is null
        and n.out_acct_flow_num is null
    )
    or (
        o.cont_id <> n.cont_id
        or o.prod_id <> n.prod_id
        or o.curr_cd <> n.curr_cd
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.distr_amt <> n.distr_amt
        or o.distr_dt <> n.distr_dt
        or o.distr_mode_pay_cd <> n.distr_mode_pay_cd
        or o.distr_sucs_flg <> n.distr_sucs_flg
        or o.enter_id <> n.enter_id
        or o.enter_name <> n.enter_name
        or o.enter_open_bank_name <> n.enter_open_bank_name
        or o.stl_acct_num_id <> n.stl_acct_num_id
        or o.repay_way_cd <> n.repay_way_cd
        or o.exp_dt <> n.exp_dt
        or o.tran_dt <> n.tran_dt
        or o.grace_days <> n.grace_days
        or o.loan_org_id <> n.loan_org_id
        or o.loan_arriv_dt_term <> n.loan_arriv_dt_term
        or o.loan_type_cd <> n.loan_type_cd
        or o.loan_usage_cd <> n.loan_usage_cd
        or o.loan_tenor <> n.loan_tenor
        or o.main_guar_way_cd <> n.main_guar_way_cd
        or o.int_set_way_cd <> n.int_set_way_cd
        or o.int_set_ped_cd <> n.int_set_ped_cd
        or o.ped_corp_cd <> n.ped_corp_cd
        or o.int_rat_mode_cd <> n.int_rat_mode_cd
        or o.base_rat_type_cd <> n.base_rat_type_cd
        or o.base_rat <> n.base_rat
        or o.int_rat_float_way_cd <> n.int_rat_float_way_cd
        or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
        or o.float_range <> n.float_range
        or o.exec_int_rat <> n.exec_int_rat
        or o.ovdue_int_rat <> n.ovdue_int_rat
        or o.ovdue_int_rat_float_way_cd <> n.ovdue_int_rat_float_way_cd
        or o.ovdue_int_rat_flo_val <> n.ovdue_int_rat_flo_val
        or o.out_acct_org_id <> n.out_acct_org_id
        or o.clear_tran_id <> n.clear_tran_id
        or o.happ_dt <> n.happ_dt
        or o.flow_dt <> n.flow_dt
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_wph_out_acct_appl_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,distr_amt -- 放款金额
    ,distr_dt -- 放款日期
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,distr_sucs_flg -- 放款成功标志
    ,enter_id -- 入账账户编号
    ,enter_name -- 入账账户名称
    ,enter_open_bank_name -- 入账账户开户行名称
    ,stl_acct_num_id -- 结算账号编号
    ,repay_way_cd -- 还款方式代码
    ,exp_dt -- 到期日期
    ,tran_dt -- 交易日期
    ,grace_days -- 宽限天数
    ,loan_org_id -- 贷款机构编号
    ,loan_arriv_dt_term -- 贷款到账日期
    ,loan_type_cd -- 贷款类型代码
    ,loan_usage_cd -- 贷款用途代码
    ,loan_tenor -- 贷款期限
    ,main_guar_way_cd -- 主担保方式代码
    ,int_set_way_cd -- 结息方式代码
    ,int_set_ped_cd -- 结息周期代码
    ,ped_corp_cd -- 周期单位代码
    ,int_rat_mode_cd -- 利率模式代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,float_range -- 浮动点数
    ,exec_int_rat -- 执行利率
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,out_acct_org_id -- 出账机构编号
    ,clear_tran_id -- 清算交易编号
    ,happ_dt -- 发生日期
    ,flow_dt -- 流程日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_wph_out_acct_appl_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,distr_amt -- 放款金额
    ,distr_dt -- 放款日期
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,distr_sucs_flg -- 放款成功标志
    ,enter_id -- 入账账户编号
    ,enter_name -- 入账账户名称
    ,enter_open_bank_name -- 入账账户开户行名称
    ,stl_acct_num_id -- 结算账号编号
    ,repay_way_cd -- 还款方式代码
    ,exp_dt -- 到期日期
    ,tran_dt -- 交易日期
    ,grace_days -- 宽限天数
    ,loan_org_id -- 贷款机构编号
    ,loan_arriv_dt_term -- 贷款到账日期
    ,loan_type_cd -- 贷款类型代码
    ,loan_usage_cd -- 贷款用途代码
    ,loan_tenor -- 贷款期限
    ,main_guar_way_cd -- 主担保方式代码
    ,int_set_way_cd -- 结息方式代码
    ,int_set_ped_cd -- 结息周期代码
    ,ped_corp_cd -- 周期单位代码
    ,int_rat_mode_cd -- 利率模式代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,float_range -- 浮动点数
    ,exec_int_rat -- 执行利率
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,out_acct_org_id -- 出账机构编号
    ,clear_tran_id -- 清算交易编号
    ,happ_dt -- 发生日期
    ,flow_dt -- 流程日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
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
    ,o.out_acct_flow_num -- 出账流水号
    ,o.cont_id -- 合同编号
    ,o.prod_id -- 产品编号
    ,o.curr_cd -- 币种代码
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.distr_amt -- 放款金额
    ,o.distr_dt -- 放款日期
    ,o.distr_mode_pay_cd -- 放款支付方式代码
    ,o.distr_sucs_flg -- 放款成功标志
    ,o.enter_id -- 入账账户编号
    ,o.enter_name -- 入账账户名称
    ,o.enter_open_bank_name -- 入账账户开户行名称
    ,o.stl_acct_num_id -- 结算账号编号
    ,o.repay_way_cd -- 还款方式代码
    ,o.exp_dt -- 到期日期
    ,o.tran_dt -- 交易日期
    ,o.grace_days -- 宽限天数
    ,o.loan_org_id -- 贷款机构编号
    ,o.loan_arriv_dt_term -- 贷款到账日期
    ,o.loan_type_cd -- 贷款类型代码
    ,o.loan_usage_cd -- 贷款用途代码
    ,o.loan_tenor -- 贷款期限
    ,o.main_guar_way_cd -- 主担保方式代码
    ,o.int_set_way_cd -- 结息方式代码
    ,o.int_set_ped_cd -- 结息周期代码
    ,o.ped_corp_cd -- 周期单位代码
    ,o.int_rat_mode_cd -- 利率模式代码
    ,o.base_rat_type_cd -- 基准利率类型代码
    ,o.base_rat -- 基准利率
    ,o.int_rat_float_way_cd -- 利率浮动方式代码
    ,o.int_rat_adj_way_cd -- 利率调整方式代码
    ,o.float_range -- 浮动点数
    ,o.exec_int_rat -- 执行利率
    ,o.ovdue_int_rat -- 逾期利率
    ,o.ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,o.ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,o.out_acct_org_id -- 出账机构编号
    ,o.clear_tran_id -- 清算交易编号
    ,o.happ_dt -- 发生日期
    ,o.flow_dt -- 流程日期
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
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
from ${iml_schema}.agt_wph_out_acct_appl_icmsf1_bk o
    left join ${iml_schema}.agt_wph_out_acct_appl_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.out_acct_flow_num = n.out_acct_flow_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_wph_out_acct_appl_icmsf1_cl d
        on
            o.appl_id = d.appl_id
            and o.lp_id = d.lp_id
            and o.out_acct_flow_num = d.out_acct_flow_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_wph_out_acct_appl;
--alter table ${iml_schema}.agt_wph_out_acct_appl truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_wph_out_acct_appl') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_wph_out_acct_appl drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_wph_out_acct_appl modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_wph_out_acct_appl exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_wph_out_acct_appl_icmsf1_cl;
alter table ${iml_schema}.agt_wph_out_acct_appl exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_wph_out_acct_appl_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_wph_out_acct_appl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_wph_out_acct_appl_icmsf1_tm purge;
drop table ${iml_schema}.agt_wph_out_acct_appl_icmsf1_op purge;
drop table ${iml_schema}.agt_wph_out_acct_appl_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_wph_out_acct_appl_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_wph_out_acct_appl', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
