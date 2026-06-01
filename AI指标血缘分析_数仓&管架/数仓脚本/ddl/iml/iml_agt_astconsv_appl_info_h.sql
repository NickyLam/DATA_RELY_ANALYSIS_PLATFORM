/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_astconsv_appl_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_astconsv_appl_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_astconsv_appl_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_astconsv_appl_info_h(
    appl_id varchar2(100) -- 申请编号
    ,lp_id varchar2(100) -- 法人编号
    ,appl_flow_num varchar2(100) -- 申请流水号
    ,cust_id varchar2(4000) -- 客户编号
    ,cust_name varchar2(4000) -- 客户名称
    ,ths_tm_asset_cls_cd varchar2(60) -- 本次资产分类代码
    ,appl_rs_descb varchar2(4000) -- 申请原因描述
    ,derate_bf_pric_sum number(30,8) -- 减免前本金合计
    ,derate_bf_adv_fee_sum number(30,8) -- 减免前代垫费用合计
    ,derate_bf_comp_int_sum number(30,8) -- 减免前复利合计
    ,derate_bf_pnlt_sum number(30,8) -- 减免前罚息合计
    ,derate_bf_int_sum number(30,8) -- 减免前利息合计
    ,apv_status_cd varchar2(100) -- 审批状态代码
    ,cntpty_id varchar2(250) -- 交易对手编号
    ,cntpty_name varchar2(500) -- 交易对手名称
    ,dubil_qtty number(30) -- 借据数量
    ,brwer_resv_recs_flg varchar2(60) -- 对借款人保留追索权标志
    ,guartor_resv_recs_flg varchar2(60) -- 对保证人保留追索权标志
    ,exist_propty_flg varchar2(60) -- 存在财产线索标志
    ,asset_descb varchar2(2000) -- 资产线索描述
    ,obj_type_cd varchar2(100) -- 对象类型代码
    ,tran_type_cd varchar2(60) -- 交易类型代码
    ,ths_tm_tran_pric_sum number(30,8) -- 本次交易本金合计
    ,ths_tm_tran_int_sum number(30,8) -- 本次交易利息合计
    ,ths_tm_comp_int_sum number(30,8) -- 本次复利合计
    ,ths_tm_pnlt_sum number(30,8) -- 本次罚息合计
    ,ths_tm_tran_adv_fee_sum number(30,8) -- 本次交易代垫费用合计
    ,oper_dt date -- 经办日期
    ,oper_belong_org_id varchar2(100) -- 经办所属机构编号
    ,oper_teller_id varchar2(100) -- 经办柜员编号
    ,rela_flow_num varchar2(100) -- 关联流水号
    ,ths_return_post_acct_recl_amt number(30,8) -- 本次回款后应收款金额
    ,ths_return_bf_acct_recv_amt number(30,8) -- 本次回款前应收款金额
    ,ths_tm_return_amt number(30,8) -- 本次回款金额
    ,last_acm_return_amt number(30,8) -- 上一累计回款金额
    ,acm_return_amt number(30,8) -- 累计回款金额
    ,fst_return_amt number(30,8) -- 首期回款金额
    ,rtn_suit_fee_cosdetn number(30,8) -- 用于归还诉讼费的对价
    ,wrt_off_type_cd varchar2(60) -- 核销类型代码
    ,acct_recvbl_acct_id varchar2(250) -- 应收款账户编号
    ,acct_recvbl_acct_name varchar2(500) -- 应收款账户名称
    ,acct_recvbl_amt number(30,8) -- 应收款金额
    ,tran_plat_cd varchar2(60) -- 交易平台代码
    ,tran_cont_id varchar2(500) -- 转让合同编号
    ,tran_way_cd varchar2(60) -- 转让方式代码
    ,tran_price number(30,8) -- 转让价格
    ,real_tran_cosdetn number(30,8) -- 真实转让对价
    ,tran_return_acct_id varchar2(250) -- 转让回款账户编号
    ,tran_return_acct_name varchar2(500) -- 转让回款账户名称
    ,inside_acct_open_org_id varchar2(250) -- 内部户开立机构编号
    ,debt_asset_id varchar2(100) -- 抵债资产编号
    ,debt_asset_name varchar2(500) -- 抵债资产名称
    ,debt_amt number(30,8) -- 抵债金额
    ,recv_dt date -- 接收日期
    ,debt_asset_type_cd varchar2(60) -- 抵债资产类型代码
    ,debt_type_cd varchar2(60) -- 抵债类型代码
    ,disp_way_cd varchar2(60) -- 处置方式代码
    ,disp_amt number(30,8) -- 处置金额
    ,disp_comnt varchar2(4000) -- 处置说明
    ,create_mon varchar2(500) -- 生成月份
    ,crdt_bal number(30,8) -- 授信余额
    ,loss_amt number(30,8) -- 损失金额
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,guar_way_cd varchar2(30) -- 担保方式代码
    ,guartor varchar2(4000) -- 保证人
    ,mtg_descb varchar2(4000) -- 抵押物描述
    ,suit_prog varchar2(4000) -- 诉讼进展
    ,liqd_disp_prop varchar2(4000) -- 清收处置方案
    ,latest_disp_prog varchar2(4000) -- 最新处置进展
    ,next_work_plan varchar2(4000) -- 下一步工作计划
    ,exist_prob varchar2(4000) -- 存在问题描述
    ,deduct_stl_acct_id varchar2(250) -- 扣款结算账户编号
    ,deduct_stl_acct_bal number(30,8) -- 扣款结算账户余额
    ,deduct_amt number(30,8) -- 扣划金额
    ,deduct_reason varchar2(4000) -- 扣划理由
    ,on_acct_id varchar2(100) -- 挂账编号
    ,trane_cert_type_cd varchar2(30) -- 受让方证件类型代码
    ,trane_cert_no varchar2(100) -- 受让方证件号码
    ,trane_acct_id varchar2(100) -- 受让方账户编号
    ,trane_bank_no varchar2(100) -- 受让方行号
    ,trane_tran_acct_dt date -- 受让方转账日期
    ,prop_id varchar2(100) -- 方案编号
    ,sign_dt date -- 签约日期
    ,effect_dt date -- 生效日期
    ,agt_curr_cd varchar2(30) -- 协议币种代码
    ,agt_amt number(30,8) -- 协议金额
    ,margin_amt number(30,8) -- 保证金金额
    ,margin_ratio number(30,8) -- 保证金比例
    ,margin_curr_cd varchar2(30) -- 保证金币种代码
    ,court_judge_id varchar2(250) -- 法院裁定书编号
    ,inst_pay_flg varchar2(10) -- 分期付款标志
    ,int_full_amt_derate_flg varchar2(10) -- 利息全额减免标志
    ,rgst_dt date -- 登记日期
    ,rgst_belong_org_id varchar2(100) -- 登记所属机构编号
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,remark varchar2(4000) -- 备注
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_astconsv_appl_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_astconsv_appl_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_astconsv_appl_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_astconsv_appl_info_h is '资产保全申请信息历史';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.appl_id is '申请编号';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.appl_flow_num is '申请流水号';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.ths_tm_asset_cls_cd is '本次资产分类代码';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.appl_rs_descb is '申请原因描述';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.derate_bf_pric_sum is '减免前本金合计';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.derate_bf_adv_fee_sum is '减免前代垫费用合计';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.derate_bf_comp_int_sum is '减免前复利合计';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.derate_bf_pnlt_sum is '减免前罚息合计';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.derate_bf_int_sum is '减免前利息合计';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.apv_status_cd is '审批状态代码';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.cntpty_id is '交易对手编号';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.cntpty_name is '交易对手名称';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.dubil_qtty is '借据数量';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.brwer_resv_recs_flg is '对借款人保留追索权标志';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.guartor_resv_recs_flg is '对保证人保留追索权标志';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.exist_propty_flg is '存在财产线索标志';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.asset_descb is '资产线索描述';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.obj_type_cd is '对象类型代码';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.ths_tm_tran_pric_sum is '本次交易本金合计';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.ths_tm_tran_int_sum is '本次交易利息合计';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.ths_tm_comp_int_sum is '本次复利合计';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.ths_tm_pnlt_sum is '本次罚息合计';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.ths_tm_tran_adv_fee_sum is '本次交易代垫费用合计';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.oper_dt is '经办日期';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.oper_belong_org_id is '经办所属机构编号';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.oper_teller_id is '经办柜员编号';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.rela_flow_num is '关联流水号';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.ths_return_post_acct_recl_amt is '本次回款后应收款金额';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.ths_return_bf_acct_recv_amt is '本次回款前应收款金额';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.ths_tm_return_amt is '本次回款金额';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.last_acm_return_amt is '上一累计回款金额';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.acm_return_amt is '累计回款金额';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.fst_return_amt is '首期回款金额';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.rtn_suit_fee_cosdetn is '用于归还诉讼费的对价';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.wrt_off_type_cd is '核销类型代码';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.acct_recvbl_acct_id is '应收款账户编号';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.acct_recvbl_acct_name is '应收款账户名称';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.acct_recvbl_amt is '应收款金额';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.tran_plat_cd is '交易平台代码';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.tran_cont_id is '转让合同编号';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.tran_way_cd is '转让方式代码';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.tran_price is '转让价格';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.real_tran_cosdetn is '真实转让对价';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.tran_return_acct_id is '转让回款账户编号';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.tran_return_acct_name is '转让回款账户名称';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.inside_acct_open_org_id is '内部户开立机构编号';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.debt_asset_id is '抵债资产编号';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.debt_asset_name is '抵债资产名称';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.debt_amt is '抵债金额';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.recv_dt is '接收日期';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.debt_asset_type_cd is '抵债资产类型代码';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.debt_type_cd is '抵债类型代码';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.disp_way_cd is '处置方式代码';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.disp_amt is '处置金额';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.disp_comnt is '处置说明';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.create_mon is '生成月份';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.crdt_bal is '授信余额';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.loss_amt is '损失金额';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.guar_way_cd is '担保方式代码';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.guartor is '保证人';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.mtg_descb is '抵押物描述';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.suit_prog is '诉讼进展';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.liqd_disp_prop is '清收处置方案';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.latest_disp_prog is '最新处置进展';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.next_work_plan is '下一步工作计划';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.exist_prob is '存在问题描述';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.deduct_stl_acct_id is '扣款结算账户编号';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.deduct_stl_acct_bal is '扣款结算账户余额';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.deduct_amt is '扣划金额';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.deduct_reason is '扣划理由';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.on_acct_id is '挂账编号';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.trane_cert_type_cd is '受让方证件类型代码';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.trane_cert_no is '受让方证件号码';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.trane_acct_id is '受让方账户编号';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.trane_bank_no is '受让方行号';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.trane_tran_acct_dt is '受让方转账日期';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.prop_id is '方案编号';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.sign_dt is '签约日期';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.agt_curr_cd is '协议币种代码';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.agt_amt is '协议金额';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.margin_amt is '保证金金额';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.margin_ratio is '保证金比例';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.margin_curr_cd is '保证金币种代码';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.court_judge_id is '法院裁定书编号';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.inst_pay_flg is '分期付款标志';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.int_full_amt_derate_flg is '利息全额减免标志';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.rgst_belong_org_id is '登记所属机构编号';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.remark is '备注';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_astconsv_appl_info_h.etl_timestamp is 'ETL处理时间戳';
