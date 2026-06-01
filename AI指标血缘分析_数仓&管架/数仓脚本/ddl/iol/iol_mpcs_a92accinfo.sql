/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a92accinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a92accinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a92accinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a92accinfo(
    trandt varchar2(12) -- 银行交易日期
    ,trantm varchar2(9) -- 银行交易时间
    ,paysys varchar2(48) -- 交易渠道 ym
    ,transeqno varchar2(48) -- 交易流水号
    ,brokercode varchar2(6) -- 商户唯一编号
    ,accountname varchar2(96) -- 姓名
    ,identitytype varchar2(2) -- 证件类型0-身份证
    ,identityno varchar2(30) -- 证件号码
    ,custno varchar2(45) -- 客户号
    ,accountid varchar2(96) -- 盈米财富id
    ,phone varchar2(45) -- 电话号码
    ,mobile varchar2(45) -- 手机号码
    ,zipcd varchar2(15) -- 邮政编码
    ,addr varchar2(768) -- 通讯地址
    ,email varchar2(75) -- 电子邮件
    ,manager varchar2(15) -- 客户经理
    ,isbill varchar2(2) -- 是否寄送账单
    ,billtype varchar2(2) -- 账单寄送方式
    ,riskgrade varchar2(2) -- 风险等级 5-激进型,4-进取型,3-稳健型,2-谨慎型,1-保守型 0-未评级
    ,stat varchar2(2) -- 状态 1-开户 2-销户
    ,upddt varchar2(12) -- 更新日期
    ,updtm varchar2(9) -- 更新时间
    ,reserve1 varchar2(48) -- 预留1
    ,reserve2 varchar2(96) -- 预留2
    ,reserve3 varchar2(192) -- 预留3
    ,reserve4 varchar2(384) -- 预留4
    ,custlevel varchar2(6) -- 投资级别 普通投资者-0；专业投资者-1
    ,infoready varchar2(6) -- 销售适当性信息是否完整 0-不完整;1-完整
    ,levelexpirydate varchar2(18) -- 专业投资者有效期 单位：天
    ,levelbegindate varchar2(18) -- 专业投资者有效期开始日
    ,levelenddate varchar2(18) -- 专业投资者有效期到期日
    ,idenddate varchar2(18) -- 证件到期日
    ,career varchar2(15) -- 职业
    ,nationality varchar2(15) -- 国籍
    ,investorname varchar2(96) -- 实际控制投资者姓名
    ,investoridtype varchar2(6) -- 实际控制投资者证件类型
    ,investoridinfo varchar2(30) -- 实际控制投资者证件号
    ,investoridenddate varchar2(18) -- 实际控制投资者证件到期日
    ,benefyname varchar2(96) -- 投资受益人姓名
    ,benefyidtype varchar2(6) -- 投资受益人证件类型
    ,benefyidinfo varchar2(30) -- 投资受益人证件号
    ,benefyidenddate varchar2(18) -- 投资受益人证件到期日
    ,terminalip varchar2(96) -- 终端ip地址
    ,terminaltype varchar2(15) -- 终端类型
    ,terminalinfo varchar2(900) -- 终端相关信息
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
grant select on ${iol_schema}.mpcs_a92accinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a92accinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a92accinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a92accinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a92accinfo is '账户信息表';
comment on column ${iol_schema}.mpcs_a92accinfo.trandt is '银行交易日期';
comment on column ${iol_schema}.mpcs_a92accinfo.trantm is '银行交易时间';
comment on column ${iol_schema}.mpcs_a92accinfo.paysys is '交易渠道 ym';
comment on column ${iol_schema}.mpcs_a92accinfo.transeqno is '交易流水号';
comment on column ${iol_schema}.mpcs_a92accinfo.brokercode is '商户唯一编号';
comment on column ${iol_schema}.mpcs_a92accinfo.accountname is '姓名';
comment on column ${iol_schema}.mpcs_a92accinfo.identitytype is '证件类型0-身份证';
comment on column ${iol_schema}.mpcs_a92accinfo.identityno is '证件号码';
comment on column ${iol_schema}.mpcs_a92accinfo.custno is '客户号';
comment on column ${iol_schema}.mpcs_a92accinfo.accountid is '盈米财富id';
comment on column ${iol_schema}.mpcs_a92accinfo.phone is '电话号码';
comment on column ${iol_schema}.mpcs_a92accinfo.mobile is '手机号码';
comment on column ${iol_schema}.mpcs_a92accinfo.zipcd is '邮政编码';
comment on column ${iol_schema}.mpcs_a92accinfo.addr is '通讯地址';
comment on column ${iol_schema}.mpcs_a92accinfo.email is '电子邮件';
comment on column ${iol_schema}.mpcs_a92accinfo.manager is '客户经理';
comment on column ${iol_schema}.mpcs_a92accinfo.isbill is '是否寄送账单';
comment on column ${iol_schema}.mpcs_a92accinfo.billtype is '账单寄送方式';
comment on column ${iol_schema}.mpcs_a92accinfo.riskgrade is '风险等级 5-激进型,4-进取型,3-稳健型,2-谨慎型,1-保守型 0-未评级';
comment on column ${iol_schema}.mpcs_a92accinfo.stat is '状态 1-开户 2-销户';
comment on column ${iol_schema}.mpcs_a92accinfo.upddt is '更新日期';
comment on column ${iol_schema}.mpcs_a92accinfo.updtm is '更新时间';
comment on column ${iol_schema}.mpcs_a92accinfo.reserve1 is '预留1';
comment on column ${iol_schema}.mpcs_a92accinfo.reserve2 is '预留2';
comment on column ${iol_schema}.mpcs_a92accinfo.reserve3 is '预留3';
comment on column ${iol_schema}.mpcs_a92accinfo.reserve4 is '预留4';
comment on column ${iol_schema}.mpcs_a92accinfo.custlevel is '投资级别 普通投资者-0；专业投资者-1';
comment on column ${iol_schema}.mpcs_a92accinfo.infoready is '销售适当性信息是否完整 0-不完整;1-完整';
comment on column ${iol_schema}.mpcs_a92accinfo.levelexpirydate is '专业投资者有效期 单位：天';
comment on column ${iol_schema}.mpcs_a92accinfo.levelbegindate is '专业投资者有效期开始日';
comment on column ${iol_schema}.mpcs_a92accinfo.levelenddate is '专业投资者有效期到期日';
comment on column ${iol_schema}.mpcs_a92accinfo.idenddate is '证件到期日';
comment on column ${iol_schema}.mpcs_a92accinfo.career is '职业';
comment on column ${iol_schema}.mpcs_a92accinfo.nationality is '国籍';
comment on column ${iol_schema}.mpcs_a92accinfo.investorname is '实际控制投资者姓名';
comment on column ${iol_schema}.mpcs_a92accinfo.investoridtype is '实际控制投资者证件类型';
comment on column ${iol_schema}.mpcs_a92accinfo.investoridinfo is '实际控制投资者证件号';
comment on column ${iol_schema}.mpcs_a92accinfo.investoridenddate is '实际控制投资者证件到期日';
comment on column ${iol_schema}.mpcs_a92accinfo.benefyname is '投资受益人姓名';
comment on column ${iol_schema}.mpcs_a92accinfo.benefyidtype is '投资受益人证件类型';
comment on column ${iol_schema}.mpcs_a92accinfo.benefyidinfo is '投资受益人证件号';
comment on column ${iol_schema}.mpcs_a92accinfo.benefyidenddate is '投资受益人证件到期日';
comment on column ${iol_schema}.mpcs_a92accinfo.terminalip is '终端ip地址';
comment on column ${iol_schema}.mpcs_a92accinfo.terminaltype is '终端类型';
comment on column ${iol_schema}.mpcs_a92accinfo.terminalinfo is '终端相关信息';
comment on column ${iol_schema}.mpcs_a92accinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a92accinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a92accinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a92accinfo.etl_timestamp is 'ETL处理时间戳';
