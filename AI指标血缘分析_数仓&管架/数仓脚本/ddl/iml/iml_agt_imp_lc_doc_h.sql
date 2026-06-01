/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_imp_lc_doc_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_imp_lc_doc_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_imp_lc_doc_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_imp_lc_doc_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,src_agt_id varchar2(60) -- 源协议编号
    ,bill_bus_id varchar2(60) -- 票据业务编号
    ,tran_descb varchar2(3750) -- 交易描述
    ,bus_teller_id varchar2(60) -- 业务柜员编号
    ,sys_rgst_dt date -- 系统登记日期
    ,bus_rgst_dt date -- 业务登记日期
    ,close_dt date -- 闭卷日期
    ,parent_bus_type_cd varchar2(30) -- 父类业务类型代码
    ,parent_tran_intnal_id varchar2(60) -- 父类交易内部编号
    ,send_bill_bk_send_bill_dt date -- 寄单行寄单日期
    ,latest_ship_dt date -- 最迟装运日期
    ,delay_pay_exp_dt date -- 延期付款到期日期
    ,load_bill_revid_dt date -- 提单收到日期
    ,discrp_advise_dt date -- 不符点通知日期
    ,doc_type_cd varchar2(30) -- 单据类型代码
    ,refuse_pay_flg_cd varchar2(30) -- 拒付标志代码
    ,apprv_flg varchar2(10) -- 批准标志
    ,goods_way_cd varchar2(30) -- 放货方式代码
    ,auth_goods_dt date -- 授权放货日期
    ,free_pay_present_flg varchar2(10) -- 免付款交单标志
    ,recv_advise_type_cd varchar2(30) -- 接收通知类型代码
    ,pick_goods_guar_open_dt date -- 提货担保开立日期
    ,traff_doc_type_cd varchar2(30) -- 运输单据类型代码
    ,traff_dt date -- 运输日期
    ,multi_tenor_flg varchar2(10) -- 多期限标志
    ,doc_diff_flg varchar2(10) -- 单据差异标志
    ,submit_role_type_cd varchar2(30) -- 提交角色类型代码
    ,doc_status_cd varchar2(30) -- 单据状态代码
    ,ignore_discrp_flg varchar2(10) -- 忽略不符点标志
    ,curr_cd varchar2(30) -- 币种代码
    ,pay_tot_amt number(18,3) -- 付款总金额
    ,payer_type_cd varchar2(30) -- 付款人类型代码
    ,acpt_flg varchar2(10) -- 承兑标志
    ,income_bill_dt date -- 来单日期
    ,chargeback_flg varchar2(10) -- 退单标志
    ,trast_org_id varchar2(60) -- 办理机构编号
    ,belong_org_id varchar2(60) -- 所属机构编号
    ,load_bill_num varchar2(60) -- 提单号
    ,nra_pay_flg varchar2(10) -- NRA付款标志
    ,clear_chn_cd varchar2(30) -- 清算渠道代码
    ,inv_id varchar2(100) -- 发票号码
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
grant select on ${iml_schema}.agt_imp_lc_doc_h to ${icl_schema};
grant select on ${iml_schema}.agt_imp_lc_doc_h to ${idl_schema};
grant select on ${iml_schema}.agt_imp_lc_doc_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_imp_lc_doc_h is '进口信用证单据历史';
comment on column ${iml_schema}.agt_imp_lc_doc_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_imp_lc_doc_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_imp_lc_doc_h.src_agt_id is '源协议编号';
comment on column ${iml_schema}.agt_imp_lc_doc_h.bill_bus_id is '票据业务编号';
comment on column ${iml_schema}.agt_imp_lc_doc_h.tran_descb is '交易描述';
comment on column ${iml_schema}.agt_imp_lc_doc_h.bus_teller_id is '业务柜员编号';
comment on column ${iml_schema}.agt_imp_lc_doc_h.sys_rgst_dt is '系统登记日期';
comment on column ${iml_schema}.agt_imp_lc_doc_h.bus_rgst_dt is '业务登记日期';
comment on column ${iml_schema}.agt_imp_lc_doc_h.close_dt is '闭卷日期';
comment on column ${iml_schema}.agt_imp_lc_doc_h.parent_bus_type_cd is '父类业务类型代码';
comment on column ${iml_schema}.agt_imp_lc_doc_h.parent_tran_intnal_id is '父类交易内部编号';
comment on column ${iml_schema}.agt_imp_lc_doc_h.send_bill_bk_send_bill_dt is '寄单行寄单日期';
comment on column ${iml_schema}.agt_imp_lc_doc_h.latest_ship_dt is '最迟装运日期';
comment on column ${iml_schema}.agt_imp_lc_doc_h.delay_pay_exp_dt is '延期付款到期日期';
comment on column ${iml_schema}.agt_imp_lc_doc_h.load_bill_revid_dt is '提单收到日期';
comment on column ${iml_schema}.agt_imp_lc_doc_h.discrp_advise_dt is '不符点通知日期';
comment on column ${iml_schema}.agt_imp_lc_doc_h.doc_type_cd is '单据类型代码';
comment on column ${iml_schema}.agt_imp_lc_doc_h.refuse_pay_flg_cd is '拒付标志代码';
comment on column ${iml_schema}.agt_imp_lc_doc_h.apprv_flg is '批准标志';
comment on column ${iml_schema}.agt_imp_lc_doc_h.goods_way_cd is '放货方式代码';
comment on column ${iml_schema}.agt_imp_lc_doc_h.auth_goods_dt is '授权放货日期';
comment on column ${iml_schema}.agt_imp_lc_doc_h.free_pay_present_flg is '免付款交单标志';
comment on column ${iml_schema}.agt_imp_lc_doc_h.recv_advise_type_cd is '接收通知类型代码';
comment on column ${iml_schema}.agt_imp_lc_doc_h.pick_goods_guar_open_dt is '提货担保开立日期';
comment on column ${iml_schema}.agt_imp_lc_doc_h.traff_doc_type_cd is '运输单据类型代码';
comment on column ${iml_schema}.agt_imp_lc_doc_h.traff_dt is '运输日期';
comment on column ${iml_schema}.agt_imp_lc_doc_h.multi_tenor_flg is '多期限标志';
comment on column ${iml_schema}.agt_imp_lc_doc_h.doc_diff_flg is '单据差异标志';
comment on column ${iml_schema}.agt_imp_lc_doc_h.submit_role_type_cd is '提交角色类型代码';
comment on column ${iml_schema}.agt_imp_lc_doc_h.doc_status_cd is '单据状态代码';
comment on column ${iml_schema}.agt_imp_lc_doc_h.ignore_discrp_flg is '忽略不符点标志';
comment on column ${iml_schema}.agt_imp_lc_doc_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_imp_lc_doc_h.pay_tot_amt is '付款总金额';
comment on column ${iml_schema}.agt_imp_lc_doc_h.payer_type_cd is '付款人类型代码';
comment on column ${iml_schema}.agt_imp_lc_doc_h.acpt_flg is '承兑标志';
comment on column ${iml_schema}.agt_imp_lc_doc_h.income_bill_dt is '来单日期';
comment on column ${iml_schema}.agt_imp_lc_doc_h.chargeback_flg is '退单标志';
comment on column ${iml_schema}.agt_imp_lc_doc_h.trast_org_id is '办理机构编号';
comment on column ${iml_schema}.agt_imp_lc_doc_h.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.agt_imp_lc_doc_h.load_bill_num is '提单号';
comment on column ${iml_schema}.agt_imp_lc_doc_h.nra_pay_flg is 'NRA付款标志';
comment on column ${iml_schema}.agt_imp_lc_doc_h.clear_chn_cd is '清算渠道代码';
comment on column ${iml_schema}.agt_imp_lc_doc_h.inv_id is '发票号码';
comment on column ${iml_schema}.agt_imp_lc_doc_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_imp_lc_doc_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_imp_lc_doc_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_imp_lc_doc_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_imp_lc_doc_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_imp_lc_doc_h.etl_timestamp is 'ETL处理时间戳';
