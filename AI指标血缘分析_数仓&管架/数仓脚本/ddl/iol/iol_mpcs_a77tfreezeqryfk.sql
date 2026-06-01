/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a77tfreezeqryfk
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a77tfreezeqryfk
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a77tfreezeqryfk purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a77tfreezeqryfk(
    docno varchar2(75) -- 协作编号
    ,caseno varchar2(150) -- 案件编号
    ,uniqueid varchar2(60) -- 唯一标识
    ,froseq varchar2(75) -- 冻结流水号
    ,account varchar2(75) -- 账号
    ,currency varchar2(30) -- 币种
    ,exchangetype varchar2(30) -- 汇钞类型
    ,frotype varchar2(15) -- 冻结类型 1 普通冻结 2 轮候冻结 3 续冻
    ,fromode varchar2(15) -- 冻结方式 1 按金额冻结 2 按账号冻结
    ,frobanlance number(17,2) -- 冻结金额
    ,froflag varchar2(5) -- 冻结标志 1已冻结 2未冻结
    ,frobanlance_1 number(17,2) -- 应冻结金额
    ,frobanlance_2 number(17,2) -- 已冻结金额
    ,frobanlance_3 number(17,2) -- 未冻结金额
    ,frobanlance_4 number(17,2) -- 冻结额度
    ,frostartdate varchar2(30) -- 冻结开始时间
    ,froenddate varchar2(30) -- 冻结结束时间
    ,memo varchar2(300) -- 原因
    ,openbr varchar2(15) -- 账户开户行
    ,hostdt varchar2(30) -- 核心交易日期
    ,hostseqno varchar2(30) -- 核心交易流水
    ,dataid varchar2(30) -- 中台交易流水
    ,isdeal varchar2(2) -- 是否已处理 0-未处理 1-已处理
    ,beforefro varchar2(75) -- 在先冻结机关
    ,beforefroban number(17,2) -- 在先冻结金额
    ,beforefrodate varchar2(30) -- 在先冻结到期日
    ,banlance number(17,2) -- 账户余额
    ,canbanlance number(17,2) -- 账户可用余额
    ,cardno varchar2(75) -- 卡号
    ,hzwjdoc varchar2(450) -- 系统自动生成的word回执文件全路径
    ,hzwjpdf varchar2(450) -- pdf回执文件名
    ,filetype varchar2(15) -- 文件格式
    ,docnum varchar2(45) -- 文书文号
    ,xtbz varchar2(6) -- 
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
grant select on ${iol_schema}.mpcs_a77tfreezeqryfk to ${iml_schema};
grant select on ${iol_schema}.mpcs_a77tfreezeqryfk to ${icl_schema};
grant select on ${iol_schema}.mpcs_a77tfreezeqryfk to ${idl_schema};
grant select on ${iol_schema}.mpcs_a77tfreezeqryfk to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a77tfreezeqryfk is '冻结续冻反馈信息表';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.docno is '协作编号';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.caseno is '案件编号';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.uniqueid is '唯一标识';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.froseq is '冻结流水号';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.account is '账号';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.currency is '币种';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.exchangetype is '汇钞类型';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.frotype is '冻结类型 1 普通冻结 2 轮候冻结 3 续冻';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.fromode is '冻结方式 1 按金额冻结 2 按账号冻结';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.frobanlance is '冻结金额';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.froflag is '冻结标志 1已冻结 2未冻结';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.frobanlance_1 is '应冻结金额';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.frobanlance_2 is '已冻结金额';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.frobanlance_3 is '未冻结金额';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.frobanlance_4 is '冻结额度';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.frostartdate is '冻结开始时间';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.froenddate is '冻结结束时间';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.memo is '原因';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.openbr is '账户开户行';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.hostdt is '核心交易日期';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.hostseqno is '核心交易流水';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.dataid is '中台交易流水';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.isdeal is '是否已处理 0-未处理 1-已处理';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.beforefro is '在先冻结机关';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.beforefroban is '在先冻结金额';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.beforefrodate is '在先冻结到期日';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.banlance is '账户余额';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.canbanlance is '账户可用余额';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.cardno is '卡号';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.hzwjdoc is '系统自动生成的word回执文件全路径';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.hzwjpdf is 'pdf回执文件名';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.filetype is '文件格式';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.docnum is '文书文号';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.xtbz is '';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a77tfreezeqryfk.etl_timestamp is 'ETL处理时间戳';
