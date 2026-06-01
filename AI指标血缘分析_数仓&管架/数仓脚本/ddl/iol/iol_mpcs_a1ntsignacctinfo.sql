/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1ntsignacctinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1ntsignacctinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1ntsignacctinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1ntsignacctinfo(
    mainseq varchar2(48) -- 中台流水号
    ,projectcode varchar2(96) -- 工程编码
    ,projectname varchar2(300) -- 工程名称
    ,code varchar2(96) -- 企业id
    ,qybh varchar2(48) -- 企业编码
    ,name varchar2(300) -- 企业名称
    ,fbqycode varchar2(48) -- 发包企业id
    ,fbqyname varchar2(300) -- 发包企业名称
    ,type varchar2(2) -- 企业类型 0-建设单位 1-施工总包企业 5-专业分包企业 6-劳务分包企业
    ,specialaccount varchar2(68) -- 专用账户号
    ,accountname varchar2(300) -- 专用账户户名
    ,bankjointnumber varchar2(45) -- 开户银行联行号
    ,optype varchar2(2) -- 开户类型 1-新开户 2-变更开户
    ,opbalance varchar2(24) -- 余额
    ,ophandler varchar2(30) -- 开户经办人姓名
    ,ophandleridcard varchar2(27) -- 开户经办人身份证号
    ,opcreatime varchar2(21) -- 开户时间
    ,opremarks varchar2(750) -- 开户备注信息
    ,destype varchar2(2) -- 销户类型
    ,balance varchar2(24) -- 结余资金
    ,deshandler varchar2(75) -- 销户经办人姓名
    ,deshandleridcard varchar2(27) -- 销户经办人身份证号
    ,transactionno varchar2(48) -- 销户转账交易号
    ,destaccount varchar2(68) -- 提取账户号
    ,destname varchar2(300) -- 提取账户名称
    ,destorgancode varchar2(45) -- 提取账户机构代码
    ,destbusicode varchar2(45) -- 提取账户营业执照号
    ,descreatime varchar2(21) -- 销户时间
    ,desremarks varchar2(750) -- 销户备注信息
    ,status varchar2(2) -- 账户状态 0-销户 1-开户
    ,sndstatus varchar2(3) -- 上报状态 00-待上报 10-开户上报成功 11-开户上报失败 20-销户上报成功 21-销户上报失败 30-开户修改上报成功 31-开户修改上报失败
    ,updt varchar2(21) -- 更新时间
    ,tlrno varchar2(15) -- 柜员号
    ,brcno varchar2(9) -- 交易机构
    ,oldspecialaccount varchar2(38) -- 原转用账户号
    ,projno varchar2(15) -- 行内项目号
    ,spectp varchar2(8) -- 账户类型    4 基本账户    6 一般账户
    ,glacno varchar2(30) -- 内部账户
    ,glacna varchar2(90) -- 内部账户名称
    ,payacctno varchar2(60) -- 他行基本户
    ,payacctname varchar2(60) -- 他行基本户户名
    ,payacctbank varchar2(45) -- 他行基本户开户行
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
grant select on ${iol_schema}.mpcs_a1ntsignacctinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1ntsignacctinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1ntsignacctinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1ntsignacctinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1ntsignacctinfo is '开户信息表';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.mainseq is '中台流水号';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.projectcode is '工程编码';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.projectname is '工程名称';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.code is '企业id';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.qybh is '企业编码';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.name is '企业名称';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.fbqycode is '发包企业id';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.fbqyname is '发包企业名称';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.type is '企业类型 0-建设单位 1-施工总包企业 5-专业分包企业 6-劳务分包企业';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.specialaccount is '专用账户号';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.accountname is '专用账户户名';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.bankjointnumber is '开户银行联行号';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.optype is '开户类型 1-新开户 2-变更开户';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.opbalance is '余额';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.ophandler is '开户经办人姓名';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.ophandleridcard is '开户经办人身份证号';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.opcreatime is '开户时间';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.opremarks is '开户备注信息';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.destype is '销户类型';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.balance is '结余资金';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.deshandler is '销户经办人姓名';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.deshandleridcard is '销户经办人身份证号';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.transactionno is '销户转账交易号';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.destaccount is '提取账户号';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.destname is '提取账户名称';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.destorgancode is '提取账户机构代码';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.destbusicode is '提取账户营业执照号';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.descreatime is '销户时间';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.desremarks is '销户备注信息';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.status is '账户状态 0-销户 1-开户';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.sndstatus is '上报状态 00-待上报 10-开户上报成功 11-开户上报失败 20-销户上报成功 21-销户上报失败 30-开户修改上报成功 31-开户修改上报失败';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.updt is '更新时间';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.tlrno is '柜员号';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.brcno is '交易机构';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.oldspecialaccount is '原转用账户号';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.projno is '行内项目号';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.spectp is '账户类型    4 基本账户    6 一般账户';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.glacno is '内部账户';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.glacna is '内部账户名称';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.payacctno is '他行基本户';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.payacctname is '他行基本户户名';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.payacctbank is '他行基本户开户行';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a1ntsignacctinfo.etl_timestamp is 'ETL处理时间戳';
