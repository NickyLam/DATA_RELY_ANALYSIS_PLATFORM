/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icps_afa_jzck_accounts
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icps_afa_jzck_accounts
whenever sqlerror continue none;
drop table ${iol_schema}.icps_afa_jzck_accounts purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icps_afa_jzck_accounts(
    productcode varchar2(8) -- 产品代号
    ,workdate varchar2(8) -- 平台日期
    ,agentserialno varchar2(20) -- 平台流水号
    ,worktime varchar2(6) -- 平台时间
    ,txcode varchar2(100) -- 交易类型编码
    ,transserialnumber varchar2(53) -- 请求单号
    ,applicationid varchar2(200) -- 任务流水号
    ,accountname varchar2(200) -- 账户名称
    ,cardnumber varchar2(30) -- 主账户
    ,accountnumber varchar2(50) -- 卡号
    ,depositbankbranch varchar2(200) -- 开户网点
    ,depositbankbranchcode varchar2(20) -- 开户网点代码
    ,accountopentime varchar2(14) -- 开户日期
    ,accountcancellationtime varchar2(14) -- 销户日期
    ,accountcancellationbranch varchar2(100) -- 销户网点
    ,accounttype varchar2(50) -- 账户类型
    ,accountstatus varchar2(30) -- 账户状态
    ,currency varchar2(3) -- 币种
    ,cashremit varchar2(20) -- 钞汇标志
    ,accountbalance varchar2(20) -- 账户余额
    ,availablebalance varchar2(20) -- 可用余额
    ,lasttransactiontime varchar2(24) -- 最后交易时间
    ,remark varchar2(225) -- 备注
    ,remark1 varchar2(16) -- 备用字段1
    ,remark2 varchar2(32) -- 歡用字段2
    ,remark3 varchar2(64) -- 备用字段3
    ,remark4 varchar2(128) -- 备用字段4
    ,accountserial varchar2(50) -- 账户序号
    ,yxq varchar2(8) -- 有效期
    ,glzjzh varchar2(50) -- 关联资金账户
    ,zhrmbye varchar2(20) -- 折合人民币余额
    ,syblrq varchar2(8) -- 银行卡签约时间
    ,qywd varchar2(200) -- 银行卡签约网点
    ,syzzrq varchar2(8) -- 银行卡终止签约时间
    ,zhdj varchar2(20) -- 账号等级
    ,zcwblx varchar2(200) -- 支持外币类型
    ,zhdlip varchar2(50) -- 最后登录ip
    ,zhdlsj varchar2(50) -- 最后登录时间
    ,wyzhmc varchar2(400) -- 网银账户名称
    ,bankname varchar2(100) -- 开户银行
    ,bankcode varchar2(50) -- 开户银行代码
    ,khwdszd varchar2(600) -- 开户网点所在地
    ,openbranchtel varchar2(50) -- 开户网点电话
    ,yzbm varchar2(50) -- 邮政编码
    ,shortname varchar2(50) -- 开户银行英文简称
    ,txdz varchar2(1000) -- 开户人联系地址
    ,lxdh varchar2(50) -- 开户人联系电话
    ,xhwddm varchar2(20) -- 销户网点代码
    ,xhwdszd varchar2(600) -- 销户网点所在地
    ,bksj varchar2(8) -- 补卡时间
    ,bkwd varchar2(100) -- 补卡网点
    ,bkwddm varchar2(20) -- 补卡网点代码
    ,bkwdszd varchar2(600) -- 补卡网点所在地
    ,idtype varchar2(50) -- 证件类型
    ,idno varchar2(100) -- 证件号码
    ,isfro varchar2(10) -- 是否支持网上冻结
    ,sftz varchar2(10) -- 是否透支
    ,datatype varchar2(10) -- 数据类型
    ,cardstatus varchar2(10) -- 卡状态
    ,upddate varchar2(8) -- 更新日期
    ,updtime varchar2(6) -- 更新时间
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
grant select on ${iol_schema}.icps_afa_jzck_accounts to ${iml_schema};
grant select on ${iol_schema}.icps_afa_jzck_accounts to ${icl_schema};
grant select on ${iol_schema}.icps_afa_jzck_accounts to ${idl_schema};
grant select on ${iol_schema}.icps_afa_jzck_accounts to ${iel_schema};

-- comment
comment on table ${iol_schema}.icps_afa_jzck_accounts is '账户信息表';
comment on column ${iol_schema}.icps_afa_jzck_accounts.productcode is '产品代号';
comment on column ${iol_schema}.icps_afa_jzck_accounts.workdate is '平台日期';
comment on column ${iol_schema}.icps_afa_jzck_accounts.agentserialno is '平台流水号';
comment on column ${iol_schema}.icps_afa_jzck_accounts.worktime is '平台时间';
comment on column ${iol_schema}.icps_afa_jzck_accounts.txcode is '交易类型编码';
comment on column ${iol_schema}.icps_afa_jzck_accounts.transserialnumber is '请求单号';
comment on column ${iol_schema}.icps_afa_jzck_accounts.applicationid is '任务流水号';
comment on column ${iol_schema}.icps_afa_jzck_accounts.accountname is '账户名称';
comment on column ${iol_schema}.icps_afa_jzck_accounts.cardnumber is '主账户';
comment on column ${iol_schema}.icps_afa_jzck_accounts.accountnumber is '卡号';
comment on column ${iol_schema}.icps_afa_jzck_accounts.depositbankbranch is '开户网点';
comment on column ${iol_schema}.icps_afa_jzck_accounts.depositbankbranchcode is '开户网点代码';
comment on column ${iol_schema}.icps_afa_jzck_accounts.accountopentime is '开户日期';
comment on column ${iol_schema}.icps_afa_jzck_accounts.accountcancellationtime is '销户日期';
comment on column ${iol_schema}.icps_afa_jzck_accounts.accountcancellationbranch is '销户网点';
comment on column ${iol_schema}.icps_afa_jzck_accounts.accounttype is '账户类型';
comment on column ${iol_schema}.icps_afa_jzck_accounts.accountstatus is '账户状态';
comment on column ${iol_schema}.icps_afa_jzck_accounts.currency is '币种';
comment on column ${iol_schema}.icps_afa_jzck_accounts.cashremit is '钞汇标志';
comment on column ${iol_schema}.icps_afa_jzck_accounts.accountbalance is '账户余额';
comment on column ${iol_schema}.icps_afa_jzck_accounts.availablebalance is '可用余额';
comment on column ${iol_schema}.icps_afa_jzck_accounts.lasttransactiontime is '最后交易时间';
comment on column ${iol_schema}.icps_afa_jzck_accounts.remark is '备注';
comment on column ${iol_schema}.icps_afa_jzck_accounts.remark1 is '备用字段1';
comment on column ${iol_schema}.icps_afa_jzck_accounts.remark2 is '歡用字段2';
comment on column ${iol_schema}.icps_afa_jzck_accounts.remark3 is '备用字段3';
comment on column ${iol_schema}.icps_afa_jzck_accounts.remark4 is '备用字段4';
comment on column ${iol_schema}.icps_afa_jzck_accounts.accountserial is '账户序号';
comment on column ${iol_schema}.icps_afa_jzck_accounts.yxq is '有效期';
comment on column ${iol_schema}.icps_afa_jzck_accounts.glzjzh is '关联资金账户';
comment on column ${iol_schema}.icps_afa_jzck_accounts.zhrmbye is '折合人民币余额';
comment on column ${iol_schema}.icps_afa_jzck_accounts.syblrq is '银行卡签约时间';
comment on column ${iol_schema}.icps_afa_jzck_accounts.qywd is '银行卡签约网点';
comment on column ${iol_schema}.icps_afa_jzck_accounts.syzzrq is '银行卡终止签约时间';
comment on column ${iol_schema}.icps_afa_jzck_accounts.zhdj is '账号等级';
comment on column ${iol_schema}.icps_afa_jzck_accounts.zcwblx is '支持外币类型';
comment on column ${iol_schema}.icps_afa_jzck_accounts.zhdlip is '最后登录ip';
comment on column ${iol_schema}.icps_afa_jzck_accounts.zhdlsj is '最后登录时间';
comment on column ${iol_schema}.icps_afa_jzck_accounts.wyzhmc is '网银账户名称';
comment on column ${iol_schema}.icps_afa_jzck_accounts.bankname is '开户银行';
comment on column ${iol_schema}.icps_afa_jzck_accounts.bankcode is '开户银行代码';
comment on column ${iol_schema}.icps_afa_jzck_accounts.khwdszd is '开户网点所在地';
comment on column ${iol_schema}.icps_afa_jzck_accounts.openbranchtel is '开户网点电话';
comment on column ${iol_schema}.icps_afa_jzck_accounts.yzbm is '邮政编码';
comment on column ${iol_schema}.icps_afa_jzck_accounts.shortname is '开户银行英文简称';
comment on column ${iol_schema}.icps_afa_jzck_accounts.txdz is '开户人联系地址';
comment on column ${iol_schema}.icps_afa_jzck_accounts.lxdh is '开户人联系电话';
comment on column ${iol_schema}.icps_afa_jzck_accounts.xhwddm is '销户网点代码';
comment on column ${iol_schema}.icps_afa_jzck_accounts.xhwdszd is '销户网点所在地';
comment on column ${iol_schema}.icps_afa_jzck_accounts.bksj is '补卡时间';
comment on column ${iol_schema}.icps_afa_jzck_accounts.bkwd is '补卡网点';
comment on column ${iol_schema}.icps_afa_jzck_accounts.bkwddm is '补卡网点代码';
comment on column ${iol_schema}.icps_afa_jzck_accounts.bkwdszd is '补卡网点所在地';
comment on column ${iol_schema}.icps_afa_jzck_accounts.idtype is '证件类型';
comment on column ${iol_schema}.icps_afa_jzck_accounts.idno is '证件号码';
comment on column ${iol_schema}.icps_afa_jzck_accounts.isfro is '是否支持网上冻结';
comment on column ${iol_schema}.icps_afa_jzck_accounts.sftz is '是否透支';
comment on column ${iol_schema}.icps_afa_jzck_accounts.datatype is '数据类型';
comment on column ${iol_schema}.icps_afa_jzck_accounts.cardstatus is '卡状态';
comment on column ${iol_schema}.icps_afa_jzck_accounts.upddate is '更新日期';
comment on column ${iol_schema}.icps_afa_jzck_accounts.updtime is '更新时间';
comment on column ${iol_schema}.icps_afa_jzck_accounts.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icps_afa_jzck_accounts.etl_timestamp is 'ETL处理时间戳';
