/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_renew_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_renew_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_renew_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_renew_info(
    serialno varchar2(64) -- 流水号
    ,duebillserialno varchar2(64) -- 借据编号
    ,objectno varchar2(64) -- 对象编号
    ,objecttype varchar2(64) -- 对象类型
    ,baseratetype varchar2(5) -- 利率类型
    ,maturity date -- 展期终止日期
    ,termmonth number(38,0) -- 展期期限（月）
    ,baserate number(15,8) -- LPR(%)
    ,floatrange number(15,8) -- 展期浮动点差BP
    ,ratefloattype varchar2(36) -- 展期正常利率浮动方式
    ,executerate number(15,8) -- 展期执行利率(%)
    ,overdueratefloattype nvarchar2(36) -- 展期逾期利率浮动方式
    ,overdueratefloatvalue number(22,0) -- 展期逾期利率浮动比例
    ,rateadjusttype varchar2(4) -- 利率调整方式
    ,rateadjustfrequency varchar2(72) -- 利率调整周期
    ,whethertorestructuretheloan varchar2(2) -- 是否重组贷款
    ,completeflag varchar2(2) -- 数据录入完整性
    ,repaytype varchar2(4) -- 还款方式
    ,repaycycle varchar2(36) -- 还款周期
    ,status varchar2(10) -- 处理状态
    ,remark varchar2(4000) -- 处理备注
    ,newrepaytype varchar2(4) -- 还款方式
    ,newrepaycycle varchar2(36) -- 还款周期
    ,balldate date -- 气球摊销日期
    ,bailsum number(24,6) -- 递增金额
    ,pdgpaypercent number(24,6) -- 递增比例
    ,orderno varchar2(50) -- 预约编号
    ,execstatus varchar2(10) -- 执行结果
    ,contractno varchar2(30) -- 展期合同号
    ,oldmaturity date -- 原合同到期日
    ,oldratefloattype varchar2(36) -- 原利率浮动方式
    ,oldrateadjusttype varchar2(72) -- 原利率调整周期
    ,oldfloatrange number(15,8) -- 原贷款浮动点差BP
    ,oldexecuterate number(15,8) -- 原执行年利率
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
grant select on ${iol_schema}.icms_renew_info to ${iml_schema};
grant select on ${iol_schema}.icms_renew_info to ${icl_schema};
grant select on ${iol_schema}.icms_renew_info to ${idl_schema};
grant select on ${iol_schema}.icms_renew_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_renew_info is '展期附属信息表';
comment on column ${iol_schema}.icms_renew_info.serialno is '流水号';
comment on column ${iol_schema}.icms_renew_info.duebillserialno is '借据编号';
comment on column ${iol_schema}.icms_renew_info.objectno is '对象编号';
comment on column ${iol_schema}.icms_renew_info.objecttype is '对象类型';
comment on column ${iol_schema}.icms_renew_info.baseratetype is '利率类型';
comment on column ${iol_schema}.icms_renew_info.maturity is '展期终止日期';
comment on column ${iol_schema}.icms_renew_info.termmonth is '展期期限（月）';
comment on column ${iol_schema}.icms_renew_info.baserate is 'LPR(%)';
comment on column ${iol_schema}.icms_renew_info.floatrange is '展期浮动点差BP';
comment on column ${iol_schema}.icms_renew_info.ratefloattype is '展期正常利率浮动方式';
comment on column ${iol_schema}.icms_renew_info.executerate is '展期执行利率(%)';
comment on column ${iol_schema}.icms_renew_info.overdueratefloattype is '展期逾期利率浮动方式';
comment on column ${iol_schema}.icms_renew_info.overdueratefloatvalue is '展期逾期利率浮动比例';
comment on column ${iol_schema}.icms_renew_info.rateadjusttype is '利率调整方式';
comment on column ${iol_schema}.icms_renew_info.rateadjustfrequency is '利率调整周期';
comment on column ${iol_schema}.icms_renew_info.whethertorestructuretheloan is '是否重组贷款';
comment on column ${iol_schema}.icms_renew_info.completeflag is '数据录入完整性';
comment on column ${iol_schema}.icms_renew_info.repaytype is '还款方式';
comment on column ${iol_schema}.icms_renew_info.repaycycle is '还款周期';
comment on column ${iol_schema}.icms_renew_info.status is '处理状态';
comment on column ${iol_schema}.icms_renew_info.remark is '处理备注';
comment on column ${iol_schema}.icms_renew_info.newrepaytype is '还款方式';
comment on column ${iol_schema}.icms_renew_info.newrepaycycle is '还款周期';
comment on column ${iol_schema}.icms_renew_info.balldate is '气球摊销日期';
comment on column ${iol_schema}.icms_renew_info.bailsum is '递增金额';
comment on column ${iol_schema}.icms_renew_info.pdgpaypercent is '递增比例';
comment on column ${iol_schema}.icms_renew_info.orderno is '预约编号';
comment on column ${iol_schema}.icms_renew_info.execstatus is '执行结果';
comment on column ${iol_schema}.icms_renew_info.contractno is '展期合同号';
comment on column ${iol_schema}.icms_renew_info.oldmaturity is '原合同到期日';
comment on column ${iol_schema}.icms_renew_info.oldratefloattype is '原利率浮动方式';
comment on column ${iol_schema}.icms_renew_info.oldrateadjusttype is '原利率调整周期';
comment on column ${iol_schema}.icms_renew_info.oldfloatrange is '原贷款浮动点差BP';
comment on column ${iol_schema}.icms_renew_info.oldexecuterate is '原执行年利率';
comment on column ${iol_schema}.icms_renew_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_renew_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_renew_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_renew_info.etl_timestamp is 'ETL处理时间戳';
