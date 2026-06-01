/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_lhwd_guar_cont_info_h_icmsf1
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
alter table ${iml_schema}.agt_lhwd_guar_cont_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_lhwd_guar_cont_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lhwd_guar_cont_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_lhwd_guar_cont_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_lhwd_guar_cont_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_lhwd_guar_cont_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lhwd_guar_cont_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,guar_cont_id -- 担保合同编号
    ,guar_cont_type_cd -- 担保合同类型代码
    ,guar_cont_status_cd -- 担保合同状态代码
    ,sign_dt -- 签订日期
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,guar_way_cd -- 担保方式代码
    ,guar_guar_form_cd -- 保证担保形式代码
    ,guar_cust_id -- 被担保客户编号
    ,guartor_id -- 担保人编号
    ,guartor_name -- 担保人名称
    ,guartor_type_cd -- 担保人类型代码
    ,guartor_cert_type_cd -- 担保人证件类型代码
    ,guartor_cert_no -- 担保人证件号码
    ,guartor_loan_card_no -- 担保人贷款卡号
    ,guartor_fax_num -- 担保人传真号码
    ,guartor_tel_num -- 担保人电话号码
    ,guartor_addr -- 担保人地址
    ,guartor_guar_ability_uplmi -- 担保人保证能力上限
    ,curr_cd -- 币种代码
    ,guar_amt -- 担保金额
    ,guar_tenor -- 担保期限
    ,aldy_guar_amt -- 已担保金额
    ,aval_bal -- 可用余额
    ,cust_risk_actl_pm_rat -- 客户风险实际抵质押率
    ,apv_pm_rat -- 审批抵质押率
    ,guar_survey -- 担保物概况
    ,other_espec_apot -- 其它特别约定
    ,guar_opinion -- 担保意见
    ,gover_fin_guar_corp_guar_flg -- 政府性融资担保公司保证标志
    ,rev_guar_flg -- 反担保标志
    ,check_guar_dt -- 核保日期
    ,fst_ctfer_name -- 第一核保人名称
    ,secd_ctfer_name -- 第二核保人名称
    ,crdt_chn_cd -- 授信渠道代码
    ,col_id -- 押品编号
    ,lmt_id -- 额度编号
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
from ${iml_schema}.agt_lhwd_guar_cont_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_lhwd_guar_cont_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lhwd_guar_cont_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_lhwd_guar_cont_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lhwd_guar_cont_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_lhwd_guaranty_contract-1
insert into ${iml_schema}.agt_lhwd_guar_cont_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,guar_cont_id -- 担保合同编号
    ,guar_cont_type_cd -- 担保合同类型代码
    ,guar_cont_status_cd -- 担保合同状态代码
    ,sign_dt -- 签订日期
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,guar_way_cd -- 担保方式代码
    ,guar_guar_form_cd -- 保证担保形式代码
    ,guar_cust_id -- 被担保客户编号
    ,guartor_id -- 担保人编号
    ,guartor_name -- 担保人名称
    ,guartor_type_cd -- 担保人类型代码
    ,guartor_cert_type_cd -- 担保人证件类型代码
    ,guartor_cert_no -- 担保人证件号码
    ,guartor_loan_card_no -- 担保人贷款卡号
    ,guartor_fax_num -- 担保人传真号码
    ,guartor_tel_num -- 担保人电话号码
    ,guartor_addr -- 担保人地址
    ,guartor_guar_ability_uplmi -- 担保人保证能力上限
    ,curr_cd -- 币种代码
    ,guar_amt -- 担保金额
    ,guar_tenor -- 担保期限
    ,aldy_guar_amt -- 已担保金额
    ,aval_bal -- 可用余额
    ,cust_risk_actl_pm_rat -- 客户风险实际抵质押率
    ,apv_pm_rat -- 审批抵质押率
    ,guar_survey -- 担保物概况
    ,other_espec_apot -- 其它特别约定
    ,guar_opinion -- 担保意见
    ,gover_fin_guar_corp_guar_flg -- 政府性融资担保公司保证标志
    ,rev_guar_flg -- 反担保标志
    ,check_guar_dt -- 核保日期
    ,fst_ctfer_name -- 第一核保人名称
    ,secd_ctfer_name -- 第二核保人名称
    ,crdt_chn_cd -- 授信渠道代码
    ,col_id -- 押品编号
    ,lmt_id -- 额度编号
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
    '300075'||P1.GUARANTYNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.GUARANTYNO -- 担保合同编号
    ,nvl(trim(P1.GUARANTYTYPE),'-') -- 担保合同类型代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'|| P1.GUARANTYSTATUS END -- 担保合同状态代码
    ,${iml_schema}.dateformat_min(P1.SIGNDATE) -- 签订日期
    ,${iml_schema}.dateformat_min(P1.BEGINDATE) -- 生效日期
    ,${iml_schema}.dateformat_max2(P1.ENDDATE) -- 到期日期
    ,nvl(trim(P1.GUARANTYSTYLE),'-') -- 担保方式代码
    ,nvl(trim(P1.GUARANTEEFORM),'-') -- 保证担保形式代码
    ,P1.CUSTOMERID -- 被担保客户编号
    ,P1.GUARANTORID -- 担保人编号
    ,P1.GUARANTORNAME -- 担保人名称
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'|| P1.GUARTORCATE END -- 担保人类型代码
    ,nvl(trim(P1.CERTTYPE),'0000') -- 担保人证件类型代码
    ,P1.CERTID -- 担保人证件号码
    ,P1.LOANCARDNO -- 担保人贷款卡号
    ,P1.GUARANTYFAX -- 担保人传真号码
    ,P1.GUARANTYPHONE -- 担保人电话号码
    ,P1.GUARANTYADDRESS -- 担保人地址
    ,P1.MAXIMUMGUARABILITY -- 担保人保证能力上限
    ,nvl(trim(P1.GUARANTYCURRENCY),'-') -- 币种代码
    ,P1.GUARANTYVALUE -- 担保金额
    ,P1.GUARTERM -- 担保期限
    ,P1.USESUM -- 已担保金额
    ,P1.GUARBALANCE -- 可用余额
    ,P1.CUSTOMERRISKACTUALRATE -- 客户风险实际抵质押率
    ,P1.APPROVALANDPLEDGERATE -- 审批抵质押率
    ,P1.GUARANTYINFO -- 担保物概况
    ,P1.OTHERDESCSRIBE -- 其它特别约定
    ,P1.GUARANTYOPINION -- 担保意见
    ,nvl(trim(P1.ISGUARANTYPLATFORMLOAN),'-') -- 政府性融资担保公司保证标志
    ,nvl(trim(P1.ISBACKGUARANTY),'-') -- 反担保标志
    ,${iml_schema}.dateformat_max2(P1.CHECKGUARANTYDATE) -- 核保日期
    ,P1.CHECKGUARANTYMANA -- 第一核保人名称
    ,P1.CHECKGUARANTYMANB -- 第二核保人名称
    ,nvl(trim(P1.CREDITCHANNEL),'-') -- 授信渠道代码
    ,P1.YPGUARANTORID -- 押品编号
    ,P1.CLNO -- 额度编号
    ,P1.REMARK -- 备注
    ,P1.INPUTORGID -- 登记柜员编号
    ,P1.INPUTUSERID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEORGID -- 更新柜员编号
    ,P1.UPDATEUSERID -- 更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_lhwd_guaranty_contract' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_lhwd_guaranty_contract p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.GUARANTYSTATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_LHWD_GUARANTY_CONTRACT'
        AND R1.SRC_FIELD_EN_NAME= 'GUARANTYSTATUS'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_LHWD_GUAR_CONT_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'GUAR_CONT_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.GUARTORCATE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_LHWD_GUARANTY_CONTRACT'
        AND R2.SRC_FIELD_EN_NAME= 'GUARTORCATE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_LHWD_GUAR_CONT_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'GUARTOR_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_lhwd_guar_cont_info_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,guar_cont_id
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
        into ${iml_schema}.agt_lhwd_guar_cont_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,guar_cont_id -- 担保合同编号
    ,guar_cont_type_cd -- 担保合同类型代码
    ,guar_cont_status_cd -- 担保合同状态代码
    ,sign_dt -- 签订日期
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,guar_way_cd -- 担保方式代码
    ,guar_guar_form_cd -- 保证担保形式代码
    ,guar_cust_id -- 被担保客户编号
    ,guartor_id -- 担保人编号
    ,guartor_name -- 担保人名称
    ,guartor_type_cd -- 担保人类型代码
    ,guartor_cert_type_cd -- 担保人证件类型代码
    ,guartor_cert_no -- 担保人证件号码
    ,guartor_loan_card_no -- 担保人贷款卡号
    ,guartor_fax_num -- 担保人传真号码
    ,guartor_tel_num -- 担保人电话号码
    ,guartor_addr -- 担保人地址
    ,guartor_guar_ability_uplmi -- 担保人保证能力上限
    ,curr_cd -- 币种代码
    ,guar_amt -- 担保金额
    ,guar_tenor -- 担保期限
    ,aldy_guar_amt -- 已担保金额
    ,aval_bal -- 可用余额
    ,cust_risk_actl_pm_rat -- 客户风险实际抵质押率
    ,apv_pm_rat -- 审批抵质押率
    ,guar_survey -- 担保物概况
    ,other_espec_apot -- 其它特别约定
    ,guar_opinion -- 担保意见
    ,gover_fin_guar_corp_guar_flg -- 政府性融资担保公司保证标志
    ,rev_guar_flg -- 反担保标志
    ,check_guar_dt -- 核保日期
    ,fst_ctfer_name -- 第一核保人名称
    ,secd_ctfer_name -- 第二核保人名称
    ,crdt_chn_cd -- 授信渠道代码
    ,col_id -- 押品编号
    ,lmt_id -- 额度编号
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
        into ${iml_schema}.agt_lhwd_guar_cont_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,guar_cont_id -- 担保合同编号
    ,guar_cont_type_cd -- 担保合同类型代码
    ,guar_cont_status_cd -- 担保合同状态代码
    ,sign_dt -- 签订日期
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,guar_way_cd -- 担保方式代码
    ,guar_guar_form_cd -- 保证担保形式代码
    ,guar_cust_id -- 被担保客户编号
    ,guartor_id -- 担保人编号
    ,guartor_name -- 担保人名称
    ,guartor_type_cd -- 担保人类型代码
    ,guartor_cert_type_cd -- 担保人证件类型代码
    ,guartor_cert_no -- 担保人证件号码
    ,guartor_loan_card_no -- 担保人贷款卡号
    ,guartor_fax_num -- 担保人传真号码
    ,guartor_tel_num -- 担保人电话号码
    ,guartor_addr -- 担保人地址
    ,guartor_guar_ability_uplmi -- 担保人保证能力上限
    ,curr_cd -- 币种代码
    ,guar_amt -- 担保金额
    ,guar_tenor -- 担保期限
    ,aldy_guar_amt -- 已担保金额
    ,aval_bal -- 可用余额
    ,cust_risk_actl_pm_rat -- 客户风险实际抵质押率
    ,apv_pm_rat -- 审批抵质押率
    ,guar_survey -- 担保物概况
    ,other_espec_apot -- 其它特别约定
    ,guar_opinion -- 担保意见
    ,gover_fin_guar_corp_guar_flg -- 政府性融资担保公司保证标志
    ,rev_guar_flg -- 反担保标志
    ,check_guar_dt -- 核保日期
    ,fst_ctfer_name -- 第一核保人名称
    ,secd_ctfer_name -- 第二核保人名称
    ,crdt_chn_cd -- 授信渠道代码
    ,col_id -- 押品编号
    ,lmt_id -- 额度编号
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
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.guar_cont_id, o.guar_cont_id) as guar_cont_id -- 担保合同编号
    ,nvl(n.guar_cont_type_cd, o.guar_cont_type_cd) as guar_cont_type_cd -- 担保合同类型代码
    ,nvl(n.guar_cont_status_cd, o.guar_cont_status_cd) as guar_cont_status_cd -- 担保合同状态代码
    ,nvl(n.sign_dt, o.sign_dt) as sign_dt -- 签订日期
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.guar_way_cd, o.guar_way_cd) as guar_way_cd -- 担保方式代码
    ,nvl(n.guar_guar_form_cd, o.guar_guar_form_cd) as guar_guar_form_cd -- 保证担保形式代码
    ,nvl(n.guar_cust_id, o.guar_cust_id) as guar_cust_id -- 被担保客户编号
    ,nvl(n.guartor_id, o.guartor_id) as guartor_id -- 担保人编号
    ,nvl(n.guartor_name, o.guartor_name) as guartor_name -- 担保人名称
    ,nvl(n.guartor_type_cd, o.guartor_type_cd) as guartor_type_cd -- 担保人类型代码
    ,nvl(n.guartor_cert_type_cd, o.guartor_cert_type_cd) as guartor_cert_type_cd -- 担保人证件类型代码
    ,nvl(n.guartor_cert_no, o.guartor_cert_no) as guartor_cert_no -- 担保人证件号码
    ,nvl(n.guartor_loan_card_no, o.guartor_loan_card_no) as guartor_loan_card_no -- 担保人贷款卡号
    ,nvl(n.guartor_fax_num, o.guartor_fax_num) as guartor_fax_num -- 担保人传真号码
    ,nvl(n.guartor_tel_num, o.guartor_tel_num) as guartor_tel_num -- 担保人电话号码
    ,nvl(n.guartor_addr, o.guartor_addr) as guartor_addr -- 担保人地址
    ,nvl(n.guartor_guar_ability_uplmi, o.guartor_guar_ability_uplmi) as guartor_guar_ability_uplmi -- 担保人保证能力上限
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.guar_amt, o.guar_amt) as guar_amt -- 担保金额
    ,nvl(n.guar_tenor, o.guar_tenor) as guar_tenor -- 担保期限
    ,nvl(n.aldy_guar_amt, o.aldy_guar_amt) as aldy_guar_amt -- 已担保金额
    ,nvl(n.aval_bal, o.aval_bal) as aval_bal -- 可用余额
    ,nvl(n.cust_risk_actl_pm_rat, o.cust_risk_actl_pm_rat) as cust_risk_actl_pm_rat -- 客户风险实际抵质押率
    ,nvl(n.apv_pm_rat, o.apv_pm_rat) as apv_pm_rat -- 审批抵质押率
    ,nvl(n.guar_survey, o.guar_survey) as guar_survey -- 担保物概况
    ,nvl(n.other_espec_apot, o.other_espec_apot) as other_espec_apot -- 其它特别约定
    ,nvl(n.guar_opinion, o.guar_opinion) as guar_opinion -- 担保意见
    ,nvl(n.gover_fin_guar_corp_guar_flg, o.gover_fin_guar_corp_guar_flg) as gover_fin_guar_corp_guar_flg -- 政府性融资担保公司保证标志
    ,nvl(n.rev_guar_flg, o.rev_guar_flg) as rev_guar_flg -- 反担保标志
    ,nvl(n.check_guar_dt, o.check_guar_dt) as check_guar_dt -- 核保日期
    ,nvl(n.fst_ctfer_name, o.fst_ctfer_name) as fst_ctfer_name -- 第一核保人名称
    ,nvl(n.secd_ctfer_name, o.secd_ctfer_name) as secd_ctfer_name -- 第二核保人名称
    ,nvl(n.crdt_chn_cd, o.crdt_chn_cd) as crdt_chn_cd -- 授信渠道代码
    ,nvl(n.col_id, o.col_id) as col_id -- 押品编号
    ,nvl(n.lmt_id, o.lmt_id) as lmt_id -- 额度编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.guar_cont_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.guar_cont_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.guar_cont_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_lhwd_guar_cont_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_lhwd_guar_cont_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.guar_cont_id = n.guar_cont_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.guar_cont_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.guar_cont_id is null
    )
    or (
        o.guar_cont_type_cd <> n.guar_cont_type_cd
        or o.guar_cont_status_cd <> n.guar_cont_status_cd
        or o.sign_dt <> n.sign_dt
        or o.effect_dt <> n.effect_dt
        or o.exp_dt <> n.exp_dt
        or o.guar_way_cd <> n.guar_way_cd
        or o.guar_guar_form_cd <> n.guar_guar_form_cd
        or o.guar_cust_id <> n.guar_cust_id
        or o.guartor_id <> n.guartor_id
        or o.guartor_name <> n.guartor_name
        or o.guartor_type_cd <> n.guartor_type_cd
        or o.guartor_cert_type_cd <> n.guartor_cert_type_cd
        or o.guartor_cert_no <> n.guartor_cert_no
        or o.guartor_loan_card_no <> n.guartor_loan_card_no
        or o.guartor_fax_num <> n.guartor_fax_num
        or o.guartor_tel_num <> n.guartor_tel_num
        or o.guartor_addr <> n.guartor_addr
        or o.guartor_guar_ability_uplmi <> n.guartor_guar_ability_uplmi
        or o.curr_cd <> n.curr_cd
        or o.guar_amt <> n.guar_amt
        or o.guar_tenor <> n.guar_tenor
        or o.aldy_guar_amt <> n.aldy_guar_amt
        or o.aval_bal <> n.aval_bal
        or o.cust_risk_actl_pm_rat <> n.cust_risk_actl_pm_rat
        or o.apv_pm_rat <> n.apv_pm_rat
        or o.guar_survey <> n.guar_survey
        or o.other_espec_apot <> n.other_espec_apot
        or o.guar_opinion <> n.guar_opinion
        or o.gover_fin_guar_corp_guar_flg <> n.gover_fin_guar_corp_guar_flg
        or o.rev_guar_flg <> n.rev_guar_flg
        or o.check_guar_dt <> n.check_guar_dt
        or o.fst_ctfer_name <> n.fst_ctfer_name
        or o.secd_ctfer_name <> n.secd_ctfer_name
        or o.crdt_chn_cd <> n.crdt_chn_cd
        or o.col_id <> n.col_id
        or o.lmt_id <> n.lmt_id
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
        into ${iml_schema}.agt_lhwd_guar_cont_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,guar_cont_id -- 担保合同编号
    ,guar_cont_type_cd -- 担保合同类型代码
    ,guar_cont_status_cd -- 担保合同状态代码
    ,sign_dt -- 签订日期
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,guar_way_cd -- 担保方式代码
    ,guar_guar_form_cd -- 保证担保形式代码
    ,guar_cust_id -- 被担保客户编号
    ,guartor_id -- 担保人编号
    ,guartor_name -- 担保人名称
    ,guartor_type_cd -- 担保人类型代码
    ,guartor_cert_type_cd -- 担保人证件类型代码
    ,guartor_cert_no -- 担保人证件号码
    ,guartor_loan_card_no -- 担保人贷款卡号
    ,guartor_fax_num -- 担保人传真号码
    ,guartor_tel_num -- 担保人电话号码
    ,guartor_addr -- 担保人地址
    ,guartor_guar_ability_uplmi -- 担保人保证能力上限
    ,curr_cd -- 币种代码
    ,guar_amt -- 担保金额
    ,guar_tenor -- 担保期限
    ,aldy_guar_amt -- 已担保金额
    ,aval_bal -- 可用余额
    ,cust_risk_actl_pm_rat -- 客户风险实际抵质押率
    ,apv_pm_rat -- 审批抵质押率
    ,guar_survey -- 担保物概况
    ,other_espec_apot -- 其它特别约定
    ,guar_opinion -- 担保意见
    ,gover_fin_guar_corp_guar_flg -- 政府性融资担保公司保证标志
    ,rev_guar_flg -- 反担保标志
    ,check_guar_dt -- 核保日期
    ,fst_ctfer_name -- 第一核保人名称
    ,secd_ctfer_name -- 第二核保人名称
    ,crdt_chn_cd -- 授信渠道代码
    ,col_id -- 押品编号
    ,lmt_id -- 额度编号
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
        into ${iml_schema}.agt_lhwd_guar_cont_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,guar_cont_id -- 担保合同编号
    ,guar_cont_type_cd -- 担保合同类型代码
    ,guar_cont_status_cd -- 担保合同状态代码
    ,sign_dt -- 签订日期
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,guar_way_cd -- 担保方式代码
    ,guar_guar_form_cd -- 保证担保形式代码
    ,guar_cust_id -- 被担保客户编号
    ,guartor_id -- 担保人编号
    ,guartor_name -- 担保人名称
    ,guartor_type_cd -- 担保人类型代码
    ,guartor_cert_type_cd -- 担保人证件类型代码
    ,guartor_cert_no -- 担保人证件号码
    ,guartor_loan_card_no -- 担保人贷款卡号
    ,guartor_fax_num -- 担保人传真号码
    ,guartor_tel_num -- 担保人电话号码
    ,guartor_addr -- 担保人地址
    ,guartor_guar_ability_uplmi -- 担保人保证能力上限
    ,curr_cd -- 币种代码
    ,guar_amt -- 担保金额
    ,guar_tenor -- 担保期限
    ,aldy_guar_amt -- 已担保金额
    ,aval_bal -- 可用余额
    ,cust_risk_actl_pm_rat -- 客户风险实际抵质押率
    ,apv_pm_rat -- 审批抵质押率
    ,guar_survey -- 担保物概况
    ,other_espec_apot -- 其它特别约定
    ,guar_opinion -- 担保意见
    ,gover_fin_guar_corp_guar_flg -- 政府性融资担保公司保证标志
    ,rev_guar_flg -- 反担保标志
    ,check_guar_dt -- 核保日期
    ,fst_ctfer_name -- 第一核保人名称
    ,secd_ctfer_name -- 第二核保人名称
    ,crdt_chn_cd -- 授信渠道代码
    ,col_id -- 押品编号
    ,lmt_id -- 额度编号
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
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.guar_cont_id -- 担保合同编号
    ,o.guar_cont_type_cd -- 担保合同类型代码
    ,o.guar_cont_status_cd -- 担保合同状态代码
    ,o.sign_dt -- 签订日期
    ,o.effect_dt -- 生效日期
    ,o.exp_dt -- 到期日期
    ,o.guar_way_cd -- 担保方式代码
    ,o.guar_guar_form_cd -- 保证担保形式代码
    ,o.guar_cust_id -- 被担保客户编号
    ,o.guartor_id -- 担保人编号
    ,o.guartor_name -- 担保人名称
    ,o.guartor_type_cd -- 担保人类型代码
    ,o.guartor_cert_type_cd -- 担保人证件类型代码
    ,o.guartor_cert_no -- 担保人证件号码
    ,o.guartor_loan_card_no -- 担保人贷款卡号
    ,o.guartor_fax_num -- 担保人传真号码
    ,o.guartor_tel_num -- 担保人电话号码
    ,o.guartor_addr -- 担保人地址
    ,o.guartor_guar_ability_uplmi -- 担保人保证能力上限
    ,o.curr_cd -- 币种代码
    ,o.guar_amt -- 担保金额
    ,o.guar_tenor -- 担保期限
    ,o.aldy_guar_amt -- 已担保金额
    ,o.aval_bal -- 可用余额
    ,o.cust_risk_actl_pm_rat -- 客户风险实际抵质押率
    ,o.apv_pm_rat -- 审批抵质押率
    ,o.guar_survey -- 担保物概况
    ,o.other_espec_apot -- 其它特别约定
    ,o.guar_opinion -- 担保意见
    ,o.gover_fin_guar_corp_guar_flg -- 政府性融资担保公司保证标志
    ,o.rev_guar_flg -- 反担保标志
    ,o.check_guar_dt -- 核保日期
    ,o.fst_ctfer_name -- 第一核保人名称
    ,o.secd_ctfer_name -- 第二核保人名称
    ,o.crdt_chn_cd -- 授信渠道代码
    ,o.col_id -- 押品编号
    ,o.lmt_id -- 额度编号
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
from ${iml_schema}.agt_lhwd_guar_cont_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_lhwd_guar_cont_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.guar_cont_id = n.guar_cont_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_lhwd_guar_cont_info_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.guar_cont_id = d.guar_cont_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_lhwd_guar_cont_info_h;
--alter table ${iml_schema}.agt_lhwd_guar_cont_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_lhwd_guar_cont_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_lhwd_guar_cont_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_lhwd_guar_cont_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_lhwd_guar_cont_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_lhwd_guar_cont_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_lhwd_guar_cont_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_lhwd_guar_cont_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_lhwd_guar_cont_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_lhwd_guar_cont_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_lhwd_guar_cont_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_lhwd_guar_cont_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_lhwd_guar_cont_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_lhwd_guar_cont_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
