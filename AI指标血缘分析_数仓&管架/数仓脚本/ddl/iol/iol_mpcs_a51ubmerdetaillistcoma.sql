/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a51ubmerdetaillistcoma
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a51ubmerdetaillistcoma
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a51ubmerdetaillistcoma purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a51ubmerdetaillistcoma(
    acqinstid varchar2(17) -- 受理机构号
    ,fwdinstid varchar2(17) -- 发送机构号
    ,systrace varchar2(9) -- 系统跟踪号
    ,transtime varchar2(18) -- 交易传输时间
    ,transdate varchar2(18) -- 交易日期
    ,priacct varchar2(30) -- 卡号
    ,msgtype varchar2(6) -- 消息类型
    ,procecode varchar2(9) -- 交易处理码
    ,transamt number(14,2) -- 交易金额
    ,handfeeinfo number(14,2) -- 手续费信息
    ,mchnttype varchar2(6) -- 商户类型
    ,retrivarefnum varchar2(18) -- 参考检索号
    ,authridresp varchar2(12) -- 预授权返回码
    ,respcode varchar2(3) -- 交易应答码
    ,acptermnlid varchar2(12) -- 受理终端号
    ,accptrid varchar2(23) -- 受理商户号
    ,currcycode varchar2(5) -- 交易币种
    ,tranflag varchar2(2) -- 借贷标志位 贷记为c，借记为d
    ,merfee number(14,2) -- 商户手续费
    ,tranamt number(15,2) -- 应付金额
    ,recvamt number(15,2) -- 应收金额
    ,stransno varchar2(30) -- 发送机构流水号
    ,stranstag varchar2(15) -- 
    ,remark1 varchar2(30) -- 服务码
    ,remark2 varchar2(75) -- 交易名称
    ,remark3 varchar2(75) -- 商户名字地址
    ,remark4 varchar2(75) -- 批次号
    ,remark5 varchar2(150) -- 
    ,status varchar2(2) -- 状态 0:预登记 1:已处理 2:失败 9:已入批次
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
grant select on ${iol_schema}.mpcs_a51ubmerdetaillistcoma to ${iml_schema};
grant select on ${iol_schema}.mpcs_a51ubmerdetaillistcoma to ${icl_schema};
grant select on ${iol_schema}.mpcs_a51ubmerdetaillistcoma to ${idl_schema};
grant select on ${iol_schema}.mpcs_a51ubmerdetaillistcoma to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a51ubmerdetaillistcoma is '商户入账明细表-COMA';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.acqinstid is '受理机构号';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.fwdinstid is '发送机构号';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.systrace is '系统跟踪号';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.transtime is '交易传输时间';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.transdate is '交易日期';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.priacct is '卡号';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.msgtype is '消息类型';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.procecode is '交易处理码';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.transamt is '交易金额';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.handfeeinfo is '手续费信息';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.mchnttype is '商户类型';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.retrivarefnum is '参考检索号';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.authridresp is '预授权返回码';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.respcode is '交易应答码';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.acptermnlid is '受理终端号';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.accptrid is '受理商户号';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.currcycode is '交易币种';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.tranflag is '借贷标志位 贷记为c，借记为d';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.merfee is '商户手续费';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.tranamt is '应付金额';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.recvamt is '应收金额';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.stransno is '发送机构流水号';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.stranstag is '';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.remark1 is '服务码';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.remark2 is '交易名称';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.remark3 is '商户名字地址';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.remark4 is '批次号';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.remark5 is '';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.status is '状态 0:预登记 1:已处理 2:失败 9:已入批次';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a51ubmerdetaillistcoma.etl_timestamp is 'ETL处理时间戳';
