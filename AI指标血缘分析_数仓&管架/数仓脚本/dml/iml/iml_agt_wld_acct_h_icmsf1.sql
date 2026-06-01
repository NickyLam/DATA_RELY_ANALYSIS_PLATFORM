/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_wld_acct_h_icmsf1
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
alter table ${iml_schema}.agt_wld_acct_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_wld_acct_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wld_acct_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_wld_acct_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_wld_acct_h_icmsf1_op purge;
drop table ${iml_schema}.agt_wld_acct_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wld_acct_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,cust_id -- 客户编号
    ,name -- 姓名
    ,gender_cd -- 性别代码
    ,cust_lmt_id -- 额度编号
    ,loan_prod_id -- 贷款产品编号
    ,syn_id -- 银团编号
    ,card_no -- 卡号
    ,curr_cd -- 币种代码
    ,lmt -- 授信额度
    ,curr_bal -- 当前余额
    ,pric_bal -- 本金余额
    ,last_exp_day_bal -- 上一到期日余额
    ,duf_mons -- 拖欠月数
    ,unbd_debit_amt -- 未入账借记金额
    ,unbd_crdt_amt -- 未入账贷记金额
    ,apot_repay_type_cd -- 约定还款类型代码
    ,apot_repay_bank_name -- 约定还款银行名称
    ,apot_repay_open_bank_num -- 约定还款开户行号
    ,apot_repay_deduct_acct_num -- 约定还款扣款账号
    ,apot_repay_deduct_acct_name -- 约定还款扣款账户名称
    ,repay_day -- 还款日
    ,last_enter_acct_batch_dt -- 上一次入账的批量日期
    ,prev_repay_dt -- 上个还款日期
    ,prev_exp_repay_dt -- 上个到期还款日期
    ,prev_ovdue_repay_dt -- 上个逾期还款日期
    ,prev_ovdue_mons_promt_dt -- 上个逾期月数提升日期
    ,in_coll_dt -- 入催日期
    ,out_coll_que_dt -- 出催收队列日期
    ,next_exp_repay_dt -- 下个到期还款日期
    ,exp_repay_dt -- 到期还款日期
    ,apot_repay_dt -- 约定还款日期
    ,grace_dt_term -- 宽限日期
    ,fir_exp_repay_dt -- 首个到期还款日期
    ,clos_acct_dt -- 销户日期
    ,tran_bad_debt_acct_dt -- 转呆账日期
    ,last_repay_amt -- 上笔还款金额
    ,currt_consm_amt -- 当期消费金额
    ,currt_consm_cnt -- 当期消费笔数
    ,currt_repay_amt -- 当期还款金额
    ,currt_repay_cnt -- 当期还款笔数
    ,currt_debit_adj_amt -- 当期借记调整金额
    ,currt_debit_adj_cnt -- 当期借记调整笔数
    ,currt_crdt_adj_amt -- 当期贷记调整金额
    ,currt_crdt_adj_cnt -- 当期贷记调整笔数
    ,currt_fee_amt -- 当期费用金额
    ,currt_fee_cnt -- 当期费用笔数
    ,currt_int_amt -- 当期利息金额
    ,currt_int_cnt -- 当期利息笔数
    ,th_mon_consm_amt -- 本月消费金额
    ,th_mon_consm_cnt -- 本月消费笔数
    ,th_year_consm_amt -- 本年消费金额
    ,th_year_consm_cnt -- 本年消费笔数
    ,curr_mon_repay_amt -- 当月还款金额
    ,curr_mon_repay_cnt -- 当月还款笔数
    ,th_year_repay_amt -- 当年还款金额
    ,th_year_repay_cnt -- 当年还款笔数
    ,h_repay_amt -- 历史还款金额
    ,h_repay_cnt -- 历史还款笔数
    ,bank_contri_ratio -- 银行出资比例
    ,out_line_cust_id -- 行外客户编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wld_acct_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_wld_acct_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wld_acct_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_wld_acct_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wld_acct_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_tm_account-1
insert into ${iml_schema}.agt_wld_acct_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,cust_id -- 客户编号
    ,name -- 姓名
    ,gender_cd -- 性别代码
    ,cust_lmt_id -- 额度编号
    ,loan_prod_id -- 贷款产品编号
    ,syn_id -- 银团编号
    ,card_no -- 卡号
    ,curr_cd -- 币种代码
    ,lmt -- 授信额度
    ,curr_bal -- 当前余额
    ,pric_bal -- 本金余额
    ,last_exp_day_bal -- 上一到期日余额
    ,duf_mons -- 拖欠月数
    ,unbd_debit_amt -- 未入账借记金额
    ,unbd_crdt_amt -- 未入账贷记金额
    ,apot_repay_type_cd -- 约定还款类型代码
    ,apot_repay_bank_name -- 约定还款银行名称
    ,apot_repay_open_bank_num -- 约定还款开户行号
    ,apot_repay_deduct_acct_num -- 约定还款扣款账号
    ,apot_repay_deduct_acct_name -- 约定还款扣款账户名称
    ,repay_day -- 还款日
    ,last_enter_acct_batch_dt -- 上一次入账的批量日期
    ,prev_repay_dt -- 上个还款日期
    ,prev_exp_repay_dt -- 上个到期还款日期
    ,prev_ovdue_repay_dt -- 上个逾期还款日期
    ,prev_ovdue_mons_promt_dt -- 上个逾期月数提升日期
    ,in_coll_dt -- 入催日期
    ,out_coll_que_dt -- 出催收队列日期
    ,next_exp_repay_dt -- 下个到期还款日期
    ,exp_repay_dt -- 到期还款日期
    ,apot_repay_dt -- 约定还款日期
    ,grace_dt_term -- 宽限日期
    ,fir_exp_repay_dt -- 首个到期还款日期
    ,clos_acct_dt -- 销户日期
    ,tran_bad_debt_acct_dt -- 转呆账日期
    ,last_repay_amt -- 上笔还款金额
    ,currt_consm_amt -- 当期消费金额
    ,currt_consm_cnt -- 当期消费笔数
    ,currt_repay_amt -- 当期还款金额
    ,currt_repay_cnt -- 当期还款笔数
    ,currt_debit_adj_amt -- 当期借记调整金额
    ,currt_debit_adj_cnt -- 当期借记调整笔数
    ,currt_crdt_adj_amt -- 当期贷记调整金额
    ,currt_crdt_adj_cnt -- 当期贷记调整笔数
    ,currt_fee_amt -- 当期费用金额
    ,currt_fee_cnt -- 当期费用笔数
    ,currt_int_amt -- 当期利息金额
    ,currt_int_cnt -- 当期利息笔数
    ,th_mon_consm_amt -- 本月消费金额
    ,th_mon_consm_cnt -- 本月消费笔数
    ,th_year_consm_amt -- 本年消费金额
    ,th_year_consm_cnt -- 本年消费笔数
    ,curr_mon_repay_amt -- 当月还款金额
    ,curr_mon_repay_cnt -- 当月还款笔数
    ,th_year_repay_amt -- 当年还款金额
    ,th_year_repay_cnt -- 当年还款笔数
    ,h_repay_amt -- 历史还款金额
    ,h_repay_cnt -- 历史还款笔数
    ,bank_contri_ratio -- 银行出资比例
    ,out_line_cust_id -- 行外客户编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '131010'||TO_CHAR(P1.ACCTNO)||P1.ACCTTYPE||P1.BANKGROUPID -- 协议编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.ACCTNO) -- 账户编号
    ,NVL(TRIM(P1.ACCTTYPE),'-') -- 账户类型代码
    ,NVL(trim(P2.CUSTOMERID),to_char(P1.CUSTID)) -- 客户编号
    ,P1.NAME -- 姓名
    ,NVL(trim(P1.GENDER),'0') -- 性别代码
    ,TO_CHAR(P1.CUSTLIMITID) -- 额度编号
    ,P1.PRODUCTCD -- 贷款产品编号
    ,P1.BANKGROUPID -- 银团编号
    ,P1.DEFAULTLOGICALCARDNO -- 卡号
    ,NVL(trim(P1.CURRCD),'-') -- 币种代码
    ,P1.CREDITLIMIT -- 授信额度
    ,P1.CURRBAL -- 当前余额
    ,P1.PRINCIPALBAL -- 本金余额
    ,P1.BEGINBAL -- 上一到期日余额
    ,NVL(TRIM(P1.AGECD),0) -- 拖欠月数
    ,P1.UNMATCHDB -- 未入账借记金额
    ,P1.UNMATCHCR -- 未入账贷记金额
    ,NVL(TRIM(P1.DDIND),'-') -- 约定还款类型代码
    ,P1.DDBANKNAME -- 约定还款银行名称
    ,P1.DDBANKBRANCH -- 约定还款开户行号
    ,P1.DDBANKACCTNO -- 约定还款扣款账号
    ,P1.DDBANKACCTNAME -- 约定还款扣款账户名称
    ,P1.BILLINGCYCLE -- 还款日
    ,P1.LASTSYNCDATE -- 上一次入账的批量日期
    ,P1.LASTPMTDATE -- 上个还款日期
    ,P1.LASTSTMTDATE -- 上个到期还款日期
    ,P1.LASTPMTDUEDATE -- 上个逾期还款日期
    ,P1.LASTAGINGDATE -- 上个逾期月数提升日期
    ,P1.COLLECTDATE -- 入催日期
    ,P1.COLLECTOUTDATE -- 出催收队列日期
    ,P1.NEXTSTMTDATE -- 下个到期还款日期
    ,P1.PMTDUEDATE -- 到期还款日期
    ,P1.DDDATE -- 约定还款日期
    ,P1.GRACEDATE -- 宽限日期
    ,P1.FIRSTSTMTDATE -- 首个到期还款日期
    ,P1.CANCELDATE -- 销户日期
    ,P1.CHARGEOFFDATE -- 转呆账日期
    ,P1.LASTPMTAMT -- 上笔还款金额
    ,P1.CTDRETAILAMT -- 当期消费金额
    ,P1.CTDRETAILCNT -- 当期消费笔数
    ,P1.CTDPAYMENTAMT -- 当期还款金额
    ,P1.CTDPAYMENTCNT -- 当期还款笔数
    ,P1.CTDDBADJAMT -- 当期借记调整金额
    ,P1.CTDDBADJCNT -- 当期借记调整笔数
    ,P1.CTDCRADJAMT -- 当期贷记调整金额
    ,P1.CTDCRADJCNT -- 当期贷记调整笔数
    ,P1.CTDFEEAMT -- 当期费用金额
    ,P1.CTDFEECNT -- 当期费用笔数
    ,P1.CTDINTEGERERESTAMT -- 当期利息金额
    ,P1.CTDINTEGERERESTCNT -- 当期利息笔数
    ,P1.MTDRETAILAMT -- 本月消费金额
    ,P1.MTDRETAILCNT -- 本月消费笔数
    ,P1.YTDRETAILAMT -- 本年消费金额
    ,P1.YTDRETAILCNT -- 本年消费笔数
    ,P1.MTDPAYMENTAMT -- 当月还款金额
    ,P1.MTDPAYMENTCNT -- 当月还款笔数
    ,P1.YTDPAYMENTAMT -- 当年还款金额
    ,P1.YTDPAYMENTCNT -- 当年还款笔数
    ,P1.LTDPAYMENTAMT -- 历史还款金额
    ,P1.LTDPAYMENTCNT -- 历史还款笔数
    ,P1.BANKPROPORTION -- 银行出资比例
    ,P1.CUSTID -- 行外客户编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_wld_tm_account' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_wld_tm_account p1
    left join ${iol_schema}.icms_customer_info_wld p2 on P1.CUSTID = P2.WLDCUSTID 
AND P2.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND P2.END_DT>TO_DATE('${batch_date}','YYYYMMDD')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_wld_acct_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
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
        into ${iml_schema}.agt_wld_acct_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,cust_id -- 客户编号
    ,name -- 姓名
    ,gender_cd -- 性别代码
    ,cust_lmt_id -- 额度编号
    ,loan_prod_id -- 贷款产品编号
    ,syn_id -- 银团编号
    ,card_no -- 卡号
    ,curr_cd -- 币种代码
    ,lmt -- 授信额度
    ,curr_bal -- 当前余额
    ,pric_bal -- 本金余额
    ,last_exp_day_bal -- 上一到期日余额
    ,duf_mons -- 拖欠月数
    ,unbd_debit_amt -- 未入账借记金额
    ,unbd_crdt_amt -- 未入账贷记金额
    ,apot_repay_type_cd -- 约定还款类型代码
    ,apot_repay_bank_name -- 约定还款银行名称
    ,apot_repay_open_bank_num -- 约定还款开户行号
    ,apot_repay_deduct_acct_num -- 约定还款扣款账号
    ,apot_repay_deduct_acct_name -- 约定还款扣款账户名称
    ,repay_day -- 还款日
    ,last_enter_acct_batch_dt -- 上一次入账的批量日期
    ,prev_repay_dt -- 上个还款日期
    ,prev_exp_repay_dt -- 上个到期还款日期
    ,prev_ovdue_repay_dt -- 上个逾期还款日期
    ,prev_ovdue_mons_promt_dt -- 上个逾期月数提升日期
    ,in_coll_dt -- 入催日期
    ,out_coll_que_dt -- 出催收队列日期
    ,next_exp_repay_dt -- 下个到期还款日期
    ,exp_repay_dt -- 到期还款日期
    ,apot_repay_dt -- 约定还款日期
    ,grace_dt_term -- 宽限日期
    ,fir_exp_repay_dt -- 首个到期还款日期
    ,clos_acct_dt -- 销户日期
    ,tran_bad_debt_acct_dt -- 转呆账日期
    ,last_repay_amt -- 上笔还款金额
    ,currt_consm_amt -- 当期消费金额
    ,currt_consm_cnt -- 当期消费笔数
    ,currt_repay_amt -- 当期还款金额
    ,currt_repay_cnt -- 当期还款笔数
    ,currt_debit_adj_amt -- 当期借记调整金额
    ,currt_debit_adj_cnt -- 当期借记调整笔数
    ,currt_crdt_adj_amt -- 当期贷记调整金额
    ,currt_crdt_adj_cnt -- 当期贷记调整笔数
    ,currt_fee_amt -- 当期费用金额
    ,currt_fee_cnt -- 当期费用笔数
    ,currt_int_amt -- 当期利息金额
    ,currt_int_cnt -- 当期利息笔数
    ,th_mon_consm_amt -- 本月消费金额
    ,th_mon_consm_cnt -- 本月消费笔数
    ,th_year_consm_amt -- 本年消费金额
    ,th_year_consm_cnt -- 本年消费笔数
    ,curr_mon_repay_amt -- 当月还款金额
    ,curr_mon_repay_cnt -- 当月还款笔数
    ,th_year_repay_amt -- 当年还款金额
    ,th_year_repay_cnt -- 当年还款笔数
    ,h_repay_amt -- 历史还款金额
    ,h_repay_cnt -- 历史还款笔数
    ,bank_contri_ratio -- 银行出资比例
    ,out_line_cust_id -- 行外客户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_wld_acct_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,cust_id -- 客户编号
    ,name -- 姓名
    ,gender_cd -- 性别代码
    ,cust_lmt_id -- 额度编号
    ,loan_prod_id -- 贷款产品编号
    ,syn_id -- 银团编号
    ,card_no -- 卡号
    ,curr_cd -- 币种代码
    ,lmt -- 授信额度
    ,curr_bal -- 当前余额
    ,pric_bal -- 本金余额
    ,last_exp_day_bal -- 上一到期日余额
    ,duf_mons -- 拖欠月数
    ,unbd_debit_amt -- 未入账借记金额
    ,unbd_crdt_amt -- 未入账贷记金额
    ,apot_repay_type_cd -- 约定还款类型代码
    ,apot_repay_bank_name -- 约定还款银行名称
    ,apot_repay_open_bank_num -- 约定还款开户行号
    ,apot_repay_deduct_acct_num -- 约定还款扣款账号
    ,apot_repay_deduct_acct_name -- 约定还款扣款账户名称
    ,repay_day -- 还款日
    ,last_enter_acct_batch_dt -- 上一次入账的批量日期
    ,prev_repay_dt -- 上个还款日期
    ,prev_exp_repay_dt -- 上个到期还款日期
    ,prev_ovdue_repay_dt -- 上个逾期还款日期
    ,prev_ovdue_mons_promt_dt -- 上个逾期月数提升日期
    ,in_coll_dt -- 入催日期
    ,out_coll_que_dt -- 出催收队列日期
    ,next_exp_repay_dt -- 下个到期还款日期
    ,exp_repay_dt -- 到期还款日期
    ,apot_repay_dt -- 约定还款日期
    ,grace_dt_term -- 宽限日期
    ,fir_exp_repay_dt -- 首个到期还款日期
    ,clos_acct_dt -- 销户日期
    ,tran_bad_debt_acct_dt -- 转呆账日期
    ,last_repay_amt -- 上笔还款金额
    ,currt_consm_amt -- 当期消费金额
    ,currt_consm_cnt -- 当期消费笔数
    ,currt_repay_amt -- 当期还款金额
    ,currt_repay_cnt -- 当期还款笔数
    ,currt_debit_adj_amt -- 当期借记调整金额
    ,currt_debit_adj_cnt -- 当期借记调整笔数
    ,currt_crdt_adj_amt -- 当期贷记调整金额
    ,currt_crdt_adj_cnt -- 当期贷记调整笔数
    ,currt_fee_amt -- 当期费用金额
    ,currt_fee_cnt -- 当期费用笔数
    ,currt_int_amt -- 当期利息金额
    ,currt_int_cnt -- 当期利息笔数
    ,th_mon_consm_amt -- 本月消费金额
    ,th_mon_consm_cnt -- 本月消费笔数
    ,th_year_consm_amt -- 本年消费金额
    ,th_year_consm_cnt -- 本年消费笔数
    ,curr_mon_repay_amt -- 当月还款金额
    ,curr_mon_repay_cnt -- 当月还款笔数
    ,th_year_repay_amt -- 当年还款金额
    ,th_year_repay_cnt -- 当年还款笔数
    ,h_repay_amt -- 历史还款金额
    ,h_repay_cnt -- 历史还款笔数
    ,bank_contri_ratio -- 银行出资比例
    ,out_line_cust_id -- 行外客户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.acct_type_cd, o.acct_type_cd) as acct_type_cd -- 账户类型代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.name, o.name) as name -- 姓名
    ,nvl(n.gender_cd, o.gender_cd) as gender_cd -- 性别代码
    ,nvl(n.cust_lmt_id, o.cust_lmt_id) as cust_lmt_id -- 额度编号
    ,nvl(n.loan_prod_id, o.loan_prod_id) as loan_prod_id -- 贷款产品编号
    ,nvl(n.syn_id, o.syn_id) as syn_id -- 银团编号
    ,nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.lmt, o.lmt) as lmt -- 授信额度
    ,nvl(n.curr_bal, o.curr_bal) as curr_bal -- 当前余额
    ,nvl(n.pric_bal, o.pric_bal) as pric_bal -- 本金余额
    ,nvl(n.last_exp_day_bal, o.last_exp_day_bal) as last_exp_day_bal -- 上一到期日余额
    ,nvl(n.duf_mons, o.duf_mons) as duf_mons -- 拖欠月数
    ,nvl(n.unbd_debit_amt, o.unbd_debit_amt) as unbd_debit_amt -- 未入账借记金额
    ,nvl(n.unbd_crdt_amt, o.unbd_crdt_amt) as unbd_crdt_amt -- 未入账贷记金额
    ,nvl(n.apot_repay_type_cd, o.apot_repay_type_cd) as apot_repay_type_cd -- 约定还款类型代码
    ,nvl(n.apot_repay_bank_name, o.apot_repay_bank_name) as apot_repay_bank_name -- 约定还款银行名称
    ,nvl(n.apot_repay_open_bank_num, o.apot_repay_open_bank_num) as apot_repay_open_bank_num -- 约定还款开户行号
    ,nvl(n.apot_repay_deduct_acct_num, o.apot_repay_deduct_acct_num) as apot_repay_deduct_acct_num -- 约定还款扣款账号
    ,nvl(n.apot_repay_deduct_acct_name, o.apot_repay_deduct_acct_name) as apot_repay_deduct_acct_name -- 约定还款扣款账户名称
    ,nvl(n.repay_day, o.repay_day) as repay_day -- 还款日
    ,nvl(n.last_enter_acct_batch_dt, o.last_enter_acct_batch_dt) as last_enter_acct_batch_dt -- 上一次入账的批量日期
    ,nvl(n.prev_repay_dt, o.prev_repay_dt) as prev_repay_dt -- 上个还款日期
    ,nvl(n.prev_exp_repay_dt, o.prev_exp_repay_dt) as prev_exp_repay_dt -- 上个到期还款日期
    ,nvl(n.prev_ovdue_repay_dt, o.prev_ovdue_repay_dt) as prev_ovdue_repay_dt -- 上个逾期还款日期
    ,nvl(n.prev_ovdue_mons_promt_dt, o.prev_ovdue_mons_promt_dt) as prev_ovdue_mons_promt_dt -- 上个逾期月数提升日期
    ,nvl(n.in_coll_dt, o.in_coll_dt) as in_coll_dt -- 入催日期
    ,nvl(n.out_coll_que_dt, o.out_coll_que_dt) as out_coll_que_dt -- 出催收队列日期
    ,nvl(n.next_exp_repay_dt, o.next_exp_repay_dt) as next_exp_repay_dt -- 下个到期还款日期
    ,nvl(n.exp_repay_dt, o.exp_repay_dt) as exp_repay_dt -- 到期还款日期
    ,nvl(n.apot_repay_dt, o.apot_repay_dt) as apot_repay_dt -- 约定还款日期
    ,nvl(n.grace_dt_term, o.grace_dt_term) as grace_dt_term -- 宽限日期
    ,nvl(n.fir_exp_repay_dt, o.fir_exp_repay_dt) as fir_exp_repay_dt -- 首个到期还款日期
    ,nvl(n.clos_acct_dt, o.clos_acct_dt) as clos_acct_dt -- 销户日期
    ,nvl(n.tran_bad_debt_acct_dt, o.tran_bad_debt_acct_dt) as tran_bad_debt_acct_dt -- 转呆账日期
    ,nvl(n.last_repay_amt, o.last_repay_amt) as last_repay_amt -- 上笔还款金额
    ,nvl(n.currt_consm_amt, o.currt_consm_amt) as currt_consm_amt -- 当期消费金额
    ,nvl(n.currt_consm_cnt, o.currt_consm_cnt) as currt_consm_cnt -- 当期消费笔数
    ,nvl(n.currt_repay_amt, o.currt_repay_amt) as currt_repay_amt -- 当期还款金额
    ,nvl(n.currt_repay_cnt, o.currt_repay_cnt) as currt_repay_cnt -- 当期还款笔数
    ,nvl(n.currt_debit_adj_amt, o.currt_debit_adj_amt) as currt_debit_adj_amt -- 当期借记调整金额
    ,nvl(n.currt_debit_adj_cnt, o.currt_debit_adj_cnt) as currt_debit_adj_cnt -- 当期借记调整笔数
    ,nvl(n.currt_crdt_adj_amt, o.currt_crdt_adj_amt) as currt_crdt_adj_amt -- 当期贷记调整金额
    ,nvl(n.currt_crdt_adj_cnt, o.currt_crdt_adj_cnt) as currt_crdt_adj_cnt -- 当期贷记调整笔数
    ,nvl(n.currt_fee_amt, o.currt_fee_amt) as currt_fee_amt -- 当期费用金额
    ,nvl(n.currt_fee_cnt, o.currt_fee_cnt) as currt_fee_cnt -- 当期费用笔数
    ,nvl(n.currt_int_amt, o.currt_int_amt) as currt_int_amt -- 当期利息金额
    ,nvl(n.currt_int_cnt, o.currt_int_cnt) as currt_int_cnt -- 当期利息笔数
    ,nvl(n.th_mon_consm_amt, o.th_mon_consm_amt) as th_mon_consm_amt -- 本月消费金额
    ,nvl(n.th_mon_consm_cnt, o.th_mon_consm_cnt) as th_mon_consm_cnt -- 本月消费笔数
    ,nvl(n.th_year_consm_amt, o.th_year_consm_amt) as th_year_consm_amt -- 本年消费金额
    ,nvl(n.th_year_consm_cnt, o.th_year_consm_cnt) as th_year_consm_cnt -- 本年消费笔数
    ,nvl(n.curr_mon_repay_amt, o.curr_mon_repay_amt) as curr_mon_repay_amt -- 当月还款金额
    ,nvl(n.curr_mon_repay_cnt, o.curr_mon_repay_cnt) as curr_mon_repay_cnt -- 当月还款笔数
    ,nvl(n.th_year_repay_amt, o.th_year_repay_amt) as th_year_repay_amt -- 当年还款金额
    ,nvl(n.th_year_repay_cnt, o.th_year_repay_cnt) as th_year_repay_cnt -- 当年还款笔数
    ,nvl(n.h_repay_amt, o.h_repay_amt) as h_repay_amt -- 历史还款金额
    ,nvl(n.h_repay_cnt, o.h_repay_cnt) as h_repay_cnt -- 历史还款笔数
    ,nvl(n.bank_contri_ratio, o.bank_contri_ratio) as bank_contri_ratio -- 银行出资比例
    ,nvl(n.out_line_cust_id, o.out_line_cust_id) as out_line_cust_id -- 行外客户编号
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wld_acct_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_wld_acct_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.acct_id <> n.acct_id
        or o.acct_type_cd <> n.acct_type_cd
        or o.cust_id <> n.cust_id
        or o.name <> n.name
        or o.gender_cd <> n.gender_cd
        or o.cust_lmt_id <> n.cust_lmt_id
        or o.loan_prod_id <> n.loan_prod_id
        or o.syn_id <> n.syn_id
        or o.card_no <> n.card_no
        or o.curr_cd <> n.curr_cd
        or o.lmt <> n.lmt
        or o.curr_bal <> n.curr_bal
        or o.pric_bal <> n.pric_bal
        or o.last_exp_day_bal <> n.last_exp_day_bal
        or o.duf_mons <> n.duf_mons
        or o.unbd_debit_amt <> n.unbd_debit_amt
        or o.unbd_crdt_amt <> n.unbd_crdt_amt
        or o.apot_repay_type_cd <> n.apot_repay_type_cd
        or o.apot_repay_bank_name <> n.apot_repay_bank_name
        or o.apot_repay_open_bank_num <> n.apot_repay_open_bank_num
        or o.apot_repay_deduct_acct_num <> n.apot_repay_deduct_acct_num
        or o.apot_repay_deduct_acct_name <> n.apot_repay_deduct_acct_name
        or o.repay_day <> n.repay_day
        or o.last_enter_acct_batch_dt <> n.last_enter_acct_batch_dt
        or o.prev_repay_dt <> n.prev_repay_dt
        or o.prev_exp_repay_dt <> n.prev_exp_repay_dt
        or o.prev_ovdue_repay_dt <> n.prev_ovdue_repay_dt
        or o.prev_ovdue_mons_promt_dt <> n.prev_ovdue_mons_promt_dt
        or o.in_coll_dt <> n.in_coll_dt
        or o.out_coll_que_dt <> n.out_coll_que_dt
        or o.next_exp_repay_dt <> n.next_exp_repay_dt
        or o.exp_repay_dt <> n.exp_repay_dt
        or o.apot_repay_dt <> n.apot_repay_dt
        or o.grace_dt_term <> n.grace_dt_term
        or o.fir_exp_repay_dt <> n.fir_exp_repay_dt
        or o.clos_acct_dt <> n.clos_acct_dt
        or o.tran_bad_debt_acct_dt <> n.tran_bad_debt_acct_dt
        or o.last_repay_amt <> n.last_repay_amt
        or o.currt_consm_amt <> n.currt_consm_amt
        or o.currt_consm_cnt <> n.currt_consm_cnt
        or o.currt_repay_amt <> n.currt_repay_amt
        or o.currt_repay_cnt <> n.currt_repay_cnt
        or o.currt_debit_adj_amt <> n.currt_debit_adj_amt
        or o.currt_debit_adj_cnt <> n.currt_debit_adj_cnt
        or o.currt_crdt_adj_amt <> n.currt_crdt_adj_amt
        or o.currt_crdt_adj_cnt <> n.currt_crdt_adj_cnt
        or o.currt_fee_amt <> n.currt_fee_amt
        or o.currt_fee_cnt <> n.currt_fee_cnt
        or o.currt_int_amt <> n.currt_int_amt
        or o.currt_int_cnt <> n.currt_int_cnt
        or o.th_mon_consm_amt <> n.th_mon_consm_amt
        or o.th_mon_consm_cnt <> n.th_mon_consm_cnt
        or o.th_year_consm_amt <> n.th_year_consm_amt
        or o.th_year_consm_cnt <> n.th_year_consm_cnt
        or o.curr_mon_repay_amt <> n.curr_mon_repay_amt
        or o.curr_mon_repay_cnt <> n.curr_mon_repay_cnt
        or o.th_year_repay_amt <> n.th_year_repay_amt
        or o.th_year_repay_cnt <> n.th_year_repay_cnt
        or o.h_repay_amt <> n.h_repay_amt
        or o.h_repay_cnt <> n.h_repay_cnt
        or o.bank_contri_ratio <> n.bank_contri_ratio
        or o.out_line_cust_id <> n.out_line_cust_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_wld_acct_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,cust_id -- 客户编号
    ,name -- 姓名
    ,gender_cd -- 性别代码
    ,cust_lmt_id -- 额度编号
    ,loan_prod_id -- 贷款产品编号
    ,syn_id -- 银团编号
    ,card_no -- 卡号
    ,curr_cd -- 币种代码
    ,lmt -- 授信额度
    ,curr_bal -- 当前余额
    ,pric_bal -- 本金余额
    ,last_exp_day_bal -- 上一到期日余额
    ,duf_mons -- 拖欠月数
    ,unbd_debit_amt -- 未入账借记金额
    ,unbd_crdt_amt -- 未入账贷记金额
    ,apot_repay_type_cd -- 约定还款类型代码
    ,apot_repay_bank_name -- 约定还款银行名称
    ,apot_repay_open_bank_num -- 约定还款开户行号
    ,apot_repay_deduct_acct_num -- 约定还款扣款账号
    ,apot_repay_deduct_acct_name -- 约定还款扣款账户名称
    ,repay_day -- 还款日
    ,last_enter_acct_batch_dt -- 上一次入账的批量日期
    ,prev_repay_dt -- 上个还款日期
    ,prev_exp_repay_dt -- 上个到期还款日期
    ,prev_ovdue_repay_dt -- 上个逾期还款日期
    ,prev_ovdue_mons_promt_dt -- 上个逾期月数提升日期
    ,in_coll_dt -- 入催日期
    ,out_coll_que_dt -- 出催收队列日期
    ,next_exp_repay_dt -- 下个到期还款日期
    ,exp_repay_dt -- 到期还款日期
    ,apot_repay_dt -- 约定还款日期
    ,grace_dt_term -- 宽限日期
    ,fir_exp_repay_dt -- 首个到期还款日期
    ,clos_acct_dt -- 销户日期
    ,tran_bad_debt_acct_dt -- 转呆账日期
    ,last_repay_amt -- 上笔还款金额
    ,currt_consm_amt -- 当期消费金额
    ,currt_consm_cnt -- 当期消费笔数
    ,currt_repay_amt -- 当期还款金额
    ,currt_repay_cnt -- 当期还款笔数
    ,currt_debit_adj_amt -- 当期借记调整金额
    ,currt_debit_adj_cnt -- 当期借记调整笔数
    ,currt_crdt_adj_amt -- 当期贷记调整金额
    ,currt_crdt_adj_cnt -- 当期贷记调整笔数
    ,currt_fee_amt -- 当期费用金额
    ,currt_fee_cnt -- 当期费用笔数
    ,currt_int_amt -- 当期利息金额
    ,currt_int_cnt -- 当期利息笔数
    ,th_mon_consm_amt -- 本月消费金额
    ,th_mon_consm_cnt -- 本月消费笔数
    ,th_year_consm_amt -- 本年消费金额
    ,th_year_consm_cnt -- 本年消费笔数
    ,curr_mon_repay_amt -- 当月还款金额
    ,curr_mon_repay_cnt -- 当月还款笔数
    ,th_year_repay_amt -- 当年还款金额
    ,th_year_repay_cnt -- 当年还款笔数
    ,h_repay_amt -- 历史还款金额
    ,h_repay_cnt -- 历史还款笔数
    ,bank_contri_ratio -- 银行出资比例
    ,out_line_cust_id -- 行外客户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_wld_acct_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,cust_id -- 客户编号
    ,name -- 姓名
    ,gender_cd -- 性别代码
    ,cust_lmt_id -- 额度编号
    ,loan_prod_id -- 贷款产品编号
    ,syn_id -- 银团编号
    ,card_no -- 卡号
    ,curr_cd -- 币种代码
    ,lmt -- 授信额度
    ,curr_bal -- 当前余额
    ,pric_bal -- 本金余额
    ,last_exp_day_bal -- 上一到期日余额
    ,duf_mons -- 拖欠月数
    ,unbd_debit_amt -- 未入账借记金额
    ,unbd_crdt_amt -- 未入账贷记金额
    ,apot_repay_type_cd -- 约定还款类型代码
    ,apot_repay_bank_name -- 约定还款银行名称
    ,apot_repay_open_bank_num -- 约定还款开户行号
    ,apot_repay_deduct_acct_num -- 约定还款扣款账号
    ,apot_repay_deduct_acct_name -- 约定还款扣款账户名称
    ,repay_day -- 还款日
    ,last_enter_acct_batch_dt -- 上一次入账的批量日期
    ,prev_repay_dt -- 上个还款日期
    ,prev_exp_repay_dt -- 上个到期还款日期
    ,prev_ovdue_repay_dt -- 上个逾期还款日期
    ,prev_ovdue_mons_promt_dt -- 上个逾期月数提升日期
    ,in_coll_dt -- 入催日期
    ,out_coll_que_dt -- 出催收队列日期
    ,next_exp_repay_dt -- 下个到期还款日期
    ,exp_repay_dt -- 到期还款日期
    ,apot_repay_dt -- 约定还款日期
    ,grace_dt_term -- 宽限日期
    ,fir_exp_repay_dt -- 首个到期还款日期
    ,clos_acct_dt -- 销户日期
    ,tran_bad_debt_acct_dt -- 转呆账日期
    ,last_repay_amt -- 上笔还款金额
    ,currt_consm_amt -- 当期消费金额
    ,currt_consm_cnt -- 当期消费笔数
    ,currt_repay_amt -- 当期还款金额
    ,currt_repay_cnt -- 当期还款笔数
    ,currt_debit_adj_amt -- 当期借记调整金额
    ,currt_debit_adj_cnt -- 当期借记调整笔数
    ,currt_crdt_adj_amt -- 当期贷记调整金额
    ,currt_crdt_adj_cnt -- 当期贷记调整笔数
    ,currt_fee_amt -- 当期费用金额
    ,currt_fee_cnt -- 当期费用笔数
    ,currt_int_amt -- 当期利息金额
    ,currt_int_cnt -- 当期利息笔数
    ,th_mon_consm_amt -- 本月消费金额
    ,th_mon_consm_cnt -- 本月消费笔数
    ,th_year_consm_amt -- 本年消费金额
    ,th_year_consm_cnt -- 本年消费笔数
    ,curr_mon_repay_amt -- 当月还款金额
    ,curr_mon_repay_cnt -- 当月还款笔数
    ,th_year_repay_amt -- 当年还款金额
    ,th_year_repay_cnt -- 当年还款笔数
    ,h_repay_amt -- 历史还款金额
    ,h_repay_cnt -- 历史还款笔数
    ,bank_contri_ratio -- 银行出资比例
    ,out_line_cust_id -- 行外客户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.acct_id -- 账户编号
    ,o.acct_type_cd -- 账户类型代码
    ,o.cust_id -- 客户编号
    ,o.name -- 姓名
    ,o.gender_cd -- 性别代码
    ,o.cust_lmt_id -- 额度编号
    ,o.loan_prod_id -- 贷款产品编号
    ,o.syn_id -- 银团编号
    ,o.card_no -- 卡号
    ,o.curr_cd -- 币种代码
    ,o.lmt -- 授信额度
    ,o.curr_bal -- 当前余额
    ,o.pric_bal -- 本金余额
    ,o.last_exp_day_bal -- 上一到期日余额
    ,o.duf_mons -- 拖欠月数
    ,o.unbd_debit_amt -- 未入账借记金额
    ,o.unbd_crdt_amt -- 未入账贷记金额
    ,o.apot_repay_type_cd -- 约定还款类型代码
    ,o.apot_repay_bank_name -- 约定还款银行名称
    ,o.apot_repay_open_bank_num -- 约定还款开户行号
    ,o.apot_repay_deduct_acct_num -- 约定还款扣款账号
    ,o.apot_repay_deduct_acct_name -- 约定还款扣款账户名称
    ,o.repay_day -- 还款日
    ,o.last_enter_acct_batch_dt -- 上一次入账的批量日期
    ,o.prev_repay_dt -- 上个还款日期
    ,o.prev_exp_repay_dt -- 上个到期还款日期
    ,o.prev_ovdue_repay_dt -- 上个逾期还款日期
    ,o.prev_ovdue_mons_promt_dt -- 上个逾期月数提升日期
    ,o.in_coll_dt -- 入催日期
    ,o.out_coll_que_dt -- 出催收队列日期
    ,o.next_exp_repay_dt -- 下个到期还款日期
    ,o.exp_repay_dt -- 到期还款日期
    ,o.apot_repay_dt -- 约定还款日期
    ,o.grace_dt_term -- 宽限日期
    ,o.fir_exp_repay_dt -- 首个到期还款日期
    ,o.clos_acct_dt -- 销户日期
    ,o.tran_bad_debt_acct_dt -- 转呆账日期
    ,o.last_repay_amt -- 上笔还款金额
    ,o.currt_consm_amt -- 当期消费金额
    ,o.currt_consm_cnt -- 当期消费笔数
    ,o.currt_repay_amt -- 当期还款金额
    ,o.currt_repay_cnt -- 当期还款笔数
    ,o.currt_debit_adj_amt -- 当期借记调整金额
    ,o.currt_debit_adj_cnt -- 当期借记调整笔数
    ,o.currt_crdt_adj_amt -- 当期贷记调整金额
    ,o.currt_crdt_adj_cnt -- 当期贷记调整笔数
    ,o.currt_fee_amt -- 当期费用金额
    ,o.currt_fee_cnt -- 当期费用笔数
    ,o.currt_int_amt -- 当期利息金额
    ,o.currt_int_cnt -- 当期利息笔数
    ,o.th_mon_consm_amt -- 本月消费金额
    ,o.th_mon_consm_cnt -- 本月消费笔数
    ,o.th_year_consm_amt -- 本年消费金额
    ,o.th_year_consm_cnt -- 本年消费笔数
    ,o.curr_mon_repay_amt -- 当月还款金额
    ,o.curr_mon_repay_cnt -- 当月还款笔数
    ,o.th_year_repay_amt -- 当年还款金额
    ,o.th_year_repay_cnt -- 当年还款笔数
    ,o.h_repay_amt -- 历史还款金额
    ,o.h_repay_cnt -- 历史还款笔数
    ,o.bank_contri_ratio -- 银行出资比例
    ,o.out_line_cust_id -- 行外客户编号
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
from ${iml_schema}.agt_wld_acct_h_icmsf1_bk o
    left join ${iml_schema}.agt_wld_acct_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_wld_acct_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_wld_acct_h;
--alter table ${iml_schema}.agt_wld_acct_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_wld_acct_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_wld_acct_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_wld_acct_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_wld_acct_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_wld_acct_h_icmsf1_cl;
alter table ${iml_schema}.agt_wld_acct_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_wld_acct_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_wld_acct_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_wld_acct_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_wld_acct_h_icmsf1_op purge;
drop table ${iml_schema}.agt_wld_acct_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_wld_acct_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_wld_acct_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
