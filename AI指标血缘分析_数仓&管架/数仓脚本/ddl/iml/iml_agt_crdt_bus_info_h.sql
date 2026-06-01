/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_crdt_bus_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_crdt_bus_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_crdt_bus_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_crdt_bus_info_h(
    agt_id varchar2(250) -- 协议编号
    ,bus_id varchar2(100) -- 业务编号
    ,prod_id varchar2(100) -- 产品编号
    ,curr_crdt_stage_cd varchar2(30) -- 当前授信阶段代码
    ,init_src_sys_cd varchar2(30) -- 最初来源系统代码
    ,init_src_bus_id varchar2(100) -- 最初来源业务编号
    ,happ_way_cd varchar2(30) -- 发生方式代码
    ,cust_id varchar2(100) -- 客户编号
    ,curr_cd varchar2(30) -- 币种代码
    ,open_amt number(30,2) -- 敞口金额
    ,nmal_amt number(30,2) -- 名义金额
    ,exec_nmal_amt number(30,2) -- 执行名义金额
    ,exec_open_amt number(30,2) -- 执行敞口金额
    ,aval_nmal_amt number(30,2) -- 可用名义金额
    ,aval_open_amt number(30,2) -- 可用敞口金额
    ,crdt_nmal_bal number(30,2) -- 授信名义余额
    ,crdt_open_bal number(30,2) -- 授信敞口余额
    ,exec_dr_open_amt number(30,2) -- 执行可缓释敞口金额
    ,dr_open_curr_cd varchar2(30) -- 可缓释敞口币种代码
    ,dr_open_amt number(30,2) -- 可缓释敞口金额
    ,guar_way_cd varchar2(30) -- 担保方式代码
    ,circl_flg varchar2(10) -- 可循环标志
    ,amt_convt_coef number(30,8) -- 金额折算系数
    ,effect_dt date -- 生效日期
    ,exp_dt date -- 到期日期
    ,ocup_idf_cd varchar2(30) -- 占用标识代码
    ,status_cd varchar2(30) -- 状态代码
    ,day_tenor number(10) -- 日期限
    ,mon_tenor number(10) -- 月期限
    ,acm_distr_amt number(30,2) -- 累计放款金额
    ,acm_repay_amt number(30,2) -- 累计还款金额
    ,actl_invalid_dt date -- 实际失效日期
    ,oper_teller_id varchar2(100) -- 业务经办人编号
    ,oper_org_id varchar2(100) -- 经办机构编号
    ,mgmt_teller_id varchar2(100) -- 管理柜员编号
    ,mgmt_org_id varchar2(100) -- 管理机构编号
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,modif_dt date -- 变更日期
    ,margin_amt number(30,2) -- 保证金金额
    ,pm_rat number(30,8) -- 抵质押率
    ,float_int_rat number(18,8) -- 浮动利率
    ,bal_update_tm timestamp -- 余额更新时间
    ,actl_ocup_pre_ocup_nmal_amt number(30,2) -- 实际占用预占名义金额
    ,actl_ocup_pre_ocup_open_amt number(30,2) -- 实际占用预占敞口金额
    ,pre_ocup_id varchar2(100) -- 预占编号
    ,low_risk_bus_flg varchar2(10) -- 低风险业务标志
    ,pmo_amt number(30,8) -- 抵质押物金额
    ,bus_cont_type_cd varchar2(30) -- 业务合同类型代码
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
grant select on ${iml_schema}.agt_crdt_bus_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_crdt_bus_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_crdt_bus_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_crdt_bus_info_h is '授信业务信息历史';
comment on column ${iml_schema}.agt_crdt_bus_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_crdt_bus_info_h.bus_id is '业务编号';
comment on column ${iml_schema}.agt_crdt_bus_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_crdt_bus_info_h.curr_crdt_stage_cd is '当前授信阶段代码';
comment on column ${iml_schema}.agt_crdt_bus_info_h.init_src_sys_cd is '最初来源系统代码';
comment on column ${iml_schema}.agt_crdt_bus_info_h.init_src_bus_id is '最初来源业务编号';
comment on column ${iml_schema}.agt_crdt_bus_info_h.happ_way_cd is '发生方式代码';
comment on column ${iml_schema}.agt_crdt_bus_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_crdt_bus_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_crdt_bus_info_h.open_amt is '敞口金额';
comment on column ${iml_schema}.agt_crdt_bus_info_h.nmal_amt is '名义金额';
comment on column ${iml_schema}.agt_crdt_bus_info_h.exec_nmal_amt is '执行名义金额';
comment on column ${iml_schema}.agt_crdt_bus_info_h.exec_open_amt is '执行敞口金额';
comment on column ${iml_schema}.agt_crdt_bus_info_h.aval_nmal_amt is '可用名义金额';
comment on column ${iml_schema}.agt_crdt_bus_info_h.aval_open_amt is '可用敞口金额';
comment on column ${iml_schema}.agt_crdt_bus_info_h.crdt_nmal_bal is '授信名义余额';
comment on column ${iml_schema}.agt_crdt_bus_info_h.crdt_open_bal is '授信敞口余额';
comment on column ${iml_schema}.agt_crdt_bus_info_h.exec_dr_open_amt is '执行可缓释敞口金额';
comment on column ${iml_schema}.agt_crdt_bus_info_h.dr_open_curr_cd is '可缓释敞口币种代码';
comment on column ${iml_schema}.agt_crdt_bus_info_h.dr_open_amt is '可缓释敞口金额';
comment on column ${iml_schema}.agt_crdt_bus_info_h.guar_way_cd is '担保方式代码';
comment on column ${iml_schema}.agt_crdt_bus_info_h.circl_flg is '可循环标志';
comment on column ${iml_schema}.agt_crdt_bus_info_h.amt_convt_coef is '金额折算系数';
comment on column ${iml_schema}.agt_crdt_bus_info_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_crdt_bus_info_h.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_crdt_bus_info_h.ocup_idf_cd is '占用标识代码';
comment on column ${iml_schema}.agt_crdt_bus_info_h.status_cd is '状态代码';
comment on column ${iml_schema}.agt_crdt_bus_info_h.day_tenor is '日期限';
comment on column ${iml_schema}.agt_crdt_bus_info_h.mon_tenor is '月期限';
comment on column ${iml_schema}.agt_crdt_bus_info_h.acm_distr_amt is '累计放款金额';
comment on column ${iml_schema}.agt_crdt_bus_info_h.acm_repay_amt is '累计还款金额';
comment on column ${iml_schema}.agt_crdt_bus_info_h.actl_invalid_dt is '实际失效日期';
comment on column ${iml_schema}.agt_crdt_bus_info_h.oper_teller_id is '业务经办人编号';
comment on column ${iml_schema}.agt_crdt_bus_info_h.oper_org_id is '经办机构编号';
comment on column ${iml_schema}.agt_crdt_bus_info_h.mgmt_teller_id is '管理柜员编号';
comment on column ${iml_schema}.agt_crdt_bus_info_h.mgmt_org_id is '管理机构编号';
comment on column ${iml_schema}.agt_crdt_bus_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_crdt_bus_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_crdt_bus_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_crdt_bus_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_crdt_bus_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_crdt_bus_info_h.modif_dt is '变更日期';
comment on column ${iml_schema}.agt_crdt_bus_info_h.margin_amt is '保证金金额';
comment on column ${iml_schema}.agt_crdt_bus_info_h.pm_rat is '抵质押率';
comment on column ${iml_schema}.agt_crdt_bus_info_h.float_int_rat is '浮动利率';
comment on column ${iml_schema}.agt_crdt_bus_info_h.bal_update_tm is '余额更新时间';
comment on column ${iml_schema}.agt_crdt_bus_info_h.actl_ocup_pre_ocup_nmal_amt is '实际占用预占名义金额';
comment on column ${iml_schema}.agt_crdt_bus_info_h.actl_ocup_pre_ocup_open_amt is '实际占用预占敞口金额';
comment on column ${iml_schema}.agt_crdt_bus_info_h.pre_ocup_id is '预占编号';
comment on column ${iml_schema}.agt_crdt_bus_info_h.low_risk_bus_flg is '低风险业务标志';
comment on column ${iml_schema}.agt_crdt_bus_info_h.pmo_amt is '抵质押物金额';
comment on column ${iml_schema}.agt_crdt_bus_info_h.bus_cont_type_cd is '业务合同类型代码';
comment on column ${iml_schema}.agt_crdt_bus_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_crdt_bus_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_crdt_bus_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_crdt_bus_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_crdt_bus_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_crdt_bus_info_h.etl_timestamp is 'ETL处理时间戳';
