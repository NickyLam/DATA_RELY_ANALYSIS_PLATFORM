/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_zjdk_crdt_appl_info_h_icmsf1
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
alter table ${iml_schema}.agt_zjdk_crdt_appl_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_zjdk_crdt_appl_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_zjdk_crdt_appl_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_zjdk_crdt_appl_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_zjdk_crdt_appl_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_zjdk_crdt_appl_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_zjdk_crdt_appl_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,crdt_appl_flow_num -- 授信申请流水号
    ,myloan_req_flow_num -- 网商贷请求流水号
    ,stud_loan_req_flow_num -- 助贷请求流水号
    ,crdt_appl_type_cd -- 授信申请类型代码
    ,crdt_id -- 授信编号
    ,prod_id -- 产品编号
    ,prod_cate_cd -- 产品类别代码
    ,curr_cd -- 币种代码
    ,crdt_status_cd -- 授信状态代码
    ,crdt_appl_sucs_flg -- 授信申请成功标志
    ,crdt_chn_cd -- 授信渠道代码
    ,crdt_lmt -- 授信额度
    ,crdt_day_int_rat -- 授信日利率
    ,crdt_year_int_rat -- 授信年利率
    ,crdt_exp_dt -- 授信到期日期
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_char_cd -- 客户性质代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,gender_cd -- 性别代码
    ,nation_cd -- 国籍代码
    ,nome_phone_num -- 家庭电话号码
    ,resdnt_addr -- 居住地址
    ,birth_dt -- 出生日期
    ,id_card_addr_info -- 身份证地址信息
    ,id_card_effect_dt -- 身份证生效日期
    ,id_card_exp_dt -- 身份证到期日期
    ,nationty -- 民族
    ,issue_org -- 签发机关
    ,career_cd -- 职业代码
    ,bank_card_num -- 银行卡号
    ,bank_name -- 银行名称
    ,bank_rsrv_mobile_no -- 银行预留手机号
    ,corp_name -- 企业名称
    ,soci_crdt_cd -- 社会信用代码
    ,bus_lics_num -- 营业执照号
    ,bl_induty_type_type_cd -- 所属行业类型类型代码
    ,dss_flg -- 董监高标志
    ,sm_lab -- 小微标签
    ,borw_usage_cd -- 借款用途代码
    ,risk_mgmt_rest_cd -- 风控结果代码
    ,risk_mgmt_crdt_lmt -- 风控授信额度
    ,risk_mgmt_int_year_int_rat -- 风控利息年利率
    ,risk_mgmt_refuse_code -- 风控拒绝码
    ,risk_mgmt_refuse_rs -- 风控拒绝原因
    ,risk_mgmt_re_dt -- 风控回调日期
    ,lmt_cont_flg -- 额度合同标志
    ,lmt_cont_id -- 额度合同编号
    ,intnal_dubil_id -- 借据编号
    ,actl_lmt -- 实际额度
    ,aval_lmt -- 可用额度
    ,borw_tot_amt -- 借款总金额
    ,unite_bk_amt -- 联合行金额
    ,loan_perds -- 贷款期数
    ,int_accr_way_cd -- 计息方式代码
    ,actl_day_int_rat -- 实际日利率
    ,actl_year_int_rat -- 实际年利率
    ,cap_code -- 资金码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_zjdk_crdt_appl_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_zjdk_crdt_appl_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_zjdk_crdt_appl_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_zjdk_crdt_appl_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_zjdk_crdt_appl_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_zjbk_business_apply-1
insert into ${iml_schema}.agt_zjdk_crdt_appl_info_h_icmsf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,crdt_appl_flow_num -- 授信申请流水号
    ,myloan_req_flow_num -- 网商贷请求流水号
    ,stud_loan_req_flow_num -- 助贷请求流水号
    ,crdt_appl_type_cd -- 授信申请类型代码
    ,crdt_id -- 授信编号
    ,prod_id -- 产品编号
    ,prod_cate_cd -- 产品类别代码
    ,curr_cd -- 币种代码
    ,crdt_status_cd -- 授信状态代码
    ,crdt_appl_sucs_flg -- 授信申请成功标志
    ,crdt_chn_cd -- 授信渠道代码
    ,crdt_lmt -- 授信额度
    ,crdt_day_int_rat -- 授信日利率
    ,crdt_year_int_rat -- 授信年利率
    ,crdt_exp_dt -- 授信到期日期
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_char_cd -- 客户性质代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,gender_cd -- 性别代码
    ,nation_cd -- 国籍代码
    ,nome_phone_num -- 家庭电话号码
    ,resdnt_addr -- 居住地址
    ,birth_dt -- 出生日期
    ,id_card_addr_info -- 身份证地址信息
    ,id_card_effect_dt -- 身份证生效日期
    ,id_card_exp_dt -- 身份证到期日期
    ,nationty -- 民族
    ,issue_org -- 签发机关
    ,career_cd -- 职业代码
    ,bank_card_num -- 银行卡号
    ,bank_name -- 银行名称
    ,bank_rsrv_mobile_no -- 银行预留手机号
    ,corp_name -- 企业名称
    ,soci_crdt_cd -- 社会信用代码
    ,bus_lics_num -- 营业执照号
    ,bl_induty_type_type_cd -- 所属行业类型类型代码
    ,dss_flg -- 董监高标志
    ,sm_lab -- 小微标签
    ,borw_usage_cd -- 借款用途代码
    ,risk_mgmt_rest_cd -- 风控结果代码
    ,risk_mgmt_crdt_lmt -- 风控授信额度
    ,risk_mgmt_int_year_int_rat -- 风控利息年利率
    ,risk_mgmt_refuse_code -- 风控拒绝码
    ,risk_mgmt_refuse_rs -- 风控拒绝原因
    ,risk_mgmt_re_dt -- 风控回调日期
    ,lmt_cont_flg -- 额度合同标志
    ,lmt_cont_id -- 额度合同编号
    ,intnal_dubil_id -- 借据编号
    ,actl_lmt -- 实际额度
    ,aval_lmt -- 可用额度
    ,borw_tot_amt -- 借款总金额
    ,unite_bk_amt -- 联合行金额
    ,loan_perds -- 贷款期数
    ,int_accr_way_cd -- 计息方式代码
    ,actl_day_int_rat -- 实际日利率
    ,actl_year_int_rat -- 实际年利率
    ,cap_code -- 资金码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206009'||P1.ACCOUNTID -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 授信申请流水号
    ,P1.LHDREQID -- 网商贷请求流水号
    ,P1.ZDREQID -- 助贷请求流水号
    ,nvl(trim(P1.CREDITTAG),'-') -- 授信申请类型代码
    ,P1.ACCOUNTID -- 授信编号
    ,P1.PRODUCTID -- 产品编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'|| replace(replace(P1.PRODUCTMODE,chr(13),''),chr(10),'') END -- 产品类别代码
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,nvl(trim(P1.APPROVESTATUS),'-') -- 授信状态代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'|| P1.STATUS END -- 授信申请成功标志
    ,P1.CREDITCHANNEL -- 授信渠道代码
    ,P1.CREDITAMOUNT -- 授信额度
    ,P1.DAILYRATE -- 授信日利率
    ,P1.ANNUALRATE -- 授信年利率
    ,P1.EFFECTDATE -- 授信到期日期
    ,P1.CUSTOMERID -- 客户编号
    ,P1.NAME -- 客户名称
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CUSTOMERTYPE END -- 客户性质代码
    ,nvl(trim(P1.CERTTYPE),'0000') -- 证件类型代码
    ,P1.IDNUMBER -- 证件号码
    ,P1.PHONE -- 手机号码
    ,nvl(trim(P1.GENDER),'-') -- 性别代码
    ,nvl(trim(P1.NATION),'XXX') -- 国籍代码
    ,P1.HOMEPHONE -- 家庭电话号码
    ,P1.ADDRESS -- 居住地址
    ,P1.BIRTHDAY -- 出生日期
    ,P1.IDCARDADDRESS -- 身份证地址信息
    ,${iml_schema}.dateformat_min(P1.IDCARDSTARTDATE) -- 身份证生效日期
    ,${iml_schema}.dateformat_max2(P1.IDCARDENDDATE) -- 身份证到期日期
    ,P1.IDCARDETHNICITY -- 民族
    ,P1.IDCARDAUTHORITY -- 签发机关
    ,nvl(trim(P1.CAREERINDUSTRY),'-') -- 职业代码
    ,P1.CARDID -- 银行卡号
    ,P1.BANKNAME -- 银行名称
    ,P1.BANKPHONE -- 银行预留手机号
    ,P1.ENTERPRISENAME -- 企业名称
    ,P1.UNIFORMSOCIALCREDITCODE -- 社会信用代码
    ,P1.BUSINESSLICENSE -- 营业执照号
    ,nvl(trim(P1.COMPANYINDUSTRY),'-') -- 所属行业类型类型代码
    ,nvl(trim(P1.IFEXESHARE),'-') -- 董监高标志
    ,P1.XWLABEL -- 小微标签
    ,nvl(trim(P1.USAGE),'000000') -- 借款用途代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.RISKSTATUS END -- 风控结果代码
    ,P1.RISKCREDITAMOUNT -- 风控授信额度
    ,P1.RISKINTRATE -- 风控利息年利率
    ,P1.FAILCODE -- 风控拒绝码
    ,P1.FAILREASON -- 风控拒绝原因
    ,P1.RISKREQTIME -- 风控回调日期
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.BUSINESSFLAG END -- 额度合同标志
    ,P1.CONTRACTNO -- 额度合同编号
    ,P1.LOANID -- 借据编号
    ,P1.APPLIEDAMOUNT -- 实际额度
    ,P1.AVAILABLEAMOUNT -- 可用额度
    ,P1.LOANAMOUNT -- 借款总金额
    ,P1.BANKAMOUNT -- 联合行金额
    ,to_number(nvl(trim(P1.PERIOD),'0')) -- 贷款期数
    ,nvl(trim(P1.REPAYTYPE),'-') -- 计息方式代码
    ,P1.ORDERDAILYRATE -- 实际日利率
    ,P1.ORDERANNUALRATE -- 实际年利率
    ,P1.CAPITALSETNO -- 资金码
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 最后更新柜员编号
    ,P1.UPDATEORGID -- 最后更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_zjbk_business_apply' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_zjbk_business_apply p1
    left join ${iml_schema}.ref_pub_cd_map r1 on replace(replace(P1.PRODUCTMODE,chr(13),''),chr(10),'') = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_ZJBK_BUSINESS_APPLY'
        AND R1.SRC_FIELD_EN_NAME= 'PRODUCTMODE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_ZJDK_CRDT_APPL_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PROD_CATE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.STATUS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_ZJBK_BUSINESS_APPLY'
        AND R2.SRC_FIELD_EN_NAME= 'STATUS'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_ZJDK_CRDT_APPL_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CRDT_APPL_SUCS_FLG'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CUSTOMERTYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'ICMS'
        AND R3.SRC_TAB_EN_NAME= 'ICMS_ZJBK_BUSINESS_APPLY'
        AND R3.SRC_FIELD_EN_NAME= 'CUSTOMERTYPE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_ZJDK_CRDT_APPL_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CUST_CHAR_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.RISKSTATUS = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'ICMS'
        AND R4.SRC_TAB_EN_NAME= 'ICMS_ZJBK_BUSINESS_APPLY'
        AND R4.SRC_FIELD_EN_NAME= 'RISKSTATUS'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_ZJDK_CRDT_APPL_INFO_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'RISK_MGMT_REST_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.BUSINESSFLAG = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'ICMS'
        AND R5.SRC_TAB_EN_NAME= 'ICMS_ZJBK_BUSINESS_APPLY'
        AND R5.SRC_FIELD_EN_NAME= 'BUSINESSFLAG'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_ZJDK_CRDT_APPL_INFO_H'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'LMT_CONT_FLG'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_zjdk_crdt_appl_info_h_icmsf1_tm 
  	                                group by 
  	                                        appl_id
  	                                        ,lp_id
  	                                        ,crdt_appl_flow_num
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
        into ${iml_schema}.agt_zjdk_crdt_appl_info_h_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,crdt_appl_flow_num -- 授信申请流水号
    ,myloan_req_flow_num -- 网商贷请求流水号
    ,stud_loan_req_flow_num -- 助贷请求流水号
    ,crdt_appl_type_cd -- 授信申请类型代码
    ,crdt_id -- 授信编号
    ,prod_id -- 产品编号
    ,prod_cate_cd -- 产品类别代码
    ,curr_cd -- 币种代码
    ,crdt_status_cd -- 授信状态代码
    ,crdt_appl_sucs_flg -- 授信申请成功标志
    ,crdt_chn_cd -- 授信渠道代码
    ,crdt_lmt -- 授信额度
    ,crdt_day_int_rat -- 授信日利率
    ,crdt_year_int_rat -- 授信年利率
    ,crdt_exp_dt -- 授信到期日期
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_char_cd -- 客户性质代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,gender_cd -- 性别代码
    ,nation_cd -- 国籍代码
    ,nome_phone_num -- 家庭电话号码
    ,resdnt_addr -- 居住地址
    ,birth_dt -- 出生日期
    ,id_card_addr_info -- 身份证地址信息
    ,id_card_effect_dt -- 身份证生效日期
    ,id_card_exp_dt -- 身份证到期日期
    ,nationty -- 民族
    ,issue_org -- 签发机关
    ,career_cd -- 职业代码
    ,bank_card_num -- 银行卡号
    ,bank_name -- 银行名称
    ,bank_rsrv_mobile_no -- 银行预留手机号
    ,corp_name -- 企业名称
    ,soci_crdt_cd -- 社会信用代码
    ,bus_lics_num -- 营业执照号
    ,bl_induty_type_type_cd -- 所属行业类型类型代码
    ,dss_flg -- 董监高标志
    ,sm_lab -- 小微标签
    ,borw_usage_cd -- 借款用途代码
    ,risk_mgmt_rest_cd -- 风控结果代码
    ,risk_mgmt_crdt_lmt -- 风控授信额度
    ,risk_mgmt_int_year_int_rat -- 风控利息年利率
    ,risk_mgmt_refuse_code -- 风控拒绝码
    ,risk_mgmt_refuse_rs -- 风控拒绝原因
    ,risk_mgmt_re_dt -- 风控回调日期
    ,lmt_cont_flg -- 额度合同标志
    ,lmt_cont_id -- 额度合同编号
    ,intnal_dubil_id -- 借据编号
    ,actl_lmt -- 实际额度
    ,aval_lmt -- 可用额度
    ,borw_tot_amt -- 借款总金额
    ,unite_bk_amt -- 联合行金额
    ,loan_perds -- 贷款期数
    ,int_accr_way_cd -- 计息方式代码
    ,actl_day_int_rat -- 实际日利率
    ,actl_year_int_rat -- 实际年利率
    ,cap_code -- 资金码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_zjdk_crdt_appl_info_h_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,crdt_appl_flow_num -- 授信申请流水号
    ,myloan_req_flow_num -- 网商贷请求流水号
    ,stud_loan_req_flow_num -- 助贷请求流水号
    ,crdt_appl_type_cd -- 授信申请类型代码
    ,crdt_id -- 授信编号
    ,prod_id -- 产品编号
    ,prod_cate_cd -- 产品类别代码
    ,curr_cd -- 币种代码
    ,crdt_status_cd -- 授信状态代码
    ,crdt_appl_sucs_flg -- 授信申请成功标志
    ,crdt_chn_cd -- 授信渠道代码
    ,crdt_lmt -- 授信额度
    ,crdt_day_int_rat -- 授信日利率
    ,crdt_year_int_rat -- 授信年利率
    ,crdt_exp_dt -- 授信到期日期
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_char_cd -- 客户性质代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,gender_cd -- 性别代码
    ,nation_cd -- 国籍代码
    ,nome_phone_num -- 家庭电话号码
    ,resdnt_addr -- 居住地址
    ,birth_dt -- 出生日期
    ,id_card_addr_info -- 身份证地址信息
    ,id_card_effect_dt -- 身份证生效日期
    ,id_card_exp_dt -- 身份证到期日期
    ,nationty -- 民族
    ,issue_org -- 签发机关
    ,career_cd -- 职业代码
    ,bank_card_num -- 银行卡号
    ,bank_name -- 银行名称
    ,bank_rsrv_mobile_no -- 银行预留手机号
    ,corp_name -- 企业名称
    ,soci_crdt_cd -- 社会信用代码
    ,bus_lics_num -- 营业执照号
    ,bl_induty_type_type_cd -- 所属行业类型类型代码
    ,dss_flg -- 董监高标志
    ,sm_lab -- 小微标签
    ,borw_usage_cd -- 借款用途代码
    ,risk_mgmt_rest_cd -- 风控结果代码
    ,risk_mgmt_crdt_lmt -- 风控授信额度
    ,risk_mgmt_int_year_int_rat -- 风控利息年利率
    ,risk_mgmt_refuse_code -- 风控拒绝码
    ,risk_mgmt_refuse_rs -- 风控拒绝原因
    ,risk_mgmt_re_dt -- 风控回调日期
    ,lmt_cont_flg -- 额度合同标志
    ,lmt_cont_id -- 额度合同编号
    ,intnal_dubil_id -- 借据编号
    ,actl_lmt -- 实际额度
    ,aval_lmt -- 可用额度
    ,borw_tot_amt -- 借款总金额
    ,unite_bk_amt -- 联合行金额
    ,loan_perds -- 贷款期数
    ,int_accr_way_cd -- 计息方式代码
    ,actl_day_int_rat -- 实际日利率
    ,actl_year_int_rat -- 实际年利率
    ,cap_code -- 资金码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
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
    ,nvl(n.crdt_appl_flow_num, o.crdt_appl_flow_num) as crdt_appl_flow_num -- 授信申请流水号
    ,nvl(n.myloan_req_flow_num, o.myloan_req_flow_num) as myloan_req_flow_num -- 网商贷请求流水号
    ,nvl(n.stud_loan_req_flow_num, o.stud_loan_req_flow_num) as stud_loan_req_flow_num -- 助贷请求流水号
    ,nvl(n.crdt_appl_type_cd, o.crdt_appl_type_cd) as crdt_appl_type_cd -- 授信申请类型代码
    ,nvl(n.crdt_id, o.crdt_id) as crdt_id -- 授信编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.prod_cate_cd, o.prod_cate_cd) as prod_cate_cd -- 产品类别代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.crdt_status_cd, o.crdt_status_cd) as crdt_status_cd -- 授信状态代码
    ,nvl(n.crdt_appl_sucs_flg, o.crdt_appl_sucs_flg) as crdt_appl_sucs_flg -- 授信申请成功标志
    ,nvl(n.crdt_chn_cd, o.crdt_chn_cd) as crdt_chn_cd -- 授信渠道代码
    ,nvl(n.crdt_lmt, o.crdt_lmt) as crdt_lmt -- 授信额度
    ,nvl(n.crdt_day_int_rat, o.crdt_day_int_rat) as crdt_day_int_rat -- 授信日利率
    ,nvl(n.crdt_year_int_rat, o.crdt_year_int_rat) as crdt_year_int_rat -- 授信年利率
    ,nvl(n.crdt_exp_dt, o.crdt_exp_dt) as crdt_exp_dt -- 授信到期日期
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cust_char_cd, o.cust_char_cd) as cust_char_cd -- 客户性质代码
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 手机号码
    ,nvl(n.gender_cd, o.gender_cd) as gender_cd -- 性别代码
    ,nvl(n.nation_cd, o.nation_cd) as nation_cd -- 国籍代码
    ,nvl(n.nome_phone_num, o.nome_phone_num) as nome_phone_num -- 家庭电话号码
    ,nvl(n.resdnt_addr, o.resdnt_addr) as resdnt_addr -- 居住地址
    ,nvl(n.birth_dt, o.birth_dt) as birth_dt -- 出生日期
    ,nvl(n.id_card_addr_info, o.id_card_addr_info) as id_card_addr_info -- 身份证地址信息
    ,nvl(n.id_card_effect_dt, o.id_card_effect_dt) as id_card_effect_dt -- 身份证生效日期
    ,nvl(n.id_card_exp_dt, o.id_card_exp_dt) as id_card_exp_dt -- 身份证到期日期
    ,nvl(n.nationty, o.nationty) as nationty -- 民族
    ,nvl(n.issue_org, o.issue_org) as issue_org -- 签发机关
    ,nvl(n.career_cd, o.career_cd) as career_cd -- 职业代码
    ,nvl(n.bank_card_num, o.bank_card_num) as bank_card_num -- 银行卡号
    ,nvl(n.bank_name, o.bank_name) as bank_name -- 银行名称
    ,nvl(n.bank_rsrv_mobile_no, o.bank_rsrv_mobile_no) as bank_rsrv_mobile_no -- 银行预留手机号
    ,nvl(n.corp_name, o.corp_name) as corp_name -- 企业名称
    ,nvl(n.soci_crdt_cd, o.soci_crdt_cd) as soci_crdt_cd -- 社会信用代码
    ,nvl(n.bus_lics_num, o.bus_lics_num) as bus_lics_num -- 营业执照号
    ,nvl(n.bl_induty_type_type_cd, o.bl_induty_type_type_cd) as bl_induty_type_type_cd -- 所属行业类型类型代码
    ,nvl(n.dss_flg, o.dss_flg) as dss_flg -- 董监高标志
    ,nvl(n.sm_lab, o.sm_lab) as sm_lab -- 小微标签
    ,nvl(n.borw_usage_cd, o.borw_usage_cd) as borw_usage_cd -- 借款用途代码
    ,nvl(n.risk_mgmt_rest_cd, o.risk_mgmt_rest_cd) as risk_mgmt_rest_cd -- 风控结果代码
    ,nvl(n.risk_mgmt_crdt_lmt, o.risk_mgmt_crdt_lmt) as risk_mgmt_crdt_lmt -- 风控授信额度
    ,nvl(n.risk_mgmt_int_year_int_rat, o.risk_mgmt_int_year_int_rat) as risk_mgmt_int_year_int_rat -- 风控利息年利率
    ,nvl(n.risk_mgmt_refuse_code, o.risk_mgmt_refuse_code) as risk_mgmt_refuse_code -- 风控拒绝码
    ,nvl(n.risk_mgmt_refuse_rs, o.risk_mgmt_refuse_rs) as risk_mgmt_refuse_rs -- 风控拒绝原因
    ,nvl(n.risk_mgmt_re_dt, o.risk_mgmt_re_dt) as risk_mgmt_re_dt -- 风控回调日期
    ,nvl(n.lmt_cont_flg, o.lmt_cont_flg) as lmt_cont_flg -- 额度合同标志
    ,nvl(n.lmt_cont_id, o.lmt_cont_id) as lmt_cont_id -- 额度合同编号
    ,nvl(n.intnal_dubil_id, o.intnal_dubil_id) as intnal_dubil_id -- 借据编号
    ,nvl(n.actl_lmt, o.actl_lmt) as actl_lmt -- 实际额度
    ,nvl(n.aval_lmt, o.aval_lmt) as aval_lmt -- 可用额度
    ,nvl(n.borw_tot_amt, o.borw_tot_amt) as borw_tot_amt -- 借款总金额
    ,nvl(n.unite_bk_amt, o.unite_bk_amt) as unite_bk_amt -- 联合行金额
    ,nvl(n.loan_perds, o.loan_perds) as loan_perds -- 贷款期数
    ,nvl(n.int_accr_way_cd, o.int_accr_way_cd) as int_accr_way_cd -- 计息方式代码
    ,nvl(n.actl_day_int_rat, o.actl_day_int_rat) as actl_day_int_rat -- 实际日利率
    ,nvl(n.actl_year_int_rat, o.actl_year_int_rat) as actl_year_int_rat -- 实际年利率
    ,nvl(n.cap_code, o.cap_code) as cap_code -- 资金码
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.final_update_teller_id, o.final_update_teller_id) as final_update_teller_id -- 最后更新柜员编号
    ,nvl(n.final_update_org_id, o.final_update_org_id) as final_update_org_id -- 最后更新机构编号
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.crdt_appl_flow_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.crdt_appl_flow_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.crdt_appl_flow_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_zjdk_crdt_appl_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_zjdk_crdt_appl_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.crdt_appl_flow_num = n.crdt_appl_flow_num
where (
        o.appl_id is null
        and o.lp_id is null
        and o.crdt_appl_flow_num is null
    )
    or (
        n.appl_id is null
        and n.lp_id is null
        and n.crdt_appl_flow_num is null
    )
    or (
        o.myloan_req_flow_num <> n.myloan_req_flow_num
        or o.stud_loan_req_flow_num <> n.stud_loan_req_flow_num
        or o.crdt_appl_type_cd <> n.crdt_appl_type_cd
        or o.crdt_id <> n.crdt_id
        or o.prod_id <> n.prod_id
        or o.prod_cate_cd <> n.prod_cate_cd
        or o.curr_cd <> n.curr_cd
        or o.crdt_status_cd <> n.crdt_status_cd
        or o.crdt_appl_sucs_flg <> n.crdt_appl_sucs_flg
        or o.crdt_chn_cd <> n.crdt_chn_cd
        or o.crdt_lmt <> n.crdt_lmt
        or o.crdt_day_int_rat <> n.crdt_day_int_rat
        or o.crdt_year_int_rat <> n.crdt_year_int_rat
        or o.crdt_exp_dt <> n.crdt_exp_dt
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.cust_char_cd <> n.cust_char_cd
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.mobile_no <> n.mobile_no
        or o.gender_cd <> n.gender_cd
        or o.nation_cd <> n.nation_cd
        or o.nome_phone_num <> n.nome_phone_num
        or o.resdnt_addr <> n.resdnt_addr
        or o.birth_dt <> n.birth_dt
        or o.id_card_addr_info <> n.id_card_addr_info
        or o.id_card_effect_dt <> n.id_card_effect_dt
        or o.id_card_exp_dt <> n.id_card_exp_dt
        or o.nationty <> n.nationty
        or o.issue_org <> n.issue_org
        or o.career_cd <> n.career_cd
        or o.bank_card_num <> n.bank_card_num
        or o.bank_name <> n.bank_name
        or o.bank_rsrv_mobile_no <> n.bank_rsrv_mobile_no
        or o.corp_name <> n.corp_name
        or o.soci_crdt_cd <> n.soci_crdt_cd
        or o.bus_lics_num <> n.bus_lics_num
        or o.bl_induty_type_type_cd <> n.bl_induty_type_type_cd
        or o.dss_flg <> n.dss_flg
        or o.sm_lab <> n.sm_lab
        or o.borw_usage_cd <> n.borw_usage_cd
        or o.risk_mgmt_rest_cd <> n.risk_mgmt_rest_cd
        or o.risk_mgmt_crdt_lmt <> n.risk_mgmt_crdt_lmt
        or o.risk_mgmt_int_year_int_rat <> n.risk_mgmt_int_year_int_rat
        or o.risk_mgmt_refuse_code <> n.risk_mgmt_refuse_code
        or o.risk_mgmt_refuse_rs <> n.risk_mgmt_refuse_rs
        or o.risk_mgmt_re_dt <> n.risk_mgmt_re_dt
        or o.lmt_cont_flg <> n.lmt_cont_flg
        or o.lmt_cont_id <> n.lmt_cont_id
        or o.intnal_dubil_id <> n.intnal_dubil_id
        or o.actl_lmt <> n.actl_lmt
        or o.aval_lmt <> n.aval_lmt
        or o.borw_tot_amt <> n.borw_tot_amt
        or o.unite_bk_amt <> n.unite_bk_amt
        or o.loan_perds <> n.loan_perds
        or o.int_accr_way_cd <> n.int_accr_way_cd
        or o.actl_day_int_rat <> n.actl_day_int_rat
        or o.actl_year_int_rat <> n.actl_year_int_rat
        or o.cap_code <> n.cap_code
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.final_update_teller_id <> n.final_update_teller_id
        or o.final_update_org_id <> n.final_update_org_id
        or o.final_update_dt <> n.final_update_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_zjdk_crdt_appl_info_h_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,crdt_appl_flow_num -- 授信申请流水号
    ,myloan_req_flow_num -- 网商贷请求流水号
    ,stud_loan_req_flow_num -- 助贷请求流水号
    ,crdt_appl_type_cd -- 授信申请类型代码
    ,crdt_id -- 授信编号
    ,prod_id -- 产品编号
    ,prod_cate_cd -- 产品类别代码
    ,curr_cd -- 币种代码
    ,crdt_status_cd -- 授信状态代码
    ,crdt_appl_sucs_flg -- 授信申请成功标志
    ,crdt_chn_cd -- 授信渠道代码
    ,crdt_lmt -- 授信额度
    ,crdt_day_int_rat -- 授信日利率
    ,crdt_year_int_rat -- 授信年利率
    ,crdt_exp_dt -- 授信到期日期
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_char_cd -- 客户性质代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,gender_cd -- 性别代码
    ,nation_cd -- 国籍代码
    ,nome_phone_num -- 家庭电话号码
    ,resdnt_addr -- 居住地址
    ,birth_dt -- 出生日期
    ,id_card_addr_info -- 身份证地址信息
    ,id_card_effect_dt -- 身份证生效日期
    ,id_card_exp_dt -- 身份证到期日期
    ,nationty -- 民族
    ,issue_org -- 签发机关
    ,career_cd -- 职业代码
    ,bank_card_num -- 银行卡号
    ,bank_name -- 银行名称
    ,bank_rsrv_mobile_no -- 银行预留手机号
    ,corp_name -- 企业名称
    ,soci_crdt_cd -- 社会信用代码
    ,bus_lics_num -- 营业执照号
    ,bl_induty_type_type_cd -- 所属行业类型类型代码
    ,dss_flg -- 董监高标志
    ,sm_lab -- 小微标签
    ,borw_usage_cd -- 借款用途代码
    ,risk_mgmt_rest_cd -- 风控结果代码
    ,risk_mgmt_crdt_lmt -- 风控授信额度
    ,risk_mgmt_int_year_int_rat -- 风控利息年利率
    ,risk_mgmt_refuse_code -- 风控拒绝码
    ,risk_mgmt_refuse_rs -- 风控拒绝原因
    ,risk_mgmt_re_dt -- 风控回调日期
    ,lmt_cont_flg -- 额度合同标志
    ,lmt_cont_id -- 额度合同编号
    ,intnal_dubil_id -- 借据编号
    ,actl_lmt -- 实际额度
    ,aval_lmt -- 可用额度
    ,borw_tot_amt -- 借款总金额
    ,unite_bk_amt -- 联合行金额
    ,loan_perds -- 贷款期数
    ,int_accr_way_cd -- 计息方式代码
    ,actl_day_int_rat -- 实际日利率
    ,actl_year_int_rat -- 实际年利率
    ,cap_code -- 资金码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_zjdk_crdt_appl_info_h_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,crdt_appl_flow_num -- 授信申请流水号
    ,myloan_req_flow_num -- 网商贷请求流水号
    ,stud_loan_req_flow_num -- 助贷请求流水号
    ,crdt_appl_type_cd -- 授信申请类型代码
    ,crdt_id -- 授信编号
    ,prod_id -- 产品编号
    ,prod_cate_cd -- 产品类别代码
    ,curr_cd -- 币种代码
    ,crdt_status_cd -- 授信状态代码
    ,crdt_appl_sucs_flg -- 授信申请成功标志
    ,crdt_chn_cd -- 授信渠道代码
    ,crdt_lmt -- 授信额度
    ,crdt_day_int_rat -- 授信日利率
    ,crdt_year_int_rat -- 授信年利率
    ,crdt_exp_dt -- 授信到期日期
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_char_cd -- 客户性质代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,gender_cd -- 性别代码
    ,nation_cd -- 国籍代码
    ,nome_phone_num -- 家庭电话号码
    ,resdnt_addr -- 居住地址
    ,birth_dt -- 出生日期
    ,id_card_addr_info -- 身份证地址信息
    ,id_card_effect_dt -- 身份证生效日期
    ,id_card_exp_dt -- 身份证到期日期
    ,nationty -- 民族
    ,issue_org -- 签发机关
    ,career_cd -- 职业代码
    ,bank_card_num -- 银行卡号
    ,bank_name -- 银行名称
    ,bank_rsrv_mobile_no -- 银行预留手机号
    ,corp_name -- 企业名称
    ,soci_crdt_cd -- 社会信用代码
    ,bus_lics_num -- 营业执照号
    ,bl_induty_type_type_cd -- 所属行业类型类型代码
    ,dss_flg -- 董监高标志
    ,sm_lab -- 小微标签
    ,borw_usage_cd -- 借款用途代码
    ,risk_mgmt_rest_cd -- 风控结果代码
    ,risk_mgmt_crdt_lmt -- 风控授信额度
    ,risk_mgmt_int_year_int_rat -- 风控利息年利率
    ,risk_mgmt_refuse_code -- 风控拒绝码
    ,risk_mgmt_refuse_rs -- 风控拒绝原因
    ,risk_mgmt_re_dt -- 风控回调日期
    ,lmt_cont_flg -- 额度合同标志
    ,lmt_cont_id -- 额度合同编号
    ,intnal_dubil_id -- 借据编号
    ,actl_lmt -- 实际额度
    ,aval_lmt -- 可用额度
    ,borw_tot_amt -- 借款总金额
    ,unite_bk_amt -- 联合行金额
    ,loan_perds -- 贷款期数
    ,int_accr_way_cd -- 计息方式代码
    ,actl_day_int_rat -- 实际日利率
    ,actl_year_int_rat -- 实际年利率
    ,cap_code -- 资金码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
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
    ,o.crdt_appl_flow_num -- 授信申请流水号
    ,o.myloan_req_flow_num -- 网商贷请求流水号
    ,o.stud_loan_req_flow_num -- 助贷请求流水号
    ,o.crdt_appl_type_cd -- 授信申请类型代码
    ,o.crdt_id -- 授信编号
    ,o.prod_id -- 产品编号
    ,o.prod_cate_cd -- 产品类别代码
    ,o.curr_cd -- 币种代码
    ,o.crdt_status_cd -- 授信状态代码
    ,o.crdt_appl_sucs_flg -- 授信申请成功标志
    ,o.crdt_chn_cd -- 授信渠道代码
    ,o.crdt_lmt -- 授信额度
    ,o.crdt_day_int_rat -- 授信日利率
    ,o.crdt_year_int_rat -- 授信年利率
    ,o.crdt_exp_dt -- 授信到期日期
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.cust_char_cd -- 客户性质代码
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.mobile_no -- 手机号码
    ,o.gender_cd -- 性别代码
    ,o.nation_cd -- 国籍代码
    ,o.nome_phone_num -- 家庭电话号码
    ,o.resdnt_addr -- 居住地址
    ,o.birth_dt -- 出生日期
    ,o.id_card_addr_info -- 身份证地址信息
    ,o.id_card_effect_dt -- 身份证生效日期
    ,o.id_card_exp_dt -- 身份证到期日期
    ,o.nationty -- 民族
    ,o.issue_org -- 签发机关
    ,o.career_cd -- 职业代码
    ,o.bank_card_num -- 银行卡号
    ,o.bank_name -- 银行名称
    ,o.bank_rsrv_mobile_no -- 银行预留手机号
    ,o.corp_name -- 企业名称
    ,o.soci_crdt_cd -- 社会信用代码
    ,o.bus_lics_num -- 营业执照号
    ,o.bl_induty_type_type_cd -- 所属行业类型类型代码
    ,o.dss_flg -- 董监高标志
    ,o.sm_lab -- 小微标签
    ,o.borw_usage_cd -- 借款用途代码
    ,o.risk_mgmt_rest_cd -- 风控结果代码
    ,o.risk_mgmt_crdt_lmt -- 风控授信额度
    ,o.risk_mgmt_int_year_int_rat -- 风控利息年利率
    ,o.risk_mgmt_refuse_code -- 风控拒绝码
    ,o.risk_mgmt_refuse_rs -- 风控拒绝原因
    ,o.risk_mgmt_re_dt -- 风控回调日期
    ,o.lmt_cont_flg -- 额度合同标志
    ,o.lmt_cont_id -- 额度合同编号
    ,o.intnal_dubil_id -- 借据编号
    ,o.actl_lmt -- 实际额度
    ,o.aval_lmt -- 可用额度
    ,o.borw_tot_amt -- 借款总金额
    ,o.unite_bk_amt -- 联合行金额
    ,o.loan_perds -- 贷款期数
    ,o.int_accr_way_cd -- 计息方式代码
    ,o.actl_day_int_rat -- 实际日利率
    ,o.actl_year_int_rat -- 实际年利率
    ,o.cap_code -- 资金码
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.final_update_teller_id -- 最后更新柜员编号
    ,o.final_update_org_id -- 最后更新机构编号
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
from ${iml_schema}.agt_zjdk_crdt_appl_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_zjdk_crdt_appl_info_h_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.crdt_appl_flow_num = n.crdt_appl_flow_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_zjdk_crdt_appl_info_h_icmsf1_cl d
        on
            o.appl_id = d.appl_id
            and o.lp_id = d.lp_id
            and o.crdt_appl_flow_num = d.crdt_appl_flow_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_zjdk_crdt_appl_info_h;
--alter table ${iml_schema}.agt_zjdk_crdt_appl_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_zjdk_crdt_appl_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_zjdk_crdt_appl_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_zjdk_crdt_appl_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_zjdk_crdt_appl_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_zjdk_crdt_appl_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_zjdk_crdt_appl_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_zjdk_crdt_appl_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_zjdk_crdt_appl_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_zjdk_crdt_appl_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_zjdk_crdt_appl_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_zjdk_crdt_appl_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_zjdk_crdt_appl_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_zjdk_crdt_appl_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
