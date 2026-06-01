/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_lx_out_acct_appl_icmsf1
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
alter table ${iml_schema}.agt_lx_out_acct_appl add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_lx_out_acct_appl_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lx_out_acct_appl partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_lx_out_acct_appl_icmsf1_tm purge;
drop table ${iml_schema}.agt_lx_out_acct_appl_icmsf1_op purge;
drop table ${iml_schema}.agt_lx_out_acct_appl_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lx_out_acct_appl_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,dubil_id -- 借据编号
    ,rela_cont_id -- 关联合同编号
    ,lim_appl_id -- 用信申请编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,org_id -- 机构编号
    ,prod_id -- 产品编号
    ,asset_crdt_id -- 资方授信编号
    ,asset_type_cd -- 资产类型代码
    ,distr_dt -- 放款日期
    ,distr_amt -- 放款金额
    ,curr_cd -- 币种代码
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,fix_out_acct_day -- 固定出账日
    ,fix_repay_day -- 固定还款日
    ,loan_tenor -- 贷款期限
    ,year_int_rat -- 年利率
    ,loan_usage -- 贷款用途
    ,mobile_no -- 手机号码
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_open_bank_num -- 收款账户开户行号
    ,recvbl_bank_card_num -- 收款银行卡号
    ,recvbl_bank_card_ibank_no -- 收款银行卡联行号
    ,repay_way_cd -- 还款方式代码
    ,fin_guar_mode_cd -- 联合融担标志
    ,apv_status_cd -- 审批状态代码
    ,core_tran_flow_num -- 核心交易流水号
    ,core_distr_sucs_flg -- 核心放款成功标志
    ,core_distr_fail_descb -- 核心放款失败描述
    ,out_line_tran_acct_sucs_flg -- 行外转账成功标志
    ,out_line_distr_fail_descb -- 行外放款失败描述
    ,core_revs_sucs_flg -- 核心冲正成功标志
    ,core_revs_fail_descb -- 核心冲正失败描述
    ,rgst_dt -- 登记日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,final_update_dt -- 最后更新日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_lx_out_acct_appl partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_lx_out_acct_appl_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lx_out_acct_appl partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_lx_out_acct_appl_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lx_out_acct_appl partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_lx_business_putout-1
insert into ${iml_schema}.agt_lx_out_acct_appl_icmsf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,dubil_id -- 借据编号
    ,rela_cont_id -- 关联合同编号
    ,lim_appl_id -- 用信申请编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,org_id -- 机构编号
    ,prod_id -- 产品编号
    ,asset_crdt_id -- 资方授信编号
    ,asset_type_cd -- 资产类型代码
    ,distr_dt -- 放款日期
    ,distr_amt -- 放款金额
    ,curr_cd -- 币种代码
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,fix_out_acct_day -- 固定出账日
    ,fix_repay_day -- 固定还款日
    ,loan_tenor -- 贷款期限
    ,year_int_rat -- 年利率
    ,loan_usage -- 贷款用途
    ,mobile_no -- 手机号码
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_open_bank_num -- 收款账户开户行号
    ,recvbl_bank_card_num -- 收款银行卡号
    ,recvbl_bank_card_ibank_no -- 收款银行卡联行号
    ,repay_way_cd -- 还款方式代码
    ,fin_guar_mode_cd -- 联合融担标志
    ,apv_status_cd -- 审批状态代码
    ,core_tran_flow_num -- 核心交易流水号
    ,core_distr_sucs_flg -- 核心放款成功标志
    ,core_distr_fail_descb -- 核心放款失败描述
    ,out_line_tran_acct_sucs_flg -- 行外转账成功标志
    ,out_line_distr_fail_descb -- 行外放款失败描述
    ,core_revs_sucs_flg -- 核心冲正成功标志
    ,core_revs_fail_descb -- 核心冲正失败描述
    ,rgst_dt -- 登记日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,final_update_dt -- 最后更新日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206017'||P1.SERIALNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 出账流水号
    ,P1.CAPITALLOANNO -- 借据编号
    ,P1.CONTRACTSERIALNO -- 关联合同编号
    ,P1.APPLYID -- 用信申请编号
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CUSTOMERNAME -- 客户名称
    ,P1.PARTNERCODE -- 机构编号
    ,P1.PRODUCTID -- 产品编号
    ,P1.CREDITNO -- 资方授信编号
    ,nvl(trim(P1.ORDERTYPE),'-') -- 资产类型代码
    ,P1.PAYMENTTIME -- 放款日期
    ,P1.BUSINESSSUM -- 放款金额
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,P1.STARTDATE -- 起始日期
    ,P1.MATURITY -- 到期日期
    ,P1.FIXEDBILLDAY -- 固定出账日
    ,P1.FIXEDREPAYDAY -- 固定还款日
    ,P1.LOANTERM -- 贷款期限
    ,P1.ANNUALRATE -- 年利率
    ,P1.LOANUSE -- 贷款用途
    ,P1.MOBILENO -- 手机号码
    ,P1.DEBITACCOUNTNAME -- 收款账户名称
    ,P1.DEBITOPENACCOUNTBANK -- 收款账户开户行号
    ,P1.DEBITACCOUNTNO -- 收款银行卡号
    ,P1.DEBITCNAPS -- 收款银行卡联行号
    ,nvl(trim(P1.REPAYTYPE),'-') -- 还款方式代码
    ,nvl(trim(P1.UNIONGUARANTEEFLAG),'-') -- 联合融担标志
    ,nvl(trim(P1.APPROVESTATUS),'-') -- 审批状态代码
    ,P1.HXFKSEQNUM -- 核心交易流水号
    ,nvl(trim(P1.HXFKSTATUS),'-') -- 核心放款成功标志
    ,P1.HXFKMESSAGE -- 核心放款失败描述
    ,nvl(trim(P1.HWZZSTATUS),'-') -- 行外转账成功标志
    ,P1.HWZZMESSAGE -- 行外放款失败描述
    ,nvl(trim(P1.HXCZSTATUS),'-') -- 核心冲正成功标志
    ,P1.HXCZMESSAGE -- 核心冲正失败描述
    ,P1.INPUTDATE -- 登记日期
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_lx_business_putout' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_lx_business_putout p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_lx_out_acct_appl_icmsf1_tm 
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
        into ${iml_schema}.agt_lx_out_acct_appl_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,dubil_id -- 借据编号
    ,rela_cont_id -- 关联合同编号
    ,lim_appl_id -- 用信申请编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,org_id -- 机构编号
    ,prod_id -- 产品编号
    ,asset_crdt_id -- 资方授信编号
    ,asset_type_cd -- 资产类型代码
    ,distr_dt -- 放款日期
    ,distr_amt -- 放款金额
    ,curr_cd -- 币种代码
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,fix_out_acct_day -- 固定出账日
    ,fix_repay_day -- 固定还款日
    ,loan_tenor -- 贷款期限
    ,year_int_rat -- 年利率
    ,loan_usage -- 贷款用途
    ,mobile_no -- 手机号码
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_open_bank_num -- 收款账户开户行号
    ,recvbl_bank_card_num -- 收款银行卡号
    ,recvbl_bank_card_ibank_no -- 收款银行卡联行号
    ,repay_way_cd -- 还款方式代码
    ,fin_guar_mode_cd -- 联合融担标志
    ,apv_status_cd -- 审批状态代码
    ,core_tran_flow_num -- 核心交易流水号
    ,core_distr_sucs_flg -- 核心放款成功标志
    ,core_distr_fail_descb -- 核心放款失败描述
    ,out_line_tran_acct_sucs_flg -- 行外转账成功标志
    ,out_line_distr_fail_descb -- 行外放款失败描述
    ,core_revs_sucs_flg -- 核心冲正成功标志
    ,core_revs_fail_descb -- 核心冲正失败描述
    ,rgst_dt -- 登记日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,final_update_dt -- 最后更新日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_lx_out_acct_appl_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,dubil_id -- 借据编号
    ,rela_cont_id -- 关联合同编号
    ,lim_appl_id -- 用信申请编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,org_id -- 机构编号
    ,prod_id -- 产品编号
    ,asset_crdt_id -- 资方授信编号
    ,asset_type_cd -- 资产类型代码
    ,distr_dt -- 放款日期
    ,distr_amt -- 放款金额
    ,curr_cd -- 币种代码
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,fix_out_acct_day -- 固定出账日
    ,fix_repay_day -- 固定还款日
    ,loan_tenor -- 贷款期限
    ,year_int_rat -- 年利率
    ,loan_usage -- 贷款用途
    ,mobile_no -- 手机号码
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_open_bank_num -- 收款账户开户行号
    ,recvbl_bank_card_num -- 收款银行卡号
    ,recvbl_bank_card_ibank_no -- 收款银行卡联行号
    ,repay_way_cd -- 还款方式代码
    ,fin_guar_mode_cd -- 联合融担标志
    ,apv_status_cd -- 审批状态代码
    ,core_tran_flow_num -- 核心交易流水号
    ,core_distr_sucs_flg -- 核心放款成功标志
    ,core_distr_fail_descb -- 核心放款失败描述
    ,out_line_tran_acct_sucs_flg -- 行外转账成功标志
    ,out_line_distr_fail_descb -- 行外放款失败描述
    ,core_revs_sucs_flg -- 核心冲正成功标志
    ,core_revs_fail_descb -- 核心冲正失败描述
    ,rgst_dt -- 登记日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,final_update_dt -- 最后更新日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
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
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.rela_cont_id, o.rela_cont_id) as rela_cont_id -- 关联合同编号
    ,nvl(n.lim_appl_id, o.lim_appl_id) as lim_appl_id -- 用信申请编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.asset_crdt_id, o.asset_crdt_id) as asset_crdt_id -- 资方授信编号
    ,nvl(n.asset_type_cd, o.asset_type_cd) as asset_type_cd -- 资产类型代码
    ,nvl(n.distr_dt, o.distr_dt) as distr_dt -- 放款日期
    ,nvl(n.distr_amt, o.distr_amt) as distr_amt -- 放款金额
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.begin_dt, o.begin_dt) as begin_dt -- 起始日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.fix_out_acct_day, o.fix_out_acct_day) as fix_out_acct_day -- 固定出账日
    ,nvl(n.fix_repay_day, o.fix_repay_day) as fix_repay_day -- 固定还款日
    ,nvl(n.loan_tenor, o.loan_tenor) as loan_tenor -- 贷款期限
    ,nvl(n.year_int_rat, o.year_int_rat) as year_int_rat -- 年利率
    ,nvl(n.loan_usage, o.loan_usage) as loan_usage -- 贷款用途
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 手机号码
    ,nvl(n.recvbl_acct_name, o.recvbl_acct_name) as recvbl_acct_name -- 收款账户名称
    ,nvl(n.recvbl_acct_open_bank_num, o.recvbl_acct_open_bank_num) as recvbl_acct_open_bank_num -- 收款账户开户行号
    ,nvl(n.recvbl_bank_card_num, o.recvbl_bank_card_num) as recvbl_bank_card_num -- 收款银行卡号
    ,nvl(n.recvbl_bank_card_ibank_no, o.recvbl_bank_card_ibank_no) as recvbl_bank_card_ibank_no -- 收款银行卡联行号
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.fin_guar_mode_cd, o.fin_guar_mode_cd) as fin_guar_mode_cd -- 联合融担标志
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.core_tran_flow_num, o.core_tran_flow_num) as core_tran_flow_num -- 核心交易流水号
    ,nvl(n.core_distr_sucs_flg, o.core_distr_sucs_flg) as core_distr_sucs_flg -- 核心放款成功标志
    ,nvl(n.core_distr_fail_descb, o.core_distr_fail_descb) as core_distr_fail_descb -- 核心放款失败描述
    ,nvl(n.out_line_tran_acct_sucs_flg, o.out_line_tran_acct_sucs_flg) as out_line_tran_acct_sucs_flg -- 行外转账成功标志
    ,nvl(n.out_line_distr_fail_descb, o.out_line_distr_fail_descb) as out_line_distr_fail_descb -- 行外放款失败描述
    ,nvl(n.core_revs_sucs_flg, o.core_revs_sucs_flg) as core_revs_sucs_flg -- 核心冲正成功标志
    ,nvl(n.core_revs_fail_descb, o.core_revs_fail_descb) as core_revs_fail_descb -- 核心冲正失败描述
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
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
from ${iml_schema}.agt_lx_out_acct_appl_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_lx_out_acct_appl_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.dubil_id <> n.dubil_id
        or o.rela_cont_id <> n.rela_cont_id
        or o.lim_appl_id <> n.lim_appl_id
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.org_id <> n.org_id
        or o.prod_id <> n.prod_id
        or o.asset_crdt_id <> n.asset_crdt_id
        or o.asset_type_cd <> n.asset_type_cd
        or o.distr_dt <> n.distr_dt
        or o.distr_amt <> n.distr_amt
        or o.curr_cd <> n.curr_cd
        or o.begin_dt <> n.begin_dt
        or o.exp_dt <> n.exp_dt
        or o.fix_out_acct_day <> n.fix_out_acct_day
        or o.fix_repay_day <> n.fix_repay_day
        or o.loan_tenor <> n.loan_tenor
        or o.year_int_rat <> n.year_int_rat
        or o.loan_usage <> n.loan_usage
        or o.mobile_no <> n.mobile_no
        or o.recvbl_acct_name <> n.recvbl_acct_name
        or o.recvbl_acct_open_bank_num <> n.recvbl_acct_open_bank_num
        or o.recvbl_bank_card_num <> n.recvbl_bank_card_num
        or o.recvbl_bank_card_ibank_no <> n.recvbl_bank_card_ibank_no
        or o.repay_way_cd <> n.repay_way_cd
        or o.fin_guar_mode_cd <> n.fin_guar_mode_cd
        or o.apv_status_cd <> n.apv_status_cd
        or o.core_tran_flow_num <> n.core_tran_flow_num
        or o.core_distr_sucs_flg <> n.core_distr_sucs_flg
        or o.core_distr_fail_descb <> n.core_distr_fail_descb
        or o.out_line_tran_acct_sucs_flg <> n.out_line_tran_acct_sucs_flg
        or o.out_line_distr_fail_descb <> n.out_line_distr_fail_descb
        or o.core_revs_sucs_flg <> n.core_revs_sucs_flg
        or o.core_revs_fail_descb <> n.core_revs_fail_descb
        or o.rgst_dt <> n.rgst_dt
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.final_update_dt <> n.final_update_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_lx_out_acct_appl_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,dubil_id -- 借据编号
    ,rela_cont_id -- 关联合同编号
    ,lim_appl_id -- 用信申请编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,org_id -- 机构编号
    ,prod_id -- 产品编号
    ,asset_crdt_id -- 资方授信编号
    ,asset_type_cd -- 资产类型代码
    ,distr_dt -- 放款日期
    ,distr_amt -- 放款金额
    ,curr_cd -- 币种代码
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,fix_out_acct_day -- 固定出账日
    ,fix_repay_day -- 固定还款日
    ,loan_tenor -- 贷款期限
    ,year_int_rat -- 年利率
    ,loan_usage -- 贷款用途
    ,mobile_no -- 手机号码
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_open_bank_num -- 收款账户开户行号
    ,recvbl_bank_card_num -- 收款银行卡号
    ,recvbl_bank_card_ibank_no -- 收款银行卡联行号
    ,repay_way_cd -- 还款方式代码
    ,fin_guar_mode_cd -- 联合融担标志
    ,apv_status_cd -- 审批状态代码
    ,core_tran_flow_num -- 核心交易流水号
    ,core_distr_sucs_flg -- 核心放款成功标志
    ,core_distr_fail_descb -- 核心放款失败描述
    ,out_line_tran_acct_sucs_flg -- 行外转账成功标志
    ,out_line_distr_fail_descb -- 行外放款失败描述
    ,core_revs_sucs_flg -- 核心冲正成功标志
    ,core_revs_fail_descb -- 核心冲正失败描述
    ,rgst_dt -- 登记日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,final_update_dt -- 最后更新日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_lx_out_acct_appl_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,dubil_id -- 借据编号
    ,rela_cont_id -- 关联合同编号
    ,lim_appl_id -- 用信申请编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,org_id -- 机构编号
    ,prod_id -- 产品编号
    ,asset_crdt_id -- 资方授信编号
    ,asset_type_cd -- 资产类型代码
    ,distr_dt -- 放款日期
    ,distr_amt -- 放款金额
    ,curr_cd -- 币种代码
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,fix_out_acct_day -- 固定出账日
    ,fix_repay_day -- 固定还款日
    ,loan_tenor -- 贷款期限
    ,year_int_rat -- 年利率
    ,loan_usage -- 贷款用途
    ,mobile_no -- 手机号码
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_open_bank_num -- 收款账户开户行号
    ,recvbl_bank_card_num -- 收款银行卡号
    ,recvbl_bank_card_ibank_no -- 收款银行卡联行号
    ,repay_way_cd -- 还款方式代码
    ,fin_guar_mode_cd -- 联合融担标志
    ,apv_status_cd -- 审批状态代码
    ,core_tran_flow_num -- 核心交易流水号
    ,core_distr_sucs_flg -- 核心放款成功标志
    ,core_distr_fail_descb -- 核心放款失败描述
    ,out_line_tran_acct_sucs_flg -- 行外转账成功标志
    ,out_line_distr_fail_descb -- 行外放款失败描述
    ,core_revs_sucs_flg -- 核心冲正成功标志
    ,core_revs_fail_descb -- 核心冲正失败描述
    ,rgst_dt -- 登记日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,final_update_dt -- 最后更新日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
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
    ,o.dubil_id -- 借据编号
    ,o.rela_cont_id -- 关联合同编号
    ,o.lim_appl_id -- 用信申请编号
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.org_id -- 机构编号
    ,o.prod_id -- 产品编号
    ,o.asset_crdt_id -- 资方授信编号
    ,o.asset_type_cd -- 资产类型代码
    ,o.distr_dt -- 放款日期
    ,o.distr_amt -- 放款金额
    ,o.curr_cd -- 币种代码
    ,o.begin_dt -- 起始日期
    ,o.exp_dt -- 到期日期
    ,o.fix_out_acct_day -- 固定出账日
    ,o.fix_repay_day -- 固定还款日
    ,o.loan_tenor -- 贷款期限
    ,o.year_int_rat -- 年利率
    ,o.loan_usage -- 贷款用途
    ,o.mobile_no -- 手机号码
    ,o.recvbl_acct_name -- 收款账户名称
    ,o.recvbl_acct_open_bank_num -- 收款账户开户行号
    ,o.recvbl_bank_card_num -- 收款银行卡号
    ,o.recvbl_bank_card_ibank_no -- 收款银行卡联行号
    ,o.repay_way_cd -- 还款方式代码
    ,o.fin_guar_mode_cd -- 联合融担标志
    ,o.apv_status_cd -- 审批状态代码
    ,o.core_tran_flow_num -- 核心交易流水号
    ,o.core_distr_sucs_flg -- 核心放款成功标志
    ,o.core_distr_fail_descb -- 核心放款失败描述
    ,o.out_line_tran_acct_sucs_flg -- 行外转账成功标志
    ,o.out_line_distr_fail_descb -- 行外放款失败描述
    ,o.core_revs_sucs_flg -- 核心冲正成功标志
    ,o.core_revs_fail_descb -- 核心冲正失败描述
    ,o.rgst_dt -- 登记日期
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.final_update_dt -- 最后更新日期
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
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
from ${iml_schema}.agt_lx_out_acct_appl_icmsf1_bk o
    left join ${iml_schema}.agt_lx_out_acct_appl_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.out_acct_flow_num = n.out_acct_flow_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_lx_out_acct_appl_icmsf1_cl d
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
--truncate table ${iml_schema}.agt_lx_out_acct_appl;
--alter table ${iml_schema}.agt_lx_out_acct_appl truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_lx_out_acct_appl') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_lx_out_acct_appl drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_lx_out_acct_appl modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_lx_out_acct_appl exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_lx_out_acct_appl_icmsf1_cl;
alter table ${iml_schema}.agt_lx_out_acct_appl exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_lx_out_acct_appl_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_lx_out_acct_appl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_lx_out_acct_appl_icmsf1_tm purge;
drop table ${iml_schema}.agt_lx_out_acct_appl_icmsf1_op purge;
drop table ${iml_schema}.agt_lx_out_acct_appl_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_lx_out_acct_appl_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_lx_out_acct_appl', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
