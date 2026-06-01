/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_afterloan_change
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_afterloan_change
whenever sqlerror continue none;
drop table ${iol_schema}.icms_afterloan_change purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_afterloan_change(
    serialno varchar2(32) -- 流水号
    ,applystatus varchar2(32) -- 申请状态
    ,rateunit2 varchar2(18) -- 利率单位
    ,ratefloattype2 varchar2(18) -- 利率浮动类型
    ,businessrate2 number(24,8) -- 执行利率
    ,paymentaccount varchar2(80) -- 还款账号
    ,transno varchar2(32) -- 核心交易号
    ,oldrepaydate varchar2(10) -- 原还款日
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(8) -- 更新人
    ,oldrepaytype varchar2(36) -- 原还款方式
    ,completeflag varchar2(6) -- 完成标志
    ,repayaccname varchar2(80) -- 还款账户名称
    ,belongdept varchar2(18) -- 所属条线
    ,oldrepayaccname varchar2(80) -- 原还款账户名称
    ,baserate number(15,8) -- 基准利率
    ,inputuserid varchar2(8) -- 登记人
    ,updateorgid varchar2(12) -- 更新机构
    ,corporgid varchar2(32) -- 法人机构编号
    ,loanno varchar2(32) -- 关联借据号
    ,customerid varchar2(16) -- 客户编号
    ,termid2 varchar2(18) -- 利率模式
    ,updatedate date -- 更新日期
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,objecttype varchar2(200) -- 关联对象类型
    ,ratefloattype varchar2(18) -- 利率浮动类型
    ,ratefloat2 number(24,8) -- 浮动幅度
    ,paymenttype varchar2(18) -- 还款方式
    ,gaincyc number(22) -- 递变周期
    ,oldrepayaccno varchar2(32) -- 原还款账户
    ,termid varchar2(18) -- 利率模式
    ,businessrate number(15,8) -- 执行利率
    ,putoutaccount varchar2(80) -- 放款账号
    ,payfrequency number(22) -- 指定周期
    ,productid varchar2(32) -- 产品编号
    ,repricetype2 varchar2(18) -- 利率调整方式
    ,accountingorgid varchar2(32) -- 入账机构
    ,baseratetype varchar2(18) -- 基准利率类型
    ,baserate2 number(24,8) -- 基准利率
    ,transcode varchar2(32) -- 交易类型
    ,oldmaturitydate date -- 原贷款到期日
    ,baseratetype2 varchar2(18) -- 基准利率类型
    ,payfrequencytype varchar2(18) -- 还款周期类型
    ,segrptamount number(24,6) -- 尾款金额
    ,transdate date -- 生效日期
    ,remark varchar2(500) -- 备注
    ,relativeserialno varchar2(32) -- 关联流水号
    ,defaultdueday varchar2(6) -- 默认还款日
    ,gainamount number(24,8) -- 递变幅度
    ,transstatus varchar2(6) -- 交易状态
    ,excutedate date -- 交易日期
    ,customername varchar2(200) -- 客户名称
    ,newmaturitydate date -- 新贷款到期日
    ,rateunit varchar2(18) -- 利率单位
    ,ratechangeflag varchar2(18) -- 利率变更标志
    ,ratefloat number(24,8) -- 浮动幅度
    ,inputorgid varchar2(12) -- 登记机构
    ,repricetype varchar2(18) -- 利率调整方式
    ,segterm number(22) -- 指定还款计算期限
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
grant select on ${iol_schema}.icms_afterloan_change to ${iml_schema};
grant select on ${iol_schema}.icms_afterloan_change to ${icl_schema};
grant select on ${iol_schema}.icms_afterloan_change to ${idl_schema};
grant select on ${iol_schema}.icms_afterloan_change to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_afterloan_change is '贷后变更';
comment on column ${iol_schema}.icms_afterloan_change.serialno is '流水号';
comment on column ${iol_schema}.icms_afterloan_change.applystatus is '申请状态';
comment on column ${iol_schema}.icms_afterloan_change.rateunit2 is '利率单位';
comment on column ${iol_schema}.icms_afterloan_change.ratefloattype2 is '利率浮动类型';
comment on column ${iol_schema}.icms_afterloan_change.businessrate2 is '执行利率';
comment on column ${iol_schema}.icms_afterloan_change.paymentaccount is '还款账号';
comment on column ${iol_schema}.icms_afterloan_change.transno is '核心交易号';
comment on column ${iol_schema}.icms_afterloan_change.oldrepaydate is '原还款日';
comment on column ${iol_schema}.icms_afterloan_change.inputdate is '登记日期';
comment on column ${iol_schema}.icms_afterloan_change.updateuserid is '更新人';
comment on column ${iol_schema}.icms_afterloan_change.oldrepaytype is '原还款方式';
comment on column ${iol_schema}.icms_afterloan_change.completeflag is '完成标志';
comment on column ${iol_schema}.icms_afterloan_change.repayaccname is '还款账户名称';
comment on column ${iol_schema}.icms_afterloan_change.belongdept is '所属条线';
comment on column ${iol_schema}.icms_afterloan_change.oldrepayaccname is '原还款账户名称';
comment on column ${iol_schema}.icms_afterloan_change.baserate is '基准利率';
comment on column ${iol_schema}.icms_afterloan_change.inputuserid is '登记人';
comment on column ${iol_schema}.icms_afterloan_change.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_afterloan_change.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_afterloan_change.loanno is '关联借据号';
comment on column ${iol_schema}.icms_afterloan_change.customerid is '客户编号';
comment on column ${iol_schema}.icms_afterloan_change.termid2 is '利率模式';
comment on column ${iol_schema}.icms_afterloan_change.updatedate is '更新日期';
comment on column ${iol_schema}.icms_afterloan_change.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_afterloan_change.objecttype is '关联对象类型';
comment on column ${iol_schema}.icms_afterloan_change.ratefloattype is '利率浮动类型';
comment on column ${iol_schema}.icms_afterloan_change.ratefloat2 is '浮动幅度';
comment on column ${iol_schema}.icms_afterloan_change.paymenttype is '还款方式';
comment on column ${iol_schema}.icms_afterloan_change.gaincyc is '递变周期';
comment on column ${iol_schema}.icms_afterloan_change.oldrepayaccno is '原还款账户';
comment on column ${iol_schema}.icms_afterloan_change.termid is '利率模式';
comment on column ${iol_schema}.icms_afterloan_change.businessrate is '执行利率';
comment on column ${iol_schema}.icms_afterloan_change.putoutaccount is '放款账号';
comment on column ${iol_schema}.icms_afterloan_change.payfrequency is '指定周期';
comment on column ${iol_schema}.icms_afterloan_change.productid is '产品编号';
comment on column ${iol_schema}.icms_afterloan_change.repricetype2 is '利率调整方式';
comment on column ${iol_schema}.icms_afterloan_change.accountingorgid is '入账机构';
comment on column ${iol_schema}.icms_afterloan_change.baseratetype is '基准利率类型';
comment on column ${iol_schema}.icms_afterloan_change.baserate2 is '基准利率';
comment on column ${iol_schema}.icms_afterloan_change.transcode is '交易类型';
comment on column ${iol_schema}.icms_afterloan_change.oldmaturitydate is '原贷款到期日';
comment on column ${iol_schema}.icms_afterloan_change.baseratetype2 is '基准利率类型';
comment on column ${iol_schema}.icms_afterloan_change.payfrequencytype is '还款周期类型';
comment on column ${iol_schema}.icms_afterloan_change.segrptamount is '尾款金额';
comment on column ${iol_schema}.icms_afterloan_change.transdate is '生效日期';
comment on column ${iol_schema}.icms_afterloan_change.remark is '备注';
comment on column ${iol_schema}.icms_afterloan_change.relativeserialno is '关联流水号';
comment on column ${iol_schema}.icms_afterloan_change.defaultdueday is '默认还款日';
comment on column ${iol_schema}.icms_afterloan_change.gainamount is '递变幅度';
comment on column ${iol_schema}.icms_afterloan_change.transstatus is '交易状态';
comment on column ${iol_schema}.icms_afterloan_change.excutedate is '交易日期';
comment on column ${iol_schema}.icms_afterloan_change.customername is '客户名称';
comment on column ${iol_schema}.icms_afterloan_change.newmaturitydate is '新贷款到期日';
comment on column ${iol_schema}.icms_afterloan_change.rateunit is '利率单位';
comment on column ${iol_schema}.icms_afterloan_change.ratechangeflag is '利率变更标志';
comment on column ${iol_schema}.icms_afterloan_change.ratefloat is '浮动幅度';
comment on column ${iol_schema}.icms_afterloan_change.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_afterloan_change.repricetype is '利率调整方式';
comment on column ${iol_schema}.icms_afterloan_change.segterm is '指定还款计算期限';
comment on column ${iol_schema}.icms_afterloan_change.start_dt is '开始时间';
comment on column ${iol_schema}.icms_afterloan_change.end_dt is '结束时间';
comment on column ${iol_schema}.icms_afterloan_change.id_mark is '增删标志';
comment on column ${iol_schema}.icms_afterloan_change.etl_timestamp is 'ETL处理时间戳';
