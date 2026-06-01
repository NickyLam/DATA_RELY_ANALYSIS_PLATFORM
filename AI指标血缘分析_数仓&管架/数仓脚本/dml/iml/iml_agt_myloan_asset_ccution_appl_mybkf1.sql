/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_myloan_asset_ccution_appl_mybkf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_myloan_asset_ccution_appl_mybkf1_tm purge;
drop table ${iml_schema}.agt_myloan_asset_ccution_appl_mybkf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_myloan_asset_ccution_appl add partition p_mybkf1 values ('mybkf1')(
        subpartition p_mybkf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_myloan_asset_ccution_appl modify partition p_mybkf1
    add subpartition p_mybkf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_myloan_asset_ccution_appl_mybkf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_myloan_asset_ccution_appl partition for ('mybkf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_myloan_asset_ccution_appl_mybkf1_tm
compress ${option_switch} for query high
as
select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,asset_ccution_id -- 资产流转编号
    ,tran_batch_id -- 转让批次编号
    ,disb_id -- 支用编号
    ,brwer_name -- 借款人名称
    ,brwer_cert_type_cd -- 借款人证件类型代码
    ,brwer_cert_no -- 借款人证件号码
    ,brwer_mobile_no -- 借款人手机号码
    ,brwer_addr -- 借款人住址
    ,solv_cd -- 偿债能力代码
    ,l_six_m_ovdue_cnt_level_score -- 最近六个月逾期笔数等级分数
    ,l_six_m_ovdue_amt_level_score -- 最近六个月逾期金额等级分数
    ,l_six_m_ovdue_days_level_score -- 最近六个月逾期天数等级分数
    ,recnt_yearly_perf_level_score -- 最近一年履约等级分数
    ,crdt_duran_level_score -- 信贷时长等级分数
    ,risk_score -- 风险分数
    ,risk_level_cd -- 风险等级代码
    ,six_m_ovdue_flg -- 六个月逾期标志
    ,rg_prov_name -- 地区省份名称
    ,age -- 年龄
    ,loan_type_descb -- 贷款类型描述
    ,loan_usage_descb -- 贷款用途描述
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,curr_cd -- 币种代码
    ,cont_amt -- 合同金额
    ,loan_bal -- 贷款余额
    ,int_rat_adj_way_descb -- 利率调整方式描述
    ,loan_year_int_rat -- 贷款年利率
    ,loan_value_dt -- 贷款起息日期
    ,loan_exp_dt -- 贷款到期日期
    ,loan_tenor -- 贷款期限
    ,loan_surp_days -- 贷款剩余天数
    ,repay_way_comnt -- 还款方式说明
    ,guar_way_descb -- 担保方式描述
    ,guara -- 担保品
    ,single_acct_crdt_lmt -- 单户授信额度
    ,corp_rgst_type -- 企业登记注册类型
    ,corp_name -- 公司名称
    ,legal_rep_name -- 法定代表人名称
    ,iac_rgst_no -- 工商注册号
    ,rgst_tm -- 注册时间
    ,rgst_addr -- 注册地址
    ,rgst_dist_id -- 注册地行政区编号
    ,rgst_prov_city_rg -- 注册地省市区
    ,thsnds_rgst_cap -- 万元注册资本
    ,indus_type_cd -- 行业类型代码
    ,oper_range_comnt -- 经营范围说明
    ,reg_iacb -- 注册工商局
    ,oper_status_comnt -- 经营状态说明
    ,final_as_year -- 最后年检年度
    ,oper_start_tm -- 经营开始时间
    ,oper_end_tm -- 经营结束时间
    ,start_bus_tm -- 开业时间
    ,corp_type_descb -- 公司类型描述
    ,dload_dt -- 下载日期
    ,cust_mgr_id -- 客户经理编号
    ,apv_status_cd -- 审批状态代码
    ,refuse_rs_comnt -- 拒绝原因说明
    ,cust_id -- 客户编号
    ,open_acct_sucs_flg -- 开户成功标志
    ,netw_vrfction_pass_flg -- 联网核查通过标志
    ,apv_end_tm -- 审批结束时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_myloan_asset_ccution_appl
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_myloan_asset_ccution_appl_mybkf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_myloan_asset_ccution_appl partition for ('mybkf1') where 0=1;

-- 2.1 insert data to tm table
-- icms_mybk_asset_transfer-1
insert into ${iml_schema}.agt_myloan_asset_ccution_appl_mybkf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,asset_ccution_id -- 资产流转编号
    ,tran_batch_id -- 转让批次编号
    ,disb_id -- 支用编号
    ,brwer_name -- 借款人名称
    ,brwer_cert_type_cd -- 借款人证件类型代码
    ,brwer_cert_no -- 借款人证件号码
    ,brwer_mobile_no -- 借款人手机号码
    ,brwer_addr -- 借款人住址
    ,solv_cd -- 偿债能力代码
    ,l_six_m_ovdue_cnt_level_score -- 最近六个月逾期笔数等级分数
    ,l_six_m_ovdue_amt_level_score -- 最近六个月逾期金额等级分数
    ,l_six_m_ovdue_days_level_score -- 最近六个月逾期天数等级分数
    ,recnt_yearly_perf_level_score -- 最近一年履约等级分数
    ,crdt_duran_level_score -- 信贷时长等级分数
    ,risk_score -- 风险分数
    ,risk_level_cd -- 风险等级代码
    ,six_m_ovdue_flg -- 六个月逾期标志
    ,rg_prov_name -- 地区省份名称
    ,age -- 年龄
    ,loan_type_descb -- 贷款类型描述
    ,loan_usage_descb -- 贷款用途描述
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,curr_cd -- 币种代码
    ,cont_amt -- 合同金额
    ,loan_bal -- 贷款余额
    ,int_rat_adj_way_descb -- 利率调整方式描述
    ,loan_year_int_rat -- 贷款年利率
    ,loan_value_dt -- 贷款起息日期
    ,loan_exp_dt -- 贷款到期日期
    ,loan_tenor -- 贷款期限
    ,loan_surp_days -- 贷款剩余天数
    ,repay_way_comnt -- 还款方式说明
    ,guar_way_descb -- 担保方式描述
    ,guara -- 担保品
    ,single_acct_crdt_lmt -- 单户授信额度
    ,corp_rgst_type -- 企业登记注册类型
    ,corp_name -- 公司名称
    ,legal_rep_name -- 法定代表人名称
    ,iac_rgst_no -- 工商注册号
    ,rgst_tm -- 注册时间
    ,rgst_addr -- 注册地址
    ,rgst_dist_id -- 注册地行政区编号
    ,rgst_prov_city_rg -- 注册地省市区
    ,thsnds_rgst_cap -- 万元注册资本
    ,indus_type_cd -- 行业类型代码
    ,oper_range_comnt -- 经营范围说明
    ,reg_iacb -- 注册工商局
    ,oper_status_comnt -- 经营状态说明
    ,final_as_year -- 最后年检年度
    ,oper_start_tm -- 经营开始时间
    ,oper_end_tm -- 经营结束时间
    ,start_bus_tm -- 开业时间
    ,corp_type_descb -- 公司类型描述
    ,dload_dt -- 下载日期
    ,cust_mgr_id -- 客户经理编号
    ,apv_status_cd -- 审批状态代码
    ,refuse_rs_comnt -- 拒绝原因说明
    ,cust_id -- 客户编号
    ,open_acct_sucs_flg -- 开户成功标志
    ,netw_vrfction_pass_flg -- 联网核查通过标志
    ,apv_end_tm -- 审批结束时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '203004'||P1.SERIALNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 资产流转编号
    ,P1.INJECTID -- 转让批次编号
    ,P1.DRAWNDNSEQNO -- 支用编号
    ,P1.NAME -- 借款人名称
    ,nvl(trim(P1.CERTTYPE),'0000')  -- 借款人证件类型代码
    ,P1.CERTNO -- 借款人证件号码
    ,P1.MOBILENO -- 借款人手机号码
    ,P1.USERADDRESS -- 借款人住址
    ,P1.REPAYMENTSEG -- 偿债能力代码
    ,P1.OVDORDERCNT6MGRADE -- 最近六个月逾期笔数等级分数
    ,P1.OVDORDERAMT6MGRADE -- 最近六个月逾期金额等级分数
    ,P1.OVDORDERDAYS6MGRADE -- 最近六个月逾期天数等级分数
    ,P1.POSITIVEBIZCNT1YGRADE -- 最近一年履约等级分数
    ,P1.FIRSTLOANLENGTHGRADE -- 信贷时长等级分数
    ,P1.RISKSCORE -- 风险分数
    ,P1.RISKRANK -- 风险等级代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.OVDLOG6M END -- 六个月逾期标志
    ,P1.PROVINCE -- 地区省份名称
    ,P1.USERAGE -- 年龄
    ,P1.LOANTYPE -- 贷款类型描述
    ,P1.LOANUSETYPE -- 贷款用途描述
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.ASSETCLASS END -- 贷款五级分类代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CURRENCYTYPE END -- 币种代码
    ,nvl(trim(P1.AMT),0) -- 合同金额
    ,nvl(trim(P1.BAL),0) -- 贷款余额
    ,P1.INTTYPE -- 利率调整方式描述
    ,nvl(trim(P1.INTRATE),0)*100 -- 贷款年利率
    ,${iml_schema}.DATEFORMAT_MIN(trim(P1.DISBURSEDATE)) -- 贷款起息日期
    ,${iml_schema}.DATEFORMAT_MIN(trim(P1.DUEDATE)) -- 贷款到期日期
    ,P1.TERMNUM -- 贷款期限
    ,P1.REMINDDAYS -- 贷款剩余天数
    ,P1.REPAYMODEDESC -- 还款方式说明
    ,P1.GUARANTEEMETHOD -- 担保方式描述
    ,P1.GUARANTEEITEM -- 担保品
    ,nvl(trim(P1.CREDITBAL),0) -- 单户授信额度
    ,P1.BUTPYE -- 企业登记注册类型
    ,P1.ENTITYNAME -- 公司名称
    ,P1.LAWER -- 法定代表人名称
    ,P1.REGISTERNO -- 工商注册号
    ,case when trim(P1.REGISTERDATE) is null then to_timestamp('1900-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss.ff6') else to_timestamp(P1.REGISTERDATE, 'yyyy-mm-dd hh24:mi:ss.ff6') end -- 注册时间
    ,P1.REGISTERADDRESS -- 注册地址
    ,P1.REGISTERADDRESSAREACODE -- 注册地行政区编号
    ,P1.REGISTERADDRESSAREA -- 注册地省市区
    ,nvl(trim(P1.REGISTERFUND),0) -- 万元注册资本
    ,P1.TRADECODE -- 行业类型代码
    ,P1.MANAGERANGE -- 经营范围说明
    ,P1.REGISTERDEPARTMENT -- 注册工商局
    ,P1.STATUSDESC -- 经营状态说明
    ,P1.LASTCHECKYEAR -- 最后年检年度
    ,case when trim(P1.MANAGEBEGINDATE) is null then to_timestamp('1900-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss.ff6') else to_timestamp(P1.MANAGEBEGINDATE, 'yyyy-mm-dd hh24:mi:ss.ff6') end -- 经营开始时间
    ,case when trim(P1.MANAGEENDDATE) is null then to_timestamp('2099-12-31 00:00:00', 'yyyy-mm-dd hh24:mi:ss.ff6') else to_timestamp(P1.MANAGEENDDATE, 'yyyy-mm-dd hh24:mi:ss.ff6') end -- 经营结束时间
    ,case when trim(P1.OPENDATE) is null then to_timestamp('2099-12-31 00:00:00', 'yyyy-mm-dd hh24:mi:ss.ff6') else to_timestamp(P1.OPENDATE, 'yyyy-mm-dd hh24:mi:ss.ff6') end -- 开业时间
    ,P1.COMPANYTYPE -- 公司类型描述
    ,${iml_schema}.DATEFORMAT_MIN(trim(P1.INPUTDATE)) -- 下载日期
    ,P1.INPUTID -- 客户经理编号
    ,P1.APPROVESTATUS -- 审批状态代码
    ,P1.FAILREASON -- 拒绝原因说明
    ,P1.CUSID -- 客户编号
    ,P1.ISGETCUSCODE -- 开户成功标志
    ,P1.ISCHECKINSPECT -- 联网核查通过标志
    ,case when trim(P1.APPRENDTIME) is null then to_timestamp('2099-12-31 00:00:00', 'yyyy-mm-dd hh24:mi:ss.ff6') else to_timestamp(P1.APPRENDTIME, 'yyyy-mm-dd hh24:mi:ss.ff6') end -- 审批结束时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_mybk_asset_transfer' -- 源表名称
    ,'mybkf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_mybk_asset_transfer p1
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.OVDLOG6M = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'ICMS'
        AND R4.SRC_TAB_EN_NAME= 'ICMS_MYBK_ASSET_TRANSFER'
        AND R4.SRC_FIELD_EN_NAME= 'OVDLOG6M'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_MYLOAN_ASSET_CCUTION_APPL'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'SIX_M_OVDUE_FLG'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.ASSETCLASS = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'ICMS'
        AND R3.SRC_TAB_EN_NAME= 'ICMS_MYBK_ASSET_TRANSFER'
        AND R3.SRC_FIELD_EN_NAME= 'ASSETCLASS'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_MYLOAN_ASSET_CCUTION_APPL'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'LOAN_LEVEL5_CLS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CURRENCYTYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_MYBK_ASSET_TRANSFER'
        AND R2.SRC_FIELD_EN_NAME= 'CURRENCYTYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_MYLOAN_ASSET_CCUTION_APPL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
where  1 = 1 
     and P1.etl_dt=to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_myloan_asset_ccution_appl_mybkf1_tm 
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_myloan_asset_ccution_appl_mybkf1_ex(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,asset_ccution_id -- 资产流转编号
    ,tran_batch_id -- 转让批次编号
    ,disb_id -- 支用编号
    ,brwer_name -- 借款人名称
    ,brwer_cert_type_cd -- 借款人证件类型代码
    ,brwer_cert_no -- 借款人证件号码
    ,brwer_mobile_no -- 借款人手机号码
    ,brwer_addr -- 借款人住址
    ,solv_cd -- 偿债能力代码
    ,l_six_m_ovdue_cnt_level_score -- 最近六个月逾期笔数等级分数
    ,l_six_m_ovdue_amt_level_score -- 最近六个月逾期金额等级分数
    ,l_six_m_ovdue_days_level_score -- 最近六个月逾期天数等级分数
    ,recnt_yearly_perf_level_score -- 最近一年履约等级分数
    ,crdt_duran_level_score -- 信贷时长等级分数
    ,risk_score -- 风险分数
    ,risk_level_cd -- 风险等级代码
    ,six_m_ovdue_flg -- 六个月逾期标志
    ,rg_prov_name -- 地区省份名称
    ,age -- 年龄
    ,loan_type_descb -- 贷款类型描述
    ,loan_usage_descb -- 贷款用途描述
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,curr_cd -- 币种代码
    ,cont_amt -- 合同金额
    ,loan_bal -- 贷款余额
    ,int_rat_adj_way_descb -- 利率调整方式描述
    ,loan_year_int_rat -- 贷款年利率
    ,loan_value_dt -- 贷款起息日期
    ,loan_exp_dt -- 贷款到期日期
    ,loan_tenor -- 贷款期限
    ,loan_surp_days -- 贷款剩余天数
    ,repay_way_comnt -- 还款方式说明
    ,guar_way_descb -- 担保方式描述
    ,guara -- 担保品
    ,single_acct_crdt_lmt -- 单户授信额度
    ,corp_rgst_type -- 企业登记注册类型
    ,corp_name -- 公司名称
    ,legal_rep_name -- 法定代表人名称
    ,iac_rgst_no -- 工商注册号
    ,rgst_tm -- 注册时间
    ,rgst_addr -- 注册地址
    ,rgst_dist_id -- 注册地行政区编号
    ,rgst_prov_city_rg -- 注册地省市区
    ,thsnds_rgst_cap -- 万元注册资本
    ,indus_type_cd -- 行业类型代码
    ,oper_range_comnt -- 经营范围说明
    ,reg_iacb -- 注册工商局
    ,oper_status_comnt -- 经营状态说明
    ,final_as_year -- 最后年检年度
    ,oper_start_tm -- 经营开始时间
    ,oper_end_tm -- 经营结束时间
    ,start_bus_tm -- 开业时间
    ,corp_type_descb -- 公司类型描述
    ,dload_dt -- 下载日期
    ,cust_mgr_id -- 客户经理编号
    ,apv_status_cd -- 审批状态代码
    ,refuse_rs_comnt -- 拒绝原因说明
    ,cust_id -- 客户编号
    ,open_acct_sucs_flg -- 开户成功标志
    ,netw_vrfction_pass_flg -- 联网核查通过标志
    ,apv_end_tm -- 审批结束时间
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.appl_id, o.appl_id) as appl_id -- 申请编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.asset_ccution_id, o.asset_ccution_id) as asset_ccution_id -- 资产流转编号
    ,nvl(n.tran_batch_id, o.tran_batch_id) as tran_batch_id -- 转让批次编号
    ,nvl(n.disb_id, o.disb_id) as disb_id -- 支用编号
    ,nvl(n.brwer_name, o.brwer_name) as brwer_name -- 借款人名称
    ,nvl(n.brwer_cert_type_cd, o.brwer_cert_type_cd) as brwer_cert_type_cd -- 借款人证件类型代码
    ,nvl(n.brwer_cert_no, o.brwer_cert_no) as brwer_cert_no -- 借款人证件号码
    ,nvl(n.brwer_mobile_no, o.brwer_mobile_no) as brwer_mobile_no -- 借款人手机号码
    ,nvl(n.brwer_addr, o.brwer_addr) as brwer_addr -- 借款人住址
    ,nvl(n.solv_cd, o.solv_cd) as solv_cd -- 偿债能力代码
    ,nvl(n.l_six_m_ovdue_cnt_level_score, o.l_six_m_ovdue_cnt_level_score) as l_six_m_ovdue_cnt_level_score -- 最近六个月逾期笔数等级分数
    ,nvl(n.l_six_m_ovdue_amt_level_score, o.l_six_m_ovdue_amt_level_score) as l_six_m_ovdue_amt_level_score -- 最近六个月逾期金额等级分数
    ,nvl(n.l_six_m_ovdue_days_level_score, o.l_six_m_ovdue_days_level_score) as l_six_m_ovdue_days_level_score -- 最近六个月逾期天数等级分数
    ,nvl(n.recnt_yearly_perf_level_score, o.recnt_yearly_perf_level_score) as recnt_yearly_perf_level_score -- 最近一年履约等级分数
    ,nvl(n.crdt_duran_level_score, o.crdt_duran_level_score) as crdt_duran_level_score -- 信贷时长等级分数
    ,nvl(n.risk_score, o.risk_score) as risk_score -- 风险分数
    ,nvl(n.risk_level_cd, o.risk_level_cd) as risk_level_cd -- 风险等级代码
    ,nvl(n.six_m_ovdue_flg, o.six_m_ovdue_flg) as six_m_ovdue_flg -- 六个月逾期标志
    ,nvl(n.rg_prov_name, o.rg_prov_name) as rg_prov_name -- 地区省份名称
    ,nvl(n.age, o.age) as age -- 年龄
    ,nvl(n.loan_type_descb, o.loan_type_descb) as loan_type_descb -- 贷款类型描述
    ,nvl(n.loan_usage_descb, o.loan_usage_descb) as loan_usage_descb -- 贷款用途描述
    ,nvl(n.loan_level5_cls_cd, o.loan_level5_cls_cd) as loan_level5_cls_cd -- 贷款五级分类代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.cont_amt, o.cont_amt) as cont_amt -- 合同金额
    ,nvl(n.loan_bal, o.loan_bal) as loan_bal -- 贷款余额
    ,nvl(n.int_rat_adj_way_descb, o.int_rat_adj_way_descb) as int_rat_adj_way_descb -- 利率调整方式描述
    ,nvl(n.loan_year_int_rat, o.loan_year_int_rat) as loan_year_int_rat -- 贷款年利率
    ,nvl(n.loan_value_dt, o.loan_value_dt) as loan_value_dt -- 贷款起息日期
    ,nvl(n.loan_exp_dt, o.loan_exp_dt) as loan_exp_dt -- 贷款到期日期
    ,nvl(n.loan_tenor, o.loan_tenor) as loan_tenor -- 贷款期限
    ,nvl(n.loan_surp_days, o.loan_surp_days) as loan_surp_days -- 贷款剩余天数
    ,nvl(n.repay_way_comnt, o.repay_way_comnt) as repay_way_comnt -- 还款方式说明
    ,nvl(n.guar_way_descb, o.guar_way_descb) as guar_way_descb -- 担保方式描述
    ,nvl(n.guara, o.guara) as guara -- 担保品
    ,nvl(n.single_acct_crdt_lmt, o.single_acct_crdt_lmt) as single_acct_crdt_lmt -- 单户授信额度
    ,nvl(n.corp_rgst_type, o.corp_rgst_type) as corp_rgst_type -- 企业登记注册类型
    ,nvl(n.corp_name, o.corp_name) as corp_name -- 公司名称
    ,nvl(n.legal_rep_name, o.legal_rep_name) as legal_rep_name -- 法定代表人名称
    ,nvl(n.iac_rgst_no, o.iac_rgst_no) as iac_rgst_no -- 工商注册号
    ,nvl(n.rgst_tm, o.rgst_tm) as rgst_tm -- 注册时间
    ,nvl(n.rgst_addr, o.rgst_addr) as rgst_addr -- 注册地址
    ,nvl(n.rgst_dist_id, o.rgst_dist_id) as rgst_dist_id -- 注册地行政区编号
    ,nvl(n.rgst_prov_city_rg, o.rgst_prov_city_rg) as rgst_prov_city_rg -- 注册地省市区
    ,nvl(n.thsnds_rgst_cap, o.thsnds_rgst_cap) as thsnds_rgst_cap -- 万元注册资本
    ,nvl(n.indus_type_cd, o.indus_type_cd) as indus_type_cd -- 行业类型代码
    ,nvl(n.oper_range_comnt, o.oper_range_comnt) as oper_range_comnt -- 经营范围说明
    ,nvl(n.reg_iacb, o.reg_iacb) as reg_iacb -- 注册工商局
    ,nvl(n.oper_status_comnt, o.oper_status_comnt) as oper_status_comnt -- 经营状态说明
    ,nvl(n.final_as_year, o.final_as_year) as final_as_year -- 最后年检年度
    ,nvl(n.oper_start_tm, o.oper_start_tm) as oper_start_tm -- 经营开始时间
    ,nvl(n.oper_end_tm, o.oper_end_tm) as oper_end_tm -- 经营结束时间
    ,nvl(n.start_bus_tm, o.start_bus_tm) as start_bus_tm -- 开业时间
    ,nvl(n.corp_type_descb, o.corp_type_descb) as corp_type_descb -- 公司类型描述
    ,nvl(n.dload_dt, o.dload_dt) as dload_dt -- 下载日期
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.refuse_rs_comnt, o.refuse_rs_comnt) as refuse_rs_comnt -- 拒绝原因说明
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.open_acct_sucs_flg, o.open_acct_sucs_flg) as open_acct_sucs_flg -- 开户成功标志
    ,nvl(n.netw_vrfction_pass_flg, o.netw_vrfction_pass_flg) as netw_vrfction_pass_flg -- 联网核查通过标志
    ,nvl(n.apv_end_tm, o.apv_end_tm) as apv_end_tm -- 审批结束时间
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.appl_id is null
                and o.lp_id is null
            ) or (
                o.asset_ccution_id <> n.asset_ccution_id
                or o.tran_batch_id <> n.tran_batch_id
                or o.disb_id <> n.disb_id
                or o.brwer_name <> n.brwer_name
                or o.brwer_cert_type_cd <> n.brwer_cert_type_cd
                or o.brwer_cert_no <> n.brwer_cert_no
                or o.brwer_mobile_no <> n.brwer_mobile_no
                or o.brwer_addr <> n.brwer_addr
                or o.solv_cd <> n.solv_cd
                or o.l_six_m_ovdue_cnt_level_score <> n.l_six_m_ovdue_cnt_level_score
                or o.l_six_m_ovdue_amt_level_score <> n.l_six_m_ovdue_amt_level_score
                or o.l_six_m_ovdue_days_level_score <> n.l_six_m_ovdue_days_level_score
                or o.recnt_yearly_perf_level_score <> n.recnt_yearly_perf_level_score
                or o.crdt_duran_level_score <> n.crdt_duran_level_score
                or o.risk_score <> n.risk_score
                or o.risk_level_cd <> n.risk_level_cd
                or o.six_m_ovdue_flg <> n.six_m_ovdue_flg
                or o.rg_prov_name <> n.rg_prov_name
                or o.age <> n.age
                or o.loan_type_descb <> n.loan_type_descb
                or o.loan_usage_descb <> n.loan_usage_descb
                or o.loan_level5_cls_cd <> n.loan_level5_cls_cd
                or o.curr_cd <> n.curr_cd
                or o.cont_amt <> n.cont_amt
                or o.loan_bal <> n.loan_bal
                or o.int_rat_adj_way_descb <> n.int_rat_adj_way_descb
                or o.loan_year_int_rat <> n.loan_year_int_rat
                or o.loan_value_dt <> n.loan_value_dt
                or o.loan_exp_dt <> n.loan_exp_dt
                or o.loan_tenor <> n.loan_tenor
                or o.loan_surp_days <> n.loan_surp_days
                or o.repay_way_comnt <> n.repay_way_comnt
                or o.guar_way_descb <> n.guar_way_descb
                or o.guara <> n.guara
                or o.single_acct_crdt_lmt <> n.single_acct_crdt_lmt
                or o.corp_rgst_type <> n.corp_rgst_type
                or o.corp_name <> n.corp_name
                or o.legal_rep_name <> n.legal_rep_name
                or o.iac_rgst_no <> n.iac_rgst_no
                or o.rgst_tm <> n.rgst_tm
                or o.rgst_addr <> n.rgst_addr
                or o.rgst_dist_id <> n.rgst_dist_id
                or o.rgst_prov_city_rg <> n.rgst_prov_city_rg
                or o.thsnds_rgst_cap <> n.thsnds_rgst_cap
                or o.indus_type_cd <> n.indus_type_cd
                or o.oper_range_comnt <> n.oper_range_comnt
                or o.reg_iacb <> n.reg_iacb
                or o.oper_status_comnt <> n.oper_status_comnt
                or o.final_as_year <> n.final_as_year
                or o.oper_start_tm <> n.oper_start_tm
                or o.oper_end_tm <> n.oper_end_tm
                or o.start_bus_tm <> n.start_bus_tm
                or o.corp_type_descb <> n.corp_type_descb
                or o.dload_dt <> n.dload_dt
                or o.cust_mgr_id <> n.cust_mgr_id
                or o.apv_status_cd <> n.apv_status_cd
                or o.refuse_rs_comnt <> n.refuse_rs_comnt
                or o.cust_id <> n.cust_id
                or o.open_acct_sucs_flg <> n.open_acct_sucs_flg
                or o.netw_vrfction_pass_flg <> n.netw_vrfction_pass_flg
                or o.apv_end_tm <> n.apv_end_tm
            ) or (
                 case when (
                           n.appl_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.appl_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_myloan_asset_ccution_appl_mybkf1_tm n
    full join ${iml_schema}.agt_myloan_asset_ccution_appl_mybkf1_bk o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_myloan_asset_ccution_appl truncate partition for ('mybkf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_myloan_asset_ccution_appl exchange subpartition p_mybkf1_${batch_date} with table ${iml_schema}.agt_myloan_asset_ccution_appl_mybkf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_myloan_asset_ccution_appl drop subpartition p_mybkf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_myloan_asset_ccution_appl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_myloan_asset_ccution_appl_mybkf1_tm purge;
drop table ${iml_schema}.agt_myloan_asset_ccution_appl_mybkf1_ex purge;
drop table ${iml_schema}.agt_myloan_asset_ccution_appl_mybkf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_myloan_asset_ccution_appl', partname => 'p_mybkf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);