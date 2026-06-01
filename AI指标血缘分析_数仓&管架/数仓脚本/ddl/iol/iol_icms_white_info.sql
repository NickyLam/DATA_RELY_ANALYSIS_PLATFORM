/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_white_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_white_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_white_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_white_info(
    serialno varchar2(40) -- 白名单编号
    ,orgshort varchar2(20) -- 机构中文简称
    ,status varchar2(3) -- 状态
    ,isbelongterm varchar2(2) -- 是否靠档计息
    ,totolsum number(24,6) -- 额度上限
    ,riskcapitalassesstype varchar2(10) -- 风险资本考核方式,码值:RiskCapitalAssessType,M:按月,S:按季
    ,customername varchar2(200) -- 客户名称
    ,attribute2 varchar2(80) -- 保证金账户名称
    ,issinosureaccount varchar2(40) -- 是否信保客户
    ,updateorgid varchar2(16) -- 更新机构
    ,fixedrate number(15,8) -- 固定利率
    ,attribute4 varchar2(40) -- 备用信息4
    ,sinosurename varchar2(80) -- 受托支付账户名称
    ,updatedate date -- 更新时间
    ,inputdate date -- 登记时间
    ,sinosureaccount varchar2(40) -- 受托支付账户
    ,migtflag varchar2(80) -- 
    ,maxloanterm number(22) -- 单笔最长贷款期限
    ,repaytype varchar2(2) -- 还款方式
    ,firstpayratio number(24,6) -- 首付款比例%
    ,isfirstpay varchar2(2) -- 是否首付款1是2否
    ,adristtype varchar2(2) -- 结息方式
    ,customerid varchar2(40) -- 客户号
    ,maturity date -- 有效到期日
    ,bypassaccount varchar2(40) -- 子户
    ,singleputsum number(24,6) -- 单笔自动化出账金额上限
    ,iscitecon varchar2(2) -- 流贷合同
    ,attribute1 varchar2(40) -- 渠道
    ,attribute3 varchar2(40) -- 备用信息3
    ,inputuserid varchar2(20) -- 登记员工编号
    ,updateuserid varchar2(8) -- 更新用户
    ,teamputsum number(24,6) -- 团队长审批金额上限
    ,inputorgid varchar2(32) -- 登记机构编号
    ,sinosurebillaccount varchar2(40) -- 保证金账户
    ,taskstatus varchar2(32) -- 任务状态
    ,interestrepaycycle varchar2(10) -- 结息频率-ICCycN
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
grant select on ${iol_schema}.icms_white_info to ${iml_schema};
grant select on ${iol_schema}.icms_white_info to ${icl_schema};
grant select on ${iol_schema}.icms_white_info to ${idl_schema};
grant select on ${iol_schema}.icms_white_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_white_info is '线上业务白名单信息';
comment on column ${iol_schema}.icms_white_info.serialno is '白名单编号';
comment on column ${iol_schema}.icms_white_info.orgshort is '机构中文简称';
comment on column ${iol_schema}.icms_white_info.status is '状态';
comment on column ${iol_schema}.icms_white_info.isbelongterm is '是否靠档计息';
comment on column ${iol_schema}.icms_white_info.totolsum is '额度上限';
comment on column ${iol_schema}.icms_white_info.riskcapitalassesstype is '风险资本考核方式,码值:RiskCapitalAssessType,M:按月,S:按季';
comment on column ${iol_schema}.icms_white_info.customername is '客户名称';
comment on column ${iol_schema}.icms_white_info.attribute2 is '保证金账户名称';
comment on column ${iol_schema}.icms_white_info.issinosureaccount is '是否信保客户';
comment on column ${iol_schema}.icms_white_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_white_info.fixedrate is '固定利率';
comment on column ${iol_schema}.icms_white_info.attribute4 is '备用信息4';
comment on column ${iol_schema}.icms_white_info.sinosurename is '受托支付账户名称';
comment on column ${iol_schema}.icms_white_info.updatedate is '更新时间';
comment on column ${iol_schema}.icms_white_info.inputdate is '登记时间';
comment on column ${iol_schema}.icms_white_info.sinosureaccount is '受托支付账户';
comment on column ${iol_schema}.icms_white_info.migtflag is '';
comment on column ${iol_schema}.icms_white_info.maxloanterm is '单笔最长贷款期限';
comment on column ${iol_schema}.icms_white_info.repaytype is '还款方式';
comment on column ${iol_schema}.icms_white_info.firstpayratio is '首付款比例%';
comment on column ${iol_schema}.icms_white_info.isfirstpay is '是否首付款1是2否';
comment on column ${iol_schema}.icms_white_info.adristtype is '结息方式';
comment on column ${iol_schema}.icms_white_info.customerid is '客户号';
comment on column ${iol_schema}.icms_white_info.maturity is '有效到期日';
comment on column ${iol_schema}.icms_white_info.bypassaccount is '子户';
comment on column ${iol_schema}.icms_white_info.singleputsum is '单笔自动化出账金额上限';
comment on column ${iol_schema}.icms_white_info.iscitecon is '流贷合同';
comment on column ${iol_schema}.icms_white_info.attribute1 is '渠道';
comment on column ${iol_schema}.icms_white_info.attribute3 is '备用信息3';
comment on column ${iol_schema}.icms_white_info.inputuserid is '登记员工编号';
comment on column ${iol_schema}.icms_white_info.updateuserid is '更新用户';
comment on column ${iol_schema}.icms_white_info.teamputsum is '团队长审批金额上限';
comment on column ${iol_schema}.icms_white_info.inputorgid is '登记机构编号';
comment on column ${iol_schema}.icms_white_info.sinosurebillaccount is '保证金账户';
comment on column ${iol_schema}.icms_white_info.taskstatus is '任务状态';
comment on column ${iol_schema}.icms_white_info.interestrepaycycle is '结息频率-ICCycN';
comment on column ${iol_schema}.icms_white_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_white_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_white_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_white_info.etl_timestamp is 'ETL处理时间戳';
