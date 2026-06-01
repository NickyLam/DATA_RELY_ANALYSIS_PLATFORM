/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_white_info_history
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_white_info_history
whenever sqlerror continue none;
drop table ${iol_schema}.icms_white_info_history purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_white_info_history(
    serialno varchar2(40) -- 流水号
    ,sinosurebillaccount varchar2(40) -- 信保保证金账户
    ,sinosurename varchar2(80) -- 受托支付账户名称
    ,whiteno varchar2(40) -- 白名单流水号
    ,inputorgid varchar2(32) -- 登记机构编号
    ,teamputsum number(24,6) -- 团队长审批金额上限
    ,migtflag varchar2(80) -- 
    ,attribute2 varchar2(80) -- 保证金账户名称
    ,issinosureaccount varchar2(40) -- 是否信保客户
    ,firstpayratio number(24,6) -- 首付款比例%
    ,customerid varchar2(40) -- 客户号
    ,inputuserid varchar2(20) -- 登记员工编号
    ,attribute1 varchar2(40) -- 渠道
    ,riskcapitalassesstype varchar2(10) -- 风险资本考核方式,码值:RiskCapitalAssessType,M:按月,S:按季
    ,repaytype varchar2(2) -- 还款方式
    ,maturity varchar2(10) -- 有效到期日
    ,bypassaccount varchar2(40) -- 保证金子户
    ,totolsum number(24,6) -- 额度上限
    ,attribute3 varchar2(40) -- 属性3
    ,attribute4 varchar2(40) -- 属性4
    ,singleputsum number(24,6) -- 单笔自动化出账金额上限
    ,isfirstpay varchar2(2) -- 是否首付款1是2否
    ,inputdate varchar2(10) -- 登记时间
    ,updatedate varchar2(20) -- 修改时间（即入历史数据表时间）
    ,fixedrate number(10,6) -- 固定利率
    ,adristtype varchar2(2) -- 结息方式
    ,customername varchar2(200) -- 客户名称
    ,sinosureaccount varchar2(40) -- 受托支付账户账户
    ,isbelongterm varchar2(2) -- 是否靠档计息
    ,updateuserid varchar2(20) -- 修改员工编号
    ,iscitecon varchar2(2) -- 流贷合同
    ,status varchar2(3) -- 状态
    ,orgshort varchar2(20) -- 机构中文简称
    ,maxloanterm number(22) -- 单笔最长贷款期限
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_white_info_history to ${iml_schema};
grant select on ${iol_schema}.icms_white_info_history to ${icl_schema};
grant select on ${iol_schema}.icms_white_info_history to ${idl_schema};
grant select on ${iol_schema}.icms_white_info_history to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_white_info_history is '线上业务白名单变更历史记录';
comment on column ${iol_schema}.icms_white_info_history.serialno is '流水号';
comment on column ${iol_schema}.icms_white_info_history.sinosurebillaccount is '信保保证金账户';
comment on column ${iol_schema}.icms_white_info_history.sinosurename is '受托支付账户名称';
comment on column ${iol_schema}.icms_white_info_history.whiteno is '白名单流水号';
comment on column ${iol_schema}.icms_white_info_history.inputorgid is '登记机构编号';
comment on column ${iol_schema}.icms_white_info_history.teamputsum is '团队长审批金额上限';
comment on column ${iol_schema}.icms_white_info_history.migtflag is '';
comment on column ${iol_schema}.icms_white_info_history.attribute2 is '保证金账户名称';
comment on column ${iol_schema}.icms_white_info_history.issinosureaccount is '是否信保客户';
comment on column ${iol_schema}.icms_white_info_history.firstpayratio is '首付款比例%';
comment on column ${iol_schema}.icms_white_info_history.customerid is '客户号';
comment on column ${iol_schema}.icms_white_info_history.inputuserid is '登记员工编号';
comment on column ${iol_schema}.icms_white_info_history.attribute1 is '渠道';
comment on column ${iol_schema}.icms_white_info_history.riskcapitalassesstype is '风险资本考核方式,码值:RiskCapitalAssessType,M:按月,S:按季';
comment on column ${iol_schema}.icms_white_info_history.repaytype is '还款方式';
comment on column ${iol_schema}.icms_white_info_history.maturity is '有效到期日';
comment on column ${iol_schema}.icms_white_info_history.bypassaccount is '保证金子户';
comment on column ${iol_schema}.icms_white_info_history.totolsum is '额度上限';
comment on column ${iol_schema}.icms_white_info_history.attribute3 is '属性3';
comment on column ${iol_schema}.icms_white_info_history.attribute4 is '属性4';
comment on column ${iol_schema}.icms_white_info_history.singleputsum is '单笔自动化出账金额上限';
comment on column ${iol_schema}.icms_white_info_history.isfirstpay is '是否首付款1是2否';
comment on column ${iol_schema}.icms_white_info_history.inputdate is '登记时间';
comment on column ${iol_schema}.icms_white_info_history.updatedate is '修改时间（即入历史数据表时间）';
comment on column ${iol_schema}.icms_white_info_history.fixedrate is '固定利率';
comment on column ${iol_schema}.icms_white_info_history.adristtype is '结息方式';
comment on column ${iol_schema}.icms_white_info_history.customername is '客户名称';
comment on column ${iol_schema}.icms_white_info_history.sinosureaccount is '受托支付账户账户';
comment on column ${iol_schema}.icms_white_info_history.isbelongterm is '是否靠档计息';
comment on column ${iol_schema}.icms_white_info_history.updateuserid is '修改员工编号';
comment on column ${iol_schema}.icms_white_info_history.iscitecon is '流贷合同';
comment on column ${iol_schema}.icms_white_info_history.status is '状态';
comment on column ${iol_schema}.icms_white_info_history.orgshort is '机构中文简称';
comment on column ${iol_schema}.icms_white_info_history.maxloanterm is '单笔最长贷款期限';
comment on column ${iol_schema}.icms_white_info_history.start_dt is '开始时间';
comment on column ${iol_schema}.icms_white_info_history.end_dt is '结束时间';
comment on column ${iol_schema}.icms_white_info_history.id_mark is '增删标志';
comment on column ${iol_schema}.icms_white_info_history.etl_timestamp is 'ETL处理时间戳';
