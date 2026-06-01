/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_white_info_edit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_white_info_edit
whenever sqlerror continue none;
drop table ${iol_schema}.icms_white_info_edit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_white_info_edit(
    serialno varchar2(40) -- 白名单修改编号
    ,issinosureaccount varchar2(40) -- 是否信保客户
    ,singleputsum number(24,6) -- 单笔自动化出账金额上限
    ,teamputsum number(24,6) -- 团队长审批金额上限
    ,firstpayratio number(24,6) -- 首付款比例%
    ,serialnowf varchar2(40) -- 白名单编号
    ,orgshort varchar2(20) -- 机构中文简称
    ,isfirstpay varchar2(2) -- 是否首付款1是2否
    ,inputuserid varchar2(20) -- 登记员工编号
    ,editstatus varchar2(3) -- 修改状态
    ,totolsum number(24,6) -- 额度上限
    ,attribute2 varchar2(80) -- 保证金账户名称
    ,attribute4 varchar2(40) -- 
    ,isbelongterm varchar2(2) -- 是否靠档计息
    ,customername varchar2(200) -- 客户名称
    ,sinosureaccount varchar2(40) -- 受托支付账户账户
    ,maturity varchar2(10) -- 有效到期日
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,customerid varchar2(40) -- 客户号
    ,bypassaccount varchar2(40) -- 保证金子户
    ,adristtype varchar2(2) -- 结息方式
    ,iscitecon varchar2(2) -- 流贷合同
    ,repaytype varchar2(2) -- 还款方式
    ,attribute1 varchar2(40) -- 渠道
    ,riskcapitalassesstype varchar2(10) -- 风险资本考核方式,码值:RiskCapitalAssessType,M:按月,S:按季
    ,attribute3 varchar2(40) -- 
    ,inputdate date -- 登记时间
    ,fixedrate number(15,8) -- 固定利率
    ,inputorgid varchar2(32) -- 登记机构编号
    ,sinosurebillaccount varchar2(40) -- 信保保证金账户
    ,sinosurename varchar2(80) -- 受托支付账户名称
    ,maxloanterm number(22) -- 单笔最长贷款期限
    ,status varchar2(3) -- 状态
    ,interestrepaycycle varchar2(10) -- 结息频率-ICCycN
    ,relativeno varchar2(40) -- 关联名单流水号
    ,tasktype varchar2(32) -- 任务类型
    ,updatedate date -- 更新时间
    ,updateorgid varchar2(32) -- 更新机构编号
    ,updateuserid varchar2(20) -- 更新用户编号
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
grant select on ${iol_schema}.icms_white_info_edit to ${iml_schema};
grant select on ${iol_schema}.icms_white_info_edit to ${icl_schema};
grant select on ${iol_schema}.icms_white_info_edit to ${idl_schema};
grant select on ${iol_schema}.icms_white_info_edit to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_white_info_edit is '流程中的sxd白名单';
comment on column ${iol_schema}.icms_white_info_edit.serialno is '白名单修改编号';
comment on column ${iol_schema}.icms_white_info_edit.issinosureaccount is '是否信保客户';
comment on column ${iol_schema}.icms_white_info_edit.singleputsum is '单笔自动化出账金额上限';
comment on column ${iol_schema}.icms_white_info_edit.teamputsum is '团队长审批金额上限';
comment on column ${iol_schema}.icms_white_info_edit.firstpayratio is '首付款比例%';
comment on column ${iol_schema}.icms_white_info_edit.serialnowf is '白名单编号';
comment on column ${iol_schema}.icms_white_info_edit.orgshort is '机构中文简称';
comment on column ${iol_schema}.icms_white_info_edit.isfirstpay is '是否首付款1是2否';
comment on column ${iol_schema}.icms_white_info_edit.inputuserid is '登记员工编号';
comment on column ${iol_schema}.icms_white_info_edit.editstatus is '修改状态';
comment on column ${iol_schema}.icms_white_info_edit.totolsum is '额度上限';
comment on column ${iol_schema}.icms_white_info_edit.attribute2 is '保证金账户名称';
comment on column ${iol_schema}.icms_white_info_edit.attribute4 is '';
comment on column ${iol_schema}.icms_white_info_edit.isbelongterm is '是否靠档计息';
comment on column ${iol_schema}.icms_white_info_edit.customername is '客户名称';
comment on column ${iol_schema}.icms_white_info_edit.sinosureaccount is '受托支付账户账户';
comment on column ${iol_schema}.icms_white_info_edit.maturity is '有效到期日';
comment on column ${iol_schema}.icms_white_info_edit.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_white_info_edit.customerid is '客户号';
comment on column ${iol_schema}.icms_white_info_edit.bypassaccount is '保证金子户';
comment on column ${iol_schema}.icms_white_info_edit.adristtype is '结息方式';
comment on column ${iol_schema}.icms_white_info_edit.iscitecon is '流贷合同';
comment on column ${iol_schema}.icms_white_info_edit.repaytype is '还款方式';
comment on column ${iol_schema}.icms_white_info_edit.attribute1 is '渠道';
comment on column ${iol_schema}.icms_white_info_edit.riskcapitalassesstype is '风险资本考核方式,码值:RiskCapitalAssessType,M:按月,S:按季';
comment on column ${iol_schema}.icms_white_info_edit.attribute3 is '';
comment on column ${iol_schema}.icms_white_info_edit.inputdate is '登记时间';
comment on column ${iol_schema}.icms_white_info_edit.fixedrate is '固定利率';
comment on column ${iol_schema}.icms_white_info_edit.inputorgid is '登记机构编号';
comment on column ${iol_schema}.icms_white_info_edit.sinosurebillaccount is '信保保证金账户';
comment on column ${iol_schema}.icms_white_info_edit.sinosurename is '受托支付账户名称';
comment on column ${iol_schema}.icms_white_info_edit.maxloanterm is '单笔最长贷款期限';
comment on column ${iol_schema}.icms_white_info_edit.status is '状态';
comment on column ${iol_schema}.icms_white_info_edit.interestrepaycycle is '结息频率-ICCycN';
comment on column ${iol_schema}.icms_white_info_edit.relativeno is '关联名单流水号';
comment on column ${iol_schema}.icms_white_info_edit.tasktype is '任务类型';
comment on column ${iol_schema}.icms_white_info_edit.updatedate is '更新时间';
comment on column ${iol_schema}.icms_white_info_edit.updateorgid is '更新机构编号';
comment on column ${iol_schema}.icms_white_info_edit.updateuserid is '更新用户编号';
comment on column ${iol_schema}.icms_white_info_edit.start_dt is '开始时间';
comment on column ${iol_schema}.icms_white_info_edit.end_dt is '结束时间';
comment on column ${iol_schema}.icms_white_info_edit.id_mark is '增删标志';
comment on column ${iol_schema}.icms_white_info_edit.etl_timestamp is 'ETL处理时间戳';
