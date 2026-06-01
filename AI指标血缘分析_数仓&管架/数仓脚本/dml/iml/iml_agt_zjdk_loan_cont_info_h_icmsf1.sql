/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_zjdk_loan_cont_info_h_icmsf1
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
alter table ${iml_schema}.agt_zjdk_loan_cont_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_zjdk_loan_cont_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_zjdk_loan_cont_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_zjdk_loan_cont_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_zjdk_loan_cont_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_zjdk_loan_cont_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_zjdk_loan_cont_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,myloan_appl_flow_num -- 网商贷申请流水号
    ,stud_loan_appl_flow_num -- 助贷申请流水号
    ,apv_status_cd -- 审批状态代码
    ,lmt_cont_flg -- 额度合同标志
    ,lmt_cont_id -- 额度合同编号
    ,crdt_id -- 授信编号
    ,crdt_day_int_rat -- 授信日利率
    ,aval_lmt -- 可用额度
    ,estim_lmt -- 预估额度
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,prod_id -- 产品编号
    ,prod_cate_cd -- 产品类别代码
    ,cont_valid_flg -- 合同有效标志
    ,cont_amt -- 合同金额
    ,cont_bal -- 合同余额
    ,loan_int_rat -- 贷款利率
    ,curr_cd -- 币种代码
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,tenor -- 期限
    ,loan_usage_cd -- 贷款用途代码
    ,intnal_dubil_id -- 借据编号
    ,zjck_acct_close_dt -- 字节账户关闭日期
    ,zjck_acct_close_type_cd -- 字节账户关闭类型代码
    ,bl_induty_cd -- 所属行业代码
    ,loan_dir_cd -- 贷款投向代码
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
from ${iml_schema}.agt_zjdk_loan_cont_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_zjdk_loan_cont_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_zjdk_loan_cont_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_zjdk_loan_cont_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_zjdk_loan_cont_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_zjbk_business_contract-1
insert into ${iml_schema}.agt_zjdk_loan_cont_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,myloan_appl_flow_num -- 网商贷申请流水号
    ,stud_loan_appl_flow_num -- 助贷申请流水号
    ,apv_status_cd -- 审批状态代码
    ,lmt_cont_flg -- 额度合同标志
    ,lmt_cont_id -- 额度合同编号
    ,crdt_id -- 授信编号
    ,crdt_day_int_rat -- 授信日利率
    ,aval_lmt -- 可用额度
    ,estim_lmt -- 预估额度
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,prod_id -- 产品编号
    ,prod_cate_cd -- 产品类别代码
    ,cont_valid_flg -- 合同有效标志
    ,cont_amt -- 合同金额
    ,cont_bal -- 合同余额
    ,loan_int_rat -- 贷款利率
    ,curr_cd -- 币种代码
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,tenor -- 期限
    ,loan_usage_cd -- 贷款用途代码
    ,intnal_dubil_id -- 借据编号
    ,zjck_acct_close_dt -- 字节账户关闭日期
    ,zjck_acct_close_type_cd -- 字节账户关闭类型代码
    ,bl_induty_cd -- 所属行业代码
    ,loan_dir_cd -- 贷款投向代码
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
    '300062'||P1.SERIALNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 合同编号
    ,P1.RELATIVELHDSERIALNO -- 网商贷申请流水号
    ,P1.RELATIVEZDSERIALNO -- 助贷申请流水号
    ,nvl(trim(P1.APPROVESTATUS),'-') -- 审批状态代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'|| P1.BUSINESSFLAG END -- 额度合同标志
    ,P1.PARENTSERIALNO -- 额度合同编号
    ,P1.ACCOUNTID -- 授信编号
    ,P1.DAILYRATE -- 授信日利率
    ,0 -- 可用额度
    ,P1.NEWCRDTESTIMATLMT -- 预估额度
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CUSTOMERNAME -- 客户名称
    ,nvl(trim(P1.CERTTYPE),'0000') -- 证件类型代码
    ,P1.CERTID -- 证件号码
    ,P1.PHONE -- 手机号码
    ,P1.PRODUCTID -- 产品编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'|| replace(replace(P1.PRODUCTMODE,chr(13),''),chr(10),'') END -- 产品类别代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.STATUS END -- 合同有效标志
    ,P1.BUSINESSSUM -- 合同金额
    ,P1.BALANCE -- 合同余额
    ,P1.INTRATE -- 贷款利率
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,P1.STARTDATE -- 起始日期
    ,P1.ENDDATE -- 到期日期
    ,P1.TERMMONTH -- 期限
    ,nvl(trim(P1.USAGE),'000000') -- 贷款用途代码
    ,P1.LOANID -- 借据编号
    ,${iml_schema}.dateformat_max2(P1.CLOSEDATE) -- 字节账户关闭日期
    ,nvl(trim(P1.CLOSETYPE),'-') -- 字节账户关闭类型代码
    ,nvl(trim(P1.COMPANYINDUSTRY),'-') -- 所属行业代码
    ,nvl(trim(P1.INTRAINDUSTRYTYPE),'-') -- 贷款投向代码
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 最后更新柜员编号
    ,P1.UPDATEORGID -- 最后更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_zjbk_business_contract' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_zjbk_business_contract p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.BUSINESSFLAG = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_ZJBK_BUSINESS_CONTRACT'
        AND R1.SRC_FIELD_EN_NAME= 'BUSINESSFLAG'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_ZJDK_LOAN_CONT_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'LMT_CONT_FLG'
    left join ${iml_schema}.ref_pub_cd_map r2 on  replace(replace(P1.PRODUCTMODE,chr(13),''),chr(10),'') = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_ZJBK_BUSINESS_CONTRACT'
        AND R2.SRC_FIELD_EN_NAME= 'PRODUCTMODE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_ZJDK_LOAN_CONT_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'PROD_CATE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.STATUS = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'ICMS'
        AND R3.SRC_TAB_EN_NAME= 'ICMS_ZJBK_BUSINESS_CONTRACT'
        AND R3.SRC_FIELD_EN_NAME= 'STATUS'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_ZJDK_LOAN_CONT_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CONT_VALID_FLG'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_zjdk_loan_cont_info_h_icmsf1_tm 
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
        into ${iml_schema}.agt_zjdk_loan_cont_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,myloan_appl_flow_num -- 网商贷申请流水号
    ,stud_loan_appl_flow_num -- 助贷申请流水号
    ,apv_status_cd -- 审批状态代码
    ,lmt_cont_flg -- 额度合同标志
    ,lmt_cont_id -- 额度合同编号
    ,crdt_id -- 授信编号
    ,crdt_day_int_rat -- 授信日利率
    ,aval_lmt -- 可用额度
    ,estim_lmt -- 预估额度
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,prod_id -- 产品编号
    ,prod_cate_cd -- 产品类别代码
    ,cont_valid_flg -- 合同有效标志
    ,cont_amt -- 合同金额
    ,cont_bal -- 合同余额
    ,loan_int_rat -- 贷款利率
    ,curr_cd -- 币种代码
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,tenor -- 期限
    ,loan_usage_cd -- 贷款用途代码
    ,intnal_dubil_id -- 借据编号
    ,zjck_acct_close_dt -- 字节账户关闭日期
    ,zjck_acct_close_type_cd -- 字节账户关闭类型代码
    ,bl_induty_cd -- 所属行业代码
    ,loan_dir_cd -- 贷款投向代码
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
        into ${iml_schema}.agt_zjdk_loan_cont_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,myloan_appl_flow_num -- 网商贷申请流水号
    ,stud_loan_appl_flow_num -- 助贷申请流水号
    ,apv_status_cd -- 审批状态代码
    ,lmt_cont_flg -- 额度合同标志
    ,lmt_cont_id -- 额度合同编号
    ,crdt_id -- 授信编号
    ,crdt_day_int_rat -- 授信日利率
    ,aval_lmt -- 可用额度
    ,estim_lmt -- 预估额度
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,prod_id -- 产品编号
    ,prod_cate_cd -- 产品类别代码
    ,cont_valid_flg -- 合同有效标志
    ,cont_amt -- 合同金额
    ,cont_bal -- 合同余额
    ,loan_int_rat -- 贷款利率
    ,curr_cd -- 币种代码
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,tenor -- 期限
    ,loan_usage_cd -- 贷款用途代码
    ,intnal_dubil_id -- 借据编号
    ,zjck_acct_close_dt -- 字节账户关闭日期
    ,zjck_acct_close_type_cd -- 字节账户关闭类型代码
    ,bl_induty_cd -- 所属行业代码
    ,loan_dir_cd -- 贷款投向代码
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
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.myloan_appl_flow_num, o.myloan_appl_flow_num) as myloan_appl_flow_num -- 网商贷申请流水号
    ,nvl(n.stud_loan_appl_flow_num, o.stud_loan_appl_flow_num) as stud_loan_appl_flow_num -- 助贷申请流水号
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.lmt_cont_flg, o.lmt_cont_flg) as lmt_cont_flg -- 额度合同标志
    ,nvl(n.lmt_cont_id, o.lmt_cont_id) as lmt_cont_id -- 额度合同编号
    ,nvl(n.crdt_id, o.crdt_id) as crdt_id -- 授信编号
    ,nvl(n.crdt_day_int_rat, o.crdt_day_int_rat) as crdt_day_int_rat -- 授信日利率
    ,nvl(n.aval_lmt, o.aval_lmt) as aval_lmt -- 可用额度
    ,nvl(n.estim_lmt, o.estim_lmt) as estim_lmt -- 预估额度
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 手机号码
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.prod_cate_cd, o.prod_cate_cd) as prod_cate_cd -- 产品类别代码
    ,nvl(n.cont_valid_flg, o.cont_valid_flg) as cont_valid_flg -- 合同有效标志
    ,nvl(n.cont_amt, o.cont_amt) as cont_amt -- 合同金额
    ,nvl(n.cont_bal, o.cont_bal) as cont_bal -- 合同余额
    ,nvl(n.loan_int_rat, o.loan_int_rat) as loan_int_rat -- 贷款利率
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.begin_dt, o.begin_dt) as begin_dt -- 起始日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.tenor, o.tenor) as tenor -- 期限
    ,nvl(n.loan_usage_cd, o.loan_usage_cd) as loan_usage_cd -- 贷款用途代码
    ,nvl(n.intnal_dubil_id, o.intnal_dubil_id) as intnal_dubil_id -- 借据编号
    ,nvl(n.zjck_acct_close_dt, o.zjck_acct_close_dt) as zjck_acct_close_dt -- 字节账户关闭日期
    ,nvl(n.zjck_acct_close_type_cd, o.zjck_acct_close_type_cd) as zjck_acct_close_type_cd -- 字节账户关闭类型代码
    ,nvl(n.bl_induty_cd, o.bl_induty_cd) as bl_induty_cd -- 所属行业代码
    ,nvl(n.loan_dir_cd, o.loan_dir_cd) as loan_dir_cd -- 贷款投向代码
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.final_update_teller_id, o.final_update_teller_id) as final_update_teller_id -- 最后更新柜员编号
    ,nvl(n.final_update_org_id, o.final_update_org_id) as final_update_org_id -- 最后更新机构编号
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
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
from ${iml_schema}.agt_zjdk_loan_cont_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_zjdk_loan_cont_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.cont_id <> n.cont_id
        or o.myloan_appl_flow_num <> n.myloan_appl_flow_num
        or o.stud_loan_appl_flow_num <> n.stud_loan_appl_flow_num
        or o.apv_status_cd <> n.apv_status_cd
        or o.lmt_cont_flg <> n.lmt_cont_flg
        or o.lmt_cont_id <> n.lmt_cont_id
        or o.crdt_id <> n.crdt_id
        or o.crdt_day_int_rat <> n.crdt_day_int_rat
        or o.aval_lmt <> n.aval_lmt
        or o.estim_lmt <> n.estim_lmt
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.mobile_no <> n.mobile_no
        or o.prod_id <> n.prod_id
        or o.prod_cate_cd <> n.prod_cate_cd
        or o.cont_valid_flg <> n.cont_valid_flg
        or o.cont_amt <> n.cont_amt
        or o.cont_bal <> n.cont_bal
        or o.loan_int_rat <> n.loan_int_rat
        or o.curr_cd <> n.curr_cd
        or o.begin_dt <> n.begin_dt
        or o.exp_dt <> n.exp_dt
        or o.tenor <> n.tenor
        or o.loan_usage_cd <> n.loan_usage_cd
        or o.intnal_dubil_id <> n.intnal_dubil_id
        or o.zjck_acct_close_dt <> n.zjck_acct_close_dt
        or o.zjck_acct_close_type_cd <> n.zjck_acct_close_type_cd
        or o.bl_induty_cd <> n.bl_induty_cd
        or o.loan_dir_cd <> n.loan_dir_cd
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
        into ${iml_schema}.agt_zjdk_loan_cont_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,myloan_appl_flow_num -- 网商贷申请流水号
    ,stud_loan_appl_flow_num -- 助贷申请流水号
    ,apv_status_cd -- 审批状态代码
    ,lmt_cont_flg -- 额度合同标志
    ,lmt_cont_id -- 额度合同编号
    ,crdt_id -- 授信编号
    ,crdt_day_int_rat -- 授信日利率
    ,aval_lmt -- 可用额度
    ,estim_lmt -- 预估额度
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,prod_id -- 产品编号
    ,prod_cate_cd -- 产品类别代码
    ,cont_valid_flg -- 合同有效标志
    ,cont_amt -- 合同金额
    ,cont_bal -- 合同余额
    ,loan_int_rat -- 贷款利率
    ,curr_cd -- 币种代码
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,tenor -- 期限
    ,loan_usage_cd -- 贷款用途代码
    ,intnal_dubil_id -- 借据编号
    ,zjck_acct_close_dt -- 字节账户关闭日期
    ,zjck_acct_close_type_cd -- 字节账户关闭类型代码
    ,bl_induty_cd -- 所属行业代码
    ,loan_dir_cd -- 贷款投向代码
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
        into ${iml_schema}.agt_zjdk_loan_cont_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,myloan_appl_flow_num -- 网商贷申请流水号
    ,stud_loan_appl_flow_num -- 助贷申请流水号
    ,apv_status_cd -- 审批状态代码
    ,lmt_cont_flg -- 额度合同标志
    ,lmt_cont_id -- 额度合同编号
    ,crdt_id -- 授信编号
    ,crdt_day_int_rat -- 授信日利率
    ,aval_lmt -- 可用额度
    ,estim_lmt -- 预估额度
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,prod_id -- 产品编号
    ,prod_cate_cd -- 产品类别代码
    ,cont_valid_flg -- 合同有效标志
    ,cont_amt -- 合同金额
    ,cont_bal -- 合同余额
    ,loan_int_rat -- 贷款利率
    ,curr_cd -- 币种代码
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,tenor -- 期限
    ,loan_usage_cd -- 贷款用途代码
    ,intnal_dubil_id -- 借据编号
    ,zjck_acct_close_dt -- 字节账户关闭日期
    ,zjck_acct_close_type_cd -- 字节账户关闭类型代码
    ,bl_induty_cd -- 所属行业代码
    ,loan_dir_cd -- 贷款投向代码
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
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.cont_id -- 合同编号
    ,o.myloan_appl_flow_num -- 网商贷申请流水号
    ,o.stud_loan_appl_flow_num -- 助贷申请流水号
    ,o.apv_status_cd -- 审批状态代码
    ,o.lmt_cont_flg -- 额度合同标志
    ,o.lmt_cont_id -- 额度合同编号
    ,o.crdt_id -- 授信编号
    ,o.crdt_day_int_rat -- 授信日利率
    ,o.aval_lmt -- 可用额度
    ,o.estim_lmt -- 预估额度
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.mobile_no -- 手机号码
    ,o.prod_id -- 产品编号
    ,o.prod_cate_cd -- 产品类别代码
    ,o.cont_valid_flg -- 合同有效标志
    ,o.cont_amt -- 合同金额
    ,o.cont_bal -- 合同余额
    ,o.loan_int_rat -- 贷款利率
    ,o.curr_cd -- 币种代码
    ,o.begin_dt -- 起始日期
    ,o.exp_dt -- 到期日期
    ,o.tenor -- 期限
    ,o.loan_usage_cd -- 贷款用途代码
    ,o.intnal_dubil_id -- 借据编号
    ,o.zjck_acct_close_dt -- 字节账户关闭日期
    ,o.zjck_acct_close_type_cd -- 字节账户关闭类型代码
    ,o.bl_induty_cd -- 所属行业代码
    ,o.loan_dir_cd -- 贷款投向代码
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
from ${iml_schema}.agt_zjdk_loan_cont_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_zjdk_loan_cont_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_zjdk_loan_cont_info_h_icmsf1_cl d
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
--truncate table ${iml_schema}.agt_zjdk_loan_cont_info_h;
--alter table ${iml_schema}.agt_zjdk_loan_cont_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_zjdk_loan_cont_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_zjdk_loan_cont_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_zjdk_loan_cont_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_zjdk_loan_cont_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_zjdk_loan_cont_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_zjdk_loan_cont_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_zjdk_loan_cont_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_zjdk_loan_cont_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_zjdk_loan_cont_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_zjdk_loan_cont_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_zjdk_loan_cont_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_zjdk_loan_cont_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_zjdk_loan_cont_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
