/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_out_acct_indv_loan_attach_info_h_icmsf1
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
alter table ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,out_acct_flow_num -- 出账流水号
    ,lp_id -- 法人编号
    ,appl_distr_amt -- 申请放款金额
    ,hqd_centr_out_acct_flg -- 集中出账标志
    ,recver_open_bank_name -- 收款人开户行名称
    ,open_acct_bind_mobile_no -- 开户绑定手机号码
    ,loan_distr_dt -- 贷款发放日期
    ,loan_actl_distr_dt -- 贷款实际发放日期
    ,entr_pay_cfm_status_cd -- 受托支付确认状态代码
    ,entr_pay_cfm_tm -- 受托支付确认时间
    ,entr_pay_acct_num_id -- 受托支付账号编号
    ,self_pay_amt -- 自主支付金额
    ,pay_indent_id -- 支付订单编号
    ,distr_chn_cd -- 放款渠道代码
    ,distr_dt -- 放款日期
    ,distr_advise_sucs_flg -- 放款通知成功标志
    ,distr_end_dt -- 放款结束日期
    ,loan_perds -- 贷款期数
    ,repay_card_type_cd -- 还款卡类型代码
    ,deflt_repay_day -- 默认还款日
    ,loan_termnt_dt -- 贷款终止日期
    ,blon_loan_amort_dt -- 气球贷摊销日期
    ,input_stamp_tax_flg -- 录入印花税标志
    ,stamp_tax_tax_acct_id -- 印花税扣税账户编号
    ,stamp_tax_acct_name -- 印花税扣税账号名称
    ,stamp_tax_amt -- 印花税金额
    ,prod_chn_idf_cd -- 产品渠道标识代码
    ,rela_flow_num -- 关联流水号
    ,file_int_accr_flg -- 靠档计息标志
    ,due_diligence_flg -- 尽调标志
    ,outline_vrif_idti_flg -- 线下核身标志
    ,out_acct_impt_cond_descb -- 出账落实条件描述
    ,risk_mgmt_rest_cd -- 风控结果代码
    ,guar_guar_letter_id -- 担保保证函编号
    ,group_cust_flg -- 集团客户标志
    ,group_cust_name -- 集团客户名称
    ,group_cust_id -- 集团客户编号
    ,group_cust_aval_open_lmt -- 集团客户可用敞口额度
    ,brwer_and_group_rela_cd -- 借款人与集团关系代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_bp_personal_loan
insert into ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h_icmsf1_tm(
    appl_id -- 申请编号
    ,out_acct_flow_num -- 出账流水号
    ,lp_id -- 法人编号
    ,appl_distr_amt -- 申请放款金额
    ,hqd_centr_out_acct_flg -- 好企贷集中出账标志
    ,recver_open_bank_name -- 收款人开户行名称
    ,open_acct_bind_mobile_no -- 开户绑定手机号码
    ,loan_distr_dt -- 贷款发放日期
    ,loan_actl_distr_dt -- 贷款实际发放日期
    ,entr_pay_cfm_status_cd -- 受托支付确认状态代码
    ,entr_pay_cfm_tm -- 受托支付确认时间
    ,entr_pay_acct_num_id -- 受托支付账号编号
    ,self_pay_amt -- 自主支付金额
    ,pay_indent_id -- 支付订单编号
    ,distr_chn_cd -- 放款渠道代码
    ,distr_dt -- 放款日期
    ,distr_advise_sucs_flg -- 放款通知成功标志
    ,distr_end_dt -- 放款结束日期
    ,loan_perds -- 贷款期数
    ,repay_card_type_cd -- 还款卡类型代码
    ,deflt_repay_day -- 默认还款日
    ,loan_termnt_dt -- 贷款终止日期
    ,blon_loan_amort_dt -- 气球贷摊销日期
    ,input_stamp_tax_flg -- 录入印花税标志
    ,stamp_tax_tax_acct_id -- 印花税扣税账户编号
    ,stamp_tax_acct_name -- 印花税扣税账号名称
    ,stamp_tax_amt -- 印花税金额
    ,prod_chn_idf_cd -- 产品渠道标识代码
    ,rela_flow_num -- 关联流水号
    ,file_int_accr_flg -- 靠档计息标志
    ,due_diligence_flg -- 尽调标志
    ,outline_vrif_idti_flg -- 线下核身标志
    ,out_acct_impt_cond_descb -- 出账落实条件描述
    ,risk_mgmt_rest_cd -- 风控结果代码
    ,guar_guar_letter_id -- 担保保证函编号
    ,group_cust_flg -- 集团客户标志
    ,group_cust_name -- 集团客户名称
    ,group_cust_id -- 集团客户编号
    ,group_cust_aval_open_lmt -- 集团客户可用敞口额度
    ,brwer_and_group_rela_cd -- 借款人与集团关系代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206001'||P1.SERIALNO -- 申请编号
    ,P1.SERIALNO -- 出账流水号
    ,'9999' -- 法人编号
    ,P1.APPLYSUM -- 申请放款金额
    ,P1.ISCENTRALIZEDACCOUNT -- 好企贷集中出账标志
    ,P1.PAYEE_BANK_NAME -- 收款人开户行名称
    ,P1.PAYACCOUNTTEL -- 开户绑定手机号码
    ,P1.LOANBEGINDATE -- 贷款发放日期
    ,P1.LOANTRUEDATE -- 贷款实际发放日期
    ,P1.CONFIRMSTATE -- 受托支付确认状态代码
    ,${iml_schema}.timeformat_min(P1.CONFIRMTIME) -- 受托支付确认时间
    ,P1.PAYACCTNO -- 受托支付账号编号
    ,P1.CASHSUM -- 自主支付金额
    ,P1.PAYORDERID -- 支付订单编号
    ,nvl(trim(P1.CHANNELCODE),'-') -- 放款渠道代码
    ,P1.PUTOUTTIME -- 放款日期
    ,nvl(trim(P1.INFORMFLAG),'-') -- 放款通知成功标志
    ,P1.APPROVEENDDATE -- 放款结束日期
    ,P1.LOANSTAGE -- 贷款期数
    ,nvl(trim(P1.PAYACCOUNTTYPE),'-') -- 还款卡类型代码
    ,P1.REPAYDATETYPE -- 默认还款日
    ,P1.LOANFINISHDATE -- 贷款终止日期
    ,P1.BALLDATE -- 气球贷摊销日期
    ,P1.ISRECORDTAX -- 录入印花税标志
    ,P1.TAXACCOUNT -- 印花税扣税账户编号
    ,P1.TAXACCOUNTNAME -- 印花税扣税账号名称
    ,P1.TAXAMOUNT -- 印花税金额
    ,nvl(trim(P1.PRODUCTCHANNEL),'0000') -- 产品渠道标识代码
    ,P1.RELASERIALNO -- 关联流水号
    ,nvl(trim(P1.ISBELONGTERM),'-') -- 靠档计息标志
    ,decode(P1.INVSTFLG,'N','0','Y','1',' ','-',P1.INVSTFLG) -- 尽调标志
    ,decode(P1.OFFLCHKIDENFLG,'N','0','Y','1',' ','-',P1.OFFLCHKIDENFLG) -- 线下核身标志
    ,P1.PUTOUTCONDITIONREMARK -- 出账落实条件描述
    ,nvl(trim(P1.CHECKRESULT),'-') -- 风控结果代码
    ,P1.GUACONTNO -- 担保保证函编号
    ,nvl(trim(P1.ISNOGROUP),'-') -- 集团客户标志
    ,P1.GROUPCUSTNAME -- 集团客户名称
    ,P1.GROUPCUSTCODE -- 集团客户编号
    ,P1.AVAILEXPOSURE -- 集团客户可用敞口额度
    ,nvl(trim(P1.RELATIONSHIP),'dw000') -- 借款人与集团关系代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_bp_personal_loan' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_bp_personal_loan p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h_icmsf1_tm 
  	                                group by 
  	                                        appl_id
  	                                        ,out_acct_flow_num
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
        into ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h_icmsf1_cl(
            appl_id -- 申请编号
    ,out_acct_flow_num -- 出账流水号
    ,lp_id -- 法人编号
    ,appl_distr_amt -- 申请放款金额
    ,hqd_centr_out_acct_flg -- 好企贷集中出账标志
    ,recver_open_bank_name -- 收款人开户行名称
    ,open_acct_bind_mobile_no -- 开户绑定手机号码
    ,loan_distr_dt -- 贷款发放日期
    ,loan_actl_distr_dt -- 贷款实际发放日期
    ,entr_pay_cfm_status_cd -- 受托支付确认状态代码
    ,entr_pay_cfm_tm -- 受托支付确认时间
    ,entr_pay_acct_num_id -- 受托支付账号编号
    ,self_pay_amt -- 自主支付金额
    ,pay_indent_id -- 支付订单编号
    ,distr_chn_cd -- 放款渠道代码
    ,distr_dt -- 放款日期
    ,distr_advise_sucs_flg -- 放款通知成功标志
    ,distr_end_dt -- 放款结束日期
    ,loan_perds -- 贷款期数
    ,repay_card_type_cd -- 还款卡类型代码
    ,deflt_repay_day -- 默认还款日
    ,loan_termnt_dt -- 贷款终止日期
    ,blon_loan_amort_dt -- 气球贷摊销日期
    ,input_stamp_tax_flg -- 录入印花税标志
    ,stamp_tax_tax_acct_id -- 印花税扣税账户编号
    ,stamp_tax_acct_name -- 印花税扣税账号名称
    ,stamp_tax_amt -- 印花税金额
    ,prod_chn_idf_cd -- 产品渠道标识代码
    ,rela_flow_num -- 关联流水号
    ,file_int_accr_flg -- 靠档计息标志
    ,due_diligence_flg -- 尽调标志
    ,outline_vrif_idti_flg -- 线下核身标志
    ,out_acct_impt_cond_descb -- 出账落实条件描述
    ,risk_mgmt_rest_cd -- 风控结果代码
    ,guar_guar_letter_id -- 担保保证函编号
    ,group_cust_flg -- 集团客户标志
    ,group_cust_name -- 集团客户名称
    ,group_cust_id -- 集团客户编号
    ,group_cust_aval_open_lmt -- 集团客户可用敞口额度
    ,brwer_and_group_rela_cd -- 借款人与集团关系代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h_icmsf1_op(
            appl_id -- 申请编号
    ,out_acct_flow_num -- 出账流水号
    ,lp_id -- 法人编号
    ,appl_distr_amt -- 申请放款金额
    ,hqd_centr_out_acct_flg -- 好企贷集中出账标志
    ,recver_open_bank_name -- 收款人开户行名称
    ,open_acct_bind_mobile_no -- 开户绑定手机号码
    ,loan_distr_dt -- 贷款发放日期
    ,loan_actl_distr_dt -- 贷款实际发放日期
    ,entr_pay_cfm_status_cd -- 受托支付确认状态代码
    ,entr_pay_cfm_tm -- 受托支付确认时间
    ,entr_pay_acct_num_id -- 受托支付账号编号
    ,self_pay_amt -- 自主支付金额
    ,pay_indent_id -- 支付订单编号
    ,distr_chn_cd -- 放款渠道代码
    ,distr_dt -- 放款日期
    ,distr_advise_sucs_flg -- 放款通知成功标志
    ,distr_end_dt -- 放款结束日期
    ,loan_perds -- 贷款期数
    ,repay_card_type_cd -- 还款卡类型代码
    ,deflt_repay_day -- 默认还款日
    ,loan_termnt_dt -- 贷款终止日期
    ,blon_loan_amort_dt -- 气球贷摊销日期
    ,input_stamp_tax_flg -- 录入印花税标志
    ,stamp_tax_tax_acct_id -- 印花税扣税账户编号
    ,stamp_tax_acct_name -- 印花税扣税账号名称
    ,stamp_tax_amt -- 印花税金额
    ,prod_chn_idf_cd -- 产品渠道标识代码
    ,rela_flow_num -- 关联流水号
    ,file_int_accr_flg -- 靠档计息标志
    ,due_diligence_flg -- 尽调标志
    ,outline_vrif_idti_flg -- 线下核身标志
    ,out_acct_impt_cond_descb -- 出账落实条件描述
    ,risk_mgmt_rest_cd -- 风控结果代码
    ,guar_guar_letter_id -- 担保保证函编号
    ,group_cust_flg -- 集团客户标志
    ,group_cust_name -- 集团客户名称
    ,group_cust_id -- 集团客户编号
    ,group_cust_aval_open_lmt -- 集团客户可用敞口额度
    ,brwer_and_group_rela_cd -- 借款人与集团关系代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.appl_id, o.appl_id) as appl_id -- 申请编号
    ,nvl(n.out_acct_flow_num, o.out_acct_flow_num) as out_acct_flow_num -- 出账流水号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.appl_distr_amt, o.appl_distr_amt) as appl_distr_amt -- 申请放款金额
    ,nvl(n.hqd_centr_out_acct_flg, o.hqd_centr_out_acct_flg) as hqd_centr_out_acct_flg -- 好企贷集中出账标志
    ,nvl(n.recver_open_bank_name, o.recver_open_bank_name) as recver_open_bank_name -- 收款人开户行名称
    ,nvl(n.open_acct_bind_mobile_no, o.open_acct_bind_mobile_no) as open_acct_bind_mobile_no -- 开户绑定手机号码
    ,nvl(n.loan_distr_dt, o.loan_distr_dt) as loan_distr_dt -- 贷款发放日期
    ,nvl(n.loan_actl_distr_dt, o.loan_actl_distr_dt) as loan_actl_distr_dt -- 贷款实际发放日期
    ,nvl(n.entr_pay_cfm_status_cd, o.entr_pay_cfm_status_cd) as entr_pay_cfm_status_cd -- 受托支付确认状态代码
    ,nvl(n.entr_pay_cfm_tm, o.entr_pay_cfm_tm) as entr_pay_cfm_tm -- 受托支付确认时间
    ,nvl(n.entr_pay_acct_num_id, o.entr_pay_acct_num_id) as entr_pay_acct_num_id -- 受托支付账号编号
    ,nvl(n.self_pay_amt, o.self_pay_amt) as self_pay_amt -- 自主支付金额
    ,nvl(n.pay_indent_id, o.pay_indent_id) as pay_indent_id -- 支付订单编号
    ,nvl(n.distr_chn_cd, o.distr_chn_cd) as distr_chn_cd -- 放款渠道代码
    ,nvl(n.distr_dt, o.distr_dt) as distr_dt -- 放款日期
    ,nvl(n.distr_advise_sucs_flg, o.distr_advise_sucs_flg) as distr_advise_sucs_flg -- 放款通知成功标志
    ,nvl(n.distr_end_dt, o.distr_end_dt) as distr_end_dt -- 放款结束日期
    ,nvl(n.loan_perds, o.loan_perds) as loan_perds -- 贷款期数
    ,nvl(n.repay_card_type_cd, o.repay_card_type_cd) as repay_card_type_cd -- 还款卡类型代码
    ,nvl(n.deflt_repay_day, o.deflt_repay_day) as deflt_repay_day -- 默认还款日
    ,nvl(n.loan_termnt_dt, o.loan_termnt_dt) as loan_termnt_dt -- 贷款终止日期
    ,nvl(n.blon_loan_amort_dt, o.blon_loan_amort_dt) as blon_loan_amort_dt -- 气球贷摊销日期
    ,nvl(n.input_stamp_tax_flg, o.input_stamp_tax_flg) as input_stamp_tax_flg -- 录入印花税标志
    ,nvl(n.stamp_tax_tax_acct_id, o.stamp_tax_tax_acct_id) as stamp_tax_tax_acct_id -- 印花税扣税账户编号
    ,nvl(n.stamp_tax_acct_name, o.stamp_tax_acct_name) as stamp_tax_acct_name -- 印花税扣税账号名称
    ,nvl(n.stamp_tax_amt, o.stamp_tax_amt) as stamp_tax_amt -- 印花税金额
    ,nvl(n.prod_chn_idf_cd, o.prod_chn_idf_cd) as prod_chn_idf_cd -- 产品渠道标识代码
    ,nvl(n.rela_flow_num, o.rela_flow_num) as rela_flow_num -- 关联流水号
    ,nvl(n.file_int_accr_flg, o.file_int_accr_flg) as file_int_accr_flg -- 靠档计息标志
    ,nvl(n.due_diligence_flg, o.due_diligence_flg) as due_diligence_flg -- 尽调标志
    ,nvl(n.outline_vrif_idti_flg, o.outline_vrif_idti_flg) as outline_vrif_idti_flg -- 线下核身标志
    ,nvl(n.out_acct_impt_cond_descb, o.out_acct_impt_cond_descb) as out_acct_impt_cond_descb -- 出账落实条件描述
    ,nvl(n.risk_mgmt_rest_cd, o.risk_mgmt_rest_cd) as risk_mgmt_rest_cd -- 风控结果代码
    ,nvl(n.guar_guar_letter_id, o.guar_guar_letter_id) as guar_guar_letter_id -- 担保保证函编号
    ,nvl(n.group_cust_flg, o.group_cust_flg) as group_cust_flg -- 集团客户标志
    ,nvl(n.group_cust_name, o.group_cust_name) as group_cust_name -- 集团客户名称
    ,nvl(n.group_cust_id, o.group_cust_id) as group_cust_id -- 集团客户编号
    ,nvl(n.group_cust_aval_open_lmt, o.group_cust_aval_open_lmt) as group_cust_aval_open_lmt -- 集团客户可用敞口额度
    ,nvl(n.brwer_and_group_rela_cd, o.brwer_and_group_rela_cd) as brwer_and_group_rela_cd -- 借款人与集团关系代码
    ,case when
            n.appl_id is null
            and n.out_acct_flow_num is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appl_id is null
            and n.out_acct_flow_num is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appl_id is null
            and n.out_acct_flow_num is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.appl_id = n.appl_id
            and o.out_acct_flow_num = n.out_acct_flow_num
            and o.lp_id = n.lp_id
where (
        o.appl_id is null
        and o.out_acct_flow_num is null
        and o.lp_id is null
    )
    or (
        n.appl_id is null
        and n.out_acct_flow_num is null
        and n.lp_id is null
    )
    or (
        o.appl_distr_amt <> n.appl_distr_amt
        or o.hqd_centr_out_acct_flg <> n.hqd_centr_out_acct_flg
        or o.recver_open_bank_name <> n.recver_open_bank_name
        or o.open_acct_bind_mobile_no <> n.open_acct_bind_mobile_no
        or o.loan_distr_dt <> n.loan_distr_dt
        or o.loan_actl_distr_dt <> n.loan_actl_distr_dt
        or o.entr_pay_cfm_status_cd <> n.entr_pay_cfm_status_cd
        or o.entr_pay_cfm_tm <> n.entr_pay_cfm_tm
        or o.entr_pay_acct_num_id <> n.entr_pay_acct_num_id
        or o.self_pay_amt <> n.self_pay_amt
        or o.pay_indent_id <> n.pay_indent_id
        or o.distr_chn_cd <> n.distr_chn_cd
        or o.distr_dt <> n.distr_dt
        or o.distr_advise_sucs_flg <> n.distr_advise_sucs_flg
        or o.distr_end_dt <> n.distr_end_dt
        or o.loan_perds <> n.loan_perds
        or o.repay_card_type_cd <> n.repay_card_type_cd
        or o.deflt_repay_day <> n.deflt_repay_day
        or o.loan_termnt_dt <> n.loan_termnt_dt
        or o.blon_loan_amort_dt <> n.blon_loan_amort_dt
        or o.input_stamp_tax_flg <> n.input_stamp_tax_flg
        or o.stamp_tax_tax_acct_id <> n.stamp_tax_tax_acct_id
        or o.stamp_tax_acct_name <> n.stamp_tax_acct_name
        or o.stamp_tax_amt <> n.stamp_tax_amt
        or o.prod_chn_idf_cd <> n.prod_chn_idf_cd
        or o.rela_flow_num <> n.rela_flow_num
        or o.file_int_accr_flg <> n.file_int_accr_flg
        or o.due_diligence_flg <> n.due_diligence_flg
        or o.outline_vrif_idti_flg <> n.outline_vrif_idti_flg
        or o.out_acct_impt_cond_descb <> n.out_acct_impt_cond_descb
        or o.risk_mgmt_rest_cd <> n.risk_mgmt_rest_cd
        or o.guar_guar_letter_id <> n.guar_guar_letter_id
        or o.group_cust_flg <> n.group_cust_flg
        or o.group_cust_name <> n.group_cust_name
        or o.group_cust_id <> n.group_cust_id
        or o.group_cust_aval_open_lmt <> n.group_cust_aval_open_lmt
        or o.brwer_and_group_rela_cd <> n.brwer_and_group_rela_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h_icmsf1_cl(
            appl_id -- 申请编号
    ,out_acct_flow_num -- 出账流水号
    ,lp_id -- 法人编号
    ,appl_distr_amt -- 申请放款金额
    ,hqd_centr_out_acct_flg -- 好企贷集中出账标志
    ,recver_open_bank_name -- 收款人开户行名称
    ,open_acct_bind_mobile_no -- 开户绑定手机号码
    ,loan_distr_dt -- 贷款发放日期
    ,loan_actl_distr_dt -- 贷款实际发放日期
    ,entr_pay_cfm_status_cd -- 受托支付确认状态代码
    ,entr_pay_cfm_tm -- 受托支付确认时间
    ,entr_pay_acct_num_id -- 受托支付账号编号
    ,self_pay_amt -- 自主支付金额
    ,pay_indent_id -- 支付订单编号
    ,distr_chn_cd -- 放款渠道代码
    ,distr_dt -- 放款日期
    ,distr_advise_sucs_flg -- 放款通知成功标志
    ,distr_end_dt -- 放款结束日期
    ,loan_perds -- 贷款期数
    ,repay_card_type_cd -- 还款卡类型代码
    ,deflt_repay_day -- 默认还款日
    ,loan_termnt_dt -- 贷款终止日期
    ,blon_loan_amort_dt -- 气球贷摊销日期
    ,input_stamp_tax_flg -- 录入印花税标志
    ,stamp_tax_tax_acct_id -- 印花税扣税账户编号
    ,stamp_tax_acct_name -- 印花税扣税账号名称
    ,stamp_tax_amt -- 印花税金额
    ,prod_chn_idf_cd -- 产品渠道标识代码
    ,rela_flow_num -- 关联流水号
    ,file_int_accr_flg -- 靠档计息标志
    ,due_diligence_flg -- 尽调标志
    ,outline_vrif_idti_flg -- 线下核身标志
    ,out_acct_impt_cond_descb -- 出账落实条件描述
    ,risk_mgmt_rest_cd -- 风控结果代码
    ,guar_guar_letter_id -- 担保保证函编号
    ,group_cust_flg -- 集团客户标志
    ,group_cust_name -- 集团客户名称
    ,group_cust_id -- 集团客户编号
    ,group_cust_aval_open_lmt -- 集团客户可用敞口额度
    ,brwer_and_group_rela_cd -- 借款人与集团关系代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h_icmsf1_op(
            appl_id -- 申请编号
    ,out_acct_flow_num -- 出账流水号
    ,lp_id -- 法人编号
    ,appl_distr_amt -- 申请放款金额
    ,hqd_centr_out_acct_flg -- 好企贷集中出账标志
    ,recver_open_bank_name -- 收款人开户行名称
    ,open_acct_bind_mobile_no -- 开户绑定手机号码
    ,loan_distr_dt -- 贷款发放日期
    ,loan_actl_distr_dt -- 贷款实际发放日期
    ,entr_pay_cfm_status_cd -- 受托支付确认状态代码
    ,entr_pay_cfm_tm -- 受托支付确认时间
    ,entr_pay_acct_num_id -- 受托支付账号编号
    ,self_pay_amt -- 自主支付金额
    ,pay_indent_id -- 支付订单编号
    ,distr_chn_cd -- 放款渠道代码
    ,distr_dt -- 放款日期
    ,distr_advise_sucs_flg -- 放款通知成功标志
    ,distr_end_dt -- 放款结束日期
    ,loan_perds -- 贷款期数
    ,repay_card_type_cd -- 还款卡类型代码
    ,deflt_repay_day -- 默认还款日
    ,loan_termnt_dt -- 贷款终止日期
    ,blon_loan_amort_dt -- 气球贷摊销日期
    ,input_stamp_tax_flg -- 录入印花税标志
    ,stamp_tax_tax_acct_id -- 印花税扣税账户编号
    ,stamp_tax_acct_name -- 印花税扣税账号名称
    ,stamp_tax_amt -- 印花税金额
    ,prod_chn_idf_cd -- 产品渠道标识代码
    ,rela_flow_num -- 关联流水号
    ,file_int_accr_flg -- 靠档计息标志
    ,due_diligence_flg -- 尽调标志
    ,outline_vrif_idti_flg -- 线下核身标志
    ,out_acct_impt_cond_descb -- 出账落实条件描述
    ,risk_mgmt_rest_cd -- 风控结果代码
    ,guar_guar_letter_id -- 担保保证函编号
    ,group_cust_flg -- 集团客户标志
    ,group_cust_name -- 集团客户名称
    ,group_cust_id -- 集团客户编号
    ,group_cust_aval_open_lmt -- 集团客户可用敞口额度
    ,brwer_and_group_rela_cd -- 借款人与集团关系代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.appl_id -- 申请编号
    ,o.out_acct_flow_num -- 出账流水号
    ,o.lp_id -- 法人编号
    ,o.appl_distr_amt -- 申请放款金额
    ,o.hqd_centr_out_acct_flg -- 好企贷集中出账标志
    ,o.recver_open_bank_name -- 收款人开户行名称
    ,o.open_acct_bind_mobile_no -- 开户绑定手机号码
    ,o.loan_distr_dt -- 贷款发放日期
    ,o.loan_actl_distr_dt -- 贷款实际发放日期
    ,o.entr_pay_cfm_status_cd -- 受托支付确认状态代码
    ,o.entr_pay_cfm_tm -- 受托支付确认时间
    ,o.entr_pay_acct_num_id -- 受托支付账号编号
    ,o.self_pay_amt -- 自主支付金额
    ,o.pay_indent_id -- 支付订单编号
    ,o.distr_chn_cd -- 放款渠道代码
    ,o.distr_dt -- 放款日期
    ,o.distr_advise_sucs_flg -- 放款通知成功标志
    ,o.distr_end_dt -- 放款结束日期
    ,o.loan_perds -- 贷款期数
    ,o.repay_card_type_cd -- 还款卡类型代码
    ,o.deflt_repay_day -- 默认还款日
    ,o.loan_termnt_dt -- 贷款终止日期
    ,o.blon_loan_amort_dt -- 气球贷摊销日期
    ,o.input_stamp_tax_flg -- 录入印花税标志
    ,o.stamp_tax_tax_acct_id -- 印花税扣税账户编号
    ,o.stamp_tax_acct_name -- 印花税扣税账号名称
    ,o.stamp_tax_amt -- 印花税金额
    ,o.prod_chn_idf_cd -- 产品渠道标识代码
    ,o.rela_flow_num -- 关联流水号
    ,o.file_int_accr_flg -- 靠档计息标志
    ,o.due_diligence_flg -- 尽调标志
    ,o.outline_vrif_idti_flg -- 线下核身标志
    ,o.out_acct_impt_cond_descb -- 出账落实条件描述
    ,o.risk_mgmt_rest_cd -- 风控结果代码
    ,o.guar_guar_letter_id -- 担保保证函编号
    ,o.group_cust_flg -- 集团客户标志
    ,o.group_cust_name -- 集团客户名称
    ,o.group_cust_id -- 集团客户编号
    ,o.group_cust_aval_open_lmt -- 集团客户可用敞口额度
    ,o.brwer_and_group_rela_cd -- 借款人与集团关系代码
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
from ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.out_acct_flow_num = n.out_acct_flow_num
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h_icmsf1_cl d
        on
            o.appl_id = d.appl_id
            and o.out_acct_flow_num = d.out_acct_flow_num
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h;
--alter table ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_out_acct_indv_loan_attach_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_out_acct_indv_loan_attach_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
