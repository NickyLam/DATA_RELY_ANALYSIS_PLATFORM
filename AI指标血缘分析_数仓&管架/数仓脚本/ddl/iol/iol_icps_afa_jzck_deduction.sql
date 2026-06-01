/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icps_afa_jzck_deduction
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icps_afa_jzck_deduction
whenever sqlerror continue none;
drop table ${iol_schema}.icps_afa_jzck_deduction purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icps_afa_jzck_deduction(
    productcode varchar2(20) -- 产品代号
    ,workdate varchar2(20) -- 平台日期
    ,agentserialno varchar2(50) -- 平台流水号
    ,worktime varchar2(20) -- 平台时间
    ,reqbatno varchar2(60) -- 请求批次号
    ,taskid varchar2(200) -- 请求单号
    ,accno varchar2(50) -- 扣划账户
    ,subaccno varchar2(32) -- 扣划子账户
    ,amonut varchar2(20) -- 扣划金额
    ,accnoname varchar2(100) -- 账户户名
    ,idtype varchar2(15) -- 账户证件类型
    ,id varchar2(32) -- 账户证件号码
    ,yyaccno varchar2(50) -- 内部户账号
    ,zxkaccnoname varchar2(100) -- 执行款专户户名
    ,zxkbrnoname varchar2(100) -- 执行款专户开户行
    ,zxkbrnocode varchar2(32) -- 执行款专户开户行号
    ,zxkaccno varchar2(50) -- 执行款专户账号
    ,zxfyname varchar2(100) -- 执行法院名称
    ,zxfycode varchar2(20) -- 执行法院代码
    ,cbfg varchar2(100) -- 承办法官
    ,cbfgtel varchar2(30) -- 承办法官联系电话
    ,cbfggzz varchar2(20) -- 承办法官工作证编号
    ,cbfggwz varchar2(20) -- 承办法官公务证编号
    ,tzs varchar2(50) -- 控制通知书名称
    ,zxah varchar2(50) -- 执行案号
    ,remark1 varchar2(20) -- 是否续冻转解冻
    ,remark2 varchar2(32) -- 备用字段2
    ,remark3 varchar2(50) -- 备用字段3
    ,remark4 varchar2(100) -- 备用字段4
    ,status varchar2(2) -- 业务处理状态
    ,zxkaccnotype varchar2(20) -- 执行款专户账号类型
    ,upddate varchar2(8) -- 更新日期
    ,updtime varchar2(6) -- 更新时间
    ,deducttype varchar2(1) -- 扣划类型
    ,origtaskid varchar2(60) -- 原任务流水号
    ,islock varchar2(1) -- 是否锁定
    ,unfreezedate varchar2(8) -- 解冻核心日期
    ,unfreezeserno varchar2(32) -- 解冻核心流水
    ,unfreezestatus varchar2(1) -- 解冻扣划解冻状态
    ,errorcode varchar2(20) -- 错误码
    ,errormsg varchar2(256) -- 错误描述
    ,busiserno varchar2(40) -- 业务流水号
    ,hostdate varchar2(8) -- 核心日期
    ,hostfreezeserial varchar2(40) -- 核心流水
    ,globalseqno varchar2(40) -- 全局流水号
    ,brno varchar2(10) -- 机构号
    ,tellerno varchar2(10) -- 柜员号
    ,authorizer varchar2(10) -- 授权柜员号
    ,hosttype varchar2(1) -- 账户来源
    ,subchnl varchar2(2) -- 子户来源
    ,iscbs varchar2(2) -- 是否为储蓄账户
    ,decramount varchar2(20) -- 核减金额
    ,accountopenbankcode varchar2(12) -- 执行开户行
    ,chnid varchar2(8) -- 渠道号
    ,busisysdate varchar2(14) -- 请求交日期
    ,origfrozedamount varchar2(20) -- 原剩余冻结金额
    ,accruacctno varchar2(40) -- 利息账户
    ,accruacctname varchar2(200) -- 利息账户户名
    ,deduprcp varchar2(22) -- 扣划本金
    ,deduint varchar2(22) -- 扣划利息
    ,enteraccttype varchar2(10) -- 利息转入账户分类属性
    ,accruaccttype varchar2(10) -- 利息转入账户分类属性
    ,isspecial varchar2(10) -- 特殊扣划标志
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
grant select on ${iol_schema}.icps_afa_jzck_deduction to ${iml_schema};
grant select on ${iol_schema}.icps_afa_jzck_deduction to ${icl_schema};
grant select on ${iol_schema}.icps_afa_jzck_deduction to ${idl_schema};
grant select on ${iol_schema}.icps_afa_jzck_deduction to ${iel_schema};

-- comment
comment on table ${iol_schema}.icps_afa_jzck_deduction is '扣划信息登记表';
comment on column ${iol_schema}.icps_afa_jzck_deduction.productcode is '产品代号';
comment on column ${iol_schema}.icps_afa_jzck_deduction.workdate is '平台日期';
comment on column ${iol_schema}.icps_afa_jzck_deduction.agentserialno is '平台流水号';
comment on column ${iol_schema}.icps_afa_jzck_deduction.worktime is '平台时间';
comment on column ${iol_schema}.icps_afa_jzck_deduction.reqbatno is '请求批次号';
comment on column ${iol_schema}.icps_afa_jzck_deduction.taskid is '请求单号';
comment on column ${iol_schema}.icps_afa_jzck_deduction.accno is '扣划账户';
comment on column ${iol_schema}.icps_afa_jzck_deduction.subaccno is '扣划子账户';
comment on column ${iol_schema}.icps_afa_jzck_deduction.amonut is '扣划金额';
comment on column ${iol_schema}.icps_afa_jzck_deduction.accnoname is '账户户名';
comment on column ${iol_schema}.icps_afa_jzck_deduction.idtype is '账户证件类型';
comment on column ${iol_schema}.icps_afa_jzck_deduction.id is '账户证件号码';
comment on column ${iol_schema}.icps_afa_jzck_deduction.yyaccno is '内部户账号';
comment on column ${iol_schema}.icps_afa_jzck_deduction.zxkaccnoname is '执行款专户户名';
comment on column ${iol_schema}.icps_afa_jzck_deduction.zxkbrnoname is '执行款专户开户行';
comment on column ${iol_schema}.icps_afa_jzck_deduction.zxkbrnocode is '执行款专户开户行号';
comment on column ${iol_schema}.icps_afa_jzck_deduction.zxkaccno is '执行款专户账号';
comment on column ${iol_schema}.icps_afa_jzck_deduction.zxfyname is '执行法院名称';
comment on column ${iol_schema}.icps_afa_jzck_deduction.zxfycode is '执行法院代码';
comment on column ${iol_schema}.icps_afa_jzck_deduction.cbfg is '承办法官';
comment on column ${iol_schema}.icps_afa_jzck_deduction.cbfgtel is '承办法官联系电话';
comment on column ${iol_schema}.icps_afa_jzck_deduction.cbfggzz is '承办法官工作证编号';
comment on column ${iol_schema}.icps_afa_jzck_deduction.cbfggwz is '承办法官公务证编号';
comment on column ${iol_schema}.icps_afa_jzck_deduction.tzs is '控制通知书名称';
comment on column ${iol_schema}.icps_afa_jzck_deduction.zxah is '执行案号';
comment on column ${iol_schema}.icps_afa_jzck_deduction.remark1 is '是否续冻转解冻';
comment on column ${iol_schema}.icps_afa_jzck_deduction.remark2 is '备用字段2';
comment on column ${iol_schema}.icps_afa_jzck_deduction.remark3 is '备用字段3';
comment on column ${iol_schema}.icps_afa_jzck_deduction.remark4 is '备用字段4';
comment on column ${iol_schema}.icps_afa_jzck_deduction.status is '业务处理状态';
comment on column ${iol_schema}.icps_afa_jzck_deduction.zxkaccnotype is '执行款专户账号类型';
comment on column ${iol_schema}.icps_afa_jzck_deduction.upddate is '更新日期';
comment on column ${iol_schema}.icps_afa_jzck_deduction.updtime is '更新时间';
comment on column ${iol_schema}.icps_afa_jzck_deduction.deducttype is '扣划类型';
comment on column ${iol_schema}.icps_afa_jzck_deduction.origtaskid is '原任务流水号';
comment on column ${iol_schema}.icps_afa_jzck_deduction.islock is '是否锁定';
comment on column ${iol_schema}.icps_afa_jzck_deduction.unfreezedate is '解冻核心日期';
comment on column ${iol_schema}.icps_afa_jzck_deduction.unfreezeserno is '解冻核心流水';
comment on column ${iol_schema}.icps_afa_jzck_deduction.unfreezestatus is '解冻扣划解冻状态';
comment on column ${iol_schema}.icps_afa_jzck_deduction.errorcode is '错误码';
comment on column ${iol_schema}.icps_afa_jzck_deduction.errormsg is '错误描述';
comment on column ${iol_schema}.icps_afa_jzck_deduction.busiserno is '业务流水号';
comment on column ${iol_schema}.icps_afa_jzck_deduction.hostdate is '核心日期';
comment on column ${iol_schema}.icps_afa_jzck_deduction.hostfreezeserial is '核心流水';
comment on column ${iol_schema}.icps_afa_jzck_deduction.globalseqno is '全局流水号';
comment on column ${iol_schema}.icps_afa_jzck_deduction.brno is '机构号';
comment on column ${iol_schema}.icps_afa_jzck_deduction.tellerno is '柜员号';
comment on column ${iol_schema}.icps_afa_jzck_deduction.authorizer is '授权柜员号';
comment on column ${iol_schema}.icps_afa_jzck_deduction.hosttype is '账户来源';
comment on column ${iol_schema}.icps_afa_jzck_deduction.subchnl is '子户来源';
comment on column ${iol_schema}.icps_afa_jzck_deduction.iscbs is '是否为储蓄账户';
comment on column ${iol_schema}.icps_afa_jzck_deduction.decramount is '核减金额';
comment on column ${iol_schema}.icps_afa_jzck_deduction.accountopenbankcode is '执行开户行';
comment on column ${iol_schema}.icps_afa_jzck_deduction.chnid is '渠道号';
comment on column ${iol_schema}.icps_afa_jzck_deduction.busisysdate is '请求交日期';
comment on column ${iol_schema}.icps_afa_jzck_deduction.origfrozedamount is '原剩余冻结金额';
comment on column ${iol_schema}.icps_afa_jzck_deduction.accruacctno is '利息账户';
comment on column ${iol_schema}.icps_afa_jzck_deduction.accruacctname is '利息账户户名';
comment on column ${iol_schema}.icps_afa_jzck_deduction.deduprcp is '扣划本金';
comment on column ${iol_schema}.icps_afa_jzck_deduction.deduint is '扣划利息';
comment on column ${iol_schema}.icps_afa_jzck_deduction.enteraccttype is '利息转入账户分类属性';
comment on column ${iol_schema}.icps_afa_jzck_deduction.accruaccttype is '利息转入账户分类属性';
comment on column ${iol_schema}.icps_afa_jzck_deduction.isspecial is '特殊扣划标志';
comment on column ${iol_schema}.icps_afa_jzck_deduction.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icps_afa_jzck_deduction.etl_timestamp is 'ETL处理时间戳';
