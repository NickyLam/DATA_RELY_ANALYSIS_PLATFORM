/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_exp_lc_doc_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_exp_lc_doc_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_exp_lc_doc_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_exp_lc_doc_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,src_agt_id varchar2(60) -- 源协议编号
    ,doc_id varchar2(60) -- 单据编号
    ,tran_descb varchar2(375) -- 交易描述
    ,parent_bus_type_cd varchar2(30) -- 父类业务类型代码
    ,parent_tran_intnal_id varchar2(60) -- 父类交易内部编号
    ,sugst_pay_dt date -- 提示付款日期
    ,cust_present_dt date -- 客户交单日期
    ,shipment_dt date -- 装船日期
    ,valid_pay_dt date -- 有效付款日期
    ,doc_type_cd varchar2(30) -- 单据类型代码
    ,teller_rgst_dt date -- 柜员登记日期
    ,close_dt date -- 闭卷日期
    ,acquiri_bank_rgst_dt date -- 收单行登记日期
    ,bus_teller_id varchar2(60) -- 业务柜员编号
    ,proof_nego_pay_flg varchar2(10) -- 凭保议付标志
    ,noth_flg varchar2(10) -- 无偿放单标志
    ,iss_ps_type_cd varchar2(30) -- 出单人类型代码
    ,payer_type_cd varchar2(30) -- 付款人类型代码
    ,margin_letter_revid_dt date -- 保证金信件收到日期
    ,discrp_flg varchar2(10) -- 不符点标志
    ,curt_acpt_flg varchar2(10) -- 现在承兑标志
    ,curr_cd varchar2(30) -- 币种代码
    ,pay_tot_amt number(30,3) -- 付款总金额
    ,pay_dt date -- 付款日期
    ,doc_status_cd varchar2(30) -- 单据状态代码
    ,doc_recv_ps_type_cd varchar2(30) -- 单据接收人类型代码
    ,send_exp_other_addr_flg varchar2(10) -- 送单到其他地址标志
    ,return_doc_flg varchar2(10) -- 返还单据标志
    ,reim_bank_cd varchar2(30) -- 偿付行代码
    ,overs_comm_fee number(18,3) -- 国外手续费
    ,trast_org_id varchar2(60) -- 办理机构编号
    ,belong_org_id varchar2(60) -- 所属机构编号
    ,nra_pay_flg varchar2(10) -- NRA付款标志
    ,ship_odd_no varchar2(60) -- 船运单号
    ,traff_doc_type_cd varchar2(30) -- 运输单据类型代码
    ,traff_dt date -- 运输日期
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_exp_lc_doc_h to ${icl_schema};
grant select on ${iml_schema}.agt_exp_lc_doc_h to ${idl_schema};
grant select on ${iml_schema}.agt_exp_lc_doc_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_exp_lc_doc_h is '出口信用证单据历史';
comment on column ${iml_schema}.agt_exp_lc_doc_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_exp_lc_doc_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_exp_lc_doc_h.src_agt_id is '源协议编号';
comment on column ${iml_schema}.agt_exp_lc_doc_h.doc_id is '单据编号';
comment on column ${iml_schema}.agt_exp_lc_doc_h.tran_descb is '交易描述';
comment on column ${iml_schema}.agt_exp_lc_doc_h.parent_bus_type_cd is '父类业务类型代码';
comment on column ${iml_schema}.agt_exp_lc_doc_h.parent_tran_intnal_id is '父类交易内部编号';
comment on column ${iml_schema}.agt_exp_lc_doc_h.sugst_pay_dt is '提示付款日期';
comment on column ${iml_schema}.agt_exp_lc_doc_h.cust_present_dt is '客户交单日期';
comment on column ${iml_schema}.agt_exp_lc_doc_h.shipment_dt is '装船日期';
comment on column ${iml_schema}.agt_exp_lc_doc_h.valid_pay_dt is '有效付款日期';
comment on column ${iml_schema}.agt_exp_lc_doc_h.doc_type_cd is '单据类型代码';
comment on column ${iml_schema}.agt_exp_lc_doc_h.teller_rgst_dt is '柜员登记日期';
comment on column ${iml_schema}.agt_exp_lc_doc_h.close_dt is '闭卷日期';
comment on column ${iml_schema}.agt_exp_lc_doc_h.acquiri_bank_rgst_dt is '收单行登记日期';
comment on column ${iml_schema}.agt_exp_lc_doc_h.bus_teller_id is '业务柜员编号';
comment on column ${iml_schema}.agt_exp_lc_doc_h.proof_nego_pay_flg is '凭保议付标志';
comment on column ${iml_schema}.agt_exp_lc_doc_h.noth_flg is '无偿放单标志';
comment on column ${iml_schema}.agt_exp_lc_doc_h.iss_ps_type_cd is '出单人类型代码';
comment on column ${iml_schema}.agt_exp_lc_doc_h.payer_type_cd is '付款人类型代码';
comment on column ${iml_schema}.agt_exp_lc_doc_h.margin_letter_revid_dt is '保证金信件收到日期';
comment on column ${iml_schema}.agt_exp_lc_doc_h.discrp_flg is '不符点标志';
comment on column ${iml_schema}.agt_exp_lc_doc_h.curt_acpt_flg is '现在承兑标志';
comment on column ${iml_schema}.agt_exp_lc_doc_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_exp_lc_doc_h.pay_tot_amt is '付款总金额';
comment on column ${iml_schema}.agt_exp_lc_doc_h.pay_dt is '付款日期';
comment on column ${iml_schema}.agt_exp_lc_doc_h.doc_status_cd is '单据状态代码';
comment on column ${iml_schema}.agt_exp_lc_doc_h.doc_recv_ps_type_cd is '单据接收人类型代码';
comment on column ${iml_schema}.agt_exp_lc_doc_h.send_exp_other_addr_flg is '送单到其他地址标志';
comment on column ${iml_schema}.agt_exp_lc_doc_h.return_doc_flg is '返还单据标志';
comment on column ${iml_schema}.agt_exp_lc_doc_h.reim_bank_cd is '偿付行代码';
comment on column ${iml_schema}.agt_exp_lc_doc_h.overs_comm_fee is '国外手续费';
comment on column ${iml_schema}.agt_exp_lc_doc_h.trast_org_id is '办理机构编号';
comment on column ${iml_schema}.agt_exp_lc_doc_h.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.agt_exp_lc_doc_h.nra_pay_flg is 'NRA付款标志';
comment on column ${iml_schema}.agt_exp_lc_doc_h.ship_odd_no is '船运单号';
comment on column ${iml_schema}.agt_exp_lc_doc_h.traff_doc_type_cd is '运输单据类型代码';
comment on column ${iml_schema}.agt_exp_lc_doc_h.traff_dt is '运输日期';
comment on column ${iml_schema}.agt_exp_lc_doc_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_exp_lc_doc_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_exp_lc_doc_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_exp_lc_doc_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_exp_lc_doc_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_exp_lc_doc_h.etl_timestamp is 'ETL处理时间戳';
