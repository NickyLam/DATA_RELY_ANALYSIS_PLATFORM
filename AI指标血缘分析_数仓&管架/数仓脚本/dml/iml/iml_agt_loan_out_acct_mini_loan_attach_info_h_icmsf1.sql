/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_out_acct_mini_loan_attach_info_h_icmsf1
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
alter table ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,recver_open_bank_cate_cd -- 收款人开户行类别代码
    ,recver_open_bank_rg_cd -- 收款人开户行地区代码
    ,mini_loan_stl_acct_id -- 微贷结算账户编号
    ,loan_type_cd -- 贷款类型代码
    ,prep_entred_tran_cnt -- 待受托划款笔数
    ,tran_type_cd -- 交易类型代码
    ,bank_int_flg -- 行内标志
    ,init_tran_dt -- 原交易日期
    ,init_tran_flow_num -- 原交易流水号
    ,loan_tenor_cd -- 贷款期限代码
    ,guar_way_cd -- 担保方式代码
    ,mode_pay_cd -- 支付方式代码
    ,pay_way_cd -- 付款方式代码
    ,mini_loan_repay_num_id_one -- 微贷还款账户编号一
    ,mini_loan_repay_num_id_two -- 微贷还款账户编号二
    ,entr_pay_acct_id -- 受托支付账户编号
    ,entr_pay_acct_name -- 受托支付账户名称
    ,tran_dt -- 交易日期
    ,loan_repay_int_intrv -- 贷款还息间隔
    ,recv_bank_no -- 收款行行号
    ,recv_bank_name -- 收款行名称
    ,cust_id -- 客户编号
    ,tran_flow_num -- 交易流水号
    ,enter_acct_org_id -- 入账机构编号
    ,out_acct_status_cd -- 出账状态代码
    ,repay_comnt_descb -- 还款说明描述
    ,prtcpt_deduct_flg -- 参与批扣标志
    ,tenor_type_cd -- 期限类型代码
    ,user_id -- 用户编号
    ,out_acct_appl_dt -- 出账申请日期
    ,actl_out_acct_dt -- 实际出账日期
    ,stud_loan_prod_id -- 助贷产品编号
    ,major_guartor_id -- 主要担保人编号
    ,major_guartor_name -- 主要担保人名称
    ,secd_repay_acct_name -- 第二还款账户名称
    ,secd_repay_acct_id -- 第二还款账户编号
    ,forwd_tran_dt -- 正向交易日期
    ,forwd_tran_flow_num -- 正向交易流水号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_bp_upl_loan-1
insert into ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h_icmsf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,recver_open_bank_cate_cd -- 收款人开户行类别代码
    ,recver_open_bank_rg_cd -- 收款人开户行地区代码
    ,mini_loan_stl_acct_id -- 微贷结算账户编号
    ,loan_type_cd -- 贷款类型代码
    ,prep_entred_tran_cnt -- 待受托划款笔数
    ,tran_type_cd -- 交易类型代码
    ,bank_int_flg -- 行内标志
    ,init_tran_dt -- 原交易日期
    ,init_tran_flow_num -- 原交易流水号
    ,loan_tenor_cd -- 贷款期限代码
    ,guar_way_cd -- 担保方式代码
    ,mode_pay_cd -- 支付方式代码
    ,pay_way_cd -- 付款方式代码
    ,mini_loan_repay_num_id_one -- 微贷还款账户编号一
    ,mini_loan_repay_num_id_two -- 微贷还款账户编号二
    ,entr_pay_acct_id -- 受托支付账户编号
    ,entr_pay_acct_name -- 受托支付账户名称
    ,tran_dt -- 交易日期
    ,loan_repay_int_intrv -- 贷款还息间隔
    ,recv_bank_no -- 收款行行号
    ,recv_bank_name -- 收款行名称
    ,cust_id -- 客户编号
    ,tran_flow_num -- 交易流水号
    ,enter_acct_org_id -- 入账机构编号
    ,out_acct_status_cd -- 出账状态代码
    ,repay_comnt_descb -- 还款说明描述
    ,prtcpt_deduct_flg -- 参与批扣标志
    ,tenor_type_cd -- 期限类型代码
    ,user_id -- 用户编号
    ,out_acct_appl_dt -- 出账申请日期
    ,actl_out_acct_dt -- 实际出账日期
    ,stud_loan_prod_id -- 助贷产品编号
    ,major_guartor_id -- 主要担保人编号
    ,major_guartor_name -- 主要担保人名称
    ,secd_repay_acct_name -- 第二还款账户名称
    ,secd_repay_acct_id -- 第二还款账户编号
    ,forwd_tran_dt -- 正向交易日期
    ,forwd_tran_flow_num -- 正向交易流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206001'||P1.SERIALNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 出账流水号
    ,P1.PAYBANKKINDCODE -- 收款人开户行类别代码
    ,nvl(trim(P1.PAYBANKADDCODE),'000000') -- 收款人开户行地区代码
    ,P1.UPLACCOUNTNO -- 微贷结算账户编号
    ,nvl(trim(P1.LOANTYPE),'-') -- 贷款类型代码
    ,P1.STAYENTRUSTNUMBER -- 待受托划款笔数
    ,nvl(trim(P1.EXCHANGETYPE),'-') -- 交易类型代码
    ,nvl(trim(P1.BANKINOUTFLAG),'-') -- 行内标志
    ,P1.OLDTRADEDATE -- 原交易日期
    ,P1.OLDTRADESERIALNO -- 原交易流水号
    ,nvl(trim(P1.LOANTERM),'-') -- 贷款期限代码
    ,nvl(trim(P1.VOUCHMODE),'-') -- 担保方式代码
    ,nvl(trim(P1.PAYMENTMODE),'0') -- 支付方式代码
    ,nvl(trim(P1.REPAYMODE),'-') -- 付款方式代码
    ,P1.UPLPAYACCOUNTNO1 -- 微贷还款账户编号一
    ,P1.UPLPAYACCOUNTNO2 -- 微贷还款账户编号二
    ,P1.TRUSTPAYACCOUNTNO -- 受托支付账户编号
    ,P1.TRUSTPAYACCOUNTNAME -- 受托支付账户名称
    ,P1.TRADEDATE -- 交易日期
    ,P1.PAYPRININTVL -- 贷款还息间隔
    ,P1.PAYBANKNO -- 收款行行号
    ,P1.PAYBANKNAME -- 收款行名称
    ,P1.MFCUSTOMERID -- 客户编号
    ,P1.BUSINESSSERIALNO -- 交易流水号
    ,P1.INCOMEORGID -- 入账机构编号
    ,nvl(trim(P1.PUTOUTSTATUS),'-') -- 出账状态代码
    ,P1.PAYSOURCE -- 还款说明描述
    ,P1.BATCHPAYMENTFLAG -- 参与批扣标志
    ,nvl(trim(P1.LOANKIND),'-') -- 期限类型代码
    ,P1.USERID -- 用户编号
    ,P1.BEGINTIME -- 出账申请日期
    ,P1.ACTUALBEGINTIME -- 实际出账日期
    ,P1.SUBBUSINESSTYPE -- 助贷产品编号
    ,P1.WARRANTORID -- 主要担保人编号
    ,P1.WARRANTOR -- 主要担保人名称
    ,P1.PAYACCOUNTNAME2 -- 第二还款账户名称
    ,P1.PAYACCOUNTNO2 -- 第二还款账户编号
    ,P1.CRSTRANDATE -- 正向交易日期
    ,P1.CRSTRANSEQNO -- 正向交易流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_bp_upl_loan' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_bp_upl_loan p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h_icmsf1_tm 
  	                                group by 
  	                                        appl_id
  	                                        ,lp_id
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
        into ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,recver_open_bank_cate_cd -- 收款人开户行类别代码
    ,recver_open_bank_rg_cd -- 收款人开户行地区代码
    ,mini_loan_stl_acct_id -- 微贷结算账户编号
    ,loan_type_cd -- 贷款类型代码
    ,prep_entred_tran_cnt -- 待受托划款笔数
    ,tran_type_cd -- 交易类型代码
    ,bank_int_flg -- 行内标志
    ,init_tran_dt -- 原交易日期
    ,init_tran_flow_num -- 原交易流水号
    ,loan_tenor_cd -- 贷款期限代码
    ,guar_way_cd -- 担保方式代码
    ,mode_pay_cd -- 支付方式代码
    ,pay_way_cd -- 付款方式代码
    ,mini_loan_repay_num_id_one -- 微贷还款账户编号一
    ,mini_loan_repay_num_id_two -- 微贷还款账户编号二
    ,entr_pay_acct_id -- 受托支付账户编号
    ,entr_pay_acct_name -- 受托支付账户名称
    ,tran_dt -- 交易日期
    ,loan_repay_int_intrv -- 贷款还息间隔
    ,recv_bank_no -- 收款行行号
    ,recv_bank_name -- 收款行名称
    ,cust_id -- 客户编号
    ,tran_flow_num -- 交易流水号
    ,enter_acct_org_id -- 入账机构编号
    ,out_acct_status_cd -- 出账状态代码
    ,repay_comnt_descb -- 还款说明描述
    ,prtcpt_deduct_flg -- 参与批扣标志
    ,tenor_type_cd -- 期限类型代码
    ,user_id -- 用户编号
    ,out_acct_appl_dt -- 出账申请日期
    ,actl_out_acct_dt -- 实际出账日期
    ,stud_loan_prod_id -- 助贷产品编号
    ,major_guartor_id -- 主要担保人编号
    ,major_guartor_name -- 主要担保人名称
    ,secd_repay_acct_name -- 第二还款账户名称
    ,secd_repay_acct_id -- 第二还款账户编号
    ,forwd_tran_dt -- 正向交易日期
    ,forwd_tran_flow_num -- 正向交易流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,recver_open_bank_cate_cd -- 收款人开户行类别代码
    ,recver_open_bank_rg_cd -- 收款人开户行地区代码
    ,mini_loan_stl_acct_id -- 微贷结算账户编号
    ,loan_type_cd -- 贷款类型代码
    ,prep_entred_tran_cnt -- 待受托划款笔数
    ,tran_type_cd -- 交易类型代码
    ,bank_int_flg -- 行内标志
    ,init_tran_dt -- 原交易日期
    ,init_tran_flow_num -- 原交易流水号
    ,loan_tenor_cd -- 贷款期限代码
    ,guar_way_cd -- 担保方式代码
    ,mode_pay_cd -- 支付方式代码
    ,pay_way_cd -- 付款方式代码
    ,mini_loan_repay_num_id_one -- 微贷还款账户编号一
    ,mini_loan_repay_num_id_two -- 微贷还款账户编号二
    ,entr_pay_acct_id -- 受托支付账户编号
    ,entr_pay_acct_name -- 受托支付账户名称
    ,tran_dt -- 交易日期
    ,loan_repay_int_intrv -- 贷款还息间隔
    ,recv_bank_no -- 收款行行号
    ,recv_bank_name -- 收款行名称
    ,cust_id -- 客户编号
    ,tran_flow_num -- 交易流水号
    ,enter_acct_org_id -- 入账机构编号
    ,out_acct_status_cd -- 出账状态代码
    ,repay_comnt_descb -- 还款说明描述
    ,prtcpt_deduct_flg -- 参与批扣标志
    ,tenor_type_cd -- 期限类型代码
    ,user_id -- 用户编号
    ,out_acct_appl_dt -- 出账申请日期
    ,actl_out_acct_dt -- 实际出账日期
    ,stud_loan_prod_id -- 助贷产品编号
    ,major_guartor_id -- 主要担保人编号
    ,major_guartor_name -- 主要担保人名称
    ,secd_repay_acct_name -- 第二还款账户名称
    ,secd_repay_acct_id -- 第二还款账户编号
    ,forwd_tran_dt -- 正向交易日期
    ,forwd_tran_flow_num -- 正向交易流水号
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
    ,nvl(n.recver_open_bank_cate_cd, o.recver_open_bank_cate_cd) as recver_open_bank_cate_cd -- 收款人开户行类别代码
    ,nvl(n.recver_open_bank_rg_cd, o.recver_open_bank_rg_cd) as recver_open_bank_rg_cd -- 收款人开户行地区代码
    ,nvl(n.mini_loan_stl_acct_id, o.mini_loan_stl_acct_id) as mini_loan_stl_acct_id -- 微贷结算账户编号
    ,nvl(n.loan_type_cd, o.loan_type_cd) as loan_type_cd -- 贷款类型代码
    ,nvl(n.prep_entred_tran_cnt, o.prep_entred_tran_cnt) as prep_entred_tran_cnt -- 待受托划款笔数
    ,nvl(n.tran_type_cd, o.tran_type_cd) as tran_type_cd -- 交易类型代码
    ,nvl(n.bank_int_flg, o.bank_int_flg) as bank_int_flg -- 行内标志
    ,nvl(n.init_tran_dt, o.init_tran_dt) as init_tran_dt -- 原交易日期
    ,nvl(n.init_tran_flow_num, o.init_tran_flow_num) as init_tran_flow_num -- 原交易流水号
    ,nvl(n.loan_tenor_cd, o.loan_tenor_cd) as loan_tenor_cd -- 贷款期限代码
    ,nvl(n.guar_way_cd, o.guar_way_cd) as guar_way_cd -- 担保方式代码
    ,nvl(n.mode_pay_cd, o.mode_pay_cd) as mode_pay_cd -- 支付方式代码
    ,nvl(n.pay_way_cd, o.pay_way_cd) as pay_way_cd -- 付款方式代码
    ,nvl(n.mini_loan_repay_num_id_one, o.mini_loan_repay_num_id_one) as mini_loan_repay_num_id_one -- 微贷还款账户编号一
    ,nvl(n.mini_loan_repay_num_id_two, o.mini_loan_repay_num_id_two) as mini_loan_repay_num_id_two -- 微贷还款账户编号二
    ,nvl(n.entr_pay_acct_id, o.entr_pay_acct_id) as entr_pay_acct_id -- 受托支付账户编号
    ,nvl(n.entr_pay_acct_name, o.entr_pay_acct_name) as entr_pay_acct_name -- 受托支付账户名称
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.loan_repay_int_intrv, o.loan_repay_int_intrv) as loan_repay_int_intrv -- 贷款还息间隔
    ,nvl(n.recv_bank_no, o.recv_bank_no) as recv_bank_no -- 收款行行号
    ,nvl(n.recv_bank_name, o.recv_bank_name) as recv_bank_name -- 收款行名称
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.enter_acct_org_id, o.enter_acct_org_id) as enter_acct_org_id -- 入账机构编号
    ,nvl(n.out_acct_status_cd, o.out_acct_status_cd) as out_acct_status_cd -- 出账状态代码
    ,nvl(n.repay_comnt_descb, o.repay_comnt_descb) as repay_comnt_descb -- 还款说明描述
    ,nvl(n.prtcpt_deduct_flg, o.prtcpt_deduct_flg) as prtcpt_deduct_flg -- 参与批扣标志
    ,nvl(n.tenor_type_cd, o.tenor_type_cd) as tenor_type_cd -- 期限类型代码
    ,nvl(n.user_id, o.user_id) as user_id -- 用户编号
    ,nvl(n.out_acct_appl_dt, o.out_acct_appl_dt) as out_acct_appl_dt -- 出账申请日期
    ,nvl(n.actl_out_acct_dt, o.actl_out_acct_dt) as actl_out_acct_dt -- 实际出账日期
    ,nvl(n.stud_loan_prod_id, o.stud_loan_prod_id) as stud_loan_prod_id -- 助贷产品编号
    ,nvl(n.major_guartor_id, o.major_guartor_id) as major_guartor_id -- 主要担保人编号
    ,nvl(n.major_guartor_name, o.major_guartor_name) as major_guartor_name -- 主要担保人名称
    ,nvl(n.secd_repay_acct_name, o.secd_repay_acct_name) as secd_repay_acct_name -- 第二还款账户名称
    ,nvl(n.secd_repay_acct_id, o.secd_repay_acct_id) as secd_repay_acct_id -- 第二还款账户编号
    ,nvl(n.forwd_tran_dt, o.forwd_tran_dt) as forwd_tran_dt -- 正向交易日期
    ,nvl(n.forwd_tran_flow_num, o.forwd_tran_flow_num) as forwd_tran_flow_num -- 正向交易流水号
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
where (
        o.appl_id is null
        and o.lp_id is null
    )
    or (
        n.appl_id is null
        and n.lp_id is null
    )
    or (
        o.out_acct_flow_num <> n.out_acct_flow_num
        or o.recver_open_bank_cate_cd <> n.recver_open_bank_cate_cd
        or o.recver_open_bank_rg_cd <> n.recver_open_bank_rg_cd
        or o.mini_loan_stl_acct_id <> n.mini_loan_stl_acct_id
        or o.loan_type_cd <> n.loan_type_cd
        or o.prep_entred_tran_cnt <> n.prep_entred_tran_cnt
        or o.tran_type_cd <> n.tran_type_cd
        or o.bank_int_flg <> n.bank_int_flg
        or o.init_tran_dt <> n.init_tran_dt
        or o.init_tran_flow_num <> n.init_tran_flow_num
        or o.loan_tenor_cd <> n.loan_tenor_cd
        or o.guar_way_cd <> n.guar_way_cd
        or o.mode_pay_cd <> n.mode_pay_cd
        or o.pay_way_cd <> n.pay_way_cd
        or o.mini_loan_repay_num_id_one <> n.mini_loan_repay_num_id_one
        or o.mini_loan_repay_num_id_two <> n.mini_loan_repay_num_id_two
        or o.entr_pay_acct_id <> n.entr_pay_acct_id
        or o.entr_pay_acct_name <> n.entr_pay_acct_name
        or o.tran_dt <> n.tran_dt
        or o.loan_repay_int_intrv <> n.loan_repay_int_intrv
        or o.recv_bank_no <> n.recv_bank_no
        or o.recv_bank_name <> n.recv_bank_name
        or o.cust_id <> n.cust_id
        or o.tran_flow_num <> n.tran_flow_num
        or o.enter_acct_org_id <> n.enter_acct_org_id
        or o.out_acct_status_cd <> n.out_acct_status_cd
        or o.repay_comnt_descb <> n.repay_comnt_descb
        or o.prtcpt_deduct_flg <> n.prtcpt_deduct_flg
        or o.tenor_type_cd <> n.tenor_type_cd
        or o.user_id <> n.user_id
        or o.out_acct_appl_dt <> n.out_acct_appl_dt
        or o.actl_out_acct_dt <> n.actl_out_acct_dt
        or o.stud_loan_prod_id <> n.stud_loan_prod_id
        or o.major_guartor_id <> n.major_guartor_id
        or o.major_guartor_name <> n.major_guartor_name
        or o.secd_repay_acct_name <> n.secd_repay_acct_name
        or o.secd_repay_acct_id <> n.secd_repay_acct_id
        or o.forwd_tran_dt <> n.forwd_tran_dt
        or o.forwd_tran_flow_num <> n.forwd_tran_flow_num
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,recver_open_bank_cate_cd -- 收款人开户行类别代码
    ,recver_open_bank_rg_cd -- 收款人开户行地区代码
    ,mini_loan_stl_acct_id -- 微贷结算账户编号
    ,loan_type_cd -- 贷款类型代码
    ,prep_entred_tran_cnt -- 待受托划款笔数
    ,tran_type_cd -- 交易类型代码
    ,bank_int_flg -- 行内标志
    ,init_tran_dt -- 原交易日期
    ,init_tran_flow_num -- 原交易流水号
    ,loan_tenor_cd -- 贷款期限代码
    ,guar_way_cd -- 担保方式代码
    ,mode_pay_cd -- 支付方式代码
    ,pay_way_cd -- 付款方式代码
    ,mini_loan_repay_num_id_one -- 微贷还款账户编号一
    ,mini_loan_repay_num_id_two -- 微贷还款账户编号二
    ,entr_pay_acct_id -- 受托支付账户编号
    ,entr_pay_acct_name -- 受托支付账户名称
    ,tran_dt -- 交易日期
    ,loan_repay_int_intrv -- 贷款还息间隔
    ,recv_bank_no -- 收款行行号
    ,recv_bank_name -- 收款行名称
    ,cust_id -- 客户编号
    ,tran_flow_num -- 交易流水号
    ,enter_acct_org_id -- 入账机构编号
    ,out_acct_status_cd -- 出账状态代码
    ,repay_comnt_descb -- 还款说明描述
    ,prtcpt_deduct_flg -- 参与批扣标志
    ,tenor_type_cd -- 期限类型代码
    ,user_id -- 用户编号
    ,out_acct_appl_dt -- 出账申请日期
    ,actl_out_acct_dt -- 实际出账日期
    ,stud_loan_prod_id -- 助贷产品编号
    ,major_guartor_id -- 主要担保人编号
    ,major_guartor_name -- 主要担保人名称
    ,secd_repay_acct_name -- 第二还款账户名称
    ,secd_repay_acct_id -- 第二还款账户编号
    ,forwd_tran_dt -- 正向交易日期
    ,forwd_tran_flow_num -- 正向交易流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,recver_open_bank_cate_cd -- 收款人开户行类别代码
    ,recver_open_bank_rg_cd -- 收款人开户行地区代码
    ,mini_loan_stl_acct_id -- 微贷结算账户编号
    ,loan_type_cd -- 贷款类型代码
    ,prep_entred_tran_cnt -- 待受托划款笔数
    ,tran_type_cd -- 交易类型代码
    ,bank_int_flg -- 行内标志
    ,init_tran_dt -- 原交易日期
    ,init_tran_flow_num -- 原交易流水号
    ,loan_tenor_cd -- 贷款期限代码
    ,guar_way_cd -- 担保方式代码
    ,mode_pay_cd -- 支付方式代码
    ,pay_way_cd -- 付款方式代码
    ,mini_loan_repay_num_id_one -- 微贷还款账户编号一
    ,mini_loan_repay_num_id_two -- 微贷还款账户编号二
    ,entr_pay_acct_id -- 受托支付账户编号
    ,entr_pay_acct_name -- 受托支付账户名称
    ,tran_dt -- 交易日期
    ,loan_repay_int_intrv -- 贷款还息间隔
    ,recv_bank_no -- 收款行行号
    ,recv_bank_name -- 收款行名称
    ,cust_id -- 客户编号
    ,tran_flow_num -- 交易流水号
    ,enter_acct_org_id -- 入账机构编号
    ,out_acct_status_cd -- 出账状态代码
    ,repay_comnt_descb -- 还款说明描述
    ,prtcpt_deduct_flg -- 参与批扣标志
    ,tenor_type_cd -- 期限类型代码
    ,user_id -- 用户编号
    ,out_acct_appl_dt -- 出账申请日期
    ,actl_out_acct_dt -- 实际出账日期
    ,stud_loan_prod_id -- 助贷产品编号
    ,major_guartor_id -- 主要担保人编号
    ,major_guartor_name -- 主要担保人名称
    ,secd_repay_acct_name -- 第二还款账户名称
    ,secd_repay_acct_id -- 第二还款账户编号
    ,forwd_tran_dt -- 正向交易日期
    ,forwd_tran_flow_num -- 正向交易流水号
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
    ,o.recver_open_bank_cate_cd -- 收款人开户行类别代码
    ,o.recver_open_bank_rg_cd -- 收款人开户行地区代码
    ,o.mini_loan_stl_acct_id -- 微贷结算账户编号
    ,o.loan_type_cd -- 贷款类型代码
    ,o.prep_entred_tran_cnt -- 待受托划款笔数
    ,o.tran_type_cd -- 交易类型代码
    ,o.bank_int_flg -- 行内标志
    ,o.init_tran_dt -- 原交易日期
    ,o.init_tran_flow_num -- 原交易流水号
    ,o.loan_tenor_cd -- 贷款期限代码
    ,o.guar_way_cd -- 担保方式代码
    ,o.mode_pay_cd -- 支付方式代码
    ,o.pay_way_cd -- 付款方式代码
    ,o.mini_loan_repay_num_id_one -- 微贷还款账户编号一
    ,o.mini_loan_repay_num_id_two -- 微贷还款账户编号二
    ,o.entr_pay_acct_id -- 受托支付账户编号
    ,o.entr_pay_acct_name -- 受托支付账户名称
    ,o.tran_dt -- 交易日期
    ,o.loan_repay_int_intrv -- 贷款还息间隔
    ,o.recv_bank_no -- 收款行行号
    ,o.recv_bank_name -- 收款行名称
    ,o.cust_id -- 客户编号
    ,o.tran_flow_num -- 交易流水号
    ,o.enter_acct_org_id -- 入账机构编号
    ,o.out_acct_status_cd -- 出账状态代码
    ,o.repay_comnt_descb -- 还款说明描述
    ,o.prtcpt_deduct_flg -- 参与批扣标志
    ,o.tenor_type_cd -- 期限类型代码
    ,o.user_id -- 用户编号
    ,o.out_acct_appl_dt -- 出账申请日期
    ,o.actl_out_acct_dt -- 实际出账日期
    ,o.stud_loan_prod_id -- 助贷产品编号
    ,o.major_guartor_id -- 主要担保人编号
    ,o.major_guartor_name -- 主要担保人名称
    ,o.secd_repay_acct_name -- 第二还款账户名称
    ,o.secd_repay_acct_id -- 第二还款账户编号
    ,o.forwd_tran_dt -- 正向交易日期
    ,o.forwd_tran_flow_num -- 正向交易流水号
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
from ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h_icmsf1_cl d
        on
            o.appl_id = d.appl_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h;
--alter table ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_out_acct_mini_loan_attach_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_out_acct_mini_loan_attach_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_out_acct_mini_loan_attach_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
