/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icps_afa_jzck_freandstopdetail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icps_afa_jzck_freandstopdetail
whenever sqlerror continue none;
drop table ${iol_schema}.icps_afa_jzck_freandstopdetail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icps_afa_jzck_freandstopdetail(
    productcode varchar2(8) -- 产品代号详见产品代码数据字典
    ,workdate varchar2(8) -- 平台日期
    ,agentserialno varchar2(20) -- 平台流水号
    ,worktime varchar2(6) -- 平台时间
    ,transserialnumber varchar2(53) -- 传输报文流水号
    ,applicationid varchar2(200) -- 业务申请编号
    ,opttype varchar2(2) -- 措施类型
    ,cardnumber varchar2(50) -- 账号
    ,accountnumber varchar2(50) -- 子账号
    ,accountserial varchar2(50) -- 子账号序号
    ,starttime varchar2(14) -- 开始时间
    ,endtime varchar2(14) -- 截止时间
    ,currency varchar2(10) -- 币种
    ,cashremit varchar2(20) -- 钞汇标志
    ,formerapplicationdepartment varchar2(2000) -- 在先冻结机关
    ,formerfrozenbalance varchar2(20) -- 在先冻结金额
    ,formerfrozenexpiretime varchar2(20) -- 在先冻结到期日
    ,frozedbalance varchar2(20) -- 执行冻结金额
    ,accountbalance varchar2(20) -- 账户余额
    ,accountavaiablebalance varchar2(20) -- 账户可用余额
    ,hostfreezeserial varchar2(40) -- 冻结核心流水号核心冻结成功后反馈
    ,hostdate varchar2(14) -- 冻结核心日期核心冻结成功后反馈
    ,unfrozedbalance varchar2(20) -- 未冻结金额
    ,freezetype varchar2(6) -- 冻结措施 类型0001-公安止付;0002-公安冻结;1001-高法止付;1002-高法冻结；2001-监委止付；2002-监委冻结；
    ,tradestatus varchar2(2) -- 执行结果  0-冻结/止付成功 1-冻结/止付失败 2-解冻/解止付成功
    ,dealmsg varchar2(1000) -- 执行结果原因
    ,remark1 varchar2(32) -- 备用字段1
    ,remark2 varchar2(32) -- 备用字段2
    ,restraint_seq_no varchar2(64) -- 冻结编号
    ,globalseqno varchar2(128) -- 全局流水
    ,upddate varchar2(8) -- 更新日期
    ,updtime varchar2(6) -- 更新时间
    ,brno varchar2(10) -- 执行机构
    ,tellerno varchar2(10) -- 执行柜员
    ,frozedtype varchar2(2) -- 冻结方式 1-部分冻结(金额冻结)；2-无限额冻结(账户冻结)；
    ,unfrozedtype varchar2(2) -- 系统解冻类型 1-普通日终解冻；2-对日对时解冻；
    ,iswait varchar2(1) -- 是否轮候冻结 0-否；1-是；
    ,remark varchar2(400) -- 执行原因
    ,isfrozed varchar2(1) -- 是否已解冻 0-否；1-是；
    ,frozedamount varchar2(20) -- 剩余冻结金额
    ,acctstatus varchar2(1) -- 账户状态 0-未冻结 1-已账户冻结 2-已子户冻结
    ,frozeno varchar2(10) -- 冻结序号
    ,hosttype varchar2(1) -- 核心类型 1-传统核心 2-电子账户 3-微众联合
    ,pre_freeze_amount varchar2(20) -- 申请冻结金额
    ,init_froz_flow varchar2(50) -- 原冻结流水号
    ,init_froz_dt varchar2(20) -- 原冻结日期
    ,init_freeze_due_date varchar2(20) -- 原冻结到期日
    ,init_freeze_amount varchar2(20) -- 原冻结金额
    ,deduct_doc_type varchar2(30) -- 划扣通知书类型
    ,deduct_doc_code varchar2(30) -- 划扣通知书编号
    ,inner_account_no varchar2(60) -- 内部账号
    ,account_name varchar2(160) -- 账号名称
    ,authorizer varchar2(100) -- 授权柜员
    ,exec_org_cd varchar2(200) -- 执行机关
    ,executor varchar2(400) -- 执行人员
    ,certificate_type_one varchar2(30) -- 执行人证件1
    ,certificate_no_one varchar2(100) -- 执行人号码1
    ,certificate_type_two varchar2(10) -- 执行人证件2
    ,certificate_no_two varchar2(100) -- 执行人号码2
    ,customer_no varchar2(30) -- 客户号
    ,law_enforce_type varchar2(10) -- 执法部门类型
    ,law_enforce_name varchar2(200) -- 执法部门名称
    ,prove_type_id varchar2(200) -- 证明类别
    ,prove_no varchar2(200) -- 证明书号
    ,remit_way varchar2(10) -- 解除方式
    ,formerfrozendate varchar2(20) -- 在先冻结日期
    ,formerfrozenserno varchar2(40) -- 在先冻结流水
    ,dealstatus varchar2(20) -- 处理状态 0-未处理； 1-处理中
    ,busiserno varchar2(100) -- 业务流水号
    ,acct_lvl varchar2(10) -- 产品代号
    ,busidate varchar2(8) -- 平台日期
    ,restraint_date varchar2(8) -- 平台流水号
    ,dealdate varchar2(8) -- 处理日期
    ,dealtime varchar2(6) -- 处理时间
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
grant select on ${iol_schema}.icps_afa_jzck_freandstopdetail to ${iml_schema};
grant select on ${iol_schema}.icps_afa_jzck_freandstopdetail to ${icl_schema};
grant select on ${iol_schema}.icps_afa_jzck_freandstopdetail to ${idl_schema};
grant select on ${iol_schema}.icps_afa_jzck_freandstopdetail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icps_afa_jzck_freandstopdetail is '冻结止付明细表';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.productcode is '产品代号详见产品代码数据字典';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.workdate is '平台日期';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.agentserialno is '平台流水号';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.worktime is '平台时间';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.transserialnumber is '传输报文流水号';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.applicationid is '业务申请编号';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.opttype is '措施类型';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.cardnumber is '账号';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.accountnumber is '子账号';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.accountserial is '子账号序号';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.starttime is '开始时间';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.endtime is '截止时间';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.currency is '币种';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.cashremit is '钞汇标志';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.formerapplicationdepartment is '在先冻结机关';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.formerfrozenbalance is '在先冻结金额';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.formerfrozenexpiretime is '在先冻结到期日';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.frozedbalance is '执行冻结金额';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.accountbalance is '账户余额';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.accountavaiablebalance is '账户可用余额';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.hostfreezeserial is '冻结核心流水号核心冻结成功后反馈';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.hostdate is '冻结核心日期核心冻结成功后反馈';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.unfrozedbalance is '未冻结金额';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.freezetype is '冻结措施 类型0001-公安止付;0002-公安冻结;1001-高法止付;1002-高法冻结；2001-监委止付；2002-监委冻结；';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.tradestatus is '执行结果  0-冻结/止付成功 1-冻结/止付失败 2-解冻/解止付成功';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.dealmsg is '执行结果原因';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.remark1 is '备用字段1';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.remark2 is '备用字段2';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.restraint_seq_no is '冻结编号';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.globalseqno is '全局流水';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.upddate is '更新日期';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.updtime is '更新时间';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.brno is '执行机构';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.tellerno is '执行柜员';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.frozedtype is '冻结方式 1-部分冻结(金额冻结)；2-无限额冻结(账户冻结)；';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.unfrozedtype is '系统解冻类型 1-普通日终解冻；2-对日对时解冻；';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.iswait is '是否轮候冻结 0-否；1-是；';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.remark is '执行原因';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.isfrozed is '是否已解冻 0-否；1-是；';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.frozedamount is '剩余冻结金额';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.acctstatus is '账户状态 0-未冻结 1-已账户冻结 2-已子户冻结';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.frozeno is '冻结序号';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.hosttype is '核心类型 1-传统核心 2-电子账户 3-微众联合';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.pre_freeze_amount is '申请冻结金额';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.init_froz_flow is '原冻结流水号';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.init_froz_dt is '原冻结日期';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.init_freeze_due_date is '原冻结到期日';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.init_freeze_amount is '原冻结金额';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.deduct_doc_type is '划扣通知书类型';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.deduct_doc_code is '划扣通知书编号';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.inner_account_no is '内部账号';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.account_name is '账号名称';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.authorizer is '授权柜员';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.exec_org_cd is '执行机关';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.executor is '执行人员';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.certificate_type_one is '执行人证件1';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.certificate_no_one is '执行人号码1';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.certificate_type_two is '执行人证件2';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.certificate_no_two is '执行人号码2';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.customer_no is '客户号';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.law_enforce_type is '执法部门类型';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.law_enforce_name is '执法部门名称';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.prove_type_id is '证明类别';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.prove_no is '证明书号';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.remit_way is '解除方式';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.formerfrozendate is '在先冻结日期';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.formerfrozenserno is '在先冻结流水';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.dealstatus is '处理状态 0-未处理； 1-处理中';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.busiserno is '业务流水号';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.acct_lvl is '产品代号';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.busidate is '平台日期';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.restraint_date is '平台流水号';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.dealdate is '处理日期';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.dealtime is '处理时间';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icps_afa_jzck_freandstopdetail.etl_timestamp is 'ETL处理时间戳';
