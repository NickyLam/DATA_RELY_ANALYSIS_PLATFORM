/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_cont_lmt_attach_info_h_icmsf1
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
alter table ${iml_schema}.agt_loan_cont_lmt_attach_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_cont_lmt_attach_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_cont_lmt_attach_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_cont_lmt_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_cont_lmt_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_cont_lmt_attach_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_cont_lmt_attach_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,cont_id -- 合同编号
    ,lmt_next_bus_higt_pm_rat -- 额度下业务最高抵质押率
    ,lmt_next_bus_init_margin_ratio -- 额度下业务初始保证金比例
    ,lmt_next_bus_int_rat_lowt_flo_val -- 额度下业务利率最低浮动值
    ,lmt_next_bus_sig_max_amt -- 额度下业务单笔最大金额
    ,lmt_next_bus_lont_tenor -- 额度下业务最长期限
    ,lmt_next_bus_delay_renew_tenor -- 额度下业务延展期限
    ,lmt_under_bus_latest_exp_dt -- 额度项下业务最迟到期日期
    ,lmt_invalid_dt -- 额度失效日期
    ,fin_cont_flg -- 融资合同标志
    ,public_crdt_flg -- 公开授信标志
    ,turn_crdt_flg -- 转授信标志
    ,crdt_rg_cd -- 授信区域代码
    ,crdt_bus_flow_type_cd -- 授信业务流程类型代码
    ,lmt_dir_use_flg -- 额度可直接使用标志
    ,tenor_type_cd -- 期限类型代码
    ,lmt_kind_cd -- 额度种类代码
    ,group_lmt_crtl_mode_cd -- 集团额度管控模式代码
    ,under_bus_curr_cd_range -- 项下业务币种代码范围
    ,lmt_nmal_amt -- 额度名义金额
    ,lmt_open_amt -- 额度敞口金额
    ,used_nmal_amt -- 已用敞口金额
    ,used_open_amt -- 已用授信额度
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,syn_loan_tot_amt -- 银团贷款总金额
    ,major_loan_cls_cd -- 专业贷款分类代码
    ,risk_expose_cls -- 风险暴露分类代码
    ,invo_estate_fin_flg -- 涉及房地产融资标志
    ,invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,br_build_ifin_flg -- 一带一路建设投融资标志
    ,col_turn_margin_acct_id -- 押品转保证金账户编号
    ,lmt_use_cond_descb -- 额度使用条件描述
    ,froz_flg -- 冻结标志
    ,prtcptr_way_cd -- 参与方式代码
    ,onl_lmt -- 线上额度
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,green_crdt_fin_flg -- 绿色信贷融资标志
    ,invest_way_cd -- 投资方式代码
    ,class_crdt_flg -- 类信贷标志
    ,distr_org_id -- 放贷机构编号
    ,passer_id -- 通道方编号
    ,passer_name -- 通道方名称
    ,cap_src_cd -- 资金来源代码
    ,ext_bond_item_rating_cd -- 外部债项评级代码
    ,ext_rating_org_name -- 外部评级机构名称
    ,ext_rating_dt -- 外部评级日期
    ,col_turn_margin_sub_acct_num -- 押品转保证金子户号
    ,lon_post_mgmt_teller_id -- 贷后管理柜员编号
    ,lon_post_mgmt_org_id -- 贷后管理机构编号
    ,debt_regroup_cnt -- 债务重组次数
    ,auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,comn_risk_open_amt -- 一般风险敞口金额
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,single_higt_crdt_lmt_nmal_amt -- 单一最高授信额度名义金额
    ,single_higt_crdt_lmt_open_amt -- 单一最高授信额度敞口金额
    ,cent_mgmt_dept_id -- 归口管理部门编号
    ,level5_cls_cd -- 五级分类代码
    ,have_incre_crdt_flg -- 有增信标志
    ,ext_main_rating_cd -- 外部主体评级代码
    ,main_rating_org_name -- 主体评级机构名称
    ,main_rating_dt -- 主体评级日期
    ,loan_usage_descb -- 贷款用途描述
    ,invest_underly_descb -- 投资标的描述
    ,issuer_name -- 发行人名称
    ,issuer_cust_id -- 发行人客户编号
    ,mger_name -- 管理人名称
    ,mger_cust_id -- 管理人客户编号
    ,pente_flg -- 可穿透标志
    ,sup_chain_bus_ocup_core_corp_lmt_flg -- 供应链业务单占核心企业额度标志
    ,class_low_risk_flg -- 类低风险标志
    ,inovt_bus_flg -- 创新业务标志
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,ibank_lmt_type_cd -- 同业额度类型代码
    ,appl_syn_loan_tot -- 申请银团贷款总额
    ,fit_in_single_cust_or_group_lmt_flg -- 纳入单一客户或集团限额标志
    ,comb_class_consmt_flg -- 集合类代销标志
    ,set_single_cust_lmt_flg -- 设置单一客户限额标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_cont_lmt_attach_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_cont_lmt_attach_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_cont_lmt_attach_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_cont_lmt_attach_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_cont_lmt_attach_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_bc_cl_info-1
insert into ${iml_schema}.agt_loan_cont_lmt_attach_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,cont_id -- 合同编号
    ,lmt_next_bus_higt_pm_rat -- 额度下业务最高抵质押率
    ,lmt_next_bus_init_margin_ratio -- 额度下业务初始保证金比例
    ,lmt_next_bus_int_rat_lowt_flo_val -- 额度下业务利率最低浮动值
    ,lmt_next_bus_sig_max_amt -- 额度下业务单笔最大金额
    ,lmt_next_bus_lont_tenor -- 额度下业务最长期限
    ,lmt_next_bus_delay_renew_tenor -- 额度下业务延展期限
    ,lmt_under_bus_latest_exp_dt -- 额度项下业务最迟到期日期
    ,lmt_invalid_dt -- 额度失效日期
    ,fin_cont_flg -- 融资合同标志
    ,public_crdt_flg -- 公开授信标志
    ,turn_crdt_flg -- 转授信标志
    ,crdt_rg_cd -- 授信区域代码
    ,crdt_bus_flow_type_cd -- 授信业务流程类型代码
    ,lmt_dir_use_flg -- 额度可直接使用标志
    ,tenor_type_cd -- 期限类型代码
    ,lmt_kind_cd -- 额度种类代码
    ,group_lmt_crtl_mode_cd -- 集团额度管控模式代码
    ,under_bus_curr_cd_range -- 项下业务币种代码范围
    ,lmt_nmal_amt -- 额度名义金额
    ,lmt_open_amt -- 额度敞口金额
    ,used_nmal_amt -- 已用敞口金额
    ,used_open_amt -- 已用授信额度
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,syn_loan_tot_amt -- 银团贷款总金额
    ,major_loan_cls_cd -- 专业贷款分类代码
    ,risk_expose_cls -- 风险暴露分类代码
    ,invo_estate_fin_flg -- 涉及房地产融资标志
    ,invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,br_build_ifin_flg -- 一带一路建设投融资标志
    ,col_turn_margin_acct_id -- 押品转保证金账户编号
    ,lmt_use_cond_descb -- 额度使用条件描述
    ,froz_flg -- 冻结标志
    ,prtcptr_way_cd -- 参与方式代码
    ,onl_lmt -- 线上额度
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,green_crdt_fin_flg -- 绿色信贷融资标志
    ,invest_way_cd -- 投资方式代码
    ,class_crdt_flg -- 类信贷标志
    ,distr_org_id -- 放贷机构编号
    ,passer_id -- 通道方编号
    ,passer_name -- 通道方名称
    ,cap_src_cd -- 资金来源代码
    ,ext_bond_item_rating_cd -- 外部债项评级代码
    ,ext_rating_org_name -- 外部评级机构名称
    ,ext_rating_dt -- 外部评级日期
    ,col_turn_margin_sub_acct_num -- 押品转保证金子户号
    ,lon_post_mgmt_teller_id -- 贷后管理柜员编号
    ,lon_post_mgmt_org_id -- 贷后管理机构编号
    ,debt_regroup_cnt -- 债务重组次数
    ,auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,comn_risk_open_amt -- 一般风险敞口金额
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,single_higt_crdt_lmt_nmal_amt -- 单一最高授信额度名义金额
    ,single_higt_crdt_lmt_open_amt -- 单一最高授信额度敞口金额
    ,cent_mgmt_dept_id -- 归口管理部门编号
    ,level5_cls_cd -- 五级分类代码
    ,have_incre_crdt_flg -- 有增信标志
    ,ext_main_rating_cd -- 外部主体评级代码
    ,main_rating_org_name -- 主体评级机构名称
    ,main_rating_dt -- 主体评级日期
    ,loan_usage_descb -- 贷款用途描述
    ,invest_underly_descb -- 投资标的描述
    ,issuer_name -- 发行人名称
    ,issuer_cust_id -- 发行人客户编号
    ,mger_name -- 管理人名称
    ,mger_cust_id -- 管理人客户编号
    ,pente_flg -- 可穿透标志
    ,sup_chain_bus_ocup_core_corp_lmt_flg -- 供应链业务单占核心企业额度标志
    ,class_low_risk_flg -- 类低风险标志
    ,inovt_bus_flg -- 创新业务标志
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,ibank_lmt_type_cd -- 同业额度类型代码
    ,appl_syn_loan_tot -- 申请银团贷款总额
    ,fit_in_single_cust_or_group_lmt_flg -- 纳入单一客户或集团限额标志
    ,comb_class_consmt_flg -- 集合类代销标志
    ,set_single_cust_lmt_flg -- 设置单一客户限额标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300002'||P1.SERIALNO -- 协议编号
    ,P1.SERIALNO -- 合同编号
    ,P1.BIZMOSTMORTGAGERATE -- 额度下业务最高抵质押率
    ,P1.BIZBAILINITIALRATE -- 额度下业务初始保证金比例
    ,P1.BIZLOWESTFLOATRATE -- 额度下业务利率最低浮动值
    ,P1.SINGLEBIZMOSTAMOUNT -- 额度下业务单笔最大金额
    ,P1.BIZLONGESTTERM -- 额度下业务最长期限
    ,P1.BIZEXTENDEDTERM -- 额度下业务延展期限
    ,decode(P1.USETERM,to_date('00010101','yyyymmdd'),to_date('29991231','yyyymmdd'),P1.USETERM) -- 额度项下业务最迟到期日期
    ,decode(P1.LATESTUSEDATE,to_date('00010101','yyyymmdd'),to_date('29991231','yyyymmdd'),P1.LATESTUSEDATE) -- 额度失效日期
    ,nvl(trim(P1.ISRZ),'-') -- 融资合同标志
    ,nvl(trim(P1.ISPUBLICCREDIT),'-') -- 公开授信标志
    ,decode(P1.ISTRANS,'1','1','0','0','2','0',' ','-'，P1.ISTRANS) -- 转授信标志
    ,NVL(TRIM(P1.CREDITAREA),'00') -- 授信区域代码
    ,P1.CREDITFLOWTYPE -- 授信业务流程类型代码
    ,nvl(trim(P1.USEWITHOUTCONDITION),'-') -- 额度可直接使用标志
    ,nvl(trim(P1.TERMTYPE),'-') -- 期限类型代码
    ,nvl(trim(P1.LINECLASS),'-') -- 额度种类代码
    ,nvl(trim(P1.LINECONTROLMODE),'-') -- 集团额度管控模式代码
    ,nvl(trim(P1.CURRENCYRANGE),'-') -- 项下业务币种代码范围
    ,P1.NOMINALSUM -- 额度名义金额
    ,P1.EXPOSURESUM -- 额度敞口金额
    ,P1.OCCUPYNOMINALSUM -- 已用敞口金额
    ,P1.OCCUPYEXPOSURESUM -- 已用授信额度
    ,P1.AVAILABLENOMINALSUM -- 可用名义金额
    ,P1.AVAILABLEEXPOSURESUM -- 可用敞口金额
    ,P1.SYNDICATETOTALSUM -- 银团贷款总金额
    ,P1.BUSINESSTYPE2 -- 专业贷款分类代码
    ,nvl(trim(P1.CLASSIFYTYPE2),'-') -- 风险暴露分类代码
    ,nvl(trim(P1.ISESTATEFINANCE),'-') -- 涉及房地产融资标志
    ,nvl(trim(P1.ISGOVERNFINANCE),'-') -- 涉及政府类融资标志
    ,nvl(trim(P1.ISBELTROADFINANCE),'-') -- 一带一路建设投融资标志
    ,P1.GUARANTYBAILACCOUNT -- 押品转保证金账户编号
    ,P1.LimitUseCondition -- 额度使用条件描述
    ,P1.FREEZEFLAG -- 冻结标志
    ,P1.PLAYTYPE -- 参与方式代码
    ,P1.ONLINEAMOUNT -- 线上额度
    ,nvl(trim(P1.ISCONSUMERFINANCE),'-') -- 消费服务类融资标志
    ,nvl(trim(P1.ISGREENFINANCE),'-') -- 绿色信贷融资标志
    ,nvl(trim(P1.INVESTWAY),'00') -- 投资方式代码
    ,nvl(trim(P1.ISLIKELOAN),'-') -- 类信贷标志
    ,P1.PUTOUTORGID -- 放贷机构编号
    ,P1.CHANNELID -- 通道方编号
    ,P1.CHANNELNAME -- 通道方名称
    ,nvl(trim(P1.FUNDSOURCE),'-') -- 资金来源代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'|| P1.OUTCLASSIFYLEVEL END  -- 外部债项评级代码
    ,P1.OUTCLASSIFYORG -- 外部评级机构名称
    ,${iml_schema}.dateformat_max2(P1.OUTCLASSIFYDATE) -- 外部评级日期
    ,P1.GUARANTYBAILSUBACCOUNT -- 押品转保证金子户号
    ,P1.AFTERLOANUSERID -- 贷后管理柜员编号
    ,P1.AFTERLOANORGID -- 贷后管理机构编号
    ,P1.DRTIMES -- 债务重组次数
    ,nvl(trim(P1.ISQUERYCREDITREPORT),'-') -- 自动查询贷后报告标志
    ,P1.RISKEXPOSURESUM -- 一般风险敞口金额
    ,P1.LOWRISKEXPOSURESUM -- 类低风险敞口金额
    ,nvl(trim(P1.OTHERLIMITFLAG),'-') -- 占用他用额度标志
    ,P1.MAXNOMINALAMOUNT -- 单一最高授信额度名义金额
    ,P1.MAXEXPOSUREAMOUNT -- 单一最高授信额度敞口金额
    ,P1.HXTYOPERATEORG -- 归口管理部门编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'|| P1.CLASSIFYRESULTELEVEN END -- 五级分类代码
    ,nvl(trim(P1.ISCREDITINCREMENT),'-') -- 有增信标志
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'|| P1.HXTYMAINRATELEVEL END  -- 外部主体评级代码
    ,P1.MAINLEVELORG -- 主体评级机构名称
    ,${iml_schema}.dateformat_max2(P1.MAINLEVELDATE) -- 主体评级日期
    ,P1.PURPOSE -- 贷款用途描述
    ,P1.INVESTTARGET -- 投资标的描述
    ,P1.ISSUERNAME -- 发行人名称
    ,P1.ISSUERID -- 发行人客户编号
    ,P1.MANAGENAME -- 管理人名称
    ,P1.MANAGEID -- 管理人客户编号
    ,nvl(trim(P1.ISPENETRATE),'-') -- 可穿透标志
    ,nvl(trim(P1.SUPPLYCHAIN),'-') -- 供应链业务单占核心企业额度标志
    ,nvl(trim(P1.ISLIKELOWRISK),'-') -- 类低风险标志
    ,nvl(trim(P1.ISINNOVATE),'-') -- 创新业务标志
    ,nvl(trim(P1.ISSUPPLYCHAINFINANCE),'-') -- 供应链金融业务标志
    ,P1.LMTTYP -- 同业额度类型代码
    ,P1.SQDKZE -- 申请银团贷款总额
    ,nvl(trim(P1.ISJOINLIMITS),'-') -- 纳入单一客户或集团限额标志
    ,nvl(trim(P1.ISCOLLECTIONAGENCY),'-') -- 集合类代销标志
    ,nvl(trim(P1.ISLIMIT),'-') -- 设置单一客户限额标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_bc_cl_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_bc_cl_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLASSIFYRESULTELEVEN = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_BC_CL_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'CLASSIFYRESULTELEVEN'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_LOAN_CONT_LMT_ATTACH_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'LEVEL5_CLS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.OUTCLASSIFYLEVEL = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_BC_CL_INFO'
        AND R2.SRC_FIELD_EN_NAME= 'OUTCLASSIFYLEVEL'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_LOAN_CONT_LMT_ATTACH_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'EXT_BOND_ITEM_RATING_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.HXTYMAINRATELEVEL = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'ICMS'
        AND R3.SRC_TAB_EN_NAME= 'ICMS_BC_CL_INFO'
        AND R3.SRC_FIELD_EN_NAME= 'HXTYMAINRATELEVEL'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_LOAN_CONT_LMT_ATTACH_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'EXT_MAIN_RATING_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_cont_lmt_attach_info_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,cont_id
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
        into ${iml_schema}.agt_loan_cont_lmt_attach_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,cont_id -- 合同编号
    ,lmt_next_bus_higt_pm_rat -- 额度下业务最高抵质押率
    ,lmt_next_bus_init_margin_ratio -- 额度下业务初始保证金比例
    ,lmt_next_bus_int_rat_lowt_flo_val -- 额度下业务利率最低浮动值
    ,lmt_next_bus_sig_max_amt -- 额度下业务单笔最大金额
    ,lmt_next_bus_lont_tenor -- 额度下业务最长期限
    ,lmt_next_bus_delay_renew_tenor -- 额度下业务延展期限
    ,lmt_under_bus_latest_exp_dt -- 额度项下业务最迟到期日期
    ,lmt_invalid_dt -- 额度失效日期
    ,fin_cont_flg -- 融资合同标志
    ,public_crdt_flg -- 公开授信标志
    ,turn_crdt_flg -- 转授信标志
    ,crdt_rg_cd -- 授信区域代码
    ,crdt_bus_flow_type_cd -- 授信业务流程类型代码
    ,lmt_dir_use_flg -- 额度可直接使用标志
    ,tenor_type_cd -- 期限类型代码
    ,lmt_kind_cd -- 额度种类代码
    ,group_lmt_crtl_mode_cd -- 集团额度管控模式代码
    ,under_bus_curr_cd_range -- 项下业务币种代码范围
    ,lmt_nmal_amt -- 额度名义金额
    ,lmt_open_amt -- 额度敞口金额
    ,used_nmal_amt -- 已用敞口金额
    ,used_open_amt -- 已用授信额度
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,syn_loan_tot_amt -- 银团贷款总金额
    ,major_loan_cls_cd -- 专业贷款分类代码
    ,risk_expose_cls -- 风险暴露分类代码
    ,invo_estate_fin_flg -- 涉及房地产融资标志
    ,invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,br_build_ifin_flg -- 一带一路建设投融资标志
    ,col_turn_margin_acct_id -- 押品转保证金账户编号
    ,lmt_use_cond_descb -- 额度使用条件描述
    ,froz_flg -- 冻结标志
    ,prtcptr_way_cd -- 参与方式代码
    ,onl_lmt -- 线上额度
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,green_crdt_fin_flg -- 绿色信贷融资标志
    ,invest_way_cd -- 投资方式代码
    ,class_crdt_flg -- 类信贷标志
    ,distr_org_id -- 放贷机构编号
    ,passer_id -- 通道方编号
    ,passer_name -- 通道方名称
    ,cap_src_cd -- 资金来源代码
    ,ext_bond_item_rating_cd -- 外部债项评级代码
    ,ext_rating_org_name -- 外部评级机构名称
    ,ext_rating_dt -- 外部评级日期
    ,col_turn_margin_sub_acct_num -- 押品转保证金子户号
    ,lon_post_mgmt_teller_id -- 贷后管理柜员编号
    ,lon_post_mgmt_org_id -- 贷后管理机构编号
    ,debt_regroup_cnt -- 债务重组次数
    ,auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,comn_risk_open_amt -- 一般风险敞口金额
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,single_higt_crdt_lmt_nmal_amt -- 单一最高授信额度名义金额
    ,single_higt_crdt_lmt_open_amt -- 单一最高授信额度敞口金额
    ,cent_mgmt_dept_id -- 归口管理部门编号
    ,level5_cls_cd -- 五级分类代码
    ,have_incre_crdt_flg -- 有增信标志
    ,ext_main_rating_cd -- 外部主体评级代码
    ,main_rating_org_name -- 主体评级机构名称
    ,main_rating_dt -- 主体评级日期
    ,loan_usage_descb -- 贷款用途描述
    ,invest_underly_descb -- 投资标的描述
    ,issuer_name -- 发行人名称
    ,issuer_cust_id -- 发行人客户编号
    ,mger_name -- 管理人名称
    ,mger_cust_id -- 管理人客户编号
    ,pente_flg -- 可穿透标志
    ,sup_chain_bus_ocup_core_corp_lmt_flg -- 供应链业务单占核心企业额度标志
    ,class_low_risk_flg -- 类低风险标志
    ,inovt_bus_flg -- 创新业务标志
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,ibank_lmt_type_cd -- 同业额度类型代码
    ,appl_syn_loan_tot -- 申请银团贷款总额
    ,fit_in_single_cust_or_group_lmt_flg -- 纳入单一客户或集团限额标志
    ,comb_class_consmt_flg -- 集合类代销标志
    ,set_single_cust_lmt_flg -- 设置单一客户限额标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_cont_lmt_attach_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,cont_id -- 合同编号
    ,lmt_next_bus_higt_pm_rat -- 额度下业务最高抵质押率
    ,lmt_next_bus_init_margin_ratio -- 额度下业务初始保证金比例
    ,lmt_next_bus_int_rat_lowt_flo_val -- 额度下业务利率最低浮动值
    ,lmt_next_bus_sig_max_amt -- 额度下业务单笔最大金额
    ,lmt_next_bus_lont_tenor -- 额度下业务最长期限
    ,lmt_next_bus_delay_renew_tenor -- 额度下业务延展期限
    ,lmt_under_bus_latest_exp_dt -- 额度项下业务最迟到期日期
    ,lmt_invalid_dt -- 额度失效日期
    ,fin_cont_flg -- 融资合同标志
    ,public_crdt_flg -- 公开授信标志
    ,turn_crdt_flg -- 转授信标志
    ,crdt_rg_cd -- 授信区域代码
    ,crdt_bus_flow_type_cd -- 授信业务流程类型代码
    ,lmt_dir_use_flg -- 额度可直接使用标志
    ,tenor_type_cd -- 期限类型代码
    ,lmt_kind_cd -- 额度种类代码
    ,group_lmt_crtl_mode_cd -- 集团额度管控模式代码
    ,under_bus_curr_cd_range -- 项下业务币种代码范围
    ,lmt_nmal_amt -- 额度名义金额
    ,lmt_open_amt -- 额度敞口金额
    ,used_nmal_amt -- 已用敞口金额
    ,used_open_amt -- 已用授信额度
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,syn_loan_tot_amt -- 银团贷款总金额
    ,major_loan_cls_cd -- 专业贷款分类代码
    ,risk_expose_cls -- 风险暴露分类代码
    ,invo_estate_fin_flg -- 涉及房地产融资标志
    ,invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,br_build_ifin_flg -- 一带一路建设投融资标志
    ,col_turn_margin_acct_id -- 押品转保证金账户编号
    ,lmt_use_cond_descb -- 额度使用条件描述
    ,froz_flg -- 冻结标志
    ,prtcptr_way_cd -- 参与方式代码
    ,onl_lmt -- 线上额度
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,green_crdt_fin_flg -- 绿色信贷融资标志
    ,invest_way_cd -- 投资方式代码
    ,class_crdt_flg -- 类信贷标志
    ,distr_org_id -- 放贷机构编号
    ,passer_id -- 通道方编号
    ,passer_name -- 通道方名称
    ,cap_src_cd -- 资金来源代码
    ,ext_bond_item_rating_cd -- 外部债项评级代码
    ,ext_rating_org_name -- 外部评级机构名称
    ,ext_rating_dt -- 外部评级日期
    ,col_turn_margin_sub_acct_num -- 押品转保证金子户号
    ,lon_post_mgmt_teller_id -- 贷后管理柜员编号
    ,lon_post_mgmt_org_id -- 贷后管理机构编号
    ,debt_regroup_cnt -- 债务重组次数
    ,auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,comn_risk_open_amt -- 一般风险敞口金额
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,single_higt_crdt_lmt_nmal_amt -- 单一最高授信额度名义金额
    ,single_higt_crdt_lmt_open_amt -- 单一最高授信额度敞口金额
    ,cent_mgmt_dept_id -- 归口管理部门编号
    ,level5_cls_cd -- 五级分类代码
    ,have_incre_crdt_flg -- 有增信标志
    ,ext_main_rating_cd -- 外部主体评级代码
    ,main_rating_org_name -- 主体评级机构名称
    ,main_rating_dt -- 主体评级日期
    ,loan_usage_descb -- 贷款用途描述
    ,invest_underly_descb -- 投资标的描述
    ,issuer_name -- 发行人名称
    ,issuer_cust_id -- 发行人客户编号
    ,mger_name -- 管理人名称
    ,mger_cust_id -- 管理人客户编号
    ,pente_flg -- 可穿透标志
    ,sup_chain_bus_ocup_core_corp_lmt_flg -- 供应链业务单占核心企业额度标志
    ,class_low_risk_flg -- 类低风险标志
    ,inovt_bus_flg -- 创新业务标志
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,ibank_lmt_type_cd -- 同业额度类型代码
    ,appl_syn_loan_tot -- 申请银团贷款总额
    ,fit_in_single_cust_or_group_lmt_flg -- 纳入单一客户或集团限额标志
    ,comb_class_consmt_flg -- 集合类代销标志
    ,set_single_cust_lmt_flg -- 设置单一客户限额标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.lmt_next_bus_higt_pm_rat, o.lmt_next_bus_higt_pm_rat) as lmt_next_bus_higt_pm_rat -- 额度下业务最高抵质押率
    ,nvl(n.lmt_next_bus_init_margin_ratio, o.lmt_next_bus_init_margin_ratio) as lmt_next_bus_init_margin_ratio -- 额度下业务初始保证金比例
    ,nvl(n.lmt_next_bus_int_rat_lowt_flo_val, o.lmt_next_bus_int_rat_lowt_flo_val) as lmt_next_bus_int_rat_lowt_flo_val -- 额度下业务利率最低浮动值
    ,nvl(n.lmt_next_bus_sig_max_amt, o.lmt_next_bus_sig_max_amt) as lmt_next_bus_sig_max_amt -- 额度下业务单笔最大金额
    ,nvl(n.lmt_next_bus_lont_tenor, o.lmt_next_bus_lont_tenor) as lmt_next_bus_lont_tenor -- 额度下业务最长期限
    ,nvl(n.lmt_next_bus_delay_renew_tenor, o.lmt_next_bus_delay_renew_tenor) as lmt_next_bus_delay_renew_tenor -- 额度下业务延展期限
    ,nvl(n.lmt_under_bus_latest_exp_dt, o.lmt_under_bus_latest_exp_dt) as lmt_under_bus_latest_exp_dt -- 额度项下业务最迟到期日期
    ,nvl(n.lmt_invalid_dt, o.lmt_invalid_dt) as lmt_invalid_dt -- 额度失效日期
    ,nvl(n.fin_cont_flg, o.fin_cont_flg) as fin_cont_flg -- 融资合同标志
    ,nvl(n.public_crdt_flg, o.public_crdt_flg) as public_crdt_flg -- 公开授信标志
    ,nvl(n.turn_crdt_flg, o.turn_crdt_flg) as turn_crdt_flg -- 转授信标志
    ,nvl(n.crdt_rg_cd, o.crdt_rg_cd) as crdt_rg_cd -- 授信区域代码
    ,nvl(n.crdt_bus_flow_type_cd, o.crdt_bus_flow_type_cd) as crdt_bus_flow_type_cd -- 授信业务流程类型代码
    ,nvl(n.lmt_dir_use_flg, o.lmt_dir_use_flg) as lmt_dir_use_flg -- 额度可直接使用标志
    ,nvl(n.tenor_type_cd, o.tenor_type_cd) as tenor_type_cd -- 期限类型代码
    ,nvl(n.lmt_kind_cd, o.lmt_kind_cd) as lmt_kind_cd -- 额度种类代码
    ,nvl(n.group_lmt_crtl_mode_cd, o.group_lmt_crtl_mode_cd) as group_lmt_crtl_mode_cd -- 集团额度管控模式代码
    ,nvl(n.under_bus_curr_cd_range, o.under_bus_curr_cd_range) as under_bus_curr_cd_range -- 项下业务币种代码范围
    ,nvl(n.lmt_nmal_amt, o.lmt_nmal_amt) as lmt_nmal_amt -- 额度名义金额
    ,nvl(n.lmt_open_amt, o.lmt_open_amt) as lmt_open_amt -- 额度敞口金额
    ,nvl(n.used_nmal_amt, o.used_nmal_amt) as used_nmal_amt -- 已用敞口金额
    ,nvl(n.used_open_amt, o.used_open_amt) as used_open_amt -- 已用授信额度
    ,nvl(n.aval_nmal_amt, o.aval_nmal_amt) as aval_nmal_amt -- 可用名义金额
    ,nvl(n.aval_open_amt, o.aval_open_amt) as aval_open_amt -- 可用敞口金额
    ,nvl(n.syn_loan_tot_amt, o.syn_loan_tot_amt) as syn_loan_tot_amt -- 银团贷款总金额
    ,nvl(n.major_loan_cls_cd, o.major_loan_cls_cd) as major_loan_cls_cd -- 专业贷款分类代码
    ,nvl(n.risk_expose_cls, o.risk_expose_cls) as risk_expose_cls -- 风险暴露分类代码
    ,nvl(n.invo_estate_fin_flg, o.invo_estate_fin_flg) as invo_estate_fin_flg -- 涉及房地产融资标志
    ,nvl(n.invo_gover_class_fin_flg, o.invo_gover_class_fin_flg) as invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,nvl(n.br_build_ifin_flg, o.br_build_ifin_flg) as br_build_ifin_flg -- 一带一路建设投融资标志
    ,nvl(n.col_turn_margin_acct_id, o.col_turn_margin_acct_id) as col_turn_margin_acct_id -- 押品转保证金账户编号
    ,nvl(n.lmt_use_cond_descb, o.lmt_use_cond_descb) as lmt_use_cond_descb -- 额度使用条件描述
    ,nvl(n.froz_flg, o.froz_flg) as froz_flg -- 冻结标志
    ,nvl(n.prtcptr_way_cd, o.prtcptr_way_cd) as prtcptr_way_cd -- 参与方式代码
    ,nvl(n.onl_lmt, o.onl_lmt) as onl_lmt -- 线上额度
    ,nvl(n.consm_serv_class_fin_flg, o.consm_serv_class_fin_flg) as consm_serv_class_fin_flg -- 消费服务类融资标志
    ,nvl(n.green_crdt_fin_flg, o.green_crdt_fin_flg) as green_crdt_fin_flg -- 绿色信贷融资标志
    ,nvl(n.invest_way_cd, o.invest_way_cd) as invest_way_cd -- 投资方式代码
    ,nvl(n.class_crdt_flg, o.class_crdt_flg) as class_crdt_flg -- 类信贷标志
    ,nvl(n.distr_org_id, o.distr_org_id) as distr_org_id -- 放贷机构编号
    ,nvl(n.passer_id, o.passer_id) as passer_id -- 通道方编号
    ,nvl(n.passer_name, o.passer_name) as passer_name -- 通道方名称
    ,nvl(n.cap_src_cd, o.cap_src_cd) as cap_src_cd -- 资金来源代码
    ,nvl(n.ext_bond_item_rating_cd, o.ext_bond_item_rating_cd) as ext_bond_item_rating_cd -- 外部债项评级代码
    ,nvl(n.ext_rating_org_name, o.ext_rating_org_name) as ext_rating_org_name -- 外部评级机构名称
    ,nvl(n.ext_rating_dt, o.ext_rating_dt) as ext_rating_dt -- 外部评级日期
    ,nvl(n.col_turn_margin_sub_acct_num, o.col_turn_margin_sub_acct_num) as col_turn_margin_sub_acct_num -- 押品转保证金子户号
    ,nvl(n.lon_post_mgmt_teller_id, o.lon_post_mgmt_teller_id) as lon_post_mgmt_teller_id -- 贷后管理柜员编号
    ,nvl(n.lon_post_mgmt_org_id, o.lon_post_mgmt_org_id) as lon_post_mgmt_org_id -- 贷后管理机构编号
    ,nvl(n.debt_regroup_cnt, o.debt_regroup_cnt) as debt_regroup_cnt -- 债务重组次数
    ,nvl(n.auto_que_lon_post_rept_flg, o.auto_que_lon_post_rept_flg) as auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,nvl(n.comn_risk_open_amt, o.comn_risk_open_amt) as comn_risk_open_amt -- 一般风险敞口金额
    ,nvl(n.class_low_risk_open_amt, o.class_low_risk_open_amt) as class_low_risk_open_amt -- 类低风险敞口金额
    ,nvl(n.ocup_o_use_lmt_flg, o.ocup_o_use_lmt_flg) as ocup_o_use_lmt_flg -- 占用他用额度标志
    ,nvl(n.single_higt_crdt_lmt_nmal_amt, o.single_higt_crdt_lmt_nmal_amt) as single_higt_crdt_lmt_nmal_amt -- 单一最高授信额度名义金额
    ,nvl(n.single_higt_crdt_lmt_open_amt, o.single_higt_crdt_lmt_open_amt) as single_higt_crdt_lmt_open_amt -- 单一最高授信额度敞口金额
    ,nvl(n.cent_mgmt_dept_id, o.cent_mgmt_dept_id) as cent_mgmt_dept_id -- 归口管理部门编号
    ,nvl(n.level5_cls_cd, o.level5_cls_cd) as level5_cls_cd -- 五级分类代码
    ,nvl(n.have_incre_crdt_flg, o.have_incre_crdt_flg) as have_incre_crdt_flg -- 有增信标志
    ,nvl(n.ext_main_rating_cd, o.ext_main_rating_cd) as ext_main_rating_cd -- 外部主体评级代码
    ,nvl(n.main_rating_org_name, o.main_rating_org_name) as main_rating_org_name -- 主体评级机构名称
    ,nvl(n.main_rating_dt, o.main_rating_dt) as main_rating_dt -- 主体评级日期
    ,nvl(n.loan_usage_descb, o.loan_usage_descb) as loan_usage_descb -- 贷款用途描述
    ,nvl(n.invest_underly_descb, o.invest_underly_descb) as invest_underly_descb -- 投资标的描述
    ,nvl(n.issuer_name, o.issuer_name) as issuer_name -- 发行人名称
    ,nvl(n.issuer_cust_id, o.issuer_cust_id) as issuer_cust_id -- 发行人客户编号
    ,nvl(n.mger_name, o.mger_name) as mger_name -- 管理人名称
    ,nvl(n.mger_cust_id, o.mger_cust_id) as mger_cust_id -- 管理人客户编号
    ,nvl(n.pente_flg, o.pente_flg) as pente_flg -- 可穿透标志
    ,nvl(n.sup_chain_bus_ocup_core_corp_lmt_flg, o.sup_chain_bus_ocup_core_corp_lmt_flg) as sup_chain_bus_ocup_core_corp_lmt_flg -- 供应链业务单占核心企业额度标志
    ,nvl(n.class_low_risk_flg, o.class_low_risk_flg) as class_low_risk_flg -- 类低风险标志
    ,nvl(n.inovt_bus_flg, o.inovt_bus_flg) as inovt_bus_flg -- 创新业务标志
    ,nvl(n.sup_chain_fin_bus_flg, o.sup_chain_fin_bus_flg) as sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,nvl(n.ibank_lmt_type_cd, o.ibank_lmt_type_cd) as ibank_lmt_type_cd -- 同业额度类型代码
    ,nvl(n.appl_syn_loan_tot, o.appl_syn_loan_tot) as appl_syn_loan_tot -- 申请银团贷款总额
    ,nvl(n.fit_in_single_cust_or_group_lmt_flg, o.fit_in_single_cust_or_group_lmt_flg) as fit_in_single_cust_or_group_lmt_flg -- 纳入单一客户或集团限额标志
    ,nvl(n.comb_class_consmt_flg, o.comb_class_consmt_flg) as comb_class_consmt_flg -- 集合类代销标志
    ,nvl(n.set_single_cust_lmt_flg, o.set_single_cust_lmt_flg) as set_single_cust_lmt_flg -- 设置单一客户限额标志
    ,case when
            n.agt_id is null
            and n.cont_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.cont_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.cont_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_cont_lmt_attach_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_cont_lmt_attach_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.cont_id = n.cont_id
where (
        o.agt_id is null
        and o.cont_id is null
    )
    or (
        n.agt_id is null
        and n.cont_id is null
    )
    or (
        o.lmt_next_bus_higt_pm_rat <> n.lmt_next_bus_higt_pm_rat
        or o.lmt_next_bus_init_margin_ratio <> n.lmt_next_bus_init_margin_ratio
        or o.lmt_next_bus_int_rat_lowt_flo_val <> n.lmt_next_bus_int_rat_lowt_flo_val
        or o.lmt_next_bus_sig_max_amt <> n.lmt_next_bus_sig_max_amt
        or o.lmt_next_bus_lont_tenor <> n.lmt_next_bus_lont_tenor
        or o.lmt_next_bus_delay_renew_tenor <> n.lmt_next_bus_delay_renew_tenor
        or o.lmt_under_bus_latest_exp_dt <> n.lmt_under_bus_latest_exp_dt
        or o.lmt_invalid_dt <> n.lmt_invalid_dt
        or o.fin_cont_flg <> n.fin_cont_flg
        or o.public_crdt_flg <> n.public_crdt_flg
        or o.turn_crdt_flg <> n.turn_crdt_flg
        or o.crdt_rg_cd <> n.crdt_rg_cd
        or o.crdt_bus_flow_type_cd <> n.crdt_bus_flow_type_cd
        or o.lmt_dir_use_flg <> n.lmt_dir_use_flg
        or o.tenor_type_cd <> n.tenor_type_cd
        or o.lmt_kind_cd <> n.lmt_kind_cd
        or o.group_lmt_crtl_mode_cd <> n.group_lmt_crtl_mode_cd
        or o.under_bus_curr_cd_range <> n.under_bus_curr_cd_range
        or o.lmt_nmal_amt <> n.lmt_nmal_amt
        or o.lmt_open_amt <> n.lmt_open_amt
        or o.used_nmal_amt <> n.used_nmal_amt
        or o.used_open_amt <> n.used_open_amt
        or o.aval_nmal_amt <> n.aval_nmal_amt
        or o.aval_open_amt <> n.aval_open_amt
        or o.syn_loan_tot_amt <> n.syn_loan_tot_amt
        or o.major_loan_cls_cd <> n.major_loan_cls_cd
        or o.risk_expose_cls <> n.risk_expose_cls
        or o.invo_estate_fin_flg <> n.invo_estate_fin_flg
        or o.invo_gover_class_fin_flg <> n.invo_gover_class_fin_flg
        or o.br_build_ifin_flg <> n.br_build_ifin_flg
        or o.col_turn_margin_acct_id <> n.col_turn_margin_acct_id
        or o.lmt_use_cond_descb <> n.lmt_use_cond_descb
        or o.froz_flg <> n.froz_flg
        or o.prtcptr_way_cd <> n.prtcptr_way_cd
        or o.onl_lmt <> n.onl_lmt
        or o.consm_serv_class_fin_flg <> n.consm_serv_class_fin_flg
        or o.green_crdt_fin_flg <> n.green_crdt_fin_flg
        or o.invest_way_cd <> n.invest_way_cd
        or o.class_crdt_flg <> n.class_crdt_flg
        or o.distr_org_id <> n.distr_org_id
        or o.passer_id <> n.passer_id
        or o.passer_name <> n.passer_name
        or o.cap_src_cd <> n.cap_src_cd
        or o.ext_bond_item_rating_cd <> n.ext_bond_item_rating_cd
        or o.ext_rating_org_name <> n.ext_rating_org_name
        or o.ext_rating_dt <> n.ext_rating_dt
        or o.col_turn_margin_sub_acct_num <> n.col_turn_margin_sub_acct_num
        or o.lon_post_mgmt_teller_id <> n.lon_post_mgmt_teller_id
        or o.lon_post_mgmt_org_id <> n.lon_post_mgmt_org_id
        or o.debt_regroup_cnt <> n.debt_regroup_cnt
        or o.auto_que_lon_post_rept_flg <> n.auto_que_lon_post_rept_flg
        or o.comn_risk_open_amt <> n.comn_risk_open_amt
        or o.class_low_risk_open_amt <> n.class_low_risk_open_amt
        or o.ocup_o_use_lmt_flg <> n.ocup_o_use_lmt_flg
        or o.single_higt_crdt_lmt_nmal_amt <> n.single_higt_crdt_lmt_nmal_amt
        or o.single_higt_crdt_lmt_open_amt <> n.single_higt_crdt_lmt_open_amt
        or o.cent_mgmt_dept_id <> n.cent_mgmt_dept_id
        or o.level5_cls_cd <> n.level5_cls_cd
        or o.have_incre_crdt_flg <> n.have_incre_crdt_flg
        or o.ext_main_rating_cd <> n.ext_main_rating_cd
        or o.main_rating_org_name <> n.main_rating_org_name
        or o.main_rating_dt <> n.main_rating_dt
        or o.loan_usage_descb <> n.loan_usage_descb
        or o.invest_underly_descb <> n.invest_underly_descb
        or o.issuer_name <> n.issuer_name
        or o.issuer_cust_id <> n.issuer_cust_id
        or o.mger_name <> n.mger_name
        or o.mger_cust_id <> n.mger_cust_id
        or o.pente_flg <> n.pente_flg
        or o.sup_chain_bus_ocup_core_corp_lmt_flg <> n.sup_chain_bus_ocup_core_corp_lmt_flg
        or o.class_low_risk_flg <> n.class_low_risk_flg
        or o.inovt_bus_flg <> n.inovt_bus_flg
        or o.sup_chain_fin_bus_flg <> n.sup_chain_fin_bus_flg
        or o.ibank_lmt_type_cd <> n.ibank_lmt_type_cd
        or o.appl_syn_loan_tot <> n.appl_syn_loan_tot
        or o.fit_in_single_cust_or_group_lmt_flg <> n.fit_in_single_cust_or_group_lmt_flg
        or o.comb_class_consmt_flg <> n.comb_class_consmt_flg
        or o.set_single_cust_lmt_flg <> n.set_single_cust_lmt_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_cont_lmt_attach_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,cont_id -- 合同编号
    ,lmt_next_bus_higt_pm_rat -- 额度下业务最高抵质押率
    ,lmt_next_bus_init_margin_ratio -- 额度下业务初始保证金比例
    ,lmt_next_bus_int_rat_lowt_flo_val -- 额度下业务利率最低浮动值
    ,lmt_next_bus_sig_max_amt -- 额度下业务单笔最大金额
    ,lmt_next_bus_lont_tenor -- 额度下业务最长期限
    ,lmt_next_bus_delay_renew_tenor -- 额度下业务延展期限
    ,lmt_under_bus_latest_exp_dt -- 额度项下业务最迟到期日期
    ,lmt_invalid_dt -- 额度失效日期
    ,fin_cont_flg -- 融资合同标志
    ,public_crdt_flg -- 公开授信标志
    ,turn_crdt_flg -- 转授信标志
    ,crdt_rg_cd -- 授信区域代码
    ,crdt_bus_flow_type_cd -- 授信业务流程类型代码
    ,lmt_dir_use_flg -- 额度可直接使用标志
    ,tenor_type_cd -- 期限类型代码
    ,lmt_kind_cd -- 额度种类代码
    ,group_lmt_crtl_mode_cd -- 集团额度管控模式代码
    ,under_bus_curr_cd_range -- 项下业务币种代码范围
    ,lmt_nmal_amt -- 额度名义金额
    ,lmt_open_amt -- 额度敞口金额
    ,used_nmal_amt -- 已用敞口金额
    ,used_open_amt -- 已用授信额度
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,syn_loan_tot_amt -- 银团贷款总金额
    ,major_loan_cls_cd -- 专业贷款分类代码
    ,risk_expose_cls -- 风险暴露分类代码
    ,invo_estate_fin_flg -- 涉及房地产融资标志
    ,invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,br_build_ifin_flg -- 一带一路建设投融资标志
    ,col_turn_margin_acct_id -- 押品转保证金账户编号
    ,lmt_use_cond_descb -- 额度使用条件描述
    ,froz_flg -- 冻结标志
    ,prtcptr_way_cd -- 参与方式代码
    ,onl_lmt -- 线上额度
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,green_crdt_fin_flg -- 绿色信贷融资标志
    ,invest_way_cd -- 投资方式代码
    ,class_crdt_flg -- 类信贷标志
    ,distr_org_id -- 放贷机构编号
    ,passer_id -- 通道方编号
    ,passer_name -- 通道方名称
    ,cap_src_cd -- 资金来源代码
    ,ext_bond_item_rating_cd -- 外部债项评级代码
    ,ext_rating_org_name -- 外部评级机构名称
    ,ext_rating_dt -- 外部评级日期
    ,col_turn_margin_sub_acct_num -- 押品转保证金子户号
    ,lon_post_mgmt_teller_id -- 贷后管理柜员编号
    ,lon_post_mgmt_org_id -- 贷后管理机构编号
    ,debt_regroup_cnt -- 债务重组次数
    ,auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,comn_risk_open_amt -- 一般风险敞口金额
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,single_higt_crdt_lmt_nmal_amt -- 单一最高授信额度名义金额
    ,single_higt_crdt_lmt_open_amt -- 单一最高授信额度敞口金额
    ,cent_mgmt_dept_id -- 归口管理部门编号
    ,level5_cls_cd -- 五级分类代码
    ,have_incre_crdt_flg -- 有增信标志
    ,ext_main_rating_cd -- 外部主体评级代码
    ,main_rating_org_name -- 主体评级机构名称
    ,main_rating_dt -- 主体评级日期
    ,loan_usage_descb -- 贷款用途描述
    ,invest_underly_descb -- 投资标的描述
    ,issuer_name -- 发行人名称
    ,issuer_cust_id -- 发行人客户编号
    ,mger_name -- 管理人名称
    ,mger_cust_id -- 管理人客户编号
    ,pente_flg -- 可穿透标志
    ,sup_chain_bus_ocup_core_corp_lmt_flg -- 供应链业务单占核心企业额度标志
    ,class_low_risk_flg -- 类低风险标志
    ,inovt_bus_flg -- 创新业务标志
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,ibank_lmt_type_cd -- 同业额度类型代码
    ,appl_syn_loan_tot -- 申请银团贷款总额
    ,fit_in_single_cust_or_group_lmt_flg -- 纳入单一客户或集团限额标志
    ,comb_class_consmt_flg -- 集合类代销标志
    ,set_single_cust_lmt_flg -- 设置单一客户限额标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_cont_lmt_attach_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,cont_id -- 合同编号
    ,lmt_next_bus_higt_pm_rat -- 额度下业务最高抵质押率
    ,lmt_next_bus_init_margin_ratio -- 额度下业务初始保证金比例
    ,lmt_next_bus_int_rat_lowt_flo_val -- 额度下业务利率最低浮动值
    ,lmt_next_bus_sig_max_amt -- 额度下业务单笔最大金额
    ,lmt_next_bus_lont_tenor -- 额度下业务最长期限
    ,lmt_next_bus_delay_renew_tenor -- 额度下业务延展期限
    ,lmt_under_bus_latest_exp_dt -- 额度项下业务最迟到期日期
    ,lmt_invalid_dt -- 额度失效日期
    ,fin_cont_flg -- 融资合同标志
    ,public_crdt_flg -- 公开授信标志
    ,turn_crdt_flg -- 转授信标志
    ,crdt_rg_cd -- 授信区域代码
    ,crdt_bus_flow_type_cd -- 授信业务流程类型代码
    ,lmt_dir_use_flg -- 额度可直接使用标志
    ,tenor_type_cd -- 期限类型代码
    ,lmt_kind_cd -- 额度种类代码
    ,group_lmt_crtl_mode_cd -- 集团额度管控模式代码
    ,under_bus_curr_cd_range -- 项下业务币种代码范围
    ,lmt_nmal_amt -- 额度名义金额
    ,lmt_open_amt -- 额度敞口金额
    ,used_nmal_amt -- 已用敞口金额
    ,used_open_amt -- 已用授信额度
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,syn_loan_tot_amt -- 银团贷款总金额
    ,major_loan_cls_cd -- 专业贷款分类代码
    ,risk_expose_cls -- 风险暴露分类代码
    ,invo_estate_fin_flg -- 涉及房地产融资标志
    ,invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,br_build_ifin_flg -- 一带一路建设投融资标志
    ,col_turn_margin_acct_id -- 押品转保证金账户编号
    ,lmt_use_cond_descb -- 额度使用条件描述
    ,froz_flg -- 冻结标志
    ,prtcptr_way_cd -- 参与方式代码
    ,onl_lmt -- 线上额度
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,green_crdt_fin_flg -- 绿色信贷融资标志
    ,invest_way_cd -- 投资方式代码
    ,class_crdt_flg -- 类信贷标志
    ,distr_org_id -- 放贷机构编号
    ,passer_id -- 通道方编号
    ,passer_name -- 通道方名称
    ,cap_src_cd -- 资金来源代码
    ,ext_bond_item_rating_cd -- 外部债项评级代码
    ,ext_rating_org_name -- 外部评级机构名称
    ,ext_rating_dt -- 外部评级日期
    ,col_turn_margin_sub_acct_num -- 押品转保证金子户号
    ,lon_post_mgmt_teller_id -- 贷后管理柜员编号
    ,lon_post_mgmt_org_id -- 贷后管理机构编号
    ,debt_regroup_cnt -- 债务重组次数
    ,auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,comn_risk_open_amt -- 一般风险敞口金额
    ,class_low_risk_open_amt -- 类低风险敞口金额
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,single_higt_crdt_lmt_nmal_amt -- 单一最高授信额度名义金额
    ,single_higt_crdt_lmt_open_amt -- 单一最高授信额度敞口金额
    ,cent_mgmt_dept_id -- 归口管理部门编号
    ,level5_cls_cd -- 五级分类代码
    ,have_incre_crdt_flg -- 有增信标志
    ,ext_main_rating_cd -- 外部主体评级代码
    ,main_rating_org_name -- 主体评级机构名称
    ,main_rating_dt -- 主体评级日期
    ,loan_usage_descb -- 贷款用途描述
    ,invest_underly_descb -- 投资标的描述
    ,issuer_name -- 发行人名称
    ,issuer_cust_id -- 发行人客户编号
    ,mger_name -- 管理人名称
    ,mger_cust_id -- 管理人客户编号
    ,pente_flg -- 可穿透标志
    ,sup_chain_bus_ocup_core_corp_lmt_flg -- 供应链业务单占核心企业额度标志
    ,class_low_risk_flg -- 类低风险标志
    ,inovt_bus_flg -- 创新业务标志
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,ibank_lmt_type_cd -- 同业额度类型代码
    ,appl_syn_loan_tot -- 申请银团贷款总额
    ,fit_in_single_cust_or_group_lmt_flg -- 纳入单一客户或集团限额标志
    ,comb_class_consmt_flg -- 集合类代销标志
    ,set_single_cust_lmt_flg -- 设置单一客户限额标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.cont_id -- 合同编号
    ,o.lmt_next_bus_higt_pm_rat -- 额度下业务最高抵质押率
    ,o.lmt_next_bus_init_margin_ratio -- 额度下业务初始保证金比例
    ,o.lmt_next_bus_int_rat_lowt_flo_val -- 额度下业务利率最低浮动值
    ,o.lmt_next_bus_sig_max_amt -- 额度下业务单笔最大金额
    ,o.lmt_next_bus_lont_tenor -- 额度下业务最长期限
    ,o.lmt_next_bus_delay_renew_tenor -- 额度下业务延展期限
    ,o.lmt_under_bus_latest_exp_dt -- 额度项下业务最迟到期日期
    ,o.lmt_invalid_dt -- 额度失效日期
    ,o.fin_cont_flg -- 融资合同标志
    ,o.public_crdt_flg -- 公开授信标志
    ,o.turn_crdt_flg -- 转授信标志
    ,o.crdt_rg_cd -- 授信区域代码
    ,o.crdt_bus_flow_type_cd -- 授信业务流程类型代码
    ,o.lmt_dir_use_flg -- 额度可直接使用标志
    ,o.tenor_type_cd -- 期限类型代码
    ,o.lmt_kind_cd -- 额度种类代码
    ,o.group_lmt_crtl_mode_cd -- 集团额度管控模式代码
    ,o.under_bus_curr_cd_range -- 项下业务币种代码范围
    ,o.lmt_nmal_amt -- 额度名义金额
    ,o.lmt_open_amt -- 额度敞口金额
    ,o.used_nmal_amt -- 已用敞口金额
    ,o.used_open_amt -- 已用授信额度
    ,o.aval_nmal_amt -- 可用名义金额
    ,o.aval_open_amt -- 可用敞口金额
    ,o.syn_loan_tot_amt -- 银团贷款总金额
    ,o.major_loan_cls_cd -- 专业贷款分类代码
    ,o.risk_expose_cls -- 风险暴露分类代码
    ,o.invo_estate_fin_flg -- 涉及房地产融资标志
    ,o.invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,o.br_build_ifin_flg -- 一带一路建设投融资标志
    ,o.col_turn_margin_acct_id -- 押品转保证金账户编号
    ,o.lmt_use_cond_descb -- 额度使用条件描述
    ,o.froz_flg -- 冻结标志
    ,o.prtcptr_way_cd -- 参与方式代码
    ,o.onl_lmt -- 线上额度
    ,o.consm_serv_class_fin_flg -- 消费服务类融资标志
    ,o.green_crdt_fin_flg -- 绿色信贷融资标志
    ,o.invest_way_cd -- 投资方式代码
    ,o.class_crdt_flg -- 类信贷标志
    ,o.distr_org_id -- 放贷机构编号
    ,o.passer_id -- 通道方编号
    ,o.passer_name -- 通道方名称
    ,o.cap_src_cd -- 资金来源代码
    ,o.ext_bond_item_rating_cd -- 外部债项评级代码
    ,o.ext_rating_org_name -- 外部评级机构名称
    ,o.ext_rating_dt -- 外部评级日期
    ,o.col_turn_margin_sub_acct_num -- 押品转保证金子户号
    ,o.lon_post_mgmt_teller_id -- 贷后管理柜员编号
    ,o.lon_post_mgmt_org_id -- 贷后管理机构编号
    ,o.debt_regroup_cnt -- 债务重组次数
    ,o.auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,o.comn_risk_open_amt -- 一般风险敞口金额
    ,o.class_low_risk_open_amt -- 类低风险敞口金额
    ,o.ocup_o_use_lmt_flg -- 占用他用额度标志
    ,o.single_higt_crdt_lmt_nmal_amt -- 单一最高授信额度名义金额
    ,o.single_higt_crdt_lmt_open_amt -- 单一最高授信额度敞口金额
    ,o.cent_mgmt_dept_id -- 归口管理部门编号
    ,o.level5_cls_cd -- 五级分类代码
    ,o.have_incre_crdt_flg -- 有增信标志
    ,o.ext_main_rating_cd -- 外部主体评级代码
    ,o.main_rating_org_name -- 主体评级机构名称
    ,o.main_rating_dt -- 主体评级日期
    ,o.loan_usage_descb -- 贷款用途描述
    ,o.invest_underly_descb -- 投资标的描述
    ,o.issuer_name -- 发行人名称
    ,o.issuer_cust_id -- 发行人客户编号
    ,o.mger_name -- 管理人名称
    ,o.mger_cust_id -- 管理人客户编号
    ,o.pente_flg -- 可穿透标志
    ,o.sup_chain_bus_ocup_core_corp_lmt_flg -- 供应链业务单占核心企业额度标志
    ,o.class_low_risk_flg -- 类低风险标志
    ,o.inovt_bus_flg -- 创新业务标志
    ,o.sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,o.ibank_lmt_type_cd -- 同业额度类型代码
    ,o.appl_syn_loan_tot -- 申请银团贷款总额
    ,o.fit_in_single_cust_or_group_lmt_flg -- 纳入单一客户或集团限额标志
    ,o.comb_class_consmt_flg -- 集合类代销标志
    ,o.set_single_cust_lmt_flg -- 设置单一客户限额标志
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
from ${iml_schema}.agt_loan_cont_lmt_attach_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_cont_lmt_attach_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.cont_id = n.cont_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_cont_lmt_attach_info_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.cont_id = d.cont_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_cont_lmt_attach_info_h;
--alter table ${iml_schema}.agt_loan_cont_lmt_attach_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_cont_lmt_attach_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_cont_lmt_attach_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_cont_lmt_attach_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_cont_lmt_attach_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_cont_lmt_attach_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_cont_lmt_attach_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_cont_lmt_attach_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_cont_lmt_attach_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_cont_lmt_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_cont_lmt_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_cont_lmt_attach_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_cont_lmt_attach_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_cont_lmt_attach_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
