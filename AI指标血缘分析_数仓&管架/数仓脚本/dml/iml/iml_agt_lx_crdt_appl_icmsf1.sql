/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_lx_crdt_appl_icmsf1
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
alter table ${iml_schema}.agt_lx_crdt_appl add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_lx_crdt_appl_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lx_crdt_appl partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_lx_crdt_appl_icmsf1_tm purge;
drop table ${iml_schema}.agt_lx_crdt_appl_icmsf1_op purge;
drop table ${iml_schema}.agt_lx_crdt_appl_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lx_crdt_appl_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,src_appl_flow_num -- 源申请流水号
    ,prod_id -- 产品编号
    ,org_id -- 机构编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,appl_type_cd -- 申请类型代码
    ,appl_lmt -- 申请额度
    ,appl_status_cd -- 申请状态代码
    ,crdt_status_cd -- 授信状态代码
    ,guar_way_cd -- 担保方式代码
    ,guar_id -- 担保编号
    ,mode_pay_cd -- 支付方式代码
    ,asset_crdt_id -- 资方授信编号
    ,asset_type_cd -- 资产类型代码
    ,repay_way_cd -- 还款方式代码
    ,fix_out_acct_day -- 固定出账日
    ,fix_repay_day -- 固定还款日
    ,loan_tenor -- 贷款期限
    ,year_int_rat -- 年利率
    ,loan_usage -- 贷款用途
    ,enter_acct_bank_card_num -- 入账银行卡号
    ,enter_name -- 入账账户名称
    ,enter_acct_card_open_bank_no -- 入账银行卡开户行
    ,enter_acct_card_ibank_no -- 入账银行卡联行号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,id_card_effect_dt -- 身份证生效日期
    ,id_card_exp_dt -- 身份证到期日期
    ,id_card_addr_info -- 身份证地址信息
    ,issue_org -- 签发机关
    ,birth_dt -- 出生日期
    ,marriage_status_cd -- 婚姻状态代码
    ,age -- 年龄
    ,gender_cd -- 性别代码
    ,nation_cd -- 国籍代码
    ,nationty -- 民族
    ,mobile_no -- 手机号码
    ,user_bank_card_num -- 用户银行卡号
    ,user_rating_cd -- 用户评级代码
    ,fst_cotas_name -- 第一联系人名称
    ,fst_cotas_mobile_no -- 第一联系人手机号码
    ,fst_cotas_rela_cd -- 第一联系人关系代码
    ,resdnt_addr -- 居住地址
    ,career_cd -- 职业代码
    ,indus_type_cd -- 行业类型代码
    ,edu_cd -- 学历代码
    ,mon_inco -- 月收入
    ,provi_fund_payment_base -- 公积金缴纳基数
    ,soci_secu_payment_base -- 社保缴纳基数
    ,provi_fund_payment_corp -- 公积金缴纳单位名称
    ,corp_addr -- 单位地址
    ,manu_apv_flg -- 人工审批标志
    ,final_decis_rest_cd -- 最终决策结果代码
    ,final_jud_apv_lmt -- 终审审批额度
    ,final_jud_apv_tenor -- 终审审批期限
    ,final_jud_estim_price -- 终审评估价格
    ,risk_mgmt_remark -- 风控备注
    ,risk_mgmt_warn -- 风控预警
    ,apv_cmplt_dt -- 审批完成日期
    ,sugst_tenor -- 建议期限
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_lx_crdt_appl partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_lx_crdt_appl_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lx_crdt_appl partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_lx_crdt_appl_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lx_crdt_appl partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_lx_business_apply-1
insert into ${iml_schema}.agt_lx_crdt_appl_icmsf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,src_appl_flow_num -- 源申请流水号
    ,prod_id -- 产品编号
    ,org_id -- 机构编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,appl_type_cd -- 申请类型代码
    ,appl_lmt -- 申请额度
    ,appl_status_cd -- 申请状态代码
    ,crdt_status_cd -- 授信状态代码
    ,guar_way_cd -- 主担保方式代码
    ,guar_id -- 担保编号
    ,mode_pay_cd -- 支付方式代码
    ,asset_crdt_id -- 资方授信编号
    ,asset_type_cd -- 资产类型代码
    ,repay_way_cd -- 还款方式代码
    ,fix_out_acct_day -- 固定出账日
    ,fix_repay_day -- 固定还款日
    ,loan_tenor -- 贷款期限
    ,year_int_rat -- 年利率
    ,loan_usage -- 贷款用途
    ,enter_acct_bank_card_num -- 入账银行卡号
    ,enter_name -- 入账账户名称
    ,enter_acct_card_open_bank_no -- 入账银行卡开户行
    ,enter_acct_card_ibank_no -- 入账银行卡联行号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,id_card_effect_dt -- 身份证生效日期
    ,id_card_exp_dt -- 身份证到期日期
    ,id_card_addr_info -- 身份证地址信息
    ,issue_org -- 签发机关
    ,birth_dt -- 出生日期
    ,marriage_status_cd -- 婚姻状态代码
    ,age -- 年龄
    ,gender_cd -- 性别代码
    ,nation_cd -- 国籍代码
    ,nationty -- 民族
    ,mobile_no -- 手机号码
    ,user_bank_card_num -- 用户银行卡号
    ,user_rating_cd -- 用户评级代码
    ,fst_cotas_name -- 第一联系人名称
    ,fst_cotas_mobile_no -- 第一联系人手机号码
    ,fst_cotas_rela_cd -- 第一联系人关系代码
    ,resdnt_addr -- 居住地址
    ,career_cd -- 职业代码
    ,indus_type_cd -- 行业类型代码
    ,edu_cd -- 学历代码
    ,mon_inco -- 月收入
    ,provi_fund_payment_base -- 公积金缴纳基数
    ,soci_secu_payment_base -- 社保缴纳基数
    ,provi_fund_payment_corp -- 公积金缴纳单位名称
    ,corp_addr -- 单位地址
    ,manu_apv_flg -- 人工审批标志
    ,final_decis_rest_cd -- 最终决策结果代码
    ,final_jud_apv_lmt -- 终审审批额度
    ,final_jud_apv_tenor -- 终审审批期限
    ,final_jud_estim_price -- 终审评估价格
    ,risk_mgmt_remark -- 风控备注
    ,risk_mgmt_warn -- 风控预警
    ,apv_cmplt_dt -- 审批完成日期
    ,sugst_tenor -- 建议期限
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206016 '||P1.SERIALNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 申请流水号
    ,P1.CREDITAPPLYID -- 源申请流水号
    ,P1.PRODUCTID -- 产品编号
    ,P1.PARTNERCODE -- 机构编号
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CUSTOMERNAME -- 客户名称
    ,nvl(trim(P1.BUSINESSFLAG),'-') -- 申请类型代码
    ,P1.CREDITAMOUNT -- 申请额度
    ,nvl(trim(P1.APPROVESTATUS),'-') -- 申请状态代码
    ,nvl(trim(P1.AUDITSTATUS),'-') -- 授信状态代码
    ,nvl(trim(P1.VOUCHTYPE),'-') -- 主担保方式代码
    ,P1.INSUREID -- 担保编号
    ,nvl(trim(P1.PAYMENTTYPE),'-') -- 支付方式代码
    ,P1.CREDITNO -- 资方授信编号
    ,nvl(trim(P1.ORDERTYPE),'-') -- 资产类型代码
    ,nvl(trim(P1.REPAYTYPE),'-') -- 还款方式代码
    ,P1.FIXEDBILLDAY -- 固定出账日
    ,P1.FIXEDREPAYDAY -- 固定还款日
    ,P1.LOANTERM -- 贷款期限
    ,P1.SETTLERATE -- 年利率
    ,P1.LOANUSE -- 贷款用途
    ,P1.DEBITACCOUNTNO -- 入账银行卡号
    ,P1.DEBITACCOUNTNAME -- 入账账户名称
    ,P1.DEBITOPENACCOUNTBANK -- 入账银行卡开户行
    ,P1.DEBITCNAPS -- 入账银行卡联行号
    ,nvl(trim(P1.IDENTITYPE),'-') -- 证件类型代码
    ,P1.IDENTINO -- 证件号码
    ,P1.IDCARDEXPIREDATE -- 身份证生效日期
    ,P1.IDCARDVALIDDATE -- 身份证到期日期
    ,P1.IDADDR -- 身份证地址信息
    ,P1.ISSUEDAGENCY -- 签发机关
    ,P1.BIRTHDAY -- 出生日期
    ,nvl(trim(P1.MARITALSTATUS),'-') -- 婚姻状态代码
    ,to_number(nvl(trim(P1.AGE),0)) -- 年龄
    ,nvl(trim(P1.SEX),'0') -- 性别代码
    ,nvl(trim(P1.NATIONALITY),'XXX') -- 国籍代码
    ,nvl(trim(P1.NATION),'-') -- 民族
    ,P1.MOBILENO -- 手机号码
    ,P1.USERBANKCARDNO -- 用户银行卡号
    ,nvl(trim(P1.USERRATING),'-') -- 用户评级代码
    ,P1.FSTLNKMNAME -- 第一联系人名称
    ,P1.FSTLNKMTEL -- 第一联系人手机号码
    ,nvl(trim(P1.FRSLNKMRELA),'-') -- 第一联系人关系代码
    ,P1.LIVINGADDRESS -- 居住地址
    ,nvl(trim(P1.USEROCCUPATION),'-') -- 职业代码
    ,nvl(trim(P1.USERINDUSTRYCATEGORY),'-') -- 行业类型代码
    ,nvl(trim(P1.EDUCATIONLEVEL),'-') -- 学历代码
    ,P1.MONTHLYINCOME -- 月收入
    ,P1.PROVIDENTFUNDBASEAMT -- 公积金缴纳基数
    ,P1.SECURITYBASEAMT -- 社保缴纳基数
    ,P1.PROVIDENTFUNDCOMPANY -- 公积金缴纳单位名称
    ,P1.COMPANYADDR -- 单位地址
    ,nvl(trim(P1.MANUALAPPROVAL),'-') -- 人工审批标志
    ,nvl(trim(P1.FINALDECISIONCODE),'-') -- 最终决策结果代码
    ,P1.FINALAPPLYAMOUNT -- 终审审批额度
    ,P1.FINALAPPLYTERM -- 终审审批期限
    ,P1.FINALAPPLYVALUATION -- 终审评估价格
    ,P1.RISKNOTE -- 风控备注
    ,P1.RISKWARM -- 风控预警
    ,P1.FINISHTIME -- 审批完成日期
    ,P1.RECTERM -- 建议期限
    ,P1.EXTEND -- 备注
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_lx_business_apply' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_lx_business_apply p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_lx_crdt_appl_icmsf1_tm 
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
        into ${iml_schema}.agt_lx_crdt_appl_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,src_appl_flow_num -- 源申请流水号
    ,prod_id -- 产品编号
    ,org_id -- 机构编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,appl_type_cd -- 申请类型代码
    ,appl_lmt -- 申请额度
    ,appl_status_cd -- 申请状态代码
    ,crdt_status_cd -- 授信状态代码
    ,guar_way_cd -- 主担保方式代码
    ,guar_id -- 担保编号
    ,mode_pay_cd -- 支付方式代码
    ,asset_crdt_id -- 资方授信编号
    ,asset_type_cd -- 资产类型代码
    ,repay_way_cd -- 还款方式代码
    ,fix_out_acct_day -- 固定出账日
    ,fix_repay_day -- 固定还款日
    ,loan_tenor -- 贷款期限
    ,year_int_rat -- 年利率
    ,loan_usage -- 贷款用途
    ,enter_acct_bank_card_num -- 入账银行卡号
    ,enter_name -- 入账账户名称
    ,enter_acct_card_open_bank_no -- 入账银行卡开户行
    ,enter_acct_card_ibank_no -- 入账银行卡联行号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,id_card_effect_dt -- 身份证生效日期
    ,id_card_exp_dt -- 身份证到期日期
    ,id_card_addr_info -- 身份证地址信息
    ,issue_org -- 签发机关
    ,birth_dt -- 出生日期
    ,marriage_status_cd -- 婚姻状态代码
    ,age -- 年龄
    ,gender_cd -- 性别代码
    ,nation_cd -- 国籍代码
    ,nationty -- 民族
    ,mobile_no -- 手机号码
    ,user_bank_card_num -- 用户银行卡号
    ,user_rating_cd -- 用户评级代码
    ,fst_cotas_name -- 第一联系人名称
    ,fst_cotas_mobile_no -- 第一联系人手机号码
    ,fst_cotas_rela_cd -- 第一联系人关系代码
    ,resdnt_addr -- 居住地址
    ,career_cd -- 职业代码
    ,indus_type_cd -- 行业类型代码
    ,edu_cd -- 学历代码
    ,mon_inco -- 月收入
    ,provi_fund_payment_base -- 公积金缴纳基数
    ,soci_secu_payment_base -- 社保缴纳基数
    ,provi_fund_payment_corp -- 公积金缴纳单位名称
    ,corp_addr -- 单位地址
    ,manu_apv_flg -- 人工审批标志
    ,final_decis_rest_cd -- 最终决策结果代码
    ,final_jud_apv_lmt -- 终审审批额度
    ,final_jud_apv_tenor -- 终审审批期限
    ,final_jud_estim_price -- 终审评估价格
    ,risk_mgmt_remark -- 风控备注
    ,risk_mgmt_warn -- 风控预警
    ,apv_cmplt_dt -- 审批完成日期
    ,sugst_tenor -- 建议期限
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_lx_crdt_appl_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,src_appl_flow_num -- 源申请流水号
    ,prod_id -- 产品编号
    ,org_id -- 机构编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,appl_type_cd -- 申请类型代码
    ,appl_lmt -- 申请额度
    ,appl_status_cd -- 申请状态代码
    ,crdt_status_cd -- 授信状态代码
    ,guar_way_cd -- 主担保方式代码
    ,guar_id -- 担保编号
    ,mode_pay_cd -- 支付方式代码
    ,asset_crdt_id -- 资方授信编号
    ,asset_type_cd -- 资产类型代码
    ,repay_way_cd -- 还款方式代码
    ,fix_out_acct_day -- 固定出账日
    ,fix_repay_day -- 固定还款日
    ,loan_tenor -- 贷款期限
    ,year_int_rat -- 年利率
    ,loan_usage -- 贷款用途
    ,enter_acct_bank_card_num -- 入账银行卡号
    ,enter_name -- 入账账户名称
    ,enter_acct_card_open_bank_no -- 入账银行卡开户行
    ,enter_acct_card_ibank_no -- 入账银行卡联行号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,id_card_effect_dt -- 身份证生效日期
    ,id_card_exp_dt -- 身份证到期日期
    ,id_card_addr_info -- 身份证地址信息
    ,issue_org -- 签发机关
    ,birth_dt -- 出生日期
    ,marriage_status_cd -- 婚姻状态代码
    ,age -- 年龄
    ,gender_cd -- 性别代码
    ,nation_cd -- 国籍代码
    ,nationty -- 民族
    ,mobile_no -- 手机号码
    ,user_bank_card_num -- 用户银行卡号
    ,user_rating_cd -- 用户评级代码
    ,fst_cotas_name -- 第一联系人名称
    ,fst_cotas_mobile_no -- 第一联系人手机号码
    ,fst_cotas_rela_cd -- 第一联系人关系代码
    ,resdnt_addr -- 居住地址
    ,career_cd -- 职业代码
    ,indus_type_cd -- 行业类型代码
    ,edu_cd -- 学历代码
    ,mon_inco -- 月收入
    ,provi_fund_payment_base -- 公积金缴纳基数
    ,soci_secu_payment_base -- 社保缴纳基数
    ,provi_fund_payment_corp -- 公积金缴纳单位名称
    ,corp_addr -- 单位地址
    ,manu_apv_flg -- 人工审批标志
    ,final_decis_rest_cd -- 最终决策结果代码
    ,final_jud_apv_lmt -- 终审审批额度
    ,final_jud_apv_tenor -- 终审审批期限
    ,final_jud_estim_price -- 终审评估价格
    ,risk_mgmt_remark -- 风控备注
    ,risk_mgmt_warn -- 风控预警
    ,apv_cmplt_dt -- 审批完成日期
    ,sugst_tenor -- 建议期限
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
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
    ,nvl(n.src_appl_flow_num, o.src_appl_flow_num) as src_appl_flow_num -- 源申请流水号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.appl_type_cd, o.appl_type_cd) as appl_type_cd -- 申请类型代码
    ,nvl(n.appl_lmt, o.appl_lmt) as appl_lmt -- 申请额度
    ,nvl(n.appl_status_cd, o.appl_status_cd) as appl_status_cd -- 申请状态代码
    ,nvl(n.crdt_status_cd, o.crdt_status_cd) as crdt_status_cd -- 授信状态代码
    ,nvl(n.guar_way_cd, o.guar_way_cd) as guar_way_cd -- 主担保方式代码
    ,nvl(n.guar_id, o.guar_id) as guar_id -- 担保编号
    ,nvl(n.mode_pay_cd, o.mode_pay_cd) as mode_pay_cd -- 支付方式代码
    ,nvl(n.asset_crdt_id, o.asset_crdt_id) as asset_crdt_id -- 资方授信编号
    ,nvl(n.asset_type_cd, o.asset_type_cd) as asset_type_cd -- 资产类型代码
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.fix_out_acct_day, o.fix_out_acct_day) as fix_out_acct_day -- 固定出账日
    ,nvl(n.fix_repay_day, o.fix_repay_day) as fix_repay_day -- 固定还款日
    ,nvl(n.loan_tenor, o.loan_tenor) as loan_tenor -- 贷款期限
    ,nvl(n.year_int_rat, o.year_int_rat) as year_int_rat -- 年利率
    ,nvl(n.loan_usage, o.loan_usage) as loan_usage -- 贷款用途
    ,nvl(n.enter_acct_bank_card_num, o.enter_acct_bank_card_num) as enter_acct_bank_card_num -- 入账银行卡号
    ,nvl(n.enter_name, o.enter_name) as enter_name -- 入账账户名称
    ,nvl(n.enter_acct_card_open_bank_no, o.enter_acct_card_open_bank_no) as enter_acct_card_open_bank_no -- 入账银行卡开户行
    ,nvl(n.enter_acct_card_ibank_no, o.enter_acct_card_ibank_no) as enter_acct_card_ibank_no -- 入账银行卡联行号
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.id_card_effect_dt, o.id_card_effect_dt) as id_card_effect_dt -- 身份证生效日期
    ,nvl(n.id_card_exp_dt, o.id_card_exp_dt) as id_card_exp_dt -- 身份证到期日期
    ,nvl(n.id_card_addr_info, o.id_card_addr_info) as id_card_addr_info -- 身份证地址信息
    ,nvl(n.issue_org, o.issue_org) as issue_org -- 签发机关
    ,nvl(n.birth_dt, o.birth_dt) as birth_dt -- 出生日期
    ,nvl(n.marriage_status_cd, o.marriage_status_cd) as marriage_status_cd -- 婚姻状态代码
    ,nvl(n.age, o.age) as age -- 年龄
    ,nvl(n.gender_cd, o.gender_cd) as gender_cd -- 性别代码
    ,nvl(n.nation_cd, o.nation_cd) as nation_cd -- 国籍代码
    ,nvl(n.nationty, o.nationty) as nationty -- 民族
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 手机号码
    ,nvl(n.user_bank_card_num, o.user_bank_card_num) as user_bank_card_num -- 用户银行卡号
    ,nvl(n.user_rating_cd, o.user_rating_cd) as user_rating_cd -- 用户评级代码
    ,nvl(n.fst_cotas_name, o.fst_cotas_name) as fst_cotas_name -- 第一联系人名称
    ,nvl(n.fst_cotas_mobile_no, o.fst_cotas_mobile_no) as fst_cotas_mobile_no -- 第一联系人手机号码
    ,nvl(n.fst_cotas_rela_cd, o.fst_cotas_rela_cd) as fst_cotas_rela_cd -- 第一联系人关系代码
    ,nvl(n.resdnt_addr, o.resdnt_addr) as resdnt_addr -- 居住地址
    ,nvl(n.career_cd, o.career_cd) as career_cd -- 职业代码
    ,nvl(n.indus_type_cd, o.indus_type_cd) as indus_type_cd -- 行业类型代码
    ,nvl(n.edu_cd, o.edu_cd) as edu_cd -- 学历代码
    ,nvl(n.mon_inco, o.mon_inco) as mon_inco -- 月收入
    ,nvl(n.provi_fund_payment_base, o.provi_fund_payment_base) as provi_fund_payment_base -- 公积金缴纳基数
    ,nvl(n.soci_secu_payment_base, o.soci_secu_payment_base) as soci_secu_payment_base -- 社保缴纳基数
    ,nvl(n.provi_fund_payment_corp, o.provi_fund_payment_corp) as provi_fund_payment_corp -- 公积金缴纳单位名称
    ,nvl(n.corp_addr, o.corp_addr) as corp_addr -- 单位地址
    ,nvl(n.manu_apv_flg, o.manu_apv_flg) as manu_apv_flg -- 人工审批标志
    ,nvl(n.final_decis_rest_cd, o.final_decis_rest_cd) as final_decis_rest_cd -- 最终决策结果代码
    ,nvl(n.final_jud_apv_lmt, o.final_jud_apv_lmt) as final_jud_apv_lmt -- 终审审批额度
    ,nvl(n.final_jud_apv_tenor, o.final_jud_apv_tenor) as final_jud_apv_tenor -- 终审审批期限
    ,nvl(n.final_jud_estim_price, o.final_jud_estim_price) as final_jud_estim_price -- 终审评估价格
    ,nvl(n.risk_mgmt_remark, o.risk_mgmt_remark) as risk_mgmt_remark -- 风控备注
    ,nvl(n.risk_mgmt_warn, o.risk_mgmt_warn) as risk_mgmt_warn -- 风控预警
    ,nvl(n.apv_cmplt_dt, o.apv_cmplt_dt) as apv_cmplt_dt -- 审批完成日期
    ,nvl(n.sugst_tenor, o.sugst_tenor) as sugst_tenor -- 建议期限
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
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
from ${iml_schema}.agt_lx_crdt_appl_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_lx_crdt_appl_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.src_appl_flow_num <> n.src_appl_flow_num
        or o.prod_id <> n.prod_id
        or o.org_id <> n.org_id
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.appl_type_cd <> n.appl_type_cd
        or o.appl_lmt <> n.appl_lmt
        or o.appl_status_cd <> n.appl_status_cd
        or o.crdt_status_cd <> n.crdt_status_cd
        or o.guar_way_cd <> n.guar_way_cd
        or o.guar_id <> n.guar_id
        or o.mode_pay_cd <> n.mode_pay_cd
        or o.asset_crdt_id <> n.asset_crdt_id
        or o.asset_type_cd <> n.asset_type_cd
        or o.repay_way_cd <> n.repay_way_cd
        or o.fix_out_acct_day <> n.fix_out_acct_day
        or o.fix_repay_day <> n.fix_repay_day
        or o.loan_tenor <> n.loan_tenor
        or o.year_int_rat <> n.year_int_rat
        or o.loan_usage <> n.loan_usage
        or o.enter_acct_bank_card_num <> n.enter_acct_bank_card_num
        or o.enter_name <> n.enter_name
        or o.enter_acct_card_open_bank_no <> n.enter_acct_card_open_bank_no
        or o.enter_acct_card_ibank_no <> n.enter_acct_card_ibank_no
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.id_card_effect_dt <> n.id_card_effect_dt
        or o.id_card_exp_dt <> n.id_card_exp_dt
        or o.id_card_addr_info <> n.id_card_addr_info
        or o.issue_org <> n.issue_org
        or o.birth_dt <> n.birth_dt
        or o.marriage_status_cd <> n.marriage_status_cd
        or o.age <> n.age
        or o.gender_cd <> n.gender_cd
        or o.nation_cd <> n.nation_cd
        or o.nationty <> n.nationty
        or o.mobile_no <> n.mobile_no
        or o.user_bank_card_num <> n.user_bank_card_num
        or o.user_rating_cd <> n.user_rating_cd
        or o.fst_cotas_name <> n.fst_cotas_name
        or o.fst_cotas_mobile_no <> n.fst_cotas_mobile_no
        or o.fst_cotas_rela_cd <> n.fst_cotas_rela_cd
        or o.resdnt_addr <> n.resdnt_addr
        or o.career_cd <> n.career_cd
        or o.indus_type_cd <> n.indus_type_cd
        or o.edu_cd <> n.edu_cd
        or o.mon_inco <> n.mon_inco
        or o.provi_fund_payment_base <> n.provi_fund_payment_base
        or o.soci_secu_payment_base <> n.soci_secu_payment_base
        or o.provi_fund_payment_corp <> n.provi_fund_payment_corp
        or o.corp_addr <> n.corp_addr
        or o.manu_apv_flg <> n.manu_apv_flg
        or o.final_decis_rest_cd <> n.final_decis_rest_cd
        or o.final_jud_apv_lmt <> n.final_jud_apv_lmt
        or o.final_jud_apv_tenor <> n.final_jud_apv_tenor
        or o.final_jud_estim_price <> n.final_jud_estim_price
        or o.risk_mgmt_remark <> n.risk_mgmt_remark
        or o.risk_mgmt_warn <> n.risk_mgmt_warn
        or o.apv_cmplt_dt <> n.apv_cmplt_dt
        or o.sugst_tenor <> n.sugst_tenor
        or o.remark <> n.remark
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.final_update_dt <> n.final_update_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_lx_crdt_appl_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,src_appl_flow_num -- 源申请流水号
    ,prod_id -- 产品编号
    ,org_id -- 机构编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,appl_type_cd -- 申请类型代码
    ,appl_lmt -- 申请额度
    ,appl_status_cd -- 申请状态代码
    ,crdt_status_cd -- 授信状态代码
    ,guar_way_cd -- 主担保方式代码
    ,guar_id -- 担保编号
    ,mode_pay_cd -- 支付方式代码
    ,asset_crdt_id -- 资方授信编号
    ,asset_type_cd -- 资产类型代码
    ,repay_way_cd -- 还款方式代码
    ,fix_out_acct_day -- 固定出账日
    ,fix_repay_day -- 固定还款日
    ,loan_tenor -- 贷款期限
    ,year_int_rat -- 年利率
    ,loan_usage -- 贷款用途
    ,enter_acct_bank_card_num -- 入账银行卡号
    ,enter_name -- 入账账户名称
    ,enter_acct_card_open_bank_no -- 入账银行卡开户行
    ,enter_acct_card_ibank_no -- 入账银行卡联行号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,id_card_effect_dt -- 身份证生效日期
    ,id_card_exp_dt -- 身份证到期日期
    ,id_card_addr_info -- 身份证地址信息
    ,issue_org -- 签发机关
    ,birth_dt -- 出生日期
    ,marriage_status_cd -- 婚姻状态代码
    ,age -- 年龄
    ,gender_cd -- 性别代码
    ,nation_cd -- 国籍代码
    ,nationty -- 民族
    ,mobile_no -- 手机号码
    ,user_bank_card_num -- 用户银行卡号
    ,user_rating_cd -- 用户评级代码
    ,fst_cotas_name -- 第一联系人名称
    ,fst_cotas_mobile_no -- 第一联系人手机号码
    ,fst_cotas_rela_cd -- 第一联系人关系代码
    ,resdnt_addr -- 居住地址
    ,career_cd -- 职业代码
    ,indus_type_cd -- 行业类型代码
    ,edu_cd -- 学历代码
    ,mon_inco -- 月收入
    ,provi_fund_payment_base -- 公积金缴纳基数
    ,soci_secu_payment_base -- 社保缴纳基数
    ,provi_fund_payment_corp -- 公积金缴纳单位名称
    ,corp_addr -- 单位地址
    ,manu_apv_flg -- 人工审批标志
    ,final_decis_rest_cd -- 最终决策结果代码
    ,final_jud_apv_lmt -- 终审审批额度
    ,final_jud_apv_tenor -- 终审审批期限
    ,final_jud_estim_price -- 终审评估价格
    ,risk_mgmt_remark -- 风控备注
    ,risk_mgmt_warn -- 风控预警
    ,apv_cmplt_dt -- 审批完成日期
    ,sugst_tenor -- 建议期限
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_lx_crdt_appl_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,src_appl_flow_num -- 源申请流水号
    ,prod_id -- 产品编号
    ,org_id -- 机构编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,appl_type_cd -- 申请类型代码
    ,appl_lmt -- 申请额度
    ,appl_status_cd -- 申请状态代码
    ,crdt_status_cd -- 授信状态代码
    ,guar_way_cd -- 主担保方式代码
    ,guar_id -- 担保编号
    ,mode_pay_cd -- 支付方式代码
    ,asset_crdt_id -- 资方授信编号
    ,asset_type_cd -- 资产类型代码
    ,repay_way_cd -- 还款方式代码
    ,fix_out_acct_day -- 固定出账日
    ,fix_repay_day -- 固定还款日
    ,loan_tenor -- 贷款期限
    ,year_int_rat -- 年利率
    ,loan_usage -- 贷款用途
    ,enter_acct_bank_card_num -- 入账银行卡号
    ,enter_name -- 入账账户名称
    ,enter_acct_card_open_bank_no -- 入账银行卡开户行
    ,enter_acct_card_ibank_no -- 入账银行卡联行号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,id_card_effect_dt -- 身份证生效日期
    ,id_card_exp_dt -- 身份证到期日期
    ,id_card_addr_info -- 身份证地址信息
    ,issue_org -- 签发机关
    ,birth_dt -- 出生日期
    ,marriage_status_cd -- 婚姻状态代码
    ,age -- 年龄
    ,gender_cd -- 性别代码
    ,nation_cd -- 国籍代码
    ,nationty -- 民族
    ,mobile_no -- 手机号码
    ,user_bank_card_num -- 用户银行卡号
    ,user_rating_cd -- 用户评级代码
    ,fst_cotas_name -- 第一联系人名称
    ,fst_cotas_mobile_no -- 第一联系人手机号码
    ,fst_cotas_rela_cd -- 第一联系人关系代码
    ,resdnt_addr -- 居住地址
    ,career_cd -- 职业代码
    ,indus_type_cd -- 行业类型代码
    ,edu_cd -- 学历代码
    ,mon_inco -- 月收入
    ,provi_fund_payment_base -- 公积金缴纳基数
    ,soci_secu_payment_base -- 社保缴纳基数
    ,provi_fund_payment_corp -- 公积金缴纳单位名称
    ,corp_addr -- 单位地址
    ,manu_apv_flg -- 人工审批标志
    ,final_decis_rest_cd -- 最终决策结果代码
    ,final_jud_apv_lmt -- 终审审批额度
    ,final_jud_apv_tenor -- 终审审批期限
    ,final_jud_estim_price -- 终审评估价格
    ,risk_mgmt_remark -- 风控备注
    ,risk_mgmt_warn -- 风控预警
    ,apv_cmplt_dt -- 审批完成日期
    ,sugst_tenor -- 建议期限
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
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
    ,o.src_appl_flow_num -- 源申请流水号
    ,o.prod_id -- 产品编号
    ,o.org_id -- 机构编号
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.appl_type_cd -- 申请类型代码
    ,o.appl_lmt -- 申请额度
    ,o.appl_status_cd -- 申请状态代码
    ,o.crdt_status_cd -- 授信状态代码
    ,o.guar_way_cd -- 主担保方式代码
    ,o.guar_id -- 担保编号
    ,o.mode_pay_cd -- 支付方式代码
    ,o.asset_crdt_id -- 资方授信编号
    ,o.asset_type_cd -- 资产类型代码
    ,o.repay_way_cd -- 还款方式代码
    ,o.fix_out_acct_day -- 固定出账日
    ,o.fix_repay_day -- 固定还款日
    ,o.loan_tenor -- 贷款期限
    ,o.year_int_rat -- 年利率
    ,o.loan_usage -- 贷款用途
    ,o.enter_acct_bank_card_num -- 入账银行卡号
    ,o.enter_name -- 入账账户名称
    ,o.enter_acct_card_open_bank_no -- 入账银行卡开户行
    ,o.enter_acct_card_ibank_no -- 入账银行卡联行号
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.id_card_effect_dt -- 身份证生效日期
    ,o.id_card_exp_dt -- 身份证到期日期
    ,o.id_card_addr_info -- 身份证地址信息
    ,o.issue_org -- 签发机关
    ,o.birth_dt -- 出生日期
    ,o.marriage_status_cd -- 婚姻状态代码
    ,o.age -- 年龄
    ,o.gender_cd -- 性别代码
    ,o.nation_cd -- 国籍代码
    ,o.nationty -- 民族
    ,o.mobile_no -- 手机号码
    ,o.user_bank_card_num -- 用户银行卡号
    ,o.user_rating_cd -- 用户评级代码
    ,o.fst_cotas_name -- 第一联系人名称
    ,o.fst_cotas_mobile_no -- 第一联系人手机号码
    ,o.fst_cotas_rela_cd -- 第一联系人关系代码
    ,o.resdnt_addr -- 居住地址
    ,o.career_cd -- 职业代码
    ,o.indus_type_cd -- 行业类型代码
    ,o.edu_cd -- 学历代码
    ,o.mon_inco -- 月收入
    ,o.provi_fund_payment_base -- 公积金缴纳基数
    ,o.soci_secu_payment_base -- 社保缴纳基数
    ,o.provi_fund_payment_corp -- 公积金缴纳单位名称
    ,o.corp_addr -- 单位地址
    ,o.manu_apv_flg -- 人工审批标志
    ,o.final_decis_rest_cd -- 最终决策结果代码
    ,o.final_jud_apv_lmt -- 终审审批额度
    ,o.final_jud_apv_tenor -- 终审审批期限
    ,o.final_jud_estim_price -- 终审评估价格
    ,o.risk_mgmt_remark -- 风控备注
    ,o.risk_mgmt_warn -- 风控预警
    ,o.apv_cmplt_dt -- 审批完成日期
    ,o.sugst_tenor -- 建议期限
    ,o.remark -- 备注
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.final_update_dt -- 最后更新日期
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
from ${iml_schema}.agt_lx_crdt_appl_icmsf1_bk o
    left join ${iml_schema}.agt_lx_crdt_appl_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.appl_flow_num = n.appl_flow_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_lx_crdt_appl_icmsf1_cl d
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
--truncate table ${iml_schema}.agt_lx_crdt_appl;
--alter table ${iml_schema}.agt_lx_crdt_appl truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_lx_crdt_appl') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_lx_crdt_appl drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_lx_crdt_appl modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_lx_crdt_appl exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_lx_crdt_appl_icmsf1_cl;
alter table ${iml_schema}.agt_lx_crdt_appl exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_lx_crdt_appl_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_lx_crdt_appl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_lx_crdt_appl_icmsf1_tm purge;
drop table ${iml_schema}.agt_lx_crdt_appl_icmsf1_op purge;
drop table ${iml_schema}.agt_lx_crdt_appl_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_lx_crdt_appl_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_lx_crdt_appl', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
