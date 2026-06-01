/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_risk_cls_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_risk_cls_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_risk_cls_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_risk_cls_h(
    risk_cls_id varchar2(100) -- 风险分类编号
    ,rela_flow_num varchar2(100) -- 关联流水号
    ,agt_id varchar2(250) -- 协议编号
    ,obj_id varchar2(100) -- 对象编号
    ,obj_type_name varchar2(500) -- 对象类型名称
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,loan_amt number(30,2) -- 贷款金额
    ,loan_bal number(30,2) -- 贷款余额
    ,loan_tenor_cd varchar2(30) -- 贷款期限代码
    ,cls_closing_dt date -- 分类截止日期
    ,sys_cls_rest_cd varchar2(30) -- 系统分类结果代码
    ,manu_cls_rest_cd varchar2(30) -- 人工分类结果代码
    ,manu_cls_reason_descb varchar2(1000) -- 人工分类理由描述
    ,final_rest_cd varchar2(30) -- 最终结果代码
    ,cls_way_cd varchar2(30) -- 分类方式代码
    ,belong_strip_line_cd varchar2(30) -- 所属条线代码
    ,cls_status_cd varchar2(30) -- 分类状态代码
    ,low_risk_flg varchar2(10) -- 低风险标志
    ,curr_mon_happ_flg varchar2(10) -- 当月发生标志
    ,remark varchar2(4000) -- 备注
    ,oper_teller_id varchar2(100) -- 业务经办人编号
    ,oper_org_id varchar2(100) -- 经办机构编号
    ,oper_dt date -- 经办日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,modif_dt date -- 变更日期
    ,cmplt_dt date -- 完成日期
    ,lp_id varchar2(100) -- 法人编号
    ,idtfy_lev_cd varchar2(30) -- 认定级别代码
    ,last_cls_rest_cd varchar2(30) -- 上次分类结果代码
    ,fst_cls_rest_cd varchar2(30) -- 第一次分类结果代码
    ,secd_cls_rest_cd varchar2(30) -- 第二次分类结果代码
    ,cont_id varchar2(100) -- 合同编号
    ,old_crdt_flow_num varchar2(100) -- 旧信贷流水号
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
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
grant select on ${iml_schema}.agt_loan_risk_cls_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_risk_cls_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_risk_cls_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_risk_cls_h is '贷款风险分类历史';
comment on column ${iml_schema}.agt_loan_risk_cls_h.risk_cls_id is '风险分类编号';
comment on column ${iml_schema}.agt_loan_risk_cls_h.rela_flow_num is '关联流水号';
comment on column ${iml_schema}.agt_loan_risk_cls_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_risk_cls_h.obj_id is '对象编号';
comment on column ${iml_schema}.agt_loan_risk_cls_h.obj_type_name is '对象类型名称';
comment on column ${iml_schema}.agt_loan_risk_cls_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_loan_risk_cls_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_loan_risk_cls_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_loan_risk_cls_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_loan_risk_cls_h.loan_amt is '贷款金额';
comment on column ${iml_schema}.agt_loan_risk_cls_h.loan_bal is '贷款余额';
comment on column ${iml_schema}.agt_loan_risk_cls_h.loan_tenor_cd is '贷款期限代码';
comment on column ${iml_schema}.agt_loan_risk_cls_h.cls_closing_dt is '分类截止日期';
comment on column ${iml_schema}.agt_loan_risk_cls_h.sys_cls_rest_cd is '系统分类结果代码';
comment on column ${iml_schema}.agt_loan_risk_cls_h.manu_cls_rest_cd is '人工分类结果代码';
comment on column ${iml_schema}.agt_loan_risk_cls_h.manu_cls_reason_descb is '人工分类理由描述';
comment on column ${iml_schema}.agt_loan_risk_cls_h.final_rest_cd is '最终结果代码';
comment on column ${iml_schema}.agt_loan_risk_cls_h.cls_way_cd is '分类方式代码';
comment on column ${iml_schema}.agt_loan_risk_cls_h.belong_strip_line_cd is '所属条线代码';
comment on column ${iml_schema}.agt_loan_risk_cls_h.cls_status_cd is '分类状态代码';
comment on column ${iml_schema}.agt_loan_risk_cls_h.low_risk_flg is '低风险标志';
comment on column ${iml_schema}.agt_loan_risk_cls_h.curr_mon_happ_flg is '当月发生标志';
comment on column ${iml_schema}.agt_loan_risk_cls_h.remark is '备注';
comment on column ${iml_schema}.agt_loan_risk_cls_h.oper_teller_id is '业务经办人编号';
comment on column ${iml_schema}.agt_loan_risk_cls_h.oper_org_id is '经办机构编号';
comment on column ${iml_schema}.agt_loan_risk_cls_h.oper_dt is '经办日期';
comment on column ${iml_schema}.agt_loan_risk_cls_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_loan_risk_cls_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_loan_risk_cls_h.modif_dt is '变更日期';
comment on column ${iml_schema}.agt_loan_risk_cls_h.cmplt_dt is '完成日期';
comment on column ${iml_schema}.agt_loan_risk_cls_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_risk_cls_h.idtfy_lev_cd is '认定级别代码';
comment on column ${iml_schema}.agt_loan_risk_cls_h.last_cls_rest_cd is '上次分类结果代码';
comment on column ${iml_schema}.agt_loan_risk_cls_h.fst_cls_rest_cd is '第一次分类结果代码';
comment on column ${iml_schema}.agt_loan_risk_cls_h.secd_cls_rest_cd is '第二次分类结果代码';
comment on column ${iml_schema}.agt_loan_risk_cls_h.cont_id is '合同编号';
comment on column ${iml_schema}.agt_loan_risk_cls_h.old_crdt_flow_num is '旧信贷流水号';
comment on column ${iml_schema}.agt_loan_risk_cls_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_loan_risk_cls_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_loan_risk_cls_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_loan_risk_cls_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_risk_cls_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_risk_cls_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_risk_cls_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_risk_cls_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_risk_cls_h.etl_timestamp is 'ETL处理时间戳';
