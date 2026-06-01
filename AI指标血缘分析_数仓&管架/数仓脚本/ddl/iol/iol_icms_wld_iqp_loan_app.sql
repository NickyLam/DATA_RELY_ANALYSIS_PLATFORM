/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wld_iqp_loan_app
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wld_iqp_loan_app
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wld_iqp_loan_app purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wld_iqp_loan_app(
    serialno varchar2(32) -- 授信流水号
    ,seqno varchar2(48) -- 业务流水号
    ,transcode varchar2(10) -- 交易场景
    ,producttype varchar2(20) -- 产品类型
    ,wldversion varchar2(10) -- 版本号
    ,wldtimestamp varchar2(13) -- 时间戳
    ,bankno varchar2(10) -- 银行号
    ,papporderid varchar2(48) -- 业务订单号
    ,bizscene varchar2(40) -- 业务场景
    ,iscustdataqueryauth varchar2(1) -- 客户是否授权查外部数据源
    ,isneedtdouterdata varchar2(1) -- 是否需要查询外部多头数据
    ,isneedgaouterdata varchar2(1) -- 是否需要查询外部公安数据
    ,isneedhfouterdata varchar2(1) -- 是否需要查询外部法诉数据
    ,isneedyeouterdata varchar2(1) -- 是否需要判断客户在合作行贷款余额超过20w
    ,isneedxxouterdata varchar2(1) -- 是否需要查询外部学位数据
    ,isneedouterlimit varchar2(1) -- 是否加工合作机构可用额度
    ,isneedouterlist varchar2(1) -- 是否需要查询名单信息
    ,idtype varchar2(4) -- 证件类型(不建议)
    ,idno varchar2(30) -- 证件号
    ,certtype varchar2(4) -- 证件类型(建议)
    ,customername varchar2(80) -- 姓名
    ,genderno varchar2(6) -- 性别
    ,nation varchar2(20) -- 国籍
    ,validbegintime varchar2(20) -- 有效起始日
    ,validendtime varchar2(20) -- 有效结束日
    ,profession varchar2(20) -- 职业
    ,address varchar2(500) -- 地址
    ,phone varchar2(20) -- 电话号
    ,ishaslandline varchar2(1) -- 是否有座机
    ,limitpurpose varchar2(12) -- 额度用途
    ,firstchecklimit number(24,6) -- 初审额度
    ,callbackcode varchar2(10) -- 回调接口号
    ,inputuserid varchar2(32) -- 客户经理
    ,inputorgid varchar2(32) -- 所属机构
    ,inputdate varchar2(20) -- 登记时间
    ,customerid varchar2(32) -- 客户号
    ,openflag varchar2(1) -- 开户标识
    ,informflag varchar2(1) -- 通知标识
    ,riskpapporderid varchar2(50) -- 业务订单号(风控)
    ,risktdouterdata varchar2(20) -- 外部多头共债数据(风控)
    ,riskgaouterdata varchar2(20) -- 外部公安数据(风控)
    ,riskhfouterdata varchar2(20) -- 外部法诉数据(风控)
    ,riskyeouterdata varchar2(20) -- 客户在合作行贷款余额超过20w(风控)
    ,riskxxouterdata varchar2(20) -- 外部学位数据(风控)
    ,risknegative varchar2(20) -- 反洗钱名单(风控)
    ,riskrelational varchar2(20) -- 关系人关联人名单(风控)
    ,riskotherrule varchar2(20) -- 其他不准入规则(风控)
    ,riskisoverlimithat varchar2(20) -- 是否到达额度上限(风控)
    ,riskouterlimit varchar2(20) -- 合作机构可用额度(风控)
    ,approvestatus varchar2(20) -- 审批状态
    ,remark varchar2(510) -- 备注
    ,operateorgid varchar2(32) -- 账务机构
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
grant select on ${iol_schema}.icms_wld_iqp_loan_app to ${iml_schema};
grant select on ${iol_schema}.icms_wld_iqp_loan_app to ${icl_schema};
grant select on ${iol_schema}.icms_wld_iqp_loan_app to ${idl_schema};
grant select on ${iol_schema}.icms_wld_iqp_loan_app to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wld_iqp_loan_app is '微粒贷授信表';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.serialno is '授信流水号';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.seqno is '业务流水号';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.transcode is '交易场景';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.producttype is '产品类型';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.wldversion is '版本号';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.wldtimestamp is '时间戳';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.bankno is '银行号';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.papporderid is '业务订单号';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.bizscene is '业务场景';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.iscustdataqueryauth is '客户是否授权查外部数据源';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.isneedtdouterdata is '是否需要查询外部多头数据';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.isneedgaouterdata is '是否需要查询外部公安数据';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.isneedhfouterdata is '是否需要查询外部法诉数据';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.isneedyeouterdata is '是否需要判断客户在合作行贷款余额超过20w';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.isneedxxouterdata is '是否需要查询外部学位数据';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.isneedouterlimit is '是否加工合作机构可用额度';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.isneedouterlist is '是否需要查询名单信息';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.idtype is '证件类型(不建议)';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.idno is '证件号';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.certtype is '证件类型(建议)';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.customername is '姓名';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.genderno is '性别';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.nation is '国籍';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.validbegintime is '有效起始日';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.validendtime is '有效结束日';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.profession is '职业';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.address is '地址';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.phone is '电话号';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.ishaslandline is '是否有座机';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.limitpurpose is '额度用途';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.firstchecklimit is '初审额度';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.callbackcode is '回调接口号';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.inputuserid is '客户经理';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.inputorgid is '所属机构';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.inputdate is '登记时间';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.customerid is '客户号';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.openflag is '开户标识';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.informflag is '通知标识';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.riskpapporderid is '业务订单号(风控)';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.risktdouterdata is '外部多头共债数据(风控)';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.riskgaouterdata is '外部公安数据(风控)';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.riskhfouterdata is '外部法诉数据(风控)';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.riskyeouterdata is '客户在合作行贷款余额超过20w(风控)';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.riskxxouterdata is '外部学位数据(风控)';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.risknegative is '反洗钱名单(风控)';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.riskrelational is '关系人关联人名单(风控)';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.riskotherrule is '其他不准入规则(风控)';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.riskisoverlimithat is '是否到达额度上限(风控)';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.riskouterlimit is '合作机构可用额度(风控)';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.remark is '备注';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.operateorgid is '账务机构';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wld_iqp_loan_app.etl_timestamp is 'ETL处理时间戳';
