/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_business_extension
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_business_extension
whenever sqlerror continue none;
drop table ${iol_schema}.icms_business_extension purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_business_extension(
    serialno varchar2(64) -- 信息流水号
    ,occurtime varchar2(10) -- 发生时间
    ,transactionflag varchar2(12) -- 交易标志
    ,voucherno varchar2(64) -- 凭证号码
    ,overduefloat number(6,2) -- 逾期贷款利率浮动比例
    ,extendflag varchar2(2) -- 更新标志
    ,rategenre varchar2(5) -- 利率重定价
    ,occurdate date -- 发生日期
    ,extendtermday number(22) -- 展期期限日
    ,orgid varchar2(64) -- 创建机构
    ,ratefloat number(24,6) -- (Del)浮动利率
    ,lastmaturity date -- 原到期日
    ,putoutno varchar2(32) -- 出帐号
    ,relativeduebillno varchar2(64) -- 关联借据号
    ,extendtermmonth number(22) -- 展期期限月
    ,extendrate number(15,8) -- 展期利率
    ,lastrate number(15,8) -- 原利率
    ,extensionsum number(24,6) -- 展期金额
    ,overduerate number(11,7) -- 逾期贷款执行利率
    ,contractno varchar2(32) -- 展期合同号
    ,extendtermyear number(22) -- 展期期限年
    ,baserate number(24,6) -- (Del)基准利率
    ,lastputoutdate date -- 展期前起始日
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,businessrate number(15,8) -- 利率
    ,userid varchar2(64) -- 操作员
    ,extendputoutdate date -- 受托支付序号
    ,baseratetype varchar2(18) -- (Del)基准利率类型
    ,lastsum number(24,6) -- 展期前金额
    ,extendmaturity date -- 展期后到期日
    ,remark varchar2(2000) -- 备注
    ,rateadjustfrequency varchar2(72) -- 利率调整周期
    ,rateadjusttype varchar2(18) -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
    ,orderno varchar2(50) -- 预约编号
    ,nextsettlementdate varchar2(10) -- 下一结息日
    ,extendeffectdate date -- 展期生效日期
    ,extendrateeffectdate date -- 展期后利率的生效日期
    ,extendrepayplaneffectdate date -- 展期后还款计划生效日期
    ,newrepaytype varchar2(10) -- 新还款方式
    ,finalmerger varchar2(10) -- 是否末期合并：0否，1是
    ,repaydate varchar2(10) -- 按揭还款日
    ,repaycycle varchar2(36) -- 还款周期
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
grant select on ${iol_schema}.icms_business_extension to ${iml_schema};
grant select on ${iol_schema}.icms_business_extension to ${icl_schema};
grant select on ${iol_schema}.icms_business_extension to ${idl_schema};
grant select on ${iol_schema}.icms_business_extension to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_business_extension is '展期信息表展期信息表';
comment on column ${iol_schema}.icms_business_extension.serialno is '信息流水号';
comment on column ${iol_schema}.icms_business_extension.occurtime is '发生时间';
comment on column ${iol_schema}.icms_business_extension.transactionflag is '交易标志';
comment on column ${iol_schema}.icms_business_extension.voucherno is '凭证号码';
comment on column ${iol_schema}.icms_business_extension.overduefloat is '逾期贷款利率浮动比例';
comment on column ${iol_schema}.icms_business_extension.extendflag is '更新标志';
comment on column ${iol_schema}.icms_business_extension.rategenre is '利率重定价';
comment on column ${iol_schema}.icms_business_extension.occurdate is '发生日期';
comment on column ${iol_schema}.icms_business_extension.extendtermday is '展期期限日';
comment on column ${iol_schema}.icms_business_extension.orgid is '创建机构';
comment on column ${iol_schema}.icms_business_extension.ratefloat is '(Del)浮动利率';
comment on column ${iol_schema}.icms_business_extension.lastmaturity is '原到期日';
comment on column ${iol_schema}.icms_business_extension.putoutno is '出帐号';
comment on column ${iol_schema}.icms_business_extension.relativeduebillno is '关联借据号';
comment on column ${iol_schema}.icms_business_extension.extendtermmonth is '展期期限月';
comment on column ${iol_schema}.icms_business_extension.extendrate is '展期利率';
comment on column ${iol_schema}.icms_business_extension.lastrate is '原利率';
comment on column ${iol_schema}.icms_business_extension.extensionsum is '展期金额';
comment on column ${iol_schema}.icms_business_extension.overduerate is '逾期贷款执行利率';
comment on column ${iol_schema}.icms_business_extension.contractno is '展期合同号';
comment on column ${iol_schema}.icms_business_extension.extendtermyear is '展期期限年';
comment on column ${iol_schema}.icms_business_extension.baserate is '(Del)基准利率';
comment on column ${iol_schema}.icms_business_extension.lastputoutdate is '展期前起始日';
comment on column ${iol_schema}.icms_business_extension.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_business_extension.businessrate is '利率';
comment on column ${iol_schema}.icms_business_extension.userid is '操作员';
comment on column ${iol_schema}.icms_business_extension.extendputoutdate is '受托支付序号';
comment on column ${iol_schema}.icms_business_extension.baseratetype is '(Del)基准利率类型';
comment on column ${iol_schema}.icms_business_extension.lastsum is '展期前金额';
comment on column ${iol_schema}.icms_business_extension.extendmaturity is '展期后到期日';
comment on column ${iol_schema}.icms_business_extension.remark is '备注';
comment on column ${iol_schema}.icms_business_extension.rateadjustfrequency is '利率调整周期';
comment on column ${iol_schema}.icms_business_extension.rateadjusttype is '利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)';
comment on column ${iol_schema}.icms_business_extension.orderno is '预约编号';
comment on column ${iol_schema}.icms_business_extension.nextsettlementdate is '下一结息日';
comment on column ${iol_schema}.icms_business_extension.extendeffectdate is '展期生效日期';
comment on column ${iol_schema}.icms_business_extension.extendrateeffectdate is '展期后利率的生效日期';
comment on column ${iol_schema}.icms_business_extension.extendrepayplaneffectdate is '展期后还款计划生效日期';
comment on column ${iol_schema}.icms_business_extension.newrepaytype is '新还款方式';
comment on column ${iol_schema}.icms_business_extension.finalmerger is '是否末期合并：0否，1是';
comment on column ${iol_schema}.icms_business_extension.repaydate is '按揭还款日';
comment on column ${iol_schema}.icms_business_extension.repaycycle is '还款周期';
comment on column ${iol_schema}.icms_business_extension.start_dt is '开始时间';
comment on column ${iol_schema}.icms_business_extension.end_dt is '结束时间';
comment on column ${iol_schema}.icms_business_extension.id_mark is '增删标志';
comment on column ${iol_schema}.icms_business_extension.etl_timestamp is 'ETL处理时间戳';
