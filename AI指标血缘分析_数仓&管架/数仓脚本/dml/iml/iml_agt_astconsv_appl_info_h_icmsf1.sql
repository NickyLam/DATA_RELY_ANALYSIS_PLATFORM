/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_astconsv_appl_info_h_icmsf1
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
alter table ${iml_schema}.agt_astconsv_appl_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_astconsv_appl_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_astconsv_appl_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_astconsv_appl_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_astconsv_appl_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_astconsv_appl_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_astconsv_appl_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,ths_tm_asset_cls_cd -- 本次资产分类代码
    ,appl_rs_descb -- 申请原因描述
    ,derate_bf_pric_sum -- 减免前本金合计
    ,derate_bf_adv_fee_sum -- 减免前代垫费用合计
    ,derate_bf_comp_int_sum -- 减免前复利合计
    ,derate_bf_pnlt_sum -- 减免前罚息合计
    ,derate_bf_int_sum -- 减免前利息合计
    ,apv_status_cd -- 审批状态代码
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,dubil_qtty -- 借据数量
    ,brwer_resv_recs_flg -- 对借款人保留追索权标志
    ,guartor_resv_recs_flg -- 对保证人保留追索权标志
    ,exist_propty_flg -- 存在财产线索标志
    ,asset_descb -- 资产线索描述
    ,obj_type_cd -- 对象类型代码
    ,tran_type_cd -- 交易类型代码
    ,ths_tm_tran_pric_sum -- 本次交易本金合计
    ,ths_tm_tran_int_sum -- 本次交易利息合计
    ,ths_tm_comp_int_sum -- 本次复利合计
    ,ths_tm_pnlt_sum -- 本次罚息合计
    ,ths_tm_tran_adv_fee_sum -- 本次交易代垫费用合计
    ,oper_dt -- 经办日期
    ,oper_belong_org_id -- 经办所属机构编号
    ,oper_teller_id -- 经办柜员编号
    ,rela_flow_num -- 关联流水号
    ,ths_return_post_acct_recl_amt -- 本次回款后应收款金额
    ,ths_return_bf_acct_recv_amt -- 本次回款前应收款金额
    ,ths_tm_return_amt -- 本次回款金额
    ,last_acm_return_amt -- 上一累计回款金额
    ,acm_return_amt -- 累计回款金额
    ,fst_return_amt -- 首期回款金额
    ,rtn_suit_fee_cosdetn -- 用于归还诉讼费的对价
    ,wrt_off_type_cd -- 核销类型代码
    ,acct_recvbl_acct_id -- 应收款账户编号
    ,acct_recvbl_acct_name -- 应收款账户名称
    ,acct_recvbl_amt -- 应收款金额
    ,tran_plat_cd -- 交易平台代码
    ,tran_cont_id -- 转让合同编号
    ,tran_way_cd -- 转让方式代码
    ,tran_price -- 转让价格
    ,real_tran_cosdetn -- 真实转让对价
    ,tran_return_acct_id -- 转让回款账户编号
    ,tran_return_acct_name -- 转让回款账户名称
    ,inside_acct_open_org_id -- 内部户开立机构编号
    ,debt_asset_id -- 抵债资产编号
    ,debt_asset_name -- 抵债资产名称
    ,debt_amt -- 抵债金额
    ,recv_dt -- 接收日期
    ,debt_asset_type_cd -- 抵债资产类型代码
    ,debt_type_cd -- 抵债类型代码
    ,disp_way_cd -- 处置方式代码
    ,disp_amt -- 处置金额
    ,disp_comnt -- 处置说明
    ,create_mon -- 生成月份
    ,crdt_bal -- 授信余额
    ,loss_amt -- 损失金额
    ,cust_type_cd -- 客户类型代码
    ,guar_way_cd -- 担保方式代码
    ,guartor -- 保证人
    ,mtg_descb -- 抵押物描述
    ,suit_prog -- 诉讼进展
    ,liqd_disp_prop -- 清收处置方案
    ,latest_disp_prog -- 最新处置进展
    ,next_work_plan -- 下一步工作计划
    ,exist_prob -- 存在问题描述
    ,deduct_stl_acct_id -- 扣款结算账户编号
    ,deduct_stl_acct_bal -- 扣款结算账户余额
    ,deduct_amt -- 扣划金额
    ,deduct_reason -- 扣划理由
    ,on_acct_id -- 挂账编号
    ,trane_cert_type_cd -- 受让方证件类型代码
    ,trane_cert_no -- 受让方证件号码
    ,trane_acct_id -- 受让方账户编号
    ,trane_bank_no -- 受让方行号
    ,trane_tran_acct_dt -- 受让方转账日期
    ,prop_id -- 方案编号
    ,sign_dt -- 签约日期
    ,effect_dt -- 生效日期
    ,agt_curr_cd -- 协议币种代码
    ,agt_amt -- 协议金额
    ,margin_amt -- 保证金金额
    ,margin_ratio -- 保证金比例
    ,margin_curr_cd -- 保证金币种代码
    ,court_judge_id -- 法院裁定书编号
    ,inst_pay_flg -- 分期付款标志
    ,int_full_amt_derate_flg -- 利息全额减免标志
    ,rgst_dt -- 登记日期
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,remark -- 备注
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_astconsv_appl_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_astconsv_appl_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_astconsv_appl_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_astconsv_appl_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_astconsv_appl_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_asset_preservation_apply-1
insert into ${iml_schema}.agt_astconsv_appl_info_h_icmsf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,ths_tm_asset_cls_cd -- 本次资产分类代码
    ,appl_rs_descb -- 申请原因描述
    ,derate_bf_pric_sum -- 减免前本金合计
    ,derate_bf_adv_fee_sum -- 减免前代垫费用合计
    ,derate_bf_comp_int_sum -- 减免前复利合计
    ,derate_bf_pnlt_sum -- 减免前罚息合计
    ,derate_bf_int_sum -- 减免前利息合计
    ,apv_status_cd -- 审批状态代码
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,dubil_qtty -- 借据数量
    ,brwer_resv_recs_flg -- 对借款人保留追索权标志
    ,guartor_resv_recs_flg -- 对保证人保留追索权标志
    ,exist_propty_flg -- 存在财产线索标志
    ,asset_descb -- 资产线索描述
    ,obj_type_cd -- 对象类型代码
    ,tran_type_cd -- 交易类型代码
    ,ths_tm_tran_pric_sum -- 本次交易本金合计
    ,ths_tm_tran_int_sum -- 本次交易利息合计
    ,ths_tm_comp_int_sum -- 本次复利合计
    ,ths_tm_pnlt_sum -- 本次罚息合计
    ,ths_tm_tran_adv_fee_sum -- 本次交易代垫费用合计
    ,oper_dt -- 经办日期
    ,oper_belong_org_id -- 经办所属机构编号
    ,oper_teller_id -- 经办柜员编号
    ,rela_flow_num -- 关联流水号
    ,ths_return_post_acct_recl_amt -- 本次回款后应收款金额
    ,ths_return_bf_acct_recv_amt -- 本次回款前应收款金额
    ,ths_tm_return_amt -- 本次回款金额
    ,last_acm_return_amt -- 上一累计回款金额
    ,acm_return_amt -- 累计回款金额
    ,fst_return_amt -- 首期回款金额
    ,rtn_suit_fee_cosdetn -- 用于归还诉讼费的对价
    ,wrt_off_type_cd -- 核销类型代码
    ,acct_recvbl_acct_id -- 应收款账户编号
    ,acct_recvbl_acct_name -- 应收款账户名称
    ,acct_recvbl_amt -- 应收款金额
    ,tran_plat_cd -- 交易平台代码
    ,tran_cont_id -- 转让合同编号
    ,tran_way_cd -- 转让方式代码
    ,tran_price -- 转让价格
    ,real_tran_cosdetn -- 真实转让对价
    ,tran_return_acct_id -- 转让回款账户编号
    ,tran_return_acct_name -- 转让回款账户名称
    ,inside_acct_open_org_id -- 内部户开立机构编号
    ,debt_asset_id -- 抵债资产编号
    ,debt_asset_name -- 抵债资产名称
    ,debt_amt -- 抵债金额
    ,recv_dt -- 接收日期
    ,debt_asset_type_cd -- 抵债资产类型代码
    ,debt_type_cd -- 抵债类型代码
    ,disp_way_cd -- 处置方式代码
    ,disp_amt -- 处置金额
    ,disp_comnt -- 处置说明
    ,create_mon -- 生成月份
    ,crdt_bal -- 授信余额
    ,loss_amt -- 损失金额
    ,cust_type_cd -- 客户类型代码
    ,guar_way_cd -- 担保方式代码
    ,guartor -- 保证人
    ,mtg_descb -- 抵押物描述
    ,suit_prog -- 诉讼进展
    ,liqd_disp_prop -- 清收处置方案
    ,latest_disp_prog -- 最新处置进展
    ,next_work_plan -- 下一步工作计划
    ,exist_prob -- 存在问题描述
    ,deduct_stl_acct_id -- 扣款结算账户编号
    ,deduct_stl_acct_bal -- 扣款结算账户余额
    ,deduct_amt -- 扣划金额
    ,deduct_reason -- 扣划理由
    ,on_acct_id -- 挂账编号
    ,trane_cert_type_cd -- 受让方证件类型代码
    ,trane_cert_no -- 受让方证件号码
    ,trane_acct_id -- 受让方账户编号
    ,trane_bank_no -- 受让方行号
    ,trane_tran_acct_dt -- 受让方转账日期
    ,prop_id -- 方案编号
    ,sign_dt -- 签约日期
    ,effect_dt -- 生效日期
    ,agt_curr_cd -- 协议币种代码
    ,agt_amt -- 协议金额
    ,margin_amt -- 保证金金额
    ,margin_ratio -- 保证金比例
    ,margin_curr_cd -- 保证金币种代码
    ,court_judge_id -- 法院裁定书编号
    ,inst_pay_flg -- 分期付款标志
    ,int_full_amt_derate_flg -- 利息全额减免标志
    ,rgst_dt -- 登记日期
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206008'||P1.SERIALNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 申请流水号
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CUSTOMERNAME -- 客户名称
    ,decode(P1.CLASSIFY,'01','A','02','B','03','C',' ','-',P1.CLASSIFY) -- 本次资产分类代码
    ,P1.CONDITION -- 申请原因描述
    ,P1.AFTERLOBJ -- 减免前本金合计
    ,P1.AFTERLODDFY -- 减免前代垫费用合计
    ,P1.AFTERLOFL -- 减免前复利合计
    ,P1.AFTERLOFX -- 减免前罚息合计
    ,P1.AFTERLOLX -- 减免前利息合计
    ,nvl(trim(P1.APPROVESTATUS),'-') -- 审批状态代码
    ,P1.COUNTERPARTY -- 交易对手编号
    ,P1.COUNTERPARTYNAME -- 交易对手名称
    ,to_number(nvl(trim(P1.DUEBILLNUM),0)) -- 借据数量
    ,nvl(trim(P1.ISBORROWERRECOURSE),'-') -- 对借款人保留追索权标志
    ,nvl(trim(P1.ISGURANTYRECOURSE),'-') -- 对保证人保留追索权标志
    ,nvl(trim(P1.ISPROPERTYCLUE),'-') -- 存在财产线索标志
    ,P1.PROPERTYCLUE -- 资产线索描述
    ,nvl(trim(P1.OBJECTTYPE),'-') -- 对象类型代码
    ,nvl(trim(P1.OCCURTYPE),'-')  -- 交易类型代码
    ,P1.PRIAMTSUM -- 本次交易本金合计
    ,P1.INTAMTSUM -- 本次交易利息合计
    ,P1.ODIAMTSUM -- 本次复利合计
    ,P1.ODPAMTSUM -- 本次罚息合计
    ,P1.DDFYAMTSUM -- 本次交易代垫费用合计
    ,P1.OPERATEDATE -- 经办日期
    ,P1.OPERATEORGID -- 经办所属机构编号
    ,P1.OPERATEUSERID -- 经办柜员编号
    ,P1.RELATIVESERIALNO -- 关联流水号
    ,P1.RETURNEDAFTERMONEY -- 本次回款后应收款金额
    ,P1.RETURNEDBEFOREMONEY -- 本次回款前应收款金额
    ,P1.RETURNEDMONEY -- 本次回款金额
    ,P1.LASTRETURNEDMONEYSUM -- 上一累计回款金额
    ,P1.RETURNEDMONEYSUM -- 累计回款金额
    ,P1.SQAMOUNT -- 首期回款金额
    ,P1.USETOSSFDJ -- 用于归还诉讼费的对价
    ,nvl(trim(P1.WRITEOFFTYPE),'-') -- 核销类型代码
    ,P1.YSACCOUNT -- 应收款账户编号
    ,P1.YSACCOUNTNAME -- 应收款账户名称
    ,P1.YSAMOUNT -- 应收款金额
    ,nvl(trim(P1.TRADINGPLATFORM),'09') -- 交易平台代码
    ,P1.TRANSFERCONTRACTNO -- 转让合同编号
    ,nvl(trim(P1.TRANSFERTYPE),'-') -- 转让方式代码
    ,P1.TRANSFERPRICE -- 转让价格
    ,P1.TRANSFERACTUALPRICE -- 真实转让对价
    ,P1.TRANSFERACCOUNT -- 转让回款账户编号
    ,P1.TRANSFERACCOUNTNAME -- 转让回款账户名称
    ,nvl(trim(P1.ESTABLISHMENT),'-')  -- 内部户开立机构编号
    ,P1.DEBTREPAYASSETID -- 抵债资产编号
    ,P1.DEBTREPAYASSETNAME -- 抵债资产名称
    ,P1.DEBTREPAYSUM -- 抵债金额
    ,P1.RECEIVEDATE -- 接收日期
    ,nvl(trim(P1.DEBTREPAYASSETTYPE),'-') -- 抵债资产类型代码
    ,nvl(trim(P1.DEBTREPAYMENTTYPE),'-') -- 抵债类型代码
    ,nvl(trim(P1.HANDLETYPE),'-') -- 处置方式代码
    ,P1.HANDLEBALANCE -- 处置金额
    ,P1.HANDLEDESC -- 处置说明
    ,P1.DISPOSALDATE -- 生成月份
    ,P1.CREDITBALANCE -- 授信余额
    ,P1.LOSSAMOUNT -- 损失金额
    ,nvl(trim(P1.CUSTOMERTYPE),'-') -- 客户类型代码
    ,nvl(trim(P1.GURANTYTYPE),'-') -- 担保方式代码
    ,P1.GURANTORINFO -- 保证人
    ,P1.GURANTYINFO -- 抵押物描述
    ,P1.SSPROGRESS -- 诉讼进展
    ,P1.DISPOSALPLAN -- 清收处置方案
    ,P1.DISPOSALPROGRESS -- 最新处置进展
    ,P1.NEXTPLAN -- 下一步工作计划
    ,P1.EXISTDIFFICULTY -- 存在问题描述
    ,P1.DEDUCTSETTLEACCOUNT -- 扣款结算账户编号
    ,P1.DEDUCTSETTLEACCOUNTBALANCE -- 扣款结算账户余额
    ,P1.DEDUCTAMOUNT -- 扣划金额
    ,P1.DEDUCTREASON -- 扣划理由
    ,P1.ACCOUNTNO -- 挂账编号
    ,nvl(trim(P1.COUNTERPARTYCERTTYPE),'0000') -- 受让方证件类型代码
    ,P1.COUNTERPARTYCERTID -- 受让方证件号码
    ,P1.COUNTERPARTYZH -- 受让方账户编号
    ,P1.COUNTERPARTYZHBANK -- 受让方行号
    ,P1.COUNTERPARTYZZDATE -- 受让方转账日期
    ,P1.PROGRAMNO -- 方案编号
    ,P1.QYDATE -- 签约日期
    ,P1.SXDATE -- 生效日期
    ,nvl(trim(P1.CURRENCY),'-') -- 协议币种代码
    ,P1.XYAMT -- 协议金额
    ,P1.BZJAMT -- 保证金金额
    ,P1.BZJRATE -- 保证金比例
    ,nvl(trim(P1.BZJCURRENCY),'-') -- 保证金币种代码
    ,P1.FYCDSID -- 法院裁定书编号
    ,nvl(trim(P1.ISINSTALLMENT),'-') -- 分期付款标志
    ,nvl(trim(P1.ISCOMPINTERESTFORGIVENESS),'-') -- 利息全额减免标志
    ,P1.INPUTDATE -- 登记日期
    ,P1.INPUTORGID -- 登记所属机构编号
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.UPDATEORGID -- 更新柜员编号
    ,P1.UPDATEUSERID -- 更新机构编号
    ,P1.REMARK -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_asset_preservation_apply' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_asset_preservation_apply p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.OCCURTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_ASSET_PRESERVATION_APPLY'
        AND R1.SRC_FIELD_EN_NAME= 'OCCURTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_ASTCONSV_APPL_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.TRANSFERTYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_ASSET_PRESERVATION_APPLY'
        AND R2.SRC_FIELD_EN_NAME= 'TRANSFERTYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_ASTCONSV_APPL_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'TRAN_WAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_astconsv_appl_info_h_icmsf1_tm 
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
        into ${iml_schema}.agt_astconsv_appl_info_h_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,ths_tm_asset_cls_cd -- 本次资产分类代码
    ,appl_rs_descb -- 申请原因描述
    ,derate_bf_pric_sum -- 减免前本金合计
    ,derate_bf_adv_fee_sum -- 减免前代垫费用合计
    ,derate_bf_comp_int_sum -- 减免前复利合计
    ,derate_bf_pnlt_sum -- 减免前罚息合计
    ,derate_bf_int_sum -- 减免前利息合计
    ,apv_status_cd -- 审批状态代码
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,dubil_qtty -- 借据数量
    ,brwer_resv_recs_flg -- 对借款人保留追索权标志
    ,guartor_resv_recs_flg -- 对保证人保留追索权标志
    ,exist_propty_flg -- 存在财产线索标志
    ,asset_descb -- 资产线索描述
    ,obj_type_cd -- 对象类型代码
    ,tran_type_cd -- 交易类型代码
    ,ths_tm_tran_pric_sum -- 本次交易本金合计
    ,ths_tm_tran_int_sum -- 本次交易利息合计
    ,ths_tm_comp_int_sum -- 本次复利合计
    ,ths_tm_pnlt_sum -- 本次罚息合计
    ,ths_tm_tran_adv_fee_sum -- 本次交易代垫费用合计
    ,oper_dt -- 经办日期
    ,oper_belong_org_id -- 经办所属机构编号
    ,oper_teller_id -- 经办柜员编号
    ,rela_flow_num -- 关联流水号
    ,ths_return_post_acct_recl_amt -- 本次回款后应收款金额
    ,ths_return_bf_acct_recv_amt -- 本次回款前应收款金额
    ,ths_tm_return_amt -- 本次回款金额
    ,last_acm_return_amt -- 上一累计回款金额
    ,acm_return_amt -- 累计回款金额
    ,fst_return_amt -- 首期回款金额
    ,rtn_suit_fee_cosdetn -- 用于归还诉讼费的对价
    ,wrt_off_type_cd -- 核销类型代码
    ,acct_recvbl_acct_id -- 应收款账户编号
    ,acct_recvbl_acct_name -- 应收款账户名称
    ,acct_recvbl_amt -- 应收款金额
    ,tran_plat_cd -- 交易平台代码
    ,tran_cont_id -- 转让合同编号
    ,tran_way_cd -- 转让方式代码
    ,tran_price -- 转让价格
    ,real_tran_cosdetn -- 真实转让对价
    ,tran_return_acct_id -- 转让回款账户编号
    ,tran_return_acct_name -- 转让回款账户名称
    ,inside_acct_open_org_id -- 内部户开立机构编号
    ,debt_asset_id -- 抵债资产编号
    ,debt_asset_name -- 抵债资产名称
    ,debt_amt -- 抵债金额
    ,recv_dt -- 接收日期
    ,debt_asset_type_cd -- 抵债资产类型代码
    ,debt_type_cd -- 抵债类型代码
    ,disp_way_cd -- 处置方式代码
    ,disp_amt -- 处置金额
    ,disp_comnt -- 处置说明
    ,create_mon -- 生成月份
    ,crdt_bal -- 授信余额
    ,loss_amt -- 损失金额
    ,cust_type_cd -- 客户类型代码
    ,guar_way_cd -- 担保方式代码
    ,guartor -- 保证人
    ,mtg_descb -- 抵押物描述
    ,suit_prog -- 诉讼进展
    ,liqd_disp_prop -- 清收处置方案
    ,latest_disp_prog -- 最新处置进展
    ,next_work_plan -- 下一步工作计划
    ,exist_prob -- 存在问题描述
    ,deduct_stl_acct_id -- 扣款结算账户编号
    ,deduct_stl_acct_bal -- 扣款结算账户余额
    ,deduct_amt -- 扣划金额
    ,deduct_reason -- 扣划理由
    ,on_acct_id -- 挂账编号
    ,trane_cert_type_cd -- 受让方证件类型代码
    ,trane_cert_no -- 受让方证件号码
    ,trane_acct_id -- 受让方账户编号
    ,trane_bank_no -- 受让方行号
    ,trane_tran_acct_dt -- 受让方转账日期
    ,prop_id -- 方案编号
    ,sign_dt -- 签约日期
    ,effect_dt -- 生效日期
    ,agt_curr_cd -- 协议币种代码
    ,agt_amt -- 协议金额
    ,margin_amt -- 保证金金额
    ,margin_ratio -- 保证金比例
    ,margin_curr_cd -- 保证金币种代码
    ,court_judge_id -- 法院裁定书编号
    ,inst_pay_flg -- 分期付款标志
    ,int_full_amt_derate_flg -- 利息全额减免标志
    ,rgst_dt -- 登记日期
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_astconsv_appl_info_h_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,ths_tm_asset_cls_cd -- 本次资产分类代码
    ,appl_rs_descb -- 申请原因描述
    ,derate_bf_pric_sum -- 减免前本金合计
    ,derate_bf_adv_fee_sum -- 减免前代垫费用合计
    ,derate_bf_comp_int_sum -- 减免前复利合计
    ,derate_bf_pnlt_sum -- 减免前罚息合计
    ,derate_bf_int_sum -- 减免前利息合计
    ,apv_status_cd -- 审批状态代码
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,dubil_qtty -- 借据数量
    ,brwer_resv_recs_flg -- 对借款人保留追索权标志
    ,guartor_resv_recs_flg -- 对保证人保留追索权标志
    ,exist_propty_flg -- 存在财产线索标志
    ,asset_descb -- 资产线索描述
    ,obj_type_cd -- 对象类型代码
    ,tran_type_cd -- 交易类型代码
    ,ths_tm_tran_pric_sum -- 本次交易本金合计
    ,ths_tm_tran_int_sum -- 本次交易利息合计
    ,ths_tm_comp_int_sum -- 本次复利合计
    ,ths_tm_pnlt_sum -- 本次罚息合计
    ,ths_tm_tran_adv_fee_sum -- 本次交易代垫费用合计
    ,oper_dt -- 经办日期
    ,oper_belong_org_id -- 经办所属机构编号
    ,oper_teller_id -- 经办柜员编号
    ,rela_flow_num -- 关联流水号
    ,ths_return_post_acct_recl_amt -- 本次回款后应收款金额
    ,ths_return_bf_acct_recv_amt -- 本次回款前应收款金额
    ,ths_tm_return_amt -- 本次回款金额
    ,last_acm_return_amt -- 上一累计回款金额
    ,acm_return_amt -- 累计回款金额
    ,fst_return_amt -- 首期回款金额
    ,rtn_suit_fee_cosdetn -- 用于归还诉讼费的对价
    ,wrt_off_type_cd -- 核销类型代码
    ,acct_recvbl_acct_id -- 应收款账户编号
    ,acct_recvbl_acct_name -- 应收款账户名称
    ,acct_recvbl_amt -- 应收款金额
    ,tran_plat_cd -- 交易平台代码
    ,tran_cont_id -- 转让合同编号
    ,tran_way_cd -- 转让方式代码
    ,tran_price -- 转让价格
    ,real_tran_cosdetn -- 真实转让对价
    ,tran_return_acct_id -- 转让回款账户编号
    ,tran_return_acct_name -- 转让回款账户名称
    ,inside_acct_open_org_id -- 内部户开立机构编号
    ,debt_asset_id -- 抵债资产编号
    ,debt_asset_name -- 抵债资产名称
    ,debt_amt -- 抵债金额
    ,recv_dt -- 接收日期
    ,debt_asset_type_cd -- 抵债资产类型代码
    ,debt_type_cd -- 抵债类型代码
    ,disp_way_cd -- 处置方式代码
    ,disp_amt -- 处置金额
    ,disp_comnt -- 处置说明
    ,create_mon -- 生成月份
    ,crdt_bal -- 授信余额
    ,loss_amt -- 损失金额
    ,cust_type_cd -- 客户类型代码
    ,guar_way_cd -- 担保方式代码
    ,guartor -- 保证人
    ,mtg_descb -- 抵押物描述
    ,suit_prog -- 诉讼进展
    ,liqd_disp_prop -- 清收处置方案
    ,latest_disp_prog -- 最新处置进展
    ,next_work_plan -- 下一步工作计划
    ,exist_prob -- 存在问题描述
    ,deduct_stl_acct_id -- 扣款结算账户编号
    ,deduct_stl_acct_bal -- 扣款结算账户余额
    ,deduct_amt -- 扣划金额
    ,deduct_reason -- 扣划理由
    ,on_acct_id -- 挂账编号
    ,trane_cert_type_cd -- 受让方证件类型代码
    ,trane_cert_no -- 受让方证件号码
    ,trane_acct_id -- 受让方账户编号
    ,trane_bank_no -- 受让方行号
    ,trane_tran_acct_dt -- 受让方转账日期
    ,prop_id -- 方案编号
    ,sign_dt -- 签约日期
    ,effect_dt -- 生效日期
    ,agt_curr_cd -- 协议币种代码
    ,agt_amt -- 协议金额
    ,margin_amt -- 保证金金额
    ,margin_ratio -- 保证金比例
    ,margin_curr_cd -- 保证金币种代码
    ,court_judge_id -- 法院裁定书编号
    ,inst_pay_flg -- 分期付款标志
    ,int_full_amt_derate_flg -- 利息全额减免标志
    ,rgst_dt -- 登记日期
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
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
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.ths_tm_asset_cls_cd, o.ths_tm_asset_cls_cd) as ths_tm_asset_cls_cd -- 本次资产分类代码
    ,nvl(n.appl_rs_descb, o.appl_rs_descb) as appl_rs_descb -- 申请原因描述
    ,nvl(n.derate_bf_pric_sum, o.derate_bf_pric_sum) as derate_bf_pric_sum -- 减免前本金合计
    ,nvl(n.derate_bf_adv_fee_sum, o.derate_bf_adv_fee_sum) as derate_bf_adv_fee_sum -- 减免前代垫费用合计
    ,nvl(n.derate_bf_comp_int_sum, o.derate_bf_comp_int_sum) as derate_bf_comp_int_sum -- 减免前复利合计
    ,nvl(n.derate_bf_pnlt_sum, o.derate_bf_pnlt_sum) as derate_bf_pnlt_sum -- 减免前罚息合计
    ,nvl(n.derate_bf_int_sum, o.derate_bf_int_sum) as derate_bf_int_sum -- 减免前利息合计
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.cntpty_id, o.cntpty_id) as cntpty_id -- 交易对手编号
    ,nvl(n.cntpty_name, o.cntpty_name) as cntpty_name -- 交易对手名称
    ,nvl(n.dubil_qtty, o.dubil_qtty) as dubil_qtty -- 借据数量
    ,nvl(n.brwer_resv_recs_flg, o.brwer_resv_recs_flg) as brwer_resv_recs_flg -- 对借款人保留追索权标志
    ,nvl(n.guartor_resv_recs_flg, o.guartor_resv_recs_flg) as guartor_resv_recs_flg -- 对保证人保留追索权标志
    ,nvl(n.exist_propty_flg, o.exist_propty_flg) as exist_propty_flg -- 存在财产线索标志
    ,nvl(n.asset_descb, o.asset_descb) as asset_descb -- 资产线索描述
    ,nvl(n.obj_type_cd, o.obj_type_cd) as obj_type_cd -- 对象类型代码
    ,nvl(n.tran_type_cd, o.tran_type_cd) as tran_type_cd -- 交易类型代码
    ,nvl(n.ths_tm_tran_pric_sum, o.ths_tm_tran_pric_sum) as ths_tm_tran_pric_sum -- 本次交易本金合计
    ,nvl(n.ths_tm_tran_int_sum, o.ths_tm_tran_int_sum) as ths_tm_tran_int_sum -- 本次交易利息合计
    ,nvl(n.ths_tm_comp_int_sum, o.ths_tm_comp_int_sum) as ths_tm_comp_int_sum -- 本次复利合计
    ,nvl(n.ths_tm_pnlt_sum, o.ths_tm_pnlt_sum) as ths_tm_pnlt_sum -- 本次罚息合计
    ,nvl(n.ths_tm_tran_adv_fee_sum, o.ths_tm_tran_adv_fee_sum) as ths_tm_tran_adv_fee_sum -- 本次交易代垫费用合计
    ,nvl(n.oper_dt, o.oper_dt) as oper_dt -- 经办日期
    ,nvl(n.oper_belong_org_id, o.oper_belong_org_id) as oper_belong_org_id -- 经办所属机构编号
    ,nvl(n.oper_teller_id, o.oper_teller_id) as oper_teller_id -- 经办柜员编号
    ,nvl(n.rela_flow_num, o.rela_flow_num) as rela_flow_num -- 关联流水号
    ,nvl(n.ths_return_post_acct_recl_amt, o.ths_return_post_acct_recl_amt) as ths_return_post_acct_recl_amt -- 本次回款后应收款金额
    ,nvl(n.ths_return_bf_acct_recv_amt, o.ths_return_bf_acct_recv_amt) as ths_return_bf_acct_recv_amt -- 本次回款前应收款金额
    ,nvl(n.ths_tm_return_amt, o.ths_tm_return_amt) as ths_tm_return_amt -- 本次回款金额
    ,nvl(n.last_acm_return_amt, o.last_acm_return_amt) as last_acm_return_amt -- 上一累计回款金额
    ,nvl(n.acm_return_amt, o.acm_return_amt) as acm_return_amt -- 累计回款金额
    ,nvl(n.fst_return_amt, o.fst_return_amt) as fst_return_amt -- 首期回款金额
    ,nvl(n.rtn_suit_fee_cosdetn, o.rtn_suit_fee_cosdetn) as rtn_suit_fee_cosdetn -- 用于归还诉讼费的对价
    ,nvl(n.wrt_off_type_cd, o.wrt_off_type_cd) as wrt_off_type_cd -- 核销类型代码
    ,nvl(n.acct_recvbl_acct_id, o.acct_recvbl_acct_id) as acct_recvbl_acct_id -- 应收款账户编号
    ,nvl(n.acct_recvbl_acct_name, o.acct_recvbl_acct_name) as acct_recvbl_acct_name -- 应收款账户名称
    ,nvl(n.acct_recvbl_amt, o.acct_recvbl_amt) as acct_recvbl_amt -- 应收款金额
    ,nvl(n.tran_plat_cd, o.tran_plat_cd) as tran_plat_cd -- 交易平台代码
    ,nvl(n.tran_cont_id, o.tran_cont_id) as tran_cont_id -- 转让合同编号
    ,nvl(n.tran_way_cd, o.tran_way_cd) as tran_way_cd -- 转让方式代码
    ,nvl(n.tran_price, o.tran_price) as tran_price -- 转让价格
    ,nvl(n.real_tran_cosdetn, o.real_tran_cosdetn) as real_tran_cosdetn -- 真实转让对价
    ,nvl(n.tran_return_acct_id, o.tran_return_acct_id) as tran_return_acct_id -- 转让回款账户编号
    ,nvl(n.tran_return_acct_name, o.tran_return_acct_name) as tran_return_acct_name -- 转让回款账户名称
    ,nvl(n.inside_acct_open_org_id, o.inside_acct_open_org_id) as inside_acct_open_org_id -- 内部户开立机构编号
    ,nvl(n.debt_asset_id, o.debt_asset_id) as debt_asset_id -- 抵债资产编号
    ,nvl(n.debt_asset_name, o.debt_asset_name) as debt_asset_name -- 抵债资产名称
    ,nvl(n.debt_amt, o.debt_amt) as debt_amt -- 抵债金额
    ,nvl(n.recv_dt, o.recv_dt) as recv_dt -- 接收日期
    ,nvl(n.debt_asset_type_cd, o.debt_asset_type_cd) as debt_asset_type_cd -- 抵债资产类型代码
    ,nvl(n.debt_type_cd, o.debt_type_cd) as debt_type_cd -- 抵债类型代码
    ,nvl(n.disp_way_cd, o.disp_way_cd) as disp_way_cd -- 处置方式代码
    ,nvl(n.disp_amt, o.disp_amt) as disp_amt -- 处置金额
    ,nvl(n.disp_comnt, o.disp_comnt) as disp_comnt -- 处置说明
    ,nvl(n.create_mon, o.create_mon) as create_mon -- 生成月份
    ,nvl(n.crdt_bal, o.crdt_bal) as crdt_bal -- 授信余额
    ,nvl(n.loss_amt, o.loss_amt) as loss_amt -- 损失金额
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.guar_way_cd, o.guar_way_cd) as guar_way_cd -- 担保方式代码
    ,nvl(n.guartor, o.guartor) as guartor -- 保证人
    ,nvl(n.mtg_descb, o.mtg_descb) as mtg_descb -- 抵押物描述
    ,nvl(n.suit_prog, o.suit_prog) as suit_prog -- 诉讼进展
    ,nvl(n.liqd_disp_prop, o.liqd_disp_prop) as liqd_disp_prop -- 清收处置方案
    ,nvl(n.latest_disp_prog, o.latest_disp_prog) as latest_disp_prog -- 最新处置进展
    ,nvl(n.next_work_plan, o.next_work_plan) as next_work_plan -- 下一步工作计划
    ,nvl(n.exist_prob, o.exist_prob) as exist_prob -- 存在问题描述
    ,nvl(n.deduct_stl_acct_id, o.deduct_stl_acct_id) as deduct_stl_acct_id -- 扣款结算账户编号
    ,nvl(n.deduct_stl_acct_bal, o.deduct_stl_acct_bal) as deduct_stl_acct_bal -- 扣款结算账户余额
    ,nvl(n.deduct_amt, o.deduct_amt) as deduct_amt -- 扣划金额
    ,nvl(n.deduct_reason, o.deduct_reason) as deduct_reason -- 扣划理由
    ,nvl(n.on_acct_id, o.on_acct_id) as on_acct_id -- 挂账编号
    ,nvl(n.trane_cert_type_cd, o.trane_cert_type_cd) as trane_cert_type_cd -- 受让方证件类型代码
    ,nvl(n.trane_cert_no, o.trane_cert_no) as trane_cert_no -- 受让方证件号码
    ,nvl(n.trane_acct_id, o.trane_acct_id) as trane_acct_id -- 受让方账户编号
    ,nvl(n.trane_bank_no, o.trane_bank_no) as trane_bank_no -- 受让方行号
    ,nvl(n.trane_tran_acct_dt, o.trane_tran_acct_dt) as trane_tran_acct_dt -- 受让方转账日期
    ,nvl(n.prop_id, o.prop_id) as prop_id -- 方案编号
    ,nvl(n.sign_dt, o.sign_dt) as sign_dt -- 签约日期
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.agt_curr_cd, o.agt_curr_cd) as agt_curr_cd -- 协议币种代码
    ,nvl(n.agt_amt, o.agt_amt) as agt_amt -- 协议金额
    ,nvl(n.margin_amt, o.margin_amt) as margin_amt -- 保证金金额
    ,nvl(n.margin_ratio, o.margin_ratio) as margin_ratio -- 保证金比例
    ,nvl(n.margin_curr_cd, o.margin_curr_cd) as margin_curr_cd -- 保证金币种代码
    ,nvl(n.court_judge_id, o.court_judge_id) as court_judge_id -- 法院裁定书编号
    ,nvl(n.inst_pay_flg, o.inst_pay_flg) as inst_pay_flg -- 分期付款标志
    ,nvl(n.int_full_amt_derate_flg, o.int_full_amt_derate_flg) as int_full_amt_derate_flg -- 利息全额减免标志
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.rgst_belong_org_id, o.rgst_belong_org_id) as rgst_belong_org_id -- 登记所属机构编号
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
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
from ${iml_schema}.agt_astconsv_appl_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_astconsv_appl_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.ths_tm_asset_cls_cd <> n.ths_tm_asset_cls_cd
        or o.appl_rs_descb <> n.appl_rs_descb
        or o.derate_bf_pric_sum <> n.derate_bf_pric_sum
        or o.derate_bf_adv_fee_sum <> n.derate_bf_adv_fee_sum
        or o.derate_bf_comp_int_sum <> n.derate_bf_comp_int_sum
        or o.derate_bf_pnlt_sum <> n.derate_bf_pnlt_sum
        or o.derate_bf_int_sum <> n.derate_bf_int_sum
        or o.apv_status_cd <> n.apv_status_cd
        or o.cntpty_id <> n.cntpty_id
        or o.cntpty_name <> n.cntpty_name
        or o.dubil_qtty <> n.dubil_qtty
        or o.brwer_resv_recs_flg <> n.brwer_resv_recs_flg
        or o.guartor_resv_recs_flg <> n.guartor_resv_recs_flg
        or o.exist_propty_flg <> n.exist_propty_flg
        or o.asset_descb <> n.asset_descb
        or o.obj_type_cd <> n.obj_type_cd
        or o.tran_type_cd <> n.tran_type_cd
        or o.ths_tm_tran_pric_sum <> n.ths_tm_tran_pric_sum
        or o.ths_tm_tran_int_sum <> n.ths_tm_tran_int_sum
        or o.ths_tm_comp_int_sum <> n.ths_tm_comp_int_sum
        or o.ths_tm_pnlt_sum <> n.ths_tm_pnlt_sum
        or o.ths_tm_tran_adv_fee_sum <> n.ths_tm_tran_adv_fee_sum
        or o.oper_dt <> n.oper_dt
        or o.oper_belong_org_id <> n.oper_belong_org_id
        or o.oper_teller_id <> n.oper_teller_id
        or o.rela_flow_num <> n.rela_flow_num
        or o.ths_return_post_acct_recl_amt <> n.ths_return_post_acct_recl_amt
        or o.ths_return_bf_acct_recv_amt <> n.ths_return_bf_acct_recv_amt
        or o.ths_tm_return_amt <> n.ths_tm_return_amt
        or o.last_acm_return_amt <> n.last_acm_return_amt
        or o.acm_return_amt <> n.acm_return_amt
        or o.fst_return_amt <> n.fst_return_amt
        or o.rtn_suit_fee_cosdetn <> n.rtn_suit_fee_cosdetn
        or o.wrt_off_type_cd <> n.wrt_off_type_cd
        or o.acct_recvbl_acct_id <> n.acct_recvbl_acct_id
        or o.acct_recvbl_acct_name <> n.acct_recvbl_acct_name
        or o.acct_recvbl_amt <> n.acct_recvbl_amt
        or o.tran_plat_cd <> n.tran_plat_cd
        or o.tran_cont_id <> n.tran_cont_id
        or o.tran_way_cd <> n.tran_way_cd
        or o.tran_price <> n.tran_price
        or o.real_tran_cosdetn <> n.real_tran_cosdetn
        or o.tran_return_acct_id <> n.tran_return_acct_id
        or o.tran_return_acct_name <> n.tran_return_acct_name
        or o.inside_acct_open_org_id <> n.inside_acct_open_org_id
        or o.debt_asset_id <> n.debt_asset_id
        or o.debt_asset_name <> n.debt_asset_name
        or o.debt_amt <> n.debt_amt
        or o.recv_dt <> n.recv_dt
        or o.debt_asset_type_cd <> n.debt_asset_type_cd
        or o.debt_type_cd <> n.debt_type_cd
        or o.disp_way_cd <> n.disp_way_cd
        or o.disp_amt <> n.disp_amt
        or o.disp_comnt <> n.disp_comnt
        or o.create_mon <> n.create_mon
        or o.crdt_bal <> n.crdt_bal
        or o.loss_amt <> n.loss_amt
        or o.cust_type_cd <> n.cust_type_cd
        or o.guar_way_cd <> n.guar_way_cd
        or o.guartor <> n.guartor
        or o.mtg_descb <> n.mtg_descb
        or o.suit_prog <> n.suit_prog
        or o.liqd_disp_prop <> n.liqd_disp_prop
        or o.latest_disp_prog <> n.latest_disp_prog
        or o.next_work_plan <> n.next_work_plan
        or o.exist_prob <> n.exist_prob
        or o.deduct_stl_acct_id <> n.deduct_stl_acct_id
        or o.deduct_stl_acct_bal <> n.deduct_stl_acct_bal
        or o.deduct_amt <> n.deduct_amt
        or o.deduct_reason <> n.deduct_reason
        or o.on_acct_id <> n.on_acct_id
        or o.trane_cert_type_cd <> n.trane_cert_type_cd
        or o.trane_cert_no <> n.trane_cert_no
        or o.trane_acct_id <> n.trane_acct_id
        or o.trane_bank_no <> n.trane_bank_no
        or o.trane_tran_acct_dt <> n.trane_tran_acct_dt
        or o.prop_id <> n.prop_id
        or o.sign_dt <> n.sign_dt
        or o.effect_dt <> n.effect_dt
        or o.agt_curr_cd <> n.agt_curr_cd
        or o.agt_amt <> n.agt_amt
        or o.margin_amt <> n.margin_amt
        or o.margin_ratio <> n.margin_ratio
        or o.margin_curr_cd <> n.margin_curr_cd
        or o.court_judge_id <> n.court_judge_id
        or o.inst_pay_flg <> n.inst_pay_flg
        or o.int_full_amt_derate_flg <> n.int_full_amt_derate_flg
        or o.rgst_dt <> n.rgst_dt
        or o.rgst_belong_org_id <> n.rgst_belong_org_id
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.remark <> n.remark
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_astconsv_appl_info_h_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,ths_tm_asset_cls_cd -- 本次资产分类代码
    ,appl_rs_descb -- 申请原因描述
    ,derate_bf_pric_sum -- 减免前本金合计
    ,derate_bf_adv_fee_sum -- 减免前代垫费用合计
    ,derate_bf_comp_int_sum -- 减免前复利合计
    ,derate_bf_pnlt_sum -- 减免前罚息合计
    ,derate_bf_int_sum -- 减免前利息合计
    ,apv_status_cd -- 审批状态代码
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,dubil_qtty -- 借据数量
    ,brwer_resv_recs_flg -- 对借款人保留追索权标志
    ,guartor_resv_recs_flg -- 对保证人保留追索权标志
    ,exist_propty_flg -- 存在财产线索标志
    ,asset_descb -- 资产线索描述
    ,obj_type_cd -- 对象类型代码
    ,tran_type_cd -- 交易类型代码
    ,ths_tm_tran_pric_sum -- 本次交易本金合计
    ,ths_tm_tran_int_sum -- 本次交易利息合计
    ,ths_tm_comp_int_sum -- 本次复利合计
    ,ths_tm_pnlt_sum -- 本次罚息合计
    ,ths_tm_tran_adv_fee_sum -- 本次交易代垫费用合计
    ,oper_dt -- 经办日期
    ,oper_belong_org_id -- 经办所属机构编号
    ,oper_teller_id -- 经办柜员编号
    ,rela_flow_num -- 关联流水号
    ,ths_return_post_acct_recl_amt -- 本次回款后应收款金额
    ,ths_return_bf_acct_recv_amt -- 本次回款前应收款金额
    ,ths_tm_return_amt -- 本次回款金额
    ,last_acm_return_amt -- 上一累计回款金额
    ,acm_return_amt -- 累计回款金额
    ,fst_return_amt -- 首期回款金额
    ,rtn_suit_fee_cosdetn -- 用于归还诉讼费的对价
    ,wrt_off_type_cd -- 核销类型代码
    ,acct_recvbl_acct_id -- 应收款账户编号
    ,acct_recvbl_acct_name -- 应收款账户名称
    ,acct_recvbl_amt -- 应收款金额
    ,tran_plat_cd -- 交易平台代码
    ,tran_cont_id -- 转让合同编号
    ,tran_way_cd -- 转让方式代码
    ,tran_price -- 转让价格
    ,real_tran_cosdetn -- 真实转让对价
    ,tran_return_acct_id -- 转让回款账户编号
    ,tran_return_acct_name -- 转让回款账户名称
    ,inside_acct_open_org_id -- 内部户开立机构编号
    ,debt_asset_id -- 抵债资产编号
    ,debt_asset_name -- 抵债资产名称
    ,debt_amt -- 抵债金额
    ,recv_dt -- 接收日期
    ,debt_asset_type_cd -- 抵债资产类型代码
    ,debt_type_cd -- 抵债类型代码
    ,disp_way_cd -- 处置方式代码
    ,disp_amt -- 处置金额
    ,disp_comnt -- 处置说明
    ,create_mon -- 生成月份
    ,crdt_bal -- 授信余额
    ,loss_amt -- 损失金额
    ,cust_type_cd -- 客户类型代码
    ,guar_way_cd -- 担保方式代码
    ,guartor -- 保证人
    ,mtg_descb -- 抵押物描述
    ,suit_prog -- 诉讼进展
    ,liqd_disp_prop -- 清收处置方案
    ,latest_disp_prog -- 最新处置进展
    ,next_work_plan -- 下一步工作计划
    ,exist_prob -- 存在问题描述
    ,deduct_stl_acct_id -- 扣款结算账户编号
    ,deduct_stl_acct_bal -- 扣款结算账户余额
    ,deduct_amt -- 扣划金额
    ,deduct_reason -- 扣划理由
    ,on_acct_id -- 挂账编号
    ,trane_cert_type_cd -- 受让方证件类型代码
    ,trane_cert_no -- 受让方证件号码
    ,trane_acct_id -- 受让方账户编号
    ,trane_bank_no -- 受让方行号
    ,trane_tran_acct_dt -- 受让方转账日期
    ,prop_id -- 方案编号
    ,sign_dt -- 签约日期
    ,effect_dt -- 生效日期
    ,agt_curr_cd -- 协议币种代码
    ,agt_amt -- 协议金额
    ,margin_amt -- 保证金金额
    ,margin_ratio -- 保证金比例
    ,margin_curr_cd -- 保证金币种代码
    ,court_judge_id -- 法院裁定书编号
    ,inst_pay_flg -- 分期付款标志
    ,int_full_amt_derate_flg -- 利息全额减免标志
    ,rgst_dt -- 登记日期
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_astconsv_appl_info_h_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,ths_tm_asset_cls_cd -- 本次资产分类代码
    ,appl_rs_descb -- 申请原因描述
    ,derate_bf_pric_sum -- 减免前本金合计
    ,derate_bf_adv_fee_sum -- 减免前代垫费用合计
    ,derate_bf_comp_int_sum -- 减免前复利合计
    ,derate_bf_pnlt_sum -- 减免前罚息合计
    ,derate_bf_int_sum -- 减免前利息合计
    ,apv_status_cd -- 审批状态代码
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,dubil_qtty -- 借据数量
    ,brwer_resv_recs_flg -- 对借款人保留追索权标志
    ,guartor_resv_recs_flg -- 对保证人保留追索权标志
    ,exist_propty_flg -- 存在财产线索标志
    ,asset_descb -- 资产线索描述
    ,obj_type_cd -- 对象类型代码
    ,tran_type_cd -- 交易类型代码
    ,ths_tm_tran_pric_sum -- 本次交易本金合计
    ,ths_tm_tran_int_sum -- 本次交易利息合计
    ,ths_tm_comp_int_sum -- 本次复利合计
    ,ths_tm_pnlt_sum -- 本次罚息合计
    ,ths_tm_tran_adv_fee_sum -- 本次交易代垫费用合计
    ,oper_dt -- 经办日期
    ,oper_belong_org_id -- 经办所属机构编号
    ,oper_teller_id -- 经办柜员编号
    ,rela_flow_num -- 关联流水号
    ,ths_return_post_acct_recl_amt -- 本次回款后应收款金额
    ,ths_return_bf_acct_recv_amt -- 本次回款前应收款金额
    ,ths_tm_return_amt -- 本次回款金额
    ,last_acm_return_amt -- 上一累计回款金额
    ,acm_return_amt -- 累计回款金额
    ,fst_return_amt -- 首期回款金额
    ,rtn_suit_fee_cosdetn -- 用于归还诉讼费的对价
    ,wrt_off_type_cd -- 核销类型代码
    ,acct_recvbl_acct_id -- 应收款账户编号
    ,acct_recvbl_acct_name -- 应收款账户名称
    ,acct_recvbl_amt -- 应收款金额
    ,tran_plat_cd -- 交易平台代码
    ,tran_cont_id -- 转让合同编号
    ,tran_way_cd -- 转让方式代码
    ,tran_price -- 转让价格
    ,real_tran_cosdetn -- 真实转让对价
    ,tran_return_acct_id -- 转让回款账户编号
    ,tran_return_acct_name -- 转让回款账户名称
    ,inside_acct_open_org_id -- 内部户开立机构编号
    ,debt_asset_id -- 抵债资产编号
    ,debt_asset_name -- 抵债资产名称
    ,debt_amt -- 抵债金额
    ,recv_dt -- 接收日期
    ,debt_asset_type_cd -- 抵债资产类型代码
    ,debt_type_cd -- 抵债类型代码
    ,disp_way_cd -- 处置方式代码
    ,disp_amt -- 处置金额
    ,disp_comnt -- 处置说明
    ,create_mon -- 生成月份
    ,crdt_bal -- 授信余额
    ,loss_amt -- 损失金额
    ,cust_type_cd -- 客户类型代码
    ,guar_way_cd -- 担保方式代码
    ,guartor -- 保证人
    ,mtg_descb -- 抵押物描述
    ,suit_prog -- 诉讼进展
    ,liqd_disp_prop -- 清收处置方案
    ,latest_disp_prog -- 最新处置进展
    ,next_work_plan -- 下一步工作计划
    ,exist_prob -- 存在问题描述
    ,deduct_stl_acct_id -- 扣款结算账户编号
    ,deduct_stl_acct_bal -- 扣款结算账户余额
    ,deduct_amt -- 扣划金额
    ,deduct_reason -- 扣划理由
    ,on_acct_id -- 挂账编号
    ,trane_cert_type_cd -- 受让方证件类型代码
    ,trane_cert_no -- 受让方证件号码
    ,trane_acct_id -- 受让方账户编号
    ,trane_bank_no -- 受让方行号
    ,trane_tran_acct_dt -- 受让方转账日期
    ,prop_id -- 方案编号
    ,sign_dt -- 签约日期
    ,effect_dt -- 生效日期
    ,agt_curr_cd -- 协议币种代码
    ,agt_amt -- 协议金额
    ,margin_amt -- 保证金金额
    ,margin_ratio -- 保证金比例
    ,margin_curr_cd -- 保证金币种代码
    ,court_judge_id -- 法院裁定书编号
    ,inst_pay_flg -- 分期付款标志
    ,int_full_amt_derate_flg -- 利息全额减免标志
    ,rgst_dt -- 登记日期
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
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
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.ths_tm_asset_cls_cd -- 本次资产分类代码
    ,o.appl_rs_descb -- 申请原因描述
    ,o.derate_bf_pric_sum -- 减免前本金合计
    ,o.derate_bf_adv_fee_sum -- 减免前代垫费用合计
    ,o.derate_bf_comp_int_sum -- 减免前复利合计
    ,o.derate_bf_pnlt_sum -- 减免前罚息合计
    ,o.derate_bf_int_sum -- 减免前利息合计
    ,o.apv_status_cd -- 审批状态代码
    ,o.cntpty_id -- 交易对手编号
    ,o.cntpty_name -- 交易对手名称
    ,o.dubil_qtty -- 借据数量
    ,o.brwer_resv_recs_flg -- 对借款人保留追索权标志
    ,o.guartor_resv_recs_flg -- 对保证人保留追索权标志
    ,o.exist_propty_flg -- 存在财产线索标志
    ,o.asset_descb -- 资产线索描述
    ,o.obj_type_cd -- 对象类型代码
    ,o.tran_type_cd -- 交易类型代码
    ,o.ths_tm_tran_pric_sum -- 本次交易本金合计
    ,o.ths_tm_tran_int_sum -- 本次交易利息合计
    ,o.ths_tm_comp_int_sum -- 本次复利合计
    ,o.ths_tm_pnlt_sum -- 本次罚息合计
    ,o.ths_tm_tran_adv_fee_sum -- 本次交易代垫费用合计
    ,o.oper_dt -- 经办日期
    ,o.oper_belong_org_id -- 经办所属机构编号
    ,o.oper_teller_id -- 经办柜员编号
    ,o.rela_flow_num -- 关联流水号
    ,o.ths_return_post_acct_recl_amt -- 本次回款后应收款金额
    ,o.ths_return_bf_acct_recv_amt -- 本次回款前应收款金额
    ,o.ths_tm_return_amt -- 本次回款金额
    ,o.last_acm_return_amt -- 上一累计回款金额
    ,o.acm_return_amt -- 累计回款金额
    ,o.fst_return_amt -- 首期回款金额
    ,o.rtn_suit_fee_cosdetn -- 用于归还诉讼费的对价
    ,o.wrt_off_type_cd -- 核销类型代码
    ,o.acct_recvbl_acct_id -- 应收款账户编号
    ,o.acct_recvbl_acct_name -- 应收款账户名称
    ,o.acct_recvbl_amt -- 应收款金额
    ,o.tran_plat_cd -- 交易平台代码
    ,o.tran_cont_id -- 转让合同编号
    ,o.tran_way_cd -- 转让方式代码
    ,o.tran_price -- 转让价格
    ,o.real_tran_cosdetn -- 真实转让对价
    ,o.tran_return_acct_id -- 转让回款账户编号
    ,o.tran_return_acct_name -- 转让回款账户名称
    ,o.inside_acct_open_org_id -- 内部户开立机构编号
    ,o.debt_asset_id -- 抵债资产编号
    ,o.debt_asset_name -- 抵债资产名称
    ,o.debt_amt -- 抵债金额
    ,o.recv_dt -- 接收日期
    ,o.debt_asset_type_cd -- 抵债资产类型代码
    ,o.debt_type_cd -- 抵债类型代码
    ,o.disp_way_cd -- 处置方式代码
    ,o.disp_amt -- 处置金额
    ,o.disp_comnt -- 处置说明
    ,o.create_mon -- 生成月份
    ,o.crdt_bal -- 授信余额
    ,o.loss_amt -- 损失金额
    ,o.cust_type_cd -- 客户类型代码
    ,o.guar_way_cd -- 担保方式代码
    ,o.guartor -- 保证人
    ,o.mtg_descb -- 抵押物描述
    ,o.suit_prog -- 诉讼进展
    ,o.liqd_disp_prop -- 清收处置方案
    ,o.latest_disp_prog -- 最新处置进展
    ,o.next_work_plan -- 下一步工作计划
    ,o.exist_prob -- 存在问题描述
    ,o.deduct_stl_acct_id -- 扣款结算账户编号
    ,o.deduct_stl_acct_bal -- 扣款结算账户余额
    ,o.deduct_amt -- 扣划金额
    ,o.deduct_reason -- 扣划理由
    ,o.on_acct_id -- 挂账编号
    ,o.trane_cert_type_cd -- 受让方证件类型代码
    ,o.trane_cert_no -- 受让方证件号码
    ,o.trane_acct_id -- 受让方账户编号
    ,o.trane_bank_no -- 受让方行号
    ,o.trane_tran_acct_dt -- 受让方转账日期
    ,o.prop_id -- 方案编号
    ,o.sign_dt -- 签约日期
    ,o.effect_dt -- 生效日期
    ,o.agt_curr_cd -- 协议币种代码
    ,o.agt_amt -- 协议金额
    ,o.margin_amt -- 保证金金额
    ,o.margin_ratio -- 保证金比例
    ,o.margin_curr_cd -- 保证金币种代码
    ,o.court_judge_id -- 法院裁定书编号
    ,o.inst_pay_flg -- 分期付款标志
    ,o.int_full_amt_derate_flg -- 利息全额减免标志
    ,o.rgst_dt -- 登记日期
    ,o.rgst_belong_org_id -- 登记所属机构编号
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
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
from ${iml_schema}.agt_astconsv_appl_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_astconsv_appl_info_h_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_astconsv_appl_info_h_icmsf1_cl d
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
--truncate table ${iml_schema}.agt_astconsv_appl_info_h;
--alter table ${iml_schema}.agt_astconsv_appl_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_astconsv_appl_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_astconsv_appl_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_astconsv_appl_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_astconsv_appl_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_astconsv_appl_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_astconsv_appl_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_astconsv_appl_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_astconsv_appl_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_astconsv_appl_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_astconsv_appl_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_astconsv_appl_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_astconsv_appl_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_astconsv_appl_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
