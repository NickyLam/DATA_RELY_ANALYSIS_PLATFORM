/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_ib_log_finance_log
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_ib_log_finance_log
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_ib_log_finance_log purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_log_finance_log(
    tx_seq varchar2(33) -- 业务流水号
    ,financestatus varchar2(2) -- 业务登记标识|0-登记 1-关联
    ,trandate date -- 交易日期
    ,trantim date -- 交易时间
    ,trancode varchar2(10) -- 交易码
    ,branchnum varchar2(12) -- 机构号
    ,usernum varchar2(200) -- 柜员号
    ,actflag varchar2(2) -- 是否代理|n-否 1-普通代理 2-监护人代理
    ,servicecontent varchar2(10) -- 服务内容
    ,tranccy varchar2(3) -- 付出币种
    ,tranamt number(20,2) -- 付出金额
    ,drawccy varchar2(3) -- 收入币种
    ,drawamt number(20,2) -- 收入金额
    ,applyname varchar2(200) -- 申请人姓名
    ,applysex varchar2(2) -- 申请人性别
    ,applybirthday date -- 申请人出生日期
    ,applycountry varchar2(255) -- 申请人国籍
    ,applycerttype varchar2(4) -- 申请人证件类型
    ,applycertnum varchar2(60) -- 申请人证件号码
    ,applycertsta varchar2(100) -- 申请人证件开始日期
    ,applycertend varchar2(255) -- 申请人证件结束日期
    ,certbranchnum varchar2(255) -- 发证机关代码
    ,certbranchaddr varchar2(1000) -- 发证机关地区
    ,loc varchar2(1000) -- 工作单位
    ,postcode varchar2(10) -- 邮编
    ,telephone varchar2(100) -- 固定电话
    ,phone varchar2(100) -- 移动电话
    ,actnaem varchar2(200) -- 代理人姓名
    ,actcountry varchar2(255) -- 代理人国籍
    ,actcerttyp varchar2(4) -- 代理人证件类型
    ,actcertnum varchar2(60) -- 代理人证件号码
    ,actcertsta varchar2(100) -- 代理人证件开始日期
    ,actcertend varchar2(255) -- 代理人证件结束日期
    ,acttelephone varchar2(100) -- 代理人固定电话
    ,actphone varchar2(100) -- 代理人移动电话
    ,actreason varchar2(1000) -- 代理原因
    ,careerone varchar2(10) -- 职业一级
    ,careertwo varchar2(10) -- 职业二级
    ,careeronename varchar2(100) -- 职业一级名称
    ,careertwoname varchar2(100) -- 职业二级名称
    ,careerdesc varchar2(600) -- 职业说明
    ,cretaddrflag varchar2(2) -- 居住地是否同证件|1-是 0-否
    ,cretprovincecode varchar2(10) -- 证件省代码
    ,cretcitycode varchar2(10) -- 证件市代码
    ,cretcountycode varchar2(10) -- 证件区代码
    ,cretprovincename varchar2(100) -- 证件省名称
    ,cretcityname varchar2(100) -- 证件市名称
    ,cretcountyname varchar2(100) -- 证件区名称
    ,cretaddresdesc varchar2(1000) -- 证件联系地址
    ,provincecode varchar2(10) -- 常住省代码
    ,citycode varchar2(10) -- 常住市代码
    ,countycode varchar2(10) -- 常住区代码
    ,provincename varchar2(100) -- 常住省名称
    ,cityname varchar2(100) -- 常住市名称
    ,countyname varchar2(100) -- 常住区名称
    ,addresdesc varchar2(1000) -- 常住联系地址
    ,remark1 varchar2(4000) -- 备用1
    ,remark2 varchar2(1000) -- 备用2
    ,remark3 varchar2(500) -- 备用3
    ,remark4 varchar2(500) -- 备用4
    ,remark5 varchar2(500) -- 备用5
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
grant select on ${iol_schema}.nibs_ib_log_finance_log to ${iml_schema};
grant select on ${iol_schema}.nibs_ib_log_finance_log to ${icl_schema};
grant select on ${iol_schema}.nibs_ib_log_finance_log to ${idl_schema};
grant select on ${iol_schema}.nibs_ib_log_finance_log to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_ib_log_finance_log is '一次性金融服务流水表';
comment on column ${iol_schema}.nibs_ib_log_finance_log.tx_seq is '业务流水号';
comment on column ${iol_schema}.nibs_ib_log_finance_log.financestatus is '业务登记标识|0-登记 1-关联';
comment on column ${iol_schema}.nibs_ib_log_finance_log.trandate is '交易日期';
comment on column ${iol_schema}.nibs_ib_log_finance_log.trantim is '交易时间';
comment on column ${iol_schema}.nibs_ib_log_finance_log.trancode is '交易码';
comment on column ${iol_schema}.nibs_ib_log_finance_log.branchnum is '机构号';
comment on column ${iol_schema}.nibs_ib_log_finance_log.usernum is '柜员号';
comment on column ${iol_schema}.nibs_ib_log_finance_log.actflag is '是否代理|n-否 1-普通代理 2-监护人代理';
comment on column ${iol_schema}.nibs_ib_log_finance_log.servicecontent is '服务内容';
comment on column ${iol_schema}.nibs_ib_log_finance_log.tranccy is '付出币种';
comment on column ${iol_schema}.nibs_ib_log_finance_log.tranamt is '付出金额';
comment on column ${iol_schema}.nibs_ib_log_finance_log.drawccy is '收入币种';
comment on column ${iol_schema}.nibs_ib_log_finance_log.drawamt is '收入金额';
comment on column ${iol_schema}.nibs_ib_log_finance_log.applyname is '申请人姓名';
comment on column ${iol_schema}.nibs_ib_log_finance_log.applysex is '申请人性别';
comment on column ${iol_schema}.nibs_ib_log_finance_log.applybirthday is '申请人出生日期';
comment on column ${iol_schema}.nibs_ib_log_finance_log.applycountry is '申请人国籍';
comment on column ${iol_schema}.nibs_ib_log_finance_log.applycerttype is '申请人证件类型';
comment on column ${iol_schema}.nibs_ib_log_finance_log.applycertnum is '申请人证件号码';
comment on column ${iol_schema}.nibs_ib_log_finance_log.applycertsta is '申请人证件开始日期';
comment on column ${iol_schema}.nibs_ib_log_finance_log.applycertend is '申请人证件结束日期';
comment on column ${iol_schema}.nibs_ib_log_finance_log.certbranchnum is '发证机关代码';
comment on column ${iol_schema}.nibs_ib_log_finance_log.certbranchaddr is '发证机关地区';
comment on column ${iol_schema}.nibs_ib_log_finance_log.loc is '工作单位';
comment on column ${iol_schema}.nibs_ib_log_finance_log.postcode is '邮编';
comment on column ${iol_schema}.nibs_ib_log_finance_log.telephone is '固定电话';
comment on column ${iol_schema}.nibs_ib_log_finance_log.phone is '移动电话';
comment on column ${iol_schema}.nibs_ib_log_finance_log.actnaem is '代理人姓名';
comment on column ${iol_schema}.nibs_ib_log_finance_log.actcountry is '代理人国籍';
comment on column ${iol_schema}.nibs_ib_log_finance_log.actcerttyp is '代理人证件类型';
comment on column ${iol_schema}.nibs_ib_log_finance_log.actcertnum is '代理人证件号码';
comment on column ${iol_schema}.nibs_ib_log_finance_log.actcertsta is '代理人证件开始日期';
comment on column ${iol_schema}.nibs_ib_log_finance_log.actcertend is '代理人证件结束日期';
comment on column ${iol_schema}.nibs_ib_log_finance_log.acttelephone is '代理人固定电话';
comment on column ${iol_schema}.nibs_ib_log_finance_log.actphone is '代理人移动电话';
comment on column ${iol_schema}.nibs_ib_log_finance_log.actreason is '代理原因';
comment on column ${iol_schema}.nibs_ib_log_finance_log.careerone is '职业一级';
comment on column ${iol_schema}.nibs_ib_log_finance_log.careertwo is '职业二级';
comment on column ${iol_schema}.nibs_ib_log_finance_log.careeronename is '职业一级名称';
comment on column ${iol_schema}.nibs_ib_log_finance_log.careertwoname is '职业二级名称';
comment on column ${iol_schema}.nibs_ib_log_finance_log.careerdesc is '职业说明';
comment on column ${iol_schema}.nibs_ib_log_finance_log.cretaddrflag is '居住地是否同证件|1-是 0-否';
comment on column ${iol_schema}.nibs_ib_log_finance_log.cretprovincecode is '证件省代码';
comment on column ${iol_schema}.nibs_ib_log_finance_log.cretcitycode is '证件市代码';
comment on column ${iol_schema}.nibs_ib_log_finance_log.cretcountycode is '证件区代码';
comment on column ${iol_schema}.nibs_ib_log_finance_log.cretprovincename is '证件省名称';
comment on column ${iol_schema}.nibs_ib_log_finance_log.cretcityname is '证件市名称';
comment on column ${iol_schema}.nibs_ib_log_finance_log.cretcountyname is '证件区名称';
comment on column ${iol_schema}.nibs_ib_log_finance_log.cretaddresdesc is '证件联系地址';
comment on column ${iol_schema}.nibs_ib_log_finance_log.provincecode is '常住省代码';
comment on column ${iol_schema}.nibs_ib_log_finance_log.citycode is '常住市代码';
comment on column ${iol_schema}.nibs_ib_log_finance_log.countycode is '常住区代码';
comment on column ${iol_schema}.nibs_ib_log_finance_log.provincename is '常住省名称';
comment on column ${iol_schema}.nibs_ib_log_finance_log.cityname is '常住市名称';
comment on column ${iol_schema}.nibs_ib_log_finance_log.countyname is '常住区名称';
comment on column ${iol_schema}.nibs_ib_log_finance_log.addresdesc is '常住联系地址';
comment on column ${iol_schema}.nibs_ib_log_finance_log.remark1 is '备用1';
comment on column ${iol_schema}.nibs_ib_log_finance_log.remark2 is '备用2';
comment on column ${iol_schema}.nibs_ib_log_finance_log.remark3 is '备用3';
comment on column ${iol_schema}.nibs_ib_log_finance_log.remark4 is '备用4';
comment on column ${iol_schema}.nibs_ib_log_finance_log.remark5 is '备用5';
comment on column ${iol_schema}.nibs_ib_log_finance_log.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nibs_ib_log_finance_log.etl_timestamp is 'ETL处理时间戳';
