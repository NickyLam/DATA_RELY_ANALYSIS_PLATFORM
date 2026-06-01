/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_dubil_non_retl_attach_info_h_icmsf1
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
alter table ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,dubil_id -- 借据编号
    ,fee_rat -- 费率
    ,ped -- 周期
    ,int_accr_way_cd -- 计息方式代码
    ,pre_recv_int_flg -- 预收息标志
    ,loan_type_cd -- 贷款类型代码
    ,surp_perds -- 剩余期数
    ,eh_issue_deduct_amt -- 每期扣款金额
    ,acm_rtn_pric -- 累计归还本金
    ,acm_rtn_int -- 累计归还利息
    ,int_expns_fee_id -- 利息支出费用编号
    ,comm_fee_expns_fee_id -- 手续费支出费用编号
    ,next_term_rpp_dt -- 下一期还本日期
    ,next_term_rpp_amt -- 下一期还本金额
    ,next_term_repay_int_dt -- 下一期还息日期
    ,next_term_repay_int_amt -- 下一期还息金额
    ,advc_amt -- 垫款金额
    ,attach_rgst_dubil_flg -- 补登借据标志
    ,bill_uniq_ind_no -- 票据唯一标识号
    ,bill_id -- 票据编号
    ,bill_type_cd -- 票据类型代码
    ,bill_kind_cd -- 票据种类代码
    ,acpt_bank_no -- 承兑行行号
    ,acpt_bank_name -- 承兑行名称
    ,transf_type_cd -- 转让类型代码
    ,discount_int_rat -- 转贴现利率
    ,dir_paste_bank_no -- 直贴行行号
    ,dir_paste_bank_name -- 直贴行名称
    ,benefc_open_bank_no -- 受益人开户行行号
    ,benefc_open_bank_name -- 受益人开户行名称
    ,benefc_name -- 受益人名称
    ,bnft_bank_name -- 受益行名称
    ,open_flow_num -- 开立流水号
    ,open_dt -- 开立日期
    ,wrtoff_type_cd -- 注销类型代码
    ,wrtoff_flow_num -- 注销流水号
    ,wrtoff_dt -- 注销日期
    ,sell_status_cd -- 卖出状态代码
    ,attach_rgst_check_teller_id -- 补登复核柜员编号
    ,refac_batch_pkg_id -- 支小再批次包编号
    ,refac_batch_exp_dt -- 支小再批次到期日期
    ,refac_status_cd -- 支小再状态代码
    ,refac_invalid_tm -- 支小再失效时间
    ,edu_hea_flg -- 文教健康标志
    ,asset_id -- 资产编号
    ,acct_b_cate_cd -- 账簿类别代码
    ,matn_flg -- 维护标志
    ,bus_org_id -- 业务机构编号
    ,tran_org_id -- 交易机构编号
    ,batch_data_src_cd -- 批量数据来源代码
    ,dep_agt_id -- 存款协议编号
    ,benefc_cust_id -- 受益人客户编号
    ,deduct_dt -- 扣款日期
    ,int_adj -- 利息调整
    ,col_int_type_cd -- 收息类型代码
    ,acru_int -- 应计利息
    ,ibank_no -- 联行号
    ,rels_lmt_flg -- 释放额度标志
    ,accept_recv_flg -- 收票签收标志
    ,suit_fee -- 诉讼费
    ,ibank_syn_bus_sys_tran_dt -- 同业综合业务系统交易日期
    ,syn_loan_seq_num -- 银团贷款序号
    ,oc_curr_cd -- 原币币种代码
    ,oc_amt -- 原币金额
    ,init_asset_uniq_idf -- 原资产唯一标识
    ,final_modif_dt -- 最后修改日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_bd_extend_detail-1
insert into ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,dubil_id -- 借据编号
    ,fee_rat -- 费率
    ,ped -- 周期
    ,int_accr_way_cd -- 计息方式代码
    ,pre_recv_int_flg -- 预收息标志
    ,loan_type_cd -- 贷款类型代码
    ,surp_perds -- 剩余期数
    ,eh_issue_deduct_amt -- 每期扣款金额
    ,acm_rtn_pric -- 累计归还本金
    ,acm_rtn_int -- 累计归还利息
    ,int_expns_fee_id -- 利息支出费用编号
    ,comm_fee_expns_fee_id -- 手续费支出费用编号
    ,next_term_rpp_dt -- 下一期还本日期
    ,next_term_rpp_amt -- 下一期还本金额
    ,next_term_repay_int_dt -- 下一期还息日期
    ,next_term_repay_int_amt -- 下一期还息金额
    ,advc_amt -- 垫款金额
    ,attach_rgst_dubil_flg -- 补登借据标志
    ,bill_uniq_ind_no -- 票据唯一标识号
    ,bill_id -- 票据编号
    ,bill_type_cd -- 票据类型代码
    ,bill_kind_cd -- 票据种类代码
    ,acpt_bank_no -- 承兑行行号
    ,acpt_bank_name -- 承兑行名称
    ,transf_type_cd -- 转让类型代码
    ,discount_int_rat -- 转贴现利率
    ,dir_paste_bank_no -- 直贴行行号
    ,dir_paste_bank_name -- 直贴行名称
    ,benefc_open_bank_no -- 受益人开户行行号
    ,benefc_open_bank_name -- 受益人开户行名称
    ,benefc_name -- 受益人名称
    ,bnft_bank_name -- 受益行名称
    ,open_flow_num -- 开立流水号
    ,open_dt -- 开立日期
    ,wrtoff_type_cd -- 注销类型代码
    ,wrtoff_flow_num -- 注销流水号
    ,wrtoff_dt -- 注销日期
    ,sell_status_cd -- 卖出状态代码
    ,attach_rgst_check_teller_id -- 补登复核柜员编号
    ,refac_batch_pkg_id -- 支小再批次包编号
    ,refac_batch_exp_dt -- 支小再批次到期日期
    ,refac_status_cd -- 支小再状态代码
    ,refac_invalid_tm -- 支小再失效时间
    ,edu_hea_flg -- 文教健康标志
    ,asset_id -- 资产编号
    ,acct_b_cate_cd -- 账簿类别代码
    ,matn_flg -- 维护标志
    ,bus_org_id -- 业务机构编号
    ,tran_org_id -- 交易机构编号
    ,batch_data_src_cd -- 批量数据来源代码
    ,dep_agt_id -- 存款协议编号
    ,benefc_cust_id -- 受益人客户编号
    ,deduct_dt -- 扣款日期
    ,int_adj -- 利息调整
    ,col_int_type_cd -- 收息类型代码
    ,acru_int -- 应计利息
    ,ibank_no -- 联行号
    ,rels_lmt_flg -- 释放额度标志
    ,accept_recv_flg -- 收票签收标志
    ,suit_fee -- 诉讼费
    ,ibank_syn_bus_sys_tran_dt -- 同业综合业务系统交易日期
    ,syn_loan_seq_num -- 银团贷款序号
    ,oc_curr_cd -- 原币币种代码
    ,oc_amt -- 原币金额
    ,init_asset_uniq_idf -- 原资产唯一标识
    ,final_modif_dt -- 最后修改日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300004'||P1.SERIALNO -- 协议编号
    ,P1.SERIALNO -- 借据编号
    ,P1.PREMIUMRATE -- 费率
    ,P1.FIXTERM -- 周期
    ,nvl(trim(P1.ICTYPE),'-') -- 计息方式代码
    ,nvl(trim(P1.PREINTTYPE),'-') -- 预收息标志
    ,nvl(trim(P1.LOANTYPE),'-') -- 贷款类型代码
    ,P1.SURPLUSPHASES -- 剩余期数
    ,P1.EACMPRINCIPAL -- 每期扣款金额
    ,P1.INSUM -- 累计归还本金
    ,P1.INTERESTINSUM -- 累计归还利息
    ,P1.interexpnum -- 利息支出费用编号
    ,P1.commexpnum -- 手续费支出费用编号
    ,${iml_schema}.dateformat_max2(P1.NEXTPERIODRETURNPRINCIPALDATE) -- 下一期还本日期
    ,P1.NEXTPERIODRETURNPRINCIPALSUM -- 下一期还本金额
    ,${iml_schema}.dateformat_max2(P1.NEXTPERIODRETURNINTERESTDATE) -- 下一期还息日期
    ,P1.NEXTPERIODRETURNINTERESTSUM -- 下一期还息金额
    ,P1.ADVANCEFLAGSUM -- 垫款金额
    ,P1.FIXFLAG -- 补登借据标志
    ,P1.KEYNO -- 票据唯一标识号
    ,P1.BILLNO -- 票据编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.BILLTYPE END -- 票据类型代码
    ,nvl(trim(P1.BILLKIND),'0') -- 票据种类代码
    ,P1.ACCEPTBANKID -- 承兑行行号
    ,P1.ACCEPTBANKNAME -- 承兑行名称
    ,nvl(trim(P1.RESELLTYPE),'-') -- 转让类型代码
    ,P1.ZTRATE -- 转贴现利率
    ,P1.ZTACCEPTBANKID -- 直贴行行号
    ,P1.ZTACCEPTBANKNAME -- 直贴行名称
    ,P1.ABOUTBANKID2 -- 受益人开户行行号
    ,P1.BENEFITCORPBANK -- 受益人开户行名称
    ,P1.BENEFITCORPNAME -- 受益人名称
    ,P1.ABOUTBANKNAME2 -- 受益行名称
    ,P1.OPENNO -- 开立流水号
    ,${iml_schema}.dateformat_min(P1.OPENDATE) -- 开立日期
    ,nvl(trim(P1.LOGOUTTYPE),'-') -- 注销类型代码
    ,P1.LOGOUTNO -- 注销流水号
    ,${iml_schema}.dateformat_max2(P1.LOGOUTDATE) -- 注销日期
    ,nvl(trim(P1.sellstatus),'-') -- 卖出状态代码
    ,P1.REINFORCECHECKER -- 补登复核柜员编号
    ,P1.LITTLECREDITBATCHNO -- 支小再批次包编号
    ,${iml_schema}.dateformat_max2(P1.LITTLECREDITBATCHENDDATE) -- 支小再批次到期日期
    ,nvl(trim(P1.LITTLECREDITSTATUS),'-') -- 支小再状态代码
    ,${iml_schema}.timeformat_max2(P1.LITTLECREDITLAPSETIME) -- 支小再失效时间
    ,nvl(trim(P1.ISTEACHHEALTH),'-') -- 文教健康标志
    ,P1.ASSETNO -- 资产编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.ACCOUNTCATAGORY END -- 账簿类别代码
    ,nvl(trim(P1.ISINUSE),'-') -- 维护标志
    ,P1.BUSINESSDEPT -- 业务机构编号
    ,P1.TRADEORGID -- 交易机构编号
    ,nvl(trim(P1.DATATYPE),'-') -- 批量数据来源代码
    ,P1.AGREEMENTID -- 存款协议编号
    ,P1.BENEFITCORP -- 受益人客户编号
    ,${iml_schema}.dateformat_max2(P1.DEDUCTDATE) -- 扣款日期
    ,P1.NINTERESTADJUST -- 利息调整
    ,P1.ACCEPTINTTYPE -- 收息类型代码
    ,P1.NACCRUALINTEREST -- 应计利息
    ,P1.LENDER -- 联行号
    ,nvl(trim(P1.ISCREDITRELEASE),'-') -- 释放额度标志
    ,nvl(trim(P1.ISRECEIVEBILL),'-') -- 收票签收标志
    ,P1.LEGAL -- 诉讼费
    ,${iml_schema}.dateformat_max2(P1.TRANSDATE) -- 同业综合业务系统交易日期
    ,P1.DDNO -- 银团贷款序号
    ,nvl(trim(P1.ACTUALCURRENCY),'-') -- 原币币种代码
    ,P1.ACTUALBUSINESSSUM -- 原币金额
    ,P1.OLDASSETNO -- 原资产唯一标识
    ,P1.LASTMODIFIED -- 最后修改日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_bd_extend_detail' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_bd_extend_detail p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.BILLTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_BD_EXTEND_DETAIL'
        AND R1.SRC_FIELD_EN_NAME= 'BILLTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_LOAN_DUBIL_NON_RETL_ATTACH_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'BILL_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.ACCOUNTCATAGORY = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_BD_EXTEND_DETAIL'
        AND R2.SRC_FIELD_EN_NAME= 'ACCOUNTCATAGORY'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_LOAN_DUBIL_NON_RETL_ATTACH_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'ACCT_B_CATE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,dubil_id
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
        into ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,dubil_id -- 借据编号
    ,fee_rat -- 费率
    ,ped -- 周期
    ,int_accr_way_cd -- 计息方式代码
    ,pre_recv_int_flg -- 预收息标志
    ,loan_type_cd -- 贷款类型代码
    ,surp_perds -- 剩余期数
    ,eh_issue_deduct_amt -- 每期扣款金额
    ,acm_rtn_pric -- 累计归还本金
    ,acm_rtn_int -- 累计归还利息
    ,int_expns_fee_id -- 利息支出费用编号
    ,comm_fee_expns_fee_id -- 手续费支出费用编号
    ,next_term_rpp_dt -- 下一期还本日期
    ,next_term_rpp_amt -- 下一期还本金额
    ,next_term_repay_int_dt -- 下一期还息日期
    ,next_term_repay_int_amt -- 下一期还息金额
    ,advc_amt -- 垫款金额
    ,attach_rgst_dubil_flg -- 补登借据标志
    ,bill_uniq_ind_no -- 票据唯一标识号
    ,bill_id -- 票据编号
    ,bill_type_cd -- 票据类型代码
    ,bill_kind_cd -- 票据种类代码
    ,acpt_bank_no -- 承兑行行号
    ,acpt_bank_name -- 承兑行名称
    ,transf_type_cd -- 转让类型代码
    ,discount_int_rat -- 转贴现利率
    ,dir_paste_bank_no -- 直贴行行号
    ,dir_paste_bank_name -- 直贴行名称
    ,benefc_open_bank_no -- 受益人开户行行号
    ,benefc_open_bank_name -- 受益人开户行名称
    ,benefc_name -- 受益人名称
    ,bnft_bank_name -- 受益行名称
    ,open_flow_num -- 开立流水号
    ,open_dt -- 开立日期
    ,wrtoff_type_cd -- 注销类型代码
    ,wrtoff_flow_num -- 注销流水号
    ,wrtoff_dt -- 注销日期
    ,sell_status_cd -- 卖出状态代码
    ,attach_rgst_check_teller_id -- 补登复核柜员编号
    ,refac_batch_pkg_id -- 支小再批次包编号
    ,refac_batch_exp_dt -- 支小再批次到期日期
    ,refac_status_cd -- 支小再状态代码
    ,refac_invalid_tm -- 支小再失效时间
    ,edu_hea_flg -- 文教健康标志
    ,asset_id -- 资产编号
    ,acct_b_cate_cd -- 账簿类别代码
    ,matn_flg -- 维护标志
    ,bus_org_id -- 业务机构编号
    ,tran_org_id -- 交易机构编号
    ,batch_data_src_cd -- 批量数据来源代码
    ,dep_agt_id -- 存款协议编号
    ,benefc_cust_id -- 受益人客户编号
    ,deduct_dt -- 扣款日期
    ,int_adj -- 利息调整
    ,col_int_type_cd -- 收息类型代码
    ,acru_int -- 应计利息
    ,ibank_no -- 联行号
    ,rels_lmt_flg -- 释放额度标志
    ,accept_recv_flg -- 收票签收标志
    ,suit_fee -- 诉讼费
    ,ibank_syn_bus_sys_tran_dt -- 同业综合业务系统交易日期
    ,syn_loan_seq_num -- 银团贷款序号
    ,oc_curr_cd -- 原币币种代码
    ,oc_amt -- 原币金额
    ,init_asset_uniq_idf -- 原资产唯一标识
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,dubil_id -- 借据编号
    ,fee_rat -- 费率
    ,ped -- 周期
    ,int_accr_way_cd -- 计息方式代码
    ,pre_recv_int_flg -- 预收息标志
    ,loan_type_cd -- 贷款类型代码
    ,surp_perds -- 剩余期数
    ,eh_issue_deduct_amt -- 每期扣款金额
    ,acm_rtn_pric -- 累计归还本金
    ,acm_rtn_int -- 累计归还利息
    ,int_expns_fee_id -- 利息支出费用编号
    ,comm_fee_expns_fee_id -- 手续费支出费用编号
    ,next_term_rpp_dt -- 下一期还本日期
    ,next_term_rpp_amt -- 下一期还本金额
    ,next_term_repay_int_dt -- 下一期还息日期
    ,next_term_repay_int_amt -- 下一期还息金额
    ,advc_amt -- 垫款金额
    ,attach_rgst_dubil_flg -- 补登借据标志
    ,bill_uniq_ind_no -- 票据唯一标识号
    ,bill_id -- 票据编号
    ,bill_type_cd -- 票据类型代码
    ,bill_kind_cd -- 票据种类代码
    ,acpt_bank_no -- 承兑行行号
    ,acpt_bank_name -- 承兑行名称
    ,transf_type_cd -- 转让类型代码
    ,discount_int_rat -- 转贴现利率
    ,dir_paste_bank_no -- 直贴行行号
    ,dir_paste_bank_name -- 直贴行名称
    ,benefc_open_bank_no -- 受益人开户行行号
    ,benefc_open_bank_name -- 受益人开户行名称
    ,benefc_name -- 受益人名称
    ,bnft_bank_name -- 受益行名称
    ,open_flow_num -- 开立流水号
    ,open_dt -- 开立日期
    ,wrtoff_type_cd -- 注销类型代码
    ,wrtoff_flow_num -- 注销流水号
    ,wrtoff_dt -- 注销日期
    ,sell_status_cd -- 卖出状态代码
    ,attach_rgst_check_teller_id -- 补登复核柜员编号
    ,refac_batch_pkg_id -- 支小再批次包编号
    ,refac_batch_exp_dt -- 支小再批次到期日期
    ,refac_status_cd -- 支小再状态代码
    ,refac_invalid_tm -- 支小再失效时间
    ,edu_hea_flg -- 文教健康标志
    ,asset_id -- 资产编号
    ,acct_b_cate_cd -- 账簿类别代码
    ,matn_flg -- 维护标志
    ,bus_org_id -- 业务机构编号
    ,tran_org_id -- 交易机构编号
    ,batch_data_src_cd -- 批量数据来源代码
    ,dep_agt_id -- 存款协议编号
    ,benefc_cust_id -- 受益人客户编号
    ,deduct_dt -- 扣款日期
    ,int_adj -- 利息调整
    ,col_int_type_cd -- 收息类型代码
    ,acru_int -- 应计利息
    ,ibank_no -- 联行号
    ,rels_lmt_flg -- 释放额度标志
    ,accept_recv_flg -- 收票签收标志
    ,suit_fee -- 诉讼费
    ,ibank_syn_bus_sys_tran_dt -- 同业综合业务系统交易日期
    ,syn_loan_seq_num -- 银团贷款序号
    ,oc_curr_cd -- 原币币种代码
    ,oc_amt -- 原币金额
    ,init_asset_uniq_idf -- 原资产唯一标识
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.fee_rat, o.fee_rat) as fee_rat -- 费率
    ,nvl(n.ped, o.ped) as ped -- 周期
    ,nvl(n.int_accr_way_cd, o.int_accr_way_cd) as int_accr_way_cd -- 计息方式代码
    ,nvl(n.pre_recv_int_flg, o.pre_recv_int_flg) as pre_recv_int_flg -- 预收息标志
    ,nvl(n.loan_type_cd, o.loan_type_cd) as loan_type_cd -- 贷款类型代码
    ,nvl(n.surp_perds, o.surp_perds) as surp_perds -- 剩余期数
    ,nvl(n.eh_issue_deduct_amt, o.eh_issue_deduct_amt) as eh_issue_deduct_amt -- 每期扣款金额
    ,nvl(n.acm_rtn_pric, o.acm_rtn_pric) as acm_rtn_pric -- 累计归还本金
    ,nvl(n.acm_rtn_int, o.acm_rtn_int) as acm_rtn_int -- 累计归还利息
    ,nvl(n.int_expns_fee_id, o.int_expns_fee_id) as int_expns_fee_id -- 利息支出费用编号
    ,nvl(n.comm_fee_expns_fee_id, o.comm_fee_expns_fee_id) as comm_fee_expns_fee_id -- 手续费支出费用编号
    ,nvl(n.next_term_rpp_dt, o.next_term_rpp_dt) as next_term_rpp_dt -- 下一期还本日期
    ,nvl(n.next_term_rpp_amt, o.next_term_rpp_amt) as next_term_rpp_amt -- 下一期还本金额
    ,nvl(n.next_term_repay_int_dt, o.next_term_repay_int_dt) as next_term_repay_int_dt -- 下一期还息日期
    ,nvl(n.next_term_repay_int_amt, o.next_term_repay_int_amt) as next_term_repay_int_amt -- 下一期还息金额
    ,nvl(n.advc_amt, o.advc_amt) as advc_amt -- 垫款金额
    ,nvl(n.attach_rgst_dubil_flg, o.attach_rgst_dubil_flg) as attach_rgst_dubil_flg -- 补登借据标志
    ,nvl(n.bill_uniq_ind_no, o.bill_uniq_ind_no) as bill_uniq_ind_no -- 票据唯一标识号
    ,nvl(n.bill_id, o.bill_id) as bill_id -- 票据编号
    ,nvl(n.bill_type_cd, o.bill_type_cd) as bill_type_cd -- 票据类型代码
    ,nvl(n.bill_kind_cd, o.bill_kind_cd) as bill_kind_cd -- 票据种类代码
    ,nvl(n.acpt_bank_no, o.acpt_bank_no) as acpt_bank_no -- 承兑行行号
    ,nvl(n.acpt_bank_name, o.acpt_bank_name) as acpt_bank_name -- 承兑行名称
    ,nvl(n.transf_type_cd, o.transf_type_cd) as transf_type_cd -- 转让类型代码
    ,nvl(n.discount_int_rat, o.discount_int_rat) as discount_int_rat -- 转贴现利率
    ,nvl(n.dir_paste_bank_no, o.dir_paste_bank_no) as dir_paste_bank_no -- 直贴行行号
    ,nvl(n.dir_paste_bank_name, o.dir_paste_bank_name) as dir_paste_bank_name -- 直贴行名称
    ,nvl(n.benefc_open_bank_no, o.benefc_open_bank_no) as benefc_open_bank_no -- 受益人开户行行号
    ,nvl(n.benefc_open_bank_name, o.benefc_open_bank_name) as benefc_open_bank_name -- 受益人开户行名称
    ,nvl(n.benefc_name, o.benefc_name) as benefc_name -- 受益人名称
    ,nvl(n.bnft_bank_name, o.bnft_bank_name) as bnft_bank_name -- 受益行名称
    ,nvl(n.open_flow_num, o.open_flow_num) as open_flow_num -- 开立流水号
    ,nvl(n.open_dt, o.open_dt) as open_dt -- 开立日期
    ,nvl(n.wrtoff_type_cd, o.wrtoff_type_cd) as wrtoff_type_cd -- 注销类型代码
    ,nvl(n.wrtoff_flow_num, o.wrtoff_flow_num) as wrtoff_flow_num -- 注销流水号
    ,nvl(n.wrtoff_dt, o.wrtoff_dt) as wrtoff_dt -- 注销日期
    ,nvl(n.sell_status_cd, o.sell_status_cd) as sell_status_cd -- 卖出状态代码
    ,nvl(n.attach_rgst_check_teller_id, o.attach_rgst_check_teller_id) as attach_rgst_check_teller_id -- 补登复核柜员编号
    ,nvl(n.refac_batch_pkg_id, o.refac_batch_pkg_id) as refac_batch_pkg_id -- 支小再批次包编号
    ,nvl(n.refac_batch_exp_dt, o.refac_batch_exp_dt) as refac_batch_exp_dt -- 支小再批次到期日期
    ,nvl(n.refac_status_cd, o.refac_status_cd) as refac_status_cd -- 支小再状态代码
    ,nvl(n.refac_invalid_tm, o.refac_invalid_tm) as refac_invalid_tm -- 支小再失效时间
    ,nvl(n.edu_hea_flg, o.edu_hea_flg) as edu_hea_flg -- 文教健康标志
    ,nvl(n.asset_id, o.asset_id) as asset_id -- 资产编号
    ,nvl(n.acct_b_cate_cd, o.acct_b_cate_cd) as acct_b_cate_cd -- 账簿类别代码
    ,nvl(n.matn_flg, o.matn_flg) as matn_flg -- 维护标志
    ,nvl(n.bus_org_id, o.bus_org_id) as bus_org_id -- 业务机构编号
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.batch_data_src_cd, o.batch_data_src_cd) as batch_data_src_cd -- 批量数据来源代码
    ,nvl(n.dep_agt_id, o.dep_agt_id) as dep_agt_id -- 存款协议编号
    ,nvl(n.benefc_cust_id, o.benefc_cust_id) as benefc_cust_id -- 受益人客户编号
    ,nvl(n.deduct_dt, o.deduct_dt) as deduct_dt -- 扣款日期
    ,nvl(n.int_adj, o.int_adj) as int_adj -- 利息调整
    ,nvl(n.col_int_type_cd, o.col_int_type_cd) as col_int_type_cd -- 收息类型代码
    ,nvl(n.acru_int, o.acru_int) as acru_int -- 应计利息
    ,nvl(n.ibank_no, o.ibank_no) as ibank_no -- 联行号
    ,nvl(n.rels_lmt_flg, o.rels_lmt_flg) as rels_lmt_flg -- 释放额度标志
    ,nvl(n.accept_recv_flg, o.accept_recv_flg) as accept_recv_flg -- 收票签收标志
    ,nvl(n.suit_fee, o.suit_fee) as suit_fee -- 诉讼费
    ,nvl(n.ibank_syn_bus_sys_tran_dt, o.ibank_syn_bus_sys_tran_dt) as ibank_syn_bus_sys_tran_dt -- 同业综合业务系统交易日期
    ,nvl(n.syn_loan_seq_num, o.syn_loan_seq_num) as syn_loan_seq_num -- 银团贷款序号
    ,nvl(n.oc_curr_cd, o.oc_curr_cd) as oc_curr_cd -- 原币币种代码
    ,nvl(n.oc_amt, o.oc_amt) as oc_amt -- 原币金额
    ,nvl(n.init_asset_uniq_idf, o.init_asset_uniq_idf) as init_asset_uniq_idf -- 原资产唯一标识
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,case when
            n.agt_id is null
            and n.dubil_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.dubil_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.dubil_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.dubil_id = n.dubil_id
where (
        o.agt_id is null
        and o.dubil_id is null
    )
    or (
        n.agt_id is null
        and n.dubil_id is null
    )
    or (
        o.fee_rat <> n.fee_rat
        or o.ped <> n.ped
        or o.int_accr_way_cd <> n.int_accr_way_cd
        or o.pre_recv_int_flg <> n.pre_recv_int_flg
        or o.loan_type_cd <> n.loan_type_cd
        or o.surp_perds <> n.surp_perds
        or o.eh_issue_deduct_amt <> n.eh_issue_deduct_amt
        or o.acm_rtn_pric <> n.acm_rtn_pric
        or o.acm_rtn_int <> n.acm_rtn_int
        or o.int_expns_fee_id <> n.int_expns_fee_id
        or o.comm_fee_expns_fee_id <> n.comm_fee_expns_fee_id
        or o.next_term_rpp_dt <> n.next_term_rpp_dt
        or o.next_term_rpp_amt <> n.next_term_rpp_amt
        or o.next_term_repay_int_dt <> n.next_term_repay_int_dt
        or o.next_term_repay_int_amt <> n.next_term_repay_int_amt
        or o.advc_amt <> n.advc_amt
        or o.attach_rgst_dubil_flg <> n.attach_rgst_dubil_flg
        or o.bill_uniq_ind_no <> n.bill_uniq_ind_no
        or o.bill_id <> n.bill_id
        or o.bill_type_cd <> n.bill_type_cd
        or o.bill_kind_cd <> n.bill_kind_cd
        or o.acpt_bank_no <> n.acpt_bank_no
        or o.acpt_bank_name <> n.acpt_bank_name
        or o.transf_type_cd <> n.transf_type_cd
        or o.discount_int_rat <> n.discount_int_rat
        or o.dir_paste_bank_no <> n.dir_paste_bank_no
        or o.dir_paste_bank_name <> n.dir_paste_bank_name
        or o.benefc_open_bank_no <> n.benefc_open_bank_no
        or o.benefc_open_bank_name <> n.benefc_open_bank_name
        or o.benefc_name <> n.benefc_name
        or o.bnft_bank_name <> n.bnft_bank_name
        or o.open_flow_num <> n.open_flow_num
        or o.open_dt <> n.open_dt
        or o.wrtoff_type_cd <> n.wrtoff_type_cd
        or o.wrtoff_flow_num <> n.wrtoff_flow_num
        or o.wrtoff_dt <> n.wrtoff_dt
        or o.sell_status_cd <> n.sell_status_cd
        or o.attach_rgst_check_teller_id <> n.attach_rgst_check_teller_id
        or o.refac_batch_pkg_id <> n.refac_batch_pkg_id
        or o.refac_batch_exp_dt <> n.refac_batch_exp_dt
        or o.refac_status_cd <> n.refac_status_cd
        or o.refac_invalid_tm <> n.refac_invalid_tm
        or o.edu_hea_flg <> n.edu_hea_flg
        or o.asset_id <> n.asset_id
        or o.acct_b_cate_cd <> n.acct_b_cate_cd
        or o.matn_flg <> n.matn_flg
        or o.bus_org_id <> n.bus_org_id
        or o.tran_org_id <> n.tran_org_id
        or o.batch_data_src_cd <> n.batch_data_src_cd
        or o.dep_agt_id <> n.dep_agt_id
        or o.benefc_cust_id <> n.benefc_cust_id
        or o.deduct_dt <> n.deduct_dt
        or o.int_adj <> n.int_adj
        or o.col_int_type_cd <> n.col_int_type_cd
        or o.acru_int <> n.acru_int
        or o.ibank_no <> n.ibank_no
        or o.rels_lmt_flg <> n.rels_lmt_flg
        or o.accept_recv_flg <> n.accept_recv_flg
        or o.suit_fee <> n.suit_fee
        or o.ibank_syn_bus_sys_tran_dt <> n.ibank_syn_bus_sys_tran_dt
        or o.syn_loan_seq_num <> n.syn_loan_seq_num
        or o.oc_curr_cd <> n.oc_curr_cd
        or o.oc_amt <> n.oc_amt
        or o.init_asset_uniq_idf <> n.init_asset_uniq_idf
        or o.final_modif_dt <> n.final_modif_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,dubil_id -- 借据编号
    ,fee_rat -- 费率
    ,ped -- 周期
    ,int_accr_way_cd -- 计息方式代码
    ,pre_recv_int_flg -- 预收息标志
    ,loan_type_cd -- 贷款类型代码
    ,surp_perds -- 剩余期数
    ,eh_issue_deduct_amt -- 每期扣款金额
    ,acm_rtn_pric -- 累计归还本金
    ,acm_rtn_int -- 累计归还利息
    ,int_expns_fee_id -- 利息支出费用编号
    ,comm_fee_expns_fee_id -- 手续费支出费用编号
    ,next_term_rpp_dt -- 下一期还本日期
    ,next_term_rpp_amt -- 下一期还本金额
    ,next_term_repay_int_dt -- 下一期还息日期
    ,next_term_repay_int_amt -- 下一期还息金额
    ,advc_amt -- 垫款金额
    ,attach_rgst_dubil_flg -- 补登借据标志
    ,bill_uniq_ind_no -- 票据唯一标识号
    ,bill_id -- 票据编号
    ,bill_type_cd -- 票据类型代码
    ,bill_kind_cd -- 票据种类代码
    ,acpt_bank_no -- 承兑行行号
    ,acpt_bank_name -- 承兑行名称
    ,transf_type_cd -- 转让类型代码
    ,discount_int_rat -- 转贴现利率
    ,dir_paste_bank_no -- 直贴行行号
    ,dir_paste_bank_name -- 直贴行名称
    ,benefc_open_bank_no -- 受益人开户行行号
    ,benefc_open_bank_name -- 受益人开户行名称
    ,benefc_name -- 受益人名称
    ,bnft_bank_name -- 受益行名称
    ,open_flow_num -- 开立流水号
    ,open_dt -- 开立日期
    ,wrtoff_type_cd -- 注销类型代码
    ,wrtoff_flow_num -- 注销流水号
    ,wrtoff_dt -- 注销日期
    ,sell_status_cd -- 卖出状态代码
    ,attach_rgst_check_teller_id -- 补登复核柜员编号
    ,refac_batch_pkg_id -- 支小再批次包编号
    ,refac_batch_exp_dt -- 支小再批次到期日期
    ,refac_status_cd -- 支小再状态代码
    ,refac_invalid_tm -- 支小再失效时间
    ,edu_hea_flg -- 文教健康标志
    ,asset_id -- 资产编号
    ,acct_b_cate_cd -- 账簿类别代码
    ,matn_flg -- 维护标志
    ,bus_org_id -- 业务机构编号
    ,tran_org_id -- 交易机构编号
    ,batch_data_src_cd -- 批量数据来源代码
    ,dep_agt_id -- 存款协议编号
    ,benefc_cust_id -- 受益人客户编号
    ,deduct_dt -- 扣款日期
    ,int_adj -- 利息调整
    ,col_int_type_cd -- 收息类型代码
    ,acru_int -- 应计利息
    ,ibank_no -- 联行号
    ,rels_lmt_flg -- 释放额度标志
    ,accept_recv_flg -- 收票签收标志
    ,suit_fee -- 诉讼费
    ,ibank_syn_bus_sys_tran_dt -- 同业综合业务系统交易日期
    ,syn_loan_seq_num -- 银团贷款序号
    ,oc_curr_cd -- 原币币种代码
    ,oc_amt -- 原币金额
    ,init_asset_uniq_idf -- 原资产唯一标识
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,dubil_id -- 借据编号
    ,fee_rat -- 费率
    ,ped -- 周期
    ,int_accr_way_cd -- 计息方式代码
    ,pre_recv_int_flg -- 预收息标志
    ,loan_type_cd -- 贷款类型代码
    ,surp_perds -- 剩余期数
    ,eh_issue_deduct_amt -- 每期扣款金额
    ,acm_rtn_pric -- 累计归还本金
    ,acm_rtn_int -- 累计归还利息
    ,int_expns_fee_id -- 利息支出费用编号
    ,comm_fee_expns_fee_id -- 手续费支出费用编号
    ,next_term_rpp_dt -- 下一期还本日期
    ,next_term_rpp_amt -- 下一期还本金额
    ,next_term_repay_int_dt -- 下一期还息日期
    ,next_term_repay_int_amt -- 下一期还息金额
    ,advc_amt -- 垫款金额
    ,attach_rgst_dubil_flg -- 补登借据标志
    ,bill_uniq_ind_no -- 票据唯一标识号
    ,bill_id -- 票据编号
    ,bill_type_cd -- 票据类型代码
    ,bill_kind_cd -- 票据种类代码
    ,acpt_bank_no -- 承兑行行号
    ,acpt_bank_name -- 承兑行名称
    ,transf_type_cd -- 转让类型代码
    ,discount_int_rat -- 转贴现利率
    ,dir_paste_bank_no -- 直贴行行号
    ,dir_paste_bank_name -- 直贴行名称
    ,benefc_open_bank_no -- 受益人开户行行号
    ,benefc_open_bank_name -- 受益人开户行名称
    ,benefc_name -- 受益人名称
    ,bnft_bank_name -- 受益行名称
    ,open_flow_num -- 开立流水号
    ,open_dt -- 开立日期
    ,wrtoff_type_cd -- 注销类型代码
    ,wrtoff_flow_num -- 注销流水号
    ,wrtoff_dt -- 注销日期
    ,sell_status_cd -- 卖出状态代码
    ,attach_rgst_check_teller_id -- 补登复核柜员编号
    ,refac_batch_pkg_id -- 支小再批次包编号
    ,refac_batch_exp_dt -- 支小再批次到期日期
    ,refac_status_cd -- 支小再状态代码
    ,refac_invalid_tm -- 支小再失效时间
    ,edu_hea_flg -- 文教健康标志
    ,asset_id -- 资产编号
    ,acct_b_cate_cd -- 账簿类别代码
    ,matn_flg -- 维护标志
    ,bus_org_id -- 业务机构编号
    ,tran_org_id -- 交易机构编号
    ,batch_data_src_cd -- 批量数据来源代码
    ,dep_agt_id -- 存款协议编号
    ,benefc_cust_id -- 受益人客户编号
    ,deduct_dt -- 扣款日期
    ,int_adj -- 利息调整
    ,col_int_type_cd -- 收息类型代码
    ,acru_int -- 应计利息
    ,ibank_no -- 联行号
    ,rels_lmt_flg -- 释放额度标志
    ,accept_recv_flg -- 收票签收标志
    ,suit_fee -- 诉讼费
    ,ibank_syn_bus_sys_tran_dt -- 同业综合业务系统交易日期
    ,syn_loan_seq_num -- 银团贷款序号
    ,oc_curr_cd -- 原币币种代码
    ,oc_amt -- 原币金额
    ,init_asset_uniq_idf -- 原资产唯一标识
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.dubil_id -- 借据编号
    ,o.fee_rat -- 费率
    ,o.ped -- 周期
    ,o.int_accr_way_cd -- 计息方式代码
    ,o.pre_recv_int_flg -- 预收息标志
    ,o.loan_type_cd -- 贷款类型代码
    ,o.surp_perds -- 剩余期数
    ,o.eh_issue_deduct_amt -- 每期扣款金额
    ,o.acm_rtn_pric -- 累计归还本金
    ,o.acm_rtn_int -- 累计归还利息
    ,o.int_expns_fee_id -- 利息支出费用编号
    ,o.comm_fee_expns_fee_id -- 手续费支出费用编号
    ,o.next_term_rpp_dt -- 下一期还本日期
    ,o.next_term_rpp_amt -- 下一期还本金额
    ,o.next_term_repay_int_dt -- 下一期还息日期
    ,o.next_term_repay_int_amt -- 下一期还息金额
    ,o.advc_amt -- 垫款金额
    ,o.attach_rgst_dubil_flg -- 补登借据标志
    ,o.bill_uniq_ind_no -- 票据唯一标识号
    ,o.bill_id -- 票据编号
    ,o.bill_type_cd -- 票据类型代码
    ,o.bill_kind_cd -- 票据种类代码
    ,o.acpt_bank_no -- 承兑行行号
    ,o.acpt_bank_name -- 承兑行名称
    ,o.transf_type_cd -- 转让类型代码
    ,o.discount_int_rat -- 转贴现利率
    ,o.dir_paste_bank_no -- 直贴行行号
    ,o.dir_paste_bank_name -- 直贴行名称
    ,o.benefc_open_bank_no -- 受益人开户行行号
    ,o.benefc_open_bank_name -- 受益人开户行名称
    ,o.benefc_name -- 受益人名称
    ,o.bnft_bank_name -- 受益行名称
    ,o.open_flow_num -- 开立流水号
    ,o.open_dt -- 开立日期
    ,o.wrtoff_type_cd -- 注销类型代码
    ,o.wrtoff_flow_num -- 注销流水号
    ,o.wrtoff_dt -- 注销日期
    ,o.sell_status_cd -- 卖出状态代码
    ,o.attach_rgst_check_teller_id -- 补登复核柜员编号
    ,o.refac_batch_pkg_id -- 支小再批次包编号
    ,o.refac_batch_exp_dt -- 支小再批次到期日期
    ,o.refac_status_cd -- 支小再状态代码
    ,o.refac_invalid_tm -- 支小再失效时间
    ,o.edu_hea_flg -- 文教健康标志
    ,o.asset_id -- 资产编号
    ,o.acct_b_cate_cd -- 账簿类别代码
    ,o.matn_flg -- 维护标志
    ,o.bus_org_id -- 业务机构编号
    ,o.tran_org_id -- 交易机构编号
    ,o.batch_data_src_cd -- 批量数据来源代码
    ,o.dep_agt_id -- 存款协议编号
    ,o.benefc_cust_id -- 受益人客户编号
    ,o.deduct_dt -- 扣款日期
    ,o.int_adj -- 利息调整
    ,o.col_int_type_cd -- 收息类型代码
    ,o.acru_int -- 应计利息
    ,o.ibank_no -- 联行号
    ,o.rels_lmt_flg -- 释放额度标志
    ,o.accept_recv_flg -- 收票签收标志
    ,o.suit_fee -- 诉讼费
    ,o.ibank_syn_bus_sys_tran_dt -- 同业综合业务系统交易日期
    ,o.syn_loan_seq_num -- 银团贷款序号
    ,o.oc_curr_cd -- 原币币种代码
    ,o.oc_amt -- 原币金额
    ,o.init_asset_uniq_idf -- 原资产唯一标识
    ,o.final_modif_dt -- 最后修改日期
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
from ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.dubil_id = n.dubil_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.dubil_id = d.dubil_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h;
--alter table ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_dubil_non_retl_attach_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_dubil_non_retl_attach_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
