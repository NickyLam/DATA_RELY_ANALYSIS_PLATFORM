/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_dom_buyer_lc_doc_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_dom_buyer_lc_doc_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_dom_buyer_lc_doc_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dom_buyer_lc_doc_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,src_agt_id varchar2(100) -- 源协议编号
    ,bill_bus_id varchar2(100) -- 票据业务编号
    ,tran_descb varchar2(150) -- 交易描述
    ,bus_teller_id varchar2(100) -- 业务柜员编号
    ,sys_rgst_dt date -- 系统登记日期
    ,issue_dt date -- 开证日期
    ,close_dt date -- 闭卷日期
    ,parent_bus_type_cd varchar2(30) -- 父类业务类型代码
    ,parent_tran_intnal_id varchar2(100) -- 父类交易内部编号
    ,send_bill_bk_send_bill_dt date -- 寄单行寄单日期
    ,latest_ship_dt date -- 最迟装运日期
    ,valid_pay_dt date -- 有效付款日期
    ,load_bill_revid_dt date -- 提单收到日期
    ,discrp_advise_dt date -- 不符点通知日期
    ,doc_type_cd varchar2(30) -- 单据类型代码
    ,refuse_pay_flg_cd varchar2(30) -- 拒付标志代码
    ,free_pay_present_flg varchar2(10) -- 免付款交单标志
    ,edit_id varchar2(100) -- 版本编号
    ,recv_advise_type_cd varchar2(30) -- 接收通知类型代码
    ,cargo_auth_applit_flg varchar2(10) -- 货物授权申请人标志
    ,multi_tenor_flg varchar2(10) -- 多期限标志
    ,doc_diff_flg varchar2(10) -- 单据差异标志
    ,submit_role_type_cd varchar2(30) -- 提交角色类型代码
    ,doc_status_cd varchar2(30) -- 单据状态代码
    ,ignore_discrp_flg varchar2(10) -- 忽略不符点标志
    ,pay_curr_cd varchar2(30) -- 付款币种代码
    ,pay_tot_amt number(30,3) -- 付款总金额
    ,payer_type_cd varchar2(30) -- 付款人类型代码
    ,acpt_flg varchar2(10) -- 承兑标志
    ,income_bill_dt date -- 来单日期
    ,chargeback_flg varchar2(10) -- 退单标志
    ,trast_org_id varchar2(100) -- 办理机构编号
    ,belong_org_id varchar2(100) -- 所属机构编号
    ,inv_id varchar2(100) -- 发票号码
    ,cfm_curr_cd varchar2(30) -- 确认币种代码
    ,cfm_amt number(30,3) -- 确认金额
    ,doc_cont_id varchar2(100) -- 单据合同编号
    ,clear_way_cd varchar2(30) -- 清算方式代码
    ,send_bill_claim_money_id varchar2(100) -- 寄单索款编号
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
grant select on ${iml_schema}.agt_dom_buyer_lc_doc_h to ${icl_schema};
grant select on ${iml_schema}.agt_dom_buyer_lc_doc_h to ${idl_schema};
grant select on ${iml_schema}.agt_dom_buyer_lc_doc_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_dom_buyer_lc_doc_h is '国内买方信用证单据历史';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.src_agt_id is '源协议编号';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.bill_bus_id is '票据业务编号';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.tran_descb is '交易描述';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.bus_teller_id is '业务柜员编号';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.sys_rgst_dt is '系统登记日期';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.issue_dt is '开证日期';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.close_dt is '闭卷日期';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.parent_bus_type_cd is '父类业务类型代码';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.parent_tran_intnal_id is '父类交易内部编号';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.send_bill_bk_send_bill_dt is '寄单行寄单日期';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.latest_ship_dt is '最迟装运日期';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.valid_pay_dt is '有效付款日期';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.load_bill_revid_dt is '提单收到日期';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.discrp_advise_dt is '不符点通知日期';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.doc_type_cd is '单据类型代码';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.refuse_pay_flg_cd is '拒付标志代码';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.free_pay_present_flg is '免付款交单标志';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.edit_id is '版本编号';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.recv_advise_type_cd is '接收通知类型代码';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.cargo_auth_applit_flg is '货物授权申请人标志';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.multi_tenor_flg is '多期限标志';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.doc_diff_flg is '单据差异标志';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.submit_role_type_cd is '提交角色类型代码';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.doc_status_cd is '单据状态代码';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.ignore_discrp_flg is '忽略不符点标志';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.pay_curr_cd is '付款币种代码';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.pay_tot_amt is '付款总金额';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.payer_type_cd is '付款人类型代码';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.acpt_flg is '承兑标志';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.income_bill_dt is '来单日期';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.chargeback_flg is '退单标志';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.trast_org_id is '办理机构编号';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.inv_id is '发票号码';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.cfm_curr_cd is '确认币种代码';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.cfm_amt is '确认金额';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.doc_cont_id is '单据合同编号';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.clear_way_cd is '清算方式代码';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.send_bill_claim_money_id is '寄单索款编号';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_dom_buyer_lc_doc_h.etl_timestamp is 'ETL处理时间戳';
