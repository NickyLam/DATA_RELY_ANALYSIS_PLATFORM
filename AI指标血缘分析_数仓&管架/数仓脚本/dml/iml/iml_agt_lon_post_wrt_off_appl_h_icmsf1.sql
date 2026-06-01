/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_lon_post_wrt_off_appl_h_icmsf1
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
alter table ${iml_schema}.agt_lon_post_wrt_off_appl_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_lon_post_wrt_off_appl_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lon_post_wrt_off_appl_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_lon_post_wrt_off_appl_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_lon_post_wrt_off_appl_h_icmsf1_op purge;
drop table ${iml_schema}.agt_lon_post_wrt_off_appl_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lon_post_wrt_off_appl_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,wrt_off_flow_num -- 核销流水号
    ,wrt_off_cate_cd -- 核销类别代码
    ,wrt_off_batch_no -- 核销批次号
    ,loan_bal -- 贷款余额
    ,pric_amt -- 本金金额
    ,wrt_off_amt -- 核销金额
    ,wrt_off_pric -- 核销本金
    ,wrt_off_in_bs_int -- 核销表内利息
    ,wrt_off_off_bs_int -- 核销表外利息
    ,curr_cd -- 币种代码
    ,apv_wrt_off_dt -- 审批核销日期
    ,apv_status_cd -- 审批状态代码
    ,wrt_off_dt -- 核销日期
    ,guar_recs_situ_and_rest_descb -- 担保追偿情况及结果描述
    ,brwer_recs_situ_and_rest_descb -- 借款人追偿情况及结果描述
    ,cust_id -- 客户编号
    ,court_final_rule_num -- 法院最终裁定文号
    ,court_final_rule_tm -- 法院最终裁定时间
    ,court_final_rule_doc_name -- 法院最终裁定文件名称
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,bad_debt_form_rs_descb -- 呆账形成原因描述
    ,duty_idtfy_and_rest_descb -- 责任认定及处理结果描述
    ,acct_instit_id -- 账务机构编号
    ,dubil_id_comb -- 借据编号集合
    ,mang_corp_name -- 经营企业名称
    ,resv_debtor_recs_flg -- 保留对债务人追索权标志
    ,cust_name -- 客户名称
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,gender_cd -- 性别代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,bl_induty_type_cd -- 所属行业类型代码
    ,bus_lics_revo_dt -- 营业执照吊销日期
    ,advc_amt -- 垫付金额
    ,mini_loan_prod_id -- 微贷产品编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_lon_post_wrt_off_appl_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_lon_post_wrt_off_appl_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lon_post_wrt_off_appl_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_lon_post_wrt_off_appl_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lon_post_wrt_off_appl_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_afterloan_write_off-1
insert into ${iml_schema}.agt_lon_post_wrt_off_appl_h_icmsf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,wrt_off_flow_num -- 核销流水号
    ,wrt_off_cate_cd -- 核销类别代码
    ,wrt_off_batch_no -- 核销批次号
    ,loan_bal -- 贷款余额
    ,pric_amt -- 本金金额
    ,wrt_off_amt -- 核销金额
    ,wrt_off_pric -- 核销本金
    ,wrt_off_in_bs_int -- 核销表内利息
    ,wrt_off_off_bs_int -- 核销表外利息
    ,curr_cd -- 币种代码
    ,apv_wrt_off_dt -- 审批核销日期
    ,apv_status_cd -- 审批状态代码
    ,wrt_off_dt -- 核销日期
    ,guar_recs_situ_and_rest_descb -- 担保追偿情况及结果描述
    ,brwer_recs_situ_and_rest_descb -- 借款人追偿情况及结果描述
    ,cust_id -- 客户编号
    ,court_final_rule_num -- 法院最终裁定文号
    ,court_final_rule_tm -- 法院最终裁定时间
    ,court_final_rule_doc_name -- 法院最终裁定文件名称
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,bad_debt_form_rs_descb -- 呆账形成原因描述
    ,duty_idtfy_and_rest_descb -- 责任认定及处理结果描述
    ,acct_instit_id -- 账务机构编号
    ,dubil_id_comb -- 借据编号集合
    ,mang_corp_name -- 经营企业名称
    ,resv_debtor_recs_flg -- 保留对债务人追索权标志
    ,cust_name -- 客户名称
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,gender_cd -- 性别代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,bl_induty_type_cd -- 所属行业类型代码
    ,bus_lics_revo_dt -- 营业执照吊销日期
    ,advc_amt -- 垫付金额
    ,mini_loan_prod_id -- 微贷产品编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206003'||P1.SERIALNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 核销流水号
    ,nvl(trim(P1.CANCELTYPE),'-') -- 核销类别代码
    ,P1.DZHXBATCHNO -- 核销批次号
    ,P1.LOANBALANCE -- 贷款余额
    ,P1.AMT -- 本金金额
    ,P1.APPROVEAMT -- 核销金额
    ,P1.CANCELAMOUNT -- 核销本金
    ,P1.CANCELRECEIN -- 核销表内利息
    ,P1.CANCELRECEOUT -- 核销表外利息
    ,nvl(trim(P1.CURTYPE),'-') -- 币种代码
    ,${iml_schema}.dateformat_max2(P1.APPROVEVERIFICATIONPERIOD) -- 审批核销日期
    ,nvl(trim(P1.APPROVESTATUS),'-') -- 审批状态代码
    ,P1.APPROVEDATE -- 核销日期
    ,P1.CLAIMSRECOVERYGRT -- 担保追偿情况及结果描述
    ,P1.CLAIMSRECOVERYBORROWER -- 借款人追偿情况及结果描述
    ,P1.CUSTOMERID -- 客户编号
    ,P1.COURTFINARULINGNUMBER -- 法院最终裁定文号
    ,P1.COURTFINARULINGTIME -- 法院最终裁定时间
    ,P1.COURTFINARULINGTITLE -- 法院最终裁定文件名称
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.BADDEBTSCAUSEREASON -- 呆账形成原因描述
    ,P1.RESPONSIBILITYIDENTIFYRESULT -- 责任认定及处理结果描述
    ,P1.FINABRID -- 账务机构编号
    ,P1.ACCIDS -- 借据编号集合
    ,P1.COMPNAME -- 经营企业名称
    ,nvl(trim(P1.ISRETAINRECOURSE),'-') -- 保留对债务人追索权标志
    ,P1.CUSTOMERNAME -- 客户名称
    ,P1.CERTID -- 证件号码
    ,nvl(trim(P1.CERTTYPE),'0000') -- 证件类型代码
    ,nvl(trim(P1.CUSSEX),'0') -- 性别代码
    ,nvl(trim(P1.CUSMARST),'90') -- 婚姻状况代码
    ,nvl(trim(P1.INDUSTRY),'-') -- 所属行业类型代码
    ,${iml_schema}.dateformat_max2(P1.BORROWERBUSICODECANCELTIME) -- 营业执照吊销日期
    ,P1.ADVANCEPAYMENT -- 垫付金额
    ,P1.UPLPRODUCTID -- 微贷产品编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_afterloan_write_off' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_afterloan_write_off p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_lon_post_wrt_off_appl_h_icmsf1_tm 
  	                                group by 
  	                                        appl_id
  	                                        ,lp_id
  	                                        ,wrt_off_flow_num
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
        into ${iml_schema}.agt_lon_post_wrt_off_appl_h_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,wrt_off_flow_num -- 核销流水号
    ,wrt_off_cate_cd -- 核销类别代码
    ,wrt_off_batch_no -- 核销批次号
    ,loan_bal -- 贷款余额
    ,pric_amt -- 本金金额
    ,wrt_off_amt -- 核销金额
    ,wrt_off_pric -- 核销本金
    ,wrt_off_in_bs_int -- 核销表内利息
    ,wrt_off_off_bs_int -- 核销表外利息
    ,curr_cd -- 币种代码
    ,apv_wrt_off_dt -- 审批核销日期
    ,apv_status_cd -- 审批状态代码
    ,wrt_off_dt -- 核销日期
    ,guar_recs_situ_and_rest_descb -- 担保追偿情况及结果描述
    ,brwer_recs_situ_and_rest_descb -- 借款人追偿情况及结果描述
    ,cust_id -- 客户编号
    ,court_final_rule_num -- 法院最终裁定文号
    ,court_final_rule_tm -- 法院最终裁定时间
    ,court_final_rule_doc_name -- 法院最终裁定文件名称
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,bad_debt_form_rs_descb -- 呆账形成原因描述
    ,duty_idtfy_and_rest_descb -- 责任认定及处理结果描述
    ,acct_instit_id -- 账务机构编号
    ,dubil_id_comb -- 借据编号集合
    ,mang_corp_name -- 经营企业名称
    ,resv_debtor_recs_flg -- 保留对债务人追索权标志
    ,cust_name -- 客户名称
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,gender_cd -- 性别代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,bl_induty_type_cd -- 所属行业类型代码
    ,bus_lics_revo_dt -- 营业执照吊销日期
    ,advc_amt -- 垫付金额
    ,mini_loan_prod_id -- 微贷产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_lon_post_wrt_off_appl_h_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,wrt_off_flow_num -- 核销流水号
    ,wrt_off_cate_cd -- 核销类别代码
    ,wrt_off_batch_no -- 核销批次号
    ,loan_bal -- 贷款余额
    ,pric_amt -- 本金金额
    ,wrt_off_amt -- 核销金额
    ,wrt_off_pric -- 核销本金
    ,wrt_off_in_bs_int -- 核销表内利息
    ,wrt_off_off_bs_int -- 核销表外利息
    ,curr_cd -- 币种代码
    ,apv_wrt_off_dt -- 审批核销日期
    ,apv_status_cd -- 审批状态代码
    ,wrt_off_dt -- 核销日期
    ,guar_recs_situ_and_rest_descb -- 担保追偿情况及结果描述
    ,brwer_recs_situ_and_rest_descb -- 借款人追偿情况及结果描述
    ,cust_id -- 客户编号
    ,court_final_rule_num -- 法院最终裁定文号
    ,court_final_rule_tm -- 法院最终裁定时间
    ,court_final_rule_doc_name -- 法院最终裁定文件名称
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,bad_debt_form_rs_descb -- 呆账形成原因描述
    ,duty_idtfy_and_rest_descb -- 责任认定及处理结果描述
    ,acct_instit_id -- 账务机构编号
    ,dubil_id_comb -- 借据编号集合
    ,mang_corp_name -- 经营企业名称
    ,resv_debtor_recs_flg -- 保留对债务人追索权标志
    ,cust_name -- 客户名称
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,gender_cd -- 性别代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,bl_induty_type_cd -- 所属行业类型代码
    ,bus_lics_revo_dt -- 营业执照吊销日期
    ,advc_amt -- 垫付金额
    ,mini_loan_prod_id -- 微贷产品编号
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
    ,nvl(n.wrt_off_flow_num, o.wrt_off_flow_num) as wrt_off_flow_num -- 核销流水号
    ,nvl(n.wrt_off_cate_cd, o.wrt_off_cate_cd) as wrt_off_cate_cd -- 核销类别代码
    ,nvl(n.wrt_off_batch_no, o.wrt_off_batch_no) as wrt_off_batch_no -- 核销批次号
    ,nvl(n.loan_bal, o.loan_bal) as loan_bal -- 贷款余额
    ,nvl(n.pric_amt, o.pric_amt) as pric_amt -- 本金金额
    ,nvl(n.wrt_off_amt, o.wrt_off_amt) as wrt_off_amt -- 核销金额
    ,nvl(n.wrt_off_pric, o.wrt_off_pric) as wrt_off_pric -- 核销本金
    ,nvl(n.wrt_off_in_bs_int, o.wrt_off_in_bs_int) as wrt_off_in_bs_int -- 核销表内利息
    ,nvl(n.wrt_off_off_bs_int, o.wrt_off_off_bs_int) as wrt_off_off_bs_int -- 核销表外利息
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.apv_wrt_off_dt, o.apv_wrt_off_dt) as apv_wrt_off_dt -- 审批核销日期
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.wrt_off_dt, o.wrt_off_dt) as wrt_off_dt -- 核销日期
    ,nvl(n.guar_recs_situ_and_rest_descb, o.guar_recs_situ_and_rest_descb) as guar_recs_situ_and_rest_descb -- 担保追偿情况及结果描述
    ,nvl(n.brwer_recs_situ_and_rest_descb, o.brwer_recs_situ_and_rest_descb) as brwer_recs_situ_and_rest_descb -- 借款人追偿情况及结果描述
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.court_final_rule_num, o.court_final_rule_num) as court_final_rule_num -- 法院最终裁定文号
    ,nvl(n.court_final_rule_tm, o.court_final_rule_tm) as court_final_rule_tm -- 法院最终裁定时间
    ,nvl(n.court_final_rule_doc_name, o.court_final_rule_doc_name) as court_final_rule_doc_name -- 法院最终裁定文件名称
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.bad_debt_form_rs_descb, o.bad_debt_form_rs_descb) as bad_debt_form_rs_descb -- 呆账形成原因描述
    ,nvl(n.duty_idtfy_and_rest_descb, o.duty_idtfy_and_rest_descb) as duty_idtfy_and_rest_descb -- 责任认定及处理结果描述
    ,nvl(n.acct_instit_id, o.acct_instit_id) as acct_instit_id -- 账务机构编号
    ,nvl(n.dubil_id_comb, o.dubil_id_comb) as dubil_id_comb -- 借据编号集合
    ,nvl(n.mang_corp_name, o.mang_corp_name) as mang_corp_name -- 经营企业名称
    ,nvl(n.resv_debtor_recs_flg, o.resv_debtor_recs_flg) as resv_debtor_recs_flg -- 保留对债务人追索权标志
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.gender_cd, o.gender_cd) as gender_cd -- 性别代码
    ,nvl(n.marriage_situ_cd, o.marriage_situ_cd) as marriage_situ_cd -- 婚姻状况代码
    ,nvl(n.bl_induty_type_cd, o.bl_induty_type_cd) as bl_induty_type_cd -- 所属行业类型代码
    ,nvl(n.bus_lics_revo_dt, o.bus_lics_revo_dt) as bus_lics_revo_dt -- 营业执照吊销日期
    ,nvl(n.advc_amt, o.advc_amt) as advc_amt -- 垫付金额
    ,nvl(n.mini_loan_prod_id, o.mini_loan_prod_id) as mini_loan_prod_id -- 微贷产品编号
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.wrt_off_flow_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.wrt_off_flow_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.wrt_off_flow_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_lon_post_wrt_off_appl_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_lon_post_wrt_off_appl_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.wrt_off_flow_num = n.wrt_off_flow_num
where (
        o.appl_id is null
        and o.lp_id is null
        and o.wrt_off_flow_num is null
    )
    or (
        n.appl_id is null
        and n.lp_id is null
        and n.wrt_off_flow_num is null
    )
    or (
        o.wrt_off_cate_cd <> n.wrt_off_cate_cd
        or o.wrt_off_batch_no <> n.wrt_off_batch_no
        or o.loan_bal <> n.loan_bal
        or o.pric_amt <> n.pric_amt
        or o.wrt_off_amt <> n.wrt_off_amt
        or o.wrt_off_pric <> n.wrt_off_pric
        or o.wrt_off_in_bs_int <> n.wrt_off_in_bs_int
        or o.wrt_off_off_bs_int <> n.wrt_off_off_bs_int
        or o.curr_cd <> n.curr_cd
        or o.apv_wrt_off_dt <> n.apv_wrt_off_dt
        or o.apv_status_cd <> n.apv_status_cd
        or o.wrt_off_dt <> n.wrt_off_dt
        or o.guar_recs_situ_and_rest_descb <> n.guar_recs_situ_and_rest_descb
        or o.brwer_recs_situ_and_rest_descb <> n.brwer_recs_situ_and_rest_descb
        or o.cust_id <> n.cust_id
        or o.court_final_rule_num <> n.court_final_rule_num
        or o.court_final_rule_tm <> n.court_final_rule_tm
        or o.court_final_rule_doc_name <> n.court_final_rule_doc_name
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.bad_debt_form_rs_descb <> n.bad_debt_form_rs_descb
        or o.duty_idtfy_and_rest_descb <> n.duty_idtfy_and_rest_descb
        or o.acct_instit_id <> n.acct_instit_id
        or o.dubil_id_comb <> n.dubil_id_comb
        or o.mang_corp_name <> n.mang_corp_name
        or o.resv_debtor_recs_flg <> n.resv_debtor_recs_flg
        or o.cust_name <> n.cust_name
        or o.cert_no <> n.cert_no
        or o.cert_type_cd <> n.cert_type_cd
        or o.gender_cd <> n.gender_cd
        or o.marriage_situ_cd <> n.marriage_situ_cd
        or o.bl_induty_type_cd <> n.bl_induty_type_cd
        or o.bus_lics_revo_dt <> n.bus_lics_revo_dt
        or o.advc_amt <> n.advc_amt
        or o.mini_loan_prod_id <> n.mini_loan_prod_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_lon_post_wrt_off_appl_h_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,wrt_off_flow_num -- 核销流水号
    ,wrt_off_cate_cd -- 核销类别代码
    ,wrt_off_batch_no -- 核销批次号
    ,loan_bal -- 贷款余额
    ,pric_amt -- 本金金额
    ,wrt_off_amt -- 核销金额
    ,wrt_off_pric -- 核销本金
    ,wrt_off_in_bs_int -- 核销表内利息
    ,wrt_off_off_bs_int -- 核销表外利息
    ,curr_cd -- 币种代码
    ,apv_wrt_off_dt -- 审批核销日期
    ,apv_status_cd -- 审批状态代码
    ,wrt_off_dt -- 核销日期
    ,guar_recs_situ_and_rest_descb -- 担保追偿情况及结果描述
    ,brwer_recs_situ_and_rest_descb -- 借款人追偿情况及结果描述
    ,cust_id -- 客户编号
    ,court_final_rule_num -- 法院最终裁定文号
    ,court_final_rule_tm -- 法院最终裁定时间
    ,court_final_rule_doc_name -- 法院最终裁定文件名称
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,bad_debt_form_rs_descb -- 呆账形成原因描述
    ,duty_idtfy_and_rest_descb -- 责任认定及处理结果描述
    ,acct_instit_id -- 账务机构编号
    ,dubil_id_comb -- 借据编号集合
    ,mang_corp_name -- 经营企业名称
    ,resv_debtor_recs_flg -- 保留对债务人追索权标志
    ,cust_name -- 客户名称
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,gender_cd -- 性别代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,bl_induty_type_cd -- 所属行业类型代码
    ,bus_lics_revo_dt -- 营业执照吊销日期
    ,advc_amt -- 垫付金额
    ,mini_loan_prod_id -- 微贷产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_lon_post_wrt_off_appl_h_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,wrt_off_flow_num -- 核销流水号
    ,wrt_off_cate_cd -- 核销类别代码
    ,wrt_off_batch_no -- 核销批次号
    ,loan_bal -- 贷款余额
    ,pric_amt -- 本金金额
    ,wrt_off_amt -- 核销金额
    ,wrt_off_pric -- 核销本金
    ,wrt_off_in_bs_int -- 核销表内利息
    ,wrt_off_off_bs_int -- 核销表外利息
    ,curr_cd -- 币种代码
    ,apv_wrt_off_dt -- 审批核销日期
    ,apv_status_cd -- 审批状态代码
    ,wrt_off_dt -- 核销日期
    ,guar_recs_situ_and_rest_descb -- 担保追偿情况及结果描述
    ,brwer_recs_situ_and_rest_descb -- 借款人追偿情况及结果描述
    ,cust_id -- 客户编号
    ,court_final_rule_num -- 法院最终裁定文号
    ,court_final_rule_tm -- 法院最终裁定时间
    ,court_final_rule_doc_name -- 法院最终裁定文件名称
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,bad_debt_form_rs_descb -- 呆账形成原因描述
    ,duty_idtfy_and_rest_descb -- 责任认定及处理结果描述
    ,acct_instit_id -- 账务机构编号
    ,dubil_id_comb -- 借据编号集合
    ,mang_corp_name -- 经营企业名称
    ,resv_debtor_recs_flg -- 保留对债务人追索权标志
    ,cust_name -- 客户名称
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,gender_cd -- 性别代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,bl_induty_type_cd -- 所属行业类型代码
    ,bus_lics_revo_dt -- 营业执照吊销日期
    ,advc_amt -- 垫付金额
    ,mini_loan_prod_id -- 微贷产品编号
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
    ,o.wrt_off_flow_num -- 核销流水号
    ,o.wrt_off_cate_cd -- 核销类别代码
    ,o.wrt_off_batch_no -- 核销批次号
    ,o.loan_bal -- 贷款余额
    ,o.pric_amt -- 本金金额
    ,o.wrt_off_amt -- 核销金额
    ,o.wrt_off_pric -- 核销本金
    ,o.wrt_off_in_bs_int -- 核销表内利息
    ,o.wrt_off_off_bs_int -- 核销表外利息
    ,o.curr_cd -- 币种代码
    ,o.apv_wrt_off_dt -- 审批核销日期
    ,o.apv_status_cd -- 审批状态代码
    ,o.wrt_off_dt -- 核销日期
    ,o.guar_recs_situ_and_rest_descb -- 担保追偿情况及结果描述
    ,o.brwer_recs_situ_and_rest_descb -- 借款人追偿情况及结果描述
    ,o.cust_id -- 客户编号
    ,o.court_final_rule_num -- 法院最终裁定文号
    ,o.court_final_rule_tm -- 法院最终裁定时间
    ,o.court_final_rule_doc_name -- 法院最终裁定文件名称
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.bad_debt_form_rs_descb -- 呆账形成原因描述
    ,o.duty_idtfy_and_rest_descb -- 责任认定及处理结果描述
    ,o.acct_instit_id -- 账务机构编号
    ,o.dubil_id_comb -- 借据编号集合
    ,o.mang_corp_name -- 经营企业名称
    ,o.resv_debtor_recs_flg -- 保留对债务人追索权标志
    ,o.cust_name -- 客户名称
    ,o.cert_no -- 证件号码
    ,o.cert_type_cd -- 证件类型代码
    ,o.gender_cd -- 性别代码
    ,o.marriage_situ_cd -- 婚姻状况代码
    ,o.bl_induty_type_cd -- 所属行业类型代码
    ,o.bus_lics_revo_dt -- 营业执照吊销日期
    ,o.advc_amt -- 垫付金额
    ,o.mini_loan_prod_id -- 微贷产品编号
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
from ${iml_schema}.agt_lon_post_wrt_off_appl_h_icmsf1_bk o
    left join ${iml_schema}.agt_lon_post_wrt_off_appl_h_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.wrt_off_flow_num = n.wrt_off_flow_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_lon_post_wrt_off_appl_h_icmsf1_cl d
        on
            o.appl_id = d.appl_id
            and o.lp_id = d.lp_id
            and o.wrt_off_flow_num = d.wrt_off_flow_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_lon_post_wrt_off_appl_h;
--alter table ${iml_schema}.agt_lon_post_wrt_off_appl_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_lon_post_wrt_off_appl_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_lon_post_wrt_off_appl_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_lon_post_wrt_off_appl_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_lon_post_wrt_off_appl_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_lon_post_wrt_off_appl_h_icmsf1_cl;
alter table ${iml_schema}.agt_lon_post_wrt_off_appl_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_lon_post_wrt_off_appl_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_lon_post_wrt_off_appl_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_lon_post_wrt_off_appl_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_lon_post_wrt_off_appl_h_icmsf1_op purge;
drop table ${iml_schema}.agt_lon_post_wrt_off_appl_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_lon_post_wrt_off_appl_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_lon_post_wrt_off_appl_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
