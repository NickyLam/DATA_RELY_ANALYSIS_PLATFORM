/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_appl_xked_attach_info_h_icmsf1
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
alter table ${iml_schema}.agt_loan_appl_xked_attach_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_appl_xked_attach_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_appl_xked_attach_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_appl_xked_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_appl_xked_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_appl_xked_attach_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_appl_xked_attach_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,prod_abbr -- 产品简称
    ,appl_amt -- 申请金额
    ,loan_tenor -- 贷款期限
    ,main_guar_way_cd -- 主担保方式代码
    ,lmt_circl_flg -- 额度循环标志
    ,corp_name -- 企业名称
    ,corp_cert_type_cd -- 企业证件类型代码
    ,corp_cert_no -- 企业证件号码
    ,corp_cert_exp_dt -- 企业证件到期日期
    ,corp_mang_range -- 企业经营范围
    ,corp_mang_begin_dt -- 企业经营起始日期
    ,corp_mang_exp_dt -- 企业经营到期日期
    ,corp_found_dt -- 企业成立日期
    ,score_val -- 评分分值
    ,mang_local_prov_cd -- 经营所在省级代码
    ,mang_local_city_cd -- 经营所在市级代码
    ,mang_site_cd -- 经营所在地区代码
    ,mang_addr -- 经营地址
    ,actl_ctrler_work_years -- 实控人从业年限
    ,flow_calcu_year_sell_inco -- 流水推算年销售收入
    ,tech_inovt_corp_type_cd -- 科创企业类型代码
    ,corp_solft_coprit_affi_cnt -- 企业软著登记公告次数
    ,corp_intel_prop_qtty -- 企业知识产权数量
    ,intel_prop_invent_qtty -- 知识产权发明数量
    ,intgd_ciut_design_appl_qtty -- 集成电路布图设计申请数量
    ,intel_prop_tort_punish_cnt -- 知识产权侵权处罚次数
    ,int_prop_unfair_comption_cnt -- 知识产权不正当竞争次数
    ,intel_prop_judge_dfndn_cnt -- 知识产权裁判文书被告次数
    ,m24_ups_bf_5_purchs_amt -- 近24个月上游前5大采购金额
    ,m24_ups_purchs_amt -- 近24个月上游整体采购金额
    ,m24_dos_bf_5_sell_amt -- 近24个月下游前5大销售金额
    ,m24_dos_sell_amt -- 近24个月下游整体销售金额
    ,m12_ias_provi_bf10_tran_amt -- 近12个月重要稳定供应商（前十）交易金额
    ,m12_i_provi_bf10_tran_amt -- 近12个月重要稳定客户（前十）交易金额
    ,m24_open_invoice_inco -- 近24个月开票收入
    ,th_year_max_new_tech_inco -- 本年度高新技术产品（服务）收入
    ,nx_year_max_new_tech_inco -- 上年度高新技术产品（服务）收入
    ,th_year_degree_bus_inco -- 本年度营业收入
    ,th_year_degree_workr_num -- 本年度从业人数
    ,nx_year_obtain_emply_number -- 上年度从业人数
    ,th_year_scen_tech_person_num -- 本年度科技人员人数
    ,nx_year_scen_tech_person_num -- 上年度科技人员人数
    ,th_year_degree_resdev_amt -- 本年度研发费用金额
    ,nx_year_resdev_fee_amt -- 上年度研发费用金额
    ,th_year_gover_subsidy_inco -- 本年度企业获取政府补贴收入
    ,nx_year_gover_subsidy_inco -- 上年度企业获取政府补贴收入
    ,pre_scd_year_sales_qtty -- 预测次年销售量
    ,other_chn_provi_oper_cap -- 其他渠道提供的运营资金
    ,crdtc_not_embody_liab_bal -- 征信未体现的负债余额
    ,crdtc_not_mon_second_marke -- 征信未体现的月还款额
    ,corp_mon_second_marke -- 企业月还款额
    ,corp_acct_recvbl_inpwn_flg -- 企业应收账款质押标志
    ,acct_recvbl_inpwn_loan_amt -- 应收账款质押贷款金额
    ,intel_prop_inpwn_flg -- 知识产权质押标志
    ,intel_prop_inpwn_loan_amt -- 知识产权质押贷款金额
    ,share_right_inpwn_flg -- 股权质押标志
    ,share_right_inpwn_loan_amt -- 股权质押贷款金额
    ,crdtc_inquirer_idti_cd -- 征信查询人身份代码
    ,que_appl_type_cd -- 查询申请类型代码
    ,data_src_cd -- 数据来源代码
    ,auth_dt -- 授权日期
    ,auth_effect_dt -- 授权生效日期
    ,auth_invalid_dt -- 授权失效日期
    ,hxb_rela_ps_flg -- 我行关联人标志
    ,corp_cust_id -- 企业客户编号
    ,flow_status_cd -- 流程状态代码
    ,task_status_cd -- 任务状态代码
    ,apv_status_cd -- 审批状态代码
    ,apv_lmt -- 审批额度
    ,warn_info -- 预警信息
    ,tax_type_cd -- 涉税类型代码
    ,tax_que_auth_flow_num -- 税务查询授权流水号
    ,tax_num -- 纳税人识别号
    ,tax_auth_sucs_flg -- 广税授权成功标志
    ,apv_appl_dt -- 审批申请日期
    ,apv_end_dt -- 审批结束日期
    ,corp_new_flg -- 企业专精特新标志
    ,refuse_rs -- 拒绝原因
    ,hxb_rela_corp_flg -- 我行关联企业标志
    ,rg_lon_flg -- 园区贷标志
    ,advise_flg -- 通知展业标志
    ,outline_flg -- 线下标志
    ,lmt_appl_flow_num -- 授信申请流水号
    ,cust_mgr_id -- 客户经理编号
    ,belong_brch_org_id -- 所属分行机构编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,update_org_id -- 更新机构编号
    ,update_teller_id -- 更新柜员编号
    ,up_date -- 更新日期
    ,auth_way_cd -- 授权方式代码
    ,biome_trics_cd -- 生物识别技术代码
    ,remark -- 备注
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_appl_xked_attach_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_appl_xked_attach_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_appl_xked_attach_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_appl_xked_attach_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_appl_xked_attach_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_xked_iqp_loan_app-1
insert into ${iml_schema}.agt_loan_appl_xked_attach_info_h_icmsf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,prod_abbr -- 产品简称
    ,appl_amt -- 申请金额
    ,loan_tenor -- 贷款期限
    ,main_guar_way_cd -- 主担保方式代码
    ,lmt_circl_flg -- 额度循环标志
    ,corp_name -- 企业名称
    ,corp_cert_type_cd -- 企业证件类型代码
    ,corp_cert_no -- 企业证件号码
    ,corp_cert_exp_dt -- 企业证件到期日期
    ,corp_mang_range -- 企业经营范围
    ,corp_mang_begin_dt -- 企业经营起始日期
    ,corp_mang_exp_dt -- 企业经营到期日期
    ,corp_found_dt -- 企业成立日期
    ,score_val -- 评分分值
    ,mang_local_prov_cd -- 经营所在省级代码
    ,mang_local_city_cd -- 经营所在市级代码
    ,mang_site_cd -- 经营所在地区代码
    ,mang_addr -- 经营地址
    ,actl_ctrler_work_years -- 实控人从业年限
    ,flow_calcu_year_sell_inco -- 流水推算年销售收入
    ,tech_inovt_corp_type_cd -- 科创企业类型代码
    ,corp_solft_coprit_affi_cnt -- 企业软著登记公告次数
    ,corp_intel_prop_qtty -- 企业知识产权数量
    ,intel_prop_invent_qtty -- 知识产权发明数量
    ,intgd_ciut_design_appl_qtty -- 集成电路布图设计申请数量
    ,intel_prop_tort_punish_cnt -- 知识产权侵权处罚次数
    ,int_prop_unfair_comption_cnt -- 知识产权不正当竞争次数
    ,intel_prop_judge_dfndn_cnt -- 知识产权裁判文书被告次数
    ,m24_ups_bf_5_purchs_amt -- 近24个月上游前5大采购金额
    ,m24_ups_purchs_amt -- 近24个月上游整体采购金额
    ,m24_dos_bf_5_sell_amt -- 近24个月下游前5大销售金额
    ,m24_dos_sell_amt -- 近24个月下游整体销售金额
    ,m12_ias_provi_bf10_tran_amt -- 近12个月重要稳定供应商（前十）交易金额
    ,m12_i_provi_bf10_tran_amt -- 近12个月重要稳定客户（前十）交易金额
    ,m24_open_invoice_inco -- 近24个月开票收入
    ,th_year_max_new_tech_inco -- 本年度高新技术产品（服务）收入
    ,nx_year_max_new_tech_inco -- 上年度高新技术产品（服务）收入
    ,th_year_degree_bus_inco -- 本年度营业收入
    ,th_year_degree_workr_num -- 本年度从业人数
    ,nx_year_obtain_emply_number -- 上年度从业人数
    ,th_year_scen_tech_person_num -- 本年度科技人员人数
    ,nx_year_scen_tech_person_num -- 上年度科技人员人数
    ,th_year_degree_resdev_amt -- 本年度研发费用金额
    ,nx_year_resdev_fee_amt -- 上年度研发费用金额
    ,th_year_gover_subsidy_inco -- 本年度企业获取政府补贴收入
    ,nx_year_gover_subsidy_inco -- 上年度企业获取政府补贴收入
    ,pre_scd_year_sales_qtty -- 预测次年销售量
    ,other_chn_provi_oper_cap -- 其他渠道提供的运营资金
    ,crdtc_not_embody_liab_bal -- 征信未体现的负债余额
    ,crdtc_not_mon_second_marke -- 征信未体现的月还款额
    ,corp_mon_second_marke -- 企业月还款额
    ,corp_acct_recvbl_inpwn_flg -- 企业应收账款质押标志
    ,acct_recvbl_inpwn_loan_amt -- 应收账款质押贷款金额
    ,intel_prop_inpwn_flg -- 知识产权质押标志
    ,intel_prop_inpwn_loan_amt -- 知识产权质押贷款金额
    ,share_right_inpwn_flg -- 股权质押标志
    ,share_right_inpwn_loan_amt -- 股权质押贷款金额
    ,crdtc_inquirer_idti_cd -- 征信查询人身份代码
    ,que_appl_type_cd -- 查询申请类型代码
    ,data_src_cd -- 数据来源代码
    ,auth_dt -- 授权日期
    ,auth_effect_dt -- 授权生效日期
    ,auth_invalid_dt -- 授权失效日期
    ,hxb_rela_ps_flg -- 我行关联人标志
    ,corp_cust_id -- 企业客户编号
    ,flow_status_cd -- 流程状态代码
    ,task_status_cd -- 任务状态代码
    ,apv_status_cd -- 审批状态代码
    ,apv_lmt -- 审批额度
    ,warn_info -- 预警信息
    ,tax_type_cd -- 涉税类型代码
    ,tax_que_auth_flow_num -- 税务查询授权流水号
    ,tax_num -- 纳税人识别号
    ,tax_auth_sucs_flg -- 广税授权成功标志
    ,apv_appl_dt -- 审批申请日期
    ,apv_end_dt -- 审批结束日期
    ,corp_new_flg -- 企业专精特新标志
    ,refuse_rs -- 拒绝原因
    ,hxb_rela_corp_flg -- 我行关联企业标志
    ,rg_lon_flg -- 园区贷标志
    ,advise_flg -- 通知展业标志
    ,outline_flg -- 线下标志
    ,lmt_appl_flow_num -- 授信申请流水号
    ,cust_mgr_id -- 客户经理编号
    ,belong_brch_org_id -- 所属分行机构编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,update_org_id -- 更新机构编号
    ,update_teller_id -- 更新柜员编号
    ,up_date -- 更新日期
    ,auth_way_cd -- 授权方式代码
    ,biome_trics_cd -- 生物识别技术代码
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206004'||P1.SERIALNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 申请流水号
    ,P1.APPLYNO -- 信贷申请流水号
    ,P1.PRDCODE -- 产品编号
    ,P1.PRDNAME -- 产品名称
    ,P1.TAXSTRDATE -- 产品简称
    ,P1.LOADAMOUNT -- 申请金额
    ,to_number(nvl(trim(P1.TERMMONTH),0)) -- 贷款期限
    ,nvl(trim(P1.DWELLADDRESS),'-') -- 主担保方式代码
    ,nvl(trim(P1.DWELLAREACODE),'-') -- 额度循环标志
    ,P1.ENTERPRISENAME -- 企业名称
    ,P1.ENTIDTTP -- 企业证件类型代码
    ,P1.ENTIDTNO -- 企业证件号码
    ,P1.IDEXPIRYDATE -- 企业证件到期日期
    ,P1.BRWERCORPOPERSCOPE -- 企业经营范围
    ,P1.ENTERSTARTDATE -- 企业经营起始日期
    ,P1.ENTERENDDATE -- 企业经营到期日期
    ,P1.SETUPDATE -- 企业成立日期
    ,P1.AUTOSCORE -- 评分分值
    ,nvl(trim(P1.BUSINESSSCOPE),'000000') -- 经营所在省级代码
    ,nvl(trim(P1.VALIDITEDATE),'000000') -- 经营所在市级代码
    ,nvl(trim(P1.REGISTERAREA),'000000') -- 经营所在地区代码
    ,P1.REGISTERADDRESS -- 经营地址
    ,to_number(nvl(trim(P1.ACTUALCONTROLLEREMPYEARS),0)) -- 实控人从业年限
    ,P1.FLOWANNUALSALESREVENUE -- 流水推算年销售收入
    ,nvl(trim(P1.SCIENCETECHENTTYPE),'-') -- 科创企业类型代码
    ,to_number(nvl(trim(P1.ENTSOLFTCOPYRIGHTREGNUM),0)) -- 企业软著登记公告次数
    ,to_number(nvl(trim(P1.ENTKNOWLEDGEPROPNUM),0)) -- 企业知识产权数量
    ,to_number(nvl(trim(P1.KNOWLEDGEPROPINVENTNUM),0)) -- 知识产权发明数量
    ,to_number(nvl(trim(P1.INTEFCIRCUITLAYOUTDESIGNAPPNUM),0)) -- 集成电路布图设计申请数量
    ,to_number(nvl(trim(P1.KNOWLEDGEPROPINFRINPUNISHNUM),0)) -- 知识产权侵权处罚次数
    ,to_number(nvl(trim(P1.KNOWLEDGEPROPUNFAIRCOMPENUM),0)) -- 知识产权不正当竞争次数
    ,to_number(nvl(trim(P1.KNOWLEDGEPROPJUDGDOCDEFENTNUM),0)) -- 知识产权裁判文书被告次数
    ,P1.PAST24MUPSTREAMTOP5PURCHAMT -- 近24个月上游前5大采购金额
    ,P1.PAST24MUPSTREAMINTEGPURCHAMT -- 近24个月上游整体采购金额
    ,P1.PAST24MDOWNSTREAMTOP5SALEAMT -- 近24个月下游前5大销售金额
    ,P1.PAST24MDOWNSTREAMINTEGSALEAMT -- 近24个月下游整体销售金额
    ,P1.PAST12MISPARTNERTOP10TRANSAMT -- 近12个月重要稳定供应商（前十）交易金额
    ,P1.PAST12MISCUSTTOP10TRANSAMT -- 近12个月重要稳定客户（前十）交易金额
    ,P1.PAST24MINVOICREVENUE -- 近24个月开票收入
    ,P1.ANNUALHIGHTECHPROINCOME -- 本年度高新技术产品（服务）收入
    ,P1.PREYEARHIGHTECHPROINCOME -- 上年度高新技术产品（服务）收入
    ,P1.ANNUALOPERAINCOME -- 本年度营业收入
    ,to_number(nvl(trim(P1.ANNUALEMPSNUM),0)) -- 本年度从业人数
    ,to_number(nvl(trim(P1.PREYEAREMPSNUM),0)) -- 上年度从业人数
    ,to_number(nvl(trim(P1.ANNUALTECHNINUM),0)) -- 本年度科技人员人数
    ,to_number(nvl(trim(P1.PREYEARTECHNINUM),0)) -- 上年度科技人员人数
    ,P1.ANNUALRESEARCHDEVAMT -- 本年度研发费用金额
    ,P1.PREYEARRESEARCHDEVAMT -- 上年度研发费用金额
    ,P1.ANNUALENTGETGOVSUSIDY -- 本年度企业获取政府补贴收入
    ,P1.PREYEARENTGETGOVSUSIDY -- 上年度企业获取政府补贴收入
    ,to_number(nvl(trim(P1.FORECASTNEXTYEARSALE),0)) -- 预测次年销售量
    ,P1.OTHERCHANNELWORKCAPIT -- 其他渠道提供的运营资金
    ,P1.NOCREDITEACHDEBTACCUBALANCE -- 征信未体现的负债余额
    ,P1.NOCREDITMONTHACCUREPAYDEBT -- 征信未体现的月还款额
    ,P1.ENTMONTHREPAYBALANCE -- 企业月还款额
    ,nvl(trim(P1.ISPLEDGEDRECEIVEACCOUNT),'-') -- 企业应收账款质押标志
    ,P1.PLEDGERECEIVEAMT -- 应收账款质押贷款金额
    ,nvl(trim(P1.ISKNOWLEDGEPLEDGED),'-') -- 知识产权质押标志
    ,P1.KNOWLEDGEPLEDGERECEIVEAMT -- 知识产权质押贷款金额
    ,nvl(trim(P1.ISSTOCKPLEDGED),'-') -- 股权质押标志
    ,P1.STOCKPLEDGEDAMT -- 股权质押贷款金额
    ,P1.QRYUSERTYPE -- 征信查询人身份代码
    ,nvl(trim(P1.QRYOPERTP),'-') -- 查询申请类型代码
    ,nvl(trim(P1.PARTNER),'-') -- 数据来源代码
    ,P1.AUTHOTIME -- 授权日期
    ,P1.AUTHOSTRDATE -- 授权生效日期
    ,P1.AUTHOENDDATE -- 授权失效日期
    ,nvl(trim(P1.ISBANKREL),'-') -- 我行关联人标志
    ,P1.CUSTOMERID -- 企业客户编号
    ,nvl(trim(P1.TRANSSTATUS),'-') -- 流程状态代码
    ,nvl(trim(P1.STATUS),'-') -- 任务状态代码
    ,nvl(trim(P1.APPROVESTATUS),'-') -- 审批状态代码
    ,P1.FINALAPPLYAMOUNT -- 审批额度
    ,P1.RISKWARM -- 预警信息
    ,nvl(trim(P1.TAXQUERYFLAG),'-') -- 涉税类型代码
    ,P1.TAXAUTHORIZENO -- 税务查询授权流水号
    ,P1.TAXPAYERIDENTITYNO -- 纳税人识别号
    ,nvl(trim(P1.ISTAXSUCCESSGS),'-') -- 广税授权成功标志
    ,P1.LOANSTARTTIME -- 审批申请日期
    ,P1.LOANENDTIME -- 审批结束日期
    ,nvl(trim(P1.OPERCORPFLG),'-') -- 企业专精特新标志
    ,P1.MASSAGE -- 拒绝原因
    ,nvl(trim(P1.ISRELATEENT),'-') -- 我行关联企业标志
    ,nvl(trim(P1.ISGARDEN),'-') -- 园区贷标志
    ,nvl(trim(P1.INFORMFLAG),'-') -- 通知展业标志
    ,decode(P1.CHANNLEFROM,' ','-','1','1','2','0',P1.CHANNLEFROM) -- 线下标志
    ,P1.BANO -- 授信申请流水号
    ,P1.INPUTID -- 客户经理编号
    ,P1.BRANCHID -- 所属分行机构编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEDATE -- 更新日期
    ,nvl(trim(P1.AUTHOTYPE),'-') -- 授权方式代码
    ,nvl(trim(P1.BIOMETRICS),'-') -- 生物识别技术代码
    ,P1.RISKNOTE -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_xked_iqp_loan_app' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_xked_iqp_loan_app p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_appl_xked_attach_info_h_icmsf1_tm 
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
        into ${iml_schema}.agt_loan_appl_xked_attach_info_h_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,prod_abbr -- 产品简称
    ,appl_amt -- 申请金额
    ,loan_tenor -- 贷款期限
    ,main_guar_way_cd -- 主担保方式代码
    ,lmt_circl_flg -- 额度循环标志
    ,corp_name -- 企业名称
    ,corp_cert_type_cd -- 企业证件类型代码
    ,corp_cert_no -- 企业证件号码
    ,corp_cert_exp_dt -- 企业证件到期日期
    ,corp_mang_range -- 企业经营范围
    ,corp_mang_begin_dt -- 企业经营起始日期
    ,corp_mang_exp_dt -- 企业经营到期日期
    ,corp_found_dt -- 企业成立日期
    ,score_val -- 评分分值
    ,mang_local_prov_cd -- 经营所在省级代码
    ,mang_local_city_cd -- 经营所在市级代码
    ,mang_site_cd -- 经营所在地区代码
    ,mang_addr -- 经营地址
    ,actl_ctrler_work_years -- 实控人从业年限
    ,flow_calcu_year_sell_inco -- 流水推算年销售收入
    ,tech_inovt_corp_type_cd -- 科创企业类型代码
    ,corp_solft_coprit_affi_cnt -- 企业软著登记公告次数
    ,corp_intel_prop_qtty -- 企业知识产权数量
    ,intel_prop_invent_qtty -- 知识产权发明数量
    ,intgd_ciut_design_appl_qtty -- 集成电路布图设计申请数量
    ,intel_prop_tort_punish_cnt -- 知识产权侵权处罚次数
    ,int_prop_unfair_comption_cnt -- 知识产权不正当竞争次数
    ,intel_prop_judge_dfndn_cnt -- 知识产权裁判文书被告次数
    ,m24_ups_bf_5_purchs_amt -- 近24个月上游前5大采购金额
    ,m24_ups_purchs_amt -- 近24个月上游整体采购金额
    ,m24_dos_bf_5_sell_amt -- 近24个月下游前5大销售金额
    ,m24_dos_sell_amt -- 近24个月下游整体销售金额
    ,m12_ias_provi_bf10_tran_amt -- 近12个月重要稳定供应商（前十）交易金额
    ,m12_i_provi_bf10_tran_amt -- 近12个月重要稳定客户（前十）交易金额
    ,m24_open_invoice_inco -- 近24个月开票收入
    ,th_year_max_new_tech_inco -- 本年度高新技术产品（服务）收入
    ,nx_year_max_new_tech_inco -- 上年度高新技术产品（服务）收入
    ,th_year_degree_bus_inco -- 本年度营业收入
    ,th_year_degree_workr_num -- 本年度从业人数
    ,nx_year_obtain_emply_number -- 上年度从业人数
    ,th_year_scen_tech_person_num -- 本年度科技人员人数
    ,nx_year_scen_tech_person_num -- 上年度科技人员人数
    ,th_year_degree_resdev_amt -- 本年度研发费用金额
    ,nx_year_resdev_fee_amt -- 上年度研发费用金额
    ,th_year_gover_subsidy_inco -- 本年度企业获取政府补贴收入
    ,nx_year_gover_subsidy_inco -- 上年度企业获取政府补贴收入
    ,pre_scd_year_sales_qtty -- 预测次年销售量
    ,other_chn_provi_oper_cap -- 其他渠道提供的运营资金
    ,crdtc_not_embody_liab_bal -- 征信未体现的负债余额
    ,crdtc_not_mon_second_marke -- 征信未体现的月还款额
    ,corp_mon_second_marke -- 企业月还款额
    ,corp_acct_recvbl_inpwn_flg -- 企业应收账款质押标志
    ,acct_recvbl_inpwn_loan_amt -- 应收账款质押贷款金额
    ,intel_prop_inpwn_flg -- 知识产权质押标志
    ,intel_prop_inpwn_loan_amt -- 知识产权质押贷款金额
    ,share_right_inpwn_flg -- 股权质押标志
    ,share_right_inpwn_loan_amt -- 股权质押贷款金额
    ,crdtc_inquirer_idti_cd -- 征信查询人身份代码
    ,que_appl_type_cd -- 查询申请类型代码
    ,data_src_cd -- 数据来源代码
    ,auth_dt -- 授权日期
    ,auth_effect_dt -- 授权生效日期
    ,auth_invalid_dt -- 授权失效日期
    ,hxb_rela_ps_flg -- 我行关联人标志
    ,corp_cust_id -- 企业客户编号
    ,flow_status_cd -- 流程状态代码
    ,task_status_cd -- 任务状态代码
    ,apv_status_cd -- 审批状态代码
    ,apv_lmt -- 审批额度
    ,warn_info -- 预警信息
    ,tax_type_cd -- 涉税类型代码
    ,tax_que_auth_flow_num -- 税务查询授权流水号
    ,tax_num -- 纳税人识别号
    ,tax_auth_sucs_flg -- 广税授权成功标志
    ,apv_appl_dt -- 审批申请日期
    ,apv_end_dt -- 审批结束日期
    ,corp_new_flg -- 企业专精特新标志
    ,refuse_rs -- 拒绝原因
    ,hxb_rela_corp_flg -- 我行关联企业标志
    ,rg_lon_flg -- 园区贷标志
    ,advise_flg -- 通知展业标志
    ,outline_flg -- 线下标志
    ,lmt_appl_flow_num -- 授信申请流水号
    ,cust_mgr_id -- 客户经理编号
    ,belong_brch_org_id -- 所属分行机构编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,update_org_id -- 更新机构编号
    ,update_teller_id -- 更新柜员编号
    ,up_date -- 更新日期
    ,auth_way_cd -- 授权方式代码
    ,biome_trics_cd -- 生物识别技术代码
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_appl_xked_attach_info_h_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,prod_abbr -- 产品简称
    ,appl_amt -- 申请金额
    ,loan_tenor -- 贷款期限
    ,main_guar_way_cd -- 主担保方式代码
    ,lmt_circl_flg -- 额度循环标志
    ,corp_name -- 企业名称
    ,corp_cert_type_cd -- 企业证件类型代码
    ,corp_cert_no -- 企业证件号码
    ,corp_cert_exp_dt -- 企业证件到期日期
    ,corp_mang_range -- 企业经营范围
    ,corp_mang_begin_dt -- 企业经营起始日期
    ,corp_mang_exp_dt -- 企业经营到期日期
    ,corp_found_dt -- 企业成立日期
    ,score_val -- 评分分值
    ,mang_local_prov_cd -- 经营所在省级代码
    ,mang_local_city_cd -- 经营所在市级代码
    ,mang_site_cd -- 经营所在地区代码
    ,mang_addr -- 经营地址
    ,actl_ctrler_work_years -- 实控人从业年限
    ,flow_calcu_year_sell_inco -- 流水推算年销售收入
    ,tech_inovt_corp_type_cd -- 科创企业类型代码
    ,corp_solft_coprit_affi_cnt -- 企业软著登记公告次数
    ,corp_intel_prop_qtty -- 企业知识产权数量
    ,intel_prop_invent_qtty -- 知识产权发明数量
    ,intgd_ciut_design_appl_qtty -- 集成电路布图设计申请数量
    ,intel_prop_tort_punish_cnt -- 知识产权侵权处罚次数
    ,int_prop_unfair_comption_cnt -- 知识产权不正当竞争次数
    ,intel_prop_judge_dfndn_cnt -- 知识产权裁判文书被告次数
    ,m24_ups_bf_5_purchs_amt -- 近24个月上游前5大采购金额
    ,m24_ups_purchs_amt -- 近24个月上游整体采购金额
    ,m24_dos_bf_5_sell_amt -- 近24个月下游前5大销售金额
    ,m24_dos_sell_amt -- 近24个月下游整体销售金额
    ,m12_ias_provi_bf10_tran_amt -- 近12个月重要稳定供应商（前十）交易金额
    ,m12_i_provi_bf10_tran_amt -- 近12个月重要稳定客户（前十）交易金额
    ,m24_open_invoice_inco -- 近24个月开票收入
    ,th_year_max_new_tech_inco -- 本年度高新技术产品（服务）收入
    ,nx_year_max_new_tech_inco -- 上年度高新技术产品（服务）收入
    ,th_year_degree_bus_inco -- 本年度营业收入
    ,th_year_degree_workr_num -- 本年度从业人数
    ,nx_year_obtain_emply_number -- 上年度从业人数
    ,th_year_scen_tech_person_num -- 本年度科技人员人数
    ,nx_year_scen_tech_person_num -- 上年度科技人员人数
    ,th_year_degree_resdev_amt -- 本年度研发费用金额
    ,nx_year_resdev_fee_amt -- 上年度研发费用金额
    ,th_year_gover_subsidy_inco -- 本年度企业获取政府补贴收入
    ,nx_year_gover_subsidy_inco -- 上年度企业获取政府补贴收入
    ,pre_scd_year_sales_qtty -- 预测次年销售量
    ,other_chn_provi_oper_cap -- 其他渠道提供的运营资金
    ,crdtc_not_embody_liab_bal -- 征信未体现的负债余额
    ,crdtc_not_mon_second_marke -- 征信未体现的月还款额
    ,corp_mon_second_marke -- 企业月还款额
    ,corp_acct_recvbl_inpwn_flg -- 企业应收账款质押标志
    ,acct_recvbl_inpwn_loan_amt -- 应收账款质押贷款金额
    ,intel_prop_inpwn_flg -- 知识产权质押标志
    ,intel_prop_inpwn_loan_amt -- 知识产权质押贷款金额
    ,share_right_inpwn_flg -- 股权质押标志
    ,share_right_inpwn_loan_amt -- 股权质押贷款金额
    ,crdtc_inquirer_idti_cd -- 征信查询人身份代码
    ,que_appl_type_cd -- 查询申请类型代码
    ,data_src_cd -- 数据来源代码
    ,auth_dt -- 授权日期
    ,auth_effect_dt -- 授权生效日期
    ,auth_invalid_dt -- 授权失效日期
    ,hxb_rela_ps_flg -- 我行关联人标志
    ,corp_cust_id -- 企业客户编号
    ,flow_status_cd -- 流程状态代码
    ,task_status_cd -- 任务状态代码
    ,apv_status_cd -- 审批状态代码
    ,apv_lmt -- 审批额度
    ,warn_info -- 预警信息
    ,tax_type_cd -- 涉税类型代码
    ,tax_que_auth_flow_num -- 税务查询授权流水号
    ,tax_num -- 纳税人识别号
    ,tax_auth_sucs_flg -- 广税授权成功标志
    ,apv_appl_dt -- 审批申请日期
    ,apv_end_dt -- 审批结束日期
    ,corp_new_flg -- 企业专精特新标志
    ,refuse_rs -- 拒绝原因
    ,hxb_rela_corp_flg -- 我行关联企业标志
    ,rg_lon_flg -- 园区贷标志
    ,advise_flg -- 通知展业标志
    ,outline_flg -- 线下标志
    ,lmt_appl_flow_num -- 授信申请流水号
    ,cust_mgr_id -- 客户经理编号
    ,belong_brch_org_id -- 所属分行机构编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,update_org_id -- 更新机构编号
    ,update_teller_id -- 更新柜员编号
    ,up_date -- 更新日期
    ,auth_way_cd -- 授权方式代码
    ,biome_trics_cd -- 生物识别技术代码
    ,remark -- 备注
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
    ,nvl(n.crdt_appl_flow_num, o.crdt_appl_flow_num) as crdt_appl_flow_num -- 信贷申请流水号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.prod_abbr, o.prod_abbr) as prod_abbr -- 产品简称
    ,nvl(n.appl_amt, o.appl_amt) as appl_amt -- 申请金额
    ,nvl(n.loan_tenor, o.loan_tenor) as loan_tenor -- 贷款期限
    ,nvl(n.main_guar_way_cd, o.main_guar_way_cd) as main_guar_way_cd -- 主担保方式代码
    ,nvl(n.lmt_circl_flg, o.lmt_circl_flg) as lmt_circl_flg -- 额度循环标志
    ,nvl(n.corp_name, o.corp_name) as corp_name -- 企业名称
    ,nvl(n.corp_cert_type_cd, o.corp_cert_type_cd) as corp_cert_type_cd -- 企业证件类型代码
    ,nvl(n.corp_cert_no, o.corp_cert_no) as corp_cert_no -- 企业证件号码
    ,nvl(n.corp_cert_exp_dt, o.corp_cert_exp_dt) as corp_cert_exp_dt -- 企业证件到期日期
    ,nvl(n.corp_mang_range, o.corp_mang_range) as corp_mang_range -- 企业经营范围
    ,nvl(n.corp_mang_begin_dt, o.corp_mang_begin_dt) as corp_mang_begin_dt -- 企业经营起始日期
    ,nvl(n.corp_mang_exp_dt, o.corp_mang_exp_dt) as corp_mang_exp_dt -- 企业经营到期日期
    ,nvl(n.corp_found_dt, o.corp_found_dt) as corp_found_dt -- 企业成立日期
    ,nvl(n.score_val, o.score_val) as score_val -- 评分分值
    ,nvl(n.mang_local_prov_cd, o.mang_local_prov_cd) as mang_local_prov_cd -- 经营所在省级代码
    ,nvl(n.mang_local_city_cd, o.mang_local_city_cd) as mang_local_city_cd -- 经营所在市级代码
    ,nvl(n.mang_site_cd, o.mang_site_cd) as mang_site_cd -- 经营所在地区代码
    ,nvl(n.mang_addr, o.mang_addr) as mang_addr -- 经营地址
    ,nvl(n.actl_ctrler_work_years, o.actl_ctrler_work_years) as actl_ctrler_work_years -- 实控人从业年限
    ,nvl(n.flow_calcu_year_sell_inco, o.flow_calcu_year_sell_inco) as flow_calcu_year_sell_inco -- 流水推算年销售收入
    ,nvl(n.tech_inovt_corp_type_cd, o.tech_inovt_corp_type_cd) as tech_inovt_corp_type_cd -- 科创企业类型代码
    ,nvl(n.corp_solft_coprit_affi_cnt, o.corp_solft_coprit_affi_cnt) as corp_solft_coprit_affi_cnt -- 企业软著登记公告次数
    ,nvl(n.corp_intel_prop_qtty, o.corp_intel_prop_qtty) as corp_intel_prop_qtty -- 企业知识产权数量
    ,nvl(n.intel_prop_invent_qtty, o.intel_prop_invent_qtty) as intel_prop_invent_qtty -- 知识产权发明数量
    ,nvl(n.intgd_ciut_design_appl_qtty, o.intgd_ciut_design_appl_qtty) as intgd_ciut_design_appl_qtty -- 集成电路布图设计申请数量
    ,nvl(n.intel_prop_tort_punish_cnt, o.intel_prop_tort_punish_cnt) as intel_prop_tort_punish_cnt -- 知识产权侵权处罚次数
    ,nvl(n.int_prop_unfair_comption_cnt, o.int_prop_unfair_comption_cnt) as int_prop_unfair_comption_cnt -- 知识产权不正当竞争次数
    ,nvl(n.intel_prop_judge_dfndn_cnt, o.intel_prop_judge_dfndn_cnt) as intel_prop_judge_dfndn_cnt -- 知识产权裁判文书被告次数
    ,nvl(n.m24_ups_bf_5_purchs_amt, o.m24_ups_bf_5_purchs_amt) as m24_ups_bf_5_purchs_amt -- 近24个月上游前5大采购金额
    ,nvl(n.m24_ups_purchs_amt, o.m24_ups_purchs_amt) as m24_ups_purchs_amt -- 近24个月上游整体采购金额
    ,nvl(n.m24_dos_bf_5_sell_amt, o.m24_dos_bf_5_sell_amt) as m24_dos_bf_5_sell_amt -- 近24个月下游前5大销售金额
    ,nvl(n.m24_dos_sell_amt, o.m24_dos_sell_amt) as m24_dos_sell_amt -- 近24个月下游整体销售金额
    ,nvl(n.m12_ias_provi_bf10_tran_amt, o.m12_ias_provi_bf10_tran_amt) as m12_ias_provi_bf10_tran_amt -- 近12个月重要稳定供应商（前十）交易金额
    ,nvl(n.m12_i_provi_bf10_tran_amt, o.m12_i_provi_bf10_tran_amt) as m12_i_provi_bf10_tran_amt -- 近12个月重要稳定客户（前十）交易金额
    ,nvl(n.m24_open_invoice_inco, o.m24_open_invoice_inco) as m24_open_invoice_inco -- 近24个月开票收入
    ,nvl(n.th_year_max_new_tech_inco, o.th_year_max_new_tech_inco) as th_year_max_new_tech_inco -- 本年度高新技术产品（服务）收入
    ,nvl(n.nx_year_max_new_tech_inco, o.nx_year_max_new_tech_inco) as nx_year_max_new_tech_inco -- 上年度高新技术产品（服务）收入
    ,nvl(n.th_year_degree_bus_inco, o.th_year_degree_bus_inco) as th_year_degree_bus_inco -- 本年度营业收入
    ,nvl(n.th_year_degree_workr_num, o.th_year_degree_workr_num) as th_year_degree_workr_num -- 本年度从业人数
    ,nvl(n.nx_year_obtain_emply_number, o.nx_year_obtain_emply_number) as nx_year_obtain_emply_number -- 上年度从业人数
    ,nvl(n.th_year_scen_tech_person_num, o.th_year_scen_tech_person_num) as th_year_scen_tech_person_num -- 本年度科技人员人数
    ,nvl(n.nx_year_scen_tech_person_num, o.nx_year_scen_tech_person_num) as nx_year_scen_tech_person_num -- 上年度科技人员人数
    ,nvl(n.th_year_degree_resdev_amt, o.th_year_degree_resdev_amt) as th_year_degree_resdev_amt -- 本年度研发费用金额
    ,nvl(n.nx_year_resdev_fee_amt, o.nx_year_resdev_fee_amt) as nx_year_resdev_fee_amt -- 上年度研发费用金额
    ,nvl(n.th_year_gover_subsidy_inco, o.th_year_gover_subsidy_inco) as th_year_gover_subsidy_inco -- 本年度企业获取政府补贴收入
    ,nvl(n.nx_year_gover_subsidy_inco, o.nx_year_gover_subsidy_inco) as nx_year_gover_subsidy_inco -- 上年度企业获取政府补贴收入
    ,nvl(n.pre_scd_year_sales_qtty, o.pre_scd_year_sales_qtty) as pre_scd_year_sales_qtty -- 预测次年销售量
    ,nvl(n.other_chn_provi_oper_cap, o.other_chn_provi_oper_cap) as other_chn_provi_oper_cap -- 其他渠道提供的运营资金
    ,nvl(n.crdtc_not_embody_liab_bal, o.crdtc_not_embody_liab_bal) as crdtc_not_embody_liab_bal -- 征信未体现的负债余额
    ,nvl(n.crdtc_not_mon_second_marke, o.crdtc_not_mon_second_marke) as crdtc_not_mon_second_marke -- 征信未体现的月还款额
    ,nvl(n.corp_mon_second_marke, o.corp_mon_second_marke) as corp_mon_second_marke -- 企业月还款额
    ,nvl(n.corp_acct_recvbl_inpwn_flg, o.corp_acct_recvbl_inpwn_flg) as corp_acct_recvbl_inpwn_flg -- 企业应收账款质押标志
    ,nvl(n.acct_recvbl_inpwn_loan_amt, o.acct_recvbl_inpwn_loan_amt) as acct_recvbl_inpwn_loan_amt -- 应收账款质押贷款金额
    ,nvl(n.intel_prop_inpwn_flg, o.intel_prop_inpwn_flg) as intel_prop_inpwn_flg -- 知识产权质押标志
    ,nvl(n.intel_prop_inpwn_loan_amt, o.intel_prop_inpwn_loan_amt) as intel_prop_inpwn_loan_amt -- 知识产权质押贷款金额
    ,nvl(n.share_right_inpwn_flg, o.share_right_inpwn_flg) as share_right_inpwn_flg -- 股权质押标志
    ,nvl(n.share_right_inpwn_loan_amt, o.share_right_inpwn_loan_amt) as share_right_inpwn_loan_amt -- 股权质押贷款金额
    ,nvl(n.crdtc_inquirer_idti_cd, o.crdtc_inquirer_idti_cd) as crdtc_inquirer_idti_cd -- 征信查询人身份代码
    ,nvl(n.que_appl_type_cd, o.que_appl_type_cd) as que_appl_type_cd -- 查询申请类型代码
    ,nvl(n.data_src_cd, o.data_src_cd) as data_src_cd -- 数据来源代码
    ,nvl(n.auth_dt, o.auth_dt) as auth_dt -- 授权日期
    ,nvl(n.auth_effect_dt, o.auth_effect_dt) as auth_effect_dt -- 授权生效日期
    ,nvl(n.auth_invalid_dt, o.auth_invalid_dt) as auth_invalid_dt -- 授权失效日期
    ,nvl(n.hxb_rela_ps_flg, o.hxb_rela_ps_flg) as hxb_rela_ps_flg -- 我行关联人标志
    ,nvl(n.corp_cust_id, o.corp_cust_id) as corp_cust_id -- 企业客户编号
    ,nvl(n.flow_status_cd, o.flow_status_cd) as flow_status_cd -- 流程状态代码
    ,nvl(n.task_status_cd, o.task_status_cd) as task_status_cd -- 任务状态代码
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.apv_lmt, o.apv_lmt) as apv_lmt -- 审批额度
    ,nvl(n.warn_info, o.warn_info) as warn_info -- 预警信息
    ,nvl(n.tax_type_cd, o.tax_type_cd) as tax_type_cd -- 涉税类型代码
    ,nvl(n.tax_que_auth_flow_num, o.tax_que_auth_flow_num) as tax_que_auth_flow_num -- 税务查询授权流水号
    ,nvl(n.tax_num, o.tax_num) as tax_num -- 纳税人识别号
    ,nvl(n.tax_auth_sucs_flg, o.tax_auth_sucs_flg) as tax_auth_sucs_flg -- 广税授权成功标志
    ,nvl(n.apv_appl_dt, o.apv_appl_dt) as apv_appl_dt -- 审批申请日期
    ,nvl(n.apv_end_dt, o.apv_end_dt) as apv_end_dt -- 审批结束日期
    ,nvl(n.corp_new_flg, o.corp_new_flg) as corp_new_flg -- 企业专精特新标志
    ,nvl(n.refuse_rs, o.refuse_rs) as refuse_rs -- 拒绝原因
    ,nvl(n.hxb_rela_corp_flg, o.hxb_rela_corp_flg) as hxb_rela_corp_flg -- 我行关联企业标志
    ,nvl(n.rg_lon_flg, o.rg_lon_flg) as rg_lon_flg -- 园区贷标志
    ,nvl(n.advise_flg, o.advise_flg) as advise_flg -- 通知展业标志
    ,nvl(n.outline_flg, o.outline_flg) as outline_flg -- 线下标志
    ,nvl(n.lmt_appl_flow_num, o.lmt_appl_flow_num) as lmt_appl_flow_num -- 授信申请流水号
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.belong_brch_org_id, o.belong_brch_org_id) as belong_brch_org_id -- 所属分行机构编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.up_date, o.up_date) as up_date -- 更新日期
    ,nvl(n.auth_way_cd, o.auth_way_cd) as auth_way_cd -- 授权方式代码
    ,nvl(n.biome_trics_cd, o.biome_trics_cd) as biome_trics_cd -- 生物识别技术代码
    ,nvl(n.remark, o.remark) as remark -- 备注
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
from ${iml_schema}.agt_loan_appl_xked_attach_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_appl_xked_attach_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.appl_flow_num <> n.appl_flow_num
        or o.crdt_appl_flow_num <> n.crdt_appl_flow_num
        or o.prod_id <> n.prod_id
        or o.prod_name <> n.prod_name
        or o.prod_abbr <> n.prod_abbr
        or o.appl_amt <> n.appl_amt
        or o.loan_tenor <> n.loan_tenor
        or o.main_guar_way_cd <> n.main_guar_way_cd
        or o.lmt_circl_flg <> n.lmt_circl_flg
        or o.corp_name <> n.corp_name
        or o.corp_cert_type_cd <> n.corp_cert_type_cd
        or o.corp_cert_no <> n.corp_cert_no
        or o.corp_cert_exp_dt <> n.corp_cert_exp_dt
        or o.corp_mang_range <> n.corp_mang_range
        or o.corp_mang_begin_dt <> n.corp_mang_begin_dt
        or o.corp_mang_exp_dt <> n.corp_mang_exp_dt
        or o.corp_found_dt <> n.corp_found_dt
        or o.score_val <> n.score_val
        or o.mang_local_prov_cd <> n.mang_local_prov_cd
        or o.mang_local_city_cd <> n.mang_local_city_cd
        or o.mang_site_cd <> n.mang_site_cd
        or o.mang_addr <> n.mang_addr
        or o.actl_ctrler_work_years <> n.actl_ctrler_work_years
        or o.flow_calcu_year_sell_inco <> n.flow_calcu_year_sell_inco
        or o.tech_inovt_corp_type_cd <> n.tech_inovt_corp_type_cd
        or o.corp_solft_coprit_affi_cnt <> n.corp_solft_coprit_affi_cnt
        or o.corp_intel_prop_qtty <> n.corp_intel_prop_qtty
        or o.intel_prop_invent_qtty <> n.intel_prop_invent_qtty
        or o.intgd_ciut_design_appl_qtty <> n.intgd_ciut_design_appl_qtty
        or o.intel_prop_tort_punish_cnt <> n.intel_prop_tort_punish_cnt
        or o.int_prop_unfair_comption_cnt <> n.int_prop_unfair_comption_cnt
        or o.intel_prop_judge_dfndn_cnt <> n.intel_prop_judge_dfndn_cnt
        or o.m24_ups_bf_5_purchs_amt <> n.m24_ups_bf_5_purchs_amt
        or o.m24_ups_purchs_amt <> n.m24_ups_purchs_amt
        or o.m24_dos_bf_5_sell_amt <> n.m24_dos_bf_5_sell_amt
        or o.m24_dos_sell_amt <> n.m24_dos_sell_amt
        or o.m12_ias_provi_bf10_tran_amt <> n.m12_ias_provi_bf10_tran_amt
        or o.m12_i_provi_bf10_tran_amt <> n.m12_i_provi_bf10_tran_amt
        or o.m24_open_invoice_inco <> n.m24_open_invoice_inco
        or o.th_year_max_new_tech_inco <> n.th_year_max_new_tech_inco
        or o.nx_year_max_new_tech_inco <> n.nx_year_max_new_tech_inco
        or o.th_year_degree_bus_inco <> n.th_year_degree_bus_inco
        or o.th_year_degree_workr_num <> n.th_year_degree_workr_num
        or o.nx_year_obtain_emply_number <> n.nx_year_obtain_emply_number
        or o.th_year_scen_tech_person_num <> n.th_year_scen_tech_person_num
        or o.nx_year_scen_tech_person_num <> n.nx_year_scen_tech_person_num
        or o.th_year_degree_resdev_amt <> n.th_year_degree_resdev_amt
        or o.nx_year_resdev_fee_amt <> n.nx_year_resdev_fee_amt
        or o.th_year_gover_subsidy_inco <> n.th_year_gover_subsidy_inco
        or o.nx_year_gover_subsidy_inco <> n.nx_year_gover_subsidy_inco
        or o.pre_scd_year_sales_qtty <> n.pre_scd_year_sales_qtty
        or o.other_chn_provi_oper_cap <> n.other_chn_provi_oper_cap
        or o.crdtc_not_embody_liab_bal <> n.crdtc_not_embody_liab_bal
        or o.crdtc_not_mon_second_marke <> n.crdtc_not_mon_second_marke
        or o.corp_mon_second_marke <> n.corp_mon_second_marke
        or o.corp_acct_recvbl_inpwn_flg <> n.corp_acct_recvbl_inpwn_flg
        or o.acct_recvbl_inpwn_loan_amt <> n.acct_recvbl_inpwn_loan_amt
        or o.intel_prop_inpwn_flg <> n.intel_prop_inpwn_flg
        or o.intel_prop_inpwn_loan_amt <> n.intel_prop_inpwn_loan_amt
        or o.share_right_inpwn_flg <> n.share_right_inpwn_flg
        or o.share_right_inpwn_loan_amt <> n.share_right_inpwn_loan_amt
        or o.crdtc_inquirer_idti_cd <> n.crdtc_inquirer_idti_cd
        or o.que_appl_type_cd <> n.que_appl_type_cd
        or o.data_src_cd <> n.data_src_cd
        or o.auth_dt <> n.auth_dt
        or o.auth_effect_dt <> n.auth_effect_dt
        or o.auth_invalid_dt <> n.auth_invalid_dt
        or o.hxb_rela_ps_flg <> n.hxb_rela_ps_flg
        or o.corp_cust_id <> n.corp_cust_id
        or o.flow_status_cd <> n.flow_status_cd
        or o.task_status_cd <> n.task_status_cd
        or o.apv_status_cd <> n.apv_status_cd
        or o.apv_lmt <> n.apv_lmt
        or o.warn_info <> n.warn_info
        or o.tax_type_cd <> n.tax_type_cd
        or o.tax_que_auth_flow_num <> n.tax_que_auth_flow_num
        or o.tax_num <> n.tax_num
        or o.tax_auth_sucs_flg <> n.tax_auth_sucs_flg
        or o.apv_appl_dt <> n.apv_appl_dt
        or o.apv_end_dt <> n.apv_end_dt
        or o.corp_new_flg <> n.corp_new_flg
        or o.refuse_rs <> n.refuse_rs
        or o.hxb_rela_corp_flg <> n.hxb_rela_corp_flg
        or o.rg_lon_flg <> n.rg_lon_flg
        or o.advise_flg <> n.advise_flg
        or o.outline_flg <> n.outline_flg
        or o.lmt_appl_flow_num <> n.lmt_appl_flow_num
        or o.cust_mgr_id <> n.cust_mgr_id
        or o.belong_brch_org_id <> n.belong_brch_org_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.update_org_id <> n.update_org_id
        or o.update_teller_id <> n.update_teller_id
        or o.up_date <> n.up_date
        or o.auth_way_cd <> n.auth_way_cd
        or o.biome_trics_cd <> n.biome_trics_cd
        or o.remark <> n.remark
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_appl_xked_attach_info_h_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,prod_abbr -- 产品简称
    ,appl_amt -- 申请金额
    ,loan_tenor -- 贷款期限
    ,main_guar_way_cd -- 主担保方式代码
    ,lmt_circl_flg -- 额度循环标志
    ,corp_name -- 企业名称
    ,corp_cert_type_cd -- 企业证件类型代码
    ,corp_cert_no -- 企业证件号码
    ,corp_cert_exp_dt -- 企业证件到期日期
    ,corp_mang_range -- 企业经营范围
    ,corp_mang_begin_dt -- 企业经营起始日期
    ,corp_mang_exp_dt -- 企业经营到期日期
    ,corp_found_dt -- 企业成立日期
    ,score_val -- 评分分值
    ,mang_local_prov_cd -- 经营所在省级代码
    ,mang_local_city_cd -- 经营所在市级代码
    ,mang_site_cd -- 经营所在地区代码
    ,mang_addr -- 经营地址
    ,actl_ctrler_work_years -- 实控人从业年限
    ,flow_calcu_year_sell_inco -- 流水推算年销售收入
    ,tech_inovt_corp_type_cd -- 科创企业类型代码
    ,corp_solft_coprit_affi_cnt -- 企业软著登记公告次数
    ,corp_intel_prop_qtty -- 企业知识产权数量
    ,intel_prop_invent_qtty -- 知识产权发明数量
    ,intgd_ciut_design_appl_qtty -- 集成电路布图设计申请数量
    ,intel_prop_tort_punish_cnt -- 知识产权侵权处罚次数
    ,int_prop_unfair_comption_cnt -- 知识产权不正当竞争次数
    ,intel_prop_judge_dfndn_cnt -- 知识产权裁判文书被告次数
    ,m24_ups_bf_5_purchs_amt -- 近24个月上游前5大采购金额
    ,m24_ups_purchs_amt -- 近24个月上游整体采购金额
    ,m24_dos_bf_5_sell_amt -- 近24个月下游前5大销售金额
    ,m24_dos_sell_amt -- 近24个月下游整体销售金额
    ,m12_ias_provi_bf10_tran_amt -- 近12个月重要稳定供应商（前十）交易金额
    ,m12_i_provi_bf10_tran_amt -- 近12个月重要稳定客户（前十）交易金额
    ,m24_open_invoice_inco -- 近24个月开票收入
    ,th_year_max_new_tech_inco -- 本年度高新技术产品（服务）收入
    ,nx_year_max_new_tech_inco -- 上年度高新技术产品（服务）收入
    ,th_year_degree_bus_inco -- 本年度营业收入
    ,th_year_degree_workr_num -- 本年度从业人数
    ,nx_year_obtain_emply_number -- 上年度从业人数
    ,th_year_scen_tech_person_num -- 本年度科技人员人数
    ,nx_year_scen_tech_person_num -- 上年度科技人员人数
    ,th_year_degree_resdev_amt -- 本年度研发费用金额
    ,nx_year_resdev_fee_amt -- 上年度研发费用金额
    ,th_year_gover_subsidy_inco -- 本年度企业获取政府补贴收入
    ,nx_year_gover_subsidy_inco -- 上年度企业获取政府补贴收入
    ,pre_scd_year_sales_qtty -- 预测次年销售量
    ,other_chn_provi_oper_cap -- 其他渠道提供的运营资金
    ,crdtc_not_embody_liab_bal -- 征信未体现的负债余额
    ,crdtc_not_mon_second_marke -- 征信未体现的月还款额
    ,corp_mon_second_marke -- 企业月还款额
    ,corp_acct_recvbl_inpwn_flg -- 企业应收账款质押标志
    ,acct_recvbl_inpwn_loan_amt -- 应收账款质押贷款金额
    ,intel_prop_inpwn_flg -- 知识产权质押标志
    ,intel_prop_inpwn_loan_amt -- 知识产权质押贷款金额
    ,share_right_inpwn_flg -- 股权质押标志
    ,share_right_inpwn_loan_amt -- 股权质押贷款金额
    ,crdtc_inquirer_idti_cd -- 征信查询人身份代码
    ,que_appl_type_cd -- 查询申请类型代码
    ,data_src_cd -- 数据来源代码
    ,auth_dt -- 授权日期
    ,auth_effect_dt -- 授权生效日期
    ,auth_invalid_dt -- 授权失效日期
    ,hxb_rela_ps_flg -- 我行关联人标志
    ,corp_cust_id -- 企业客户编号
    ,flow_status_cd -- 流程状态代码
    ,task_status_cd -- 任务状态代码
    ,apv_status_cd -- 审批状态代码
    ,apv_lmt -- 审批额度
    ,warn_info -- 预警信息
    ,tax_type_cd -- 涉税类型代码
    ,tax_que_auth_flow_num -- 税务查询授权流水号
    ,tax_num -- 纳税人识别号
    ,tax_auth_sucs_flg -- 广税授权成功标志
    ,apv_appl_dt -- 审批申请日期
    ,apv_end_dt -- 审批结束日期
    ,corp_new_flg -- 企业专精特新标志
    ,refuse_rs -- 拒绝原因
    ,hxb_rela_corp_flg -- 我行关联企业标志
    ,rg_lon_flg -- 园区贷标志
    ,advise_flg -- 通知展业标志
    ,outline_flg -- 线下标志
    ,lmt_appl_flow_num -- 授信申请流水号
    ,cust_mgr_id -- 客户经理编号
    ,belong_brch_org_id -- 所属分行机构编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,update_org_id -- 更新机构编号
    ,update_teller_id -- 更新柜员编号
    ,up_date -- 更新日期
    ,auth_way_cd -- 授权方式代码
    ,biome_trics_cd -- 生物识别技术代码
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_appl_xked_attach_info_h_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,prod_abbr -- 产品简称
    ,appl_amt -- 申请金额
    ,loan_tenor -- 贷款期限
    ,main_guar_way_cd -- 主担保方式代码
    ,lmt_circl_flg -- 额度循环标志
    ,corp_name -- 企业名称
    ,corp_cert_type_cd -- 企业证件类型代码
    ,corp_cert_no -- 企业证件号码
    ,corp_cert_exp_dt -- 企业证件到期日期
    ,corp_mang_range -- 企业经营范围
    ,corp_mang_begin_dt -- 企业经营起始日期
    ,corp_mang_exp_dt -- 企业经营到期日期
    ,corp_found_dt -- 企业成立日期
    ,score_val -- 评分分值
    ,mang_local_prov_cd -- 经营所在省级代码
    ,mang_local_city_cd -- 经营所在市级代码
    ,mang_site_cd -- 经营所在地区代码
    ,mang_addr -- 经营地址
    ,actl_ctrler_work_years -- 实控人从业年限
    ,flow_calcu_year_sell_inco -- 流水推算年销售收入
    ,tech_inovt_corp_type_cd -- 科创企业类型代码
    ,corp_solft_coprit_affi_cnt -- 企业软著登记公告次数
    ,corp_intel_prop_qtty -- 企业知识产权数量
    ,intel_prop_invent_qtty -- 知识产权发明数量
    ,intgd_ciut_design_appl_qtty -- 集成电路布图设计申请数量
    ,intel_prop_tort_punish_cnt -- 知识产权侵权处罚次数
    ,int_prop_unfair_comption_cnt -- 知识产权不正当竞争次数
    ,intel_prop_judge_dfndn_cnt -- 知识产权裁判文书被告次数
    ,m24_ups_bf_5_purchs_amt -- 近24个月上游前5大采购金额
    ,m24_ups_purchs_amt -- 近24个月上游整体采购金额
    ,m24_dos_bf_5_sell_amt -- 近24个月下游前5大销售金额
    ,m24_dos_sell_amt -- 近24个月下游整体销售金额
    ,m12_ias_provi_bf10_tran_amt -- 近12个月重要稳定供应商（前十）交易金额
    ,m12_i_provi_bf10_tran_amt -- 近12个月重要稳定客户（前十）交易金额
    ,m24_open_invoice_inco -- 近24个月开票收入
    ,th_year_max_new_tech_inco -- 本年度高新技术产品（服务）收入
    ,nx_year_max_new_tech_inco -- 上年度高新技术产品（服务）收入
    ,th_year_degree_bus_inco -- 本年度营业收入
    ,th_year_degree_workr_num -- 本年度从业人数
    ,nx_year_obtain_emply_number -- 上年度从业人数
    ,th_year_scen_tech_person_num -- 本年度科技人员人数
    ,nx_year_scen_tech_person_num -- 上年度科技人员人数
    ,th_year_degree_resdev_amt -- 本年度研发费用金额
    ,nx_year_resdev_fee_amt -- 上年度研发费用金额
    ,th_year_gover_subsidy_inco -- 本年度企业获取政府补贴收入
    ,nx_year_gover_subsidy_inco -- 上年度企业获取政府补贴收入
    ,pre_scd_year_sales_qtty -- 预测次年销售量
    ,other_chn_provi_oper_cap -- 其他渠道提供的运营资金
    ,crdtc_not_embody_liab_bal -- 征信未体现的负债余额
    ,crdtc_not_mon_second_marke -- 征信未体现的月还款额
    ,corp_mon_second_marke -- 企业月还款额
    ,corp_acct_recvbl_inpwn_flg -- 企业应收账款质押标志
    ,acct_recvbl_inpwn_loan_amt -- 应收账款质押贷款金额
    ,intel_prop_inpwn_flg -- 知识产权质押标志
    ,intel_prop_inpwn_loan_amt -- 知识产权质押贷款金额
    ,share_right_inpwn_flg -- 股权质押标志
    ,share_right_inpwn_loan_amt -- 股权质押贷款金额
    ,crdtc_inquirer_idti_cd -- 征信查询人身份代码
    ,que_appl_type_cd -- 查询申请类型代码
    ,data_src_cd -- 数据来源代码
    ,auth_dt -- 授权日期
    ,auth_effect_dt -- 授权生效日期
    ,auth_invalid_dt -- 授权失效日期
    ,hxb_rela_ps_flg -- 我行关联人标志
    ,corp_cust_id -- 企业客户编号
    ,flow_status_cd -- 流程状态代码
    ,task_status_cd -- 任务状态代码
    ,apv_status_cd -- 审批状态代码
    ,apv_lmt -- 审批额度
    ,warn_info -- 预警信息
    ,tax_type_cd -- 涉税类型代码
    ,tax_que_auth_flow_num -- 税务查询授权流水号
    ,tax_num -- 纳税人识别号
    ,tax_auth_sucs_flg -- 广税授权成功标志
    ,apv_appl_dt -- 审批申请日期
    ,apv_end_dt -- 审批结束日期
    ,corp_new_flg -- 企业专精特新标志
    ,refuse_rs -- 拒绝原因
    ,hxb_rela_corp_flg -- 我行关联企业标志
    ,rg_lon_flg -- 园区贷标志
    ,advise_flg -- 通知展业标志
    ,outline_flg -- 线下标志
    ,lmt_appl_flow_num -- 授信申请流水号
    ,cust_mgr_id -- 客户经理编号
    ,belong_brch_org_id -- 所属分行机构编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,update_org_id -- 更新机构编号
    ,update_teller_id -- 更新柜员编号
    ,up_date -- 更新日期
    ,auth_way_cd -- 授权方式代码
    ,biome_trics_cd -- 生物识别技术代码
    ,remark -- 备注
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
    ,o.crdt_appl_flow_num -- 信贷申请流水号
    ,o.prod_id -- 产品编号
    ,o.prod_name -- 产品名称
    ,o.prod_abbr -- 产品简称
    ,o.appl_amt -- 申请金额
    ,o.loan_tenor -- 贷款期限
    ,o.main_guar_way_cd -- 主担保方式代码
    ,o.lmt_circl_flg -- 额度循环标志
    ,o.corp_name -- 企业名称
    ,o.corp_cert_type_cd -- 企业证件类型代码
    ,o.corp_cert_no -- 企业证件号码
    ,o.corp_cert_exp_dt -- 企业证件到期日期
    ,o.corp_mang_range -- 企业经营范围
    ,o.corp_mang_begin_dt -- 企业经营起始日期
    ,o.corp_mang_exp_dt -- 企业经营到期日期
    ,o.corp_found_dt -- 企业成立日期
    ,o.score_val -- 评分分值
    ,o.mang_local_prov_cd -- 经营所在省级代码
    ,o.mang_local_city_cd -- 经营所在市级代码
    ,o.mang_site_cd -- 经营所在地区代码
    ,o.mang_addr -- 经营地址
    ,o.actl_ctrler_work_years -- 实控人从业年限
    ,o.flow_calcu_year_sell_inco -- 流水推算年销售收入
    ,o.tech_inovt_corp_type_cd -- 科创企业类型代码
    ,o.corp_solft_coprit_affi_cnt -- 企业软著登记公告次数
    ,o.corp_intel_prop_qtty -- 企业知识产权数量
    ,o.intel_prop_invent_qtty -- 知识产权发明数量
    ,o.intgd_ciut_design_appl_qtty -- 集成电路布图设计申请数量
    ,o.intel_prop_tort_punish_cnt -- 知识产权侵权处罚次数
    ,o.int_prop_unfair_comption_cnt -- 知识产权不正当竞争次数
    ,o.intel_prop_judge_dfndn_cnt -- 知识产权裁判文书被告次数
    ,o.m24_ups_bf_5_purchs_amt -- 近24个月上游前5大采购金额
    ,o.m24_ups_purchs_amt -- 近24个月上游整体采购金额
    ,o.m24_dos_bf_5_sell_amt -- 近24个月下游前5大销售金额
    ,o.m24_dos_sell_amt -- 近24个月下游整体销售金额
    ,o.m12_ias_provi_bf10_tran_amt -- 近12个月重要稳定供应商（前十）交易金额
    ,o.m12_i_provi_bf10_tran_amt -- 近12个月重要稳定客户（前十）交易金额
    ,o.m24_open_invoice_inco -- 近24个月开票收入
    ,o.th_year_max_new_tech_inco -- 本年度高新技术产品（服务）收入
    ,o.nx_year_max_new_tech_inco -- 上年度高新技术产品（服务）收入
    ,o.th_year_degree_bus_inco -- 本年度营业收入
    ,o.th_year_degree_workr_num -- 本年度从业人数
    ,o.nx_year_obtain_emply_number -- 上年度从业人数
    ,o.th_year_scen_tech_person_num -- 本年度科技人员人数
    ,o.nx_year_scen_tech_person_num -- 上年度科技人员人数
    ,o.th_year_degree_resdev_amt -- 本年度研发费用金额
    ,o.nx_year_resdev_fee_amt -- 上年度研发费用金额
    ,o.th_year_gover_subsidy_inco -- 本年度企业获取政府补贴收入
    ,o.nx_year_gover_subsidy_inco -- 上年度企业获取政府补贴收入
    ,o.pre_scd_year_sales_qtty -- 预测次年销售量
    ,o.other_chn_provi_oper_cap -- 其他渠道提供的运营资金
    ,o.crdtc_not_embody_liab_bal -- 征信未体现的负债余额
    ,o.crdtc_not_mon_second_marke -- 征信未体现的月还款额
    ,o.corp_mon_second_marke -- 企业月还款额
    ,o.corp_acct_recvbl_inpwn_flg -- 企业应收账款质押标志
    ,o.acct_recvbl_inpwn_loan_amt -- 应收账款质押贷款金额
    ,o.intel_prop_inpwn_flg -- 知识产权质押标志
    ,o.intel_prop_inpwn_loan_amt -- 知识产权质押贷款金额
    ,o.share_right_inpwn_flg -- 股权质押标志
    ,o.share_right_inpwn_loan_amt -- 股权质押贷款金额
    ,o.crdtc_inquirer_idti_cd -- 征信查询人身份代码
    ,o.que_appl_type_cd -- 查询申请类型代码
    ,o.data_src_cd -- 数据来源代码
    ,o.auth_dt -- 授权日期
    ,o.auth_effect_dt -- 授权生效日期
    ,o.auth_invalid_dt -- 授权失效日期
    ,o.hxb_rela_ps_flg -- 我行关联人标志
    ,o.corp_cust_id -- 企业客户编号
    ,o.flow_status_cd -- 流程状态代码
    ,o.task_status_cd -- 任务状态代码
    ,o.apv_status_cd -- 审批状态代码
    ,o.apv_lmt -- 审批额度
    ,o.warn_info -- 预警信息
    ,o.tax_type_cd -- 涉税类型代码
    ,o.tax_que_auth_flow_num -- 税务查询授权流水号
    ,o.tax_num -- 纳税人识别号
    ,o.tax_auth_sucs_flg -- 广税授权成功标志
    ,o.apv_appl_dt -- 审批申请日期
    ,o.apv_end_dt -- 审批结束日期
    ,o.corp_new_flg -- 企业专精特新标志
    ,o.refuse_rs -- 拒绝原因
    ,o.hxb_rela_corp_flg -- 我行关联企业标志
    ,o.rg_lon_flg -- 园区贷标志
    ,o.advise_flg -- 通知展业标志
    ,o.outline_flg -- 线下标志
    ,o.lmt_appl_flow_num -- 授信申请流水号
    ,o.cust_mgr_id -- 客户经理编号
    ,o.belong_brch_org_id -- 所属分行机构编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.update_teller_id -- 更新柜员编号
    ,o.up_date -- 更新日期
    ,o.auth_way_cd -- 授权方式代码
    ,o.biome_trics_cd -- 生物识别技术代码
    ,o.remark -- 备注
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
from ${iml_schema}.agt_loan_appl_xked_attach_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_appl_xked_attach_info_h_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_appl_xked_attach_info_h_icmsf1_cl d
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
--truncate table ${iml_schema}.agt_loan_appl_xked_attach_info_h;
--alter table ${iml_schema}.agt_loan_appl_xked_attach_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_appl_xked_attach_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_appl_xked_attach_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_appl_xked_attach_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_appl_xked_attach_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_appl_xked_attach_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_appl_xked_attach_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_appl_xked_attach_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_appl_xked_attach_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_appl_xked_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_appl_xked_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_appl_xked_attach_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_appl_xked_attach_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_appl_xked_attach_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
