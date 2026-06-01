/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_dom_buyer_lc_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_dom_buyer_lc_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_dom_buyer_lc_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dom_buyer_lc_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,intnal_lc_id varchar2(100) -- 内部信用证编号
    ,lc_id varchar2(100) -- 信用证编号
    ,tran_descb varchar2(375) -- 交易描述
    ,bus_teller_id varchar2(100) -- 业务柜员编号
    ,sys_rgst_dt date -- 系统登记日期
    ,issue_dt date -- 开证日期
    ,close_dt date -- 闭卷日期
    ,close_type_cd varchar2(30) -- 闭卷类型代码
    ,advise_bank_name varchar2(375) -- 通知行名称
    ,final_modif_dt date -- 最后修改日期
    ,modif_cnt number(10) -- 修改次数
    ,applit_name varchar2(375) -- 申请人名称
    ,applit_ref_id varchar2(100) -- 申请人参考编号
    ,pay_way_cd varchar2(30) -- 付款方式代码
    ,benefc_name varchar2(375) -- 受益人名称
    ,fee_src_cd varchar2(30) -- 费用来源代码
    ,cfm_way_cd varchar2(30) -- 保兑方式代码
    ,exp_dt date -- 到期日期
    ,present_site varchar2(375) -- 交单地点
    ,lc_type_cd varchar2(30) -- 信用证类型代码
    ,m_l_way_cd varchar2(30) -- 溢短装方式代码
    ,m_l_cu_ratio number(10) -- 溢短装上浮比例
    ,m_l_lower_ratio number(10) -- 溢短装下浮比例
    ,shipment_dt date -- 装船日期
    ,shipment_site varchar2(375) -- 装船地点
    ,acpt_cnt number(10) -- 承兑次数
    ,vp number(10) -- 有效期
    ,belong_org_id varchar2(100) -- 所属机构编号
    ,trast_org_id varchar2(100) -- 办理机构编号
    ,issue_way_cd varchar2(30) -- 开证方式代码
    ,dubil_id varchar2(100) -- 借据编号
    ,inpwn_type_cd varchar2(30) -- 质押类型代码
    ,traff_way_cd varchar2(30) -- 运输方式代码
    ,lc_bal number(18,3) -- 信用证余额
    ,open_way_cd varchar2(30) -- 开立方式代码
    ,trade_type_cd varchar2(30) -- 贸易类型代码
    ,cfm_flg varchar2(10) -- 保兑标志
    ,pur_sale_cont_id varchar2(250) -- 购销合同编号
    ,nego_pay_flg_cd varchar2(30) -- 议付标志代码
    ,cont_curr_cd varchar2(30) -- 合同币种代码
    ,cont_amt number(18,3) -- 合同金额
    ,prod_name varchar2(4000) -- 货品名称
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
grant select on ${iml_schema}.agt_dom_buyer_lc_h to ${icl_schema};
grant select on ${iml_schema}.agt_dom_buyer_lc_h to ${idl_schema};
grant select on ${iml_schema}.agt_dom_buyer_lc_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_dom_buyer_lc_h is '国内买方信用证历史';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.intnal_lc_id is '内部信用证编号';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.lc_id is '信用证编号';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.tran_descb is '交易描述';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.bus_teller_id is '业务柜员编号';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.sys_rgst_dt is '系统登记日期';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.issue_dt is '开证日期';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.close_dt is '闭卷日期';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.close_type_cd is '闭卷类型代码';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.advise_bank_name is '通知行名称';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.modif_cnt is '修改次数';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.applit_name is '申请人名称';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.applit_ref_id is '申请人参考编号';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.pay_way_cd is '付款方式代码';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.benefc_name is '受益人名称';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.fee_src_cd is '费用来源代码';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.cfm_way_cd is '保兑方式代码';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.present_site is '交单地点';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.lc_type_cd is '信用证类型代码';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.m_l_way_cd is '溢短装方式代码';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.m_l_cu_ratio is '溢短装上浮比例';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.m_l_lower_ratio is '溢短装下浮比例';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.shipment_dt is '装船日期';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.shipment_site is '装船地点';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.acpt_cnt is '承兑次数';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.vp is '有效期';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.trast_org_id is '办理机构编号';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.issue_way_cd is '开证方式代码';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.inpwn_type_cd is '质押类型代码';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.traff_way_cd is '运输方式代码';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.lc_bal is '信用证余额';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.open_way_cd is '开立方式代码';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.trade_type_cd is '贸易类型代码';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.cfm_flg is '保兑标志';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.pur_sale_cont_id is '购销合同编号';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.nego_pay_flg_cd is '议付标志代码';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.cont_curr_cd is '合同币种代码';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.cont_amt is '合同金额';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.prod_name is '货品名称';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_dom_buyer_lc_h.etl_timestamp is 'ETL处理时间戳';
