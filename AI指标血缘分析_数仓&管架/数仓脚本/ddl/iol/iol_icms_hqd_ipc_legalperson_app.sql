/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_hqd_ipc_legalperson_app
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_hqd_ipc_legalperson_app
whenever sqlerror continue none;
drop table ${iol_schema}.icms_hqd_ipc_legalperson_app purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_hqd_ipc_legalperson_app(
    serialno varchar2(32) -- 流水号
    ,applyno varchar2(64) -- 业务申请流水号
    ,baserialno varchar2(64) -- 授信申请流水号
    ,approvestatus varchar2(60) -- 审批状态
    ,occurtype varchar2(10) -- 发生类型
    ,productid varchar2(64) -- 产品编号
    ,productname varchar2(120) -- 产品名称
    ,channel varchar2(20) -- 渠道
    ,customerid varchar2(32) -- 客户编号
    ,customername varchar2(200) -- 客户名称
    ,currency varchar2(20) -- 币种
    ,businesssum number(24,6) -- 贷款金额
    ,exposureamount number(24,6) -- 敞口金额
    ,loanusetype varchar2(10) -- 贷款用途
    ,termmonth number(38) -- 期限(月)
    ,iscycle varchar2(2) -- 是否循环
    ,vouchtype varchar2(32) -- 主担保方式
    ,vouchtypeinner varchar2(32) -- 担保方式（内部口径）
    ,evaluateresult varchar2(80) -- 评估结果
    ,evaluatedate date -- 评级认定日期
    ,evaluatematurity date -- 评级到期日期
    ,oldcreditno varchar2(32) -- 原申请流水号
    ,oldedcontractno varchar2(32) -- 原额度合同流水号
    ,oldduebillno varchar2(32) -- 原借据流水号
    ,compcreditimage varchar2(4000) -- 公司客户征信影像
    ,legalcreditimage varchar2(4000) -- 公司法人征信影像
    ,guarcreditimage varchar2(4000) -- 保证人征信影像
    ,remark varchar2(4000) -- 备注
    ,operateuserid varchar2(32) -- 经办人
    ,operateorgid varchar2(32) -- 经办机构
    ,operatedate date -- 经办日期
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(32) -- 更新人
    ,updateorgid varchar2(32) -- 更新机构
    ,updatedate date -- 更新日期
    ,repaytypes varchar2(100) -- 还款方式列表
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_hqd_ipc_legalperson_app to ${iml_schema};
grant select on ${iol_schema}.icms_hqd_ipc_legalperson_app to ${icl_schema};
grant select on ${iol_schema}.icms_hqd_ipc_legalperson_app to ${idl_schema};
grant select on ${iol_schema}.icms_hqd_ipc_legalperson_app to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_hqd_ipc_legalperson_app is '好企贷IPC法人版终审';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.serialno is '流水号';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.applyno is '业务申请流水号';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.baserialno is '授信申请流水号';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.occurtype is '发生类型';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.productid is '产品编号';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.productname is '产品名称';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.channel is '渠道';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.customerid is '客户编号';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.customername is '客户名称';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.currency is '币种';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.businesssum is '贷款金额';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.exposureamount is '敞口金额';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.loanusetype is '贷款用途';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.termmonth is '期限(月)';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.iscycle is '是否循环';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.vouchtype is '主担保方式';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.vouchtypeinner is '担保方式（内部口径）';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.evaluateresult is '评估结果';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.evaluatedate is '评级认定日期';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.evaluatematurity is '评级到期日期';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.oldcreditno is '原申请流水号';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.oldedcontractno is '原额度合同流水号';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.oldduebillno is '原借据流水号';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.compcreditimage is '公司客户征信影像';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.legalcreditimage is '公司法人征信影像';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.guarcreditimage is '保证人征信影像';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.remark is '备注';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.operateuserid is '经办人';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.operateorgid is '经办机构';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.operatedate is '经办日期';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.inputuserid is '登记人';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.inputdate is '登记日期';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.updateuserid is '更新人';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.updatedate is '更新日期';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.repaytypes is '还款方式列表';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_hqd_ipc_legalperson_app.etl_timestamp is 'ETL处理时间戳';
