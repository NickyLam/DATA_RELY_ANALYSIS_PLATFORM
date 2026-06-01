/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_guar_cont_info_h_icmsf1
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
alter table ${iml_schema}.agt_guar_cont_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_guar_cont_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_guar_cont_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_guar_cont_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_guar_cont_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_guar_cont_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_guar_cont_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,guar_cont_id -- 担保合同编号
    ,guar_cont_type_cd -- 担保合同类型代码
    ,guar_way_cd -- 担保方式代码
    ,cont_status_cd -- 合同状态代码
    ,cont_sign_dt -- 合同签定日期
    ,cont_effect_dt -- 合同生效日期
    ,cont_exp_dt -- 合同到期日期
    ,cust_id -- 客户编号
    ,guartor_cate_cd -- 担保人类别代码
    ,guartor_id -- 担保人编号
    ,guartor_name -- 担保人名称
    ,guar_curr_cd -- 担保币种代码
    ,guar_tot_amt -- 担保总金额
    ,other_espec_apot_descb -- 其它特别约定描述
    ,guar_opinion_descb -- 担保意见描述
    ,check_guar_dt -- 核保日期
    ,guartor_cert_type_cd -- 担保人证件类型代码
    ,guartor_cert_no -- 担保人证件号码
    ,guartor_loan_card_no -- 担保人贷款卡号
    ,guar_guar_form_cd -- 保证担保形式代码
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,update_org_id -- 更新机构编号
    ,update_teller_id -- 更新柜员编号
    ,modif_dt -- 变更日期
    ,lp_id -- 法人编号
    ,auth_begin_dt -- 授权起始日期
    ,rev_guar_measure_flg -- 反担保措施标志
    ,nat_std_indus_dir_cd -- 国标行业投向代码
    ,corp_size_cd -- 企业规模代码
    ,natnal_econ_dept_type_cd -- 国民经济部门类型代码
    ,rgst_dist_cd -- 注册地行政区划代码
    ,dir_hxb_guar_flg -- 直接向我行担保标志
    ,obg_name -- 权属人名称
    ,obg_cust_id -- 权利人客户编号
    ,gcust_flg -- 代保管标志
    ,resdnt_flg -- 居民标志
    ,rgst_cty_rg_cd -- 注册地国家和地区代码
    ,guartor_net_asset -- 保证人净资产
    ,matn_flg -- 维护标志
    ,lmt_cont_id -- 额度合同编号
    ,ocup_guar_lmt_flg -- 占用担保额度标志
    ,file_dt -- 归档日期
    ,guar_type_cls_cd -- 担保类型分类代码
    ,guar_exp_dt -- 担保到期日期
    ,guar_begin_dt -- 担保起始日期
    ,guar_range_cd -- 担保范围代码
    ,pri_contr_id -- 主合同编号
    ,brwer_name -- 借款人名称
    ,text_cont_id -- 文本合同编号
    ,ts_flg -- 暂存标志
    ,elec_cont_type -- 电子合同类型
    ,main_guar_way_cd -- 主担保方式代码
    ,margin_ratio -- 保证金比例
    ,credt_org_name -- 债权人机构名称
    ,credt_org_id -- 债权人机构编号
    ,guar_mon_tenor -- 担保期限
    ,aldy_guar_amt -- 已担保金额
    ,aval_bal -- 可用余额
    ,auto_que_crdtc_rept_flg -- 自动查询征信报告标志
    ,crdtc_que_auth_id -- 征信查询授权书编号
    ,gover_fin_guar_corp_guar_flg -- 政府性融资担保公司保证标志
    ,rev_guar_flg -- 反担保标志
    ,ctfer_name -- 核保人姓名
    ,cust_risk_actl_pm_rat -- 客户风险实际抵质押率
    ,col_sys_guartor_id -- 押品系统保证人编号
    ,guartor_guar_ability_uplmi -- 保证人保证能力上限
    ,iscopy_guar_flow_num -- 被拷贝的担保流水号
    ,enforc_notz_flg -- 强制执行公证标志
    ,borw_legal_rep_name -- 借款人法定代表名称
    ,brwer_tel -- 借款人电话
    ,brwer_addr -- 借款人地址
    ,reception_ps_post -- 接待人职务
    ,reception_ps_name -- 接待人姓名
    ,owner_type_cd -- 所有人类型代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_guar_cont_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_guar_cont_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_guar_cont_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_guar_cont_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_guar_cont_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_guaranty_contract-1
insert into ${iml_schema}.agt_guar_cont_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,guar_cont_id -- 担保合同编号
    ,guar_cont_type_cd -- 担保合同类型代码
    ,guar_way_cd -- 担保方式代码
    ,cont_status_cd -- 合同状态代码
    ,cont_sign_dt -- 合同签定日期
    ,cont_effect_dt -- 合同生效日期
    ,cont_exp_dt -- 合同到期日期
    ,cust_id -- 客户编号
    ,guartor_cate_cd -- 担保人类别代码
    ,guartor_id -- 担保人编号
    ,guartor_name -- 担保人名称
    ,guar_curr_cd -- 担保币种代码
    ,guar_tot_amt -- 担保总金额
    ,other_espec_apot_descb -- 其它特别约定描述
    ,guar_opinion_descb -- 担保意见描述
    ,check_guar_dt -- 核保日期
    ,guartor_cert_type_cd -- 担保人证件类型代码
    ,guartor_cert_no -- 担保人证件号码
    ,guartor_loan_card_no -- 担保人贷款卡号
    ,guar_guar_form_cd -- 保证担保形式代码
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,update_org_id -- 更新机构编号
    ,update_teller_id -- 更新柜员编号
    ,modif_dt -- 变更日期
    ,lp_id -- 法人编号
    ,auth_begin_dt -- 授权起始日期
    ,rev_guar_measure_flg -- 反担保措施标志
    ,nat_std_indus_dir_cd -- 国标行业投向代码
    ,corp_size_cd -- 企业规模代码
    ,natnal_econ_dept_type_cd -- 国民经济部门类型代码
    ,rgst_dist_cd -- 注册地行政区划代码
    ,dir_hxb_guar_flg -- 直接向我行担保标志
    ,obg_name -- 权属人名称
    ,obg_cust_id -- 权利人客户编号
    ,gcust_flg -- 代保管标志
    ,resdnt_flg -- 居民标志
    ,rgst_cty_rg_cd -- 注册地国家和地区代码
    ,guartor_net_asset -- 保证人净资产
    ,matn_flg -- 维护标志
    ,lmt_cont_id -- 额度合同编号
    ,ocup_guar_lmt_flg -- 占用担保额度标志
    ,file_dt -- 归档日期
    ,guar_type_cls_cd -- 担保类型分类代码
    ,guar_exp_dt -- 担保到期日期
    ,guar_begin_dt -- 担保起始日期
    ,guar_range_cd -- 担保范围代码
    ,pri_contr_id -- 主合同编号
    ,brwer_name -- 借款人名称
    ,text_cont_id -- 文本合同编号
    ,ts_flg -- 暂存标志
    ,elec_cont_type -- 电子合同类型
    ,main_guar_way_cd -- 主担保方式代码
    ,margin_ratio -- 保证金比例
    ,credt_org_name -- 债权人机构名称
    ,credt_org_id -- 债权人机构编号
    ,guar_mon_tenor -- 担保期限
    ,aldy_guar_amt -- 已担保金额
    ,aval_bal -- 可用余额
    ,auto_que_crdtc_rept_flg -- 自动查询征信报告标志
    ,crdtc_que_auth_id -- 征信查询授权书编号
    ,gover_fin_guar_corp_guar_flg -- 政府性融资担保公司保证标志
    ,rev_guar_flg -- 反担保标志
    ,ctfer_name -- 核保人姓名
    ,cust_risk_actl_pm_rat -- 客户风险实际抵质押率
    ,col_sys_guartor_id -- 押品系统保证人编号
    ,guartor_guar_ability_uplmi -- 保证人保证能力上限
    ,iscopy_guar_flow_num -- 被拷贝的担保流水号
    ,enforc_notz_flg -- 强制执行公证标志
    ,borw_legal_rep_name -- 借款人法定代表名称
    ,brwer_tel -- 借款人电话
    ,brwer_addr -- 借款人地址
    ,reception_ps_post -- 接待人职务
    ,reception_ps_name -- 接待人姓名
    ,owner_type_cd -- 所有人类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300008'||P1.GUARANTYNO -- 协议编号
    ,P1.GUARANTYNO -- 担保合同编号
    ,P1.GUARANTYTYPE -- 担保合同类型代码
    ,nvl(trim(P1.GUARANTYSTYLE),'-') -- 担保方式代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'|| P1.GUARANTYSTATUS END -- 合同状态代码
    ,${iml_schema}.dateformat_max2(P1.SIGNDATE) -- 合同签定日期
    ,${iml_schema}.dateformat_max2(P1.BEGINDATE) -- 合同生效日期
    ,${iml_schema}.dateformat_max2(P1.ENDDATE) -- 合同到期日期
    ,P1.CUSTOMERID -- 客户编号
    ,nvl(trim(P1.GUARTORCATE),'-') -- 担保人类别代码
    ,P1.GUARANTORID -- 担保人编号
    ,P1.GUARANTORNAME -- 担保人名称
    ,nvl(trim(P1.GUARANTYCURRENCY),'-') -- 担保币种代码
    ,P1.GUARANTYVALUE -- 担保总金额
    ,P1.OTHERDESCSRIBE -- 其它特别约定描述
    ,P1.GUARANTYOPINION -- 担保意见描述
    ,${iml_schema}.dateformat_max2(P1.CHECKGUARANTYDATE) -- 核保日期
    ,nvl(trim(P1.CERTTYPE),'0000') -- 担保人证件类型代码
    ,P1.CERTID -- 担保人证件号码
    ,P1.LOANCARDNO -- 担保人贷款卡号
    ,nvl(trim(P1.GUARANTEEFORM),'-') -- 保证担保形式代码
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEDATE -- 变更日期
    ,'9999' -- 法人编号
    ,${iml_schema}.dateformat_max2(P1.AUTHOSTRDATE) -- 授权起始日期
    ,P1.ISTRANGUARANTY -- 反担保措施标志
    ,nvl(trim(P1.INDUSTRYTYPE),'-') -- 国标行业投向代码
    ,nvl(trim(P1.ENTERPRISESCOPE),'0') -- 企业规模代码
    ,nvl(trim(P1.ECODEPARTMENTCODE),'000') -- 国民经济部门类型代码
    ,nvl(trim(P1.NEWREGIONCODE),'000000') -- 注册地行政区划代码
    ,P1.ISSAVEOWNER -- 直接向我行担保标志
    ,P1.OBLIGEENAME -- 权属人名称
    ,P1.OBLIGEEID -- 权利人客户编号
    ,P1.ISCUSTODY -- 代保管标志
    ,nvl(trim(P1.RESIDENTFLAG),'-') -- 居民标志
    ,NVL(TRIM(P1.REGISTATIONCODE),'XXX') -- 注册地国家和地区代码
    ,P1.GUARANTYORSUM -- 保证人净资产
    ,nvl(trim(P1.ISINUSE),'-') -- 维护标志
    ,P1.CREDITAGGREEMENT -- 额度合同编号
    ,nvl(trim(P1.QUOTEGUARANTYQUOTA),'-') -- 占用担保额度标志
    ,${iml_schema}.dateformat_max2(P1.PIGEONHOLEDATE) -- 归档日期
    ,nvl(trim(P1.GUARANTYTYPE2),'-') -- 担保类型分类代码
    ,${iml_schema}.dateformat_max2(P1.ENDTIME) -- 担保到期日期
    ,${iml_schema}.dateformat_max2(P1.BEGINTIME) -- 担保起始日期
    ,P1.GUARANTYRANGE -- 担保范围代码
    ,P1.TEXTMAINCONTRACTNO -- 主合同编号
    ,P1.PARTYBNAME -- 借款人名称
    ,P1.TEXTCONTRACTNO -- 文本合同编号
    ,nvl(trim(P1.ECTEMPSAVEFLAG),'-') -- 暂存标志
    ,P1.ECONTRACTTYPE -- 电子合同类型
    ,nvl(trim(P1.VOUCHTYPE),'-') -- 主担保方式代码
    ,P1.BAILRATIO -- 保证金比例
    ,P1.CREDITORGNAME -- 债权人机构名称
    ,P1.CREDITORGID -- 债权人机构编号
    ,P1.GUARTERM -- 担保期限
    ,P1.USESUM -- 已担保金额
    ,P1.GUARBALANCE -- 可用余额
    ,P1.ISQUERYCREDITREPORT -- 自动查询征信报告标志
    ,P1.CREDITAUTHNO -- 征信查询授权书编号
    ,nvl(trim(p1.isguarantyplatformloan),'-') -- 政府性融资担保公司保证标志
    ,nvl(trim(p1.ISBACKGUARANTY),'-') -- 反担保标志
    ,P1.CHECKGUARANTYMANA -- 核保人姓名
    ,P1.CUSTOMERRISKACTUALRATE -- 客户风险实际抵质押率
    ,P1.YPGUARANTORID -- 押品系统保证人编号
    ,P1.MAXIMUMGUARABILITY -- 保证人保证能力上限
    ,P1.PRESERIALNO -- 被拷贝的担保流水号
    ,nvl(trim(P1.NOTARIZATIONFLAG),'-') -- 强制执行公证标志
    ,P1.PARTYBLEGALPERSON -- 借款人法定代表名称
    ,P1.PARTYBPHONE -- 借款人电话
    ,P1.PARTYBADDRESS -- 借款人地址
    ,P1.RECEPTIONDUTY -- 接待人职务
    ,P1.RECEPTION -- 接待人姓名
    ,nvl(trim(P1.CUSTOMEROWNERSHIP),'00') -- 所有人类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_guaranty_contract' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_guaranty_contract p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.GUARANTYSTATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_GUARANTY_CONTRACT'
        AND R1.SRC_FIELD_EN_NAME= 'GUARANTYSTATUS'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_GUAR_CONT_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CONT_STATUS_CD' 
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_guar_cont_info_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
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
        into ${iml_schema}.agt_guar_cont_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,guar_cont_id -- 担保合同编号
    ,guar_cont_type_cd -- 担保合同类型代码
    ,guar_way_cd -- 担保方式代码
    ,cont_status_cd -- 合同状态代码
    ,cont_sign_dt -- 合同签定日期
    ,cont_effect_dt -- 合同生效日期
    ,cont_exp_dt -- 合同到期日期
    ,cust_id -- 客户编号
    ,guartor_cate_cd -- 担保人类别代码
    ,guartor_id -- 担保人编号
    ,guartor_name -- 担保人名称
    ,guar_curr_cd -- 担保币种代码
    ,guar_tot_amt -- 担保总金额
    ,other_espec_apot_descb -- 其它特别约定描述
    ,guar_opinion_descb -- 担保意见描述
    ,check_guar_dt -- 核保日期
    ,guartor_cert_type_cd -- 担保人证件类型代码
    ,guartor_cert_no -- 担保人证件号码
    ,guartor_loan_card_no -- 担保人贷款卡号
    ,guar_guar_form_cd -- 保证担保形式代码
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,update_org_id -- 更新机构编号
    ,update_teller_id -- 更新柜员编号
    ,modif_dt -- 变更日期
    ,lp_id -- 法人编号
    ,auth_begin_dt -- 授权起始日期
    ,rev_guar_measure_flg -- 反担保措施标志
    ,nat_std_indus_dir_cd -- 国标行业投向代码
    ,corp_size_cd -- 企业规模代码
    ,natnal_econ_dept_type_cd -- 国民经济部门类型代码
    ,rgst_dist_cd -- 注册地行政区划代码
    ,dir_hxb_guar_flg -- 直接向我行担保标志
    ,obg_name -- 权属人名称
    ,obg_cust_id -- 权利人客户编号
    ,gcust_flg -- 代保管标志
    ,resdnt_flg -- 居民标志
    ,rgst_cty_rg_cd -- 注册地国家和地区代码
    ,guartor_net_asset -- 保证人净资产
    ,matn_flg -- 维护标志
    ,lmt_cont_id -- 额度合同编号
    ,ocup_guar_lmt_flg -- 占用担保额度标志
    ,file_dt -- 归档日期
    ,guar_type_cls_cd -- 担保类型分类代码
    ,guar_exp_dt -- 担保到期日期
    ,guar_begin_dt -- 担保起始日期
    ,guar_range_cd -- 担保范围代码
    ,pri_contr_id -- 主合同编号
    ,brwer_name -- 借款人名称
    ,text_cont_id -- 文本合同编号
    ,ts_flg -- 暂存标志
    ,elec_cont_type -- 电子合同类型
    ,main_guar_way_cd -- 主担保方式代码
    ,margin_ratio -- 保证金比例
    ,credt_org_name -- 债权人机构名称
    ,credt_org_id -- 债权人机构编号
    ,guar_mon_tenor -- 担保期限
    ,aldy_guar_amt -- 已担保金额
    ,aval_bal -- 可用余额
    ,auto_que_crdtc_rept_flg -- 自动查询征信报告标志
    ,crdtc_que_auth_id -- 征信查询授权书编号
    ,gover_fin_guar_corp_guar_flg -- 政府性融资担保公司保证标志
    ,rev_guar_flg -- 反担保标志
    ,ctfer_name -- 核保人姓名
    ,cust_risk_actl_pm_rat -- 客户风险实际抵质押率
    ,col_sys_guartor_id -- 押品系统保证人编号
    ,guartor_guar_ability_uplmi -- 保证人保证能力上限
    ,iscopy_guar_flow_num -- 被拷贝的担保流水号
    ,enforc_notz_flg -- 强制执行公证标志
    ,borw_legal_rep_name -- 借款人法定代表名称
    ,brwer_tel -- 借款人电话
    ,brwer_addr -- 借款人地址
    ,reception_ps_post -- 接待人职务
    ,reception_ps_name -- 接待人姓名
    ,owner_type_cd -- 所有人类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_guar_cont_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,guar_cont_id -- 担保合同编号
    ,guar_cont_type_cd -- 担保合同类型代码
    ,guar_way_cd -- 担保方式代码
    ,cont_status_cd -- 合同状态代码
    ,cont_sign_dt -- 合同签定日期
    ,cont_effect_dt -- 合同生效日期
    ,cont_exp_dt -- 合同到期日期
    ,cust_id -- 客户编号
    ,guartor_cate_cd -- 担保人类别代码
    ,guartor_id -- 担保人编号
    ,guartor_name -- 担保人名称
    ,guar_curr_cd -- 担保币种代码
    ,guar_tot_amt -- 担保总金额
    ,other_espec_apot_descb -- 其它特别约定描述
    ,guar_opinion_descb -- 担保意见描述
    ,check_guar_dt -- 核保日期
    ,guartor_cert_type_cd -- 担保人证件类型代码
    ,guartor_cert_no -- 担保人证件号码
    ,guartor_loan_card_no -- 担保人贷款卡号
    ,guar_guar_form_cd -- 保证担保形式代码
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,update_org_id -- 更新机构编号
    ,update_teller_id -- 更新柜员编号
    ,modif_dt -- 变更日期
    ,lp_id -- 法人编号
    ,auth_begin_dt -- 授权起始日期
    ,rev_guar_measure_flg -- 反担保措施标志
    ,nat_std_indus_dir_cd -- 国标行业投向代码
    ,corp_size_cd -- 企业规模代码
    ,natnal_econ_dept_type_cd -- 国民经济部门类型代码
    ,rgst_dist_cd -- 注册地行政区划代码
    ,dir_hxb_guar_flg -- 直接向我行担保标志
    ,obg_name -- 权属人名称
    ,obg_cust_id -- 权利人客户编号
    ,gcust_flg -- 代保管标志
    ,resdnt_flg -- 居民标志
    ,rgst_cty_rg_cd -- 注册地国家和地区代码
    ,guartor_net_asset -- 保证人净资产
    ,matn_flg -- 维护标志
    ,lmt_cont_id -- 额度合同编号
    ,ocup_guar_lmt_flg -- 占用担保额度标志
    ,file_dt -- 归档日期
    ,guar_type_cls_cd -- 担保类型分类代码
    ,guar_exp_dt -- 担保到期日期
    ,guar_begin_dt -- 担保起始日期
    ,guar_range_cd -- 担保范围代码
    ,pri_contr_id -- 主合同编号
    ,brwer_name -- 借款人名称
    ,text_cont_id -- 文本合同编号
    ,ts_flg -- 暂存标志
    ,elec_cont_type -- 电子合同类型
    ,main_guar_way_cd -- 主担保方式代码
    ,margin_ratio -- 保证金比例
    ,credt_org_name -- 债权人机构名称
    ,credt_org_id -- 债权人机构编号
    ,guar_mon_tenor -- 担保期限
    ,aldy_guar_amt -- 已担保金额
    ,aval_bal -- 可用余额
    ,auto_que_crdtc_rept_flg -- 自动查询征信报告标志
    ,crdtc_que_auth_id -- 征信查询授权书编号
    ,gover_fin_guar_corp_guar_flg -- 政府性融资担保公司保证标志
    ,rev_guar_flg -- 反担保标志
    ,ctfer_name -- 核保人姓名
    ,cust_risk_actl_pm_rat -- 客户风险实际抵质押率
    ,col_sys_guartor_id -- 押品系统保证人编号
    ,guartor_guar_ability_uplmi -- 保证人保证能力上限
    ,iscopy_guar_flow_num -- 被拷贝的担保流水号
    ,enforc_notz_flg -- 强制执行公证标志
    ,borw_legal_rep_name -- 借款人法定代表名称
    ,brwer_tel -- 借款人电话
    ,brwer_addr -- 借款人地址
    ,reception_ps_post -- 接待人职务
    ,reception_ps_name -- 接待人姓名
    ,owner_type_cd -- 所有人类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.guar_cont_id, o.guar_cont_id) as guar_cont_id -- 担保合同编号
    ,nvl(n.guar_cont_type_cd, o.guar_cont_type_cd) as guar_cont_type_cd -- 担保合同类型代码
    ,nvl(n.guar_way_cd, o.guar_way_cd) as guar_way_cd -- 担保方式代码
    ,nvl(n.cont_status_cd, o.cont_status_cd) as cont_status_cd -- 合同状态代码
    ,nvl(n.cont_sign_dt, o.cont_sign_dt) as cont_sign_dt -- 合同签定日期
    ,nvl(n.cont_effect_dt, o.cont_effect_dt) as cont_effect_dt -- 合同生效日期
    ,nvl(n.cont_exp_dt, o.cont_exp_dt) as cont_exp_dt -- 合同到期日期
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.guartor_cate_cd, o.guartor_cate_cd) as guartor_cate_cd -- 担保人类别代码
    ,nvl(n.guartor_id, o.guartor_id) as guartor_id -- 担保人编号
    ,nvl(n.guartor_name, o.guartor_name) as guartor_name -- 担保人名称
    ,nvl(n.guar_curr_cd, o.guar_curr_cd) as guar_curr_cd -- 担保币种代码
    ,nvl(n.guar_tot_amt, o.guar_tot_amt) as guar_tot_amt -- 担保总金额
    ,nvl(n.other_espec_apot_descb, o.other_espec_apot_descb) as other_espec_apot_descb -- 其它特别约定描述
    ,nvl(n.guar_opinion_descb, o.guar_opinion_descb) as guar_opinion_descb -- 担保意见描述
    ,nvl(n.check_guar_dt, o.check_guar_dt) as check_guar_dt -- 核保日期
    ,nvl(n.guartor_cert_type_cd, o.guartor_cert_type_cd) as guartor_cert_type_cd -- 担保人证件类型代码
    ,nvl(n.guartor_cert_no, o.guartor_cert_no) as guartor_cert_no -- 担保人证件号码
    ,nvl(n.guartor_loan_card_no, o.guartor_loan_card_no) as guartor_loan_card_no -- 担保人贷款卡号
    ,nvl(n.guar_guar_form_cd, o.guar_guar_form_cd) as guar_guar_form_cd -- 保证担保形式代码
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.modif_dt, o.modif_dt) as modif_dt -- 变更日期
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.auth_begin_dt, o.auth_begin_dt) as auth_begin_dt -- 授权起始日期
    ,nvl(n.rev_guar_measure_flg, o.rev_guar_measure_flg) as rev_guar_measure_flg -- 反担保措施标志
    ,nvl(n.nat_std_indus_dir_cd, o.nat_std_indus_dir_cd) as nat_std_indus_dir_cd -- 国标行业投向代码
    ,nvl(n.corp_size_cd, o.corp_size_cd) as corp_size_cd -- 企业规模代码
    ,nvl(n.natnal_econ_dept_type_cd, o.natnal_econ_dept_type_cd) as natnal_econ_dept_type_cd -- 国民经济部门类型代码
    ,nvl(n.rgst_dist_cd, o.rgst_dist_cd) as rgst_dist_cd -- 注册地行政区划代码
    ,nvl(n.dir_hxb_guar_flg, o.dir_hxb_guar_flg) as dir_hxb_guar_flg -- 直接向我行担保标志
    ,nvl(n.obg_name, o.obg_name) as obg_name -- 权属人名称
    ,nvl(n.obg_cust_id, o.obg_cust_id) as obg_cust_id -- 权利人客户编号
    ,nvl(n.gcust_flg, o.gcust_flg) as gcust_flg -- 代保管标志
    ,nvl(n.resdnt_flg, o.resdnt_flg) as resdnt_flg -- 居民标志
    ,nvl(n.rgst_cty_rg_cd, o.rgst_cty_rg_cd) as rgst_cty_rg_cd -- 注册地国家和地区代码
    ,nvl(n.guartor_net_asset, o.guartor_net_asset) as guartor_net_asset -- 保证人净资产
    ,nvl(n.matn_flg, o.matn_flg) as matn_flg -- 维护标志
    ,nvl(n.lmt_cont_id, o.lmt_cont_id) as lmt_cont_id -- 额度合同编号
    ,nvl(n.ocup_guar_lmt_flg, o.ocup_guar_lmt_flg) as ocup_guar_lmt_flg -- 占用担保额度标志
    ,nvl(n.file_dt, o.file_dt) as file_dt -- 归档日期
    ,nvl(n.guar_type_cls_cd, o.guar_type_cls_cd) as guar_type_cls_cd -- 担保类型分类代码
    ,nvl(n.guar_exp_dt, o.guar_exp_dt) as guar_exp_dt -- 担保到期日期
    ,nvl(n.guar_begin_dt, o.guar_begin_dt) as guar_begin_dt -- 担保起始日期
    ,nvl(n.guar_range_cd, o.guar_range_cd) as guar_range_cd -- 担保范围代码
    ,nvl(n.pri_contr_id, o.pri_contr_id) as pri_contr_id -- 主合同编号
    ,nvl(n.brwer_name, o.brwer_name) as brwer_name -- 借款人名称
    ,nvl(n.text_cont_id, o.text_cont_id) as text_cont_id -- 文本合同编号
    ,nvl(n.ts_flg, o.ts_flg) as ts_flg -- 暂存标志
    ,nvl(n.elec_cont_type, o.elec_cont_type) as elec_cont_type -- 电子合同类型
    ,nvl(n.main_guar_way_cd, o.main_guar_way_cd) as main_guar_way_cd -- 主担保方式代码
    ,nvl(n.margin_ratio, o.margin_ratio) as margin_ratio -- 保证金比例
    ,nvl(n.credt_org_name, o.credt_org_name) as credt_org_name -- 债权人机构名称
    ,nvl(n.credt_org_id, o.credt_org_id) as credt_org_id -- 债权人机构编号
    ,nvl(n.guar_mon_tenor, o.guar_mon_tenor) as guar_mon_tenor -- 担保期限
    ,nvl(n.aldy_guar_amt, o.aldy_guar_amt) as aldy_guar_amt -- 已担保金额
    ,nvl(n.aval_bal, o.aval_bal) as aval_bal -- 可用余额
    ,nvl(n.auto_que_crdtc_rept_flg, o.auto_que_crdtc_rept_flg) as auto_que_crdtc_rept_flg -- 自动查询征信报告标志
    ,nvl(n.crdtc_que_auth_id, o.crdtc_que_auth_id) as crdtc_que_auth_id -- 征信查询授权书编号
    ,nvl(n.gover_fin_guar_corp_guar_flg, o.gover_fin_guar_corp_guar_flg) as gover_fin_guar_corp_guar_flg -- 政府性融资担保公司保证标志
    ,nvl(n.rev_guar_flg, o.rev_guar_flg) as rev_guar_flg -- 反担保标志
    ,nvl(n.ctfer_name, o.ctfer_name) as ctfer_name -- 核保人姓名
    ,nvl(n.cust_risk_actl_pm_rat, o.cust_risk_actl_pm_rat) as cust_risk_actl_pm_rat -- 客户风险实际抵质押率
    ,nvl(n.col_sys_guartor_id, o.col_sys_guartor_id) as col_sys_guartor_id -- 押品系统保证人编号
    ,nvl(n.guartor_guar_ability_uplmi, o.guartor_guar_ability_uplmi) as guartor_guar_ability_uplmi -- 保证人保证能力上限
    ,nvl(n.iscopy_guar_flow_num, o.iscopy_guar_flow_num) as iscopy_guar_flow_num -- 被拷贝的担保流水号
    ,nvl(n.enforc_notz_flg, o.enforc_notz_flg) as enforc_notz_flg -- 强制执行公证标志
    ,nvl(n.borw_legal_rep_name, o.borw_legal_rep_name) as borw_legal_rep_name -- 借款人法定代表名称
    ,nvl(n.brwer_tel, o.brwer_tel) as brwer_tel -- 借款人电话
    ,nvl(n.brwer_addr, o.brwer_addr) as brwer_addr -- 借款人地址
    ,nvl(n.reception_ps_post, o.reception_ps_post) as reception_ps_post -- 接待人职务
    ,nvl(n.reception_ps_name, o.reception_ps_name) as reception_ps_name -- 接待人姓名
    ,nvl(n.owner_type_cd, o.owner_type_cd) as owner_type_cd -- 所有人类型代码
    ,case when
            n.agt_id is null
            and n.guar_cont_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.guar_cont_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.guar_cont_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_guar_cont_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_guar_cont_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.guar_cont_id = n.guar_cont_id
where (
        o.agt_id is null
        and o.guar_cont_id is null
    )
    or (
        n.agt_id is null
        and n.guar_cont_id is null
    )
    or (
        o.guar_cont_type_cd <> n.guar_cont_type_cd
        or o.guar_way_cd <> n.guar_way_cd
        or o.cont_status_cd <> n.cont_status_cd
        or o.cont_sign_dt <> n.cont_sign_dt
        or o.cont_effect_dt <> n.cont_effect_dt
        or o.cont_exp_dt <> n.cont_exp_dt
        or o.cust_id <> n.cust_id
        or o.guartor_cate_cd <> n.guartor_cate_cd
        or o.guartor_id <> n.guartor_id
        or o.guartor_name <> n.guartor_name
        or o.guar_curr_cd <> n.guar_curr_cd
        or o.guar_tot_amt <> n.guar_tot_amt
        or o.other_espec_apot_descb <> n.other_espec_apot_descb
        or o.guar_opinion_descb <> n.guar_opinion_descb
        or o.check_guar_dt <> n.check_guar_dt
        or o.guartor_cert_type_cd <> n.guartor_cert_type_cd
        or o.guartor_cert_no <> n.guartor_cert_no
        or o.guartor_loan_card_no <> n.guartor_loan_card_no
        or o.guar_guar_form_cd <> n.guar_guar_form_cd
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_dt <> n.rgst_dt
        or o.update_org_id <> n.update_org_id
        or o.update_teller_id <> n.update_teller_id
        or o.modif_dt <> n.modif_dt
        or o.lp_id <> n.lp_id
        or o.auth_begin_dt <> n.auth_begin_dt
        or o.rev_guar_measure_flg <> n.rev_guar_measure_flg
        or o.nat_std_indus_dir_cd <> n.nat_std_indus_dir_cd
        or o.corp_size_cd <> n.corp_size_cd
        or o.natnal_econ_dept_type_cd <> n.natnal_econ_dept_type_cd
        or o.rgst_dist_cd <> n.rgst_dist_cd
        or o.dir_hxb_guar_flg <> n.dir_hxb_guar_flg
        or o.obg_name <> n.obg_name
        or o.obg_cust_id <> n.obg_cust_id
        or o.gcust_flg <> n.gcust_flg
        or o.resdnt_flg <> n.resdnt_flg
        or o.rgst_cty_rg_cd <> n.rgst_cty_rg_cd
        or o.guartor_net_asset <> n.guartor_net_asset
        or o.matn_flg <> n.matn_flg
        or o.lmt_cont_id <> n.lmt_cont_id
        or o.ocup_guar_lmt_flg <> n.ocup_guar_lmt_flg
        or o.file_dt <> n.file_dt
        or o.guar_type_cls_cd <> n.guar_type_cls_cd
        or o.guar_exp_dt <> n.guar_exp_dt
        or o.guar_begin_dt <> n.guar_begin_dt
        or o.guar_range_cd <> n.guar_range_cd
        or o.pri_contr_id <> n.pri_contr_id
        or o.brwer_name <> n.brwer_name
        or o.text_cont_id <> n.text_cont_id
        or o.ts_flg <> n.ts_flg
        or o.elec_cont_type <> n.elec_cont_type
        or o.main_guar_way_cd <> n.main_guar_way_cd
        or o.margin_ratio <> n.margin_ratio
        or o.credt_org_name <> n.credt_org_name
        or o.credt_org_id <> n.credt_org_id
        or o.guar_mon_tenor <> n.guar_mon_tenor
        or o.aldy_guar_amt <> n.aldy_guar_amt
        or o.aval_bal <> n.aval_bal
        or o.auto_que_crdtc_rept_flg <> n.auto_que_crdtc_rept_flg
        or o.crdtc_que_auth_id <> n.crdtc_que_auth_id
        or o.gover_fin_guar_corp_guar_flg <> n.gover_fin_guar_corp_guar_flg
        or o.rev_guar_flg <> n.rev_guar_flg
        or o.ctfer_name <> n.ctfer_name
        or o.cust_risk_actl_pm_rat <> n.cust_risk_actl_pm_rat
        or o.col_sys_guartor_id <> n.col_sys_guartor_id
        or o.guartor_guar_ability_uplmi <> n.guartor_guar_ability_uplmi
        or o.iscopy_guar_flow_num <> n.iscopy_guar_flow_num
        or o.enforc_notz_flg <> n.enforc_notz_flg
        or o.borw_legal_rep_name <> n.borw_legal_rep_name
        or o.brwer_tel <> n.brwer_tel
        or o.brwer_addr <> n.brwer_addr
        or o.reception_ps_post <> n.reception_ps_post
        or o.reception_ps_name <> n.reception_ps_name
        or o.owner_type_cd <> n.owner_type_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_guar_cont_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,guar_cont_id -- 担保合同编号
    ,guar_cont_type_cd -- 担保合同类型代码
    ,guar_way_cd -- 担保方式代码
    ,cont_status_cd -- 合同状态代码
    ,cont_sign_dt -- 合同签定日期
    ,cont_effect_dt -- 合同生效日期
    ,cont_exp_dt -- 合同到期日期
    ,cust_id -- 客户编号
    ,guartor_cate_cd -- 担保人类别代码
    ,guartor_id -- 担保人编号
    ,guartor_name -- 担保人名称
    ,guar_curr_cd -- 担保币种代码
    ,guar_tot_amt -- 担保总金额
    ,other_espec_apot_descb -- 其它特别约定描述
    ,guar_opinion_descb -- 担保意见描述
    ,check_guar_dt -- 核保日期
    ,guartor_cert_type_cd -- 担保人证件类型代码
    ,guartor_cert_no -- 担保人证件号码
    ,guartor_loan_card_no -- 担保人贷款卡号
    ,guar_guar_form_cd -- 保证担保形式代码
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,update_org_id -- 更新机构编号
    ,update_teller_id -- 更新柜员编号
    ,modif_dt -- 变更日期
    ,lp_id -- 法人编号
    ,auth_begin_dt -- 授权起始日期
    ,rev_guar_measure_flg -- 反担保措施标志
    ,nat_std_indus_dir_cd -- 国标行业投向代码
    ,corp_size_cd -- 企业规模代码
    ,natnal_econ_dept_type_cd -- 国民经济部门类型代码
    ,rgst_dist_cd -- 注册地行政区划代码
    ,dir_hxb_guar_flg -- 直接向我行担保标志
    ,obg_name -- 权属人名称
    ,obg_cust_id -- 权利人客户编号
    ,gcust_flg -- 代保管标志
    ,resdnt_flg -- 居民标志
    ,rgst_cty_rg_cd -- 注册地国家和地区代码
    ,guartor_net_asset -- 保证人净资产
    ,matn_flg -- 维护标志
    ,lmt_cont_id -- 额度合同编号
    ,ocup_guar_lmt_flg -- 占用担保额度标志
    ,file_dt -- 归档日期
    ,guar_type_cls_cd -- 担保类型分类代码
    ,guar_exp_dt -- 担保到期日期
    ,guar_begin_dt -- 担保起始日期
    ,guar_range_cd -- 担保范围代码
    ,pri_contr_id -- 主合同编号
    ,brwer_name -- 借款人名称
    ,text_cont_id -- 文本合同编号
    ,ts_flg -- 暂存标志
    ,elec_cont_type -- 电子合同类型
    ,main_guar_way_cd -- 主担保方式代码
    ,margin_ratio -- 保证金比例
    ,credt_org_name -- 债权人机构名称
    ,credt_org_id -- 债权人机构编号
    ,guar_mon_tenor -- 担保期限
    ,aldy_guar_amt -- 已担保金额
    ,aval_bal -- 可用余额
    ,auto_que_crdtc_rept_flg -- 自动查询征信报告标志
    ,crdtc_que_auth_id -- 征信查询授权书编号
    ,gover_fin_guar_corp_guar_flg -- 政府性融资担保公司保证标志
    ,rev_guar_flg -- 反担保标志
    ,ctfer_name -- 核保人姓名
    ,cust_risk_actl_pm_rat -- 客户风险实际抵质押率
    ,col_sys_guartor_id -- 押品系统保证人编号
    ,guartor_guar_ability_uplmi -- 保证人保证能力上限
    ,iscopy_guar_flow_num -- 被拷贝的担保流水号
    ,enforc_notz_flg -- 强制执行公证标志
    ,borw_legal_rep_name -- 借款人法定代表名称
    ,brwer_tel -- 借款人电话
    ,brwer_addr -- 借款人地址
    ,reception_ps_post -- 接待人职务
    ,reception_ps_name -- 接待人姓名
    ,owner_type_cd -- 所有人类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_guar_cont_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,guar_cont_id -- 担保合同编号
    ,guar_cont_type_cd -- 担保合同类型代码
    ,guar_way_cd -- 担保方式代码
    ,cont_status_cd -- 合同状态代码
    ,cont_sign_dt -- 合同签定日期
    ,cont_effect_dt -- 合同生效日期
    ,cont_exp_dt -- 合同到期日期
    ,cust_id -- 客户编号
    ,guartor_cate_cd -- 担保人类别代码
    ,guartor_id -- 担保人编号
    ,guartor_name -- 担保人名称
    ,guar_curr_cd -- 担保币种代码
    ,guar_tot_amt -- 担保总金额
    ,other_espec_apot_descb -- 其它特别约定描述
    ,guar_opinion_descb -- 担保意见描述
    ,check_guar_dt -- 核保日期
    ,guartor_cert_type_cd -- 担保人证件类型代码
    ,guartor_cert_no -- 担保人证件号码
    ,guartor_loan_card_no -- 担保人贷款卡号
    ,guar_guar_form_cd -- 保证担保形式代码
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,update_org_id -- 更新机构编号
    ,update_teller_id -- 更新柜员编号
    ,modif_dt -- 变更日期
    ,lp_id -- 法人编号
    ,auth_begin_dt -- 授权起始日期
    ,rev_guar_measure_flg -- 反担保措施标志
    ,nat_std_indus_dir_cd -- 国标行业投向代码
    ,corp_size_cd -- 企业规模代码
    ,natnal_econ_dept_type_cd -- 国民经济部门类型代码
    ,rgst_dist_cd -- 注册地行政区划代码
    ,dir_hxb_guar_flg -- 直接向我行担保标志
    ,obg_name -- 权属人名称
    ,obg_cust_id -- 权利人客户编号
    ,gcust_flg -- 代保管标志
    ,resdnt_flg -- 居民标志
    ,rgst_cty_rg_cd -- 注册地国家和地区代码
    ,guartor_net_asset -- 保证人净资产
    ,matn_flg -- 维护标志
    ,lmt_cont_id -- 额度合同编号
    ,ocup_guar_lmt_flg -- 占用担保额度标志
    ,file_dt -- 归档日期
    ,guar_type_cls_cd -- 担保类型分类代码
    ,guar_exp_dt -- 担保到期日期
    ,guar_begin_dt -- 担保起始日期
    ,guar_range_cd -- 担保范围代码
    ,pri_contr_id -- 主合同编号
    ,brwer_name -- 借款人名称
    ,text_cont_id -- 文本合同编号
    ,ts_flg -- 暂存标志
    ,elec_cont_type -- 电子合同类型
    ,main_guar_way_cd -- 主担保方式代码
    ,margin_ratio -- 保证金比例
    ,credt_org_name -- 债权人机构名称
    ,credt_org_id -- 债权人机构编号
    ,guar_mon_tenor -- 担保期限
    ,aldy_guar_amt -- 已担保金额
    ,aval_bal -- 可用余额
    ,auto_que_crdtc_rept_flg -- 自动查询征信报告标志
    ,crdtc_que_auth_id -- 征信查询授权书编号
    ,gover_fin_guar_corp_guar_flg -- 政府性融资担保公司保证标志
    ,rev_guar_flg -- 反担保标志
    ,ctfer_name -- 核保人姓名
    ,cust_risk_actl_pm_rat -- 客户风险实际抵质押率
    ,col_sys_guartor_id -- 押品系统保证人编号
    ,guartor_guar_ability_uplmi -- 保证人保证能力上限
    ,iscopy_guar_flow_num -- 被拷贝的担保流水号
    ,enforc_notz_flg -- 强制执行公证标志
    ,borw_legal_rep_name -- 借款人法定代表名称
    ,brwer_tel -- 借款人电话
    ,brwer_addr -- 借款人地址
    ,reception_ps_post -- 接待人职务
    ,reception_ps_name -- 接待人姓名
    ,owner_type_cd -- 所有人类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.guar_cont_id -- 担保合同编号
    ,o.guar_cont_type_cd -- 担保合同类型代码
    ,o.guar_way_cd -- 担保方式代码
    ,o.cont_status_cd -- 合同状态代码
    ,o.cont_sign_dt -- 合同签定日期
    ,o.cont_effect_dt -- 合同生效日期
    ,o.cont_exp_dt -- 合同到期日期
    ,o.cust_id -- 客户编号
    ,o.guartor_cate_cd -- 担保人类别代码
    ,o.guartor_id -- 担保人编号
    ,o.guartor_name -- 担保人名称
    ,o.guar_curr_cd -- 担保币种代码
    ,o.guar_tot_amt -- 担保总金额
    ,o.other_espec_apot_descb -- 其它特别约定描述
    ,o.guar_opinion_descb -- 担保意见描述
    ,o.check_guar_dt -- 核保日期
    ,o.guartor_cert_type_cd -- 担保人证件类型代码
    ,o.guartor_cert_no -- 担保人证件号码
    ,o.guartor_loan_card_no -- 担保人贷款卡号
    ,o.guar_guar_form_cd -- 保证担保形式代码
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_dt -- 登记日期
    ,o.update_org_id -- 更新机构编号
    ,o.update_teller_id -- 更新柜员编号
    ,o.modif_dt -- 变更日期
    ,o.lp_id -- 法人编号
    ,o.auth_begin_dt -- 授权起始日期
    ,o.rev_guar_measure_flg -- 反担保措施标志
    ,o.nat_std_indus_dir_cd -- 国标行业投向代码
    ,o.corp_size_cd -- 企业规模代码
    ,o.natnal_econ_dept_type_cd -- 国民经济部门类型代码
    ,o.rgst_dist_cd -- 注册地行政区划代码
    ,o.dir_hxb_guar_flg -- 直接向我行担保标志
    ,o.obg_name -- 权属人名称
    ,o.obg_cust_id -- 权利人客户编号
    ,o.gcust_flg -- 代保管标志
    ,o.resdnt_flg -- 居民标志
    ,o.rgst_cty_rg_cd -- 注册地国家和地区代码
    ,o.guartor_net_asset -- 保证人净资产
    ,o.matn_flg -- 维护标志
    ,o.lmt_cont_id -- 额度合同编号
    ,o.ocup_guar_lmt_flg -- 占用担保额度标志
    ,o.file_dt -- 归档日期
    ,o.guar_type_cls_cd -- 担保类型分类代码
    ,o.guar_exp_dt -- 担保到期日期
    ,o.guar_begin_dt -- 担保起始日期
    ,o.guar_range_cd -- 担保范围代码
    ,o.pri_contr_id -- 主合同编号
    ,o.brwer_name -- 借款人名称
    ,o.text_cont_id -- 文本合同编号
    ,o.ts_flg -- 暂存标志
    ,o.elec_cont_type -- 电子合同类型
    ,o.main_guar_way_cd -- 主担保方式代码
    ,o.margin_ratio -- 保证金比例
    ,o.credt_org_name -- 债权人机构名称
    ,o.credt_org_id -- 债权人机构编号
    ,o.guar_mon_tenor -- 担保期限
    ,o.aldy_guar_amt -- 已担保金额
    ,o.aval_bal -- 可用余额
    ,o.auto_que_crdtc_rept_flg -- 自动查询征信报告标志
    ,o.crdtc_que_auth_id -- 征信查询授权书编号
    ,o.gover_fin_guar_corp_guar_flg -- 政府性融资担保公司保证标志
    ,o.rev_guar_flg -- 反担保标志
    ,o.ctfer_name -- 核保人姓名
    ,o.cust_risk_actl_pm_rat -- 客户风险实际抵质押率
    ,o.col_sys_guartor_id -- 押品系统保证人编号
    ,o.guartor_guar_ability_uplmi -- 保证人保证能力上限
    ,o.iscopy_guar_flow_num -- 被拷贝的担保流水号
    ,o.enforc_notz_flg -- 强制执行公证标志
    ,o.borw_legal_rep_name -- 借款人法定代表名称
    ,o.brwer_tel -- 借款人电话
    ,o.brwer_addr -- 借款人地址
    ,o.reception_ps_post -- 接待人职务
    ,o.reception_ps_name -- 接待人姓名
    ,o.owner_type_cd -- 所有人类型代码
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
from ${iml_schema}.agt_guar_cont_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_guar_cont_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.guar_cont_id = n.guar_cont_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_guar_cont_info_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.guar_cont_id = d.guar_cont_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_guar_cont_info_h;
--alter table ${iml_schema}.agt_guar_cont_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_guar_cont_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_guar_cont_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_guar_cont_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_guar_cont_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_guar_cont_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_guar_cont_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_guar_cont_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_guar_cont_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_guar_cont_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_guar_cont_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_guar_cont_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_guar_cont_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_guar_cont_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
