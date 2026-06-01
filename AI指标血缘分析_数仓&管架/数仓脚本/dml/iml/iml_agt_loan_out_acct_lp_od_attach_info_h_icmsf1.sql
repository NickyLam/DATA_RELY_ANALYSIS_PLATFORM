/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_out_acct_lp_od_attach_info_h_icmsf1
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
alter table ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,text_cont_id -- 文本合同编号
    ,cont_amt -- 合同金额
    ,od_cust_id -- 透支客户编号
    ,od_acct_id -- 透支账户编号
    ,od_cust_name -- 透支客户名称
    ,od_sub_acct_num -- 透支子账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,od_lmt -- 透支额度
    ,od_int_rat -- 透支利率
    ,start_od_amt -- 起透金额
    ,reval_way_cd -- 重定价方式代码
    ,base_int_rat -- 基准利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,nomal_loan_exec_int_rat -- 正常贷款执行利率
    ,nomal_loan_float_int_rat -- 正常贷款浮动利率
    ,comm_fee_fee_rat -- 手续费费率
    ,od_promis_fee -- 透支承诺费用
    ,od_repay_way_cd -- 透支还款方式代码
    ,recvbl_freq_cd -- 收款频率代码
    ,charge_dt -- 收费日
    ,sig_od_valid_days -- 单笔透支有效天数
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,lp_od_nacrsm_free_int_days -- 法透不跨月免息天数
    ,lp_od_lmt_begin_dt -- 法透额度起始日期
    ,lp_od_lmt_exp_dt -- 法透额度到期日期
    ,ovdue_loan_float_int_rat -- 逾期贷款浮动利率
    ,lp_od_not_acrs_mon_idf_cd -- 法透不跨月标识代码
    ,lp_od_type_cd -- 法人透支类型代码
    ,temp_store_flg -- 暂存标志
    ,buid_bus_guar_loan_type_cd -- 创业担保贷款类型代码
    ,prior_use_acct_bal_flg -- 优先使用账户余额标志
    ,buid_bus_guar_loan_flg -- 创业担保贷款标志
    ,nat_std_indus_dir_cd -- 国标行业投向代码
    ,agclt_flg -- 涉农贷款标志
    ,agclt_loan_main_type_cd -- 涉农贷款主体类型代码
    ,agclt_loan_dir_cd -- 涉农贷款用途类型代码
    ,land_fin_plat_cap_src_cd -- 地方融资平台偿债资金来源代码
    ,pla_trast_way_cd -- 贷款办理方式代码
    ,int_set_way_cd -- 结息方式代码
    ,file_int_flg -- 靠档利息标志
    ,cap_usage_descb -- 资金用途描述
    ,move_remark -- 迁移备注
    ,rgst_dt -- 登记日期
    ,oper_teller_id -- 经办柜员编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,loan_org_id -- 贷款机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,src_agt_id -- 源协议编号
    ,task_status_cd -- 任务状态代码
    ,int_rat_float_ped -- 利率浮动周期代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,comm_fee_charge_day -- 手续费收费日
    ,comm_fee_coll_way_cd -- 手续费收取方式代码
    ,comm_fee_charge_freq_cd -- 手续费收费频率代码
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,sup_chain_fin_bus_prod_cls_cd -- 供应链金融业务产品分类代码
    ,natnal_econ_type_cd -- 国民经济类型代码
    ,corp_size_cd -- 企业规模代码
    ,risk_cls_rest_cd -- 风险分类结果代码
    ,dmic_st_msg_send_cd -- 业务提醒短信发送时机代码
    ,final_update_dt -- 最后更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_business_fatou_putout-1
insert into ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h_icmsf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,text_cont_id -- 文本合同编号
    ,cont_amt -- 合同金额
    ,od_cust_id -- 透支客户编号
    ,od_acct_id -- 透支账户编号
    ,od_cust_name -- 透支客户名称
    ,od_sub_acct_num -- 透支子账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,od_lmt -- 透支额度
    ,od_int_rat -- 透支利率
    ,start_od_amt -- 起透金额
    ,reval_way_cd -- 重定价方式代码
    ,base_int_rat -- 基准利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,nomal_loan_exec_int_rat -- 正常贷款执行利率
    ,nomal_loan_float_int_rat -- 正常贷款浮动利率
    ,comm_fee_fee_rat -- 手续费费率
    ,od_promis_fee -- 透支承诺费用
    ,od_repay_way_cd -- 透支还款方式代码
    ,recvbl_freq_cd -- 收款频率代码
    ,charge_dt -- 收费日
    ,sig_od_valid_days -- 单笔透支有效天数
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,lp_od_nacrsm_free_int_days -- 法透不跨月免息天数
    ,lp_od_lmt_begin_dt -- 法透额度起始日期
    ,lp_od_lmt_exp_dt -- 法透额度到期日期
    ,ovdue_loan_float_int_rat -- 逾期贷款浮动利率
    ,lp_od_not_acrs_mon_idf_cd -- 法透不跨月标识代码
    ,lp_od_type_cd -- 法人透支类型代码
    ,temp_store_flg -- 暂存标志
    ,buid_bus_guar_loan_type_cd -- 创业担保贷款类型代码
    ,prior_use_acct_bal_flg -- 优先使用账户余额标志
    ,buid_bus_guar_loan_flg -- 创业担保贷款标志
    ,nat_std_indus_dir_cd -- 国标行业投向代码
    ,agclt_flg -- 涉农贷款标志
    ,agclt_loan_main_type_cd -- 涉农贷款主体类型代码
    ,agclt_loan_dir_cd -- 涉农贷款用途类型代码
    ,land_fin_plat_cap_src_cd -- 地方融资平台偿债资金来源代码
    ,pla_trast_way_cd -- 贷款办理方式代码
    ,int_set_way_cd -- 结息方式代码
    ,file_int_flg -- 靠档利息标志
    ,cap_usage_descb -- 资金用途描述
    ,move_remark -- 迁移备注
    ,rgst_dt -- 登记日期
    ,oper_teller_id -- 经办柜员编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,loan_org_id -- 贷款机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,src_agt_id -- 源协议编号
    ,task_status_cd -- 任务状态代码
    ,int_rat_float_ped -- 利率浮动周期代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,comm_fee_charge_day -- 手续费收费日
    ,comm_fee_coll_way_cd -- 手续费收取方式代码
    ,comm_fee_charge_freq_cd -- 手续费收费频率代码
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,sup_chain_fin_bus_prod_cls_cd -- 供应链金融业务产品分类代码
    ,natnal_econ_type_cd -- 国民经济类型代码
    ,corp_size_cd -- 企业规模代码
    ,risk_cls_rest_cd -- 风险分类结果代码
    ,dmic_st_msg_send_cd -- 业务提醒短信发送时机代码
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206001'||P1.SERIALNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 出账流水号
    ,P1.CONTRACTSERIALNO -- 合同编号
    ,P1.ARTIFICIALNO -- 文本合同编号
    ,nvl(trim(P1.CONTRACTSUM),0) -- 合同金额
    ,P1.CUSTOMERID -- 透支客户编号
    ,P1.ACCOUNTNO1 -- 透支账户编号
    ,P1.CUSTOMERNAME -- 透支客户名称
    ,P1.SUBSAC -- 透支子账号
    ,P1.BUSINESSTYPE -- 产品编号
    ,nvl(trim(P1.BUSINESSCURRENCY),'-') -- 币种代码
    ,P1.LOANAM -- 透支额度
    ,nvl(trim(P1.TZRATE),0) -- 透支利率
    ,P1.OVDRMI -- 起透金额
    ,nvl(trim(P1.RATEGENRE),'-') -- 重定价方式代码
    ,P1.BASERATE -- 基准利率
    ,nvl(trim(P1.BASERATETYPE),'-') -- 基准利率类型代码
    ,P1.BUSINESSRATE -- 正常贷款执行利率
    ,P1.RATEFLOAT -- 正常贷款浮动利率
    ,P1.FEEIVL -- 手续费费率
    ,P1.LNCMAM -- 透支承诺费用
    ,nvl(trim(P1.LONTYP),'-') -- 透支还款方式代码
    ,nvl(trim(P1.FRECHARGER),'-') -- 收款频率代码
    ,P1.BINLLINGDAY -- 收费日
    ,P1.DAYNUM -- 单笔透支有效天数
    ,P1.OVERDUERATE -- 逾期执行利率
    ,P1.ODRFREEINTEREST -- 法透不跨月免息天数
    ,P1.ODRPUTOUTDATE -- 法透额度起始日期
    ,P1.ODRMATURITY -- 法透额度到期日期
    ,P1.OVERDUEFLOAT -- 逾期贷款浮动利率
    ,decode(trim(P1.ODRNEXTMONTH),'','-','0','3',P1.ODRNEXTMONTH) -- 法透不跨月标识代码
    ,nvl(trim(P1.OVTYPE),'-') -- 法人透支类型代码
    ,nvl(trim(P1.TEMPSAVEFLAG),'-') -- 暂存标志
    ,nvl(trim(P1.CAREERGUARANTEELOANTYPE),'-') -- 创业担保贷款类型代码
    ,nvl(trim(P1.OBLOPT),'-')  -- 优先使用账户余额标志
    ,nvl(trim(P1.ISCAREERGUARANTEELOAN),'-') -- 创业担保贷款标志
    ,nvl(trim(P1.DIRECTIONNEW),'-') -- 国标行业投向代码
    ,nvl(trim(P1.ISFARMING),'-') -- 涉农贷款标志
    ,nvl(trim(P1.FARMINGLOANTYPE),'-') -- 涉农贷款主体类型代码
    ,nvl(trim(P1.FARMINGLOANUSE),'-') -- 涉农贷款用途类型代码
    ,nvl(trim(P1.PLATFORMPAYCASHSOURCE),'-') -- 地方融资平台偿债资金来源代码
    ,nvl(trim(P1.LOANHANDLECHANNEL),'-') -- 贷款办理方式代码
    ,nvl(trim(P1.ACCEPTINTTYPE),'-') -- 结息方式代码
    ,P1.SECTIONALINTEREST -- 靠档利息标志
    ,P1.PURPOSE -- 资金用途描述
    ,P1.MIGTFLAG -- 迁移备注
    ,P1.INPUTDATE -- 登记日期
    ,P1.OPERATEUSERID -- 经办柜员编号
    ,P1.OPERATEDATE -- 经办日期
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.LENDINGORGID -- 贷款机构编号
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.AGREEMENTID -- 源协议编号
    ,nvl(trim(P1.STATUS),'-') -- 任务状态代码
    ,decode(P1.OVERDUEFLOATCYCLE,'2','3',' ','-',P1.OVERDUEFLOATCYCLE) -- 利率浮动周期代码
    ,nvl(trim(P1.OVERDUEFLOATMODEL),'-') -- 利率浮动方式代码
    ,P1.FEEDATE -- 手续费收费日
    ,nvl(trim(P1.FEEMODEL),'-') -- 手续费收取方式代码
    ,nvl(trim(P1.FEEFREQUENCY),'-') -- 手续费收费频率代码
    ,nvl(trim(P1.ISSUPPLYCHAINFINANCE),'-') -- 供应链金融业务标志
    ,nvl(trim(P1.SUPPLYCHAINFINANCETYPE),'00') -- 供应链金融业务产品分类代码
    ,nvl(trim(P1.ECODEPARTMENTCODE),'000') -- 国民经济类型代码
    ,nvl(trim(P1.ENTSCALE),'0') -- 企业规模代码
    ,nvl(trim(P1.CLASSIFYRESULTELEVEN),'20') -- 风险分类结果代码
    ,nvl(trim(P1.BENGDT),'-') -- 业务提醒短信发送时机代码
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_business_fatou_putout' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_business_fatou_putout p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h_icmsf1_tm 
  	                                group by 
  	                                        appl_id
  	                                        ,lp_id
  	                                        ,out_acct_flow_num
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
        into ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,text_cont_id -- 文本合同编号
    ,cont_amt -- 合同金额
    ,od_cust_id -- 透支客户编号
    ,od_acct_id -- 透支账户编号
    ,od_cust_name -- 透支客户名称
    ,od_sub_acct_num -- 透支子账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,od_lmt -- 透支额度
    ,od_int_rat -- 透支利率
    ,start_od_amt -- 起透金额
    ,reval_way_cd -- 重定价方式代码
    ,base_int_rat -- 基准利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,nomal_loan_exec_int_rat -- 正常贷款执行利率
    ,nomal_loan_float_int_rat -- 正常贷款浮动利率
    ,comm_fee_fee_rat -- 手续费费率
    ,od_promis_fee -- 透支承诺费用
    ,od_repay_way_cd -- 透支还款方式代码
    ,recvbl_freq_cd -- 收款频率代码
    ,charge_dt -- 收费日
    ,sig_od_valid_days -- 单笔透支有效天数
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,lp_od_nacrsm_free_int_days -- 法透不跨月免息天数
    ,lp_od_lmt_begin_dt -- 法透额度起始日期
    ,lp_od_lmt_exp_dt -- 法透额度到期日期
    ,ovdue_loan_float_int_rat -- 逾期贷款浮动利率
    ,lp_od_not_acrs_mon_idf_cd -- 法透不跨月标识代码
    ,lp_od_type_cd -- 法人透支类型代码
    ,temp_store_flg -- 暂存标志
    ,buid_bus_guar_loan_type_cd -- 创业担保贷款类型代码
    ,prior_use_acct_bal_flg -- 优先使用账户余额标志
    ,buid_bus_guar_loan_flg -- 创业担保贷款标志
    ,nat_std_indus_dir_cd -- 国标行业投向代码
    ,agclt_flg -- 涉农贷款标志
    ,agclt_loan_main_type_cd -- 涉农贷款主体类型代码
    ,agclt_loan_dir_cd -- 涉农贷款用途类型代码
    ,land_fin_plat_cap_src_cd -- 地方融资平台偿债资金来源代码
    ,pla_trast_way_cd -- 贷款办理方式代码
    ,int_set_way_cd -- 结息方式代码
    ,file_int_flg -- 靠档利息标志
    ,cap_usage_descb -- 资金用途描述
    ,move_remark -- 迁移备注
    ,rgst_dt -- 登记日期
    ,oper_teller_id -- 经办柜员编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,loan_org_id -- 贷款机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,src_agt_id -- 源协议编号
    ,task_status_cd -- 任务状态代码
    ,int_rat_float_ped -- 利率浮动周期代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,comm_fee_charge_day -- 手续费收费日
    ,comm_fee_coll_way_cd -- 手续费收取方式代码
    ,comm_fee_charge_freq_cd -- 手续费收费频率代码
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,sup_chain_fin_bus_prod_cls_cd -- 供应链金融业务产品分类代码
    ,natnal_econ_type_cd -- 国民经济类型代码
    ,corp_size_cd -- 企业规模代码
    ,risk_cls_rest_cd -- 风险分类结果代码
    ,dmic_st_msg_send_cd -- 业务提醒短信发送时机代码
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,text_cont_id -- 文本合同编号
    ,cont_amt -- 合同金额
    ,od_cust_id -- 透支客户编号
    ,od_acct_id -- 透支账户编号
    ,od_cust_name -- 透支客户名称
    ,od_sub_acct_num -- 透支子账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,od_lmt -- 透支额度
    ,od_int_rat -- 透支利率
    ,start_od_amt -- 起透金额
    ,reval_way_cd -- 重定价方式代码
    ,base_int_rat -- 基准利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,nomal_loan_exec_int_rat -- 正常贷款执行利率
    ,nomal_loan_float_int_rat -- 正常贷款浮动利率
    ,comm_fee_fee_rat -- 手续费费率
    ,od_promis_fee -- 透支承诺费用
    ,od_repay_way_cd -- 透支还款方式代码
    ,recvbl_freq_cd -- 收款频率代码
    ,charge_dt -- 收费日
    ,sig_od_valid_days -- 单笔透支有效天数
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,lp_od_nacrsm_free_int_days -- 法透不跨月免息天数
    ,lp_od_lmt_begin_dt -- 法透额度起始日期
    ,lp_od_lmt_exp_dt -- 法透额度到期日期
    ,ovdue_loan_float_int_rat -- 逾期贷款浮动利率
    ,lp_od_not_acrs_mon_idf_cd -- 法透不跨月标识代码
    ,lp_od_type_cd -- 法人透支类型代码
    ,temp_store_flg -- 暂存标志
    ,buid_bus_guar_loan_type_cd -- 创业担保贷款类型代码
    ,prior_use_acct_bal_flg -- 优先使用账户余额标志
    ,buid_bus_guar_loan_flg -- 创业担保贷款标志
    ,nat_std_indus_dir_cd -- 国标行业投向代码
    ,agclt_flg -- 涉农贷款标志
    ,agclt_loan_main_type_cd -- 涉农贷款主体类型代码
    ,agclt_loan_dir_cd -- 涉农贷款用途类型代码
    ,land_fin_plat_cap_src_cd -- 地方融资平台偿债资金来源代码
    ,pla_trast_way_cd -- 贷款办理方式代码
    ,int_set_way_cd -- 结息方式代码
    ,file_int_flg -- 靠档利息标志
    ,cap_usage_descb -- 资金用途描述
    ,move_remark -- 迁移备注
    ,rgst_dt -- 登记日期
    ,oper_teller_id -- 经办柜员编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,loan_org_id -- 贷款机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,src_agt_id -- 源协议编号
    ,task_status_cd -- 任务状态代码
    ,int_rat_float_ped -- 利率浮动周期代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,comm_fee_charge_day -- 手续费收费日
    ,comm_fee_coll_way_cd -- 手续费收取方式代码
    ,comm_fee_charge_freq_cd -- 手续费收费频率代码
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,sup_chain_fin_bus_prod_cls_cd -- 供应链金融业务产品分类代码
    ,natnal_econ_type_cd -- 国民经济类型代码
    ,corp_size_cd -- 企业规模代码
    ,risk_cls_rest_cd -- 风险分类结果代码
    ,dmic_st_msg_send_cd -- 业务提醒短信发送时机代码
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
    ,nvl(n.out_acct_flow_num, o.out_acct_flow_num) as out_acct_flow_num -- 出账流水号
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.text_cont_id, o.text_cont_id) as text_cont_id -- 文本合同编号
    ,nvl(n.cont_amt, o.cont_amt) as cont_amt -- 合同金额
    ,nvl(n.od_cust_id, o.od_cust_id) as od_cust_id -- 透支客户编号
    ,nvl(n.od_acct_id, o.od_acct_id) as od_acct_id -- 透支账户编号
    ,nvl(n.od_cust_name, o.od_cust_name) as od_cust_name -- 透支客户名称
    ,nvl(n.od_sub_acct_num, o.od_sub_acct_num) as od_sub_acct_num -- 透支子账号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.od_lmt, o.od_lmt) as od_lmt -- 透支额度
    ,nvl(n.od_int_rat, o.od_int_rat) as od_int_rat -- 透支利率
    ,nvl(n.start_od_amt, o.start_od_amt) as start_od_amt -- 起透金额
    ,nvl(n.reval_way_cd, o.reval_way_cd) as reval_way_cd -- 重定价方式代码
    ,nvl(n.base_int_rat, o.base_int_rat) as base_int_rat -- 基准利率
    ,nvl(n.base_rat_type_cd, o.base_rat_type_cd) as base_rat_type_cd -- 基准利率类型代码
    ,nvl(n.nomal_loan_exec_int_rat, o.nomal_loan_exec_int_rat) as nomal_loan_exec_int_rat -- 正常贷款执行利率
    ,nvl(n.nomal_loan_float_int_rat, o.nomal_loan_float_int_rat) as nomal_loan_float_int_rat -- 正常贷款浮动利率
    ,nvl(n.comm_fee_fee_rat, o.comm_fee_fee_rat) as comm_fee_fee_rat -- 手续费费率
    ,nvl(n.od_promis_fee, o.od_promis_fee) as od_promis_fee -- 透支承诺费用
    ,nvl(n.od_repay_way_cd, o.od_repay_way_cd) as od_repay_way_cd -- 透支还款方式代码
    ,nvl(n.recvbl_freq_cd, o.recvbl_freq_cd) as recvbl_freq_cd -- 收款频率代码
    ,nvl(n.charge_dt, o.charge_dt) as charge_dt -- 收费日
    ,nvl(n.sig_od_valid_days, o.sig_od_valid_days) as sig_od_valid_days -- 单笔透支有效天数
    ,nvl(n.ovdue_exec_int_rat, o.ovdue_exec_int_rat) as ovdue_exec_int_rat -- 逾期执行利率
    ,nvl(n.lp_od_nacrsm_free_int_days, o.lp_od_nacrsm_free_int_days) as lp_od_nacrsm_free_int_days -- 法透不跨月免息天数
    ,nvl(n.lp_od_lmt_begin_dt, o.lp_od_lmt_begin_dt) as lp_od_lmt_begin_dt -- 法透额度起始日期
    ,nvl(n.lp_od_lmt_exp_dt, o.lp_od_lmt_exp_dt) as lp_od_lmt_exp_dt -- 法透额度到期日期
    ,nvl(n.ovdue_loan_float_int_rat, o.ovdue_loan_float_int_rat) as ovdue_loan_float_int_rat -- 逾期贷款浮动利率
    ,nvl(n.lp_od_not_acrs_mon_idf_cd, o.lp_od_not_acrs_mon_idf_cd) as lp_od_not_acrs_mon_idf_cd -- 法透不跨月标识代码
    ,nvl(n.lp_od_type_cd, o.lp_od_type_cd) as lp_od_type_cd -- 法人透支类型代码
    ,nvl(n.temp_store_flg, o.temp_store_flg) as temp_store_flg -- 暂存标志
    ,nvl(n.buid_bus_guar_loan_type_cd, o.buid_bus_guar_loan_type_cd) as buid_bus_guar_loan_type_cd -- 创业担保贷款类型代码
    ,nvl(n.prior_use_acct_bal_flg, o.prior_use_acct_bal_flg) as prior_use_acct_bal_flg -- 优先使用账户余额标志
    ,nvl(n.buid_bus_guar_loan_flg, o.buid_bus_guar_loan_flg) as buid_bus_guar_loan_flg -- 创业担保贷款标志
    ,nvl(n.nat_std_indus_dir_cd, o.nat_std_indus_dir_cd) as nat_std_indus_dir_cd -- 国标行业投向代码
    ,nvl(n.agclt_flg, o.agclt_flg) as agclt_flg -- 涉农贷款标志
    ,nvl(n.agclt_loan_main_type_cd, o.agclt_loan_main_type_cd) as agclt_loan_main_type_cd -- 涉农贷款主体类型代码
    ,nvl(n.agclt_loan_dir_cd, o.agclt_loan_dir_cd) as agclt_loan_dir_cd -- 涉农贷款用途类型代码
    ,nvl(n.land_fin_plat_cap_src_cd, o.land_fin_plat_cap_src_cd) as land_fin_plat_cap_src_cd -- 地方融资平台偿债资金来源代码
    ,nvl(n.pla_trast_way_cd, o.pla_trast_way_cd) as pla_trast_way_cd -- 贷款办理方式代码
    ,nvl(n.int_set_way_cd, o.int_set_way_cd) as int_set_way_cd -- 结息方式代码
    ,nvl(n.file_int_flg, o.file_int_flg) as file_int_flg -- 靠档利息标志
    ,nvl(n.cap_usage_descb, o.cap_usage_descb) as cap_usage_descb -- 资金用途描述
    ,nvl(n.move_remark, o.move_remark) as move_remark -- 迁移备注
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.oper_teller_id, o.oper_teller_id) as oper_teller_id -- 经办柜员编号
    ,nvl(n.oper_dt, o.oper_dt) as oper_dt -- 经办日期
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.loan_org_id, o.loan_org_id) as loan_org_id -- 贷款机构编号
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.src_agt_id, o.src_agt_id) as src_agt_id -- 源协议编号
    ,nvl(n.task_status_cd, o.task_status_cd) as task_status_cd -- 任务状态代码
    ,nvl(n.int_rat_float_ped, o.int_rat_float_ped) as int_rat_float_ped -- 利率浮动周期代码
    ,nvl(n.int_rat_float_way_cd, o.int_rat_float_way_cd) as int_rat_float_way_cd -- 利率浮动方式代码
    ,nvl(n.comm_fee_charge_day, o.comm_fee_charge_day) as comm_fee_charge_day -- 手续费收费日
    ,nvl(n.comm_fee_coll_way_cd, o.comm_fee_coll_way_cd) as comm_fee_coll_way_cd -- 手续费收取方式代码
    ,nvl(n.comm_fee_charge_freq_cd, o.comm_fee_charge_freq_cd) as comm_fee_charge_freq_cd -- 手续费收费频率代码
    ,nvl(n.sup_chain_fin_bus_flg, o.sup_chain_fin_bus_flg) as sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,nvl(n.sup_chain_fin_bus_prod_cls_cd, o.sup_chain_fin_bus_prod_cls_cd) as sup_chain_fin_bus_prod_cls_cd -- 供应链金融业务产品分类代码
    ,nvl(n.natnal_econ_type_cd, o.natnal_econ_type_cd) as natnal_econ_type_cd -- 国民经济类型代码
    ,nvl(n.corp_size_cd, o.corp_size_cd) as corp_size_cd -- 企业规模代码
    ,nvl(n.risk_cls_rest_cd, o.risk_cls_rest_cd) as risk_cls_rest_cd -- 风险分类结果代码
    ,nvl(n.dmic_st_msg_send_cd, o.dmic_st_msg_send_cd) as dmic_st_msg_send_cd -- 业务提醒短信发送时机代码
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.out_acct_flow_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.out_acct_flow_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.out_acct_flow_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.out_acct_flow_num = n.out_acct_flow_num
where (
        o.appl_id is null
        and o.lp_id is null
        and o.out_acct_flow_num is null
    )
    or (
        n.appl_id is null
        and n.lp_id is null
        and n.out_acct_flow_num is null
    )
    or (
        o.cont_id <> n.cont_id
        or o.text_cont_id <> n.text_cont_id
        or o.cont_amt <> n.cont_amt
        or o.od_cust_id <> n.od_cust_id
        or o.od_acct_id <> n.od_acct_id
        or o.od_cust_name <> n.od_cust_name
        or o.od_sub_acct_num <> n.od_sub_acct_num
        or o.prod_id <> n.prod_id
        or o.curr_cd <> n.curr_cd
        or o.od_lmt <> n.od_lmt
        or o.od_int_rat <> n.od_int_rat
        or o.start_od_amt <> n.start_od_amt
        or o.reval_way_cd <> n.reval_way_cd
        or o.base_int_rat <> n.base_int_rat
        or o.base_rat_type_cd <> n.base_rat_type_cd
        or o.nomal_loan_exec_int_rat <> n.nomal_loan_exec_int_rat
        or o.nomal_loan_float_int_rat <> n.nomal_loan_float_int_rat
        or o.comm_fee_fee_rat <> n.comm_fee_fee_rat
        or o.od_promis_fee <> n.od_promis_fee
        or o.od_repay_way_cd <> n.od_repay_way_cd
        or o.recvbl_freq_cd <> n.recvbl_freq_cd
        or o.charge_dt <> n.charge_dt
        or o.sig_od_valid_days <> n.sig_od_valid_days
        or o.ovdue_exec_int_rat <> n.ovdue_exec_int_rat
        or o.lp_od_nacrsm_free_int_days <> n.lp_od_nacrsm_free_int_days
        or o.lp_od_lmt_begin_dt <> n.lp_od_lmt_begin_dt
        or o.lp_od_lmt_exp_dt <> n.lp_od_lmt_exp_dt
        or o.ovdue_loan_float_int_rat <> n.ovdue_loan_float_int_rat
        or o.lp_od_not_acrs_mon_idf_cd <> n.lp_od_not_acrs_mon_idf_cd
        or o.lp_od_type_cd <> n.lp_od_type_cd
        or o.temp_store_flg <> n.temp_store_flg
        or o.buid_bus_guar_loan_type_cd <> n.buid_bus_guar_loan_type_cd
        or o.prior_use_acct_bal_flg <> n.prior_use_acct_bal_flg
        or o.buid_bus_guar_loan_flg <> n.buid_bus_guar_loan_flg
        or o.nat_std_indus_dir_cd <> n.nat_std_indus_dir_cd
        or o.agclt_flg <> n.agclt_flg
        or o.agclt_loan_main_type_cd <> n.agclt_loan_main_type_cd
        or o.agclt_loan_dir_cd <> n.agclt_loan_dir_cd
        or o.land_fin_plat_cap_src_cd <> n.land_fin_plat_cap_src_cd
        or o.pla_trast_way_cd <> n.pla_trast_way_cd
        or o.int_set_way_cd <> n.int_set_way_cd
        or o.file_int_flg <> n.file_int_flg
        or o.cap_usage_descb <> n.cap_usage_descb
        or o.move_remark <> n.move_remark
        or o.rgst_dt <> n.rgst_dt
        or o.oper_teller_id <> n.oper_teller_id
        or o.oper_dt <> n.oper_dt
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.loan_org_id <> n.loan_org_id
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.src_agt_id <> n.src_agt_id
        or o.task_status_cd <> n.task_status_cd
        or o.int_rat_float_ped <> n.int_rat_float_ped
        or o.int_rat_float_way_cd <> n.int_rat_float_way_cd
        or o.comm_fee_charge_day <> n.comm_fee_charge_day
        or o.comm_fee_coll_way_cd <> n.comm_fee_coll_way_cd
        or o.comm_fee_charge_freq_cd <> n.comm_fee_charge_freq_cd
        or o.sup_chain_fin_bus_flg <> n.sup_chain_fin_bus_flg
        or o.sup_chain_fin_bus_prod_cls_cd <> n.sup_chain_fin_bus_prod_cls_cd
        or o.natnal_econ_type_cd <> n.natnal_econ_type_cd
        or o.corp_size_cd <> n.corp_size_cd
        or o.risk_cls_rest_cd <> n.risk_cls_rest_cd
        or o.dmic_st_msg_send_cd <> n.dmic_st_msg_send_cd
        or o.final_update_dt <> n.final_update_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,text_cont_id -- 文本合同编号
    ,cont_amt -- 合同金额
    ,od_cust_id -- 透支客户编号
    ,od_acct_id -- 透支账户编号
    ,od_cust_name -- 透支客户名称
    ,od_sub_acct_num -- 透支子账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,od_lmt -- 透支额度
    ,od_int_rat -- 透支利率
    ,start_od_amt -- 起透金额
    ,reval_way_cd -- 重定价方式代码
    ,base_int_rat -- 基准利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,nomal_loan_exec_int_rat -- 正常贷款执行利率
    ,nomal_loan_float_int_rat -- 正常贷款浮动利率
    ,comm_fee_fee_rat -- 手续费费率
    ,od_promis_fee -- 透支承诺费用
    ,od_repay_way_cd -- 透支还款方式代码
    ,recvbl_freq_cd -- 收款频率代码
    ,charge_dt -- 收费日
    ,sig_od_valid_days -- 单笔透支有效天数
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,lp_od_nacrsm_free_int_days -- 法透不跨月免息天数
    ,lp_od_lmt_begin_dt -- 法透额度起始日期
    ,lp_od_lmt_exp_dt -- 法透额度到期日期
    ,ovdue_loan_float_int_rat -- 逾期贷款浮动利率
    ,lp_od_not_acrs_mon_idf_cd -- 法透不跨月标识代码
    ,lp_od_type_cd -- 法人透支类型代码
    ,temp_store_flg -- 暂存标志
    ,buid_bus_guar_loan_type_cd -- 创业担保贷款类型代码
    ,prior_use_acct_bal_flg -- 优先使用账户余额标志
    ,buid_bus_guar_loan_flg -- 创业担保贷款标志
    ,nat_std_indus_dir_cd -- 国标行业投向代码
    ,agclt_flg -- 涉农贷款标志
    ,agclt_loan_main_type_cd -- 涉农贷款主体类型代码
    ,agclt_loan_dir_cd -- 涉农贷款用途类型代码
    ,land_fin_plat_cap_src_cd -- 地方融资平台偿债资金来源代码
    ,pla_trast_way_cd -- 贷款办理方式代码
    ,int_set_way_cd -- 结息方式代码
    ,file_int_flg -- 靠档利息标志
    ,cap_usage_descb -- 资金用途描述
    ,move_remark -- 迁移备注
    ,rgst_dt -- 登记日期
    ,oper_teller_id -- 经办柜员编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,loan_org_id -- 贷款机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,src_agt_id -- 源协议编号
    ,task_status_cd -- 任务状态代码
    ,int_rat_float_ped -- 利率浮动周期代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,comm_fee_charge_day -- 手续费收费日
    ,comm_fee_coll_way_cd -- 手续费收取方式代码
    ,comm_fee_charge_freq_cd -- 手续费收费频率代码
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,sup_chain_fin_bus_prod_cls_cd -- 供应链金融业务产品分类代码
    ,natnal_econ_type_cd -- 国民经济类型代码
    ,corp_size_cd -- 企业规模代码
    ,risk_cls_rest_cd -- 风险分类结果代码
    ,dmic_st_msg_send_cd -- 业务提醒短信发送时机代码
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,text_cont_id -- 文本合同编号
    ,cont_amt -- 合同金额
    ,od_cust_id -- 透支客户编号
    ,od_acct_id -- 透支账户编号
    ,od_cust_name -- 透支客户名称
    ,od_sub_acct_num -- 透支子账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,od_lmt -- 透支额度
    ,od_int_rat -- 透支利率
    ,start_od_amt -- 起透金额
    ,reval_way_cd -- 重定价方式代码
    ,base_int_rat -- 基准利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,nomal_loan_exec_int_rat -- 正常贷款执行利率
    ,nomal_loan_float_int_rat -- 正常贷款浮动利率
    ,comm_fee_fee_rat -- 手续费费率
    ,od_promis_fee -- 透支承诺费用
    ,od_repay_way_cd -- 透支还款方式代码
    ,recvbl_freq_cd -- 收款频率代码
    ,charge_dt -- 收费日
    ,sig_od_valid_days -- 单笔透支有效天数
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,lp_od_nacrsm_free_int_days -- 法透不跨月免息天数
    ,lp_od_lmt_begin_dt -- 法透额度起始日期
    ,lp_od_lmt_exp_dt -- 法透额度到期日期
    ,ovdue_loan_float_int_rat -- 逾期贷款浮动利率
    ,lp_od_not_acrs_mon_idf_cd -- 法透不跨月标识代码
    ,lp_od_type_cd -- 法人透支类型代码
    ,temp_store_flg -- 暂存标志
    ,buid_bus_guar_loan_type_cd -- 创业担保贷款类型代码
    ,prior_use_acct_bal_flg -- 优先使用账户余额标志
    ,buid_bus_guar_loan_flg -- 创业担保贷款标志
    ,nat_std_indus_dir_cd -- 国标行业投向代码
    ,agclt_flg -- 涉农贷款标志
    ,agclt_loan_main_type_cd -- 涉农贷款主体类型代码
    ,agclt_loan_dir_cd -- 涉农贷款用途类型代码
    ,land_fin_plat_cap_src_cd -- 地方融资平台偿债资金来源代码
    ,pla_trast_way_cd -- 贷款办理方式代码
    ,int_set_way_cd -- 结息方式代码
    ,file_int_flg -- 靠档利息标志
    ,cap_usage_descb -- 资金用途描述
    ,move_remark -- 迁移备注
    ,rgst_dt -- 登记日期
    ,oper_teller_id -- 经办柜员编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,loan_org_id -- 贷款机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,src_agt_id -- 源协议编号
    ,task_status_cd -- 任务状态代码
    ,int_rat_float_ped -- 利率浮动周期代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,comm_fee_charge_day -- 手续费收费日
    ,comm_fee_coll_way_cd -- 手续费收取方式代码
    ,comm_fee_charge_freq_cd -- 手续费收费频率代码
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,sup_chain_fin_bus_prod_cls_cd -- 供应链金融业务产品分类代码
    ,natnal_econ_type_cd -- 国民经济类型代码
    ,corp_size_cd -- 企业规模代码
    ,risk_cls_rest_cd -- 风险分类结果代码
    ,dmic_st_msg_send_cd -- 业务提醒短信发送时机代码
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
    ,o.out_acct_flow_num -- 出账流水号
    ,o.cont_id -- 合同编号
    ,o.text_cont_id -- 文本合同编号
    ,o.cont_amt -- 合同金额
    ,o.od_cust_id -- 透支客户编号
    ,o.od_acct_id -- 透支账户编号
    ,o.od_cust_name -- 透支客户名称
    ,o.od_sub_acct_num -- 透支子账号
    ,o.prod_id -- 产品编号
    ,o.curr_cd -- 币种代码
    ,o.od_lmt -- 透支额度
    ,o.od_int_rat -- 透支利率
    ,o.start_od_amt -- 起透金额
    ,o.reval_way_cd -- 重定价方式代码
    ,o.base_int_rat -- 基准利率
    ,o.base_rat_type_cd -- 基准利率类型代码
    ,o.nomal_loan_exec_int_rat -- 正常贷款执行利率
    ,o.nomal_loan_float_int_rat -- 正常贷款浮动利率
    ,o.comm_fee_fee_rat -- 手续费费率
    ,o.od_promis_fee -- 透支承诺费用
    ,o.od_repay_way_cd -- 透支还款方式代码
    ,o.recvbl_freq_cd -- 收款频率代码
    ,o.charge_dt -- 收费日
    ,o.sig_od_valid_days -- 单笔透支有效天数
    ,o.ovdue_exec_int_rat -- 逾期执行利率
    ,o.lp_od_nacrsm_free_int_days -- 法透不跨月免息天数
    ,o.lp_od_lmt_begin_dt -- 法透额度起始日期
    ,o.lp_od_lmt_exp_dt -- 法透额度到期日期
    ,o.ovdue_loan_float_int_rat -- 逾期贷款浮动利率
    ,o.lp_od_not_acrs_mon_idf_cd -- 法透不跨月标识代码
    ,o.lp_od_type_cd -- 法人透支类型代码
    ,o.temp_store_flg -- 暂存标志
    ,o.buid_bus_guar_loan_type_cd -- 创业担保贷款类型代码
    ,o.prior_use_acct_bal_flg -- 优先使用账户余额标志
    ,o.buid_bus_guar_loan_flg -- 创业担保贷款标志
    ,o.nat_std_indus_dir_cd -- 国标行业投向代码
    ,o.agclt_flg -- 涉农贷款标志
    ,o.agclt_loan_main_type_cd -- 涉农贷款主体类型代码
    ,o.agclt_loan_dir_cd -- 涉农贷款用途类型代码
    ,o.land_fin_plat_cap_src_cd -- 地方融资平台偿债资金来源代码
    ,o.pla_trast_way_cd -- 贷款办理方式代码
    ,o.int_set_way_cd -- 结息方式代码
    ,o.file_int_flg -- 靠档利息标志
    ,o.cap_usage_descb -- 资金用途描述
    ,o.move_remark -- 迁移备注
    ,o.rgst_dt -- 登记日期
    ,o.oper_teller_id -- 经办柜员编号
    ,o.oper_dt -- 经办日期
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.loan_org_id -- 贷款机构编号
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.src_agt_id -- 源协议编号
    ,o.task_status_cd -- 任务状态代码
    ,o.int_rat_float_ped -- 利率浮动周期代码
    ,o.int_rat_float_way_cd -- 利率浮动方式代码
    ,o.comm_fee_charge_day -- 手续费收费日
    ,o.comm_fee_coll_way_cd -- 手续费收取方式代码
    ,o.comm_fee_charge_freq_cd -- 手续费收费频率代码
    ,o.sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,o.sup_chain_fin_bus_prod_cls_cd -- 供应链金融业务产品分类代码
    ,o.natnal_econ_type_cd -- 国民经济类型代码
    ,o.corp_size_cd -- 企业规模代码
    ,o.risk_cls_rest_cd -- 风险分类结果代码
    ,o.dmic_st_msg_send_cd -- 业务提醒短信发送时机代码
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
from ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.out_acct_flow_num = n.out_acct_flow_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h_icmsf1_cl d
        on
            o.appl_id = d.appl_id
            and o.lp_id = d.lp_id
            and o.out_acct_flow_num = d.out_acct_flow_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h;
--alter table ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_out_acct_lp_od_attach_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_out_acct_lp_od_attach_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
