/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a60mopj_batch_acct_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a60mopj_batch_acct_detail
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a60mopj_batch_acct_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a60mopj_batch_acct_detail(
    summsq varchar2(15) -- 批扣流水
    ,bachdt varchar2(12) -- 批次日期
    ,bachsq varchar2(12) -- 批次流水
    ,trandt varchar2(12) -- 交易日期
    ,transq varchar2(12) -- 交易流水
    ,filetp varchar2(3) -- 文件属性
    ,prodcd varchar2(12) -- 产品代码
    ,inacct varchar2(30) -- 代理账户
    ,trxamt number(15,2) -- 开户金额
    ,dcmttp varchar2(30) -- 凭证类型
    ,ccynbr varchar2(3) -- 币种
    ,ccyflg varchar2(2) -- 钞汇标志
    ,acctna varchar2(120) -- 客户名
    ,idtftp varchar2(6) -- 证件类型
    ,idtfno varchar2(30) -- 证件号码
    ,savecd varchar2(5) -- 储种
    ,offtel varchar2(30) -- 办公电话
    ,homtel varchar2(30) -- 家庭电话
    ,mobtel varchar2(30) -- 移动电话
    ,areacd varchar2(9) -- 地区代码
    ,posicd varchar2(15) -- 邮编
    ,addres varchar2(300) -- 地址
    ,sex varchar2(2) -- 性别
    ,trxam1 number(15,2) -- 保留金额1
    ,trxam2 number(15,2) -- 保留金额2
    ,trxam3 number(15,2) -- 保留金额3
    ,opt1 varchar2(30) -- 备用1
    ,opt2 varchar2(30) -- 备用2
    ,opt3 varchar2(30) -- 备用3
    ,mmtext varchar2(15) -- 摘要
    ,prttxt varchar2(30) -- 打印摘要
    ,agidtp varchar2(2) -- 代理人证件类型
    ,agidno varchar2(30) -- 代理人证件号
    ,agcuna varchar2(120) -- 代理人名
    ,acctno varchar2(53) -- 账号
    ,rtrxam number(15,2) -- 交易金额
    ,hostsq varchar2(18) -- 主机交易流水号
    ,hostdt varchar2(12) -- 主机交易日期
    ,acctcd varchar2(11) -- 响应码
    ,accmsg varchar2(150) -- 响应信息
    ,rspcod varchar2(11) -- 响应码	cmd9999 失败 | cmd0000成功
    ,rspmsg varchar2(383) -- 响应信息
    ,branch varchar2(9) -- 经办网点
    ,tlrnbr varchar2(12) -- 经办柜员
    ,idtfdt varchar2(12) -- 
    ,isopms varchar2(3) -- 
    ,custno varchar2(23) -- 
    ,cutycd varchar2(5) -- 国籍
    ,ocptid varchar2(30) -- 职业
    ,atchus varchar2(15) -- 客户经理
    ,daylimit number(15,2) -- 日累计限额
    ,txntimeslimit number(10,0) -- 日笔数限额
    ,yearlimit number(15,2) -- 年累计限额
    ,limitsigncd varchar2(18) -- 限额签约返回码
    ,limitsignmsg varchar2(192) -- 限额签约返回信息
    ,openflag varchar2(2) -- 
    ,bipcustno varchar2(23) -- 
    ,errmsg varchar2(1200) -- 
    ,compna varchar2(300) -- 公司名称
    ,fromdate varchar2(24) -- 证件开始日期
    ,ocptdt varchar2(300) -- 其他职业
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
grant select on ${iol_schema}.mpcs_a60mopj_batch_acct_detail to ${iml_schema};
grant select on ${iol_schema}.mpcs_a60mopj_batch_acct_detail to ${icl_schema};
grant select on ${iol_schema}.mpcs_a60mopj_batch_acct_detail to ${idl_schema};
grant select on ${iol_schema}.mpcs_a60mopj_batch_acct_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a60mopj_batch_acct_detail is '批量开卡明细表';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.summsq is '批扣流水';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.bachdt is '批次日期';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.bachsq is '批次流水';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.trandt is '交易日期';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.transq is '交易流水';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.filetp is '文件属性';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.prodcd is '产品代码';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.inacct is '代理账户';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.trxamt is '开户金额';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.dcmttp is '凭证类型';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.ccynbr is '币种';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.ccyflg is '钞汇标志';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.acctna is '客户名';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.idtftp is '证件类型';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.idtfno is '证件号码';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.savecd is '储种';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.offtel is '办公电话';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.homtel is '家庭电话';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.mobtel is '移动电话';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.areacd is '地区代码';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.posicd is '邮编';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.addres is '地址';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.sex is '性别';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.trxam1 is '保留金额1';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.trxam2 is '保留金额2';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.trxam3 is '保留金额3';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.opt1 is '备用1';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.opt2 is '备用2';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.opt3 is '备用3';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.mmtext is '摘要';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.prttxt is '打印摘要';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.agidtp is '代理人证件类型';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.agidno is '代理人证件号';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.agcuna is '代理人名';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.acctno is '账号';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.rtrxam is '交易金额';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.hostsq is '主机交易流水号';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.hostdt is '主机交易日期';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.acctcd is '响应码';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.accmsg is '响应信息';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.rspcod is '响应码	cmd9999 失败 | cmd0000成功';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.rspmsg is '响应信息';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.branch is '经办网点';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.tlrnbr is '经办柜员';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.idtfdt is '';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.isopms is '';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.custno is '';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.cutycd is '国籍';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.ocptid is '职业';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.atchus is '客户经理';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.daylimit is '日累计限额';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.txntimeslimit is '日笔数限额';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.yearlimit is '年累计限额';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.limitsigncd is '限额签约返回码';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.limitsignmsg is '限额签约返回信息';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.openflag is '';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.bipcustno is '';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.errmsg is '';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.compna is '公司名称';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.fromdate is '证件开始日期';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.ocptdt is '其他职业';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a60mopj_batch_acct_detail.etl_timestamp is 'ETL处理时间戳';
